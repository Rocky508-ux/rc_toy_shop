<template>
  <div class="admin-card">
    <div class="header">
      <h1>訂單管理</h1>
    </div>
    <div class="admin-table-wrapper">
      <table class="admin-table">
        <thead>
          <tr>
            <th>訂單編號</th>
            <th>顧客</th>
            <th>日期</th>
            <th>總金額</th>
            <th>狀態</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="order in orders" :key="order.id">
            <td>{{ order.id }}</td>
            <td>User ID: {{ order.userId }}</td>
            <td>{{ order.orderDate ? new Date(order.orderDate).toLocaleString() : '' }}</td>
            <td>NT$ {{ order.totalAmount?.toLocaleString() }}</td>
            <td>
              <select v-model="order.status" @change="updateStatus(order)" class="styled-select">
                <option value="處理中">處理中</option>
                <option value="已出貨">已出貨</option>
                <option value="已送達">已送達</option>
                <option value="已取消">已取消</option>
              </select>
            </td>
            <td class="actions">
              <button class="admin-btn view-btn" @click="viewOrder(order)">查看詳情</button>
            </td>
          </tr>
          <tr v-if="orders.length === 0">
            <td colspan="6" style="text-align: center; padding: 20px;">目前沒有訂單</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="showDetailModal" class="modal-overlay" @click.self="closeDetailModal">
      <div class="modal-content">
        <h2>訂單詳情 #{{ selectedOrder?.id }}</h2>
        <div class="order-details">
          <p><strong>User ID:</strong> {{ selectedOrder?.userId }}</p>
          <p><strong>日期:</strong> {{ selectedOrder?.orderDate ? new Date(selectedOrder.orderDate).toLocaleString() : '' }}</p>
          <p><strong>總金額:</strong> NT$ {{ selectedOrder?.totalAmount?.toLocaleString() }}</p>
          <p><strong>狀態:</strong> <span :class="['status-badge', selectedOrder?.status]">{{ selectedOrder?.status }}</span></p>
          <h3>訂購商品:</h3>
          <ul class="order-items-list">
            <li v-for="item in selectedOrder?.items" :key="item.productId">
              {{ item.productName }} (x{{ item.quantity }}) - NT$ {{ item.price.toLocaleString() }}
            </li>
          </ul>
        </div>
        <div class="modal-actions">
          <button type="button" class="admin-btn cancel-btn" @click="closeDetailModal">關閉</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onActivated } from 'vue';
import api from '../../services/api.js';

const orders = ref([]);
const showDetailModal = ref(false);
const selectedOrder = ref(null);

// Define emits
const emit = defineEmits(['show-notification']);

const fetchOrders = async () => {
  try {
    const response = await api.getOrders();
    console.log("Admin Orders Response:", response.data); // Debug log
    orders.value = response.data;
  } catch (error) {
    console.error("目前無法獲取訂單列表:", error);
    // 這裡通常是讀取失敗，也許不需要 notification，或者顯示 error toast
    emit('show-notification', "無法獲取訂單列表");
  }
};

onMounted(fetchOrders);
// 因為 Admin.vue 使用了 keep-alive，所以切換回來時要用 onActivated 重新抓取資料
onActivated(fetchOrders);

// 狀態現在直接儲存中文，無需映射
const formatStatus = (status) => status;

// ... existing code ...

const updateStatus = async (order) => {
  try {
    await api.updateOrder(order.id, { status: order.status });
    console.log(`訂單 ${order.id} 狀態已更新為 ${order.status}`);
    emit('show-notification', `訂單 #${order.id} 狀態更新成功！`);
  } catch (error) {
    console.error(`更新訂單 ${order.id} 失敗:`, error);
    emit('show-notification', "更新失敗，請稍後再試");
    fetchOrders(); 
  }
};

const viewOrder = (order) => {
  console.log("Viewing order:", order);
  selectedOrder.value = order;
  showDetailModal.value = true;
};

const closeDetailModal = () => {
  showDetailModal.value = false;
  selectedOrder.value = null;
};
</script>

<style scoped>
.order-details p {
  margin: 8px 0;
  line-height: 1.6;
  display: flex; /* Align items vertically */
  align-items: center; /* Center badge vertically with text */
  gap: 10px;
}
.order-details h3 {
  margin-top: 20px;
  margin-bottom: 10px;
  border-bottom: 1px solid #eee;
  padding-bottom: 5px;
}
.order-items-list {
  list-style-type: none;
  padding-left: 0;
}
.order-items-list li {
  padding: 8px;
  background-color: #f9f9f9;
  border-radius: 4px;
  margin-bottom: 5px;
}
</style>