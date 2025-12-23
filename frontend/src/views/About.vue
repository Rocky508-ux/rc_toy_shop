<script setup>
import { ref } from 'vue';

const imageError = ref(false);
const handleImageError = () => {
  imageError.value = true;
};
</script>

<template>
  <div class="static-page-container">
    <div class="content-wrapper">
      <h1>關於我們 (About Us)</h1>
      
      <div class="about-section">
        <div class="about-image">
           <!-- 嘗試讀取使用者上傳的圖片 -->
           <img :src="'/image/about.jpg'" alt="About RC Toy Shop" class="real-image" @error="handleImageError" v-show="!imageError" />
           
           <!-- 圖片讀取失敗時顯示的替代內容 -->
           <div class="placeholder-box" v-show="imageError">
             <span>RC玩童</span>
             <p class="upload-hint">(請上傳 about.jpg 至圖片資料夾)</p>
           </div>
        </div>
        <div class="about-text">
          <h2>歡迎來到 RC玩童</h2>
          <p>
            我們是一群熱愛 GK 模型與收藏玩偶的愛好者。
            成立於 2024 年，致力於為台灣的收藏家提供最優質、最安心的購買平台。
          </p>
          <p>
            無論是熱門的鋼彈模型、精緻的動漫公仔，還是稀有的 GK 雕像，我們都嚴格把關，確保您收到的每一件商品都是正品。
          </p>
        </div>
      </div>

      <div class="values-section">
        <div class="value-item">
          <h3>💯 正品保證</h3>
          <p>全館商品皆為官方授權或正規代理，絕無盜版。</p>
        </div>
        <div class="value-item">
          <h3>📦 專業包裝</h3>
          <p>我們深知收藏品的重要性，使用加厚紙箱與氣泡防護，確保長途運輸安全。</p>
        </div>
        <div class="value-item">
          <h3>💬 售後服務</h3>
          <p>提供完善的退換貨機制與線上客服，讓您買得放心。</p>
        </div>
      </div>

    </div>
  </div>
</template>

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

.about-section {
  display: flex;
  gap: 40px;
  margin-bottom: 50px;
  align-items: center;
}

.about-image {
  flex: 1;
  height: 300px;
  background-color: #f5f5f5;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden; /* Ensure image fits */
  position: relative;
}

.real-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.placeholder-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.placeholder-box span {
  font-size: 2rem;
  font-weight: 900;
  color: #ccc;
  letter-spacing: 2px;
}

.upload-hint {
  margin-top: 10px;
  font-size: 0.9rem;
  color: #999;
}

.about-text {
  flex: 1.5;
}

.about-text h2 {
  font-size: 1.5rem;
  color: #1976D2;
  margin-bottom: 20px;
}

.about-text p {
  line-height: 1.8;
  color: #555;
  margin-bottom: 15px;
  font-size: 1.05rem;
}

.values-section {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 30px;
  margin-top: 40px;
  padding-top: 40px;
  border-top: 1px solid #eee;
}

.value-item {
  text-align: center;
  padding: 20px;
  background: #f9f9f9;
  border-radius: 8px;
  transition: transform 0.3s;
}

.value-item:hover {
  transform: translateY(-5px);
}

.value-item h3 {
  font-size: 1.2rem;
  color: #333;
  margin-bottom: 15px;
}

.value-item p {
  color: #666;
  line-height: 1.6;
}

@media (max-width: 768px) {
  .about-section {
    flex-direction: column;
  }
  .values-section {
    grid-template-columns: 1fr;
  }
}
</style>
