import { ReactNode } from 'react';

type BadgeColor = 'primary' | 'orange' | 'blue' | 'purple' | 'cream' | 'danger' | 'neutral';

interface BadgeProps {
  label: ReactNode;
  icon?: ReactNode;
  color?: BadgeColor;
}

const COLOR_CLASSES: Record<BadgeColor, string> = {
  primary: 'bg-primary-50 text-primary-700',
  orange: 'bg-accent-yellow/30 text-accent-orange',
  blue: 'bg-accent-blue/15 text-accent-blue',
  purple: 'bg-accent-purple/15 text-accent-purple',
  cream: 'bg-accent-cream/50 text-ink-700',
  danger: 'bg-danger-50 text-danger-500',
  neutral: 'bg-surface-muted text-ink-500',
};

export function Badge({ label, icon, color = 'neutral' }: BadgeProps) {
  return (
    <span
      className={[
        'inline-flex items-center gap-1 rounded-full px-3 py-1 text-caption font-bold',
        COLOR_CLASSES[color],
      ].join(' ')}
    >
      {icon}
      {label}
    </span>
  );
}
