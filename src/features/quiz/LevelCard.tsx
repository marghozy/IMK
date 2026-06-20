import { Card } from '@/components/ui/Card';
import { StarRating } from '@/components/ui/StarRating';
import type { QuizLevel } from '@/types';

interface LevelCardProps {
  level: QuizLevel;
  onClick?: () => void;
}

export function LevelCard({ level, onClick }: LevelCardProps) {
  return (
    <Card onClick={level.locked ? undefined : onClick} locked={level.locked} className="flex items-center gap-3">
      <span className="flex size-12 shrink-0 items-center justify-center rounded-md bg-surface-muted text-xl" aria-hidden>
        {level.locked ? '🔒' : level.icon}
      </span>
      <div className="min-w-0 flex-1">
        <p className="text-body font-bold text-ink-900">{level.title}</p>
        <p className="truncate text-caption text-ink-500">{level.description}</p>
      </div>
      <div className="flex flex-col items-end gap-1">
        <StarRating value={level.starRating} />
        <span className="text-caption text-ink-500">Terbaik: {level.bestScore ?? '—'}</span>
      </div>
    </Card>
  );
}
