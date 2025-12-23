<template>
  <div class="cart-container">
    <div class="cart-header-row">
      <h2>我的購物車</h2>
      <button v-if="cartItems.length > 0" @click="openClearModal" class="clear-cart-btn">
        🗑️ 清空購物車
      </button>
    </div>

    <div v-if="!cartItems || cartItems.length === 0" class="cart-empty">
      <div class="empty-icon">🛒</div>
      <p>您的購物車是空的</p>
      <router-link to="/" class="empty-action-btn">去逛逛</router-link>
    </div>

    <div v-else>
      <div class="cart-body">
        <div class="cart-table-wrapper">
          <table class="cart-table">
            <thead>
              <tr>
                <th class="th-product header-left">商品資訊</th>
                <th class="th-spec">規格</th>
                <th class="th-qty">數量</th>
                <th class="th-price">單價</th>
                <th class="th-subtotal">小計</th>
                <th class="th-action">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in cartItems" :key="item.id">
                <td class="td-product">
                  <div class="product-info-row">
                    <div class="thumb-wrapper">
                      <img :src="getProductImage(item)" :alt="item.name" class="cart-thumb">
                    </div>
                    <div class="product-text">
                      <span class="product-name">{{ item.name }}</span>
                      <div class="mobile-meta">
                        <span class="mobile-spec" v-if="item.tag">{{ item.tag }}</span>
                      </div>
                    </div>
                  </div>
                </td>
                <td class="td-spec">
                  <span class="badge">{{ item.tag || '標準' }}</span>
                </td>
                <td class="td-qty">
                  <div class="quantity-controls">
                    <button @click="$emit('update-quantity', item.id, -1)" :disabled="item.quantity <= 1">-</button>
                    <input type="text" :value="item.quantity" readonly />
                    <button @click="$emit('update-quantity', item.id, 1)">+</button>
                  </div>
                </td>
                <td class="td-price">
                  <div class="price-wrapper">
                    <span class="currency">NT$</span>
                    <span class="amount">{{ item.price?.toLocaleString() }}</span>
                  </div>
                </td>
                <td class="td-subtotal">
                  <div class="price-wrapper highlight">
                    <span class="currency">NT$</span>
                    <span class="amount">{{ (item.price * item.quantity).toLocaleString() }}</span>
                  </div>
                </td>
                <td class="td-action">
                  <button @click="$emit('remove-from-cart', item.id)" class="delete-btn" title="移除">
                    ✕
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="cart-footer">
          <div class="cart-summary-box">
            <div class="summary-row">
              <span>共 {{ totalItems }} 件商品</span>
            </div>
            <div class="summary-row total">
              <span>總金額</span>
              <span class="total-price">NT$ {{ totalPrice.toLocaleString() }}</span>
            </div>
          </div>
          
          <div class="cart-actions">
            <div class="address-input-group">
              <label for="shipping-addr">收件地址：</label>
              <input 
                id="shipping-addr" 
                type="text" 
                v-model="shippingAddress" 
                placeholder="請輸入您的收件地址..." 
                class="addr-input"
              />
            </div>
            <router-link to="/" class="continue-shop-btn">← 繼續購物</router-link>
            <button @click="handleCheckout" class="checkout-btn">前往結帳</button>
          </div>
        </div>
      </div>
    </div>

    <div v-if="showClearModal" class="confirm-overlay" @click.self="closeClearModal">
      <div class="confirm-box">
        <h3>確定要清空購物車嗎？</h3>
        <p>此動作無法復原，所有商品將被移除。</p>
        <div class="confirm-actions">
          <button class="modal-btn cancel" @click="closeClearModal">取消</button>
          <button class="modal-btn confirm" @click="confirmClearAction">確定清空</button>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { computed, ref } from 'vue';

const props = defineProps({
  cartItems: { type: Array, required: true, default: () => [] },
  isLoggedIn: { type: Boolean, required: true }
});

const emit = defineEmits(['remove-from-cart', 'require-login', 'update-quantity', 'clear-cart', 'show-notification']);

