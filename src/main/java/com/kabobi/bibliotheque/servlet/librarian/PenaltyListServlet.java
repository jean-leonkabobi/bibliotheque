package com.kabobi.bibliotheque.servlet.librarian;

import com.kabobi.bibliotheque.dao.PenaltyDAO;
import com.kabobi.bibliotheque.entity.Penalty;
import com.kabobi.bibliotheque.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/librarian/penalties")
public class PenaltyListServlet extends HttpServlet {

    private PenaltyDAO penaltyDAO;

    @Override
    public void init() throws ServletException {
        penaltyDAO = new PenaltyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Vérifier que l'utilisateur est bibliothécaire ou admin
        if (currentUser == null || (!currentUser.isLibrarian() && !currentUser.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String filter = request.getParameter("filter");
        List<Penalty> penalties;

        if ("unpaid".equals(filter)) {
            penalties = penaltyDAO.findAllUnpaid();
            request.setAttribute("filterTitle", "Pénalités impayées");
        } else {
            penalties = penaltyDAO.findAll();
            request.setAttribute("filterTitle", "Toutes les pénalités");
        }

        // Calculer le total des impayés
        double totalUnpaid = penaltyDAO.findAllUnpaid().stream()
                .mapToDouble(Penalty::getAmount)
                .sum();

        request.setAttribute("penalties", penalties);
        request.setAttribute("totalUnpaid", totalUnpaid);
        request.setAttribute("currentFilter", filter);

        request.getRequestDispatcher("/WEB-INF/views/librarian/penalties/list.jsp")
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

        String penaltyIdStr = request.getParameter("penaltyId");
        String action = request.getParameter("action");

        if (penaltyIdStr != null) {
            try {
                Long penaltyId = Long.parseLong(penaltyIdStr);

                if ("pay".equals(action)) {
                    penaltyDAO.payPenalty(penaltyId);
                    session.setAttribute("success", "Pénalité payée avec succès");
                } else if ("cancel".equals(action)) {
                    penaltyDAO.cancelPenalty(penaltyId);
                    session.setAttribute("success", "Pénalité annulée");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID invalide");
            }
        }

        response.sendRedirect(request.getContextPath() + "/librarian/penalties");
    }

    @Override
    public void destroy() {
        if (penaltyDAO != null) {
            penaltyDAO.close();
        }
    }
}