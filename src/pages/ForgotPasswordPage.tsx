import { FormEvent, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Alert } from '@/components/ui/Alert';
import { AuthLayout } from '@/layouts/AuthLayout';
import { ROUTES } from '@/constants/routes';
import { authService } from '@/services/authService';

export default function ForgotPasswordPage() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [sent, setSent] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      const result = await authService.requestPasswordReset(email);
      setSent(result.sent);
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout>
      <div className="flex flex-col items-center text-center">
        <div className="mb-4 flex size-20 items-center justify-center rounded-lg bg-primary-50 text-3xl">🔐</div>
        <h1 className="text-h1">Lupa Kata Sandi?</h1>
        <p className="mt-1 text-body text-ink-500">
          Masukkan email akunmu. Kami akan kirim tautan untuk reset kata sandi.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="mt-6 space-y-4">
        <Input
          label="Email Terdaftar"
          type="email"
          leadingIcon="📧"
          placeholder="thariq@example.com"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
        <Button type="submit" loading={loading}>
          Kirim Tautan Reset
        </Button>
        {sent && <Alert type="info" message="Periksa folder Spam jika email belum masuk dalam 2 menit." />}
      </form>

      <p className="mt-6 text-center text-caption text-ink-500">
        Ingat kata sandi?{' '}
        <button onClick={() => navigate(ROUTES.login)} className="font-bold text-primary-600">
          Kembali ke Login
        </button>
      </p>
    </AuthLayout>
  );
}
