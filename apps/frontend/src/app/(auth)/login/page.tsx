import { Suspense } from 'react';
import type { Metadata } from 'next';
import { LoginForm } from './login-form';

export const metadata: Metadata = {
  title: 'Đăng nhập — Culinary Blog',
  description: 'Đăng nhập để lưu công thức, viết bài của riêng bạn và quản lý sổ tay bếp núc.',
  robots: { index: false },
};

export default function LoginPage() {
  return (
    <Suspense>
      <LoginForm />
    </Suspense>
  );
}
