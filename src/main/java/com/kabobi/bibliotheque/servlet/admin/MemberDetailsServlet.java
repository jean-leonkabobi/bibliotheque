package com.kabobi.bibliotheque.servlet.admin;

import com.kabobi.bibliotheque.entity.Loan;
import com.kabobi.bibliotheque.entity.Penalty;
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
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/members/*")
public class MemberDetailsServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        System.out.println("=== MemberDetailsServlet INITIALISEE ===");
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
        System.out.println("=== doGet pathInfo: " + pathInfo + " ===");

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/members");
            return;
        }

        // Vérifier si c'est une requête de suspension
        if (pathInfo.endsWith("/suspend")) {
            System.out.println("=== Mode SUSPENSION ===");
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];
            System.out.println("ID pour suspension: " + idStr);

            try {
                Long userId = Long.parseLong(idStr);

                // Ne pas suspendre un autre admin
                Optional<User> userOpt = userService.getUserById(userId);
                if (userOpt.isPresent() && userOpt.get().isAdmin() && !userId.equals(currentUser.getId())) {
                    session.setAttribute("error", "Vous ne pouvez pas suspendre un autre administrateur");
                    response.sendRedirect(request.getContextPath() + "/admin/members");
                    return;
                }

                boolean success = userService.suspendUser(userId);

                if (success) {
                    session.setAttribute("success", "Compte suspendu avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la suspension");
                }

            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID utilisateur invalide");
            }

            response.sendRedirect(request.getContextPath() + "/admin/members");
            return;
        }

        // Vérifier si c'est une requête de réactivation
        if (pathInfo.endsWith("/activate")) {
            System.out.println("=== Mode REACTIVATION ===");
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];
            System.out.println("ID pour réactivation: " + idStr);

            try {
                Long userId = Long.parseLong(idStr);
                boolean success = userService.activateUser(userId);

                if (success) {
                    session.setAttribute("success", "Compte réactivé avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la réactivation");
                }

            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID utilisateur invalide");
            }

            response.sendRedirect(request.getContextPath() + "/admin/members");
            return;
        }

        // Vérifier si c'est une requête de validation
        if (pathInfo.endsWith("/validate")) {
            System.out.println("=== Mode VALIDATION ===");
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];
            System.out.println("ID pour validation: " + idStr);

            try {
                Long userId = Long.parseLong(idStr);
                boolean success = userService.validateUser(userId);

                if (success) {
                    session.setAttribute("success", "Compte validé avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la validation");
                }

            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID utilisateur invalide");
            }

            response.sendRedirect(request.getContextPath() + "/admin/members");
            return;
        }

        // Vérifier si c'est une requête de suppression
        if (pathInfo.endsWith("/delete")) {
            System.out.println("=== Mode SUPPRESSION ===");
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];
            System.out.println("ID pour suppression: " + idStr);

            try {
                Long userId = Long.parseLong(idStr);

                // Ne pas supprimer son propre compte
                if (userId.equals(currentUser.getId())) {
                    session.setAttribute("error", "Vous ne pouvez pas supprimer votre propre compte");
                    response.sendRedirect(request.getContextPath() + "/admin/members");
                    return;
                }

                boolean success = userService.deleteUser(userId);

                if (success) {
                    session.setAttribute("success", "Compte supprimé définitivement");
                } else {
                    session.setAttribute("error", "Erreur lors de la suppression");
                }

            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID utilisateur invalide");
            }

            response.sendRedirect(request.getContextPath() + "/admin/members");
            return;
        }

        // Vérifier si c'est une requête de changement de rôle
        if (pathInfo.endsWith("/role")) {
            System.out.println("=== Mode CHANGEMENT DE ROLE ===");
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];
            System.out.println("ID pour changement de rôle: " + idStr);

            try {
                Long userId = Long.parseLong(idStr);
                Optional<User> userOpt = userService.getUserById(userId);

                if (userOpt.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Utilisateur non trouvé");
                    return;
                }

                request.setAttribute("targetUser", userOpt.get());
                request.getRequestDispatcher("/WEB-INF/views/admin/members/role.jsp")
                        .forward(request, response);
                return;

            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID invalide");
                return;
            }
        }

        // Vérifier si c'est une requête d'édition
        if (pathInfo.endsWith("/edit")) {
            System.out.println("=== Mode EDITION ===");
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];
            System.out.println("ID pour édition: " + idStr);

            try {
                Long userId = Long.parseLong(idStr);
                Optional<User> userOpt = userService.getUserById(userId);

                if (userOpt.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Utilisateur non trouvé");
                    return;
                }

                request.setAttribute("member", userOpt.get());
                request.getRequestDispatcher("/WEB-INF/views/admin/members/edit.jsp")
                        .forward(request, response);
                return;

            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID invalide");
                return;
            }
        }

        // Sinon, c'est une requête de détails
        System.out.println("=== Mode DETAILS ===");
        String idStr = pathInfo.substring(1);
        System.out.println("ID pour détails: " + idStr);

        try {
            Long userId = Long.parseLong(idStr);
            Optional<User> userOpt = userService.getUserById(userId);

            if (userOpt.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Utilisateur non trouvé");
                return;
            }

            User member = userOpt.get();

            List<Loan> loanHistory = userService.getUserLoanHistory(userId);
            List<Loan> activeLoans = userService.getUserActiveLoans(userId);
            List<Penalty> penalties = userService.getUserPenalties(userId);
            double totalPenalties = userService.getUserTotalPenalties(userId);
            boolean canBorrow = userService.canBorrow(userId);

            request.setAttribute("member", member);
            request.setAttribute("loanHistory", loanHistory);
            request.setAttribute("activeLoans", activeLoans);
            request.setAttribute("penalties", penalties);
            request.setAttribute("totalPenalties", totalPenalties);
            request.setAttribute("canBorrow", canBorrow);
            request.setAttribute("activeLoansCount", activeLoans.size());
            request.setAttribute("totalLoansCount", loanHistory.size());

            request.getRequestDispatcher("/WEB-INF/views/admin/members/details.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID invalide");
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

        String pathInfo = request.getPathInfo();
        System.out.println("=== doPost pathInfo: " + pathInfo + " ===");

        // Vérifier si c'est une requête de changement de rôle
        if (pathInfo != null && pathInfo.endsWith("/role")) {
            System.out.println("=== Traitement POST pour changement de rôle ===");

            String userIdStr = request.getParameter("userId");
            String roleStr = request.getParameter("role");

            System.out.println("userId: " + userIdStr);
            System.out.println("role: " + roleStr);

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

            response.sendRedirect(request.getContextPath() + "/admin/members/" + userIdStr);
            return;
        }

        // Vérifier si c'est une requête d'édition
        if (pathInfo != null && pathInfo.endsWith("/edit")) {
            System.out.println("=== Traitement POST pour édition ===");

            String userIdStr = request.getParameter("userId");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            System.out.println("userId: " + userIdStr);
            System.out.println("firstName: " + firstName);
            System.out.println("lastName: " + lastName);
            System.out.println("email: " + email);

            if (userIdStr == null || firstName == null || lastName == null || email == null) {
                session.setAttribute("error", "Tous les champs sont requis");
                response.sendRedirect(request.getContextPath() + "/admin/members");
                return;
            }

            try {
                Long userId = Long.parseLong(userIdStr);
                Optional<User> userOpt = userService.getUserById(userId);

                if (userOpt.isEmpty()) {
                    session.setAttribute("error", "Utilisateur non trouvé");
                    response.sendRedirect(request.getContextPath() + "/admin/members");
                    return;
                }

                Optional<User> existingUser = userService.getUserByEmail(email);
                if (existingUser.isPresent() && !existingUser.get().getId().equals(userId)) {
                    session.setAttribute("error", "Cet email est déjà utilisé par un autre compte");
                    response.sendRedirect(request.getContextPath() + "/admin/members/" + userId);
                    return;
                }

                boolean updated = userService.updateUserInfo(userId, firstName, lastName, email);

                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    if (newPassword.length() < 6) {
                        session.setAttribute("error", "Le mot de passe doit contenir au moins 6 caractères");
                        response.sendRedirect(request.getContextPath() + "/admin/members/" + userId);
                        return;
                    }

                    if (!newPassword.equals(confirmPassword)) {
                        session.setAttribute("error", "Les mots de passe ne correspondent pas");
                        response.sendRedirect(request.getContextPath() + "/admin/members/" + userId);
                        return;
                    }

                    userService.changePassword(userId, newPassword);
                }

                if (updated) {
                    session.setAttribute("success", "Informations mises à jour avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la mise à jour");
                }

            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID utilisateur invalide");
            }

            response.sendRedirect(request.getContextPath() + "/admin/members/" + userIdStr);
            return;
        }

        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}