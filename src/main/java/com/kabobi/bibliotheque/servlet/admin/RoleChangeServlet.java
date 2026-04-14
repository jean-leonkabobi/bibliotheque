package com.kabobi.bibliotheque.servlet.admin;

import com.kabobi.bibliotheque.entity.Role;
import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/admin/members/*/role")
public class RoleChangeServlet extends HttpServlet {

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

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || !pathInfo.endsWith("/role")) {
            response.sendRedirect(request.getContextPath() + "/admin/members");
            return;
        }

        String idStr = pathInfo.substring(1, pathInfo.length() - 5);

        try {
            Long userId = Long.parseLong(idStr);
            Optional<User> userOpt = userService.getUserById(userId);

            if (userOpt.isEmpty()) {
                session.setAttribute("error", "Utilisateur non trouvé");
                response.sendRedirect(request.getContextPath() + "/admin/members");
                return;
            }

            request.setAttribute("targetUser", userOpt.get());
            request.getRequestDispatcher("/WEB-INF/views/admin/members/role.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID utilisateur invalide");
            response.sendRedirect(request.getContextPath() + "/admin/members");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userIdStr = request.getParameter("userId");
        String roleStr = request.getParameter("role");

        if (userIdStr == null || roleStr == null) {
            session.setAttribute("error", "Paramètres invalides");
            response.sendRedirect(request.getContextPath() + "/admin/members");
            return;
        }

        try {
            Long userId = Long.parseLong(userIdStr);
            Role newRole = Role.valueOf(roleStr);

            Optional<User> userOpt = userService.getUserById(userId);

            if (userOpt.isEmpty()) {
                session.setAttribute("error", "Utilisateur non trouvé");
                response.sendRedirect(request.getContextPath() + "/admin/members");
                return;
            }

            // Ne pas changer le rôle de son propre compte
            if (userId.equals(currentUser.getId())) {
                session.setAttribute("error", "Vous ne pouvez pas modifier votre propre rôle");
                response.sendRedirect(request.getContextPath() + "/admin/members");
                return;
            }

            boolean success = userService.changeRole(userId, newRole);

            if (success) {
                session.setAttribute("success", "Rôle modifié avec succès");
            } else {
                session.setAttribute("error", "Erreur lors de la modification du rôle");
            }

        } catch (Exception e) {
            session.setAttribute("error", "Erreur: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/members");
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}