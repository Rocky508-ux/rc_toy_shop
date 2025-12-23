<template>
  <div class="search-bar">
    <input
      type="text"
      v-model="query"
      @keyup.enter="onSearch"
      placeholder="搜尋產品..."
    />
    <button @click="onSearch">搜尋</button>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const query = ref('');
const emit = defineEmits(['search']);

const onSearch = () => {
  emit('search', query.value);
};
</script>

<style scoped>
.search-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%; /* 容器佔滿可用空間 */
  max-width: 600px; /* 設定最大寬度，避免在電腦版太長 */
}

.search-bar input {
  /* ★★★ 修改這裡：移除 width: 400px，改用 flex ★★★ */
  flex: 1; /* 自動填滿剩餘空間 */
  width: 100%; 
  min-width: 0; /* 防止 flex 子項目被內容撐爆 */
  padding: 12px 20px;
  font-size: 16px; /* 手機版字體 16px 比較不會自動縮放 */
  font-weight: 700;
  border-radius: 6px;
  border: 1px solid #ccc;
  box-sizing: border-box;
}

.search-bar button {
  padding: 12px 20px;
  font-size: 16px;
  line-height: 16px;
  font-weight: 700;
  border-radius: 6px;
  border: 1px solid #4285F4;
  background: #4285F4;
  color: white;
  cursor: pointer;
  transition: background-color 0.3s ease;
  white-space: nowrap; /* 按鈕文字不換行 */
}

.search-bar button:hover {
  background-color: #3367d6;
}
</style>