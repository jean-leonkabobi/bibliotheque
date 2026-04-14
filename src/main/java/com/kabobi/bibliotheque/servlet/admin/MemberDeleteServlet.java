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
import java.util.Optional;

@WebServlet("/admin/members/*/delete")
public class MemberDeleteServlet extends HttpServlet {

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
        if (pathInfo == null || !pathInfo.endsWith("/delete")) {
            response.sendRedirect(request.getContextPath() + "/admin/members");
            return;
        }

        String idStr = pathInfo.substring(1, pathInfo.length() - 7);

        try {
            Long userId = Long.parseLong(idStr);
            Optional<User> userOpt = userService.getUserById(userId);

            if (userOpt.isEmpty()) {
                session.setAttribute("error", "Utilisateur non trouvé");
                response.sendRedirect(request.getContextPath() + "/admin/members");
                return;
            }

            User targetUser = userOpt.get();

            // Ne pas supprimer son propre compte
            if (targetUser.getId().equals(currentUser.getId())) {
                session.setAttribute("error", "Vous ne pouvez pas supprimer votre propre compte");
                response.sendRedirect(request.getContextPath() + "/admin/members");
                return;
            }

            boolean success = userService.deleteUser(userId);

            if (success) {
                session.setAttribute("success", "Compte supprimé définitivement");
            } else {
                session.setAttribute("error", "Erreur lors de la suppression du compte");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID utilisateur invalide");
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