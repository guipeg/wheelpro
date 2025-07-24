const defaultTheme = require('tailwindcss/defaultTheme')
const forms = require('@tailwindcss/forms')
const typography = require('@tailwindcss/typography')

module.exports = {
  content: [
    './index.html',
    './src/**/*.{vue,js,ts,jsx,tsx}',
    '../../packages/core/src/**/*.{ts,js}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans]
      },
      colors: {
        primary: 'rgb(var(--color-primary) / <alpha-value>)',
        secondary: 'rgb(var(--color-secondary) / <alpha-value>)'
      }
    }
  },
  plugins: [forms, typography],
  safelist: [
    // Útil para temas dinâmicos, classes geradas via JS ou i18n que o purge não detecta
    /^bg-/,
    /^text-/,
    /^border-/,
    /^hover:/,
    /^dark:/
  ]
}
