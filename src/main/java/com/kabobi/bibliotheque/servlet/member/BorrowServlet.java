package com.kabobi.bibliotheque.servlet.member;

import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.LoanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/member/borrow")
public class BorrowServlet extends HttpServlet {

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

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Long documentId = Long.parseLong(request.getParameter("documentId"));
            String documentType = request.getParameter("documentType");

            boolean success = loanService.createLoan(currentUser.getId(), documentId, documentType);

            if (success) {
                session.setAttribute("success", "Emprunt enregistré avec succès !");
            } else {
                session.setAttribute("error", "Impossible d'emprunter : vérifiez vos emprunts en cours (max 3) et vos pénalités.");
            }

        } catch (Exception e) {
            session.setAttribute("error", "Erreur : " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/member/catalog");
    }

    @Override
    public void destroy() {
        if (loanService != null) {
            loanService.close();
        }
    }
}