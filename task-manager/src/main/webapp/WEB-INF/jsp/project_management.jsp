<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Dự án & Công việc</title>
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
        .project-list, .task-column, .task-detail-card {
            background-color: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            box-shadow: inset 0 0 8px rgba(0,0,0,0.05);
            min-height: 200px;
        }
        .project-item, .task-card {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border: 1px solid #e0e0e0;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }
        .project-item:hover, .task-card:hover {
            background-color: #e9ecef;
        }
        .task-column-header {
            color: #ffffff;
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: bold;
            text-align: center;
        }
        .task-card h5 {
            color: #212529;
            font-weight: 600;
            margin-bottom: 5px;
        }
        .task-card p {
            font-size: 0.9rem;
            color: #555;
            margin-bottom: 8px;
        }
        .task-card small {
            color: #777;
            font-size: 0.8rem;
        }
        .btn-status-change {
            font-size: 0.8rem;
            padding: 5px 10px;
            border-radius: 5px;
            margin-right: 5px;
            transition: all 0.2s ease;
        }
        .btn-status-change:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }
        .modal-content {
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }
        .modal-header {
            border-bottom: none;
            padding-bottom: 0;
        }
        .modal-title {
            color: #1976d2;
            font-weight: 700;
        }
        .modal-footer .btn {
            border-radius: 8px;
        }
        .notification-item {
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .notification-item.read {
            background-color: #f0f4f7;
            color: #777;
        }
        .notification-item .badge {
            font-size: 0.75rem;
            padding: 4px 8px;
            border-radius: 5px;
        }
        .notification-item strong {
            color: #333;
        }
        .notification-item small {
            color: #888;
            font-size: 0.8em;
            display: block;
            margin-top: 5px;
        }
        /* Style for active project */
        .project-item.active {
            border-left: 5px solid #1976d2;
            background-color: #e0f2fe; /* Light blue background */
            box-shadow: 0 4px 10px rgba(0, 123, 255, 0.1);
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Quản lý Công việc</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <span class="nav-link">Xin chào, <span id="usernameDisplay"></span> (<span id="roleDisplay"></span>)</span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link d-none" href="/dashboard-page" id="dashboardLink">Dashboard (Admin)</a>
                    </li>
                    <li class="nav-item">
                        <button class="btn btn-light text-dark me-2" id="notificationBtn" data-bs-toggle="modal" data-bs-target="#notificationModal">
                            <i class="fas fa-bell"></i> Thông báo <span class="badge bg-danger rounded-pill d-none" id="notificationBadge"></span>
                        </button>
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

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0 text-primary">Quản lý Dự án & Công việc</h2>
            <div class="d-flex align-items-center">
                <button class="btn btn-success me-2 d-none" id="createProjectBtn" data-bs-toggle="modal" data-bs-target="#createProjectModal">
                    <i class="fas fa-plus me-2"></i>Thêm Dự án
                </button>
                <button class="btn btn-primary d-none" id="createTaskBtn" data-bs-toggle="modal" data-bs-target="#createTaskModal">
                    <i class="fas fa-plus me-2"></i>Tạo công việc mới
                </button>
                <button class="btn btn-info ms-2 d-none" id="registerUserBtn" data-bs-toggle="modal" data-bs-target="#registerUserModal">
                    <i class="fas fa-user-plus me-2"></i>Đăng ký người dùng
                </button>
            </div>
        </div>

        <div class="row">
            <div class="col-md-3 mb-4">
                <div class="project-list">
                    <h4 class="text-primary mb-3">Dự án của bạn</h4>
                    <div id="projectsContainer">
                        <p class="text-center text-muted">Đang tải dự án...</p>
                    </div>
                </div>
            </div>

            <div class="col-md-9 mb-4">
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <div class="task-column">
                            <div class="task-column-header bg-danger">Chưa làm (TODO)</div>
                            <div id="todoTasks">
                                <p class="text-center text-muted">Vui lòng chọn một dự án.</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4 mb-4">
                        <div class="task-column">
                            <div class="task-column-header bg-warning">Đang làm (IN_PROGRESS)</div>
                            <div id="inProgressTasks">
                                <p class="text-center text-muted">Vui lòng chọn một dự án.</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4 mb-4">
                        <div class="task-column">
                            <div class="task-column-header bg-success">Hoàn thành (DONE)</div>
                            <div id="doneTasks">
                                <p class="text-center text-muted">Vui lòng chọn một dự án.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="createProjectModal" tabindex="-1" aria-labelledby="createProjectModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createProjectModalLabel">Tạo dự án mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="createProjectForm">
                        <div class="mb-3">
                            <label for="projectName" class="form-label">Tên dự án</label>
                            <input type="text" class="form-control" id="projectName" required>
                        </div>
                        <div class="mb-3">
                            <label for="projectDescription" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="projectDescription" rows="3"></textarea>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Tạo</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="createTaskModal" tabindex="-1" aria-labelledby="createTaskModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createTaskModalLabel">Tạo công việc mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="createTaskForm">
                        <div class="mb-3">
                            <label for="taskName" class="form-label">Tên công việc</label>
                            <input type="text" class="form-control" id="taskName" required>
                        </div>
                        <div class="mb-3">
                            <label for="taskDescription" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="taskDescription" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="taskDeadline" class="form-label">Deadline</label>
                            <input type="date" class="form-control" id="taskDeadline" required>
                        </div>
                        <div class="mb-3">
                            <label for="taskStatus" class="form-label">Trạng thái</label>
                            <select class="form-select" id="taskStatus">
                                <option value="TODO">Chưa làm</option>
                                <option value="IN_PROGRESS">Đang làm</option>
                                <option value="DONE">Hoàn thành</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="assignedUsers" class="form-label">Người được giao</label>
                            <select class="form-select" id="assignedUsers" multiple size="5">
                                </select>
                            <small class="form-text text-muted">Giữ Ctrl/Cmd để chọn nhiều người.</small>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Tạo</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="taskDetailModal" tabindex="-1" aria-labelledby="taskDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="taskDetailModalLabel">Chi tiết công việc</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="taskDetailContent">
                        </div>
                    <hr>
                    <h5>Thêm bình luận</h5>
                    <form id="addCommentForm" class="mb-3">
                        <textarea class="form-control mb-2" id="newCommentText" rows="2" placeholder="Nhập bình luận của bạn..." required></textarea>
                        <button type="submit" class="btn btn-sm btn-primary">Gửi bình luận</button>
                    </form>

                    <h5>Thêm file đính kèm</h5>
                    <form id="addAttachmentForm" class="mb-3">
                        <input type="file" class="form-control mb-2" id="newAttachmentFile" required>
                        <button type="submit" class="btn btn-sm btn-info">Tải lên file</button>
                    </form>

                    <h5>Thêm tiến độ</h5>
                    <form id="addProgressLogForm" class="mb-3">
                        <input type="number" class="form-control mb-2" id="progressPercentage" placeholder="Tiến độ (%)" min="0" max="100" required>
                        <textarea class="form-control mb-2" id="progressDescription" rows="2" placeholder="Mô tả tiến độ..." required></textarea>
                        <button type="submit" class="btn btn-sm btn-warning">Ghi nhận tiến độ</button>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="registerUserModal" tabindex="-1" aria-labelledby="registerUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="registerUserModalLabel">Đăng ký người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="registerUserForm">
                        <div class="mb-3">
                            <label for="regUsername" class="form-label">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="regUsername" required>
                        </div>
                        <div class="mb-3">
                            <label for="regPassword" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="regPassword" required pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$">
                            <div class="invalid-feedback">Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.</div>
                        </div>
                        <div class="mb-3">
                            <label for="regFullName" class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" id="regFullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="regEmployeeId" class="form-label">Mã nhân viên</label>
                            <input type="text" class="form-control" id="regEmployeeId" required>
                        </div>
                        <div class="mb-4">
                            <label for="regRole" class="form-label">Vai trò</label>
                            <select class="form-select" id="regRole">
                                <option value="EMPLOYEE" selected>EMPLOYEE</option>
                                <option value="ADMIN">ADMIN</option>
                            </select>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Đăng ký</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="notificationModal" tabindex="-1" aria-labelledby="notificationModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="notificationModalLabel">Thông báo của bạn</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="notificationContent">
                    <p class="text-center text-muted">Đang tải thông báo...</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary" id="markAllAsReadBtn">Đánh dấu tất cả đã đọc</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
    /* <![CDATA[ */
        const API_BASE_URL = ''; // Để trống nếu chạy trên cùng domain/port, hoặc chỉ định full URL như 'http://localhost:8080'
        const token = localStorage.getItem('jwtToken');
        const userRole = localStorage.getItem('userRole');
        const currentUsername = localStorage.getItem('username'); // Lấy username của người dùng hiện tại
        let selectedProjectId = null;
        let allProjects = [];
        let allUsers = []; // For assigning tasks
        let currentTaskId = null; // To store the ID of the task currently open in the detail modal

        // --- Helper Functions ---
        function showMessage(msg, type = 'success') {
            const messageDiv = document.getElementById('message');
            messageDiv.classList.remove('d-none', 'alert-success', 'alert-danger', 'alert-warning');
            messageDiv.classList.add(`alert-${type}`);
            messageDiv.textContent = msg;
            setTimeout(() => {
                messageDiv.classList.add('d-none');
            }, 5000);
        }

        function getStatusColorClass(status) {
            switch (status) {
                case 'TODO': return 'bg-danger';
                case 'IN_PROGRESS': return 'bg-warning text-dark';
                case 'DONE': return 'bg-success';
                default: return 'bg-secondary';
            }
        }

        function getProjectNameById(projectId) {
            const project = allProjects.find(p => p.id === projectId);
            return project ? project.name : 'Dự án không xác định';
        }

        function formatDate(dateString) {
            if (!dateString) return 'N/A';
            const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' };
            return new Date(dateString).toLocaleDateString('vi-VN', options);
        }

        // --- Authentication & Initialization ---
        document.addEventListener('DOMContentLoaded', () => {
            if (!token) {
                window.location.href = '/login-page';
                return;
            }
            document.getElementById('usernameDisplay').textContent = currentUsername || 'Người dùng';
            document.getElementById('roleDisplay').textContent = userRole;

            // Show/Hide ADMIN specific buttons
            if (userRole === 'ADMIN') {
                document.getElementById('createProjectBtn').classList.remove('d-none');
                document.getElementById('createTaskBtn').classList.remove('d-none');
                document.getElementById('registerUserBtn').classList.remove('d-none');
                document.getElementById('dashboardLink').classList.remove('d-none'); // Link to ADMIN dashboard
                fetchUsers(); // Fetch users for task assignment dropdown in create task modal
            } else {
                // Hide assigned users select group if not admin when creating task
                // This select is inside createTaskModal, so it's managed by that modal's logic
                // For now, no need to hide it here as createTaskBtn is also hidden.
            }

            fetchProjects();
            fetchNotifications(false); // Fetch notifications on page load
            setInterval(() => fetchNotifications(false), 60000); // Refresh notifications every minute
        });

        document.getElementById('logoutBtn').addEventListener('click', () => {
            localStorage.removeItem('jwtToken');
            localStorage.removeItem('userRole');
            localStorage.removeItem('username');
            window.location.href = '/login-page';
        });

        // --- Fetch Data Functions ---
        async function fetchProjects() {
            try {
                const response = await fetch(`${API_BASE_URL}/projects`, {
                    headers: { 'Authorization': `Bearer ${token}` }
                });
                if (response.ok) {
                    allProjects = await response.json();
                    renderProjects();
                    if (allProjects.length > 0) {
                        // Automatically select the first project if available
                        selectedProjectId = allProjects[0].id;
                        document.querySelector(`.project-item[data-project-id="${selectedProjectId}"]`).classList.add('active');
                        fetchTasks(selectedProjectId);
                    } else {
                        showMessage('Bạn chưa có dự án nào.', 'info');
                        document.getElementById('todoTasks').innerHTML = '<p class="text-center text-muted">Không có dự án nào. Vui lòng tạo dự án mới.</p>';
                        document.getElementById('inProgressTasks').innerHTML = '';
                        document.getElementById('doneTasks').innerHTML = '';
                    }
                } else {
                    const errorText = await response.text();
                    showMessage(`Không thể tải danh sách dự án: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi tải dự án:', error);
                showMessage('Lỗi kết nối khi tải dự án.', 'danger');
            }
        }

        function renderProjects() {
            const projectsContainer = document.getElementById('projectsContainer');
            projectsContainer.innerHTML = '';
            if (allProjects.length === 0) {
                projectsContainer.innerHTML = '<p class="text-center text-muted">Không có dự án nào.</p>';
                return;
            }
            allProjects.forEach(project => {
                const projectItem = document.createElement('div');
                projectItem.className = 'project-item';
                projectItem.dataset.projectId = project.id;
                projectItem.textContent = project.name;
                projectItem.addEventListener('click', () => {
                    // Remove active class from previous
                    document.querySelectorAll('.project-item').forEach(item => item.classList.remove('active'));
                    // Add active class to current
                    projectItem.classList.add('active');
                    selectedProjectId = project.id;
                    fetchTasks(selectedProjectId);
                });
                projectsContainer.appendChild(projectItem);
            });
        }

        async function fetchUsers() {
            try {
                const response = await fetch(`${API_BASE_URL}/users`, {
                    headers: { 'Authorization': `Bearer ${token}` }
                });
                if (response.ok) {
                    allUsers = await response.json();
                    populateAssignedUsersSelect();
                } else {
                    showMessage('Không thể tải danh sách người dùng.', 'danger');
                }
            } catch (error) {
                console.error('Lỗi tải người dùng:', error);
                showMessage('Lỗi kết nối khi tải người dùng.', 'danger');
            }
        }

        function populateAssignedUsersSelect() {
            const selectElement = document.getElementById('assignedUsers');
            selectElement.innerHTML = '';
            allUsers.forEach(user => {
                const option = document.createElement('option');
                option.value = user.id;
                option.textContent = `${user.fullName} (${user.username})`;
                selectElement.appendChild(option);
            });
        }

        async function fetchTasks(projectId) {
            document.getElementById('todoTasks').innerHTML = '<p class="text-center text-muted">Đang tải công việc...</p>';
            document.getElementById('inProgressTasks').innerHTML = '<p class="text-center text-muted">Đang tải công việc...</p>';
            document.getElementById('doneTasks').innerHTML = '<p class="text-center text-muted">Đang tải công việc...</p>';

            try {
                const response = await fetch(`${API_BASE_URL}/tasks/project/${projectId}`, {
                    headers: { 'Authorization': `Bearer ${token}` }
                });
                if (response.ok) {
                    const tasks = await response.json();
                    renderTasks(tasks);
                } else {
                    const errorText = await response.text();
                    showMessage(`Không thể tải công việc: ${errorText}`, 'danger');
                    renderTasks([]); // Clear tasks on error
                }
            } catch (error) {
                console.error('Lỗi tải công việc:', error);
                showMessage('Lỗi kết nối khi tải công việc.', 'danger');
                renderTasks([]); // Clear tasks on connection error
            }
        }

        // --- Render Functions ---
        function renderTasks(tasks) {
            const todoContainer = document.getElementById('todoTasks');
            const inProgressContainer = document.getElementById('inProgressTasks');
            const doneContainer = document.getElementById('doneTasks');

            todoContainer.innerHTML = '';
            inProgressContainer.innerHTML = '';
            doneContainer.innerHTML = '';

            const todoTasks = tasks.filter(task => task.status === 'TODO');
            const inProgressTasks = tasks.filter(task => task.status === 'IN_PROGRESS');
            const doneTasks = tasks.filter(task => task.status === 'DONE');

            if (todoTasks.length === 0) todoContainer.innerHTML = '<p class="text-center text-muted">Không có công việc nào.</p>';
            if (inProgressTasks.length === 0) inProgressContainer.innerHTML = '<p class="text-center text-muted">Không có công việc nào.</p>';
            if (doneTasks.length === 0) doneContainer.innerHTML = '<p class="text-center text-muted">Không có công việc nào.</p>';

            todoTasks.forEach(task => todoContainer.appendChild(createTaskCard(task)));
            inProgressTasks.forEach(task => inProgressContainer.appendChild(createTaskCard(task)));
            doneTasks.forEach(task => doneContainer.appendChild(createTaskCard(task)));
        }

        function createTaskCard(task) {
            const card = document.createElement('div');
            card.className = 'task-card';
            card.dataset.taskId = task.id; // Store task ID for detail modal

            // Generate assigned users string
            const assignedUsersText = task.assignedUsers && task.assignedUsers.length > 0
                ? task.assignedUsers.map(user => user.fullName).join(', ')
                : 'Chưa có';

            // Generate status change buttons dynamically
            let statusButtonsHtml = '';
            if (task.status !== 'TODO') {
                statusButtonsHtml += `<button class="btn btn-sm btn-status-change btn-danger" data-task-id="${task.id}" data-new-status="TODO">Chuyển sang TODO</button>`;
            }
            if (task.status !== 'IN_PROGRESS') {
                statusButtonsHtml += `<button class="btn btn-sm btn-status-change btn-warning text-dark" data-task-id="${task.id}" data-new-status="IN_PROGRESS">Chuyển sang IN_PROGRESS</button>`;
            }
            if (task.status !== 'DONE') {
                statusButtonsHtml += `<button class="btn btn-sm btn-status-change btn-success" data-task-id="${task.id}" data-new-status="DONE">Chuyển sang DONE</button>`;
            }

            card.innerHTML = `
                <h5>${task.name}</h5>
                <p>${task.description || 'Không có mô tả.'}</p>
                <small>Deadline: ${task.deadline}</small><br>
                <small>Người được giao: ${assignedUsersText}</small>
                <div class="mt-3">
                    ${statusButtonsHtml}
                </div>
            `;
            card.querySelectorAll('.btn-status-change').forEach(button => {
                button.addEventListener('click', (event) => {
                    event.stopPropagation(); // Prevent card click from triggering
                    const taskId = event.target.dataset.taskId;
                    const newStatus = event.target.dataset.newStatus;
                    updateTaskStatus(taskId, newStatus);
                });
            });
            // Add event listener for opening task detail modal
            card.addEventListener('click', () => {
                currentTaskId = task.id; // Set current task ID
                fetchTaskDetail(task.id);
                const taskDetailModal = new bootstrap.Modal(document.getElementById('taskDetailModal'));
                taskDetailModal.show();
            });
            return card;
        }

        // --- Project Management Functions ---
        document.getElementById('createProjectForm').addEventListener('submit', async function(event) {
            event.preventDefault();
            const projectName = document.getElementById('projectName').value;
            const projectDescription = document.getElementById('projectDescription').value;

            try {
                const response = await fetch(`${API_BASE_URL}/projects`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify({
                        name: projectName,
                        description: projectDescription
                    })
                });

                if (response.ok) {
                    const newProject = await response.json();
                    showMessage('Dự án đã được tạo thành công!');
                    bootstrap.Modal.getInstance(document.getElementById('createProjectModal')).hide(); // Hide modal
                    fetchProjects(); // Refresh project list
                    document.getElementById('createProjectForm').reset();
                } else {
                    const errorText = await response.text();
                    showMessage(`Tạo dự án thất bại: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi tạo dự án:', error);
                showMessage('Lỗi kết nối khi tạo dự án.', 'danger');
            }
        });

        // --- Task Management Functions ---
        document.getElementById('createTaskForm').addEventListener('submit', async function(event) {
            event.preventDefault();
            if (!selectedProjectId) {
                showMessage('Vui lòng chọn một dự án trước khi tạo công việc.', 'warning');
                return;
            }

            const taskName = document.getElementById('taskName').value;
            const taskDescription = document.getElementById('taskDescription').value;
            const taskDeadline = document.getElementById('taskDeadline').value;
            const taskStatus = document.getElementById('taskStatus').value;
            const assignedUsersSelect = document.getElementById('assignedUsers');
            const assignedUserIds = Array.from(assignedUsersSelect.selectedOptions).map(option => parseInt(option.value));

            try {
                const response = await fetch(`${API_BASE_URL}/tasks`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify({
                        name: taskName,
                        description: taskDescription,
                        deadline: taskDeadline,
                        status: taskStatus,
                        projectId: selectedProjectId,
                        assignedUserIds: assignedUserIds // Send selected user IDs
                    })
                });

                if (response.ok) {
                    showMessage('Công việc đã được tạo thành công!');
                    bootstrap.Modal.getInstance(document.getElementById('createTaskModal')).hide(); // Hide modal
                    fetchTasks(selectedProjectId); // Refresh tasks for current project
                    document.getElementById('createTaskForm').reset();
                } else {
                    const errorText = await response.text();
                    showMessage(`Tạo công việc thất bại: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi tạo công việc:', error);
                showMessage('Lỗi kết nối khi tạo công việc.', 'danger');
            }
        });

        async function updateTaskStatus(taskId, newStatus) {
            try {
                const response = await fetch(`${API_BASE_URL}/tasks/${taskId}/status`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify({ status: newStatus })
                });

                if (response.ok) {
                    showMessage('Trạng thái công việc đã được cập nhật!');
                    fetchTasks(selectedProjectId); // Refresh tasks
                } else {
                    const errorText = await response.text();
                    showMessage(`Cập nhật trạng thái thất bại: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi cập nhật trạng thái:', error);
                showMessage('Lỗi kết nối khi cập nhật trạng thái.', 'danger');
            }
        }

        async function fetchTaskDetail(taskId) {
            try {
                const response = await fetch(`${API_BASE_URL}/tasks/${taskId}`, {
                    headers: { 'Authorization': `Bearer ${token}` }
                });
                if (response.ok) {
                    const task = await response.json();
                    renderTaskDetail(task);
                } else {
                    const errorText = await response.text();
                    showMessage(`Không thể tải chi tiết công việc: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi tải chi tiết công việc:', error);
                showMessage('Lỗi kết nối khi tải chi tiết công việc.', 'danger');
            }
        }

        // --- Render Task Detail (FIXED) ---
        function renderTaskDetail(task) {
            const detailContent = document.getElementById('taskDetailContent');
            const assignedUsersDetailText = task.assignedUsers && task.assignedUsers.length > 0
                ? task.assignedUsers.map(user => user.fullName).join(', ')
                : 'Chưa có';

            // First, render the static part of the task details
            detailContent.innerHTML = `
                <h4>${task.name}</h4>
                <p><strong>Mô tả:</strong> ${task.description || 'Không có mô tả.'}</p>
                <p><strong>Deadline:</strong> ${task.deadline}</p>
                <p><strong>Trạng thái:</strong> <span class="badge ${getStatusColorClass(task.status)}">${task.status}</span></p>
                <p><strong>Dự án:</strong> ${getProjectNameById(task.projectId)}</p>
                <p><strong>Người được giao:</strong> ${assignedUsersDetailText}</p>
                <p><strong>Người tạo:</strong> ${task.creator.fullName || 'N/A'}</p>
                <p><strong>Ngày tạo:</strong> ${formatDate(task.createdAt)}</p>

                <h6 class="mt-4">Bình luận:</h6>
                <div id="commentsContainer" class="mb-3"></div>

                <h6 class="mt-4">File đính kèm:</h6>
                <div id="attachmentsContainer" class="mb-3"></div>

                <h6 class="mt-4">Lịch sử tiến độ:</h6>
                <div id="progressLogsContainer" class="mb-3"></div>
            `;

            // Now, populate the dynamic parts (comments, attachments, progress logs) using pure JavaScript
            // This avoids JSP EL trying to parse JavaScript template literals
            const commentsContainer = document.getElementById('commentsContainer');
            if (task.comments && task.comments.length > 0) {
                commentsContainer.innerHTML = task.comments.map(comment => `
                    <div class="card card-body mb-2">
                        <strong>${comment.user.fullName}:</strong> ${comment.content}
                        <small class="text-muted text-end">${formatDate(comment.createdAt)}</small>
                    </div>
                `).join('');
            } else {
                commentsContainer.innerHTML = '<p class="text-muted">Chưa có bình luận nào.</p>';
            }

            const attachmentsContainer = document.getElementById('attachmentsContainer');
            if (task.attachments && task.attachments.length > 0) {
                attachmentsContainer.innerHTML = task.attachments.map(attachment => `
                    <div class="card card-body mb-2">
                        <a href="${API_BASE_URL}/attachments/download/${attachment.id}" target="_blank">${attachment.fileName}</a>
                        <small class="text-muted text-end">Tải lên bởi: ${attachment.user.fullName} vào ${formatDate(attachment.createdAt)}</small>
                    </div>
                `).join('');
            } else {
                attachmentsContainer.innerHTML = '<p class="text-muted">Chưa có file đính kèm nào.</p>';
            }

            const progressLogsContainer = document.getElementById('progressLogsContainer');
            if (task.progressLogs && task.progressLogs.length > 0) {
                progressLogsContainer.innerHTML = task.progressLogs.map(log => `
                    <div class="card card-body mb-2">
                        <strong>${log.progressPercentage}%</strong> - ${log.description}
                        <small class="text-muted text-end">Cập nhật bởi: ${log.user.fullName} vào ${formatDate(log.createdAt)}</small>
                    </div>
                `).join('');
            } else {
                progressLogsContainer.innerHTML = '<p class="text-muted">Chưa có lịch sử tiến độ nào.</p>';
            }
        }

        // --- Comment, Attachment, Progress Log Functions ---
        document.getElementById('addCommentForm').addEventListener('submit', async function(event) {
            event.preventDefault();
            const commentText = document.getElementById('newCommentText').value;

            try {
                const response = await fetch(`${API_BASE_URL}/comments`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify({
                        content: commentText,
                        taskId: currentTaskId
                    })
                });

                if (response.ok) {
                    showMessage('Bình luận đã được thêm!', 'success');
                    document.getElementById('newCommentText').value = ''; // Clear input
                    fetchTaskDetail(currentTaskId); // Refresh task detail
                } else {
                    const errorText = await response.text();
                    showMessage(`Thêm bình luận thất bại: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi thêm bình luận:', error);
                showMessage('Lỗi kết nối khi thêm bình luận.', 'danger');
            }
        });

        document.getElementById('addAttachmentForm').addEventListener('submit', async function(event) {
            event.preventDefault();
            const fileInput = document.getElementById('newAttachmentFile');
            const file = fileInput.files[0];

            if (!file) {
                showMessage('Vui lòng chọn một file để tải lên.', 'warning');
                return;
            }

            const formData = new FormData();
            formData.append('file', file);
            formData.append('taskId', currentTaskId);

            try {
                const response = await fetch(`${API_BASE_URL}/attachments/upload`, {
                    method: 'POST',
                    headers: {
                        'Authorization': `Bearer ${token}`
                    },
                    body: formData
                });

                if (response.ok) {
                    showMessage('File đính kèm đã được tải lên!', 'success');
                    fileInput.value = ''; // Clear file input
                    fetchTaskDetail(currentTaskId); // Refresh task detail
                } else {
                    const errorText = await response.text();
                    showMessage(`Tải lên file thất bại: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi tải lên file:', error);
                showMessage('Lỗi kết nối khi tải lên file.', 'danger');
            }
        });

        document.getElementById('addProgressLogForm').addEventListener('submit', async function(event) {
            event.preventDefault();
            const progressPercentage = document.getElementById('progressPercentage').value;
            const progressDescription = document.getElementById('progressDescription').value;

            try {
                const response = await fetch(`${API_BASE_URL}/progress-logs`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify({
                        progressPercentage: parseInt(progressPercentage),
                        description: progressDescription,
                        taskId: currentTaskId
                    })
                });

                if (response.ok) {
                    showMessage('Tiến độ đã được ghi nhận!', 'success');
                    document.getElementById('progressPercentage').value = '';
                    document.getElementById('progressDescription').value = '';
                    fetchTaskDetail(currentTaskId); // Refresh task detail
                } else {
                    const errorText = await response.text();
                    showMessage(`Ghi nhận tiến độ thất bại: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi ghi nhận tiến độ:', error);
                showMessage('Lỗi kết nối khi ghi nhận tiến độ.', 'danger');
            }
        });

        // --- User Registration (Admin Only) ---
        document.getElementById('registerUserForm').addEventListener('submit', async function(event) {
            event.preventDefault();
            const regUsername = document.getElementById('regUsername').value;
            const regPassword = document.getElementById('regPassword').value;
            const regFullName = document.getElementById('regFullName').value;
            const regEmployeeId = document.getElementById('regEmployeeId').value;
            const regRole = document.getElementById('regRole').value;

            try {
                const response = await fetch(`${API_BASE_URL}/auth/v2/register`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}` // ADMIN token required
                    },
                    body: JSON.stringify({
                        username: regUsername,
                        password: regPassword,
                        fullName: regFullName,
                        employeeId: regEmployeeId,
                        role: regRole
                    })
                });

                if (response.ok) {
                    showMessage('Người dùng mới đã được đăng ký thành công!', 'success');
                    bootstrap.Modal.getInstance(document.getElementById('registerUserModal')).hide(); // Hide modal
                    document.getElementById('registerUserForm').reset();
                    // Optionally refresh user list for task assignment if needed
                    if (userRole === 'ADMIN') {
                        fetchUsers();
                    }
                } else {
                    const errorText = await response.text();
                    showMessage(`Đăng ký người dùng thất bại: ${errorText}`, 'danger');
                }
            } catch (error) {
                console.error('Lỗi đăng ký người dùng:', error);
                showMessage('Lỗi kết nối khi đăng ký người dùng.', 'danger');
            }
        });

        // --- Notification Functions ---
        async function fetchNotifications(markAsRead = true) {
            try {
                const url = markAsRead ? `${API_BASE_URL}/notifications/mark-all-read` : `${API_BASE_URL}/notifications`;
                const method = markAsRead ? 'PUT' : 'GET';

                const response = await fetch(url, {
                    method: method,
                    headers: { 'Authorization': `Bearer ${token}` }
                });

                if (response.ok) {
                    const notifications = await response.json();
                    renderNotifications(notifications);
                } else {
                    const errorText = await response.text();
                    console.error(`Không thể tải thông báo: ${errorText}`);
                    document.getElementById('notificationContent').innerHTML = '<p class="text-center text-danger">Không thể tải thông báo.</p>';
                }
            } catch (error) {
                console.error('Lỗi kết nối khi tải thông báo:', error);
                document.getElementById('notificationContent').innerHTML = '<p class="text-center text-danger">Lỗi kết nối khi tải thông báo.</p>';
            }
        }

        function renderNotifications(notifications) {
            const notificationContent = document.getElementById('notificationContent');
            notificationContent.innerHTML = '';
            const unreadCount = notifications.filter(n => !n.read).length;

            const notificationBadge = document.getElementById('notificationBadge');
            if (unreadCount > 0) {
                notificationBadge.textContent = unreadCount;
                notificationBadge.classList.remove('d-none');
            } else {
                notificationBadge.classList.add('d-none');
            }

            if (notifications.length === 0) {
                notificationContent.innerHTML = '<p class="text-center text-muted">Không có thông báo nào.</p>';
                return;
            }

            notifications.forEach(notification => {
                const notificationItem = document.createElement('div');
                notificationItem.className = `notification-item ${notification.read ? 'read' : ''}`;
                notificationItem.innerHTML = `
                    <strong>${notification.message}</strong>
                    <span class="badge ${notification.read ? 'bg-secondary' : 'bg-primary'} ms-2">${notification.read ? 'Đã đọc' : 'Mới'}</span>
                    <small>${formatDate(notification.createdAt)}</small>
                `;
                notificationContent.appendChild(notificationItem);
            });
        }

        document.getElementById('markAllAsReadBtn').addEventListener('click', () => {
            fetchNotifications(true); // Mark all as read
        });
    /* ]]> */
    </script>
</body>
</html>