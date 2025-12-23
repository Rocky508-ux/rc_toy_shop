<template>
  <div class="register-page-container">
    <h2>會員註冊</h2>
    <form @submit.prevent="register">
      <div class="form-group">
        <label>姓名 <span style="color: red;">*</span></label>
        <input type="text" v-model="registerForm.name" required>
      </div>
      <div class="form-group">
        <label>電子郵件 <span style="color: red;">*</span></label>
        <input type="email" v-model="registerForm.email" required>
      </div>
      <div class="form-group">
        <label>手機 <span style="color: red;">*</span></label>
        <input type="tel" v-model="registerForm.phone" required>
      </div>
      <div class="form-group">
        <label>生日</label>
        <input type="date" v-model="registerForm.birthday" required>
      </div>
      <div class="form-group">
        <label>密碼 <span style="color: red;">*</span></label>
        <input type="password" v-model="registerForm.password" required>
      </div>
      <div class="form-group">
        <label>確認密碼 <span style="color: red;">*</span></label>
        <input type="password" v-model="registerForm.confirmPassword" required>
      </div>
      <button type="submit">註冊</button>
      <p class="login-footer">已有帳號？ <router-link to="/login">立即登入</router-link></p>
    </form>
  </div>
</template>

<script setup>
import { reactive } from 'vue';
import api from '../services/api.js'; // 引入 api service
import { useRouter } from 'vue-router'; // 引入 useRouter

// ★★★ 修改：加入 'show-notification' ★★★
const emit = defineEmits(['navigate-to-login', 'registration-notification', 'show-notification']);

const registerForm = reactive({
  name: '',
  email: '',
  phone: '',
  birthday: '',
  password: '',
  confirmPassword: ''
});

const router = useRouter(); // 初始化 router

async function register() {
  if (registerForm.password !== registerForm.confirmPassword) {
    emit('show-notification', '密碼不一致！');
    return;
  }

  try {
    // 呼叫後端註冊 API
    // 注意：後端 User Model 欄位需要與這裡匹配 (例如 name, email, password 等)
    await api.register({
      name: registerForm.name,
      email: registerForm.email,
      phone: registerForm.phone,
      birthday: registerForm.birthday, // 確保格式為 YYYY-MM-DD，HTML date input 預設即為此格式
      password: registerForm.password,
      role: 'USER', // 預設註冊為普通會員
      status: 'ACTIVE' // 預設狀態
    });

    emit('show-notification', '註冊成功！請登入');
    router.push('/login'); // 註冊成功後導向登入頁
  } catch (error) {
    console.error('註冊失敗:', error);
    // 如果後端回傳錯誤訊息，顯示出來
    const msg = error.response?.data?.message || '註冊失敗，請稍後再試。';
    emit('show-notification', msg);
  }
}
</script>

<style scoped>
/* (樣式保持不變) */
.register-page-container { width: 90%; max-width: 500px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 8px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); background: #fff; }
h2 { text-align: center; margin-bottom: 20px; }
.form-group { margin-bottom: 15px; }
.form-group label { display: block; margin-bottom: 5px; }
.form-group input { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
button { width: 100%; padding: 10px; background-color: #42b983; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
button:hover { background-color: #369f72; }
.login-footer { text-align: center; margin-top: 15px; }
.login-footer a { color: #42b983; cursor: pointer; text-decoration: none; }
.login-footer a:hover { text-decoration: underline; }
</style>