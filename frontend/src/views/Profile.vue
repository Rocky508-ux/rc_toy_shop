<template>
  <section class="content-section">
    <h2 class="section-title">會員中心</h2>
    <div class="extra-block">
      <h4>會員資訊</h4>
      <p v-if="isLoggedIn">歡迎回來！</p>
      <p v-else>請先登入</p>
    </div>
  </section>
</template>

<script setup>
defineProps({
  isLoggedIn: {
    type: Boolean,
    required: true
  }
});
</script>
