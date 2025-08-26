<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Quản lý Công việc</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background: linear-gradient(to bottom right, #e3f2fd, #f0f4c3);
            min-height: 100vh;
            font-family: 'Inter', sans-serif;
            color: #333;
        }
        .navbar {
            background-color: #1976d2; /* Darker blue for navbar */
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .navbar-brand, .nav-link {
            color: #ffffff !important;
        }
        .navbar-brand:hover, .nav-link:hover {
            color: #e3f2fd !important;
        }
        .container-fluid {
            padding-top: 20px;
            padding-bottom: 20px;
        }
        .card {
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: transform 0.2s ease-in-out;
        }
        .card:hover {
            transform: translateY(-3px);
        }
        .list-section h4 {
            color: #1976d2;
            margin-bottom: 20px;
        }
        .table-responsive {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            padding: 15px;
        }
        .table {
            margin-bottom: 0;
        }
        .table thead th {
            background-color: #e3f2fd;
            color: #1976d2;
            font-weight: 600;
        }
        .table tbody tr:hover {
            background-color: #f5f5f5;
        }
        .audit-log-stats table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .audit-log-stats th, .audit-log-stats td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        .audit-log-stats tbody tr:last-child td {
            border-bottom: none;
        }
        .audit-log-stats tbody tr:hover {
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Dashboard Admin</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <span class="nav-link">Xin chào, <span id="usernameDisplay"></span> (<span id="roleDisplay"></span>)</span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/project-management-page">Quản lý Dự án</a>
                    </li>
                    <li class="nav-item">
                        <button class="btn btn-light text-dark" id="logoutBtn">Đăng xuất</button>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div id="message" class="alert d-none" role="alert"></div>

        <h2 class="mb-4 text-primary">Dashboard Quản trị viên</h2>

        <div class="card mt-4 p-4">
            <h3 class="card-title text-primary mb-4">Thống kê nhật ký kiểm toán</h3>
            <div id="auditLogStats" class="audit-log-stats">
                <p class="text-center text-muted">Đang tải thống kê...</p>
            </div>
            <p class="text-muted mt-3">Lưu ý: Thống kê này hiển thị số lượng hoạt động hàng ngày trong 7 ngày gần nhất.</p>
        </div>

        <div class="row mt-5">
            <div class="col-md-6 mb-4">
                <div class="card list-section p-4">
                    <h4 class="card-title">Tất cả dự án</h4>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên dự án</th>
                                    <th>Mô tả</th>
                                </tr>
                            </thead>
                            <tbody id="allProjectsTableBody">
                                <tr><td colspan="3" class="text-center text-muted">Đang tải dự án...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <div class="card list-section p-4">
                    <h4 class="card-title">Tất cả công việc</h4>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên công việc</th>
                                    <th>Trạng thái</th>
                                    <th>Dự án</th>
                                </tr>
                            </thead>
                            <tbody id="allTasksTableBody">
                                <tr><td colspan="4" class="text-center text-muted">Đang tải công việc...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="card mt-5 p-4">
            <h3 class="card-title text-primary mb-4">Tất cả nhân viên</h3>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên đăng nhập</th>
                            <th>Họ và tên</th>
                            <th>Mã nhân viên</th>
                            <th>Vai trò</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody id="allUsersTableBody">
                        <tr><td colspan="6" class="text-center text-muted">Đang tải nhân viên...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editUserModalLabel">Chỉnh sửa thông tin nhân viên</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editUserForm">
                        <input type="hidden" id="editUserId">
                        <div class="mb-3">
                            <label for="editUsername" class="form-label">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="editUsername" disabled>
                        </div>
                        <div class="mb-3">
                            <label for="editFullName" class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" id="editFullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editEmployeeId" class="form-label">Mã nhân viên</label>
                            <input type="text" class="form-control" id="editEmployeeId" required>
                        </div>
                        <div class="mb-4">
                            <label for="editRole" class="form-label">Vai trò</label>
                            <select class="form-select" id="editRole">
                                <option value="EMPLOYEE">EMPLOYEE</option>
                                <option value="ADMIN">ADMIN</option>
                            </select>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const API_BASE_URL = ''; // Để trống nếu chạy trên cùng domain/port, hoặc chỉ định full URL như 'http://localhost:8080'

        // --- Helper Function for Messages ---
        function showMessage(msg, type = 'success') {
            const messageDiv = document.getElementById('message');
            messageDiv.classList.remove('d-none', 'alert-success', 'alert-danger', 'alert-warning');
            messageDiv.classList.add(`alert-${type}`);
            messageDiv.textContent = msg;
            setTimeout(() => {
                messageDiv.classList.add('d-none');
            }, 5000);
        }

        // --- Global Fetch with Authentication Wrapper ---
        async function fetchWithAuth(url, options = {}) {
            const token = localStorage.getItem('jwtToken');

            if (!token) {
                console.warn('Không có JWT token, chuyển hướng đến trang đăng nhập.');
                localStorage.removeItem('userRole');
                localStorage.removeItem('username');
                window.location.href = '/login-page';
                return Promise.reject(new Error('No authentication token.'));
            }

            const headers = {
                ...options.headers,
                'Authorization': `Bearer ${token}`
            };

            const newOptions = { ...options, headers: headers };

            try {
                const response = await fetch(url, newOptions);

                if (response.status === 401 || response.status === 403) {
                    console.error('Truy cập không được ủy quyền hoặc bị cấm. Token có thể đã hết hạn. Chuyển hướng đến trang đăng nhập.');
                    localStorage.removeItem('jwtToken');
                    localStorage.removeItem('userRole');
                    localStorage.removeItem('username');
                    showMessage('Phiên làm việc của bạn đã hết hạn hoặc bạn không có quyền. Vui lòng đăng nhập lại.', 'danger');
                    setTimeout(() => {
                        window.location.href = '/login-page';
                    }, 2000);
                    return Promise.reject(new Error('Unauthorized or Forbidden.'));
                }

                return response;
            } catch (error) {
                console.error('Lỗi mạng trong fetchWithAuth:', error);
                throw error;
            }
        }


        // --- Authentication & Initialization ---
        document.addEventListener('DOMContentLoaded', () => {
            const token = localStorage.getItem('jwtToken');
            const userRole = localStorage.getItem('userRole');
            const currentUsername = localStorage.getItem('username');

            if (!token || userRole !== 'ADMIN') {
                showMessage('Bạn không có quyền truy cập trang này. Vui lòng đăng nhập với vai trò ADMIN.', 'danger');
                setTimeout(() => {
                    window.location.href = '/login-page';
                }, 3000);
                return;
            }
            document.getElementById('usernameDisplay').textContent = currentUsername || 'Người dùng';
            document.getElementById('roleDisplay').textContent = userRole;

            fetchAuditLogs();
            fetchAllProjectsForAdmin();
            fetchAllTasksForAdmin();
            fetchAllUsersForAdmin();
        });

        document.getElementById('logoutBtn').addEventListener('click', () => {
            localStorage.removeItem('jwtToken');
            localStorage.removeItem('userRole');
            localStorage.removeItem('username');
            window.location.href = '/login-page';
        });

        // --- Fetch Data Functions for Admin Dashboard ---
        async function fetchAuditLogs() {
            const auditLogStatsDiv = document.getElementById('auditLogStats');
            auditLogStatsDiv.innerHTML = '<p class="text-center text-muted">Đang tải thống kê...</p>';
            try {
                const response = await fetchWithAuth(`${API_BASE_URL}/audit-logs/daily`);
                if (response.ok) {
                    const data = await response.json();
                    renderAuditLogs(data);
                } else {
                    const errorText = await response.text();
                    showMessage(`Không thể tải nhật ký kiểm toán: ${errorText}`, 'danger');
                    auditLogStatsDiv.innerHTML = `<p class="text-center text-danger">Lỗi: ${errorText}</p>`;
                }
            } catch (error) {
                console.error('Lỗi tải nhật ký kiểm toán:', error);
                // showMessage đã được xử lý trong fetchWithAuth nếu lỗi là 401/403
                if (error.message !== 'Unauthorized or Forbidden.') { // Tránh thông báo trùng lặp
                    showMessage('Lỗi kết nối khi tải nhật ký kiểm toán.', 'danger');
                }
                auditLogStatsDiv.innerHTML = `<p class="text-center text-danger">Lỗi kết nối.</p>`;
            }
        }

        function renderAuditLogs(logs) {
            const auditLogStatsDiv = document.getElementById('auditLogStats');
            if (logs.length === 0) {
                auditLogStatsDiv.innerHTML = '<p class="text-center text-muted">Không có dữ liệu nhật ký kiểm toán.</p>';
                return;
            }

            let tableHtml = `
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Ngày</th>
                            <th>Số lượng hoạt động</th>
                        </tr>
                    </thead>
                    <tbody>
            `;
            logs.forEach(log => {
                tableHtml += `
                    <tr>
                        <td>${log[0]}</td>
                        <td>${log[1]}</td>
                    </tr>
                `;
            });
            tableHtml += `
                    </tbody>
                </table>
            `;
            auditLogStatsDiv.innerHTML = tableHtml;
        }

        async function fetchAllProjectsForAdmin() {
            const projectsTableBody = document.getElementById('allProjectsTableBody');
            projectsTableBody.innerHTML = '<tr><td colspan="3" class="text-center text-muted">Đang tải dự án...</td></tr>';
            try {
                const response = await fetchWithAuth(`${API_BASE_URL}/projects`);
                if (response.ok) {
                    const projects = await response.json();
                    renderAllProjectsTable(projects);
                } else {
                    const errorText = await response.text();
                    showMessage(`Không thể tải tất cả dự án: ${errorText}`, 'danger');
                    projectsTableBody.innerHTML = `<tr><td colspan="3" class="text-center text-danger">Lỗi: ${errorText}</td></tr>`;
                }
            } catch (error) {
                console.error('Lỗi tải tất cả dự án:', error);
                if (error.message !== 'Unauthorized or Forbidden.') {
                    showMessage('Lỗi kết nối khi tải tất cả dự án.', 'danger');
                }
                projectsTableBody.innerHTML = `<tr><td colspan="3" class="text-center text-danger">Lỗi kết nối.</td></tr>`;
            }
        }

        function renderAllProjectsTable(projects) {
            const projectsTableBody = document.getElementById('allProjectsTableBody');
            projectsTableBody.innerHTML = '';
            if (projects.length === 0) {
                projectsTableBody.innerHTML = '<tr><td colspan="3" class="text-center text-muted">Không có dự án nào.</td></tr>';
                return;
            }
            projects.forEach(project => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${project.id}</td>
                    <td>${project.name}</td>
                    <td>${project.description || 'N/A'}</td>
                `;
                projectsTableBody.appendChild(row);
            });
        }

        async function fetchAllTasksForAdmin() {
            const tasksTableBody = document.getElementById('allTasksTableBody');
            tasksTableBody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">Đang tải công việc...</td></tr>';
            try {
                const response = await fetchWithAuth(`${API_BASE_URL}/tasks/all`); // Assuming you have a /tasks/all endpoint for admin
                if (response.ok) {
                    const tasks = await response.json();
                    renderAllTasksTable(tasks);
                } else {
                    const errorText = await response.text();
                    showMessage(`Không thể tải tất cả công việc: ${errorText}`, 'danger');
                    tasksTableBody.innerHTML = `<tr><td colspan="4" class="text-center text-danger">Lỗi: ${errorText}</td></tr>`;
                }
            } catch (error) {
                console.error('Lỗi tải tất cả công việc:', error);
                if (error.message !== 'Unauthorized or Forbidden.') {
                    showMessage('Lỗi kết nối khi tải tất cả công việc.', 'danger');
                }
                tasksTableBody.innerHTML = `<tr><td colspan="4" class="text-center text-danger">Lỗi kết nối.</td></tr>`;
            }
        }

        function renderAllTasksTable(tasks) {
            const tasksTableBody = document.getElementById('allTasksTableBody');
            tasksTableBody.innerHTML = '';
            if (tasks.length === 0) {
                tasksTableBody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">Không có công việc nào.</td></tr>';
                return;
            }
            tasks.forEach(task => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${task.id}</td>
                    <td>${task.name}</td>
                    <td>${task.status}</td>
                    <td>${task.project ? task.project.name : 'N/A'}</td>
                `;
                tasksTableBody.appendChild(row);
            });
        }

        async function fetchAllUsersForAdmin() {
            const usersTableBody = document.getElementById('allUsersTableBody');
            usersTableBody.innerHTML = '<tr><td colspan="6" class="text-center text-muted">Đang tải nhân viên...</td></tr>';
            try {
                const response = await fetchWithAuth(`${API_BASE_URL}/users`); // Re-using /users endpoint, assuming it returns all for admin
                if (response.ok) {
                    const users = await response.json();
                    renderAllUsersTable(users);
                } else {
                    const errorText = await response.text();
                    showMessage(`Không thể tải tất cả nhân viên: ${errorText}`, 'danger');
                    usersTableBody.innerHTML = `<tr><td colspan="6" class="text-center text-danger">Lỗi: ${errorText}</td></tr>`;
                }
            } catch (error) {
                console.error('Lỗi tải tất cả nhân viên:', error);
                if (error.message !== 'Unauthorized or Forbidden.') {
                    showMessage('Lỗi kết nối khi tải tất cả nhân viên.', 'danger');
                }
                usersTableBody.innerHTML = `<tr><td colspan="6" class="text-center text-danger">Lỗi kết nối.</td></tr>`;
            }
        }

        function renderAllUsersTable(users) {
            const usersTableBody = document.getElementById('allUsersTableBody');
            usersTableBody.innerHTML = '';
            if (users.length === 0) {
                usersTableBody.innerHTML = '<tr><td colspan="6" class="text-center text-muted">Không có nhân viên nào.</td></tr>';
                return;
            }
            users.forEach(user => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${user.id}</td>
                    <td>${user.username}</td>
                    <td>${user.fullName}</td>
                    <td>${user.employeeId || 'N/A'}</td>
                    <td>${user.role}</td>
                    <td>
                        <button class="btn btn-sm btn-warning edit-user-btn me-2" data-bs-toggle="modal" data-bs-target="#editUserModal" data-user-id="${user.id}">Sửa</button>
                        <button class="btn btn-sm btn-danger delete-user-btn" data-user-id="${user.id}">Xóa</button>
                    </td>
                `;
                usersTableBody.appendChild(row);
            });

            document.querySelectorAll('.edit-user-btn').forEach(button => {
                button.addEventListener('click', (event) => {
                    const userId = event.target.dataset.userId;
                    const userToEdit = users.find(u => u.id == userId);
                    if (userToEdit) {
                        document.getElementById('editUserId').value = userToEdit.id;
                        document.getElementById('editUsername').value = userToEdit.username;
                        document.getElementById('editFullName').value = userToEdit.fullName;
                        document.getElementById('editEmployeeId').value = userToEdit.employeeId;
                        document.getElementById('editRole').value = userToEdit.role;
                    }
                });
            });

            document.querySelectorAll('.delete-user-btn').forEach(button => {
                button.addEventListener('click', (event) => {
                    const userId = event.target.dataset.userId;
                    if (confirm(`Bạn có chắc chắn muốn xóa người dùng ID: ${userId} này không?`)) {
                        deleteUser(userId);
                    }
                });
            });
        }

        // --- User Management Functions (Admin Only) ---
        document.getElementById('editUserForm').addEventListener('submit', async function(event) {
            event.preventDefault();
            const userId = document.getElementById('editUserId').value;
            const fullName = document.getElementById('editFullName').value;
            const employeeId = document.getElementById('editEmployeeId').value;
            const role = document.getElementById('editRole').value;

            try {
                const response = await fetchWithAuth(`${API_BASE_URL}/users/${userId}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ fullName, employeeId, role })
                });

                if (response.ok) {
                    showMessage('Cập nhật thông tin nhân viên thành công!', 'success');
                    const modal = bootstrap.Modal.getInstance(document.getElementById('editUserModal'));
                    if (modal) modal.hide();
                    fetchAllUsersForAdmin(); // Refresh user list
                } else {
                    const errorText = await response.text();
                    showMessage(`Cập nhật thông tin nhân viên thất bại: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi cập nhật nhân viên:', error);
                if (error.message !== 'Unauthorized or Forbidden.') {
                    showMessage('Lỗi kết nối khi cập nhật nhân viên.', 'danger');
                }
            }
        });

        async function deleteUser(userId) {
            try {
                const response = await fetchWithAuth(`${API_BASE_URL}/users/${userId}`, {
                    method: 'DELETE'
                });

                if (response.ok) {
                    showMessage('Xóa nhân viên thành công!', 'success');
                    fetchAllUsersForAdmin(); // Refresh user list
                } else {
                    const errorText = await response.text();
                    showMessage(`Xóa nhân viên thất bại: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi xóa nhân viên:', error);
                if (error.message !== 'Unauthorized or Forbidden.') {
                    showMessage('Lỗi kết nối khi xóa nhân viên.', 'danger');
                }
            }
        }
    </script>
</body>
</html>