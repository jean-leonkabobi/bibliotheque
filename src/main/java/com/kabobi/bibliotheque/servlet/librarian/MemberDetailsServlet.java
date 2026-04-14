package com.kabobi.bibliotheque.servlet.librarian;

import com.kabobi.bibliotheque.entity.Loan;
import com.kabobi.bibliotheque.entity.Penalty;
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

@WebServlet("/librarian/members/*")
public class MemberDetailsServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        System.out.println("=== Librarian MemberDetailsServlet INITIALISEE ===");
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
        System.out.println("=== Librarian doGet pathInfo: " + pathInfo + " ===");

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/librarian/members");
            return;
        }

        // Vérifier si c'est une requête de suspension
        if (pathInfo.endsWith("/suspend")) {
            System.out.println("=== Mode SUSPENSION ===");
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];

            try {
                Long userId = Long.parseLong(idStr);
                Optional<User> userOpt = userService.getUserById(userId);

                if (userOpt.isEmpty()) {
                    session.setAttribute("error", "Membre non trouvé");
                    response.sendRedirect(request.getContextPath() + "/librarian/members");
                    return;
                }

                if (!userOpt.get().isMember()) {
                    session.setAttribute("error", "Action non autorisée sur ce type de compte");
                    response.sendRedirect(request.getContextPath() + "/librarian/members");
                    return;
                }

                boolean success = userService.suspendUser(userId);

                if (success) {
                    session.setAttribute("success", "Membre suspendu avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la suspension");
                }

            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID invalide");
            }

            response.sendRedirect(request.getContextPath() + "/librarian/members");
            return;
        }

        // Vérifier si c'est une requête de réactivation
        if (pathInfo.endsWith("/activate")) {
            System.out.println("=== Mode REACTIVATION ===");
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];

            try {
                Long userId = Long.parseLong(idStr);
                Optional<User> userOpt = userService.getUserById(userId);

                if (userOpt.isEmpty()) {
                    session.setAttribute("error", "Membre non trouvé");
                    response.sendRedirect(request.getContextPath() + "/librarian/members");
                    return;
                }

                if (!userOpt.get().isMember()) {
                    session.setAttribute("error", "Action non autorisée sur ce type de compte");
                    response.sendRedirect(request.getContextPath() + "/librarian/members");
                    return;
                }

                boolean success = userService.activateUser(userId);

                if (success) {
                    session.setAttribute("success", "Membre réactivé avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la réactivation");
                }

            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID invalide");
            }

            response.sendRedirect(request.getContextPath() + "/librarian/members");
            return;
        }

        // Vérifier si c'est une requête de validation
        if (pathInfo.endsWith("/validate")) {
            System.out.println("=== Mode VALIDATION ===");
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];

            try {
                Long userId = Long.parseLong(idStr);
                Optional<User> userOpt = userService.getUserById(userId);

                if (userOpt.isEmpty()) {
                    session.setAttribute("error", "Membre non trouvé");
                    response.sendRedirect(request.getContextPath() + "/librarian/members");
                    return;
                }

                if (!userOpt.get().isMember()) {
                    session.setAttribute("error", "Action non autorisée sur ce type de compte");
                    response.sendRedirect(request.getContextPath() + "/librarian/members");
                    return;
                }

                boolean success = userService.validateUser(userId);

                if (success) {
                    session.setAttribute("success", "Membre validé avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la validation");
                }

            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID invalide");
            }

            response.sendRedirect(request.getContextPath() + "/librarian/members");
            return;
        }

        // Sinon, c'est une requête de détails
        System.out.println("=== Mode DETAILS ===");
        String idStr = pathInfo.substring(1);
        System.out.println("ID pour détails: " + idStr);

        try {
            Long userId = Long.parseLong(idStr);
            Optional<User> userOpt = userService.getUserById(userId);

            if (userOpt.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Membre non trouvé");
                return;
            }

            User member = userOpt.get();

            if (!member.isMember() && !currentUser.isAdmin()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès non autorisé");
                return;
            }

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

            request.getRequestDispatcher("/WEB-INF/views/librarian/members/details.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID invalide");
        }
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}