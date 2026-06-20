import { InputHTMLAttributes, ReactNode, useState } from 'react';

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  leadingIcon?: ReactNode;
}

export function Input({ label, error, leadingIcon, type = 'text', className = '', ...rest }: InputProps) {
  const [showPassword, setShowPassword] = useState(false);
  const isPassword = type === 'password';
  const resolvedType = isPassword && showPassword ? 'text' : type;

  return (
    <label className="block">
      {label && <span className="mb-1.5 block text-label uppercase text-ink-500">{label}</span>}
      <span
        className={[
          'flex items-center gap-2 rounded-md border-2 bg-white px-4 py-3',
          error ? 'border-danger-300' : 'border-surface-border focus-within:border-primary-400',
          className,
        ].join(' ')}
      >
        {leadingIcon && <span className="text-ink-300">{leadingIcon}</span>}
        <input
          type={resolvedType}
          className="w-full bg-transparent text-body text-ink-900 outline-none placeholder:text-ink-300"
          {...rest}
        />
        {isPassword && (
          <button
            type="button"
            aria-label={showPassword ? 'Sembunyikan kata sandi' : 'Tampilkan kata sandi'}
            onClick={() => setShowPassword((v) => !v)}
            className="text-ink-300"
          >
            {showPassword ? '🙈' : '👁️'}
          </button>
        )}
      </span>
      {error && <span className="mt-1 block text-caption text-danger-500">{error}</span>}
    </label>
  );
}
