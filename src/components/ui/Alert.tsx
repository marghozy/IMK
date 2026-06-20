import { ReactNode } from 'react';

type AlertType = 'info' | 'warning' | 'success' | 'error';

interface AlertProps {
  message: ReactNode;
  type?: AlertType;
  icon?: ReactNode;
}

const TYPE_CLASSES: Record<AlertType, string> = {
  info: 'bg-accent-yellow/20 text-ink-700 border-accent-yellow/50',
  warning: 'bg-accent-yellow/20 text-ink-700 border-accent-yellow/50',
  success: 'bg-primary-50 text-primary-700 border-primary-200',
  error: 'bg-danger-50 text-danger-700 border-danger-100',
};

const DEFAULT_ICON: Record<AlertType, string> = {
  info: '💡',
  warning: '⚠️',
  success: '✅',
  error: '❌',
};

export function Alert({ message, type = 'info', icon }: AlertProps) {
  return (
    <div className={`flex items-start gap-2 rounded-md border px-4 py-3 text-caption ${TYPE_CLASSES[type]}`}>
      <span aria-hidden>{icon ?? DEFAULT_ICON[type]}</span>
      <span>{message}</span>
    </div>
  );
}
