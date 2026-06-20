import { NavLink } from 'react-router-dom';
import { NAV_ITEMS } from '@/constants/navItems';

export function BottomNav() {
  return (
    <nav className="sticky bottom-0 left-0 right-0 flex border-t border-surface-border bg-white px-2 py-2">
      {NAV_ITEMS.map((item) => (
        <NavLink
          key={item.key}
          to={item.path}
          className={({ isActive }) =>
            [
              'flex flex-1 flex-col items-center gap-0.5 rounded-md py-1.5 text-caption font-bold',
              isActive ? 'text-primary-600' : 'text-ink-300',
            ].join(' ')
          }
        >
          <span className="text-lg" aria-hidden>
            {item.icon}
          </span>
          {item.label}
        </NavLink>
      ))}
    </nav>
  );
}
