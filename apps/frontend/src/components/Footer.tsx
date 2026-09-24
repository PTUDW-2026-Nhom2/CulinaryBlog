import Link from 'next/link';
import { ChefHat, Rss, Send, Mail } from 'lucide-react';

export function Footer() {
  return (
    <footer className="mt-24 border-t border-border bg-surface">
      <div className="mx-auto grid max-w-7xl gap-10 px-4 py-14 sm:px-6 md:grid-cols-[1.4fr_1fr_1fr_1fr]">
        <div className="max-w-sm">
          <div className="flex items-center gap-2.5">
            <span className="grid h-9 w-9 place-items-center rounded-xl bg-primary text-primary-foreground">
              <ChefHat className="h-5 w-5" />
            </span>
            <span className="font-display text-lg font-semibold">Culinary Blog</span>
          </div>
          <p className="mt-4 text-sm leading-relaxed text-muted-foreground">
            Công thức đã được nấu thử, thời gian thật và kỹ thuật đứng sau — viết bởi những người nấu
            đi nấu lại chúng.
          </p>
          <div className="mt-5 flex gap-2">
            {[Rss, Send, Mail].map((Icon, i) => (
              <span
                key={i}
                className="grid h-9 w-9 place-items-center rounded-full border border-border bg-card text-muted-foreground"
              >
                <Icon className="h-4 w-4" />
              </span>
            ))}
          </div>
        </div>

        <FooterCol
          title="Khám phá"
          items={[
            { label: 'Tất cả công thức', to: '/recipes' },
            { label: 'Danh mục', to: '/categories' },
            { label: 'Viết công thức', to: '/dashboard/recipes/new' },
          ]}
        />
        <FooterCol
          title="Gian bếp"
          items={[
            { label: 'Bữa tối ngày thường', to: '/recipes' },
            { label: 'Làm bánh cơ bản', to: '/recipes' },
            { label: 'Món chay', to: '/recipes' },
          ]}
        />
        <FooterCol
          title="Về chúng tôi"
          items={[
            { label: 'Cách chúng tôi thử món', to: '/' },
            { label: 'Người đóng góp', to: '/' },
            { label: 'Liên hệ', to: '/' },
          ]}
        />
      </div>
      <div className="border-t border-border">
        <div className="mx-auto flex max-w-7xl flex-col gap-2 px-4 py-5 text-xs text-muted-foreground sm:flex-row sm:items-center sm:justify-between sm:px-6">
          <p>© {new Date().getFullYear()} Culinary Blog. All rights reserved.</p>
          <p>Nhóm 2 — CTK47A.</p>
        </div>
      </div>
    </footer>
  );
}

function FooterCol({ title, items }: { title: string; items: { label: string; to: string }[] }) {
  return (
    <div>
      <h3 className="font-display text-sm font-semibold uppercase tracking-wider">{title}</h3>
      <ul className="mt-4 space-y-2.5">
        {items.map((i) => (
          <li key={i.label}>
            <Link href={i.to} className="text-sm text-muted-foreground transition-colors hover:text-foreground">
              {i.label}
            </Link>
          </li>
        ))}
      </ul>
    </div>
  );
}
