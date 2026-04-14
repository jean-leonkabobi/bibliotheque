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
import java.util.List;

@WebServlet("/admin/loans")
public class LoanListServlet extends HttpServlet {

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

        String filter = request.getParameter("filter");
        List<Loan> loans;
        String filterTitle = "Tous les emprunts";

        if ("active".equals(filter)) {
            loans = loanService.getActiveLoans();
            filterTitle = "Emprunts en cours";
        } else if ("overdue".equals(filter)) {
            loans = loanService.getOverdueLoans();
            filterTitle = "Emprunts en retard";
        } else {
            loans = loanService.getAllLoans();
        }

        request.setAttribute("loans", loans);
        request.setAttribute("filterTitle", filterTitle);
        request.setAttribute("activeCount", loanService.countActiveLoans());
        request.setAttribute("overdueCount", loanService.countOverdueLoans());
        request.setAttribute("currentFilter", filter);

        request.getRequestDispatcher("/WEB-INF/views/admin/loans/list.jsp")
                .forward(request, response);
    }

    @Override
    public void destroy() {
        if (loanService != null) {
            loanService.close();
        }
    }
}