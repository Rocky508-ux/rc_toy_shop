package com.rctoyshop.backend.controller;

import com.rctoyshop.backend.dto.LoginRequest;
import com.rctoyshop.backend.model.User;
import com.rctoyshop.backend.security.JwtUtil;
import com.rctoyshop.backend.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 5. AuthController (櫃台窗口)：前端登入與註冊的入口
 * 依賴所有安全機制，最後寫。
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;
    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;

    // 注入：UserService (一般業務邏輯), AuthManager (Spring security 驗證工具), JwtUtil (發卡機)
    public AuthController(UserService userService, AuthenticationManager authenticationManager, JwtUtil jwtUtil) {
        this.userService = userService;
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
    }

    // 註冊 API：這比較單純，直接呼叫 UserService 寫入資料庫就好
    @PostMapping("/register")
    public ResponseEntity<User> registerUser(@RequestBody User user) {
        return new ResponseEntity<>(userService.registerNewUser(user), HttpStatus.CREATED);
    }

    // 登入 API：這是最關鍵的步驟！
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        try {
            // 1. 【驗證身分】
            // 把帳號密碼包成 Token (未認證)，丟給 AuthenticationManager
            // 它會去呼叫 CustomUserDetailsService -> 查 DB -> 比對密碼 (NoOpEncoder)
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));

            // 2. 【驗證成功】取得用戶詳細資料
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();

            // 3. 【發卡】呼叫 JwtUtil 製作 JWT Token
            String token = jwtUtil.generateToken(userDetails);

            // 4. 【準備回傳】取得完整 User 物件 (方便前端拿 id, role, name 等顯示用)
            User user = userService.authenticate(loginRequest.getEmail(), loginRequest.getPassword()); // 這裡直接查 DB 比對

            // 5. 【包裝結果】 Token + User Info 一起傳回去
            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            response.put("user", user);

            return ResponseEntity.ok(response);

        } catch (AuthenticationException e) {
            // 6. 驗證失敗 (帳號不存在或密碼錯誤) -> 回傳 401 Unauthorized
            return new ResponseEntity<>("Invalid email or password", HttpStatus.UNAUTHORIZED);
        }
    }
}