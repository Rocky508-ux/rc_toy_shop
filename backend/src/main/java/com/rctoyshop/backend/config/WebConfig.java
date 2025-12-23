package com.rctoyshop.backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置靜態資源路徑
        // 當前端請求 /image/** 時，Spring Boot 會依序去這裡找：
        // 1. classpath:/static/image/ (原本包在 jar 檔裡的舊圖片)
        // 2. file:./uploads/ (我們新建立的外部資料夾，用來存上傳的圖片)
        registry.addResourceHandler("/image/**")
                .addResourceLocations("classpath:/static/image/")
                .addResourceLocations("file:./uploads/");
    }
}