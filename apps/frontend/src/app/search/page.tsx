import type {
  CategoryDto,
  DifficultyLevel,
  PagedResponse,
  RecipeSearchResultDto,
} from "@culinary/shared";
import { ChevronLeft, ChevronRight, RotateCcw, Search, SlidersHorizontal } from "lucide-react";
import type { Metadata } from "next";
import Link from "next/link";
import { RecipeCard } from "@/components/RecipeCard";
import { apiGet, apiGetPaged } from "@/lib/api";

export const metadata: Metadata = {
  title: "Tìm kiếm công thức",
  description: "Tìm kiếm công thức nấu ăn bằng từ khóa, danh mục, độ khó và thời gian nấu.",
};

const PAGE_SIZE = 12;
const SORT_VALUES = [
  "relevance",
  "-createdAt",
  "createdAt",
  "title",
  "-title",
  "cookTime",
  "-cookTime",
] as const;
const DIFFICULTIES: DifficultyLevel[] = ["Easy", "Medium", "Hard"];

type SortValue = (typeof SORT_VALUES)[number];
type SearchParams = Record<string, string | string[] | undefined>;

interface SearchPageQuery {
  q: string;
  page: number;
  categoryId?: string;
  difficulty?: DifficultyLevel;
  maxCookTime?: number;
  minServings?: number;
  sort: SortValue;
}

interface SearchPageProps {
  searchParams: Promise<SearchParams>;
}

function firstValue(value: string | string[] | undefined): string | undefined {
  return Array.isArray(value) ? value[0] : value;
}

function positiveInteger(value: string | undefined): number | undefined {
  if (!value || !/^\d+$/.test(value)) return undefined;
  const parsed = Number(value);
  return Number.isSafeInteger(parsed) && parsed > 0 ? parsed : undefined;
}

function normalizePage(value: string | undefined): number {
  return positiveInteger(value) ?? 1;
}

function normalizeSort(value: string | undefined): SortValue {
  return SORT_VALUES.includes(value as SortValue) ? (value as SortValue) : "relevance";
}

function normalizeDifficulty(value: string | undefined): DifficultyLevel | undefined {
  return DIFFICULTIES.includes(value as DifficultyLevel)
    ? (value as DifficultyLevel)
    : undefined;
}

function normalizeUuid(value: string | undefined): string | undefined {
  return value && /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(value)
    ? value
    : undefined;
}

function buildSearchHref(query: SearchPageQuery, page?: number): string {
  const params = new URLSearchParams();
  if (query.q) params.set("q", query.q);
  if (page && page > 1) params.set("page", String(page));
  if (query.categoryId) params.set("categoryId", query.categoryId);
  if (query.difficulty) params.set("difficulty", query.difficulty);
  if (query.maxCookTime !== undefined) params.set("maxCookTime", String(query.maxCookTime));
  if (query.minServings !== undefined) params.set("minServings", String(query.minServings));
  if (query.sort !== "relevance") params.set("sort", query.sort);
  const search = params.toString();
  return search ? `/search?${search}` : "/search";
}

function emptyResult(page: number): PagedResponse<RecipeSearchResultDto> {
  return {
    data: [],
    meta: {
      totalCount: 0,
      page,
      pageSize: PAGE_SIZE,
      totalPages: 0,
      hasNextPage: false,
      hasPreviousPage: false,
    },
  };
}

export default async function SearchPage({ searchParams }: SearchPageProps) {
  const params = await searchParams;
  const query: SearchPageQuery = {
    q: firstValue(params.q)?.trim() ?? "",
    page: normalizePage(firstValue(params.page)),
    categoryId: normalizeUuid(firstValue(params.categoryId)),
    difficulty: normalizeDifficulty(firstValue(params.difficulty)),
    maxCookTime: positiveInteger(firstValue(params.maxCookTime)),
    minServings: positiveInteger(firstValue(params.minServings)),
    sort: normalizeSort(firstValue(params.sort)),
  };
  const result = await loadSearch(query);
  const hasActiveFilters = Boolean(
    query.categoryId ||
      query.difficulty ||
      query.maxCookTime !== undefined ||
      query.minServings !== undefined ||
      query.sort !== "relevance",
  );

  return (
    <main className="mx-auto max-w-7xl px-4 py-12 sm:px-6">
      <header className="max-w-2xl">
        <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary">Tìm kiếm</p>
        <h1 className="mt-3 font-display text-4xl sm:text-5xl">Tìm món ăn tiếp theo</h1>
        <p className="mt-4 text-muted-foreground">
          Tìm theo tên hoặc mô tả, sau đó thu hẹp kết quả bằng danh mục, độ khó và thời gian nấu.
        </p>
      </header>

      <form action="/search" className="relative mt-8" role="search">
        <Search className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
        <input
          type="search"
          name="q"
          defaultValue={query.q}
          placeholder="Thử “pho bo”, “súp” hoặc “bánh mì”"
          aria-label="Tìm kiếm công thức"
          className="field py-3.5 pl-11 pr-28"
        />
        <button
          type="submit"
          className="absolute right-2 top-1/2 -translate-y-1/2 rounded-full bg-primary px-5 py-2 text-sm font-semibold text-primary-foreground"
        >
          Tìm kiếm
        </button>
      </form>

      <div className="mt-10 grid gap-8 lg:grid-cols-[260px_minmax(0,1fr)]">
        <SearchFilters query={query} categories={result.categories} />

        <section>
          {query.q.length === 0 ? (
            <SearchPrompt message="Nhập ít nhất hai ký tự để bắt đầu tìm kiếm." />
          ) : query.q.length < 2 ? (
            <SearchPrompt message="Từ khóa cần có ít nhất hai ký tự." />
          ) : result.error ? (
            <SearchError />
          ) : (
            <SearchResults query={query} result={result.recipes} hasActiveFilters={hasActiveFilters} />
          )}
        </section>
      </div>
    </main>
  );
}

