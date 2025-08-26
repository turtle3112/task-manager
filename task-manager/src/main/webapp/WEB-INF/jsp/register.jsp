<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Quản lý Công việc</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to bottom right, #f3e5f5, #e1bee7);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
        }
        .register-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
        }
        .form-control:focus {
            border-color: #9c27b0;
            box-shadow: 0 0 0 0.25rem rgba(156, 39, 176, 0.25);
        }
        .btn-primary {
            background-color: #9c27b0;
            border-color: #9c27b0;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #8e24aa;
            border-color: #8e24aa;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(156, 39, 176, 0.3);
        }
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
            transition: all 0.3s ease;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(108, 117, 125, 0.3);
        }
        .alert {
            border-radius: 8px;
            font-size: 0.9rem;
        }
        h2 {
            color: #9c27b0;
            font-weight: 700;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2 class="text-center">Đăng ký người dùng mới (Chỉ ADMIN)</h2>
        <div id="message" class="alert d-none" role="alert"></div>
        <form id="registerForm">
            <div class="mb-3">
                <label for="username" class="form-label">Tên đăng nhập</label>
                <input type="text" class="form-control" id="username" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Mật khẩu</label>
                <input type="password" class="form-control" id="password" required pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$">
                <div class="invalid-feedback">Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.</div>
            </div>
            <div class="mb-3">
                <label for="fullName" class="form-label">Họ và tên</label>
                <input type="text" class="form-control" id="fullName" required>
            </div>
            <div class="mb-3">
                <label for="employeeId" class="form-label">Mã nhân viên</label>
                <input type="text" class="form-control" id="employeeId" required>
            </div>
            <div class="mb-4">
                <label for="role" class="form-label">Vai trò</label>
                <select class="form-select" id="role">
                    <option value="EMPLOYEE" selected>EMPLOYEE</option>
                    <option value="ADMIN">ADMIN</option>
                </select>
            </div>
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary btn-lg">Đăng ký</button>
                <a href="/login-page" class="btn btn-secondary btn-lg">Quay lại Đăng nhập</a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const token = localStorage.getItem('jwtToken');
            const userRole = localStorage.getItem('userRole');
            const messageDiv = document.getElementById('message');

            // Kiểm tra quyền truy cập khi tải trang
            if (!token || userRole !== 'ADMIN') {
                messageDiv.classList.remove('d-none', 'alert-success');
                messageDiv.classList.add('alert-danger');
                messageDiv.textContent = 'Bạn không có quyền truy cập trang này. Vui lòng đăng nhập với vai trò ADMIN.';
                setTimeout(() => {
                    window.location.href = '/login-page';
                }, 3000); // Chuyển hướng sau 3 giây
                return; // Dừng thực thi script
            }
        });

        document.getElementById('registerForm').addEventListener('submit', async function(event) {
            event.preventDefault();
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const fullName = document.getElementById('fullName').value;
            const employeeId = document.getElementById('employeeId').value;
            const role = document.getElementById('role').value;
            const messageDiv = document.getElementById('message');

            // Client-side password validation
            const passwordInput = document.getElementById('password');
            const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
            if (!passwordPattern.test(password)) {
                passwordInput.classList.add('is-invalid');
                messageDiv.classList.remove('d-none', 'alert-success');
                messageDiv.classList.add('alert-danger');
                messageDiv.textContent = 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.';
                setTimeout(() => { messageDiv.classList.add('d-none'); }, 5000);
                return;
            } else {
                passwordInput.classList.remove('is-invalid');
            }

            const token = localStorage.getItem('jwtToken');
            const userRole = localStorage.getItem('userRole');

            // Kiểm tra lại quyền truy cập trước khi gửi form (phòng trường hợp vai trò thay đổi giữa chừng)
            if (!token || userRole !== 'ADMIN') {
                messageDiv.classList.remove('d-none', 'alert-success');
                messageDiv.classList.add('alert-danger');
                messageDiv.textContent = 'Phiên làm việc của bạn đã hết hạn hoặc bạn không có quyền. Vui lòng đăng nhập lại.';
                localStorage.removeItem('jwtToken'); // Xóa token cũ
                localStorage.removeItem('userRole');
                localStorage.removeItem('username');
                setTimeout(() => {
                    window.location.href = '/login-page';
                }, 2000); // Chuyển hướng sau 2 giây
                return;
            }

            try {
                const response = await fetch('/auth/v2/register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify({ username, password, fullName, employeeId, role })
                });

                if (response.ok) {
                    messageDiv.classList.remove('d-none', 'alert-danger');
                    messageDiv.classList.add('alert-success');
                    messageDiv.textContent = 'Đăng ký người dùng thành công!';
                    // Clear form
                    document.getElementById('username').value = '';
                    document.getElementById('password').value = '';
                    document.getElementById('fullName').value = '';
                    document.getElementById('employeeId').value = '';
                    document.getElementById('role').value = 'EMPLOYEE';
                } else {
                    // Xử lý lỗi 401/403 từ server (token hết hạn hoặc không có quyền)
                    if (response.status === 401 || response.status === 403) {
                        messageDiv.classList.remove('d-none', 'alert-success');
                        messageDiv.classList.add('alert-danger');
                        messageDiv.textContent = 'Phiên làm việc của bạn đã hết hạn hoặc bạn không có quyền. Vui lòng đăng nhập lại.';
                        localStorage.removeItem('jwtToken');
                        localStorage.removeItem('userRole');
                        localStorage.removeItem('username');
                        setTimeout(() => {
                            window.location.href = '/login-page';
                        }, 2000);
                    } else {
                        const errorText = await response.text();
                        messageDiv.classList.remove('d-none', 'alert-success');
                        messageDiv.classList.add('alert-danger');
                        messageDiv.textContent = `Đăng ký thất bại: ${errorText}`;
                    }
                }
            } catch (error) {
                console.error('Lỗi kết nối:', error);
                messageDiv.classList.remove('d-none', 'alert-success');
                messageDiv.classList.add('alert-danger');
                messageDiv.textContent = 'Lỗi kết nối đến server. Vui lòng thử lại.';
            } finally {
                setTimeout(() => { messageDiv.classList.add('d-none'); }, 5000);
            }
        });
    </script>
</body>
</html>