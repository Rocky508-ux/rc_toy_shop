-- (1) 使用者
INSERT IGNORE INTO users (email, password, name, role, status, phone, birthday) VALUES 
('admin@rc.com', 'admin123', 'Admin User', 'ADMIN', 'ACTIVE', '0912345678', '1990-01-01'),
('user@example.com', 'password', 'Normal User', 'USER', 'ACTIVE', '0923456789', '1995-05-20'),
('user2@example.com', '123456', 'User2', 'USER', 'ACTIVE', '0934567890', '2000-10-10');

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
INSERT IGNORE INTO orders (id, user_id, total_amount, status, shipping_address) VALUES 
('ORD-20231212-001', 2, 21500, '已送達', '台北市信義區市府路45號'),
('ORD-NEW-USER', 3, 15800, '處理中', '高雄市新興區');

-- (5) 訂單明細 (Order Items)
INSERT IGNORE INTO order_items (order_id, product_id, product_name, quantity, price) VALUES 
('ORD-20231212-001', 'aot-levi', '進擊的巨人 里維兵長', 1, 21500),
('ORD-NEW-USER', 'dbz-gohan-beast', '七龍珠超 孫悟飯 (野獸型態)', 1, 15800);

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
