import { UnauthorizedException } from '@nestjs/common';
import { GetMeHandler } from './get-me.handler';
import { GetMeQuery } from './get-me.query';

describe('GetMeHandler', () => {
  const buildDb = (rows: unknown[]) => {
    const select = jest.fn().mockReturnValue({
      from: jest.fn().mockReturnValue({
        where: jest.fn().mockReturnValue({ limit: jest.fn().mockResolvedValue(rows) }),
      }),
    });
    return { select };
  };

  it('trả hồ sơ với roles dạng mảng, không có passwordHash', async () => {
    const db = buildDb([
      {
        id: 'user-1',
        email: 'a@b.com',
        displayName: 'Người dùng A',
        avatarUrl: null,
        bio: 'xin chào',
        role: 'Author',
      },
    ]);

    const result = await new GetMeHandler(db as never).execute(new GetMeQuery('user-1'));

    expect(result).toEqual({
      id: 'user-1',
      email: 'a@b.com',
      displayName: 'Người dùng A',
      avatarUrl: null,
      bio: 'xin chào',
      roles: ['Author'],
    });
    // Projection gửi xuống DB không được chứa cột nhạy cảm.
    expect(Object.keys(db.select.mock.calls[0][0])).toEqual([
      'id',
      'email',
      'displayName',
      'avatarUrl',
      'bio',
      'role',
    ]);
  });

  it('ném 401 khi user không còn tồn tại', async () => {
    await expect(
      new GetMeHandler(buildDb([]) as never).execute(new GetMeQuery('user-mat-tich')),
    ).rejects.toBeInstanceOf(UnauthorizedException);
  });
});
