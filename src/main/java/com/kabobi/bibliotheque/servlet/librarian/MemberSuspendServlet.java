package com.kabobi.bibliotheque.servlet.librarian;

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

@WebServlet("/librarian/members/*/suspend")
public class MemberSuspendServlet extends HttpServlet {

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

        if (currentUser == null || (!currentUser.isLibrarian() && !currentUser.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || !pathInfo.endsWith("/suspend")) {
            response.sendRedirect(request.getContextPath() + "/librarian/members");
            return;
        }

        String idStr = pathInfo.substring(1, pathInfo.length() - 8);

        try {
            Long userId = Long.parseLong(idStr);
            Optional<User> userOpt = userService.getUserById(userId);

            if (userOpt.isEmpty()) {
                session.setAttribute("error", "Membre non trouvé");
                response.sendRedirect(request.getContextPath() + "/librarian/members");
                return;
            }

            User targetUser = userOpt.get();

            // Le bibliothécaire ne peut suspendre que des MEMBERS
            if (!targetUser.isMember()) {
                session.setAttribute("error", "Action non autorisée sur ce type de compte");
                response.sendRedirect(request.getContextPath() + "/librarian/members");
                return;
            }

            boolean success = userService.suspendUser(userId);

            if (success) {
                session.setAttribute("success", "Membre suspendu avec succès");
            } else {
                session.setAttribute("error", "Erreur lors de la suspension du membre");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID membre invalide");
        }

        response.sendRedirect(request.getContextPath() + "/librarian/members");
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}