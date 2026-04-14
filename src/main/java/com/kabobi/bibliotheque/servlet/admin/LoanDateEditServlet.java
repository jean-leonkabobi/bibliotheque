package com.kabobi.bibliotheque.servlet.admin;

import com.kabobi.bibliotheque.entity.Loan;
import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.LoanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@WebServlet("/admin/loans/edit-date")
public class LoanDateEditServlet extends HttpServlet {

    private LoanService loanService;

    @Override
    public void init() throws ServletException {
        loanService = new LoanService();
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

        String loanIdStr = request.getParameter("id");
        if (loanIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/loans");
            return;
        }

        try {
            Long loanId = Long.parseLong(loanIdStr);
            Optional<Loan> loanOpt = loanService.getLoanById(loanId);

            if (loanOpt.isEmpty()) {
                session.setAttribute("error", "Emprunt non trouvé");
                response.sendRedirect(request.getContextPath() + "/admin/loans");
                return;
            }

            request.setAttribute("loan", loanOpt.get());
            request.getRequestDispatcher("/WEB-INF/views/admin/loans/edit-date.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID invalide");
            response.sendRedirect(request.getContextPath() + "/admin/loans");
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

        try {
            Long loanId = Long.parseLong(request.getParameter("loanId"));
            String newDueDateStr = request.getParameter("dueDate");

            Optional<Loan> loanOpt = loanService.getLoanById(loanId);

            if (loanOpt.isPresent()) {
                Loan loan = loanOpt.get();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                LocalDateTime newDueDate = LocalDateTime.parse(newDueDateStr, formatter);
                loan.setDueDate(newDueDate);
                loanService.updateLoan(loan);
                session.setAttribute("success", "Date de retour modifiée avec succès");
            } else {
                session.setAttribute("error", "Emprunt non trouvé");
            }

        } catch (Exception e) {
            session.setAttribute("error", "Erreur : " + e.getMessage());
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