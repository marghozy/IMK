import { useEffect, useState } from 'react';
import { AppLayout } from '@/layouts/AppLayout';
import { AccuracyBarChart } from '@/features/progress/AccuracyBarChart';
import { StreakCalendar } from '@/features/progress/StreakCalendar';
import { progressService } from '@/services/progressService';
import { formatXp } from '@/utils/format';
import type { DailyAccuracy } from '@/types';

interface Summary {
  totalXp: number;
  streakDays: number;
  accuracy: number;
  lessonsCompleted: number;
  quizzesCompleted: number;
}

export default function ProgressPage() {
  const [accuracyData, setAccuracyData] = useState<DailyAccuracy[]>([]);
  const [summary, setSummary] = useState<Summary | null>(null);

  useEffect(() => {
    progressService.getWeeklyAccuracy().then(setAccuracyData);
    progressService.getSummary().then(setSummary);
  }, []);

  return (
    <AppLayout>
      <h1 className="px-5 pt-5 text-h1">📊 Progress</h1>

      <div className="px-5 pt-4">
        <div className="gradient-primary rounded-md p-6 text-center text-white shadow-card">
          <p className="text-display">{summary ? formatXp(summary.totalXp) : '—'}</p>
          <p className="text-caption">Total XP</p>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-3 px-5 pt-4">
        <StatTile icon="🔥" value={summary?.streakDays} label="STREAK AKTIF" />
        <StatTile icon="🎯" value={summary ? `${summary.accuracy}%` : undefined} label="AKURASI" />
        <StatTile icon="📖" value={summary?.lessonsCompleted} label="PELAJARAN" />
        <StatTile icon="⚡" value={summary?.quizzesCompleted} label="QUIZ SELESAI" />
      </div>

      <div className="px-5 pt-6">
        <h2 className="mb-3 text-label uppercase text-ink-500">📈 Akurasi 7 Hari</h2>
        <div className="rounded-md bg-white p-4 shadow-card">
          <AccuracyBarChart data={accuracyData} />
        </div>
      </div>

      <div className="px-5 pt-6">
        <h2 className="mb-3 text-label uppercase text-ink-500">📅 Kalender Mei 2026</h2>
        <StreakCalendar
          monthLabel="Mei 2026"
          daysInMonth={31}
          startWeekday={4}
          activeDays={[1, 2, 3, 4, 5, 6, 7, 8, 9]}
          today={10}
        />
      </div>
    </AppLayout>
  );
}

function StatTile({ icon, value, label }: { icon: string; value?: string | number; label: string }) {
  return (
    <div className="rounded-md bg-white p-4 text-center shadow-card">
      <p className="text-xl">{icon}</p>
      <p className="text-h2 text-ink-900">{value ?? '—'}</p>
      <p className="text-caption text-ink-500">{label}</p>
    </div>
  );
}
