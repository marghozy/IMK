import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { AppLayout } from '@/layouts/AppLayout';
import { Badge } from '@/components/ui/Badge';
import { ProgressBar } from '@/components/ui/ProgressBar';
import { LessonListItem } from '@/features/lessons/LessonListItem';
import { lessonService } from '@/services/lessonService';
import { lessonCardPath } from '@/constants/routes';
import type { Lesson } from '@/types';

export default function LearnListPage() {
  const navigate = useNavigate();
  const [lessons, setLessons] = useState<Lesson[]>([]);

  useEffect(() => {
    lessonService.getLessons().then(setLessons);
  }, []);

  const activeLesson = lessons[0];

  return (
    <AppLayout>
      <div className="flex items-center justify-between px-5 pt-5">
        <h1 className="text-h1">📖 Belajar</h1>
        <Badge label="🔥 7" color="orange" />
      </div>

      {activeLesson && (
        <div className="mx-5 mt-4 gradient-primary rounded-md p-4 text-white">
          <p className="text-caption font-bold uppercase tracking-wide text-white/80">Lanjutkan</p>
          <div className="flex items-center justify-between">
            <div>
              <p className="text-h2">{activeLesson.title}</p>
              <p className="text-caption text-white/80">
                Kartu {Math.round((activeLesson.progress / 100) * activeLesson.totalCharacters)} dari{' '}
                {activeLesson.totalCharacters}
              </p>
            </div>
            <span className="text-3xl">𑆅</span>
          </div>
          <div className="mt-3">
            <ProgressBar value={activeLesson.progress} colorClassName="bg-white" trackClassName="bg-white/25" />
          </div>
        </div>
      )}

      <div className="px-5 pt-6">
        <h2 className="mb-3 text-label uppercase text-ink-500">📦 Semua Materi</h2>
        <div className="space-y-3">
          {lessons.map((lesson) => (
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
