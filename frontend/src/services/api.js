import axios from 'axios';

// 建立一個 Axios instance，用於向後端 API 發送請求
const apiClient = axios.create({
  // 我們假設後端 API 的基礎 URL 為 http://localhost:8080/api
  // 當您完成後端開發後，請確保此 URL 是正確的
  // Nginx proxy will handle /api requests
  baseURL: '/api',
  headers: {
    'Content-Type': 'application/json',
  },
});

// ★★★ 新增：請求攔截器，自動掛載 Token ★★★
apiClient.interceptors.request.use(config => {
  const token = localStorage.getItem('authToken');
  if (token && token.startsWith('ey')) { // 簡單判斷這是不是一個 JWT 字串
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
}, error => {
  return Promise.reject(error);
});

// ===============================================
//                  認證與使用者 (Auth & Users) API
// ===============================================

// 登入
export const login = (credentials) => apiClient.post('/auth/login', credentials);
// 註冊
export const register = (userData) => apiClient.post('/auth/register', userData);

// 獲取所有使用者 (Backend Path: /api/admin/users)
export const getUsers = () => apiClient.get('/admin/users');
// 創建新使用者 (Backend Path: /api/admin/users)
export const createUser = (data) => apiClient.post('/admin/users', data);
// 根據 ID 獲取單一使用者
export const getUser = (id) => apiClient.get(`/admin/users/${id}`);
// 更新使用者資料
export const updateUser = (id, data) => apiClient.put(`/admin/users/${id}`, data);
// 刪除使用者
export const deleteUser = (id) => apiClient.delete(`/admin/users/${id}`);

// [USER] 獲取個人資料
export const getUserProfile = (id) => apiClient.get(`/users/${id}`);
// [USER] 更新個人資料
export const updateUserProfile = (id, data) => apiClient.put(`/users/${id}`, data);

// ===============================================
//                  產品 (Products) API
// ===============================================

// 獲取所有產品 (Public)
export const getProducts = () => apiClient.get('/products');
// 根據 ID 獲取單一產品 (Public)
export const getProduct = (id) => apiClient.get(`/products/${id}`);

// [ADMIN] 創建新產品
export const createProduct = (data) => apiClient.post('/admin/products', data);
// [ADMIN] 更新產品資料
export const updateProduct = (id, data) => apiClient.put(`/admin/products/${id}`, data);
// [ADMIN] 刪除產品
export const deleteProduct = (id) => apiClient.delete(`/admin/products/${id}`);

// [ADMIN] 上傳產品圖片
export const uploadProductImage = (formData) => apiClient.post('/admin/products/upload', formData, {
  headers: {
    'Content-Type': 'multipart/form-data'
  }
});

// ===============================================
//                  訂單 (Orders) API
// ===============================================

// [ADMIN] 獲取所有訂單
export const getOrders = () => apiClient.get('/admin/orders');

// 根據 User ID 獲取訂單 (Public/User)
export const getUserOrders = (userId) => apiClient.get(`/orders/user/${userId}`);
// 創建新訂單 (User)
export const createOrder = (data) => apiClient.post('/orders', data);

// [ADMIN] 更新訂單狀態
export const updateOrder = (id, data) => apiClient.put(`/admin/orders/${id}`, data);

// 匯出
export default {
  login,
  register,
  getUsers,
  createUser, // Added missing export if needed
  getUser,
  updateUser,
  deleteUser,
  getUserProfile,
  updateUserProfile,
  getProducts,
  getProduct,
  createProduct,
  updateProduct,
  deleteProduct,
  uploadProductImage,
  getOrders,
  createOrder,
  updateOrder,
  getUserOrders,
};