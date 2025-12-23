import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
  server: {
    port: 3000, // ← 設定開發伺服器端口
    proxy: {
      '/api/zen': {
        target: 'https://zenquotes.io',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api\/zen/, '/api'),
      },
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
      '/image': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
    }
  }
})
