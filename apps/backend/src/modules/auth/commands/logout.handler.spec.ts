import { hashToken } from '../hash-token';
import { LogoutCommand } from './logout.command';
import { LogoutHandler } from './logout.handler';

// Lấy giá trị các bind param trong điều kiện WHERE của drizzle (chỉ đi theo queryChunks để
// tránh vòng lặp column -> table khi duyệt).
const paramValues = (node: unknown, out: string[] = []): string[] => {
  if (Array.isArray(node)) node.forEach((child) => paramValues(child, out));
  else if (node && typeof node === 'object') {
    const { queryChunks, value } = node as { queryChunks?: unknown[]; value?: unknown };
    if (typeof value === 'string') out.push(value);
    if (queryChunks) paramValues(queryChunks, out);
  }
  return out;
};

describe('LogoutHandler', () => {
  const buildDb = () => {
    const where = jest.fn().mockResolvedValue({ rowCount: 1 });
    const set = jest.fn().mockReturnValue({ where });
    return { where, set, update: jest.fn().mockReturnValue({ set }) };
  };

  it('đánh dấu revoked refresh token của chính user', async () => {
    const db = buildDb();

    await new LogoutHandler(db as never).execute(new LogoutCommand('user-1', 'raw-token'));

    expect(db.update).toHaveBeenCalled();
    expect(db.set).toHaveBeenCalledWith({ revokedAt: expect.any(Date) });
    // WHERE phải so bằng hash SHA-256, không bao giờ là raw token.
    const params = paramValues(db.where.mock.calls[0][0]);
    expect(params).toContain(hashToken('raw-token'));
    expect(params).not.toContain('raw-token');
    expect(params).toContain('user-1');
  });

  it('idempotent: token không tồn tại vẫn resolve, không ném lỗi', async () => {
    const db = buildDb();
    db.where.mockResolvedValue({ rowCount: 0 });

    await expect(
      new LogoutHandler(db as never).execute(new LogoutCommand('user-1', 'token-la')),
    ).resolves.toBeUndefined();
  });
});
