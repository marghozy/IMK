import { useEffect, useRef, useState } from 'react';

export function useTimer(initialSeconds: number, autoStart = true) {
  const [secondsLeft, setSecondsLeft] = useState(initialSeconds);
  const [running, setRunning] = useState(autoStart);
  const intervalRef = useRef<number>();

  useEffect(() => {
    if (!running) return;

    intervalRef.current = window.setInterval(() => {
      setSecondsLeft((prev) => {
        if (prev <= 1) {
          window.clearInterval(intervalRef.current);
          setRunning(false);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);

    return () => window.clearInterval(intervalRef.current);
  }, [running]);

  return { secondsLeft, running, start: () => setRunning(true), pause: () => setRunning(false) };
}
