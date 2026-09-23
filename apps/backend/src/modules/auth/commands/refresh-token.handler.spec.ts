import { UnauthorizedException } from '@nestjs/common';
import { RefreshTokenCommand } from './refresh-token.command';
import { RefreshTokenHandler } from './refresh-token.handler';

describe('RefreshTokenHandler', () => {
  const config = {
    getOrThrow: jest.fn().mockReturnValue('secret'),
    get: jest.fn((_key: string, fallback: string) => fallback),
  };

  const buildJwt = (verifyResult: { sub: string } | Error) => ({
    verifyAsync: jest.fn().mockImplementation(() => {
      if (verifyResult instanceof Error) return Promise.reject(verifyResult);
      return Promise.resolve(verifyResult);
    }),
    signAsync: jest.fn().mockResolvedValue('new-token'),
    decode: jest.fn().mockReturnValue({ exp: Math.floor(Date.now() / 1000) + 900, iat: Math.floor(Date.now() / 1000) }),
  });

  it('ném AUTH_REFRESH_TOKEN_EXPIRED khi JWT verify thất bại', async () => {
    const jwt = buildJwt(new Error('invalid'));
    const handler = new RefreshTokenHandler({} as never, jwt as never, config as never);

    await expect(handler.execute(new RefreshTokenCommand('bad-token'))).rejects.toBeInstanceOf(
      UnauthorizedException,
    );
  });

  it('phát hiện reuse attack và revoke toàn bộ token family khi token đã bị revoke', async () => {
    const jwt = buildJwt({ sub: 'user-1' });
    const where = jest.fn().mockResolvedValue(undefined);
    const db = {
      select: jest.fn().mockReturnValue({
        from: jest.fn().mockReturnValue({
          where: jest.fn().mockReturnValue({
            limit: jest.fn().mockResolvedValue([
              { id: 'rt-1', userId: 'user-1', revokedAt: new Date(), expiresAt: new Date(Date.now() + 100_000) },
            ]),
          }),
        }),
      }),
      update: jest.fn().mockReturnValue({ set: jest.fn().mockReturnValue({ where }) }),
    };
    const handler = new RefreshTokenHandler(db as never, jwt as never, config as never);

    await expect(handler.execute(new RefreshTokenCommand('reused-token'))).rejects.toBeInstanceOf(
      UnauthorizedException,
    );
    expect(db.update).toHaveBeenCalled();
    expect(where).toHaveBeenCalled();
  });

  it('rotate: revoke token cũ và cấp cặp token mới khi refresh token hợp lệ', async () => {
    const jwt = buildJwt({ sub: 'user-1' });
    const txUpdate = jest.fn().mockReturnValue({ set: jest.fn().mockReturnValue({ where: jest.fn().mockResolvedValue(undefined) }) });
    const txInsert = jest.fn().mockReturnValue({ values: jest.fn().mockResolvedValue(undefined) });
    const db = {
      select: jest
        .fn()
        .mockReturnValueOnce({
          from: jest.fn().mockReturnValue({
            where: jest.fn().mockReturnValue({
              limit: jest.fn().mockResolvedValue([
                { id: 'rt-1', userId: 'user-1', revokedAt: null, expiresAt: new Date(Date.now() + 100_000) },
              ]),
            }),
          }),
        })
        .mockReturnValueOnce({
          from: jest.fn().mockReturnValue({
            where: jest.fn().mockReturnValue({
              limit: jest.fn().mockResolvedValue([{ id: 'user-1', isActive: true }]),
            }),
          }),
        }),
      transaction: jest.fn().mockImplementation(async (fn: (tx: unknown) => Promise<void>) => {
        await fn({ update: txUpdate, insert: txInsert });
      }),
    };
    const handler = new RefreshTokenHandler(db as never, jwt as never, config as never);

    const result = await handler.execute(new RefreshTokenCommand('valid-token'));

    expect(result).toEqual({ accessToken: 'new-token', refreshToken: 'new-token', expiresIn: 900 });
    expect(txUpdate).toHaveBeenCalled();
    expect(txInsert).toHaveBeenCalled();
  });
});