const showClearModal = ref(false);
const shippingAddress = ref('');

const getProductImage = (item) => {
  if (item.images && item.images.length > 0) {
    const main = item.images.find(img => img.isMain);
    let path = main ? main.imagePath : item.images[0].imagePath;
    if (path && !path.startsWith('http')) {
      // Use relative path directly
      // return `http://localhost:8080${path}`;
      return path;
    }
    return path;
  }
  return item.image_path || ''; // Fallback for legacy structure
};

const totalPrice = computed(() => {
  if (!props.cartItems) return 0;
  return props.cartItems.reduce((total, item) => total + (item.price * item.quantity), 0);
});

const totalItems = computed(() => {
  return props.cartItems.reduce((total, item) => total + item.quantity, 0);
});

// 打開確認視窗
const openClearModal = () => {
  showClearModal.value = true;
};

// 關閉確認視窗
const closeClearModal = () => {
  showClearModal.value = false;
};

// 使用者按下「確定」後執行
const confirmClearAction = () => {
  emit('clear-cart');
  closeClearModal();
};

import api from '../services/api.js'; // 引入 API
import { useRouter } from 'vue-router'; // 引入 router

const router = useRouter();

const handleCheckout = async () => {
  if (!props.isLoggedIn) {
    emit('show-notification', '請先登入會員，才能進行結帳。');
    emit('require-login');
    return;
  }

  // 移除前後空白
  const address = shippingAddress.value.trim();

  if (!address) {
    emit('show-notification', '請填寫收件地址！');
    return;
  }

  // 驗證地址格式
  // 1. 不可以是純數字
  // 2. 長度至少 10 個字 (避免隨便打 "123" 或 "台北市")
  // 3. 簡單檢查是否包含常見地址關鍵字 (選擇性，但用戶要求不可亂打)
  const isPureNumber = /^\d+$/.test(address);
  const isTooShort = address.length < 10;
  
  if (isPureNumber) {
     emit('show-notification', '地址不可以是純數字！');
     return;       
  }
  
  if (isTooShort) {
     emit('show-notification', '地址長度過短，請填寫完整地址 (至少 10 字)');
     return;
  }

  try {
    const userId = localStorage.getItem('userId');
    if (!userId) {
      throw new Error('無法取得使用者資訊，請重新登入。');
    }

    // 1. 準備訂單資料
    const orderItems = props.cartItems.map(item => ({
      productId: item.id,
      productName: item.name,
      quantity: item.quantity,
      price: item.price
    }));

    // 生成易讀的訂單編號: ORD-YYYYMMDD-XXX (例如: ORD-20231215-008)
    const now = new Date();
    const dateStr = now.getFullYear().toString() + 
                    (now.getMonth() + 1).toString().padStart(2, '0') + 
                    now.getDate().toString().padStart(2, '0');
    // 為了避免重複，使用 3 位數隨機碼 (這只是模擬，正式環境應由後端生成)
    const randomSuffix = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
    const orderId = `ORD-${dateStr}-${randomSuffix}`;

    const orderData = {
      id: orderId,
      userId: parseInt(userId), // 確保是數字
      totalAmount: totalPrice.value,
      status: 'PENDING',
      shippingAddress: shippingAddress.value,
      items: orderItems
    };

    emit('show-notification', '正在建立訂單...');

    // 2. 呼叫後端 API
    await api.createOrder(orderData);

    // 3. 成功後處理
    emit('show-notification', '訂單建立成功！感謝您的購買。');
    emit('clear-cart'); // 清空購物車
    router.push('/orders'); // 導向訂單歷史頁面

  } catch (error) {
    console.error('結帳失敗:', error);
    if (error.message === '無法取得使用者資訊，請重新登入。') {
      emit('show-notification', '系統更新：請重新登入以獲取完整權限。');
      emit('require-login');
      // 清除舊的 token 避免卡死
      localStorage.removeItem('authToken');
      localStorage.removeItem('userRole');
      localStorage.removeItem('userName');
      localStorage.removeItem('userId'); 
    } else {
      emit('show-notification', '結帳失敗，請稍後再試。');
    }
  }
};
</script>

