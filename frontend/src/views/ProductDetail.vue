<template>
  <div v-if="product" class="product-detail-container">
    <div class="detail-layout">
      <div class="image-section">
        <div class="main-image-container">
          <img v-if="currentImage" :src="currentImage.imagePath" :alt="product.name" class="main-image" />
          <div v-else class="placeholder-image">暫無圖片</div>
        </div>
        
        <div class="thumbnail-list" v-if="allImages.length > 1">
          <div 
            v-for="(img, index) in allImages" 
            :key="img.id" 
            class="thumbnail-item"
            :class="{ 'active': index === currentImageIndex }"
            @click="currentImageIndex = index"
          >
            <img :src="img.imagePath" :alt="product.name + ' 縮圖'" />
          </div>
        </div>
      </div>

      <div class="info-section">
        <h1 class="product-title">{{ product.name }}</h1>
        <p class="product-studio" v-if="product.studio">{{ product.studio }} 工作室</p>
        
        <div class="price-box">
          <span class="currency">NT$</span>
          <span class="amount">{{ product.price.toLocaleString() }}</span>
        </div>

        <div class="specs-card">
          <div class="spec-row" v-if="product.scale">
            <span class="spec-label">比例</span>
            <span class="spec-value">{{ product.scale }}</span>
          </div>
          <div class="spec-row" v-if="product.dimensions">
            <span class="spec-label">尺寸</span>
            <span class="spec-value">{{ product.dimensions }}</span>
          </div>
          <div class="spec-row" v-if="product.material">
            <span class="spec-label">材質</span>
            <span class="spec-value">{{ product.material }}</span>
          </div>
          <div class="spec-row highlight" v-if="product.estimatedArrival">
            <span class="spec-label">預計出貨</span>
            <span class="spec-value">{{ product.estimatedArrival }}</span>
          </div>
        </div>

        <div class="features-section" v-if="product.features && product.features.length > 0">
          <h4>【商品特色】</h4>
          <ul class="features-list">
            <li v-for="(feature, index) in product.features" :key="index">
              {{ feature }}
            </li>
          </ul>
        </div>

        <div class="description-section">
          <h4>【商品簡介】</h4>
          <p class="product-description">{{ product.description }}</p>
        </div>

        <div class="important-note" v-if="product.note">
          <strong>⚠️ 注意事項：</strong> {{ product.note }}
        </div>

        <div class="action-buttons">
          <button class="add-cart-btn" @click="$emit('add-to-cart', product)">加入購物車</button>
        </div>
      </div>
    </div>

    <div class="common-policy">
      <div class="policy-block">
        <h3>📦 購買須知</h3>
        <p>1. 預購商品發售日僅供參考，實際出貨時間以原廠/工作室為準，可能會有延期狀況。</p>
        <p>2. 圖片僅供參考，實際商品可能會有細微差異 (塗裝、色差等)，請以實物為準。</p>
        <p>3. GK商品多為易碎材質，運送途中難免有風險，開箱請務必<strong>全程錄影</strong>以保障權益。</p>
      </div>
      <div class="policy-block">
        <h3>🚚 運送說明</h3>
        <p>1. 現貨商品下單後約 1-3 個工作天內出貨。</p>
        <p>2. 大型GK商品體積較大，運費將依實際材積計算，可能需分箱寄送。</p>
      </div>
      <div class="policy-block">
        <h3>🛡️ 售後服務</h3>
        <p>收到商品後若有嚴重缺件或斷裂，請於 7 日內聯繫客服並提供開箱影片，我們將協助向工作室申請補件或維修。</p>
      </div>
    </div>
    
    <router-link to="/" class="back-link">← 返回商品列表</router-link>
  </div>
  
  <div v-else class="not-found">
    <h2>很抱歉，找不到該商品</h2>
    <router-link to="/" class="back-link">返回首頁</router-link>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import { RouterLink } from 'vue-router';
import api from '../services/api.js';

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
  isLoggedIn: Boolean, 
  cartItems: Array
});

defineEmits(['add-to-cart', 'login-success', 'registration-notification', 'update-quantity', 'remove-from-cart', 'clear-cart', 'show-notification', 'require-login']);

const product = ref(null);
const currentImageIndex = ref(0);

// 獲取產品資料的函式
const fetchProduct = async (productId) => {
  try {
    const response = await api.getProduct(productId);
    product.value = response.data;
    currentImageIndex.value = 0; // 重置圖片索引
  } catch (error) {
    console.error('無法獲取產品詳細資料:', error);
    product.value = null; // 發生錯誤時清空產品資料
  }
};

// 產品的所有圖片，我們假設 API 回傳的 product 物件中包含一個名為 'images' 的陣列
const allImages = computed(() => {
  if (!product.value || !product.value.images) return [];
  // 如果後端回傳的圖片路徑是相對路徑，您可能需要在此處組合基礎 URL
  return product.value.images.map(img => {
    let path = img.imagePath;
    if (path && !path.startsWith('http')) {
      // local dev or docker, usage relative path
      // path = `http://localhost:8080${path}`;
      // Nginx /api proxy will handle it if it starts with /api, but images start with /images...
      // Wait, if path is /images/foo.jpg, it goes to http://localhost/images/foo.jpg -> Nginx -> http://backend:8080/images/foo.jpg.
      // So just allow it to remain relative.
      
    }
    return { ...img, imagePath: path };
  });
});

