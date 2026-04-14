package com.kabobi.bibliotheque.servlet.librarian;

import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.LoanService;
import com.kabobi.bibliotheque.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/librarian/loans/create")
public class LoanCreateServlet extends HttpServlet {

    private LoanService loanService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        loanService = new LoanService();
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

        // Récupérer les membres actifs
        List<User> members = userService.getActiveUsers().stream()
                .filter(u -> u.isMember())
                .toList();

        request.setAttribute("members", members);
        request.getRequestDispatcher("/WEB-INF/views/librarian/loans/create.jsp")
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

        try {
            Long userId = Long.parseLong(request.getParameter("userId"));
            Long documentId = Long.parseLong(request.getParameter("documentId"));
            String documentType = request.getParameter("documentType");

            boolean success = loanService.createLoan(userId, documentId, documentType);

            if (success) {
                session.setAttribute("success", "Emprunt enregistré avec succès");
            } else {
                session.setAttribute("error", "Erreur : membre non actif, déjà 3 emprunts ou pénalités > 10€");
            }

        } catch (Exception e) {
            session.setAttribute("error", "Erreur : " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/librarian/loans");
    }

    @Override
    public void destroy() {
        if (loanService != null) {
            loanService.close();
        }
        if (userService != null) {
            userService.close();
        }
    }
}