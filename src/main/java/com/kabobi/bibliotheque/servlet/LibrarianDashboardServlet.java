package com.kabobi.bibliotheque.servlet;

import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.DashboardService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/librarian/dashboard")
public class LibrarianDashboardServlet extends HttpServlet {

    private DashboardService dashboardService;

    @Override
    public void init() throws ServletException {
        dashboardService = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Vérifier que l'utilisateur est bibliothécaire ou admin
        if (user == null || (!user.isLibrarian() && !user.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Récupérer les statistiques
        Map<String, Object> stats = dashboardService.getLibrarianStats();
        request.setAttribute("stats", stats);

        // Afficher la page
        request.getRequestDispatcher("/WEB-INF/views/dashboard/librarian.jsp")
                .forward(request, response);
    }

    @Override
    public void destroy() {
        if (dashboardService != null) {
            dashboardService.close();
        }
    }
}