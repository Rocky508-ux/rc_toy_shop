<template>
  <div class="product-card" @click="goToDetail">
    <div v-if="product.tag" :class="['product-tag', getTagClass(product.tag)]">
      {{ product.tag === 'new' ? 'NEW' : product.tag }}
    </div>
    
    <div class="product-image-container">
      <img 
        v-if="mainImage" 
        :src="mainImage" 
        :alt="product.name" 
        loading="lazy"
      />
      <div v-else class="placeholder-image">
        <span>Image Not Available</span>
      </div>
    </div>

    <div class="product-info">
      <h3 class="product-name" :title="product.name">{{ product.name }}</h3>
      
      <div class="product-actions">
        <div class="product-price-group">
          <span class="currency">NT$</span>
          <span class="price-number">{{ product.price.toLocaleString() }}</span>
        </div>
        <button class="buy-btn" @click.stop="$emit('add-to-cart', product)">
          加入購物車
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRouter } from 'vue-router';

const props = defineProps({
  product: {
    type: Object,
    required: true,
  },
});

defineEmits(['add-to-cart']);

const router = useRouter();

const mainImage = computed(() => {
  if (!props.product.images || props.product.images.length === 0) {
    return null;
  }
  
  const main = props.product.images.find(img => img.isMain);
  let path = main ? main.imagePath : props.product.images[0].imagePath;
  
  if (path && !path.startsWith('http')) {
      return path;
  }
  return path;
});

const goToDetail = () => {
  router.push({ name: 'ProductDetail', params: { id: props.product.id } });
};

const getTagClass = (tag) => {
  if (tag === 'new' || tag === 'NEW') return 'tag-new';
  if (tag === 'HOT' || tag === 'hot') return 'tag-hot';
  if (tag === '預購') return 'tag-preorder';
  if (tag === '現貨') return 'tag-instock';
  return '';
};
</script>

<style scoped>
.product-card {
  border: none;
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  position: relative;
  display: flex;
  flex-direction: column;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.product-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 24px rgba(0,0,0,0.15);
}

.product-image-container {
  position: relative;
  width: 100%;
  aspect-ratio: 1 / 1;
  overflow: hidden;
  background-color: #fff; 
  display: flex;
  align-items: flex-start; 
  justify-content: center;
}

.product-image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: top center;
  display: block;
  transition: transform 0.5s ease;
}

.product-card:hover .product-image-container img {
  transform: scale(1.08);
}

.product-tag {
  position: absolute;
  top: 12px;
  left: 12px;
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 0.85rem;
  font-weight: 800;
  z-index: 10;
  box-shadow: 0 2px 6px rgba(0,0,0,0.2);
  letter-spacing: 1px;
  text-transform: uppercase;
}
.tag-new { background-color: #D32F2F; color: white; }
.tag-hot { background-color: #FF0000; color: white; box-shadow: 0 0 10px rgba(255, 0, 0, 0.4); }
.tag-preorder { background-color: #FFC107; color: #212121; }
.tag-instock { background-color: #388E3C; color: white; }

.product-info {
  padding: 20px;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  background: #fff;
}

.product-name {
  font-size: 1.2rem;
  font-weight: 800;
  color: #1a1a1a;
  margin: 0 0 15px 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.product-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
  gap: 10px;
}

.product-price-group {
  display: flex;
  align-items: baseline;
  color: #D32F2F;
}

.currency {
  font-size: 1rem;
  font-weight: 700;
  margin-right: 4px;
}

.price-number {
  font-size: 1.5rem;
  font-weight: 900;
  letter-spacing: -0.5px;
}

.buy-btn {
  padding: 10px 18px;
  background-color: #1976D2;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 0.95rem;
  font-weight: 700;
  white-space: nowrap;
  flex-shrink: 0;
  box-shadow: 0 2px 6px rgba(25, 118, 210, 0.3);
}

.buy-btn:hover {
  background-color: #1565C0;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(25, 118, 210, 0.4);
}

.placeholder-image {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f5f5;
  color: #999;
  font-weight: bold;
}

@media (max-width: 768px) {
  .product-info {
    padding: 15px;
  }
  .product-name {
    font-size: 1.1rem;
  }
  .price-number {
    font-size: 1.3rem;
  }
}
</style>