package com.rctoyshop.backend.filter;

import com.rctoyshop.backend.security.JwtUtil;
import com.rctoyshop.backend.service.CustomUserDetailsService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * 3. JwtAuthenticationFilter (守門員)：攔截每個 Request，檢查 Token
 * 依賴上面的 Util 和 Service，是安全機制的執行者。
 */
@Component // 加上這個讓 Spring 自動管理它，稍後 SecurityConfig 才能注入使用
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final CustomUserDetailsService userDetailsService;

    // 建構子注入：需要造卡工具 (JwtUtil) 和 查人工具 (Service)
    public JwtAuthenticationFilter(JwtUtil jwtUtil, CustomUserDetailsService userDetailsService) {
        this.jwtUtil = jwtUtil;
        this.userDetailsService = userDetailsService;
    }

    // 當 Request 進來時，會執行這個方法
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        // 1. 從 Header 抓有沒有 Authorization 欄位
        final String authorizationHeader = request.getHeader("Authorization");

        String username = null;
        String jwt = null;

        // 2. 檢查格式：必須是 "Bearer " 開頭的字串
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            jwt = authorizationHeader.substring(7); // 切掉 "Bearer " (7個字)，剩下就是 Token 本體
            try {
                username = jwtUtil.extractUsername(jwt); // 叫工具人去讀 Token 裡面的名字
            } catch (Exception e) {
                // 如果 Token 是假的、壞的或過期的，這裡會報錯。我們印個 Log 就好，不讓它通過。
                System.out.println("JWT Token validation failed: " + e.getMessage());
            }
        }

        // 3. 如果有名字，而且系統目前還不知道這個人是誰 (SecurityContext 是空的)
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {

            // 去 DB 查一下這個人的最新權限 (確保他沒被刪除或停用)
            UserDetails userDetails = this.userDetailsService.loadUserByUsername(username);

            // 4. 最後確認：Token 簽名是對的嗎？沒過期嗎？
            if (jwtUtil.validateToken(jwt, userDetails)) {

                // 5. 通行！建立一個 "認證通過" 的信物 (Authentication Token)
                UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());

                // 補上一些細節 (如來源 IP)
                usernamePasswordAuthenticationToken
                        .setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // 6. 把這個信物存進 SecurityContext，這樣後面的 Controller 就知道此人已登入！
                SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
            }
        }

        // 7. 繼續往下走 (不管有沒有登入，都要繼續走 Link，沒登入的會在後面被擋下)
        chain.doFilter(request, response);
    }
}
