import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { AppLayout } from '@/layouts/AppLayout';
import { Avatar } from '@/components/ui/Avatar';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import { ProgressBar } from '@/components/ui/ProgressBar';
import { LessonListItem } from '@/features/lessons/LessonListItem';
import { lessonCardPath } from '@/constants/routes';
import { profileService } from '@/services/profileService';
import { lessonService } from '@/services/lessonService';
import type { Lesson, User } from '@/types';

export default function HomePage() {
  const navigate = useNavigate();
  const [user, setUser] = useState<User | null>(null);
  const [lessons, setLessons] = useState<Lesson[]>([]);

  useEffect(() => {
    profileService.getCurrentUser().then(setUser);
    lessonService.getLessons().then(setLessons);
  }, []);

  const dailyProgress = 70;

  return (
    <AppLayout>
      <div className="gradient-primary px-5 pb-6 pt-5 text-white">
        <div className="flex items-center justify-between">
          <Avatar name={user?.name ?? '...'} size={40} badge={user?.level} />
          <div className="flex gap-2">
            <Badge label={`⚡ ${user?.xpTotal ?? 0} XP`} color="danger" />
            <Badge label={`🔥 ${user?.streakDays ?? 0}`} color="orange" />
          </div>
        </div>
        <h1 className="mt-4 text-h1">
          Selamat sore, <span className="text-accent-yellow">{user?.name.split(' ')[0] ?? ''}</span>! 👋
        </h1>
        <p className="text-caption text-white/80">Jangan putus streak-mu hari ini</p>

        <div className="mt-4 flex gap-2">
          {Array.from({ length: 6 }).map((_, i) => (
            <span key={i} className="flex size-8 items-center justify-center rounded-full bg-white/20 text-sm">
              🔥
            </span>
          ))}
          <span className="flex size-8 items-center justify-center rounded-full bg-white text-primary-600">●</span>
        </div>
      </div>

      <div className="-mt-3 px-5">
        <div className="rounded-md bg-white p-4 shadow-elevated">
          <div className="flex items-center justify-between text-label uppercase text-ink-500">
            <span>Progress Hari Ini</span>
            <span className="text-primary-600">{dailyProgress}%</span>
          </div>
          <div className="mt-2">
            <ProgressBar value={dailyProgress} />
          </div>
        </div>
      </div>

      <div className="px-5 pt-4">
        <Button onClick={() => navigate(lessonCardPath('pasangan', 3))} icon="▶️">
          Lanjutkan Belajar
        </Button>
      </div>

      <div className="px-5 pt-6">
        <h2 className="mb-3 text-label uppercase text-ink-500">📚 Recommended</h2>
        <div className="space-y-3">
          {lessons.slice(0, 3).map((lesson) => (
            <LessonListItem
              key={lesson.id}
              lesson={lesson}
              onClick={() => navigate(lessonCardPath(lesson.id, 0))}
            />
          ))}
        </div>
      </div>
    </AppLayout>
  );
}
