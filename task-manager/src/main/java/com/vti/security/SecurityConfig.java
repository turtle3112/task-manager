package com.vti.security;

import jakarta.servlet.http.HttpServletResponse; // Cần thiết cho xử lý lỗi 403
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider; // Cần để tạo AuthenticationProvider
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.Http403ForbiddenEntryPoint; // Cần thiết cho xử lý lỗi 403

@Configuration
@EnableWebSecurity
@EnableMethodSecurity // Quan trọng để dùng @PreAuthorize, @PostAuthorize
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final CustomUserDetailsService userDetailsService; // Cần để cấu hình DaoAuthenticationProvider

    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter,
                          CustomUserDetailsService userDetailsService) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
        this.userDetailsService = userDetailsService;
    }

    // Cấu hình để bỏ qua các tài nguyên tĩnh và các file JSP nội bộ khỏi Spring Security filter chain
    // Đây là nơi duy nhất nên dùng .ignoring(), cho các tài nguyên mà Spring Security không cần xử lý.
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().requestMatchers(
            "/WEB-INF/jsp/**" // Bỏ qua các file JSP trong WEB-INF (chỉ được forward nội bộ)
            // Các tài nguyên tĩnh cũng có thể bỏ qua ở đây, hoặc permitAll() bên dưới.
            // Nếu bạn gặp lỗi 404 cho CSS/JS, hãy đảm bảo chúng được permitAll() hoặc bỏ qua ở đây.
        );
    }

    // Cấu hình DaoAuthenticationProvider để Spring Security biết cách tải UserDetails và mã hóa mật khẩu
    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable) // Vô hiệu hóa CSRF cho API stateless (vì dùng JWT)
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // Cấu hình không sử dụng session
            .authorizeHttpRequests(authorize -> authorize
                // --- CÁC ĐƯỜNG DẪN CÔNG KHAI (PERMIT ALL) ---
                // Trang chủ (thường redirect tới login) và API đăng nhập
                .requestMatchers("/", "/auth/login").permitAll()
                // Trang lỗi
                .requestMatchers("/error").permitAll()

                // CÁC TRANG JSP (VIEWS) CŨNG PHẢI LÀ PERMITALL.
                // Lý do: Khi trình duyệt tải các trang này (GET request), nó KHÔNG gửi JWT.
                // Logic kiểm tra JWT và vai trò SẼ ĐƯỢC XỬ LÝ BỞI JAVASCRIPT trong chính các file JSP đó.
                .requestMatchers("/login-page").permitAll()
                .requestMatchers("/register-page").permitAll()
                .requestMatchers("/dashboard-page").permitAll()
                .requestMatchers("/project-management-page").permitAll()

                // Các tài nguyên tĩnh (nên được permitAll() nếu không dùng webSecurityCustomizer cho chúng)
                // Đây là cách tốt hơn để xử lý các tài nguyên tĩnh so với .ignoring()
                .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()

                // --- CÁC API ENDPOINT ĐƯỢC BẢO VỆ (YÊU CẦU JWT) ---
                // Các API chỉ dành cho ADMIN (Kiểm tra bằng JWT và vai trò)
                // Endpoint đăng ký người dùng mới (phải có vai trò ADMIN)
                .requestMatchers("/auth/v2/register").hasRole("ADMIN")
                .requestMatchers("/users/**").hasRole("ADMIN") // Giả sử tất cả API /users chỉ ADMIN
                .requestMatchers("/projects").hasRole("ADMIN") // API tạo dự án (POST)
                .requestMatchers("/projects/**").hasRole("ADMIN") // API quản lý dự án (GET/PUT/DELETE)
                .requestMatchers("/tasks").hasRole("ADMIN") // API tạo task (POST)
                .requestMatchers("/tasks/all").hasRole("ADMIN") // API lấy tất cả task (cho Dashboard Admin)
                .requestMatchers("/audit-logs/**").hasRole("ADMIN")

                // Các API yêu cầu xác thực (cho cả ADMIN và EMPLOYEE)
                // Các API này sẽ được gọi từ JS trong các trang JSP với JWT được gửi kèm.
                .requestMatchers("/notifications/**").authenticated()
                .requestMatchers("/tasks/project/**").authenticated()
                .requestMatchers("/tasks/{taskId}/status").authenticated()
                .requestMatchers("/comments/**").authenticated()
                .requestMatchers("/attachments/**").authenticated()
                .requestMatchers("/progress-logs/**").authenticated()

                // Mọi request khác đều yêu cầu xác thực (fallback)
                .anyRequest().authenticated()
            )
            // Cấu hình AuthenticationProvider
            .authenticationProvider(authenticationProvider())
            // Thêm bộ lọc JWT của bạn trước bộ lọc xác thực Username/Password mặc định của Spring Security
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
            // Xử lý ngoại lệ (ví dụ: 401 Unauthorized, 403 Forbidden)
            .exceptionHandling(exception -> exception
                .authenticationEntryPoint(new Http403ForbiddenEntryPoint()) // Xử lý khi người dùng chưa xác thực (JWT thiếu/sai)
                .accessDeniedHandler((request, response, accessDeniedException) ->
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You don't have permission to access this resource.")) // Xử lý khi người dùng đã xác thực nhưng không có quyền
            );

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}