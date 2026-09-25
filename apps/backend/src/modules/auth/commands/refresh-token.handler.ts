import { randomUUID } from 'node:crypto';
import { ForbiddenException, Inject, Logger, UnauthorizedException } from '@nestjs/common';
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { ConfigService } from '@nestjs/config';
import { JwtService, JwtSignOptions } from '@nestjs/jwt';
import { and, eq, isNull } from 'drizzle-orm';
import { DATABASE_CONNECTION, Database } from '../../../infrastructure/database/database.module';
import { refreshTokens, users } from '../../../infrastructure/database/schema';
import { hashToken } from '../hash-token';
import { RefreshTokenCommand } from './refresh-token.command';

export interface RefreshTokenResult {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

const REFRESH_TOKEN_EXPIRED = () =>
  new UnauthorizedException({
    type: 'about:blank',
    title: 'Refresh token không hợp lệ hoặc đã hết hạn',
    status: 401,
    detail: 'AUTH_REFRESH_TOKEN_EXPIRED',
  });

const REFRESH_TOKEN_REVOKED = () =>
  new UnauthorizedException({
    type: 'about:blank',
    title: 'Refresh token đã bị thu hồi',
    status: 401,
    detail: 'AUTH_REFRESH_TOKEN_REVOKED',
  });

@CommandHandler(RefreshTokenCommand)
export class RefreshTokenHandler implements ICommandHandler<RefreshTokenCommand, RefreshTokenResult> {
  private readonly logger = new Logger(RefreshTokenHandler.name);

  constructor(
    @Inject(DATABASE_CONNECTION) private readonly db: Database,
    private readonly jwtService: JwtService,
    private readonly config: ConfigService,
  ) {}

  async execute(command: RefreshTokenCommand): Promise<RefreshTokenResult> {
    const refreshSecret = this.config.getOrThrow<string>('JWT_REFRESH_SECRET');

    let sub: string;
    try {
      ({ sub } = await this.jwtService.verifyAsync<{ sub: string }>(command.refreshToken, {
        secret: refreshSecret,
      }));
    } catch {
      throw REFRESH_TOKEN_EXPIRED();
    }

    const presentedHash = hashToken(command.refreshToken);
    const [stored] = await this.db
      .select({
        id: refreshTokens.id,
        userId: refreshTokens.userId,
        revokedAt: refreshTokens.revokedAt,
        expiresAt: refreshTokens.expiresAt,
      })
      .from(refreshTokens)
      .where(eq(refreshTokens.tokenHash, presentedHash))
      .limit(1);

    if (!stored) throw REFRESH_TOKEN_EXPIRED();

    if (stored.revokedAt) {
      // Reuse Attack Detection: token đã bị rotate/revoke trước đó mà vẫn bị dùng lại
      // -> khả năng bị đánh cắp, revoke toàn bộ token family đang active của user này.
      this.logger.warn(
        `Refresh token reuse detected for user ${stored.userId} (tokenId=${stored.id}) — revoking all active refresh tokens.`,
      );
      await this.db
        .update(refreshTokens)
        .set({ revokedAt: new Date() })
        .where(and(eq(refreshTokens.userId, stored.userId), isNull(refreshTokens.revokedAt)));
      throw REFRESH_TOKEN_REVOKED();
    }

    if (stored.expiresAt.getTime() <= Date.now()) throw REFRESH_TOKEN_EXPIRED();

    const [user] = await this.db
      .select({ id: users.id, isActive: users.isActive })
      .from(users)
      .where(and(eq(users.id, sub), eq(users.isDeleted, false)))
      .limit(1);
    if (!user) throw REFRESH_TOKEN_EXPIRED();
    if (!user.isActive) {
      throw new ForbiddenException({
        type: 'about:blank',
        title: 'Tài khoản đã bị vô hiệu hóa',
        status: 403,
        detail: 'AUTH_ACCOUNT_DISABLED',
      });
    }

    const accessSecret = this.config.getOrThrow<string>('JWT_ACCESS_SECRET');
    const accessExpiresIn = this.config.get<string>('JWT_ACCESS_EXPIRES_IN', '15m');
    const refreshExpiresIn = this.config.get<string>('JWT_REFRESH_EXPIRES_IN', '7d');

    const payload = { sub: user.id };
    const newAccessToken = await this.jwtService.signAsync(payload, {
      secret: accessSecret,
      expiresIn: accessExpiresIn as JwtSignOptions['expiresIn'],
    });
    // jti ngẫu nhiên: xem ghi chú trong login.handler.ts — tránh trùng token_hash khi cùng giây.
    const newRefreshToken = await this.jwtService.signAsync(
      { ...payload, jti: randomUUID() },
      {
        secret: refreshSecret,
        expiresIn: refreshExpiresIn as JwtSignOptions['expiresIn'],
      },
    );
    const newTokenHash = hashToken(newRefreshToken);
    const { exp: newRefreshExp } = this.jwtService.decode<{ exp: number }>(newRefreshToken);

    // Rotation: token cũ bị vô hiệu ngay, token mới trỏ ngược lại token cũ để trace family.
    await this.db.transaction(async (tx) => {
      await tx
        .update(refreshTokens)
        .set({ revokedAt: new Date(), replacedByTokenHash: newTokenHash })
        .where(eq(refreshTokens.id, stored.id));
      await tx.insert(refreshTokens).values({
        userId: user.id,
        tokenHash: newTokenHash,
        expiresAt: new Date(newRefreshExp * 1000),
        createdByIp: command.ip ?? null,
      });
    });

    const { exp, iat } = this.jwtService.decode<{ exp: number; iat: number }>(newAccessToken);

    return { accessToken: newAccessToken, refreshToken: newRefreshToken, expiresIn: exp - iat };
  }
}
