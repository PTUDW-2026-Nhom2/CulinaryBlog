import Image from 'next/image';
import Link from 'next/link';
import { ArrowRight, Search, Sparkles, Timer } from 'lucide-react';

export default function Home() {
  return (
    <div>
      <section className="relative overflow-hidden border-b border-border bg-surface">
        <div className="mx-auto grid max-w-7xl items-center gap-10 px-4 py-14 sm:px-6 lg:grid-cols-2 lg:py-20">
          <div>
            <span className="inline-flex items-center gap-2 rounded-full bg-accent-soft px-3.5 py-1.5 text-xs font-semibold text-accent">
              <Sparkles className="h-3.5 w-3.5" />
              Mới tuần này: rau củ mùa xuân
            </span>
            <h1 className="mt-5 font-display text-4xl leading-[1.05] sm:text-5xl lg:text-6xl">
              Bữa ngon bắt đầu từ
              <span className="text-primary"> một công thức thật thà.</span>
            </h1>
            <p className="mt-5 max-w-lg text-lg leading-relaxed text-muted-foreground">
              Mọi món ở đây đều được nấu, nấu lại và bấm giờ trong bếp nhà. Không bước mập mờ, không
              thổi phồng thời gian — chỉ cách làm thật sự chạy được.
            </p>

            <form action="/search" role="search"
              className="mt-8 grid gap-2 rounded-2xl border border-border bg-card p-2 shadow-card sm:grid-cols-[minmax(0,1fr)_auto]"
            >
              <div className="relative">
                <Search className="pointer-events-none absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <input
                  type="search"
                  name="q"
                  aria-label="Tìm công thức"
                  placeholder="Tối nay bạn nấu gì?"
                  className="field border-transparent bg-transparent py-3 pl-10"
                />
              </div>
              <button
                type="submit"
                className="rounded-xl bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground transition-opacity hover:opacity-90"
              >
                Tìm công thức
              </button>
            </form>
          </div>

          <div className="relative">
            <Image
              src="/hero-kitchen.jpg"
              alt="Bàn bếp mộc với rau thơm, gia vị, dầu ô liu và rau củ nướng"
              width={1600}
              height={1100}
              priority
              className="aspect-[4/3] w-full rounded-3xl object-cover shadow-lift"
            />
            <div className="absolute bottom-5 left-5 flex items-center gap-3 rounded-2xl border border-border bg-card/95 px-4 py-3 shadow-card backdrop-blur">
              <span className="grid h-10 w-10 place-items-center rounded-full bg-primary-soft text-primary">
                <Timer className="h-5 w-5" />
              </span>
              <div>
                <p className="text-sm font-semibold">Dưới 30 phút</p>
                <p className="text-xs text-muted-foreground">Món nhanh cho ngày thường</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-7xl px-4 py-16 sm:px-6">
        <div className="rounded-3xl bg-ink px-6 py-12 text-center text-ink-foreground sm:px-12">
          <h2 className="font-display text-3xl">Nấu món đáng để ghi lại</h2>
          <p className="mx-auto mt-3 max-w-xl text-sm leading-relaxed opacity-80">
            Có công thức mà bạn bè cứ hỏi mãi? Đăng lên đây kèm thời gian, nguyên liệu và hình ảnh
            đầy đủ.
          </p>
          <Link
            href="/dashboard/recipes/new"
            className="mt-7 inline-flex items-center gap-2 rounded-full bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground transition-opacity hover:opacity-90"
          >
            Viết công thức
            <ArrowRight className="h-4 w-4" />
          </Link>
        </div>
      </section>
    </div>
  );
}
