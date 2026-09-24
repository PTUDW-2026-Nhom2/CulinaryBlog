import type { Metadata } from 'next';
import { RequireRole } from '@/components/RequireRole';
import { ProfileForm } from './profile-form';

export const metadata: Metadata = {
  title: 'Trang cá nhân — Culinary Blog',
  description: 'Xem và cập nhật tên hiển thị, ảnh đại diện và giới thiệu của bạn.',
  robots: { index: false },
};

export default function ProfilePage() {
  return (
    <RequireRole allow={['Author', 'Admin']}>
      <ProfileForm />
    </RequireRole>
  );
}