<style scoped>
.cart-container {
  max-width: 90%;
  margin: 40px auto;
  background-color: transparent; /* Remove container background */
  padding: 0;
  box-shadow: 0 10px 40px rgba(0,0,0,0.08); 
  border-radius: 16px; 
  overflow: hidden;
  min-height: 400px;
  display: flex;
  flex-direction: column;
  animation: fadeIn 0.5s ease-out;
}

.cart-body {
  background-color: #f8fafc; /* Suble grey body */
  flex-grow: 1; /* Fill remaining height */
  display: flex;
  flex-direction: column;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.cart-header-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 25px 40px;
  background: linear-gradient(90deg, #2d3748 0%, #4a5568 100%);
  border-bottom: none;
}

.cart-header-row h2 {
  margin: 0;
  font-size: 1.8rem;
  color: #fff;
  letter-spacing: 1px;
  font-weight: 700;
  text-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.clear-cart-btn {
  background-color: #fff5f5;
  color: #e53e3e;
  border: 1px solid #fed7d7;
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  gap: 8px;
}

.clear-cart-btn:hover {
  background-color: #fed7d7;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(229, 62, 62, 0.2);
}

/* 列表標題列 - 改用漸層與深色設計 */
/* 列表標題列 - 改用漸層與深色設計 */
.cart-table thead th {
  padding: 18px;
  background: linear-gradient(90deg, #2d3748 0%, #4a5568 100%);
  color: #fff;
  font-weight: 600;
  letter-spacing: 1px;
  font-size: 0.95rem;
  text-transform: uppercase;
  border: none;
}
.cart-table th.header-left { border-radius: 8px 0 0 8px; padding-left: 40px; }
.cart-table th.th-action { border-radius: 0 8px 8px 0; }

.cart-empty { 
  flex-grow: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 60px 20px; width: 100%; color: #a0aec0;
}

.empty-icon { font-size: 5rem; margin-bottom: 20px; opacity: 0.5; }
.cart-empty p { font-size: 1.2rem; margin-bottom: 30px; }
.empty-action-btn { display: inline-block; padding: 12px 35px; background: #2d3748; color: #fff; text-decoration: none; border-radius: 8px; font-weight: bold; transition: all 0.3s; }
.empty-action-btn:hover { background: #4a5568; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.15); }

.cart-table-wrapper { 
  overflow-x: auto; 
  width: 100%; 
  padding: 30px 40px; 
  margin-top: 0; 
  box-sizing: border-box; 
  background: transparent;
}
.cart-table, .cart-table th, .cart-table td { box-sizing: border-box; }
.cart-table { width: 100%; border-collapse: separate; border-spacing: 0 15px; table-layout: fixed; }

.td-product, .th-product { width: 40%; text-align: left !important; padding-left: 20px !important; }
.td-spec, .th-spec { width: 10%; text-align: center; }
.td-qty, .th-qty { width: 15%; text-align: center; }
.td-price, .th-price { width: 13%; text-align: center; }
.td-subtotal, .th-subtotal { width: 13%; text-align: center; }
.td-action, .th-action { width: 9%; text-align: center; padding: 10px 0 !important; }

/* Remove explicit widths from previous selector blocks to avoid conflict */
.td-product { min-width: 250px; }
.td-qty { min-width: 120px; }

.product-info-row { display: flex; flex-direction: row; align-items: center; justify-content: flex-start; gap: 20px; text-align: left; }
.thumb-wrapper { width: 80px; height: 80px; border-radius: 12px; overflow: hidden; border: 1px solid #edf2f7; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
.cart-thumb { width: 100%; height: 100%; object-fit: cover; }
.product-text { display: flex; flex-direction: column; gap: 5px; }
.product-name { font-weight: 700; font-size: 1.05rem; color: #2d3748; line-height: 1.4; }
.badge { display: inline-block; background: #edf2f7; color: #718096; padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; }

/* Quantity Controls Simplified */
.quantity-controls { 
  display: inline-flex; 
  align-items: center; 
  justify-content: center; 
  background: transparent; 
  gap: 5px; 
  border: none; 
  box-shadow: none; 
  border-radius: 0;
}

.quantity-controls button { 
  width: 26px; 
  height: 26px; 
  background: #f1f5f9; 
  border: 1px solid #e2e8f0; 
  border-radius: 4px;
  cursor: pointer; 
  font-size: 1rem; 
  color: #64748b; 
  display: flex; 
  align-items: center; 
  justify-content: center;
  transition: all 0.2s;
}
.quantity-controls button:hover:not(:disabled) { background: #cbd5e0; color: #1e293b; border-color: #cbd5e0; }
.quantity-controls button:disabled { opacity: 0.4; cursor: not-allowed; }

.quantity-controls input { 
  width: 32px; 
  text-align: center; 
  border: none; 
  font-weight: 700; 
  font-size: 1rem; 
  color: #1e293b; 
  background: transparent; 
  padding: 0;
}

.price-wrapper { font-family: 'Roboto', sans-serif; font-weight: 500; }
.price-wrapper.highlight .amount { font-weight: 700; color: #e53e3e; font-size: 1.1rem; }

.delete-btn { width: 36px; height: 36px; border-radius: 50%; border: none; background: transparent; color: #a0aec0; transition: all 0.2s; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; cursor: pointer; margin: 0 auto; }
.delete-btn:hover { background: #fff5f5; color: #e53e3e; transform: rotate(90deg); }

/* 購物車底部結帳區 */
.cart-footer {
  padding: 30px 40px;
  background: transparent !important;
  border-top: none;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 25px;
}
.cart-summary-box { text-align: right; width: 100%; max-width: 400px; }
.summary-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 1rem; color: #718096; }
.summary-row.total { font-size: 1.2rem; color: #2d3748; font-weight: 700; border-top: 2px dashed #e2e8f0; padding-top: 20px; margin-top: 10px; align-items: center; }
.total-price { color: #e53e3e; font-size: 2.2rem; font-family: 'Roboto', sans-serif; }

.cart-actions { display: flex; align-items: center; gap: 20px; width: 100%; justify-content: flex-end; flex-wrap: wrap; }
.address-input-group { display: flex; align-items: center; gap: 15px; flex-grow: 1; justify-content: flex-end; }
.address-input-group label { font-weight: 600; color: #4a5568; }
.addr-input { padding: 12px 15px; border: 2px solid #e2e8f0; border-radius: 8px; width: 350px; font-size: 1rem; transition: all 0.3s; background: #f8fafc; }
.addr-input:focus { border-color: #4299e1; background: #fff; outline: none; box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.15); }

.continue-shop-btn { color: #718096; text-decoration: none; font-weight: 600; padding: 12px 25px; border-radius: 8px; transition: all 0.2s; }
.continue-shop-btn:hover { color: #2d3748; background: #f7fafc; }

.checkout-btn { 
  background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%); 
  color: white; border: none; padding: 16px 40px; font-size: 1.1rem; font-weight: 700; 
  cursor: pointer; transition: all 0.3s; border-radius: 10px; letter-spacing: 0.5px; 
  box-shadow: 0 4px 15px rgba(0,0,0,0.2); 
  display: flex; align-items: center; gap: 10px;
}
.checkout-btn:hover:not(:disabled) { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.25); background: linear-gradient(135deg, #2d3748 0%, #1a202c 100%); }
.checkout-btn:disabled { background: #cbd5e0; cursor: not-allowed; box-shadow: none; }

/* Modal Styles */
.confirm-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.6); z-index: 2000; display: flex; align-items: center; justify-content: center; backdrop-filter: blur(4px); }
.confirm-box { background-color: #fff; padding: 40px; border-radius: 16px; box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2); text-align: center; max-width: 400px; width: 90%; animation: fadeIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); }
.confirm-box h3 { margin-top: 0; color: #1a202c; font-size: 1.5rem; font-weight: 800; }
.confirm-box p { color: #718096; margin: 15px 0 30px; font-size: 1.05rem; line-height: 1.5; }
.confirm-actions { display: flex; justify-content: center; gap: 15px; }
.modal-btn { padding: 12px 30px; border-radius: 8px; font-weight: 700; cursor: pointer; border: none; font-size: 1rem; transition: all 0.2s; }
.modal-btn.cancel { background-color: #edf2f7; color: #4a5568; }
.modal-btn.cancel:hover { background-color: #e2e8f0; color: #2d3748; }
.modal-btn.confirm { background-color: #e53e3e; color: #fff; box-shadow: 0 4px 12px rgba(229, 62, 62, 0.3); }
.modal-btn.confirm:hover { background-color: #c53030; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(229, 62, 62, 0.4); }

@keyframes fadeIn {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

@media (max-width: 768px) {
  .cart-header-row { padding: 20px; flex-direction: row; align-items: center; }
  .cart-header-row h2 { font-size: 1.4rem; }
  .cart-table-wrapper { padding: 0 15px; }
  
  .cart-table { display: block; border-spacing: 0; }
  .cart-table thead { display: none; }
  
  .cart-table tbody tr { 
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: auto auto;
    gap: 15px;
    margin-bottom: 20px; 
    padding: 20px; 
    background: #fff; 
    border-radius: 12px; 
    box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    position: relative; 
    border: 1px solid #f0f0f0;
  }

  .cart-table td { 
    display: block; 
    border: none; 
    padding: 0; 
  }
  
  /* Strict Hiding of Desktop Columns */
  .td-spec, .td-price { display: none !important; }

  /* Product Info Area */
  .td-product {
    width: 100%;
    padding-left: 0 !important;
    padding-right: 40px; /* Space for the absolute delete button */
  }
  
  .product-info-row {
    gap: 15px;
  }
  
  .thumb-wrapper {
    width: 70px;
    height: 70px;
    flex-shrink: 0;
  }
  
  .product-name {
    font-size: 1rem;
    margin-bottom: 8px; /* More space for tag */
  }
  
  /* Style mobile meta tag to look like a badge */
  .mobile-meta { 
    display: block; 
    margin-top: 4px;
  }
  .mobile-spec {
    display: inline-block; 
    background: #edf2f7; 
    color: #718096; 
    padding: 2px 8px; 
    border-radius: 12px; 
    font-size: 0.8rem; 
    font-weight: 500;
  }

  /* Controls Row: Qty and Subtotal side by side */
  .td-qty {
    display: flex;
    justify-content: space-between; /* If only one item, it floats left. If we wrapp subtotal here? No, separate cells. */
    align-items: center;
  }
  
  /* We need a row for Qty and Price. 
     Since they are separate TDs, we can't easily wrap them in a flex row unless we change HTML or use grid placement.
     Let's use grid placement on the TR.
  */
  .cart-table tbody tr {
    grid-template-columns: 1fr 1fr;
    grid-template-areas: 
      "info info"
      "qty price";
  }

  .td-qty { grid-area: qty; justify-content: flex-start; }
  .td-subtotal { grid-area: price; justify-content: flex-end; display: flex; align-items: center; }

  .price-wrapper.highlight .amount { font-size: 1.3rem; }

  /* Delete Button */
  .td-action {
    position: absolute;
    top: 15px;
    right: 15px;
    width: auto !important;
    padding: 0 !important;
    margin: 0 !important;
  }
  
  .delete-btn {
    width: 32px;
    height: 32px;
    background: #f7fafc;
    border-radius: 50%;
  }

  .cart-footer { padding: 20px; align-items: stretch; }
  .cart-actions, .address-input-group { flex-direction: column; width: 100%; align-items: stretch; gap: 15px; }
  .addr-input { width: 100%; box-sizing: border-box; }
  .checkout-btn { width: 100%; justify-content: center; }
  .continue-shop-btn { text-align: center; }
}
</style>