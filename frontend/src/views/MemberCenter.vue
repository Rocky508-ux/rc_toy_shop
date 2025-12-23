<template>
  <div class="member-center-container">
    <h2 class="page-title">會員中心</h2>

    <!-- 會員資訊 -->
    <div class="member-section">
      <h3 class="section-title">會員資訊</h3>
      <div v-if="!isEditing" class="info-grid">
        <div class="info-item"><label>姓名</label><p>{{ userInfo.name }}</p></div>
        <div class="info-item"><label>電子郵件</label><p>{{ userInfo.email }}</p></div>
        <div class="info-item"><label>手機</label><p>{{ userInfo.phone }}</p></div>
        <div class="info-item"><label>生日</label><p>{{ userInfo.birthday }}</p></div>
      </div>
      <form v-else @submit.prevent="saveUserInfo" class="info-grid">
        <div class="info-item"><label for="name">姓名</label><input id="name" type="text" v-model="editableUserInfo.name" required></div>
        <div class="info-item"><label for="email">電子郵件</label><input id="email" type="email" v-model="editableUserInfo.email" required></div>
        <div class="info-item"><label for="phone">手機</label><input id="phone" type="tel" v-model="editableUserInfo.phone" required></div>
        <div class="info-item"><label for="birthday">生日</label><input id="birthday" type="date" v-model="editableUserInfo.birthday" required></div>
      </form>
      <div class="section-actions">
        <button v-if="!isEditing" @click="startEditing" class="action-btn">編輯資料</button>
        <template v-else>
          <button @click="cancelEditing" class="action-btn secondary">取消</button>
          <button @click="saveUserInfo" class="action-btn primary">儲存變更</button>
        </template>
      </div>
    </div>

    <!-- 修改密碼 -->
    <div class="member-section">
      <h3 class="section-title">修改密碼</h3>
      <form @submit.prevent="changePassword" class="password-form">
        <div class="form-group"><label for="current-password">目前密碼</label><input type="password" id="current-password" v-model="passwords.current" required></div>
        <div class="form-group"><label for="new-password">新密碼</label><input type="password" id="new-password" v-model="passwords.new" required></div>
        <div class="form-group"><label for="confirm-password">確認新密碼</label><input type="password" id="confirm-password" v-model="passwords.confirm" required></div>
        <div class="section-actions"><button type="submit" class="action-btn primary">更新密碼</button></div>
      </form>
    </div>

    <!-- 訂單查詢 -->
    <div class="member-section">
      <h3 class="section-title">訂單查詢</h3>
      <p>點擊下方按鈕查看您的歷史訂單紀錄。</p>
      <div class="section-actions"><router-link to="/orders" class="action-btn">查看訂單</router-link></div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, watch, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '@/services/api';

const props = defineProps({
  isLoggedIn: Boolean
});

const emit = defineEmits(['show-notification']);

const router = useRouter();
const isEditing = ref(false);

// 使用 ref 而不是 reactive，因為我們要從 API 替換整個物件
const userInfo = ref({
  name: '',
  email: '',
  phone: '', // 後端 User model 目前沒有 phone，這裡可能會是 undefined，需注意
  birthday: '' // 同上
});

const editableUserInfo = reactive({});

const passwords = reactive({
  current: '',
  new: '',
  confirm: ''
});

function checkLoginStatus() {
  const token = localStorage.getItem('authToken');
  const userId = localStorage.getItem('userId');
  if (!token || !userId) {
     return false;
  }
  return true;
}

async function fetchUserInfo() {
  const userId = localStorage.getItem('userId');
  if (!userId) {
    // 如果沒有 userId，可能是舊的 Session，提示重新登入
    emit('show-notification', '偵測到過期的登入狀態，請重新登入以獲取資料。');
    // 稍微延遲後登出
    setTimeout(() => {
        localStorage.clear();
        router.push('/login');
    }, 1500);
    return;
  }

  try {
    const response = await api.getUserProfile(userId);
    userInfo.value = response.data;
  } catch (error) {
    console.error("無法獲取會員資料:", error);
    emit('show-notification', '無法獲取會員資料，請稍後再試');
  }
}

onMounted(() => {
  checkLoginStatus();
  if (props.isLoggedIn) {
     fetchUserInfo();
  }
});

function startEditing() {
  Object.assign(editableUserInfo, userInfo.value);
  isEditing.value = true;
}

