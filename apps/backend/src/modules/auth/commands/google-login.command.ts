export class GoogleLoginCommand {
  constructor(
    public readonly idToken: string,
    public readonly ip?: string,
  ) {}
}
