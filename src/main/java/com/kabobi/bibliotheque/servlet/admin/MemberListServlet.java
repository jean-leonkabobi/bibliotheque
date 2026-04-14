package com.kabobi.bibliotheque.servlet.admin;

import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/members")
public class MemberListServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("status");
        String search = request.getParameter("search");

        List<User> users = userService.getAllUsers();

        if (roleFilter != null && !roleFilter.isEmpty() && !roleFilter.equals("all")) {
            users = users.stream()
                    .filter(u -> u.getRole().name().equals(roleFilter))
                    .toList();
        }

        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
            users = users.stream()
                    .filter(u -> u.getStatus().name().equals(statusFilter))
                    .toList();
        }

        if (search != null && !search.isEmpty()) {
            String searchLower = search.toLowerCase().trim();
            users = users.stream()
                    .filter(u -> {
                        String fullName = (u.getFirstName() + " " + u.getLastName()).toLowerCase();
                        return fullName.contains(searchLower) ||
                                u.getFirstName().toLowerCase().contains(searchLower) ||
                                u.getLastName().toLowerCase().contains(searchLower) ||
                                u.getEmail().toLowerCase().contains(searchLower);
                    })
                    .toList();
        }

        request.setAttribute("users", users);
        request.setAttribute("totalUsers", users.size());
        request.setAttribute("totalMembers", userService.getTotalMembers());
        request.setAttribute("totalLibrarians", userService.getTotalLibrarians());
        request.setAttribute("totalAdmins", userService.getTotalAdmins());
        request.setAttribute("activeCount", userService.getActiveUsersCount());
        request.setAttribute("pendingCount", userService.getPendingUsersCount());
        request.setAttribute("suspendedCount", userService.getSuspendedUsersCount());
        request.setAttribute("currentRole", roleFilter);
        request.setAttribute("currentStatus", statusFilter);
        request.setAttribute("currentSearch", search);

        request.getRequestDispatcher("/WEB-INF/views/admin/members/list.jsp")
                .forward(request, response);
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}