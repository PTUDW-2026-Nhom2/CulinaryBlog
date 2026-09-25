import { Body, Controller, HttpCode, HttpStatus, Ip, Post, UseGuards } from '@nestjs/common';
import { CommandBus } from '@nestjs/cqrs';
import { ApiTags } from '@nestjs/swagger';
import { Throttle, ThrottlerGuard } from '@nestjs/throttler';
import { LoginCommand } from './commands/login.command';
import { LoginResult } from './commands/login.handler';
import { RefreshTokenCommand } from './commands/refresh-token.command';
import { RefreshTokenResult } from './commands/refresh-token.handler';
import { RegisterCommand } from './commands/register.command';
import { RegisterResult } from './commands/register.handler';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RegisterDto } from './dto/register.dto';

@ApiTags('auth')
@Controller('auth')
@UseGuards(ThrottlerGuard)
@Throttle({ default: { limit: 10, ttl: 60_000 } })
export class AuthController {
  constructor(private readonly commandBus: CommandBus) {}

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  register(@Body() dto: RegisterDto): Promise<RegisterResult> {
    return this.commandBus.execute(new RegisterCommand(dto.email, dto.password, dto.displayName));
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  login(@Body() dto: LoginDto, @Ip() ip: string): Promise<LoginResult> {
    return this.commandBus.execute(new LoginCommand(dto.email, dto.password, ip));
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  refresh(@Body() dto: RefreshTokenDto, @Ip() ip: string): Promise<RefreshTokenResult> {
    return this.commandBus.execute(new RefreshTokenCommand(dto.refreshToken, ip));
  }
}