async function loadSearch(query: SearchPageQuery) {
  try {
    const categories = await apiGet<CategoryDto[]>("/categories", undefined, { cache: "no-store" });
    if (query.q.length < 2) {
      return { categories, recipes: emptyResult(query.page), error: false };
    }

    try {
      const recipes = await apiGetPaged<RecipeSearchResultDto>(
        "/recipes/search",
        {
          q: query.q,
          page: query.page,
          pageSize: PAGE_SIZE,
          categoryId: query.categoryId,
          difficulty: query.difficulty,
          maxCookTime: query.maxCookTime,
          minServings: query.minServings,
          sort: query.sort,
        },
        { cache: "no-store" },
      );
      return { categories, recipes, error: false };
    } catch {
      return { categories, recipes: emptyResult(query.page), error: true };
    }
  } catch {
    return { categories: [], recipes: emptyResult(query.page), error: true };
  }
}

function SearchFilters({
  query,
  categories,
}: {
  query: SearchPageQuery;
  categories: CategoryDto[];
}) {
  const activeFilters = [
    query.categoryId,
    query.difficulty,
    query.maxCookTime,
    query.minServings,
    query.sort !== "relevance" ? query.sort : undefined,
  ].filter((value) => value !== undefined).length;

  return (
    <aside className="space-y-6 rounded-2xl border border-border bg-card p-6 shadow-card lg:sticky lg:top-24 lg:self-start">
      <div className="flex items-center justify-between">
        <h2 className="flex items-center gap-2 font-display text-lg">
          <SlidersHorizontal className="h-4 w-4 text-primary" />
          Bộ lọc
        </h2>
        {activeFilters > 0 && (
          <Link href={buildSearchHref({ q: query.q, page: 1, sort: "relevance" })} className="text-xs font-semibold text-primary">
            Xóa
          </Link>
        )}
      </div>

      <form action="/search" className="space-y-6">
        <input type="hidden" name="q" value={query.q} />

        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Danh mục</span>
          <select name="categoryId" className="field" defaultValue={query.categoryId ?? ""}>
            <option value="">Tất cả danh mục</option>
            {categories.map((category) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </select>
        </label>

        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Độ khó</span>
          <select name="difficulty" className="field" defaultValue={query.difficulty ?? ""}>
            <option value="">Tất cả độ khó</option>
            <option value="Easy">Dễ</option>
            <option value="Medium">Trung bình</option>
            <option value="Hard">Khó</option>
          </select>
        </label>

        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Thời gian nấu tối đa</span>
          <select name="maxCookTime" className="field" defaultValue={query.maxCookTime?.toString() ?? ""}>
            <option value="">Không giới hạn</option>
            <option value="30">30 phút</option>
            <option value="60">60 phút</option>
            <option value="90">90 phút</option>
            <option value="120">120 phút</option>
            <option value="180">180 phút</option>
          </select>
        </label>

        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Khẩu phần tối thiểu</span>
          <input
            type="number"
            name="minServings"
            min={1}
            max={100}
            defaultValue={query.minServings}
            placeholder="Bất kỳ"
            className="field"
          />
        </label>

        <label className="block">
          <span className="mb-1.5 block text-sm font-medium">Sắp xếp</span>
          <select name="sort" className="field" defaultValue={query.sort}>
            <option value="relevance">Độ liên quan</option>
            <option value="-createdAt">Mới nhất</option>
            <option value="createdAt">Cũ nhất</option>
            <option value="title">Tên A–Z</option>
            <option value="-title">Tên Z–A</option>
            <option value="cookTime">Thời gian nấu tăng dần</option>
            <option value="-cookTime">Thời gian nấu giảm dần</option>
          </select>
        </label>

        <button
          type="submit"
          className="inline-flex min-h-11 w-full items-center justify-center gap-2 rounded-xl bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition-opacity hover:opacity-90"
        >
          <SlidersHorizontal className="h-4 w-4" aria-hidden />
          Áp dụng bộ lọc
        </button>
      </form>
    </aside>
  );
}

function SearchResults({
  query,
  result,
  hasActiveFilters,
}: {
  query: SearchPageQuery;
  result: PagedResponse<RecipeSearchResultDto>;
  hasActiveFilters: boolean;
}) {
  if (result.data.length === 0) {
    return (
      <div className="mt-2 rounded-2xl border border-dashed border-border bg-surface px-6 py-16 text-center">
        <p className="font-display text-xl">Không tìm thấy công thức phù hợp</p>
        <p className="mt-2 text-sm text-muted-foreground">
          Hãy thử từ khóa khác hoặc nới lỏng các bộ lọc.
        </p>
        {hasActiveFilters && (
          <Link
            href={buildSearchHref({ q: query.q, page: 1, sort: "relevance" })}
            className="mt-5 inline-flex items-center gap-2 rounded-full border border-border bg-card px-4 py-2 text-sm font-medium transition-colors hover:border-primary hover:text-primary"
          >
            <RotateCcw className="h-4 w-4" aria-hidden />
            Xóa bộ lọc
          </Link>
        )}
      </div>
    );
  }

  return (
    <>
      <p className="text-sm text-muted-foreground">
        {result.meta.totalCount} công thức cho “{query.q}”
      </p>
      <div className="mt-4 grid gap-6 sm:grid-cols-2 xl:grid-cols-3">
        {result.data.map((recipe) => (
          <RecipeCard key={recipe.id} recipe={recipe} />
        ))}
      </div>
      <SearchPagination query={query} meta={result.meta} />
    </>
  );
}

function SearchPagination({
  query,
  meta,
}: {
  query: SearchPageQuery;
  meta: PagedResponse<RecipeSearchResultDto>["meta"];
}) {
  if (meta.totalPages <= 1) return null;

  const pageCount = Math.min(meta.totalPages, 7);
  const firstPage = Math.min(
    Math.max(meta.page - 3, 1),
    Math.max(meta.totalPages - pageCount + 1, 1),
  );
  const pages = Array.from({ length: pageCount }, (_, index) => firstPage + index);
  return (
    <nav className="mt-10 flex flex-wrap items-center justify-center gap-2" aria-label="Phân trang tìm kiếm">
      {meta.hasPreviousPage ? (
        <Link
          href={buildSearchHref(query, meta.page - 1)}
          className="grid h-10 w-10 place-items-center rounded-full border border-border bg-card"
          aria-label="Trang trước"
        >
          <ChevronLeft className="h-4 w-4" />
        </Link>
      ) : (
        <span className="grid h-10 w-10 place-items-center rounded-full border border-border opacity-40" aria-hidden>
          <ChevronLeft className="h-4 w-4" />
        </span>
      )}

      {pages.map((page) => (
        <Link
          key={page}
          href={buildSearchHref(query, page)}
          aria-current={page === meta.page ? "page" : undefined}
          className={`grid h-10 min-w-10 place-items-center rounded-full px-3 text-sm font-semibold ${
            page === meta.page
              ? "bg-primary text-primary-foreground"
              : "border border-border bg-card text-muted-foreground hover:text-foreground"
          }`}
        >
          {page}
        </Link>
      ))}

      {meta.hasNextPage ? (
        <Link
          href={buildSearchHref(query, meta.page + 1)}
          className="grid h-10 w-10 place-items-center rounded-full border border-border bg-card"
          aria-label="Trang sau"
        >
          <ChevronRight className="h-4 w-4" />
        </Link>
      ) : (
        <span className="grid h-10 w-10 place-items-center rounded-full border border-border opacity-40" aria-hidden>
          <ChevronRight className="h-4 w-4" />
        </span>
      )}
    </nav>
  );
}

function SearchPrompt({ message }: { message: string }) {
  return (
    <div className="mt-2 rounded-2xl border border-dashed border-border bg-surface px-6 py-16 text-center">
      <p className="font-display text-xl">Bắt đầu tìm kiếm công thức</p>
      <p className="mt-2 text-sm text-muted-foreground">{message}</p>
    </div>
  );
}

function SearchError() {
  return (
    <div role="alert" className="mt-2 rounded-2xl border border-destructive/30 bg-card px-6 py-16 text-center">
      <p className="font-display text-xl">Không thể tải kết quả tìm kiếm</p>
      <p className="mt-2 text-sm text-muted-foreground">
        Máy chủ đang bận hoặc kết nối bị gián đoạn. Vui lòng thử lại.
      </p>
    </div>
  );
}
