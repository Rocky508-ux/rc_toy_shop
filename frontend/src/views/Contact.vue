<template>
  <div class="static-page-container">
    <div class="content-wrapper">
      <h1>聯絡我們 (Contact Us)</h1>

      <div class="contact-grid">
        <div class="contact-info">
          <h2>客服資訊</h2>
          <p>有任何問題嗎？歡迎隨時與我們聯繫！</p>
          
          <div class="info-item">
            <span class="icon">📍</span>
            <div class="text">
              <strong>地址</strong>
              <p>台北市XX區XX路XX號</p>
            </div>
          </div>
          
          <div class="info-item">
            <span class="icon">📞</span>
            <div class="text">
              <strong>電話</strong>
              <p>02-1234-5678</p>
            </div>
          </div>
          
          <div class="info-item">
            <span class="icon">📧</span>
            <div class="text">
              <strong>Email</strong>
              <p>support@rctoyshop.com</p>
            </div>
          </div>

          <div class="info-item">
            <span class="icon">🕒</span>
            <div class="text">
              <strong>營業時間</strong>
              <p>週一至週日 10:00 - 22:00</p>
            </div>
          </div>
          
          <div class="social-links">
            <a href="#" class="social-btn fb">Facebook</a>
            <a href="#" class="social-btn ig">Instagram</a>
            <a href="#" class="social-btn line">LINE</a>
          </div>
        </div>

        <div class="contact-form">
          <h2>留言給我們</h2>
          <form @submit.prevent="submitForm">
            <div class="form-group">
              <label for="name">姓名</label>
              <input type="text" id="name" v-model="form.name" required placeholder="請輸入您的姓名">
            </div>
            
            <div class="form-group">
              <label for="email">Email</label>
              <input type="email" id="email" v-model="form.email" required placeholder="請輸入您的 Email">
            </div>
            
            <div class="form-group">
              <label for="subject">主旨</label>
              <select id="subject" v-model="form.subject">
                <option value="訂單問題">訂單問題</option>
                <option value="商品諮詢">商品諮詢</option>
                <option value="售後服務">售後服務</option>
                <option value="其他">其他</option>
              </select>
            </div>
            
            <div class="form-group">
              <label for="message">訊息內容</label>
              <textarea id="message" v-model="form.message" rows="5" required placeholder="請詳述您的問題..."></textarea>
            </div>
            
            <button type="submit" class="submit-btn">送出訊息</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, defineEmits } from 'vue';

const emit = defineEmits(['show-notification']);

const form = reactive({
  name: '',
  email: '',
  subject: '訂單問題',
  message: ''
});

const submitForm = () => {
  // 模擬送出表單
  console.log('Form Submitted:', form);
  
  // 顯示通知 (需要 App.vue 支援 show-notification listener)
  // 如果沒有接，至少 console 驗證邏輯正確。 
  // 這裡假設是透過 emit 傳遞，如果是在 App.vue 直接監聽 router-view 的 event 需要確保串接。
  alert(`感謝您的聯繫，${form.name}！我們會盡快回覆您。\n(此為展示功能，表單未實際上傳)`);
  
  // 清空表單
  form.name = '';
  form.email = '';
  form.message = '';
};
</script>

<style scoped>
.static-page-container {
  max-width: 1000px;
  margin: 40px auto;
  padding: 0 20px;
}

.content-wrapper {
  background: #fff;
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

h1 {
  text-align: center;
  margin-bottom: 40px;
  font-size: 2rem;
  color: #333;
  font-weight: 700;
}

.contact-grid {
  display: grid;
  grid-template-columns: 1fr 1.5fr;
  gap: 50px;
}

.contact-info h2, .contact-form h2 {
  font-size: 1.3rem;
  color: #1976D2;
  margin-bottom: 25px;
  font-weight: 600;
  border-bottom: 2px solid #f0f0f0;
  padding-bottom: 10px;
}

/* Info Items */
.info-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 25px;
}

.info-item .icon {
  font-size: 1.5rem;
  margin-right: 15px;
  background: #e3f2fd;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
}

.info-item .text strong {
  display: block;
  font-size: 0.95rem;
  color: #333;
  margin-bottom: 4px;
}

.info-item .text p {
  color: #666;
  font-size: 1rem;
}

/* Social Links */
.social-links {
  display: flex;
  gap: 10px;
  margin-top: 30px;
}

.social-btn {
  flex: 1;
  text-align: center;
  padding: 10px;
  border-radius: 6px;
  text-decoration: none;
  font-weight: 700;
  color: white;
  transition: opacity 0.3s;
}

.social-btn:hover {
  opacity: 0.9;
}

.fb { background-color: #1877f2; }
.ig { background-color: #e4405f; }
.line { background-color: #00c300; }

/* Form Styles */
.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
  color: #555;
  font-size: 0.95rem;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  border-color: #1976D2;
  outline: none;
}

.submit-btn {
  width: 100%;
  padding: 14px;
  background-color: #1976D2;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submit-btn:hover {
  background-color: #1565C0;
}

@media (max-width: 768px) {
  .contact-grid {
    grid-template-columns: 1fr;
    gap: 30px;
  }
}
</style>
