import { ROUTES } from './routes';

export interface NavItem {
  key: string;
  label: string;
  icon: string;
  path: string;
}

export const NAV_ITEMS: NavItem[] = [
  { key: 'home', label: 'Home', icon: '🏠', path: ROUTES.home },
  { key: 'learn', label: 'Belajar', icon: '📖', path: ROUTES.learn },
  { key: 'quiz', label: 'Quiz', icon: '⚡', path: ROUTES.quizLevels },
  { key: 'progress', label: 'Progress', icon: '📊', path: ROUTES.progress },
  { key: 'profile', label: 'Profil', icon: '👤', path: ROUTES.profile },
];
