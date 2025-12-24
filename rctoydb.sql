-- ==========================================
-- RC Toy Shop Master Database Script
-- Generated/Verified on: 2025-12-23
-- ==========================================

-- 0. 初始化資料庫 (Database Initialization)
CREATE DATABASE IF NOT EXISTS rc_toy_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE rc_toy_shop;
SET SQL_SAFE_UPDATES = 0; -- 關閉安全更新模式，避免 UPDATE/DELETE 缺乏 Key 時報錯

-- ==========================================
-- (1) 資料庫結構 (Schema / DDL)
-- ==========================================

SET FOREIGN_KEY_CHECKS = 0; -- 暫時關閉外鍵檢查以刪除舊表

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1; -- 恢復外鍵檢查

-- 1. 使用者 (Users)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    birthday DATE,
    role ENUM('ADMIN', 'USER') DEFAULT 'USER',
    status ENUM('ACTIVE', 'DISABLED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. 商品 (Products)
CREATE TABLE products (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price INT NOT NULL,
    stock INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'available',
    category_id VARCHAR(50),
    tag VARCHAR(20),
    type VARCHAR(20),
    studio VARCHAR(100),
    scale VARCHAR(50),
    dimensions VARCHAR(100),
    material VARCHAR(100),
    estimated_arrival VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. 商品圖片 (Product Images)
CREATE TABLE product_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    is_main BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 4. 訂單 (Orders)
CREATE TABLE orders (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount INT NOT NULL,
    total_items INT DEFAULT 0,
    status VARCHAR(20) DEFAULT '處理中',
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    shipping_address VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. 訂單明細 (Order Items)
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    product_name VARCHAR(255),
    quantity INT NOT NULL,
    price INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);


-- ==========================================
-- (2) 初始資料 (Data / DML)
-- ==========================================

-- (1) 使用者
-- 預設密碼: admin123 / password / 123456
INSERT IGNORE INTO users (email, password, name, role, status, phone, birthday, created_at) VALUES 
-- Admin & Staff (Early Adopters)
('admin@rctoyshop.com', 'admin123', '陳建國', 'ADMIN', 'ACTIVE', '0987654321', '1985-06-15', '2023-01-01 10:00:00'),
('service@rctoyshop.com', 'admin123', '林美秀', 'ADMIN', 'ACTIVE', '0911222333', '1990-11-20', '2023-01-02 09:30:00'),

-- Regular Users (VIP - 2023)
('yating.lin92@gmail.com', '123456', '林雅婷', 'USER', 'ACTIVE', '0912345678', '1992-09-20', '2023-03-15 14:20:00'),
('cm.chang88@yahoo.com.tw', '123456', '張志明', 'USER', 'ACTIVE', '0922333444', '1998-03-05', '2023-04-10 18:45:00'),
('david.wang77@hotmail.com', '123456', '王大偉', 'USER', 'ACTIVE', '0933444555', '1988-07-12', '2023-05-22 11:10:00'),
('sara.lee01@gmail.com', '123456', '李淑芬', 'USER', 'ACTIVE', '0955666777', '1975-04-30', '2023-06-18 09:00:00'),
('kevin.chen99@gmail.com', '123456', '陳冠宇', 'USER', 'ACTIVE', '0966777888', '1999-12-01', '2023-07-04 15:30:00'),

-- Regular Users (General - 2024 First Half)
('jason.wu85@yahoo.com', '123456', '吳家豪', 'USER', 'ACTIVE', '0977888999', '1985-02-28', '2024-01-10 20:15:00'),
('emily.hsu95@gmail.com', '123456', '許婉婷', 'USER', 'ACTIVE', '0988999000', '1995-10-10', '2024-02-14 13:25:00'),
('michael.huang@outlook.com', '123456', '黃柏翰', 'USER', 'ACTIVE', '0910111222', '1993-08-15', '2024-03-20 16:40:00'),
('jessica.tsai@gmail.com', '123456', '蔡欣依', 'USER', 'ACTIVE', '0920222333', '1996-05-25', '2024-04-05 10:50:00'),
('alex.yang00@gmail.com', '123456', '楊宗緯', 'USER', 'ACTIVE', '0930333444', '2000-01-20', '2024-05-12 22:10:00'),
('amber.liu89@yahoo.com.tw', '123456', '劉心怡', 'USER', 'ACTIVE', '0940444555', '1989-11-03', '2024-06-30 08:05:00'),
('eric.chou82@gmail.com', '123456', '周杰倫', 'USER', 'ACTIVE', '0950555666', '1982-01-18', '2024-07-07 19:19:00'),
('grace.cheng@hotmail.com', '123456', '鄭宜農', 'USER', 'ACTIVE', '0960666777', '1991-03-30', '2024-08-08 12:00:00'),

-- New Users (Recent Signups - Late 2024)
('ryan.hsu@gmail.com', '123456', '徐志宏', 'USER', 'ACTIVE', '0970777888', '1997-07-07', '2024-09-01 14:14:00'),
('vivian.lai@yahoo.com', '123456', '賴薇如', 'USER', 'ACTIVE', '0980888999', '1994-09-09', '2024-10-10 10:10:00'),
('daniel.pan@gmail.com', '123456', '潘瑋柏', 'USER', 'ACTIVE', '0911000111', '1980-08-06', '2024-11-11 11:11:00'),
('nana.lin@outlook.com', '123456', '林奈奈', 'USER', 'ACTIVE', '0922111222', '2001-12-25', '2024-12-01 23:59:00'),
('steven.kuo@gmail.com', '123456', '郭富城', 'USER', 'ACTIVE', '0933222333', '1965-10-26', '2024-12-15 09:00:00'),
('candy.chang@yahoo.com.tw', '123456', '張惠妹', 'USER', 'ACTIVE', '0944333444', '1972-08-09', '2024-12-20 18:30:00'),
('jacky.wu@gmail.com', '123456', '吳宗憲', 'USER', 'ACTIVE', '0955444555', '1962-09-26', '2024-12-23 21:00:00');

-- (2) 商品
INSERT INTO products (id, name, description, price, stock, category_id, tag, type, studio, scale, dimensions, material, estimated_arrival) VALUES

-- 1. 七龍珠系列 (Dragon Ball)
('dbz-gohan-beast', '七龍珠超 孫悟飯 (野獸型態) - 覺醒之光', '來自劇場版《七龍珠超：超級英雄》的震撼一幕！這款 1/4 比例雕像完美重現了孫悟飯覺醒「野獸型態」的瞬間。KD Studio 採用進口樹脂打造，肌肉線條與戰損塗裝皆為業內頂尖水準，是龍珠迷不可錯過的鎮宅神物。', 15800, 5, 'dbz', 'HOT', 'hot', 'KD Studio', '1/4', 'H:50cm x W:40cm x D:35cm', '高級樹脂 + PU + LED燈效', '2025年 第1季'),

('dbz-ssj4-gogeta', '七龍珠GT 超級賽亞人4 悟吉塔 - 宇宙最強', '「我既不是悟空也不是貝吉塔，我是要在這裡打倒你的人！」集結了兩大賽亞人巔峰力量的超級戰士。F4 Studio 傾力打造，紅髮赤眼的狂野造型搭配招牌的「大爆炸龜派氣功」姿態。', 16500, 4, 'dbz', 'HOT', 'hot', 'F4 Studio', '1/6', 'H:40cm x W:30cm x D:30cm', '進口樹脂 + 透明件', '現貨'),

('dbz-ssj-gogeta', '七龍珠Z 超級賽亞人 悟吉塔 - 靈魂懲罰者', '他在地獄中誕生，以一招「靈魂懲罰者」瞬間淨化了強敵邪念波。這款作品捕捉了悟吉塔手持彩虹能量球的經典瞬間，面部表情自信從容。Clouds Studio 特別強化的光影塗裝。', 14500, 3, 'dbz', '現貨', 'figure', 'Clouds Studio', '1/6', 'H:38cm x W:28cm x D:25cm', '樹脂 + PU', '2025年 第2季'),

('dbz-ui-goku', '七龍珠超 孫悟空 (自在極意功) - 神之領域', '超越破壞神、踏入神之領域的極致武道境界！銀色髮絲閃耀著神聖的光輝。Last Sleep 工作室以其擅長的動態特效聞名，底座的銀河氣旋特效件華麗無比。', 14200, 6, 'dbz', '現貨', 'figure', 'Last Sleep', '1/6', 'H:38cm x W:35cm x D:32cm', '樹脂 + LED發光組件', '現貨'),

('dbz-black', '七龍珠超 黑悟空 (超級賽亞人玫瑰) - 人類歸零', '「欣賞這孤高的美麗吧！」札馬斯奪取悟空身體後變身的姿態，粉紅色的氣焰象徵著他扭曲的正義。ShowHand Studio 精準還原了那一抹邪魅的微笑與專屬的氣鐮武器。', 12800, 8, 'dbz', '預購', 'hot', 'ShowHand Studio', '1/6', 'H:35cm x W:25cm x D:25cm', '樹脂 + PU', '2025年 第3季'),

('dbz-vegito', '七龍珠Z 貝吉特 (超級賽亞人) - 絕對力量', '使用波特拉耳環融合而成的戰士，其實力之強大甚至能將最強魔人普烏玩弄於股掌之間。配件包含著名的「氣劍」特效件，可自由替換展示。', 13500, 5, 'dbz', '現貨', 'figure', 'Last Sleep', '1/6', 'H:36cm x W:30cm x D:28cm', '樹脂', '現貨'),

('dbz-ssj4-goku', '七龍珠GT 孫悟空 (超級賽亞人4) - 始源之力', '回歸賽亞人原始野性的力量，結合了巨猿的狂暴與理性的控制。G5 Studio 的 WCF 比例雖然小巧，但細節毫不馬虎，適合桌面擺飾。', 3800, 15, 'dbz', '現貨', 'hot', 'G5 Studio', 'WCF', 'H:15cm', 'PVC + ABS', '現貨'),

-- 2. 進擊的巨人 (Attack on Titan)
('aot-levi', '進擊的巨人 里維兵長 - 人類最強', '「做出選擇吧，不會後悔的選擇。」隸屬於調查兵團的兵長，擁有以一敵百的戰鬥力。Cheng Studio 將其揮舞雙刀、在空中迴旋斬擊的瞬間凝固了下來。', 21500, 2, 'other', 'HOT', 'hot', 'Cheng Studio', '1/4', 'H:42cm x W:35cm x D:30cm', '高級樹脂', '現貨'),

('aot-eren', '進擊的巨人 艾連·葉卡 (始祖巨人) - 自由的代價', '「我要把他們... 一個不留地驅逐出去！」發動地鳴、誓言踏平世界的艾連。這款雕像呈現了後期長髮艾連站在巨人骨骸之上的決絕背影。', 20800, 3, 'other', '預購', 'figure', 'ShowHand Studio', '1/4', 'H:45cm x W:40cm x D:40cm', '樹脂 + PU', '2025年 第2季'),

-- 3. 死神 (Bleach)
('bleach-white-ichigo', '死神 白一護 (完全虛化) - 本能覺醒', '黑崎一護內心的虛，代表著純粹的戰鬥本能。蒼白的皮膚、黑色的眼白與狂氣的笑容，TPA Studio 完美還原了這一經典反派形象。', 13800, 4, 'other', '預購', 'hot', 'TPA Studio', '1/6', 'H:36cm x W:32cm x D:28cm', '樹脂', '2025年 第1季'),

-- 4. ★ NEW ★ 鬼滅之刃 (Demon Slayer)
('demon-slayer-rengoku', '鬼滅之刃 炎柱 煉獄杏壽郎 - 炎之呼吸', '「我會履行我的職責！在這裡的人，一個都不會死！」炎柱燃燒生命釋放奧義的瞬間。特效件採用高品質透明樹脂，展現出烈火燎原的氣勢，披風的破損與神情的堅毅都刻畫得入木三分。', 18800, 3, 'other', 'HOT', 'hot', 'Cheng Studio', '1/6', 'H:40cm x W:35cm x D:30cm', '樹脂 + PU', '現貨'),

('demon-slayer-giyu', '鬼滅之刃 水柱 富岡義勇 - 凪', '「水之呼吸 十一之型 凪。」在暴風雨中平靜如水的劍士。地台的水浪特效動感十足，與在此之中靜止的義勇形成強烈對比，展現出高超的劍術境界。', 17500, 4, 'other', '預購', 'figure', 'G5 Studio', '1/6', 'H:38cm x W:32cm x D:30cm', '樹脂 + 透明件', '2025年 第2季')

ON DUPLICATE KEY UPDATE 
name=VALUES(name), description=VALUES(description), price=VALUES(price), stock=VALUES(stock), category_id=VALUES(category_id), tag=VALUES(tag), type=VALUES(type), studio=VALUES(studio), scale=VALUES(scale), dimensions=VALUES(dimensions), material=VALUES(material), estimated_arrival=VALUES(estimated_arrival);


-- (3) 商品圖片 (Mappings)
INSERT INTO product_images (product_id, image_path, is_main) VALUES

-- Gohan Beast
('dbz-gohan-beast', '/image/beast.jpg', TRUE),
('dbz-gohan-beast', '/image/beast.webp', FALSE),
('dbz-gohan-beast', '/image/beast3.webp', FALSE),

-- SSJ4 Gogeta
('dbz-ssj4-gogeta', '/image/SSJ4gogeta.jpg', TRUE),

-- SSJ Gogeta
('dbz-ssj-gogeta', '/image/ssgogeta.jpg', TRUE),

-- UI Goku
('dbz-ui-goku', '/image/UI.jpg', TRUE),

-- White Ichigo (白一護)
('bleach-white-ichigo', '/image/white.jpg', TRUE),

-- Goku Black
('dbz-black', '/image/blackku.jpg', TRUE),
('dbz-black', '/image/blackku1.jpg', FALSE),

-- Levi
('aot-levi', '/image/levi.jpg', TRUE),

-- Eren (艾連)
('aot-eren', '/image/alan.jpg', TRUE),

-- Vegito
('dbz-vegito', '/image/vegito.jpg', TRUE),

-- SSJ4 Goku
('dbz-ssj4-goku', '/image/ssj4goku.jpg', TRUE),
('dbz-ssj4-goku', '/image/ssj4goku0.jpg', FALSE),

-- Rengoku
('demon-slayer-rengoku', '/image/fire.jpg', TRUE),
('demon-slayer-rengoku', '/image/fire01.jpg', FALSE),

-- Giyu
('demon-slayer-giyu', '/image/water.jpg', TRUE);


-- (4) 訂單 (Orders)
INSERT IGNORE INTO orders (id, user_id, total_amount, status, shipping_address, order_date) VALUES 
('ORD-20230520-001', 5, 16500, '已完成', '台北市大安區忠孝東路四段', '2023-05-20 14:30:00'),
('ORD-20230615-002', 3, 14500, '已完成', '新北市板橋區縣民大道', '2023-06-15 10:15:00'),
('ORD-20230710-003', 4, 21500, '已完成', '台中市西屯區台灣大道三段', '2023-07-10 16:45:00'),
('ORD-20230808-004', 6, 12800, '已完成', '高雄市左營區博愛二路', '2023-08-08 09:20:00'),
('ORD-20230925-005', 7, 3800, '已完成', '桃園市中壢區中正路', '2023-09-25 20:00:00'),
('ORD-20231111-006', 8, 15800, '已完成', '台南市東區中華東路', '2023-11-11 11:11:00'),
('ORD-20240105-007', 9, 13800, '已完成', '新竹市東區光復路二段', '2024-01-05 13:40:00'),
('ORD-20240214-008', 3, 18800, '已完成', '新北市板橋區文化路', '2024-02-14 18:30:00'),
('ORD-20240320-009', 10, 14200, '已完成', '台北市信義區松壽路', '2024-03-20 15:10:00'),
('ORD-20240404-010', 5, 20800, '已完成', '台北市大安區敦化南路', '2024-04-04 10:00:00'),
('ORD-20240520-011', 11, 17500, '已送達', '台北市內湖區瑞光路', '2024-05-20 09:45:00'),
('ORD-20240618-012', 12, 13500, '已送達', '新北市新莊區思源路', '2024-06-18 21:15:00'),
('ORD-20240707-013', 13, 15800, '已送達', '台中市南屯區文心路', '2024-07-07 14:50:00'),
('ORD-20240808-014', 14, 16500, '已送達', '高雄市前鎮區中山二路', '2024-08-08 11:30:00'),
('ORD-20240909-015', 15, 3800, '已送達', '桃園市桃園區復興路', '2024-09-09 16:20:00'),
('ORD-20241010-016', 16, 14500, '處理中', '新竹縣竹北市自強南路', '2024-10-10 10:05:00'),
('ORD-20241111-017', 17, 21500, '處理中', '台南市安平區華平路', '2024-11-11 23:11:00'),
('ORD-20241212-018', 18, 12800, '處理中', '台北市松山區南京東路四段', '2024-12-12 12:12:00'),
('ORD-20241220-019', 19, 18800, '處理中', '高雄市鼓山區美術館路', '2024-12-20 19:40:00'),
('ORD-20241223-020', 20, 3800, '已取消', '基隆市仁愛區愛三路', '2024-12-23 09:00:00');

-- (5) 訂單明細 (Order Items)
INSERT IGNORE INTO order_items (order_id, product_id, product_name, quantity, price) VALUES 
('ORD-20230520-001', 'dbz-ssj4-gogeta', '七龍珠GT 超級賽亞人4 悟吉塔', 1, 16500),
('ORD-20230615-002', 'dbz-ssj-gogeta', '七龍珠Z 超級賽亞人 悟吉塔', 1, 14500),
('ORD-20230710-003', 'aot-levi', '進擊的巨人 里維兵長', 1, 21500),
('ORD-20230808-004', 'dbz-black', '七龍珠超 黑悟空 (超級賽亞人玫瑰)', 1, 12800),
('ORD-20230925-005', 'dbz-ssj4-goku', '七龍珠GT 孫悟空 (超級賽亞人4) WCF', 1, 3800),
('ORD-20231111-006', 'dbz-gohan-beast', '七龍珠超 孫悟飯 (野獸型態)', 1, 15800),
('ORD-20240105-007', 'bleach-white-ichigo', '死神 白一護 (完全虛化)', 1, 13800),
('ORD-20240214-008', 'demon-slayer-rengoku', '鬼滅之刃 炎柱 煉獄杏壽郎', 1, 18800),
('ORD-20240320-009', 'dbz-ui-goku', '七龍珠超 孫悟空 (自在極意功)', 1, 14200),
('ORD-20240404-010', 'aot-eren', '進擊的巨人 艾連·葉卡 (始祖巨人)', 1, 20800),
('ORD-20240520-011', 'demon-slayer-giyu', '鬼滅之刃 水柱 富岡義勇', 1, 17500),
('ORD-20240618-012', 'dbz-vegito', '七龍珠Z 貝吉特 (超級賽亞人)', 1, 13500),
('ORD-20240707-013', 'dbz-gohan-beast', '七龍珠超 孫悟飯 (野獸型態)', 1, 15800),
('ORD-20240808-014', 'dbz-ssj4-gogeta', '七龍珠GT 超級賽亞人4 悟吉塔', 1, 16500),
('ORD-20240909-015', 'dbz-ssj4-goku', '七龍珠GT 孫悟空 (超級賽亞人4) WCF', 1, 3800),
('ORD-20241010-016', 'dbz-ssj-gogeta', '七龍珠Z 超級賽亞人 悟吉塔', 1, 14500),
('ORD-20241111-017', 'aot-levi', '進擊的巨人 里維兵長', 1, 21500),
('ORD-20241212-018', 'dbz-black', '七龍珠超 黑悟空 (超級賽亞人玫瑰)', 1, 12800),
('ORD-20241220-019', 'demon-slayer-rengoku', '鬼滅之刃 炎柱 煉獄杏壽郎', 1, 18800),
('ORD-20241223-020', 'dbz-ssj4-goku', '七龍珠GT 孫悟空 (超級賽亞人4) WCF', 1, 3800);

-- (6) 強制更新熱銷商品標籤 (Force Update Tags)
-- Reset all tags first to avoid clutter
UPDATE products SET tag = NULL, type = 'figure';

-- 1. HOT (熱銷) - 4 Items
UPDATE products SET tag='HOT', type='hot' WHERE id IN (
    'dbz-gohan-beast',     -- 野獸悟飯
    'dbz-ssj4-gogeta',     -- 超四悟吉塔
    'aot-levi',            -- 兵長里維
    'demon-slayer-rengoku' -- 炎柱煉獄 (New)
);

-- 2. PRE-ORDER (預購) - 4 Items
UPDATE products SET tag='預購' WHERE id IN (
    'dbz-black',           -- 黑悟空
    'bleach-white-ichigo', -- 白一護 (Moved from Hot to Preorder to balance)
    'aot-eren',            -- 艾連
    'demon-slayer-giyu'    -- 水柱義勇 (New)
);

-- 3. IN-STOCK (現貨) - 4 Items
UPDATE products SET tag='現貨' WHERE id IN (
    'dbz-ui-goku',         -- 自在極意
    'dbz-ssj-gogeta',      -- 超賽悟吉塔
    'dbz-vegito',          -- 貝吉特
    'dbz-ssj4-goku'        -- 超四悟空
);