async function saveUserInfo() {
  const userId = localStorage.getItem('userId');
  
  // 驗證邏輯
  const phonePattern = /^09\d{8}$|^0\d{1,2}-?\d{6,8}$/;
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  
  if (!editableUserInfo.name || editableUserInfo.name.trim().length < 2) {
      emit('show-notification', '姓名請至少輸入 2 個字');
      return;
  }
  
  if (!emailPattern.test(editableUserInfo.email)) {
      emit('show-notification', '電子郵件格式不正確');
      return;
  }
  
  if (!phonePattern.test(editableUserInfo.phone)) {
      emit('show-notification', '手機號碼格式錯誤 (範例: 0912345678)');
      return;
  }
  
  // 檢查生日是否在未來
  const today = new Date();
  const birthDate = new Date(editableUserInfo.birthday);
  if (birthDate > today) {
      emit('show-notification', '生日不可以是未來日期！');
      return;
  }

  try {
    await api.updateUserProfile(userId, editableUserInfo);
    // ... rest of the function
    // 更新本地顯示
    userInfo.value = { ...editableUserInfo };
    isEditing.value = false;
    emit('show-notification', '會員資料已更新！');
  } catch (error) {
    console.error("更新失敗:", error);
    emit('show-notification', '更新失敗，請稍後再試');
  }
}

function cancelEditing() {
  isEditing.value = false;
}

async function changePassword() {
  if (passwords.new !== passwords.confirm) {
    emit('show-notification', '新密碼與確認密碼不相符！');
    return;
  }
  
  const userId = localStorage.getItem('userId');
  if (!userId) {
      emit('show-notification', '使用者 ID 遺失，請重新登入');
      return;
  }

  try {
    // 呼叫後端 API 更新密碼
    // 因為後端已經改為 Patch-style (只更新非 null 欄位)，所以只傳 password 是安全的
    await api.updateUserProfile(userId, { password: passwords.new });
    
    emit('show-notification', '密碼已成功修改！');
    passwords.current = '';
    passwords.new = '';
    passwords.confirm = '';
  } catch (error) {
    console.error("密碼修改失敗:", error);
    emit('show-notification', '密碼修改失敗，請稍後再試');
  }
}

watch(() => props.isLoggedIn, (newValue) => {
  if (!newValue) {
    checkLoginStatus();
  }
});
</script>

<style scoped>
.member-center-container { max-width: 900px; margin: 3rem auto; padding: 2.5rem; background-color: #fff; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
.page-title { text-align: center; margin-bottom: 2.5rem; font-size: 2.2rem; color: #333; font-weight: 700; letter-spacing: 1px; }
.member-section { margin-bottom: 3rem; padding-bottom: 2rem; border-bottom: 1px solid #f0f0f0; }
.member-section:last-child { border-bottom: none; margin-bottom: 0; }
.section-title { font-size: 1.4rem; margin-bottom: 1.5rem; color: #4285F4; border-left: 5px solid #4285F4; padding-left: 15px; }
.info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 2rem; }
.info-item label, .form-group label { font-weight: 600; color: #444; display: block; margin-bottom: 0.8rem; font-size: 1.1rem; }
.info-item p { background-color: #f8f9fa; padding: 1rem 1.2rem; border-radius: 8px; border: 1px solid #e9ecef; margin: 0; font-size: 1.2rem; color: #333; min-height: 25px; }
.info-item input, .form-group input { width: 100%; padding: 1rem 1.2rem; border: 1px solid #ced4da; border-radius: 8px; font-size: 1.2rem; box-sizing: border-box; transition: border-color 0.2s; }
.info-item input:focus, .form-group input:focus { border-color: #4285F4; outline: none; box-shadow: 0 0 0 3px rgba(66, 133, 244, 0.15); }
.password-form .form-group { margin-bottom: 1.8rem; }
.section-actions { margin-top: 2rem; text-align: center; display: flex; justify-content: center; gap: 15px; }
.section-actions > .action-btn:only-child, .section-actions > .router-link.action-btn:only-child { width: auto; min-width: 200px; }
.action-btn { padding: 0.8rem 2rem; border-radius: 8px; border: none; cursor: pointer; font-weight: 600; font-size: 1.1rem; transition: all 0.3s ease; background-color: #6c757d; color: white; text-decoration: none; display: inline-block; text-align: center; box-sizing: border-box; }
.action-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
.action-btn.primary { background-color: #4285F4; }
.action-btn.primary:hover { background-color: #3367d6; }
.action-btn.secondary { background-color: #ff5252; }
.action-btn.secondary:hover { background-color: #ff1744; }
</style>
