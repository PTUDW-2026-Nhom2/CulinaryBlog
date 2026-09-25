import { Inject } from '@nestjs/common';
import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { and, eq, isNull } from 'drizzle-orm';
import { DATABASE_CONNECTION, Database } from '../../../infrastructure/database/database.module';
import { refreshTokens } from '../../../infrastructure/database/schema';
import { hashToken } from '../hash-token';
import { LogoutCommand } from './logout.command';

@CommandHandler(LogoutCommand)
export class LogoutHandler implements ICommandHandler<LogoutCommand, void> {
  constructor(@Inject(DATABASE_CONNECTION) private readonly db: Database) {}

  async execute({ userId, refreshToken }: LogoutCommand): Promise<void> {
    // Idempotent (FR-AUTH-005): token không tồn tại, đã revoke, hay của user khác thì cũng 204 —
    // ràng buộc userId để user này không revoke được token của người khác.
    await this.db
      .update(refreshTokens)
      .set({ revokedAt: new Date() })
      .where(
        and(
          eq(refreshTokens.tokenHash, hashToken(refreshToken)),
          eq(refreshTokens.userId, userId),
          isNull(refreshTokens.revokedAt),
        ),
      );
  }
}
