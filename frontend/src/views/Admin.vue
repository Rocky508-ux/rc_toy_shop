<template>
  <div class="admin-dashboard">
    <div v-if="isSidebarOpen" class="sidebar-overlay" @click="toggleSidebar"></div>
    <aside class="sidebar" :class="{ 'is-open': isSidebarOpen }">
      <div>
        <div class="sidebar-header">
          <h2 class="sidebar-title">管理選單</h2>
           <button class="close-btn" @click="toggleSidebar">&times;</button>
        </div>
        <nav class="sidebar-nav">
          <a href="#" @click.prevent="showSection('dashboard')" :class="{ active: activeSection === 'dashboard' }">後台總覽</a>
          <a href="#" @click.prevent="showSection('products')" :class="{ active: activeSection === 'products' }">商品管理</a>
          <a href="#" @click.prevent="showSection('orders')" :class="{ active: activeSection === 'orders' }">訂單管理</a>
          <a href="#" @click.prevent="showSection('users')" :class="{ active: activeSection === 'users' }">用戶管理</a>
        </nav>
      </div>
      <button @click="handleLogout" class="logout-btn">登出</button>
    </aside>

    <main class="main-content">
      <header class="main-header">
         <button class="hamburger-btn" @click="toggleSidebar">&#9776;</button>
        <h1>{{ currentTitle }}</h1>
        <router-link to="/" class="back-home-link">回前台首頁 ↗</router-link>
      </header>
      <div class="content-area">
        <div v-if="activeSection === 'dashboard'">
          <div class="stats-cards">
            <div class="card"><h3>總銷售額</h3><p>NT$ {{ totalRevenue.toLocaleString() }}</p></div>
            <div class="card"><h3>總訂單數</h3><p>{{ totalOrdersCount }}</p></div>
            <div class="card"><h3>總用戶數</h3><p>{{ totalUsersCountDisplay }}</p></div>
          </div>
          <div class="recent-orders admin-card">
            <h2>最近訂單</h2>
            <div class="admin-table-wrapper">
              <table class="admin-table">
                <thead>
                  <tr><th>訂單編號</th><th>顧客</th><th>日期</th><th>總金額</th><th>狀態</th></tr>
                </thead>
                <tbody>
                  <tr v-for="order in recentOrders" :key="order.id">
                    <td>{{ order.id }}</td>
                    <td>{{ order.userId }}</td>
                    <td>{{ new Date(order.orderDate).toLocaleDateString() }}</td>
                    <td>NT$ {{ order.totalAmount?.toLocaleString() }}</td>
                    <td><span :class="['status-badge', order.status]">{{ order.status }}</span></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      <!-- 動態載入子組件 (Dashboard, Users, Products, Orders) -->
      <!-- 監聽子組件發出的 show-notification 事件，並向上轉發給 App.vue -->
      <component 
        :is="activeViewComponent" 
        v-if="activeSection !== 'dashboard'" 
        @show-notification="handleNotification"
      />
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import ProductManagement from '../components/admin/ProductManagement.vue';
import OrderManagement from '../components/admin/OrderManagement.vue';
import UserManagement from '../components/admin/UserManagement.vue';
import api from '../services/api.js';

const router = useRouter();
const activeSection = ref('dashboard');
const isSidebarOpen = ref(false);

const emit = defineEmits(['show-notification']);

const orders = ref([]); // 用於儲存從 API 獲取的訂單

const usersCount = ref(0);

// onMounted 會在元件掛載後執行
onMounted(async () => {
  // Fetch Orders
  if (activeSection.value === 'dashboard') {
    try {
      const response = await api.getOrders();
      orders.value = response.data;
    } catch (error) {
      console.error("無法獲取訂單資料:", error);
    }
    
    // Fetch Users count
    try {
        const userRes = await api.getUsers();
        usersCount.value = userRes.data.length;
    } catch (error) {
        console.error("無法獲取用戶資料:", error);
    }
  }
});

const currentTitle = computed(() => {
  switch (activeSection.value) {
    case 'dashboard': return '後台總覽';
    case 'products': return '商品管理';
    case 'orders': return '訂單管理';
    case 'users': return '用戶管理';
    default: return '後台管理';
  }
});

const activeViewComponent = computed(() => {
  switch (activeSection.value) {
    case 'products': return ProductManagement;
    case 'orders': return OrderManagement;
    case 'users': return UserManagement;
    default: return null;
  }
});

