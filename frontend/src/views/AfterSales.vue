<template>
  <div class="static-page-container">
    <div class="content-wrapper">
      <h1>售後服務 (After Sales Service)</h1>
      
      <div class="service-content">
        <section class="service-section">
          <div class="icon-header">
            <span class="icon">📦</span>
            <h2>退換貨說明</h2>
          </div>
          <p>
            我們提供 <strong>7 天鑑賞期</strong> (非試用期)。
            若您收到的商品有瑕疵、破損或與訂單不符，請於收到商品後 7 天內聯繫客服進行退換貨。
          </p>
          <ul class="policy-list">
            <li>商品必須保持全新未拆封（含原始包裝、配件、贈品）。</li>
            <li>若為盲盒/扭蛋類商品，一經拆封恕不接受退換。</li>
            <li>運送過程造成的盒損（八角魔人請三思）若未影響內容物，通常不列入瑕疵範圍。</li>
          </ul>
        </section>

        <section class="service-section">
          <div class="icon-header">
            <span class="icon">🔧</span>
            <h2>維修與保固</h2>
          </div>
          <p>
            針對高單價之 GK 雕像或電子類玩具，我們提供以下服務：
          </p>
          <ul class="policy-list">
            <li><strong>GK 運損修復</strong>：若不幸發生運送斷件，我們會協助聯繫專業修復師進行評估與修復（費用視情況由物流保險或買家負擔）。</li>
            <li><strong>缺件補寄</strong>：若開封後發現缺件，請提供開箱錄影，我們將向原廠申請補件。</li>
          </ul>
        </section>

        <section class="service-section">
          <div class="icon-header">
            <span class="icon">🚚</span>
            <h2>配送進度查詢</h2>
          </div>
          <p>
            您可以隨時至「<router-link to="/orders">訂單查詢</router-link>」頁面查看您的包裹狀態。
            若訂單顯示「已出貨」超過 7 天仍未收到，請立即聯繫我們。
          </p>
        </section>

        <section class="contact-hint">
          <h3>還有其他問題嗎？</h3>
          <p>找不到您需要的答案？請直接聯繫我們的客服團隊。</p>
          <router-link to="/contact" class="contact-btn">聯繫客服</router-link>
        </section>
      </div>
    </div>
  </div>
</template>

<style scoped>
.static-page-container {
  max-width: 900px;
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
  margin-bottom: 50px;
  font-size: 2rem;
  color: #333;
  font-weight: 700;
  border-bottom: 2px solid #eee;
  padding-bottom: 20px;
}

.service-section {
  margin-bottom: 40px;
  padding-bottom: 30px;
  border-bottom: 1px dashed #eee;
}

.service-section:last-child {
  border-bottom: none;
}

.icon-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}

.icon-header .icon {
  font-size: 1.8rem;
  margin-right: 15px;
  background: #FFF3E0;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 12px;
}

.icon-header h2 {
  font-size: 1.4rem;
  color: #E65100;
  font-weight: 600;
  margin: 0;
}

p {
  line-height: 1.8;
  color: #555;
  font-size: 1rem;
  margin-bottom: 15px;
}

.policy-list {
  background: #f9f9f9;
  padding: 20px 20px 20px 40px;
  border-radius: 8px;
  border-left: 4px solid #FF9800;
}

.policy-list li {
  margin-bottom: 10px;
  color: #444;
  line-height: 1.6;
}

.contact-hint {
  text-align: center;
  background: #E3F2FD;
  padding: 30px;
  border-radius: 12px;
  margin-top: 50px;
}

.contact-hint h3 {
  color: #1565C0;
  margin-bottom: 10px;
}

.contact-btn {
  display: inline-block;
  margin-top: 15px;
  background: #1976D2;
  color: white;
  padding: 10px 25px;
  border-radius: 25px;
  text-decoration: none;
  font-weight: 700;
  transition: background 0.3s;
}

.contact-btn:hover {
  background: #1565C0;
  transform: translateY(-2px);
}
</style>
