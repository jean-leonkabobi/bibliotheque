package com.kabobi.bibliotheque.servlet.member;

import com.kabobi.bibliotheque.entity.Loan;
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

@WebServlet("/member/history")
public class HistoryServlet extends HttpServlet {

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

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Récupérer tout l'historique des emprunts
        List<Loan> loanHistory = userService.getUserLoanHistory(currentUser.getId());

        request.setAttribute("loanHistory", loanHistory);
        request.setAttribute("totalLoans", loanHistory.size());

        request.getRequestDispatcher("/WEB-INF/views/member/history.jsp")
                .forward(request, response);
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}