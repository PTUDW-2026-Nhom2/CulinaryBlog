import { ChefHat } from 'lucide-react';

export function AuthShell({
  title,
  subtitle,
  children,
}: {
  title: string;
  subtitle: string;
  children: React.ReactNode;
}) {
  return (
    <div className="mx-auto flex max-w-md flex-col px-4 py-14 sm:py-20">
      <span className="mx-auto grid h-12 w-12 place-items-center rounded-2xl bg-primary text-primary-foreground">
        <ChefHat className="h-6 w-6" />
      </span>
      <h1 className="mt-6 text-center font-display text-3xl">{title}</h1>
      <p className="mt-2 text-center text-sm text-muted-foreground">{subtitle}</p>
      <div className="mt-8 rounded-2xl border border-border bg-card p-6 shadow-card sm:p-8">{children}</div>
    </div>
  );
}

export function Divider() {
  return (
    <div className="my-6 flex items-center gap-3 text-xs uppercase tracking-widest text-muted-foreground">
      <span className="h-px flex-1 bg-border" />
      hoặc
      <span className="h-px flex-1 bg-border" />
    </div>
  );
}
