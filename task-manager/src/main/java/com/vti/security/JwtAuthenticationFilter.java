package com.vti.security;

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

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;
    private final CustomUserDetailsService userDetailsService;

    public JwtAuthenticationFilter(JwtTokenProvider jwtTokenProvider, CustomUserDetailsService userDetailsService) {
        this.jwtTokenProvider = jwtTokenProvider;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        // Lấy header 'Authorization' từ request
        String header = request.getHeader("Authorization");

        // Kiểm tra xem header có tồn tại và bắt đầu bằng "Bearer " không
        if (header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7); // Trích xuất token JWT (bỏ qua "Bearer ")

            try {
                // 1. Validate token
                if (jwtTokenProvider.validateToken(token)) {
                    // 2. Lấy username từ token
                    String username = jwtTokenProvider.getUsernameFromToken(token);

                    // 3. Tải thông tin người dùng (UserDetails) từ username
                    UserDetails userDetails = userDetailsService.loadUserByUsername(username);

                    // 4. Tạo đối tượng xác thực (Authentication)
                    UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities()); // userDetails là Principal, null là Credentials (vì token đã xác thực rồi), userDetails.getAuthorities() là quyền hạn
                    
                    // 5. Thêm chi tiết web request vào đối tượng xác thực
                    authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                    // 6. Đặt đối tượng xác thực vào SecurityContextHolder
                    // Điều này cho phép Spring Security biết người dùng hiện tại đã được xác thực
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                }
            } catch (Exception ex) {
                // Xử lý các ngoại lệ khi xác thực JWT (ví dụ: token hết hạn, không hợp lệ, chữ ký sai)
                // Trong môi trường thực tế, bạn có thể muốn ghi log lỗi chi tiết hơn
                // hoặc sử dụng một AuthenticationEntryPoint tùy chỉnh để trả về mã lỗi cụ thể (ví dụ 401)
                // System.err.println("JWT authentication failed for request to " + request.getRequestURI() + ": " + ex.getMessage());
                // Không cần làm gì thêm ở đây, vì nếu không có authentication được đặt,
                // Spring Security sẽ coi request là chưa xác thực và áp dụng các quy tắc trong SecurityConfig
            }
        }
        
        // Tiếp tục chuỗi bộ lọc.
        // Nếu không có token hợp lệ hoặc không có authentication được đặt,
        // các bộ lọc bảo mật tiếp theo sẽ xử lý request dựa trên cấu hình trong SecurityConfig.
        filterChain.doFilter(request, response);
    }
}