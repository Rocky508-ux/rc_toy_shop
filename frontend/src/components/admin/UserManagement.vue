<template>
  <div class="admin-card">
    <div class="header">
      <h1>用戶管理</h1>
      <button class="add-btn admin-btn" @click="openAddModal">新增用戶</button>
    </div>
    <div class="admin-table-wrapper">
      <table class="admin-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>名稱</th>
            <th>Email</th>
            <th>註冊日期</th>
            <th>狀態</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in filteredUsers" :key="user.id">
            <td>{{ user.id }}</td>
            <td>{{ user.name }}</td>
            <td>{{ user.email }}</td>
            <td>{{ user.createdAt ? new Date(user.createdAt).toLocaleDateString() : 'N/A' }}</td>
            <td>
              <span :class="['status-badge', user.status.toLowerCase()]">{{ user.status === 'ACTIVE' ? '啟用中' : '已停用' }}</span>
            </td>
            <td class="actions">
              <button class="history-btn admin-btn" @click="viewPurchaseHistory(user)">紀錄</button>
              <button class="edit-btn admin-btn" @click="openEditModal(user)">編輯</button>
              <button :class="['admin-btn', user.status === 'ACTIVE' ? 'disable-btn' : 'enable-btn']" @click="toggleStatus(user)">
                {{ user.status === 'ACTIVE' ? '停用' : '啟用' }}
              </button>
              <button class="delete-btn admin-btn" @click="deleteUser(user.id)">刪除</button>
            </td>
          </tr>
          <tr v-if="users.length === 0">
            <td colspan="6" style="text-align: center; padding: 20px;">目前沒有用戶</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <h2>{{ isEditMode ? '編輯用戶' : '新增用戶' }}</h2>
        <form @submit.prevent="saveUser">
          <div class="form-group">
            <label for="userName">名稱:</label>
            <input type="text" id="userName" v-model="editedUser.name" required />
          </div>
          <div class="form-group">
            <label for="userEmail">Email:</label>
            <input type="email" id="userEmail" v-model="editedUser.email" required />
          </div>
          <!-- 註冊日期自動產生，無需手動輸入 -->
          <div class="modal-actions">
            <button type="button" class="admin-btn cancel-btn" @click="closeModal">取消</button>
            <button type="submit" class="admin-btn save-btn">儲存</button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="showHistoryModal" class="modal-overlay" @click.self="closeHistoryModal">
      <div class="modal-content" style="max-width: 800px;">
        <h2>{{ selectedUser?.name }} 的購買紀錄</h2>
        <div v-if="userOrders.length" class="admin-table-wrapper">
          <table class="admin-table">
            <thead>
              <tr>
                <th>訂單ID</th>
                <th>日期</th>
                <th>總金額</th>
                <th>狀態</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="order in userOrders" :key="order.id">
                <td>{{ order.id }}</td>
                <td>{{ order.orderDate ? new Date(order.orderDate).toLocaleDateString() : 'N/A' }}</td>
                <td>NT$ {{ order.totalAmount.toLocaleString() }}</td>
                <td>
                  <span :class="['status-badge', order.status]">{{ order.status }}</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <p v-else>該用戶沒有購買紀錄。</p>
        <div class="modal-actions">
          <button type="button" class="admin-btn cancel-btn" @click="closeHistoryModal">關閉</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import api from '../../services/api.js';

const users = ref([]);
const filteredUsers = ref([]); // Store filtered users

// ...

const fetchUsers = async () => {
  try {
    const response = await api.getUsers();
    users.value = response.data;
    
    // Filter out current user
    const currentUserId = parseInt(localStorage.getItem('userId'), 10);
    if (!isNaN(currentUserId)) {
      filteredUsers.value = users.value.filter(u => u.id !== currentUserId);
    } else {
      filteredUsers.value = users.value;
    }
  } catch (error) {
    console.error("無法獲取用戶列表:", error);
  }
};
const showModal = ref(false); // Add showModal ref
const isEditMode = ref(false);

const editedUser = reactive({
    id: null, name: '', email: '', registeredDate: '', status: 'ACTIVE'
  });
const openAddModal = () => {
  isEditMode.value = false;
  Object.assign(editedUser, {
    id: null,
    name: '',
    email: '',
    status: 'ACTIVE'
  });
  showModal.value = true;
};

onMounted(() => {
  fetchUsers();
});

const openEditModal = (user) => {
  isEditMode.value = true;
  Object.assign(editedUser, JSON.parse(JSON.stringify(user)));
  showModal.value = true;
};

// History Modal Refs
const showHistoryModal = ref(false);
const selectedUser = ref(null);
const userOrders = ref([]);

const saveUser = async () => {
  try {
    const dataToSend = { ...editedUser };
    if (isEditMode.value) {
      await api.updateUser(dataToSend.id, dataToSend);
    } else {
      // Create logic needs password. For now, assuming backend handles or we add input later.
      if (!dataToSend.password) dataToSend.password = "123456"; // Default for admin-created users
      
      delete dataToSend.id; 
      await api.createUser(dataToSend);
    }
    closeModal();
    await fetchUsers();
    emit('show-notification', isEditMode.value ? '用戶更新成功' : '用戶新增成功');
  } catch (error) {
    console.error("儲存用戶失敗:", error);
    emit('show-notification', "儲存失敗: " + (error.response?.data || error.message));
  }
};

const deleteUser = async (userId) => {
  if (confirm('確定要刪除此用戶嗎？此操作無法復原。')) {
    try {
      await api.deleteUser(userId);
      await fetchUsers();
      emit('show-notification', '用戶已刪除');
    } catch (error) {
      console.error("刪除用戶失敗:", error);
      emit('show-notification', "刪除失敗: " + (error.response?.data || error.message));
    }
  }
};

const closeModal = () => {
  showModal.value = false;
};

const toggleStatus = async (user) => {
  const newStatus = user.status === 'ACTIVE' ? 'DISABLED' : 'ACTIVE';
  if (confirm(`確定要將用戶 "${user.name}" 的狀態改為 "${newStatus === 'ACTIVE' ? '啟用' : '停用'}" 嗎？`)) {
    try {
      await api.updateUser(user.id, { ...user, status: newStatus });
      await fetchUsers();
      emit('show-notification', `用戶 "${user.name}" 已${newStatus === 'ACTIVE' ? '啟用' : '停用'}`);
    } catch (error) {
      console.error("更新用戶狀態失敗:", error);
      emit('show-notification', "更新狀態失敗");
    }
  }
};

const viewPurchaseHistory = async (user) => {
  selectedUser.value = user;
  showHistoryModal.value = true;
  userOrders.value = []; 
  try {
    // FIX: 使用正確的 getUserOrders API
    const response = await api.getUserOrders(user.id);
    userOrders.value = response.data;
  } catch (error) {
    console.error("獲取用戶訂單失敗:", error);
    // 404 對於該 API 可能表示沒訂單，不應報錯
    if (error.response && error.response.status === 404) {
      userOrders.value = [];
    }
  }
};

const closeHistoryModal = () => {
  showHistoryModal.value = false;
  selectedUser.value = null;
};
</script>

<style scoped>
/* Removed unused styles */
</style>