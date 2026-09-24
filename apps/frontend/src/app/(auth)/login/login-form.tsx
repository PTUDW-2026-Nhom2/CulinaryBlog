'use client';

import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { useState } from 'react';
import { Lock, Mail } from 'lucide-react';
import { ApiError } from '@/lib/api-client';
import { useAuth } from '@/lib/auth';
import { AuthShell, Divider } from '@/components/AuthShell';
import { GoogleButton } from '@/components/GoogleButton';

/** AUTH_* code -> thông báo tiếng Việt (SRS phụ lục B). */
const MESSAGES: Record<string, string> = {
  AUTH_INVALID_CREDENTIALS: 'Email hoặc mật khẩu không đúng.',
  AUTH_ACCOUNT_DISABLED: 'Tài khoản đã bị khóa.',
};

export function LoginForm() {
  const { login } = useAuth();
  const router = useRouter();
  const redirect = useSearchParams().get('redirect');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.includes('@') || password.length < 6) {
      setError('Nhập email hợp lệ và mật khẩu từ 6 ký tự.');
      return;
    }
    setError('');
    setBusy(true);
    try {
      await login(email.trim(), password);
      router.push(redirect?.startsWith('/') ? redirect : '/dashboard/recipes');
    } catch (err) {
      if (err instanceof ApiError) {
        setError(
          MESSAGES[err.code ?? ''] ??
            (err.problem.status === 429 ? 'Bạn thử quá nhiều lần, đợi một lát rồi thử lại.' : err.problem.title),
        );
      } else {
        setError('Không kết nối được máy chủ.');
      }
    } finally {
      setBusy(false);
    }
  };

  return (
    <AuthShell title="Chào mừng trở lại" subtitle="Đăng nhập vào gian bếp Culinary Blog của bạn.">
      <form className="space-y-4" onSubmit={submit}>
        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Email</span>
          <div className="relative">
            <Mail className="pointer-events-none absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="field py-3 pl-10"
              placeholder="ban@example.com"
              autoComplete="email"
            />
          </div>
        </label>
        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Mật khẩu</span>
          <div className="relative">
            <Lock className="pointer-events-none absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="field py-3 pl-10"
              placeholder="••••••••"
              autoComplete="current-password"
            />
          </div>
        </label>

        {error && <p className="text-sm text-destructive">{error}</p>}

        <button
          type="submit"
          disabled={busy}
          className="w-full rounded-full bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground transition-opacity hover:opacity-90 disabled:opacity-60"
        >
          {busy ? 'Đang đăng nhập…' : 'Đăng nhập'}
        </button>
      </form>

      <Divider />
      {/* ponytail: chưa gắn Google Identity SDK — chờ FR-AUTH-003 (#20) xong ở backend */}
      <GoogleButton
        label="Đăng nhập bằng Google"
        onClick={() => setError('Đăng nhập Google chưa khả dụng (đang làm ở #20).')}
      />

      <p className="mt-6 text-center text-sm text-muted-foreground">
        Chưa có tài khoản?{' '}
        <Link href="/register" className="font-semibold text-primary">
          Đăng ký ngay
        </Link>
      </p>
    </AuthShell>
  );
}