const recentOrders = computed(() => {
  if (!orders.value) return [];
  return [...orders.value]
    .sort((a, b) => new Date(b.orderDate) - new Date(a.orderDate))
    .slice(0, 5);
});
const totalOrdersCount = computed(() => orders.value.length.toLocaleString());

const totalRevenue = computed(() => {
    if (!orders.value) return 0;
    return orders.value.reduce((sum, order) => sum + (order.totalAmount || 0), 0);
});

const totalUsersCountDisplay = computed(() => usersCount.value.toLocaleString());

const showSection = (section) => {
  console.log("Navigating to section:", section);
  activeSection.value = section;
  if (window.innerWidth <= 768) isSidebarOpen.value = false;
};

const toggleSidebar = () => { isSidebarOpen.value = !isSidebarOpen.value; };

// 處理來自子組件的通知並轉發
const handleNotification = (msg) => {
  emit('show-notification', msg);
};

// ★★★ 修正登出邏輯，與 App.vue 一致 ★★★
const handleLogout = () => {
  if(confirm('確定要登出管理後台嗎？')) {
    localStorage.removeItem('authToken');
    localStorage.removeItem('userRole');
    localStorage.removeItem('userName');
    
    // 為了觸發 App.vue 的狀態更新，這裡簡單暴力一點直接重整頁面回首頁
    // 或是你可以只做 push，但 App.vue 的狀態可能沒變
    window.location.href = '/'; 
  }
};
</script>

<style scoped>
/* (原本的樣式保持不變，這裡只新增一個回首頁的按鈕樣式) */
:root { --sidebar-width: 250px; }
.admin-dashboard { display: flex; min-height: 100vh; width: 100%; background-color: #f4f6f9; }
.sidebar { width: 250px; flex-shrink: 0; background-color: #2c3e50; color: #ecf0f1; padding: 20px; display: flex; flex-direction: column; justify-content: space-between; transition: transform 0.3s ease-in-out; z-index: 1001; }
.sidebar-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.sidebar-title { margin: 0; font-size: 1.5em; }
.close-btn { display: none; font-size: 2rem; background: none; border: none; color: #ecf0f1; cursor: pointer; }
.sidebar-nav a { display: block; color: #bdc3c7; text-decoration: none; padding: 12px 15px; border-radius: 4px; margin-bottom: 10px; transition: background-color 0.2s, color 0.2s; }
.sidebar-nav a:hover { background-color: #34495e; color: #fff; }
.sidebar-nav a.active { background-color: #1abc9c; color: #fff; font-weight: 500; }
.logout-btn { width: 100%; padding: 12px; background-color: #e74c3c; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; margin-top: 20px; transition: background-color 0.2s; }
.logout-btn:hover { background-color: #c0392b; }
.main-content { flex-grow: 1; display: flex; flex-direction: column; min-width: 0; }
.main-header { background: #fff; padding: 0 20px; height: 60px; display: flex; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.05); z-index: 10; justify-content: space-between; /* 讓標題和回首頁分兩邊 */ }
.hamburger-btn { font-size: 1.5rem; background: none; border: none; cursor: pointer; margin-right: 15px; display: none; }
.main-header h1 { margin: 0; font-size: 1.5rem; }
.content-area { padding: 30px; overflow-y: auto; flex-grow: 1; }
.stats-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 30px; margin-bottom: 30px; }
.card { background-color: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05); text-align: center; }
.card h3 { margin: 0 0 10px; font-size: 1.1em; color: #555; }
.card p { margin: 0; font-size: 2em; font-weight: 600; color: #2c3e50; }
.recent-orders.admin-card { padding: 25px; }
.recent-orders h2 { margin-top: 0; margin-bottom: 20px; }
.sidebar-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 1000; }

.back-home-link { color: #3498db; text-decoration: none; font-weight: bold; font-size: 0.9rem; }
.back-home-link:hover { text-decoration: underline; }

@media (max-width: 768px) {
  .hamburger-btn { display: block; }
  .sidebar { position: fixed; transform: translateX(-100%); }
  .sidebar.is-open { transform: translateX(0); }
  .sidebar.is-open ~ .main-content .sidebar-overlay { display: block; }
  .close-btn { display: block; }
}
</style>