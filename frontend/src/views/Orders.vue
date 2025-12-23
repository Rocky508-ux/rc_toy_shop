<template>
  <section class="content-section">
    <h2 class="section-title">我的訂單</h2>
    <div class="order-list">
      <div class="order-card" v-for="order in orders" :key="order.id">
        <!-- 訂單頭部：編號、日期、狀態 -->
        <div class="order-header">
          <div class="order-meta">
            <h3 class="order-id">
              <span class="label">訂單編號</span>
              {{ order.id }}
            </h3>
            <span class="order-date">{{ formatDate(order.orderDate || order.date) }}</span>
          </div>
          <span class="status-badge" :class="getStatusClass(order.status)">
            {{ translateStatus(order.status) }}
          </span>
        </div>

        <!-- 訂單明細列表 -->
        <div class="order-items-container" v-if="order.items && order.items.length > 0">
          <div class="order-item-row" v-for="item in order.items" :key="item.id">
            <div class="item-info">
              <span class="product-name">{{ item.productName }}</span>
            </div>
            <div class="item-meta">
              <span class="item-qty">x{{ item.quantity }}</span>
              <span class="item-price">NT$ {{ (item.price || 0).toLocaleString() }}</span>
            </div>
          </div>
        </div>
        <div v-else class="no-items">
          <small>無商品明細顯示 (可能是舊訂單或資料異常)</small>
        </div>

        <!-- 訂單底部：總金額 -->
        <div class="order-footer">
          <div class="total-row">
            <span class="label">訂單金額</span>
            <span class="total-amount">NT$ {{ (order.totalAmount || order.amount || 0).toLocaleString() }}</span>
          </div>
        </div>
      </div>

      <!-- 無訂單狀態 -->
      <div v-if="!orders || orders.length === 0" class="empty-state">
        <div class="empty-icon">📦</div>
        <p>目前沒有訂單紀錄</p>
        <router-link to="/" class="go-shopping-btn">去逛逛</router-link>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '../services/api.js';

const orders = ref([]);

onMounted(async () => {
  try {
    const userId = localStorage.getItem('userId');
    if (!userId) {
      return;
    }
    const response = await api.getUserOrders(userId);
    orders.value = response.data;
  } catch (error) {
    console.error("無法獲取訂單列表:", error);
  }
});

function formatDate(dateString) {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleString('zh-TW', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  });
}

function translateStatus(status) {
  const map = {
    'PENDING': '處理中',
    'COMPLETED': '已完成',
    'SHIPPED': '已出貨',
    'CANCELLED': '已取消'
  };
  return map[status] || status;
}

function getStatusClass(status) {
  // 對應 CSS class
  const map = {
    'PENDING': 'pending',
    'COMPLETED': 'completed',
    'SHIPPED': 'shipping',
    'CANCELLED': 'cancelled'
  };
  return map[status] || 'pending';
}
</script>

<style scoped>
.content-section {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
  background: transparent !important; /* Override global white bg */
  border: none !important;
  box-shadow: none !important;
}

.section-title {
  margin-bottom: 25px;
  font-size: 1.8rem;
  color: #333;
  border-left: 5px solid #333;
  padding-left: 15px;
}

.order-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.order-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.05);
  border: 1px solid #f0f0f0;
  overflow: hidden;
  transition: transform 0.2s, box-shadow 0.2s;
}

.order-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0,0,0,0.08);
}

/* Header */
.order-header {
  padding: 15px 25px;
  background: linear-gradient(90deg, #2d3748 0%, #4a5568 100%);
  border-bottom: none;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.order-meta {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.order-id {
  margin: 0;
  font-size: 1.1rem;
  color: #fff;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
  letter-spacing: 0.5px;
}

.order-id .label {
  font-size: 0.75rem;
  color: #e2e8f0;
  font-weight: 500;
  background: rgba(255, 255, 255, 0.2);
  padding: 2px 8px;
  border-radius: 4px;
}

.order-date {
  font-size: 0.85rem;
  color: #a0aec0;
}

.status-badge {
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 600;
  letter-spacing: 0.5px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.status-badge.pending { background: #fff3cd; color: #856404; }
.status-badge.completed { background: #d4edda; color: #155724; }
.status-badge.shipping { background: #cce5ff; color: #004085; }
.status-badge.cancelled { background: #f8d7da; color: #721c24; }

/* Item List */
.order-items-container {
  padding: 10px 25px;
  background: #f8fafc; /* Subtle colored background */
}

.order-item-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #edf2f7;
}

.order-item-row:last-child {
  border-bottom: none;
}

.product-name {
  font-weight: 600;
  color: #2d3748;
  font-size: 0.95rem;
}

.item-meta {
  display: flex;
  align-items: center;
  gap: 20px;
}

.item-qty {
  color: #718096;
  font-size: 0.9rem;
  background: #fff;
  border: 1px solid #e2e8f0;
  padding: 2px 10px;
  border-radius: 12px;
}

.item-price {
  font-weight: 700;
  color: #4a5568;
  min-width: 80px;
  text-align: right;
  font-family: 'Roboto', sans-serif;
}

.no-items {
  padding: 15px 25px;
  color: #bbb;
  font-style: italic;
  background: #f8fafc;
}

/* Footer */
.order-footer {
  padding: 15px 25px;
  background: #fff;
  border-top: 1px solid #edf2f7;
  display: flex;
  justify-content: flex-end;
}

.total-row {
  display: flex;
  align-items: baseline;
  gap: 15px;
}

.total-row .label {
  font-size: 0.95rem;
  color: #718096;
  font-weight: 500;
}

.total-amount {
  font-size: 1.5rem;
  font-weight: 800;
  color: #e53e3e;
  font-family: 'Roboto', sans-serif;
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 60px 20px;
  background: #fff;
  border-radius: 12px;
  border: 1px dashed #e2e8f0;
  box-shadow: 0 4px 6px rgba(0,0,0,0.02);
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 15px;
  opacity: 0.5;
  filter: grayscale(100%);
}

.empty-state p {
  color: #718096;
  font-size: 1.1rem;
  margin-bottom: 25px;
}

.go-shopping-btn {
  display: inline-block;
  padding: 12px 35px;
  background: linear-gradient(135deg, #1a202c 0%, #2d3748 100%);
  color: #fff;
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.3s;
  font-weight: 600;
  box-shadow: 0 4px 10px rgba(0,0,0,0.15);
}

.go-shopping-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(0,0,0,0.2);
  background: linear-gradient(135deg, #2d3748 0%, #1a202c 100%);
}
</style>