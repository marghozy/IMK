import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { AppLayout } from '@/layouts/AppLayout';
import { Avatar } from '@/components/ui/Avatar';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import { Toggle } from '@/components/ui/Toggle';
import { AchievementCard } from '@/features/profile/AchievementCard';
import { SettingsRow } from '@/features/profile/SettingsRow';
import { profileService } from '@/services/profileService';
import { formatXp } from '@/utils/format';
import { ROUTES } from '@/constants/routes';
import type { Achievement, User } from '@/types';

export default function ProfilePage() {
  const navigate = useNavigate();
  const [user, setUser] = useState<User | null>(null);
  const [achievements, setAchievements] = useState<Achievement[]>([]);
  const [notifications, setNotifications] = useState(false);
  const [darkMode, setDarkMode] = useState(false);
  const [music, setMusic] = useState(false);
  const [soundEffects, setSoundEffects] = useState(false);

  useEffect(() => {
    profileService.getCurrentUser().then(setUser);
    profileService.getAchievements().then(setAchievements);
  }, []);

  return (
    <AppLayout>
      <div className="gradient-primary flex flex-col items-center px-5 pb-6 pt-8 text-center text-white">
        <Avatar name={user?.name ?? '...'} size={88} />
        <h1 className="mt-3 text-h1">{user?.name}</h1>
        <div className="mt-1 flex items-center gap-2">
          <span className="text-caption">⭐ Level {user?.level}</span>
          <Badge label={user?.membership ?? ''} color="primary" />
        </div>
      </div>

      <div className="-mt-4 grid grid-cols-3 gap-3 px-5">
        <StatTile value={user ? formatXp(user.xpTotal) : '—'} label="XP TOTAL" />
        <StatTile value={user?.streakDays} label="STREAK" />
        <StatTile value={achievements.filter((a) => !a.locked).length} label="BADGES" />
      </div>

      <div className="px-5 pt-6">
        <h2 className="mb-3 text-label uppercase text-ink-500">🏆 Pencapaian</h2>
        <div className="grid grid-cols-3 gap-3">
          {achievements.map((achievement) => (
            <AchievementCard key={achievement.id} achievement={achievement} />
          ))}
        </div>
      </div>

      <div className="px-5 pt-6">
        <h2 className="mb-3 text-label uppercase text-ink-500">⚙️ Pengaturan</h2>
        <div className="space-y-3">
          <Toggle checked={notifications} onChange={setNotifications} label="Notifikasi" description="Ingatkan waktu belajar" />
          <Toggle checked={darkMode} onChange={setDarkMode} label="Mode Gelap" description="Hemat baterai" />
          <SettingsRow icon="🌐" label="Bahasa" />
          <SettingsRow icon="🔑" label="Ubah Kata Sandi" />
        </div>
      </div>

      <div className="px-5 pt-6">
        <h2 className="mb-3 text-label uppercase text-ink-500">🎧 Suara</h2>
        <div className="space-y-3">
          <Toggle checked={music} onChange={setMusic} label="Musik Latar" />
          <Toggle checked={soundEffects} onChange={setSoundEffects} label="Efek Suara" />
          <SettingsRow icon="🔊" label="Volume" />
        </div>
      </div>

      <div className="px-5 pt-6">
        <h2 className="mb-3 text-label uppercase text-ink-500">ℹ️ Tentang</h2>
        <div className="space-y-3">
          <SettingsRow icon="📧" label="Email" value={user?.email} trailing={<span />} />
          <SettingsRow icon="📱" label="Versi Aplikasi" value="1.2.0" trailing={<span />} />
          <SettingsRow icon="📜" label="Syarat & Privasi" />
        </div>
      </div>

      <div className="px-5 py-6">
        <Button variant="danger" icon="🚪" onClick={() => navigate(ROUTES.login)}>
          Keluar Akun
        </Button>
      </div>
    </AppLayout>
  );
}

function StatTile({ value, label }: { value?: string | number; label: string }) {
  return (
    <div className="rounded-md bg-white p-3 text-center shadow-elevated">
      <p className="text-h2 text-ink-900">{value ?? '—'}</p>
      <p className="text-caption text-ink-500">{label}</p>
    </div>
  );
}
