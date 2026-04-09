package com.rctoyshop.backend.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.MappedCollection;
import org.springframework.data.relational.core.mapping.Table;
import org.springframework.data.relational.core.mapping.Column; // 用於映射底線命名
import lombok.Data;

import java.time.LocalDateTime; // 用於映射 SQL 的 TIMESTAMP 類型
import java.util.Set; // 用於儲存關聯的訂單明細

import org.springframework.data.domain.Persistable; // 引入 Persistable

@Data
@Table("orders")
public class Order implements Persistable<String> { // 實作 Persistable

    // 1. 主鍵：使用 Spring Data JDBC 的 @Id
    @Id
    private String id; // 自訂訂單編號，類型是 String

    // 2. 外部鍵 (Foreign Key)：直接保留欄位，使用駝峰命名並顯式映射
    @Column("user_id")
    private Integer userId;

    @Column("total_amount")
    private Integer totalAmount;

    @Column("total_items")
    private Integer totalItems;

    private String status;

    // 3. 日期：使用 Java 8 的 LocalDateTime，並顯式映射
    @Column("order_date")
    private LocalDateTime orderDate;

    // 📢 建議新增：收件地址
    // 📢 建議新增：收件地址
    @Column("shipping_address")
    // 不可以是純數字，且長度至少 5
    @jakarta.validation.constraints.Pattern(regexp = "^(?!\\d+$).{5,}$", message = "Invalid shipping address")
    private String shippingAddress;

        // 4. 關聯性 (一對多)：使用 @MappedCollection 連結到 OrderItem
        // 這會告訴 JDBC 在載入 Order 時，同時載入 OrderItem 集合
        // idColumn = "order_id" 表示 OrderItem 表中用來連接到 Order 的欄位名稱
        // 這裡使用 Set 而不是 List：
        // - Set 會避免「完全相同的 OrderItem 被放兩次」（由 @Data 產生的 equals/hashCode 判斷）
        // - 每一筆 OrderItem 在資料庫有不同的 id，因此正常情況下不會吃掉「同一商品但不同明細」
        @MappedCollection(idColumn = "order_id")
        private Set<OrderItem> items;

    // --- Persistable 實作 ---

    // 定義一個暫時欄位來標記是否為新物件 (不映射到資料庫)
    @org.springframework.data.annotation.Transient
    private boolean isNew = true;

    @Override
    public boolean isNew() {
        return isNew;
    }

    // 載入後設為 false (雖然對於 createOrder 來說主要是初始值 true 重要)
    public void markNotNew() {
        this.isNew = false;
    }
}