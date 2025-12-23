import { createApp } from 'vue'
import App from './App.vue'
import router from './router' // 導入 router
import './assets/admin-table.css'; // 全域導入管理者介面樣式

const app = createApp(App);

app.use(router); // 讓應用程式使用 router

app.mount('#app');
