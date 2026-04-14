package com.kabobi.bibliotheque.servlet.member;

import com.kabobi.bibliotheque.dao.DocumentDAO;
import com.kabobi.bibliotheque.entity.Document;
import com.kabobi.bibliotheque.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/member/search")
public class SearchServlet extends HttpServlet {

    private DocumentDAO documentDAO;

    @Override
    public void init() throws ServletException {
        documentDAO = new DocumentDAO();
        System.out.println("=== SearchServlet initialisé ===");
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

        String query = request.getParameter("q");
        String searchType = request.getParameter("type");
        List<Document> results = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            if ("author".equals(searchType)) {
                // Recherche par auteur - retourne des livres uniquement
                List<com.kabobi.bibliotheque.entity.Book> books = documentDAO.searchBooksByAuthor(query);
                results.addAll(books);
                System.out.println("Recherche par auteur: " + query + " -> " + results.size() + " résultats");
            } else {
                // Recherche par titre
                results = documentDAO.searchByTitle(query);
                System.out.println("Recherche par titre: " + query + " -> " + results.size() + " résultats");
            }
        }

        request.setAttribute("searchQuery", query);
        request.setAttribute("searchType", searchType);
        request.setAttribute("results", results);
        request.setAttribute("resultCount", results.size());

        request.getRequestDispatcher("/WEB-INF/views/member/search.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("search");
        String searchType = request.getParameter("searchType");

        if (searchType != null && !searchType.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/member/search?q=" + query + "&type=" + searchType);
        } else {
            response.sendRedirect(request.getContextPath() + "/member/search?q=" + query);
        }
    }

    @Override
    public void destroy() {
        if (documentDAO != null) {
            documentDAO.close();
        }
    }
}