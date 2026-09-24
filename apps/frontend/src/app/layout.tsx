import type { Metadata } from 'next';
import { DM_Sans, Fraunces } from 'next/font/google';
import { AuthProvider } from '@/lib/auth';
import { Navbar } from '@/components/Navbar';
import { Footer } from '@/components/Footer';
import './globals.css';

const dmSans = DM_Sans({ subsets: ['latin'], variable: '--font-sans' });
const fraunces = Fraunces({ subsets: ['latin'], variable: '--font-display' });

export const metadata: Metadata = {
  title: 'Culinary Blog — Công thức nấu ăn đã được nấu thử',
  description: 'Nền tảng chia sẻ & khám phá công thức nấu ăn: thời gian thật, nguyên liệu rõ, từng bước cụ thể.',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="vi">
      <body className={`${dmSans.variable} ${fraunces.variable} antialiased`}>
        <AuthProvider>
          <div className="flex min-h-screen flex-col">
            <Navbar />
            <main className="flex-1">{children}</main>
            <Footer />
          </div>
        </AuthProvider>
      </body>
    </html>
  );
}
