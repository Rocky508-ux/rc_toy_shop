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

        // 2. 檢查帳號狀態 (停用/ACTIVE)
        String status = user.getStatus() != null ? user.getStatus().toLowerCase() : "active";
        boolean enabled = "active".equals(status);

        // 3. (翻譯) 把我們的 User 轉換成 Spring Security 看得懂的 UserDetails
        // 使用完整建構子: User(username, password, enabled, accountNonExpired,
        // credentialsNonExpired, accountNonLocked, authorities)
        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPassword(),
                enabled, // ★★★ 這裡傳入 true/false，Spring Security 會自動檢查並拋出 DisabledException
                true, // accountNonExpired
                true, // credentialsNonExpired
                true, // accountNonLocked
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + user.getRole())));
    }
}
