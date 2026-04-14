package com.kabobi.bibliotheque.servlet.admin;

import com.kabobi.bibliotheque.entity.Document;
import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.DocumentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/documents")
public class DocumentListServlet extends HttpServlet {

    private DocumentService documentService;

    @Override
    public void init() throws ServletException {
        documentService = new DocumentService();
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

        String search = request.getParameter("search");
        List<Document> documents;

        if (search != null && !search.isEmpty()) {
            documents = documentService.searchByTitle(search);
            request.setAttribute("searchQuery", search);
        } else {
            documents = documentService.getAllDocuments();
        }

        request.setAttribute("documents", documents);
        request.setAttribute("totalDocuments", documents.size());

        request.getRequestDispatcher("/WEB-INF/views/admin/documents/list.jsp")
                .forward(request, response);
    }

    @Override
    public void destroy() {
        if (documentService != null) {
            documentService.close();
        }
    }
}