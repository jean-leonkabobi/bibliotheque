package com.kabobi.bibliotheque.servlet.member;

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

@WebServlet("/member/penalties")
public class PenaltiesServlet extends HttpServlet {

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

        // Récupérer toutes les pénalités
        List<Penalty> penalties = userService.getUserPenalties(currentUser.getId());
        double totalUnpaid = userService.getUserTotalPenalties(currentUser.getId());

        request.setAttribute("penalties", penalties);
        request.setAttribute("totalUnpaid", totalUnpaid);

        request.getRequestDispatcher("/WEB-INF/views/member/penalties.jsp")
                .forward(request, response);
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

        String penaltyIdStr = request.getParameter("penaltyId");

        if (penaltyIdStr != null) {
            try {
                Long penaltyId = Long.parseLong(penaltyIdStr);
                boolean paid = userService.payPenalty(penaltyId);

                if (paid) {
                    session.setAttribute("success", "Pénalité payée avec succès !");
                } else {
                    session.setAttribute("error", "Erreur lors du paiement");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID invalide");
            }
        }

        response.sendRedirect(request.getContextPath() + "/member/penalties");
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}