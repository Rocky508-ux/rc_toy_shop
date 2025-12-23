<template>
  <div class="admin-card">
    <div class="header">
      <button class="add-btn admin-btn" style="margin-left: auto;" @click="openAddModal">新增商品</button>
    </div>

    <div class="admin-table-wrapper">
      <table class="admin-table">
        <thead>
          <tr>
            <th style="width: 80px;">圖片</th>
            <th style="width: 150px;">名稱</th>
            <th>工作室</th>
            <th>分類</th>
            <th>標籤</th>
            <th>價格</th>
            <th>庫存</th>
            <th style="width: 140px;">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="product in products" :key="product.id">
            <td>
              <img :src="getProductMainImage(product)" alt="產品圖片" class="product-thumb">
            </td>
            <td>{{ product.name }}</td>
            <td>{{ product.studio || '-' }}</td>
            <td>{{ product.type }}</td>
            <td>
              <span v-if="product.tag" :class="['status-badge', getTagClass(product.tag)]">
                {{ product.tag }}
              </span>
            </td>
            <td>NT$ {{ product.price.toLocaleString() }}</td>
            <td>{{ product.stock }}</td>
            <td class="actions">
              <button class="edit-btn admin-btn" @click="openEditModal(product)">編輯</button>
              <button class="delete-btn admin-btn" @click="deleteProduct(product.id)">刪除</button>
            </td>
          </tr>
          <tr v-if="products.length === 0">
            <td colspan="8" style="text-align: center; padding: 20px;">目前沒有商品</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <h2>{{ isEditMode ? '編輯商品' : '新增商品' }}</h2>
        <form @submit.prevent="saveProduct" class="product-form">
          <div class="form-section">
            <h3>📦 基本資訊</h3>
            <div class="form-row">
              <div class="form-group half">
                <label for="name">商品名稱 *</label>
                <input type="text" id="name" v-model="editedProduct.name" required placeholder="例如：海賊王 魯夫" />
              </div>
              <div class="form-group half">
                <label for="studio">工作室/品牌</label>
                <input type="text" id="studio" v-model="editedProduct.studio" list="studio-options" placeholder="選擇或輸入品牌..." />
                <datalist id="studio-options">
                    <option value="Bandai (萬代)"></option>
                    <option value="Banpresto (眼鏡廠)"></option>
                    <option value="MegaHouse"></option>
                    <option value="Good Smile Company (GSC)"></option>
                    <option value="SEGA"></option>
                    <option value="Taito"></option>
                    <option value="Aniplex"></option>
                    <option value="Kotobukiya (壽屋)"></option>
                </datalist>
              </div>
            </div>

            <div class="form-row">
              <div class="form-group third">
                <label for="price">價格 *</label>
                <input type="number" id="price" v-model.number="editedProduct.price" required />
              </div>
              <div class="form-group third">
                <label for="stock">庫存 *</label>
                <input type="number" id="stock" v-model.number="editedProduct.stock" required />
              </div>
              <div class="form-group third">
                <label for="estimated_arrival">預計出貨</label>
                <input type="text" id="estimated_arrival" v-model="editedProduct.estimated_arrival" placeholder="例如：2025 Q3" />
              </div>
            </div>

            <div class="form-row">
              <div class="form-group half">
                <label for="category">商品類型 (Type)</label>
                <select id="category" v-model="editedProduct.type" class="styled-select full-width">
                  <option value="figure">公仔 (Figure)</option>
                  <option value="model">組裝模型 (Model)</option>
                  <option value="prize">景品 (Prize)</option>
                  <option value="blindbox">盒玩 (Blindbox)</option>
                </select>
              </div>
              <div class="form-group half">
                <label for="tag">銷售標籤 (Tag)</label>
                <select id="tag" v-model="editedProduct.tag" class="styled-select full-width">
                  <option value="">無</option>
                  <option value="new">新品 (NEW)</option>
                  <option value="HOT">熱銷 (HOT)</option>
                  <option value="預購">預購</option>
                  <option value="現貨">現貨</option>
                </select>
              </div>
            </div>
            <!-- 新增：多圖管理區塊 -->
            <div class="form-row">
              <div class="form-group full-width">
                <label>商品圖片集 (第一張設為主圖)</label>
                
                <!-- 圖片列表 -->
                <div class="image-gallery" v-if="editedProduct.images && editedProduct.images.length > 0">
                    <div v-for="(img, index) in editedProduct.images" :key="index" class="gallery-item" :class="{ 'is-main': img.isMain }">
                        <img :src="img.imagePath || img.image_path" class="gallery-img">
                        <div class="gallery-actions">
                            <button type="button" class="btn-sm btn-main" @click="setMainImage(index)" v-if="!img.isMain">設為主圖</button>
                            <span class="main-label" v-else>主圖</span>
                            <button type="button" class="btn-sm btn-del" @click="removeImage(index)">刪除</button>
                        </div>
                    </div>
                </div>

                <!-- 上傳按鈕 -->
                <div class="upload-area">
                    <input type="file" id="file-upload" @change="handleFileUpload" accept="image/*" class="admin-input" />
                    <small style="color: #666; display: block; margin-top: 5px;">
                        支援 jpg, png 格式。上傳後自動加入列表。
                    </small>
                </div>
              </div>
            </div>
          </div>

          <div class="form-section">
            <h3>📏 規格詳情 (選填)</h3>
            <div class="form-row">
              <div class="form-group third">
                <label for="scale">比例</label>
                <input type="text" id="scale" v-model="editedProduct.scale" placeholder="例如：1/6" />
              </div>
              <div class="form-group third">
                <label for="dimensions">尺寸</label>
                <input type="text" id="dimensions" v-model="editedProduct.dimensions" placeholder="例如：H:30cm" />
              </div>
              <div class="form-group third">
                <label for="material">材質</label>
                <input type="text" id="material" v-model="editedProduct.material" placeholder="例如：PVC, 樹脂" />
              </div>
            </div>
            
            <div class="form-group">
              <label for="description">商品描述</label>
              <textarea id="description" v-model="editedProduct.description" rows="3"></textarea>
            </div>
          </div>

          <div class="modal-actions">
            <button type="button" class="admin-btn cancel-btn" @click="closeModal">取消</button>
            <button type="submit" class="admin-btn save-btn">儲存</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import api from '../../services/api.js';

