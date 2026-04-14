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
import java.util.List;
import java.util.Optional;

@WebServlet("/librarian/validate")
public class ValidateMemberServlet extends HttpServlet {

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

        // Vérifier que l'utilisateur est bibliothécaire ou admin
        if (currentUser == null || (!currentUser.isLibrarian() && !currentUser.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Récupérer les membres en attente
        List<User> pendingMembers = userService.getPendingUsers()
                .stream()
                .filter(u -> u.isMember()) // Seulement les membres
                .toList();

        request.setAttribute("pendingMembers", pendingMembers);
        request.setAttribute("pendingCount", pendingMembers.size());

        request.getRequestDispatcher("/WEB-INF/views/librarian/members/validate.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || (!currentUser.isLibrarian() && !currentUser.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            Long userId = Long.parseLong(userIdStr);
            Optional<User> userOpt = userService.getUserById(userId);

            if (userOpt.isEmpty()) {
                session.setAttribute("error", "Utilisateur non trouvé");
                response.sendRedirect(request.getContextPath() + "/librarian/validate");
                return;
            }

            User member = userOpt.get();

            if (!member.isMember()) {
                session.setAttribute("error", "Action non autorisée sur ce type de compte");
                response.sendRedirect(request.getContextPath() + "/librarian/validate");
                return;
            }

            boolean success = false;
            String message = "";

            switch (action) {
                case "validate":
                    success = userService.validateUser(userId);
                    message = success ? "Compte validé avec succès" : "Erreur lors de la validation";
                    break;
                case "reject":
                    success = userService.deleteUser(userId);
                    message = success ? "Compte rejeté et supprimé" : "Erreur lors du rejet";
                    break;
                default:
                    session.setAttribute("error", "Action invalide");
                    response.sendRedirect(request.getContextPath() + "/librarian/validate");
                    return;
            }

            if (success) {
                session.setAttribute("success", message);
            } else {
                session.setAttribute("error", message);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID utilisateur invalide");
        }

        response.sendRedirect(request.getContextPath() + "/librarian/validate");
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}