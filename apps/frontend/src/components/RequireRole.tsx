'use client';

import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { useEffect, type ReactNode } from 'react';
import { Lock } from 'lucide-react';
import type { UserRole } from '@culinary/shared';
import { useAuth } from '@/lib/auth';

export function RequireRole({ allow, children }: { allow: UserRole[]; children: ReactNode }) {
  const { user, loading } = useAuth();
  const router = useRouter();
  const pathname = usePathname();
  const permitted = !!user && allow.includes(user.role);

  useEffect(() => {
    if (!loading && !user) {
      router.replace(`/login?redirect=${encodeURIComponent(pathname)}`);
    }
  }, [loading, user, router, pathname]);

  if (loading) {
    return <div className="mx-auto max-w-lg px-4 py-24 text-center text-sm text-muted-foreground">Đang tải…</div>;
  }
  if (permitted) return <>{children}</>;

  return (
    <div className="mx-auto max-w-lg px-4 py-24 text-center">
      <span className="mx-auto grid h-12 w-12 place-items-center rounded-full bg-primary-soft text-primary">
        <Lock className="h-6 w-6" />
      </span>
      <h1 className="mt-5 font-display text-2xl">
        {user ? 'Tài khoản của bạn không có quyền vào đây' : 'Vui lòng đăng nhập'}
      </h1>
      <p className="mt-2 text-sm text-muted-foreground">
        {user ? 'Khu vực này chỉ dành cho quản trị viên.' : 'Đang chuyển tới trang đăng nhập…'}
      </p>
      <Link
        href="/recipes"
        className="mt-6 inline-flex rounded-full bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground"
      >
        Xem công thức
      </Link>
    </div>
  );
}
