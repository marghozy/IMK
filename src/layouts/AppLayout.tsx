import { ReactNode } from 'react';
import { BottomNav } from '@/components/ui/BottomNav';

interface AppLayoutProps {
  children: ReactNode;
}

export function AppLayout({ children }: AppLayoutProps) {
  return (
    <div className="app-shell flex flex-col">
      <main className="flex-1 pb-2">{children}</main>
      <BottomNav />
    </div>
  );
}
