interface ProgressBarProps {
  value: number;
  max?: number;
  colorClassName?: string;
  trackClassName?: string;
}

export function ProgressBar({
  value,
  max = 100,
  colorClassName = 'bg-primary-500',
  trackClassName = 'bg-surface-border',
}: ProgressBarProps) {
  const percent = Math.min(100, Math.max(0, (value / max) * 100));
  return (
    <div
      className={`h-2 w-full overflow-hidden rounded-full ${trackClassName}`}
      role="progressbar"
      aria-valuenow={value}
      aria-valuemin={0}
      aria-valuemax={max}
    >
      <div
        className={`h-full rounded-full transition-all ${colorClassName}`}
        style={{ width: `${percent}%` }}
      />
    </div>
  );
}