const products = ref([]);
const showModal = ref(false);
const isEditMode = ref(false);

const editedProduct = reactive({
  id: null,
  name: '',
  price: 0,
  stock: 0,
  description: '',
  images: [], // 新增：圖片陣列
  studio: '',
  scale: '',
  dimensions: '',
  material: '',
  estimated_arrival: '',
  tag: '',
  type: 'figure'
});

// 從 API 獲取所有商品
const fetchProducts = async () => {
  try {
    const response = await api.getProducts();
    products.value = response.data;
  } catch (error) {
    console.error("無法獲取商品列表:", error);
    alert("無法載入商品資料，請稍後再試。");
  }
};

// 元件掛載後立即獲取資料
onMounted(fetchProducts);

// 輔助函式：取得主圖 (假設 API 回傳的 product 物件中直接包含主圖路徑)
const getProductMainImage = (product) => {
  // Check if images array exists and has elements
  if (product.images && product.images.length > 0) {
      // Find the main image
      const mainImage = product.images.find(img => img.isMain);
      if (mainImage) return mainImage.imagePath;
      // Fallback to first image if no main image defined
      return product.images[0].imagePath;
  }
  // Legacy or flat structure fallback
  return product.main_image_url || product.image_path || '';
};

const getTagClass = (tag) => {
  if (!tag) return '';
  const lowerTag = tag.toLowerCase().trim();
  if (lowerTag === 'new' || lowerTag === '新品') return 'new-tag';
  if (lowerTag === 'hot' || lowerTag === '熱銷') return 'hot-tag';
  if (lowerTag === '預購') return 'preorder-tag';
  if (lowerTag === '現貨') return 'instock-tag';
  return '';
};

const openAddModal = () => {
  isEditMode.value = false;
  // 重置 editedProduct
  Object.assign(editedProduct, {
    id: null, name: '', price: 0, stock: 0, description: '',
    studio: '', scale: '', dimensions: '', material: '', estimated_arrival: '',
    tag: '', type: 'figure', images: []
  });
  showModal.value = true;
};

const openEditModal = (product) => {
  isEditMode.value = true;
  // 使用深拷貝，避免直接修改原始資料
  Object.assign(editedProduct, JSON.parse(JSON.stringify(product)));
  showModal.value = true;
};

// Define emits
const emit = defineEmits(['show-notification']);

