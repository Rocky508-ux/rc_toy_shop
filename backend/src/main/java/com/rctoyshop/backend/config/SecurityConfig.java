package com.rctoyshop.backend.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.rctoyshop.backend.filter.JwtAuthenticationFilter;
import com.rctoyshop.backend.service.CustomUserDetailsService;

/**
 * 4. SecurityConfig (總部規則)：把上面的元件組合起來，設定防火牆規則
 * 最後寫，因為它要注入 Filter 和 Service。
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthFilter;
    private final CustomUserDetailsService userDetailsService;

    // 注入我們先前寫好的 Filter (守門員) 和 Service (翻譯官)
    public SecurityConfig(JwtAuthenticationFilter jwtAuthFilter, CustomUserDetailsService userDetailsService) {
        this.jwtAuthFilter = jwtAuthFilter;
        this.userDetailsService = userDetailsService;
    }

    // --- 設定防火牆主邏輯 ---
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // 關閉 CSRF (因為我們是用 Token，不需要 Cookie Session 防護)
                .cors(cors -> cors.configurationSource(corsConfigurationSource())) // 設定 CORS (允許前端跨網域呼叫)

                // 1. 設定放行規則
                // 目前是 .anyRequest().permitAll() (全部放行) -> 這通常是為了開發方便
                // 如果要嚴格控管，會寫成 .requestMatchers("/admin/**").hasRole("ADMIN")
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll())

                // 2. 設定無狀態 (Stateless)
                // 告訴 Spring Security：不要建立 Session，不要用 Cookie 記住使用者。我們只認 Token。
                .sessionManagement(sess -> sess
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                // 3. 把我們的 JWT 守門員插隊進去
                // 插在 UsernamePasswordAuthenticationFilter 之前，這樣請求一來先檢查 Token
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    // --- 密碼編碼器設定 ---
    @SuppressWarnings("deprecation")
    @Bean
    public PasswordEncoder passwordEncoder() {
        // 使用 NoOp (明碼)，不加密。方便您直接看資料庫。
        // 正式環境應該用 BCryptPasswordEncoder。
        return NoOpPasswordEncoder.getInstance();
    }

    // --- 認證管理器 ---
    // 這是一個 Helper Bean，讓 AuthController 可以呼叫它來驗證帳號密碼
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    // --- CORS 設定 (跨來源資源共享) ---
    // 允許前端 (localhost:5173 等) 來呼叫後端 API，不然會被瀏覽器擋住
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        // 允許的前端網址
        configuration.setAllowedOrigins(List.of("http://localhost:5173", "http://localhost:3000",
                "http://127.0.0.1:5500", "http://localhost:8080"));
        configuration.addAllowedOriginPattern("*");

        // 允許的方法 (GET, POST, PUT, DELETE...)
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
