import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { JwtService, JwtSignOptions } from '@nestjs/jwt';
import { Database } from '../../../infrastructure/database/database.module';
import { refreshTokens } from '../../../infrastructure/database/schema';
import { hashToken } from '../hash-token';

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

/** Phát cặp access/refresh token và lưu hash refresh token vào DB (dùng chung cho login/google). */
export async function issueTokens(
  db: Database,
  jwtService: JwtService,
  config: ConfigService,
  userId: string,
  ip?: string,
): Promise<TokenPair> {
  const payload = { sub: userId };

  const accessToken = await jwtService.signAsync(payload, {
    secret: config.getOrThrow<string>('JWT_ACCESS_SECRET'),
    expiresIn: config.get<string>('JWT_ACCESS_EXPIRES_IN', '15m') as JwtSignOptions['expiresIn'],
  });
  // jti ngẫu nhiên: đảm bảo 2 refresh token issue cùng giây (sub+iat+exp trùng) vẫn là 2 chuỗi
  // JWT khác nhau — token_hash lưu DB có ràng buộc unique nên cần tránh 2 token trùng bytes.
  const refreshToken = await jwtService.signAsync(
    { ...payload, jti: randomUUID() },
    {
      secret: config.getOrThrow<string>('JWT_REFRESH_SECRET'),
      expiresIn: config.get<string>('JWT_REFRESH_EXPIRES_IN', '7d') as JwtSignOptions['expiresIn'],
    },
  );

  const { exp: refreshExp } = jwtService.decode<{ exp: number }>(refreshToken);
  await db.insert(refreshTokens).values({
    userId,
    tokenHash: hashToken(refreshToken),
    expiresAt: new Date(refreshExp * 1000),
    createdByIp: ip ?? null,
  });

  const { exp, iat } = jwtService.decode<{ exp: number; iat: number }>(accessToken);

  return { accessToken, refreshToken, expiresIn: exp - iat };
}
