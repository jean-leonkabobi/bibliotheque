package com.kabobi.bibliotheque.servlet.member;

import com.kabobi.bibliotheque.dao.DocumentDAO;
import com.kabobi.bibliotheque.entity.Book;
import com.kabobi.bibliotheque.entity.CD;
import com.kabobi.bibliotheque.entity.DVD;
import com.kabobi.bibliotheque.entity.Document;
import com.kabobi.bibliotheque.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/member/catalog")
public class CatalogServlet extends HttpServlet {

    private DocumentDAO documentDAO;

    @Override
    public void init() throws ServletException {
        documentDAO = new DocumentDAO();
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

        String typeFilter = request.getParameter("type");
        String search = request.getParameter("search");

        List<Document> documents;

        if (search != null && !search.trim().isEmpty()) {
            documents = documentDAO.searchByTitle(search);
            request.setAttribute("searchQuery", search);
        } else {
            documents = documentDAO.findAll();
        }

        // Appliquer le filtre par type
        if (typeFilter != null && !typeFilter.equals("all")) {
            documents = documents.stream()
                    .filter(d -> {
                        if ("BOOK".equals(typeFilter)) return d instanceof Book;
                        if ("CD".equals(typeFilter)) return d instanceof CD;
                        if ("DVD".equals(typeFilter)) return d instanceof DVD;
                        return true;
                    })
                    .collect(Collectors.toList());
        }

        // Compter les statistiques
        long booksCount = documents.stream().filter(d -> d instanceof Book).count();
        long cdsCount = documents.stream().filter(d -> d instanceof CD).count();
        long dvdsCount = documents.stream().filter(d -> d instanceof DVD).count();

        request.setAttribute("documents", documents);
        request.setAttribute("totalCount", documents.size());
        request.setAttribute("booksCount", booksCount);
        request.setAttribute("cdsCount", cdsCount);
        request.setAttribute("dvdsCount", dvdsCount);
        request.setAttribute("currentType", typeFilter);

        request.getRequestDispatcher("/WEB-INF/views/member/catalog.jsp")
                .forward(request, response);
    }

    @Override
    public void destroy() {
        if (documentDAO != null) {
            documentDAO.close();
        }
    }
}