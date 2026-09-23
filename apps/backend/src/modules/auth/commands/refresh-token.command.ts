export class RefreshTokenCommand {
  constructor(
    public readonly refreshToken: string,
    public readonly ip?: string,
  ) {}
}
