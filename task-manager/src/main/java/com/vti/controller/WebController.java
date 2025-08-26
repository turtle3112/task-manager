package com.vti.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {

    @GetMapping("/login-page")
    public String loginPage() {
        // Tên file JSP: login.jsp -> return "login"
        return "login";
    }

    @GetMapping("/register-page")
    public String registerPage() {
        // Tên file JSP: register.jsp -> return "register"
        return "register";
    }

    @GetMapping("/dashboard-page")
    public String dashboardPage() {
        // Tên file JSP: dashboard_admin.jsp -> return "dashboard_admin"
        return "dashboard_admin";
    }

    @GetMapping("/project-management-page")
    public String projectManagementPage() {
        // Tên file JSP: project_management.jsp -> return "project_management"
        return "project_management";
    }

    @GetMapping("/")
    public String homePage() {
        // Chuyển hướng về trang đăng nhập khi truy cập đường dẫn gốc
        return "redirect:/login-page";
    }
}