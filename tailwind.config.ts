import type { Config } from 'tailwindcss';

export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#EEF9EA',
          100: '#D6F1CA',
          200: '#AFE393',
          300: '#8BDB3A',
          400: '#6FCE1F',
          500: '#5BC400',
          600: '#4DA600',
          700: '#3DA635',
          800: '#2F7D29',
          900: '#235C1F',
        },
        danger: {
          50: '#FDEDED',
          100: '#FBD4D4',
          300: '#F25C5C',
          500: '#E14747',
          700: '#B83434',
        },
        accent: {
          orange: '#FFA500',
          yellow: '#FFD15C',
          blue: '#4FA8E0',
          purple: '#9B6FD6',
          cream: '#E8DCC4',
        },
        surface: {
          DEFAULT: '#FFFFFF',
          muted: '#F7F8FA',
          border: '#E5E7EB',
        },
        ink: {
          900: '#1F2937',
          700: '#4B5563',
          500: '#6B7280',
          300: '#9CA3AF',
        },
      },
      fontFamily: {
        sans: ['"Baloo 2"', '"Poppins"', 'system-ui', 'sans-serif'],
        aksara: ['"Noto Sans Javanese"', 'system-ui', 'sans-serif'],
      },
      fontSize: {
        display: ['28px', { lineHeight: '1.2', fontWeight: '700' }],
        h1: ['24px', { lineHeight: '1.25', fontWeight: '700' }],
        h2: ['18px', { lineHeight: '1.3', fontWeight: '700' }],
        body: ['15px', { lineHeight: '1.5', fontWeight: '400' }],
        caption: ['12px', { lineHeight: '1.4', fontWeight: '400' }],
        label: ['11px', { lineHeight: '1.3', fontWeight: '700', letterSpacing: '0.05em' }],
      },
      borderRadius: {
        sm: '8px',
        md: '14px',
        lg: '20px',
      },
      boxShadow: {
        card: '0 2px 8px 0 rgba(0,0,0,0.06)',
        elevated: '0 8px 24px 0 rgba(0,0,0,0.12)',
      },
      spacing: {
        18: '4.5rem',
      },
    },
  },
  plugins: [],
} satisfies Config;
