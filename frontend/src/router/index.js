import { createRouter, createWebHistory } from 'vue-router';
import ProductList from '../views/ProductList.vue';
import About from '../views/About.vue';
import Contact from '../views/Contact.vue';
import Login from '../views/Login.vue';
import Register from '../views/Register.vue';
import Profile from '../views/Profile.vue';
import Orders from '../views/Orders.vue';
import ShoppingCart from '../views/ShoppingCart.vue';
import ProductDetail from '../views/ProductDetail.vue';
import MemberCenter from '../views/MemberCenter.vue';
import Admin from '../views/Admin.vue';

const routes = [
  {
    path: '/',
    name: 'Home',
    component: ProductList,
  },
  {
    path: '/about',
    name: 'About',
    component: About,
  },
  {
    path: '/contact',
    name: 'Contact',
    component: Contact,
  },
  {
    path: '/privacy',
    name: 'PrivacyPolicy',
    component: () => import('../views/PrivacyPolicy.vue'),
  },
  {
    path: '/service',
    name: 'Service',
    component: () => import('../views/AfterSales.vue'),
  },
  {
    path: '/login',
    name: 'Login',
    component: Login,
  },
  {
    path: '/register',
    name: 'Register',
    component: Register,
  },
  {
    path: '/profile',
    name: 'Profile',
    component: Profile,
    meta: { requiresAuth: true }, // 需要登入
  },
  {
    path: '/orders',
    name: 'Orders',
    component: Orders,
    meta: { requiresAuth: true }, // 需要登入
  },
  {
    path: '/cart',
    name: 'ShoppingCart',
    component: ShoppingCart,
  },
  {
    path: '/product/:id',
    name: 'ProductDetail',
    component: ProductDetail,
    props: true,
  },
  {
    path: '/member-center',
    name: 'MemberCenter',
    component: MemberCenter,
    meta: { requiresAuth: true }, // 需要登入
  },
  {
    path: '/admin',
    name: 'Admin',
    component: Admin,
    meta: { requiresAdmin: true }, // 需要管理員權限
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
  // ★★★ 優化：換頁時自動回到頂部 ★★★
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    }
    return { top: 0 };
  }
});

// ★★★ 路由守衛：權限檢查 ★★★
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('authToken');
  const role = localStorage.getItem('userRole');

  // 1. 管理員權限檢查
  if (to.meta.requiresAdmin) {
    if (!token) {
      // 沒登入 -> 去登入頁，並帶上訊息
      return next({ path: '/login', query: { msg: '請先登入！' } });
    }
    if (role !== 'ADMIN') {
      // 權限不足 -> 踢回首頁，並帶上訊息
      return next({ path: '/', query: { msg: '權限不足，您無法進入後台！' } });
    }
  }

  // 2. 一般會員權限檢查
  if (to.meta.requiresAuth && !token) {
    return next({ path: '/login', query: { msg: '請先登入會員才能查看此頁面！' } });
  }

  // 3. 放行
  next();
});

export default router;