export class UpdateProfileCommand {
  constructor(
    public readonly userId: string,
    public readonly changes: {
      displayName?: string;
      avatarUrl?: string;
      bio?: string;
    },
  ) {}
}
