# --- 採用「多階段構建 (Multi-Stage Build)」---
# 這樣的好處是：我們可以用一個很大的 Image (含 Gradle) 來編譯
# 然後只把編譯好的 Jar 檔丟到一個很小的 Image (JRE) 去跑
# 結果：產出的 Image 會非常輕量 (可能只有 200MB)，而不是 800MB+

# [階段 1]：負責編譯 (Builder)
# 使用包含 Gradle 和 JDK 21 的官方映像檔
FROM gradle:8.5-jdk21 AS builder

# 設定工作目錄為 /app
WORKDIR /app

# 把目前目錄 (.) 下的所有檔案複製到 Container 的目前目錄 (.)
COPY . .

# 執行 Gradle 指令來打包專案
# clean: 清除舊的編譯檔
# build: 開始編譯
# -x test: 跳過測試 (省時間，除非您真的很想跑單元測試)
# --no-daemon: 不使用守護進程 (省記憶體)
RUN ./gradlew clean build -x test --no-daemon

# ------------------------------------------------------------------

# [階段 2]：負責執行 (Runner)
# 使用超輕量的 Alpine Linux 版本 (只含 JRE，不含編譯工具)
FROM eclipse-temurin:21-jre-alpine

# 設定工作目錄
WORKDIR /app

# ★關鍵步驟★：從 [階段 1] (builder) 那裡，把編譯好的 .jar 檔複製過來
# 這樣我們就不用在生產環境安裝 Gradle 了
# ★關鍵步驟★：從 [階段 1] (builder) 那裡，把編譯好的 .jar 檔複製過來
# 因為我們在 build.gradle 禁用了 plain jar，所以這邊只會有一顆胖 Jar
COPY --from=builder /app/build/libs/backend-*.jar app.jar

# 宣告這個 Container 會使用 8080 Port
EXPOSE 8080

# 設定啟動指令：執行 Java Jar 檔
ENTRYPOINT ["java", "-jar", "app.jar"]
