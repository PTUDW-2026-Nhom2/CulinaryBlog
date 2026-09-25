import { createHash } from 'node:crypto';

// Refresh token lưu hash SHA-256 trong DB, không lưu raw token (CLAUDE.md — data model refresh_tokens).
export function hashToken(rawToken: string): string {
  return createHash('sha256').update(rawToken).digest('hex');
}
