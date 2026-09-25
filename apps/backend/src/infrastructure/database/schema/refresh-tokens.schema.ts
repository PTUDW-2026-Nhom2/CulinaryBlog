import { pgTable, timestamp, uuid, varchar } from 'drizzle-orm/pg-core';
import { baseColumns } from './base.columns';
import { users } from './users.schema';

// FR-AUTH-004: Refresh Token Rotation — lưu hash SHA-256 (không lưu raw token),
// replacedByTokenHash trace token family để phát hiện reuse attack.
export const refreshTokens = pgTable('refresh_tokens', {
  ...baseColumns,
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id, { onDelete: 'cascade' }),
  tokenHash: varchar('token_hash', { length: 64 }).notNull().unique(),
  expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
  revokedAt: timestamp('revoked_at', { withTimezone: true }),
  replacedByTokenHash: varchar('replaced_by_token_hash', { length: 64 }),
  createdByIp: varchar('created_by_ip', { length: 45 }),
});

export type RefreshToken = typeof refreshTokens.$inferSelect;
export type NewRefreshToken = typeof refreshTokens.$inferInsert;
