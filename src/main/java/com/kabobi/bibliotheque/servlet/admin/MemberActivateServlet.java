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

@WebServlet("/admin/members/*/activate")
public class MemberActivateServlet extends HttpServlet {

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
        if (pathInfo == null || !pathInfo.endsWith("/activate")) {
            response.sendRedirect(request.getContextPath() + "/admin/members");
            return;
        }

        String idStr = pathInfo.substring(1, pathInfo.length() - 9);

        try {
            Long userId = Long.parseLong(idStr);
            Optional<User> userOpt = userService.getUserById(userId);

            if (userOpt.isEmpty()) {
                session.setAttribute("error", "Utilisateur non trouvé");
                response.sendRedirect(request.getContextPath() + "/admin/members");
                return;
            }

            boolean success = userService.activateUser(userId);

            if (success) {
                session.setAttribute("success", "Compte réactivé avec succès");
            } else {
                session.setAttribute("error", "Erreur lors de la réactivation du compte");
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