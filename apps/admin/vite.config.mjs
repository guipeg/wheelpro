import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import eslint from 'vite-plugin-eslint'
import path from 'node:path'

export default defineConfig({
  plugins: [
    vue(),
    eslint({
      cache: false, // ✅ Evita erros intermitentes no monorepo
      include: ['src/**/*.ts', 'src/**/*.vue'] // ✅ Evita aplicar fora da pasta
    })
  ],
  resolve: {
    alias: {
      '@core': path.resolve(__dirname, '../../packages/core/src'),
      '@components': path.resolve(__dirname, 'src/components'),
      '@views': path.resolve(__dirname, 'src/views'),
      '@stores': path.resolve(__dirname, 'src/stores'),
      '@services': path.resolve(__dirname, 'src/services'),
      '@composables': path.resolve(__dirname, 'src/composables'),
      '@themes': path.resolve(__dirname, 'src/themes'),
      '@i18n': path.resolve(__dirname, 'src/i18n')
    }
  },
  css: {
    preprocessorOptions: {
      // ✅ útil se você usar variáveis globais SCSS (ex: _variables.scss)
      // scss: {
      //   additionalData: `@import "@/styles/variables.scss";`
      // }
    }
  },
  server: {
    port: 5173,
    open: true
  },
  build: {
    outDir: 'dist',
    sourcemap: true,
    emptyOutDir: true // ✅ limpa dist antes do build
  }
})
