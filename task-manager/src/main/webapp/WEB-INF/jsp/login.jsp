<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Quản lý Công việc</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to bottom right, #e0f7fa, #e8eaf6);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
        }
        .login-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
        }
        .form-control:focus {
            border-color: #6610f2;
            box-shadow: 0 0 0 0.25rem rgba(102, 16, 242, 0.25);
        }
        .btn-primary {
            background-color: #6610f2;
            border-color: #6610f2;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #560ce0;
            border-color: #560ce0;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(102, 16, 242, 0.3);
        }
        .alert {
            border-radius: 8px;
            font-size: 0.9rem;
        }
        h2 {
            color: #6610f2;
            font-weight: 700;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2 class="text-center">Đăng nhập</h2>
        <div id="message" class="alert d-none" role="alert"></div>
        <form id="loginForm">
            <div class="mb-3">
                <label for="username" class="form-label">Tên đăng nhập</label>
                <input type="text" class="form-control" id="username" required>
            </div>
            <div class="mb-4">
                <label for="password" class="form-label">Mật khẩu</label>
                <input type="password" class="form-control" id="password" required minlength="6">
                <div class="invalid-feedback">Mật khẩu phải có ít nhất 6 ký tự.</div>
            </div>
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary btn-lg">Đăng nhập</button>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('loginForm').addEventListener('submit', async function(event) {
            event.preventDefault();
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const messageDiv = document.getElementById('message');

            // Client-side validation
            if (password.length < 6) {
                document.getElementById('password').classList.add('is-invalid');
                messageDiv.classList.remove('d-none', 'alert-success');
                messageDiv.classList.add('alert-danger');
                messageDiv.textContent = 'Mật khẩu phải có ít nhất 6 ký tự.';
                setTimeout(() => { messageDiv.classList.add('d-none'); }, 5000);
                return;
            } else {
                document.getElementById('password').classList.remove('is-invalid');
            }

            try {
                const response = await fetch('/auth/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username, password })
                });

                if (response.ok) {
                    const data = await response.json();
                    localStorage.setItem('jwtToken', data.token);
                    localStorage.setItem('userRole', data.role);
                    localStorage.setItem('username', username);
                    messageDiv.classList.remove('d-none', 'alert-danger');
                    messageDiv.classList.add('alert-success');
                    messageDiv.textContent = 'Đăng nhập thành công! Đang chuyển hướng...';
                    setTimeout(() => {
                        // Chuyển hướng dựa trên vai trò
                        if (data.role === 'ADMIN') {
                            window.location.href = '/dashboard-page';
                        } else {
                            window.location.href = '/project-management-page';
                        }
                    }, 1500);
                } else {
                    const errorText = await response.text();
                    messageDiv.classList.remove('d-none', 'alert-success');
                    messageDiv.classList.add('alert-danger');
                    messageDiv.textContent = `Đăng nhập thất bại: ${errorText}`;
                }
            } catch (error) {
                console.error('Lỗi kết nối:', error);
                messageDiv.classList.remove('d-none', 'alert-success');
                messageDiv.classList.add('alert-danger');
                messageDiv.textContent = 'Lỗi kết nối đến server. Vui lòng thử lại.';
            } finally {
                setTimeout(() => {
                    messageDiv.classList.add('d-none');
                }, 5000);
            }
        });
    </script>
</body>
</html>