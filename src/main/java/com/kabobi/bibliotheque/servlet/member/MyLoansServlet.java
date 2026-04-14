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

@WebServlet("/member/loans")
public class MyLoansServlet extends HttpServlet {

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

        // Récupérer les emprunts en cours
        List<Loan> activeLoans = userService.getUserActiveLoans(currentUser.getId());

        request.setAttribute("activeLoans", activeLoans);
        request.setAttribute("activeLoansCount", activeLoans.size());
        request.setAttribute("maxLoans", 3);

        request.getRequestDispatcher("/WEB-INF/views/member/loans.jsp")
                .forward(request, response);
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}