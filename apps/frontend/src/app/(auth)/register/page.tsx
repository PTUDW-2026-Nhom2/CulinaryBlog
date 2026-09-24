import type { Metadata } from 'next';
import { RegisterForm } from './register-form';

export const metadata: Metadata = {
  title: 'Tạo tài khoản — Culinary Blog',
  description: 'Tạo tài khoản Culinary Blog để viết, đăng và quản lý công thức của riêng bạn.',
  robots: { index: false },
};

export default function RegisterPage() {
  return <RegisterForm />;
}
