import { HTMLAttributes, ReactNode } from 'react';

interface CardProps extends HTMLAttributes<HTMLDivElement> {
  children: ReactNode;
  locked?: boolean;
}

export function Card({ children, locked = false, className = '', ...rest }: CardProps) {
  return (
    <div
      className={[
        'rounded-md bg-white p-4 shadow-card',
        locked ? 'opacity-50' : '',
        rest.onClick ? 'cursor-pointer active:scale-[0.99]' : '',
        className,
      ].join(' ')}
      {...rest}
    >
      {children}
    </div>
  );
}
