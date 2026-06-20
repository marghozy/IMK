import { FormEvent, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { AuthLayout } from '@/layouts/AuthLayout';
import { ROUTES } from '@/constants/routes';
import { authService } from '@/services/authService';

export default function LoginPage() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      await authService.login({ email, password });
      navigate(ROUTES.home);
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout>
      <div className="flex flex-col items-center text-center">
        <div className="mb-4 flex size-20 items-center justify-center rounded-lg bg-primary-500 text-3xl">📜</div>
        <h1 className="text-h1">Selamat Datang</h1>
        <p className="mt-1 text-body text-ink-500">Masuk untuk lanjut belajar Aksara Jawa</p>
      </div>

      <form onSubmit={handleSubmit} className="mt-6 space-y-4">
        <Input
          type="email"
          leadingIcon="📧"
          placeholder="thariq@example.com"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
        <Input
          type="password"
          leadingIcon="🔒"
          placeholder="rahasia12"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
        <div className="text-right">
          <button
            type="button"
            onClick={() => navigate(ROUTES.forgotPassword)}
            className="text-caption font-bold text-primary-600"
          >
            Lupa kata sandi?
          </button>
        </div>
        <Button type="submit" loading={loading}>
          Masuk
        </Button>
      </form>

      <div className="my-5 flex items-center gap-3">
        <span className="h-px flex-1 bg-surface-border" />
        <span className="text-caption text-ink-300">ATAU</span>
        <span className="h-px flex-1 bg-surface-border" />
      </div>

      <div className="flex gap-3">
        <Button variant="outline">Google</Button>
        <Button variant="outline">🍎 Apple</Button>
      </div>

      <p className="mt-6 text-center text-caption text-ink-500">
        Belum punya akun?{' '}
        <button onClick={() => navigate(ROUTES.register)} className="font-bold text-primary-600">
          Daftar
        </button>
      </p>
    </AuthLayout>
  );
}
