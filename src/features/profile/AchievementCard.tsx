import type { Achievement } from '@/types';

interface AchievementCardProps {
  achievement: Achievement;
}

export function AchievementCard({ achievement }: AchievementCardProps) {
  return (
    <div
      className={`flex flex-col items-center gap-1 rounded-md bg-white p-3 text-center shadow-card ${
        achievement.locked ? 'opacity-40' : ''
      }`}
    >
      <span className="text-2xl" aria-hidden>
        {achievement.icon}
      </span>
      <p className="text-caption font-bold text-ink-900">{achievement.title}</p>
      {achievement.dateLabel && <p className="text-caption text-ink-300">{achievement.dateLabel}</p>}
    </div>
  );
}
