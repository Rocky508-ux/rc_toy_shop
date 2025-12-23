# --- 採用「多階段構建 (Multi-Stage Build)」---

# [階段 1]：負責編譯 Vue 專案 (Build Stage)
# 使用 Node.js 20 的 Alpine 版本 (輕量版)
FROM node:20-alpine AS build-stage

# 設定工作目錄
WORKDIR /app

# 先複製 package.json 和 package-lock.json
# 為什麼？因為這樣 Docker 可以快取 (Cache) 這一層
# 如果您的程式碼變了，但依賴沒變，Docker 就不會重新 npm install，速度會快很多
COPY package*.json ./

# 安裝依賴
RUN npm install

# 複製剩下的所有程式碼
COPY . .

# 執行 Vue 的打包指令 (會產生 dist 資料夾)
RUN npm run build

# ------------------------------------------------------------------

# [階段 2]：負責提供網頁服務 (Production Stage)
# 使用 Nginx 來作為網頁伺服器
FROM nginx:alpine AS production-stage

# ★關鍵步驟★：從 [階段 1] (build-stage) 把打包好的 dist 資料夾
# 複製到 Nginx 預設的網頁根目錄
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 複製我們自定義的 Nginx 設定檔 (處理 API 轉發和 SPA 路由)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 宣告開放 Port 80
EXPOSE 80

# 啟動 Nginx (daemon off 表示讓它在前台執行，不然 Docker 會以為程式跑完就關閉了)
CMD ["nginx", "-g", "daemon off;"]
