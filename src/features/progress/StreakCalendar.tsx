interface StreakCalendarProps {
  monthLabel: string;
  daysInMonth: number;
  startWeekday: number;
  activeDays: number[];
  today: number;
}

const WEEKDAYS = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB', 'MIN'];

export function StreakCalendar({ monthLabel, daysInMonth, startWeekday, activeDays, today }: StreakCalendarProps) {
  const blanks = Array.from({ length: startWeekday });
  const days = Array.from({ length: daysInMonth }, (_, i) => i + 1);

  return (
    <div className="rounded-md bg-white p-4 shadow-card">
      <p className="mb-3 text-body font-bold text-ink-900">{monthLabel}</p>
      <div className="grid grid-cols-7 gap-1.5 text-center">
        {WEEKDAYS.map((day) => (
          <span key={day} className="text-caption font-bold text-ink-300">
            {day}
          </span>
        ))}
        {blanks.map((_, i) => (
          <span key={`blank-${i}`} />
        ))}
        {days.map((day) => {
          const isActive = activeDays.includes(day);
          const isToday = day === today;
          return (
            <span
              key={day}
              className={[
                'flex aspect-square items-center justify-center rounded-sm text-caption font-bold',
                isToday
                  ? 'bg-primary-600 text-white'
                  : isActive
                    ? 'bg-primary-100 text-primary-700'
                    : 'text-ink-500',
              ].join(' ')}
            >
              {day}
            </span>
          );
        })}
      </div>
    </div>
  );
}
