import { Card } from '@/components/ui/Card';
import { Badge } from '@/components/ui/Badge';
import { ProgressBar } from '@/components/ui/ProgressBar';
import type { Lesson } from '@/types';

const ACCENT_BG: Record<Lesson['accentColor'], string> = {
  primary: 'bg-primary-50',
  blue: 'bg-accent-blue/15',
  purple: 'bg-accent-purple/15',
  cream: 'bg-accent-cream/50',
};

const ACCENT_BAR: Record<Lesson['accentColor'], string> = {
  primary: 'bg-primary-500',
  blue: 'bg-accent-blue',
  purple: 'bg-accent-purple',
  cream: 'bg-accent-orange',
};

interface LessonListItemProps {
  lesson: Lesson;
  onClick?: () => void;
}

export function LessonListItem({ lesson, onClick }: LessonListItemProps) {
  return (
    <Card onClick={lesson.locked ? undefined : onClick} locked={lesson.locked} className="flex items-center gap-3">
      <span
        className={`flex size-12 shrink-0 items-center justify-center rounded-md text-xl ${ACCENT_BG[lesson.accentColor]}`}
        aria-hidden
      >
        {lesson.locked ? '🔒' : lesson.icon}
      </span>
      <div className="min-w-0 flex-1">
        <p className="truncate text-body font-bold text-ink-900">{lesson.title}</p>
        <p className="truncate text-caption text-ink-500">{lesson.description}</p>
        {!lesson.locked && (
          <div className="mt-1.5">
            <ProgressBar value={lesson.progress} colorClassName={ACCENT_BAR[lesson.accentColor]} />
          </div>
        )}
      </div>
      <Badge label={`+${lesson.xpReward} XP`} color={lesson.locked ? 'neutral' : 'orange'} />
    </Card>
  );
}