const saveProduct = async () => {
  try {
    if (isEditMode.value) {
      // 編輯模式
      await api.updateProduct(editedProduct.id, editedProduct);
    } else {
      // 新增模式
      // 從 editedProduct 中排除 id，讓後端生成
      const { id, ...newProductData } = editedProduct;
      await api.createProduct(newProductData);
    }
    closeModal();
    await fetchProducts(); // 重新獲取列表以顯示更新
    emit('show-notification', '商品儲存成功！');
  } catch (error) {
    console.error("儲存商品失敗:", error);
    // 這裡可以使用更詳細的錯誤訊息處理，類似 ProductList.vue
    emit('show-notification', "儲存失敗，請檢查資料或稍後再試。"); 
  }
};

const deleteProduct = async (productId) => {
  if (confirm('確定要刪除此商品嗎？此操作無法復原。')) {
    try {
      await api.deleteProduct(productId);
      await fetchProducts(); // 重新獲取列表
      emit('show-notification', '商品已刪除');
    } catch (error) {
      console.error("刪除商品失敗:", error);
      emit('show-notification', "刪除失敗，請稍後再試。");
    }
  }
};

const closeModal = () => {
  showModal.value = false;
};

const handleFileUpload = async (event) => {
  const file = event.target.files[0];
  if (!file) return;

  const formData = new FormData();
  formData.append('file', file);

  try {
    // 呼叫上傳 API
    const response = await api.uploadProductImage(formData);
    const imageUrl = response.data.url;
    
    // 初始化陣列
    if (!editedProduct.images) {
        editedProduct.images = [];
    }

    // 邏輯：如果是第一張圖片，預設為主圖；否則為附圖
    const isFirst = editedProduct.images.length === 0;
    
    // 加入新圖片
    editedProduct.images.push({ 
        imagePath: imageUrl, 
        isMain: isFirst 
    });
    
    // 清空 input 讓使用者可以重複上傳同一張(雖然通常不需要)
    event.target.value = '';

    emit('show-notification', '圖片已加入列表！記得按儲存喔。');
  } catch (error) {
    console.error('上傳失敗:', error);
    emit('show-notification', '圖片上傳失敗，請稍後再試。');
  }
};

const removeImage = (index) => {
    // 如果刪除的是主圖，且還有其他圖片，將第一張設為主圖
    const wasMain = editedProduct.images[index].isMain;
    editedProduct.images.splice(index, 1);
    
    if (wasMain && editedProduct.images.length > 0) {
        editedProduct.images[0].isMain = true;
    }
};

const setMainImage = (index) => {
    // 將所有圖片設為 false
    editedProduct.images.forEach(img => img.isMain = false);
    // 將選中的設為 true
    editedProduct.images[index].isMain = true;
};
</script>

<style scoped>
/* (樣式部分保持不變) */
.product-thumb { width: 50px; height: 50px; object-fit: cover; border-radius: 4px; }
.modal-content { max-width: 700px; }
.form-section { margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px dashed #eee; }
.form-section:last-child { border-bottom: none; }
.form-section h3 { font-size: 1.1rem; color: #4285F4; margin-bottom: 15px; border-left: 4px solid #4285F4; padding-left: 10px; }
.form-row { display: flex; gap: 15px; margin-bottom: 15px; }
.form-group { margin-bottom: 0; }
.form-group.half { flex: 1; }
.form-group.third { flex: 1; }
.full-width { width: 100%; }
.new-tag { background-color: #DB4437; }
.hot-tag { background-color: #FF0000; box-shadow: 0 0 5px rgba(255, 0, 0, 0.4); }
.preorder-tag { background-color: #fbbc05; color: #333; }
.instock-tag { background-color: #34A853; }

/* 圖片畫廊樣式 */
.image-gallery { display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 10px; }
.gallery-item { position: relative; width: 100px; height: 120px; border: 1px solid #ddd; border-radius: 6px; overflow: hidden; background: #fff; display: flex; flex-direction: column; }
.gallery-item.is-main { border: 2px solid #4285F4; box-shadow: 0 0 5px rgba(66, 133, 244, 0.3); }
.gallery-img { width: 100%; height: 80px; object-fit: cover; }
.gallery-actions { display: flex; justify-content: space-between; padding: 5px; background: #f9f9f9; flex-grow: 1; align-items: center; }
.btn-sm { font-size: 0.7rem; padding: 2px 5px; cursor: pointer; border: none; border-radius: 3px; }
.btn-main { background: #4CAF50; color: white; }
.btn-del { background: #F44336; color: white; margin-left: auto; }
.main-label { font-size: 0.75rem; color: #4285F4; font-weight: bold; margin-left: 5px; }
.upload-area { background: #f8f9fa; padding: 10px; border-radius: 6px; border: 1px dashed #ccc; }
</style>