const currentImage = computed(() => {
  if (allImages.value.length === 0) return null;
  return allImages.value[currentImageIndex.value];
});

// 監聽 props.id 的變化，當它改變時重新獲取產品資料
watch(() => props.id, (newId) => {
  fetchProduct(newId);
});

// 元件掛載時，立即獲取一次產品資料
onMounted(() => {
  fetchProduct(props.id);
});
</script>

<style scoped>
.product-detail-container {
  max-width: 1100px;
  margin: 0 auto;
  padding: 40px 20px;
}

.detail-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 50px;
  align-items: start;
  margin-bottom: 60px; /* 增加底部間距，區隔下方的通用說明 */
}

/* 圖片區 */
.image-section { display: flex; flex-direction: column; gap: 15px; }
.main-image-container {
  width: 100%; aspect-ratio: 3 / 4; background-color: #fff; border: 1px solid #eee;
  border-radius: 12px; overflow: hidden; display: flex; align-items: center; justify-content: center;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}
.main-image { width: 100%; height: 100%; object-fit: contain; }
.thumbnail-list { display: flex; gap: 10px; overflow-x: auto; padding-bottom: 5px; }
.thumbnail-item {
  width: 80px; height: 80px; border-radius: 8px; overflow: hidden; border: 2px solid transparent;
  cursor: pointer; transition: all 0.2s; flex-shrink: 0; background-color: #f0f0f0;
}
.thumbnail-item img { width: 100%; height: 100%; object-fit: cover; object-position: top center; }
.thumbnail-item:hover { border-color: #ccc; }
.thumbnail-item.active { border-color: #4285F4; box-shadow: 0 0 0 2px rgba(66, 133, 244, 0.2); }

/* 資訊區 */
.info-section { display: flex; flex-direction: column; }
.product-title { font-size: 2rem; font-weight: 800; color: #333; margin-bottom: 5px; line-height: 1.3; }
.product-studio { font-size: 1.1rem; color: #666; font-weight: 500; margin-bottom: 20px; }
.price-box { margin-bottom: 25px; color: #d93025; }
.currency { font-size: 1.2rem; font-weight: bold; margin-right: 4px; }
.amount { font-size: 2.5rem; font-weight: 900; }

.specs-card { background-color: #f8f9fa; border-radius: 8px; padding: 20px; margin-bottom: 25px; border: 1px solid #e9ecef; }
.spec-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px dashed #ddd; font-size: 1rem; }
.spec-row:last-child { border-bottom: none; }
.spec-row.highlight .spec-value { color: #d93025; font-weight: bold; }
.spec-label { color: #777; font-weight: 600; }
.spec-value { color: #333; font-weight: 500; }

/* ★★★ 新增：特色列表樣式 ★★★ */
.features-section h4, .description-section h4 {
  font-size: 1.1rem; font-weight: 700; color: #333; margin-bottom: 10px;
  border-left: 4px solid #4285F4; padding-left: 10px; /* 左側藍條裝飾 */
}
.features-list {
  list-style: none; padding: 0; margin-bottom: 25px;
}
.features-list li {
  position: relative; padding-left: 20px; margin-bottom: 8px; color: #555; line-height: 1.6;
}
.features-list li::before {
  content: "✔"; color: #34A853; position: absolute; left: 0; font-weight: bold;
}

.product-description { font-size: 1.1rem; color: #555; line-height: 1.8; margin-bottom: 25px; }

/* ★★★ 新增：警示框樣式 ★★★ */
.important-note {
  background-color: #fff8e1; border: 1px solid #ffecb3; color: #856404;
  padding: 15px; border-radius: 6px; margin-bottom: 30px; font-size: 0.95rem; line-height: 1.6;
}

.action-buttons { margin-top: auto; }
.add-cart-btn {
  width: 100%; padding: 18px; background-color: #4285F4; color: #fff;
  font-size: 1.2rem; font-weight: 700; border: none; border-radius: 8px;
  cursor: pointer; transition: all 0.3s; box-shadow: 0 4px 12px rgba(66, 133, 244, 0.3);
}
.add-cart-btn:hover { background-color: #3367d6; transform: translateY(-2px); }

/* ★★★ 新增：底部通用條款樣式 ★★★ */
.common-policy {
  border-top: 1px solid #eee;
  padding-top: 40px;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 30px;
}
.policy-block h3 {
  font-size: 1.2rem; font-weight: 700; color: #333; margin-bottom: 15px;
}
.policy-block p {
  color: #666; font-size: 0.95rem; line-height: 1.6; margin-bottom: 8px;
}

.back-link { display: inline-block; color: #666; font-weight: 600; transition: color 0.3s; margin-top: 40px; }
.back-link:hover { color: #333; }

@media (max-width: 768px) {
  .detail-layout { grid-template-columns: 1fr; gap: 30px; }
  .product-title { font-size: 1.6rem; }
  .common-policy { grid-template-columns: 1fr; gap: 20px; } /* 手機版條款改直排 */
}
</style>