import type { DailyAccuracy } from '@/types';

interface AccuracyBarChartProps {
  data: DailyAccuracy[];
}

export function AccuracyBarChart({ data }: AccuracyBarChartProps) {
  return (
    <div className="flex items-end justify-between gap-2 px-1">
      {data.map((item) => (
        <div key={item.day} className="flex flex-1 flex-col items-center gap-1.5">
          <span className="text-caption font-bold text-ink-700">{item.accuracy}%</span>
          <div className="flex h-24 w-full items-end overflow-hidden rounded-sm bg-surface-muted">
            <div
              className="w-full rounded-sm bg-accent-blue"
              style={{ height: `${item.accuracy}%` }}
            />
          </div>
          <span className="text-caption text-ink-500">{item.day}</span>
        </div>
      ))}
    </div>
  );
}
