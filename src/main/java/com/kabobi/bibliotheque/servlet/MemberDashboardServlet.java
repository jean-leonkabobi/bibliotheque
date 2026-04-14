package com.kabobi.bibliotheque.servlet;

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

@WebServlet("/member/dashboard")
public class MemberDashboardServlet extends HttpServlet {

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

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Récupérer les emprunts en cours du membre
        List<Loan> activeLoans = loanService.getUserActiveLoans(currentUser.getId());

        // Récupérer l'historique complet des emprunts
        List<Loan> loanHistory = loanService.getUserLoanHistory(currentUser.getId());

        // Calculer les statistiques
        long currentLoans = activeLoans.size();
        long maxLoans = 3;
        long overdueLoans = activeLoans.stream().filter(Loan::isOverdue).count();
        double totalPenalties = loanService.getUserTotalPenalties(currentUser.getId());
        long totalLoansHistory = loanHistory.size();

        request.setAttribute("activeLoans", activeLoans);
        request.setAttribute("loanHistory", loanHistory);
        request.setAttribute("currentLoans", currentLoans);
        request.setAttribute("maxLoans", maxLoans);
        request.setAttribute("overdueLoans", overdueLoans);
        request.setAttribute("totalPenalties", totalPenalties);
        request.setAttribute("totalLoansHistory", totalLoansHistory);

        // Chemin corrigé
        request.getRequestDispatcher("/WEB-INF/views/dashboard/member.jsp")
                .forward(request, response);
    }

    @Override
    public void destroy() {
        if (loanService != null) {
            loanService.close();
        }
    }
}