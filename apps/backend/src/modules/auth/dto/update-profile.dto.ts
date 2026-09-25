import { IsOptional, IsString, IsUrl, MaxLength, MinLength } from 'class-validator';

// SRS 8.1: chỉ 3 field này sửa được qua PATCH /auth/me. Không có email/username ở đây —
// ValidationPipe chạy whitelist nên field lạ bị loại trước khi tới handler.
export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  displayName?: string;

  @IsOptional()
  @IsUrl({ protocols: ['http', 'https'], require_protocol: true })
  @MaxLength(500)
  avatarUrl?: string;

  @IsOptional()
  @IsString()
  @MaxLength(2000)
  bio?: string;
}
