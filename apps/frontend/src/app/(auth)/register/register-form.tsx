'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { Lock, Mail, User } from 'lucide-react';
import { ApiError } from '@/lib/api-client';
import { useAuth } from '@/lib/auth';
import { AuthShell, Divider } from '@/components/AuthShell';
import { GoogleButton } from '@/components/GoogleButton';

export function RegisterForm() {
  const { register } = useAuth();
  const router = useRouter();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [fieldErrors, setFieldErrors] = useState<Record<string, string[]>>({});
  const [busy, setBusy] = useState(false);

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (name.trim().length < 2 || !email.includes('@') || password.length < 6) {
      setError('Nhập tên, email hợp lệ và mật khẩu từ 6 ký tự.');
      return;
    }
    setError('');
    setFieldErrors({});
    setBusy(true);
    try {
      await register(name.trim(), email.trim(), password);
      router.push('/profile');
    } catch (err) {
      if (err instanceof ApiError) {
        setFieldErrors(err.fieldErrors);
        setError(
          err.code === 'AUTH_EMAIL_EXISTS' ? 'Email này đã được đăng ký.' : err.problem.title,
        );
      } else {
        setError('Không kết nối được máy chủ.');
      }
    } finally {
      setBusy(false);
    }
  };

  const fieldError = (key: string) => fieldErrors[key]?.[0];

  return (
    <AuthShell title="Vào bếp cùng chúng tôi" subtitle="Viết công thức, lưu bản nháp, đăng khi đã sẵn sàng.">
      <form className="space-y-4" onSubmit={submit}>
        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Họ và tên</span>
          <div className="relative">
            <User className="pointer-events-none absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <input
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="field py-3 pl-10"
              placeholder="Nguyễn Văn A"
              autoComplete="name"
            />
          </div>
          {fieldError('displayName') && <p className="mt-1 text-xs text-destructive">{fieldError('displayName')}</p>}
        </label>
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
          {fieldError('email') && <p className="mt-1 text-xs text-destructive">{fieldError('email')}</p>}
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
              placeholder="Ít nhất 6 ký tự"
              autoComplete="new-password"
            />
          </div>
          {fieldError('password') && <p className="mt-1 text-xs text-destructive">{fieldError('password')}</p>}
        </label>

        {error && <p className="text-sm text-destructive">{error}</p>}

        <button
          type="submit"
          disabled={busy}
          className="w-full rounded-full bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground transition-opacity hover:opacity-90 disabled:opacity-60"
        >
          {busy ? 'Đang tạo tài khoản…' : 'Tạo tài khoản'}
        </button>
      </form>

      <Divider />
      <GoogleButton
        label="Đăng ký bằng Google"
        onClick={() => setError('Đăng ký bằng Google chưa khả dụng (đang làm ở #20).')}
      />

      <p className="mt-6 text-center text-sm text-muted-foreground">
        Đã có tài khoản?{' '}
        <Link href="/login" className="font-semibold text-primary">
          Đăng nhập
        </Link>
      </p>
    </AuthShell>
  );
}
