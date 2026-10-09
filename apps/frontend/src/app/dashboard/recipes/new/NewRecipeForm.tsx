'use client';

import { AlertTriangle, CheckCircle2, Loader2, Save, Send } from 'lucide-react';
import { useCallback, useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import type { CategoryDto, CreateRecipeRequest, RecipeDetailDto } from '@culinary/shared';
import IngredientsField, { type IngredientFieldValue } from '@/components/IngredientsField';
import StepsField, { type StepFieldValue } from '@/components/StepsField';
import { ApiError } from '@/lib/api';
import { apiAuthed } from '@/lib/auth';

const initialIngredients: IngredientFieldValue[] = [
  { name: '', quantity: undefined, unit: 'g', notes: '', orderIndex: 0 },
];
const initialSteps: StepFieldValue[] = [
  { stepNumber: 1, title: '', description: '', timerMinutes: undefined },
];

export function NewRecipeForm() {
  const router = useRouter();
  const [categories, setCategories] = useState<CategoryDto[]>([]);
  const [isLoadingCategories, setIsLoadingCategories] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [categoryId, setCategoryId] = useState('');
  const [difficulty, setDifficulty] = useState<CreateRecipeRequest['difficulty']>('Easy');
  const [prepTime, setPrepTime] = useState('');
  const [cookTime, setCookTime] = useState('');
  const [servings, setServings] = useState('');
  const [ingredients, setIngredients] = useState(initialIngredients);
  const [steps, setSteps] = useState(initialSteps);

  const loadCategories = useCallback(async () => {
    try {
      setCategories(await apiAuthed<CategoryDto[]>('/categories'));
    } catch (requestError) {
      setError(apiErrorMessage(requestError));
    } finally {
      setIsLoadingCategories(false);
    }
  }, []);

  useEffect(() => {
    void loadCategories();
  }, [loadCategories]);

  async function submit(event: React.FormEvent<HTMLFormElement>, publish: boolean) {
    event.preventDefault();
    setError(null);
    setNotice(null);

    const payload = buildPayload({
      title,
      description,
      categoryId,
      difficulty,
      prepTime,
      cookTime,
      servings,
      ingredients,
      steps,
    });
    if (typeof payload === 'string') {
      setError(payload);
      return;
    }

    setIsSaving(true);
    try {
      const recipe = await apiAuthed<Pick<RecipeDetailDto, 'id' | 'title'>>('/recipes', {
        method: 'POST',
        body: JSON.stringify(payload),
      });
      if (publish) {
        await apiAuthed(`/recipes/${encodeURIComponent(recipe.id)}/publish`, { method: 'PATCH' });
      }
      setNotice(publish ? 'Công thức đã được xuất bản.' : 'Bản nháp đã được lưu.');
      router.push('/recipes');
    } catch (requestError) {
      setError(apiErrorMessage(requestError));
    } finally {
      setIsSaving(false);
    }
  }

  return (
    <div className="mx-auto max-w-5xl px-4 py-12 sm:px-6">
      <header className="flex items-start justify-between gap-4">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary">Studio</p>
          <h1 className="mt-2 font-display text-3xl sm:text-4xl">Tạo công thức</h1>
          <p className="mt-2 text-sm text-muted-foreground">Thêm nguyên liệu và từng bước để lưu công thức dưới dạng bản nháp.</p>
        </div>
        <span className="shrink-0 rounded-full bg-secondary px-3 py-1.5 text-xs font-medium text-secondary-foreground">Bản nháp</span>
      </header>

      {notice && <Notice icon={<CheckCircle2 className="h-4 w-4" aria-hidden />} tone="success">{notice}</Notice>}
      {error && <Notice icon={<AlertTriangle className="h-4 w-4" aria-hidden />} tone="error">{error}</Notice>}

      <form className="mt-8 space-y-8" onSubmit={(event) => void submit(event, false)}>
        <section className="rounded-2xl border border-border bg-card p-6 shadow-card sm:p-8">
          <h2 className="font-display text-xl">Thông tin cơ bản</h2>
          <p className="mt-1 text-sm text-muted-foreground">Món ăn là gì và dành cho ai?</p>
          <div className="mt-6 grid gap-5">
            <Field label="Tên công thức">
              <input className="field" value={title} minLength={5} maxLength={200} required disabled={isSaving} placeholder="Gà nướng harissa" onChange={(event) => setTitle(event.target.value)} />
            </Field>
            <Field label="Mô tả">
              <textarea rows={3} className="field resize-y" value={description} minLength={1} maxLength={2000} required disabled={isSaving} placeholder="Tóm tắt hấp dẫn về món ăn." onChange={(event) => setDescription(event.target.value)} />
            </Field>
            <div className="grid gap-5 sm:grid-cols-2">
              <Field label="Danh mục">
                <select className="field" value={categoryId} required disabled={isSaving || isLoadingCategories} onChange={(event) => setCategoryId(event.target.value)}>
                  <option value="">{isLoadingCategories ? 'Đang tải danh mục…' : 'Chọn danh mục'}</option>
                  {categories.map((category) => <option key={category.id} value={category.id}>{category.name}</option>)}
                </select>
              </Field>
              <Field label="Độ khó">
                <select className="field" value={difficulty} disabled={isSaving} onChange={(event) => setDifficulty(event.target.value as CreateRecipeRequest['difficulty'])}>
                  <option value="Easy">Dễ</option><option value="Medium">Trung bình</option><option value="Hard">Khó</option>
                </select>
              </Field>
            </div>
            <div className="grid gap-5 sm:grid-cols-3">
              <Field label="Chuẩn bị (phút)"><input type="number" min="1" className="field" value={prepTime} required disabled={isSaving} onChange={(event) => setPrepTime(event.target.value)} /></Field>
              <Field label="Nấu (phút)"><input type="number" min="1" className="field" value={cookTime} required disabled={isSaving} onChange={(event) => setCookTime(event.target.value)} /></Field>
              <Field label="Khẩu phần"><input type="number" min="1" className="field" value={servings} required disabled={isSaving} onChange={(event) => setServings(event.target.value)} /></Field>
            </div>
          </div>
        </section>

        <IngredientsField value={ingredients} onChange={setIngredients} disabled={isSaving} />
        <StepsField value={steps} onChange={setSteps} disabled={isSaving} />

        <div className="flex flex-col gap-3 sm:flex-row sm:justify-end">
          <button type="submit" disabled={isSaving} className="inline-flex items-center justify-center gap-2 rounded-full border border-border bg-card px-6 py-3 text-sm font-medium transition-colors hover:bg-secondary disabled:opacity-60">
            {isSaving ? <Loader2 className="h-4 w-4 animate-spin" aria-hidden /> : <Save className="h-4 w-4" aria-hidden />} Lưu bản nháp
          </button>
          <button type="button" disabled={isSaving} onClick={(event) => void submit(event as unknown as React.FormEvent<HTMLFormElement>, true)} className="inline-flex items-center justify-center gap-2 rounded-full bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground transition-opacity hover:opacity-90 disabled:opacity-60">
            <Send className="h-4 w-4" aria-hidden /> Xuất bản
          </button>
        </div>
      </form>
    </div>
  );
}

function buildPayload(input: {
  title: string; description: string; categoryId: string; difficulty: CreateRecipeRequest['difficulty']; prepTime: string; cookTime: string; servings: string; ingredients: IngredientFieldValue[]; steps: StepFieldValue[];
}): CreateRecipeRequest | string {
  const title = input.title.trim();
  const description = input.description.trim();
  const prepTime = Number(input.prepTime);
  const cookTime = Number(input.cookTime);
  const servings = Number(input.servings);
  if (title.length < 5 || title.length > 200) return 'Tên công thức phải từ 5 đến 200 ký tự.';
  if (!description || description.length > 2000) return 'Mô tả công thức không hợp lệ.';
  if (!input.categoryId) return 'Hãy chọn danh mục.';
  if (![prepTime, cookTime, servings].every((value) => Number.isInteger(value) && value > 0)) return 'Thời gian và khẩu phần phải là số nguyên dương.';
  const ingredients = input.ingredients.map((item, index) => ({ ...item, name: item.name.trim(), unit: item.unit.trim(), notes: item.notes.trim(), orderIndex: index }));
  if (ingredients.some((item) => !item.name || item.name.length > 100 || item.quantity === undefined || item.quantity <= 0 || !item.unit || item.unit.length > 50 || item.notes.length > 500)) return 'Mỗi nguyên liệu cần tên, số lượng lớn hơn 0 và đơn vị hợp lệ.';
  const steps = input.steps.map((item, index) => ({ ...item, title: item.title.trim(), description: item.description.trim(), stepNumber: index + 1 }));
  if (steps.some((item) => !item.title || item.title.length > 200 || !item.description || item.description.length > 2000 || (item.timerMinutes !== undefined && (!Number.isInteger(item.timerMinutes) || item.timerMinutes < 0)))) return 'Mỗi bước cần tiêu đề, mô tả và thời gian hợp lệ.';
  return {
    title,
    description,
    categoryId: input.categoryId,
    difficulty: input.difficulty,
    prepTime,
    cookTime,
    servings,
    instructions: steps.map((step) => step.description).join('\n\n'),
    ingredients: ingredients.map(({ notes, name, quantity, unit, orderIndex }) => ({
      name,
      quantity: quantity!,
      unit,
      orderIndex,
      ...(notes ? { notes } : {}),
    })),
    steps,
  };
}

function apiErrorMessage(error: unknown): string {
  if (error instanceof ApiError) {
    if (error.status === 403) return 'Bạn không có quyền tạo công thức này.';
    if (error.status === 422) return 'Dữ liệu chưa hợp lệ. Vui lòng kiểm tra lại biểu mẫu.';
  }
  return error instanceof Error ? error.message : 'Không thể lưu công thức. Vui lòng thử lại.';
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return <label className="block"><span className="mb-1.5 block text-sm font-medium">{label}</span>{children}</label>;
}

function Notice({ children, icon, tone }: { children: React.ReactNode; icon: React.ReactNode; tone: 'success' | 'error' }) {
  return <div role={tone === 'error' ? 'alert' : 'status'} className={`mt-6 flex items-center gap-2 rounded-xl border px-4 py-3 text-sm ${tone === 'success' ? 'border-accent/30 bg-accent-soft text-accent' : 'border-destructive/30 bg-destructive/10 text-destructive'}`}>{icon}{children}</div>;
}
