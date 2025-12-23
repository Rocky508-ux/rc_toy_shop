<template>
  <div v-if="loading" class="status-msg">載入中...</div>
  <div v-else-if="fetchError" class="status-msg error">{{ fetchError }}</div>
  <template v-else-if="filteredProducts.length > 0">
    <product-card
      v-for="product in filteredProducts"
      :key="product.id"
      :product="product"
      @add-to-cart="$emit('add-to-cart', $event)"
    ></product-card>
  </template>
  
  <div v-else class="empty-state">
    <div class="icon-container">
      <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="11" cy="11" r="8"></circle>
        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
      </svg>
    </div>
    <h3>找不到符合「{{ route.query.search }}」的商品</h3>
    <p>試試看調整關鍵字，或是瀏覽所有商品。</p>
    <button class="reset-btn" @click="clearSearch">清除搜尋條件</button>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import ProductCard from '../components/ProductCard.vue';
import api from '../services/api.js';

const props = defineProps(['isLoggedIn', 'cartItems']);
defineEmits(['add-to-cart', 'login-success', 'registration-notification', 'update-quantity', 'remove-from-cart', 'clear-cart', 'show-notification', 'require-login']);

const route = useRoute();
const router = useRouter();

const allProducts = ref([]); // 用於儲存從 API 獲取的原始商品列表

const loading = ref(true);
const fetchError = ref(null);

// onMounted 會在元件掛載到 DOM 後執行
onMounted(async () => {
  try {
    loading.value = true;
    fetchError.value = null;
    const response = await api.getProducts();
    console.log('API Response:', response); // Debugging log
    allProducts.value = response.data; // 將 API 回傳的商品資料存入 allProducts
  } catch (error) {
    console.error('無法獲取商品列表:', error);
    
    let errMsg = '無法連接到後端 API';
    if (error.response) {
       // 如果後端有回傳錯誤訊息 (例如 GlobalExceptionHandler 的 map)
       const data = error.response.data;
       if (data && data.message) {
         errMsg += `: ${data.message} (${data.exception || ''})`;
       } else {
         errMsg += `: Status ${error.response.status}`;
       }
    } else {
       errMsg += `: ${error.message || '未知錯誤'}`;
    }
    
    fetchError.value = errMsg + '。請確認後端服務是否正常。';
  } finally {
    loading.value = false;
  }
});

const clearSearch = () => {
  router.push('/');
};

const filteredProducts = computed(() => {
  let currentProducts = allProducts.value || [];

  const searchTerm = (route.query.search || '').toLowerCase();
  if (searchTerm) {
    currentProducts = currentProducts.filter(product => 
      (product.name || '').toLowerCase().includes(searchTerm)
    );
  }

  const tagFilter = route.query.tag;
  if (tagFilter) {
    currentProducts = currentProducts.filter(product => product.tag === tagFilter);
  }

  const categoryFilter = route.query.category;
  if (categoryFilter === 'hot_sales') {
    // 顯示標記為 type='hot' 或 tag='熱銷' 的商品
    currentProducts = currentProducts.filter(product => 
      product.type === 'hot' || product.tag === 'hot' || product.tag === '熱銷'
    );
  } else if (categoryFilter) {
    currentProducts = currentProducts.filter(product => product.categoryId === categoryFilter);
  }

  return currentProducts;
});
</script>

<style scoped>
/* ★★★ 關鍵修正：讓空狀態橫跨所有 Grid 欄位 ★★★ */
.empty-state {
  grid-column: 1 / -1; /* 從第 1 條線跨到最後一條線 (佔滿整行) */
  width: 100%;
  
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  background-color: #fff;
  border-radius: 12px;
  text-align: center;
  min-height: 400px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.02); /* 加一點點陰影讓它不要太平面 */
  margin-top: 20px;
}

.icon-container {
  margin-bottom: 20px;
  background-color: #f3f4f6;
  padding: 20px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-state h3 {
  font-size: 1.5rem;
  color: #374151;
  margin-bottom: 10px;
  font-weight: 700;
}

.empty-state p {
  color: #6b7280;
  margin-bottom: 25px;
  font-size: 1rem;
}

.reset-btn {
  padding: 10px 24px;
  background-color: #4285F4;
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 5px rgba(66, 133, 244, 0.3);
}

.reset-btn:hover {
  background-color: #3367d6;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(66, 133, 244, 0.4);
}

.status-msg {
  grid-column: 1 / -1;
  text-align: center;
  padding: 40px;
  font-size: 1.2rem;
  color: #666;
  width: 100%;
}
.status-msg.error {
  color: #d93025;
  background-color: #fce8e6;
  border-radius: 8px;
  margin: 20px 0;
}
</style>