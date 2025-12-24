<script setup>
import { ref, onMounted } from 'vue'; // 引入 onMounted
import { useRouter, useRoute } from 'vue-router'; // 引入 useRoute
import api from '../services/api.js'; // 引入 api service

const router = useRouter();
const route = useRoute(); // 取得路由資訊
const emit = defineEmits(['login-success', 'show-notification']);

const email = ref('');
const password = ref('');
const errorMessage = ref('');

// ★★★ 新增：檢查是否有路由轉址帶來的訊息 ★★★
onMounted(() => {
  if (route.query.msg) {
    // 發出通知事件，讓 App.vue 顯示 Toast
    emit('show-notification', route.query.msg);
  }
});

const handleLogin = async () => {
  errorMessage.value = '';
  try {
    const response = await api.login({ // 使用 api.login
      email: email.value,
      password: password.value
    });

    // 3. 從後端取得 Token 與使用者資訊
    const { token, user } = response.data;
    
    // 4. 儲存 JWT Token (取代原本的 dummy token)
    localStorage.setItem('authToken', token); 
    
    // 5. 儲存使用者資訊
    localStorage.setItem('userRole', user.role);
    localStorage.setItem('userName', user.name);
    localStorage.setItem('userId', user.id); 

    emit('login-success');
    emit('show-notification', `歡迎回來，${user.name}！登入成功`);

    if (user.role === 'ADMIN') {
      router.push('/admin');
    } else {
      router.push('/');
    }
  } catch (error) {
    console.error('登入失敗:', error);
    if (error.response) {
      if (error.response.status === 401) {
        errorMessage.value = '帳號或密碼錯誤';
      } else if (error.response.status === 403) {
        // ★★★ 處理帳號停用 (Backend 回傳 403) ★★★
        errorMessage.value = error.response.data; // 直接顯示後端傳來的 "帳戶已被停用,請聯繫管理員"
      } else {
        errorMessage.value = `登入失敗 (${error.response.status}): ${error.response.data || error.message}`;
      }
    } else if (error.request) {
      errorMessage.value = '無法連接到伺服器 (Network Error)，請檢查後端是否已啟動。';
    } else {
      errorMessage.value = `發生錯誤: ${error.message}`;
    }
  }
};
</script>

<template>
  <div class="login-container">
    <h2>會員登入</h2>
    <form @submit.prevent="handleLogin" class="login-form">
      <div class="form-group">
        <label for="email">Email</label>
        <input type="email" id="email" v-model="email" required />
      </div>
      <div class="form-group">
        <label for="password">密碼</label>
        <input type="password" id="password" v-model="password" required />
      </div>
      <button type="submit" class="buy-btn" style="width: 100%;">登入</button>
      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
      <p class="login-footer">還沒有帳號嗎？<router-link to="/register">立即註冊</router-link></p>
    </form>
    
    <!-- dev-hint removed -->
  </div>
</template>

<style scoped>
/* (樣式保持不變) */
.login-container { width: 90%; max-width: 500px; margin: 50px auto; padding: 30px; border: 1px solid #e0e0e0; border-radius: 8px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); background: #fff; }
h2 { text-align: center; margin-bottom: 25px; font-size: 1.5rem; color: #333; font-weight: 700; }
.form-group { margin-bottom: 20px; }
.form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #555; font-size: 0.95rem; }
.form-group input { width: 100%; padding: 10px 12px; box-sizing: border-box; border: 1px solid #ddd; border-radius: 6px; font-size: 1rem; transition: border-color 0.3s; }
.form-group input:focus { border-color: #4285F4; outline: none; }
button { width: 100%; padding: 12px; background-color: #4285F4; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 1rem; font-weight: 700; transition: background-color 0.3s, transform 0.2s; margin-top: 10px; }
button:hover { background-color: #3367d6; transform: translateY(-1px); box-shadow: 0 2px 5px rgba(66, 133, 244, 0.3); }
.error-message { color: #d93025; text-align: center; margin-top: 15px; font-size: 0.9rem; background-color: #fce8e6; padding: 8px; border-radius: 4px; }
.login-footer { text-align: center; margin-top: 20px; color: #666; font-size: 0.95rem; }
.login-footer a { color: #42b983; cursor: pointer; text-decoration: none; font-weight: 700; margin-left: 5px; }
.login-footer a:hover { text-decoration: underline; }
.dev-hint { margin-top: 25px; font-size: 0.85rem; color: #666; background: #f8f9fa; padding: 15px; border-radius: 6px; border: 1px solid #eee; line-height: 1.6; }
</style>