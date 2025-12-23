package com.rctoyshop.backend.service;

import java.util.Collections;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.rctoyshop.backend.model.User;
import com.rctoyshop.backend.repository.UserRepository;

/**
 * 2. CustomUserDetailsService (翻譯官)：負責銜接 DB 資料與 Spring Security
 * 也是基礎依賴，不依賴 Filter，所以第二個寫。
 */
@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // 這是 Spring Security 規定要實作的方法：「給我一個 username，我給你一個完整的 UserDetails」
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        // 1. 去資料庫找人 (在我們的系統中，Email 就是帳號)
        User user = userRepository.findByEmail(email);
        if (user == null) {
            throw new UsernameNotFoundException("找無此人: " + email);
        }

        // 2. (額外邏輯) 檢查帳號狀態。如果是 "disabled" (停用)，就不准登入
        String status = user.getStatus() != null ? user.getStatus().toLowerCase() : "active";
        // 比對字串，確保不是 'active' 就拋出例外
        if (!"active".equals(status)) {
            // 這個 Exception 會被 Spring Security 捕捉，視為登入失敗
            throw new UsernameNotFoundException("帳號已被停用: " + email);
        }

        // 3. (翻譯) 把我們的 User 轉換成 Spring Security 看得懂的 UserDetails
        // 這裡回傳的是 org.springframework.security.core.userdetails.User
        return new org.springframework.security.core.userdetails.User(
                user.getEmail(), // 帳號
                user.getPassword(), // 密碼 (我們會比對這個)
                // 權限：Spring Security 喜歡 "ROLE_" 開頭，所以我們把 ADMIN 變成 ROLE_ADMIN
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + user.getRole())));
    }
}
