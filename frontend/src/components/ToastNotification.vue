<template>
  <div class="toast-container">
    <transition-group name="toast" tag="div">
      <div v-for="notification in notifications" :key="notification.id" class="toast">
        {{ notification.message }}
      </div>
    </transition-group>
  </div>
</template>

<script setup>
defineProps({
  notifications: {
    type: Array,
    default: () => []
  }
});
</script>

<style scoped>
.toast-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

.toast {
  background-color: #4CAF50; /* Green background */
  color: white;
  padding: 15px 25px;
  border-radius: 8px;
  margin-bottom: 10px;
  font-size: 16px;
  font-weight: 700;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  opacity: 1;
  transition: all 0.5s ease;
}

/* Transitions for appearing and disappearing */
.toast-enter-active, .toast-leave-active {
  transition: all 0.5s ease;
}
.toast-enter-from, .toast-leave-to {
  opacity: 0;
  transform: translateX(100%);
}
.toast-move {
  transition: transform 0.5s ease;
}
</style>
