package com.kabobi.bibliotheque.servlet.admin;

import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.LoanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/loans/renew")
public class LoanRenewServlet extends HttpServlet {

    private LoanService loanService;

    @Override
    public void init() throws ServletException {
        loanService = new LoanService();
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

        String loanIdStr = request.getParameter("loanId");

        if (loanIdStr == null) {
            session.setAttribute("error", "ID d'emprunt manquant");
            response.sendRedirect(request.getContextPath() + "/admin/loans");
            return;
        }

        try {
            Long loanId = Long.parseLong(loanIdStr);
            boolean success = loanService.renewLoan(loanId);

            if (success) {
                session.setAttribute("success", "Emprunt prolongé de 7 jours");
            } else {
                session.setAttribute("error", "Prolongation non autorisée (déjà prolongé)");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID invalide");
        }

        response.sendRedirect(request.getContextPath() + "/admin/loans");
    }

    @Override
    public void destroy() {
        if (loanService != null) {
            loanService.close();
        }
    }
}