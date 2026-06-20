import { ButtonHTMLAttributes, ReactNode } from 'react';

type Variant = 'primary' | 'outline' | 'danger' | 'danger-outline';

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  fullWidth?: boolean;
  loading?: boolean;
  icon?: ReactNode;
  children: ReactNode;
}

const VARIANT_CLASSES: Record<Variant, string> = {
  primary: 'gradient-primary text-white shadow-card disabled:opacity-50',
  outline: 'bg-white text-primary-700 border-2 border-primary-300 disabled:opacity-50',
  danger: 'gradient-danger text-white shadow-card disabled:opacity-50',
  'danger-outline': 'bg-white text-danger-500 border-2 border-danger-300 disabled:opacity-50',
};

export function Button({
  variant = 'primary',
  fullWidth = true,
  loading = false,
  icon,
  children,
  className = '',
  disabled,
  ...rest
}: ButtonProps) {
  return (
    <button
      className={[
        'inline-flex items-center justify-center gap-2 rounded-full px-6 py-3.5 text-body font-bold tracking-wide transition active:scale-[0.98] disabled:cursor-not-allowed disabled:active:scale-100',
        VARIANT_CLASSES[variant],
        fullWidth ? 'w-full' : '',
        className,
      ].join(' ')}
      disabled={disabled || loading}
      {...rest}
    >
      {loading ? (
        <span className="size-4 animate-spin rounded-full border-2 border-white/40 border-t-white" />
      ) : (
        icon
      )}
      <span>{children}</span>
    </button>
  );
}
