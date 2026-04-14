package com.kabobi.bibliotheque.servlet.admin;

import com.kabobi.bibliotheque.entity.Book;
import com.kabobi.bibliotheque.entity.CD;
import com.kabobi.bibliotheque.entity.DVD;
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
import java.util.Optional;

@WebServlet("/admin/documents/*")
public class DocumentDetailsServlet extends HttpServlet {

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

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/documents");
            return;
        }

        // Vérifier si c'est une requête d'édition
        if (pathInfo.endsWith("/edit")) {
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];

            try {
                Long id = Long.parseLong(idStr);
                Optional<Document> docOpt = documentService.getDocumentById(id);

                if (docOpt.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document non trouvé");
                    return;
                }

                request.setAttribute("document", docOpt.get());
                request.getRequestDispatcher("/WEB-INF/views/admin/documents/edit.jsp")
                        .forward(request, response);
                return;

            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID invalide");
                return;
            }
        }

        // Vérifier si c'est une requête de suppression
        if (pathInfo.endsWith("/delete")) {
            String[] parts = pathInfo.split("/");
            String idStr = parts[1];

            try {
                Long id = Long.parseLong(idStr);
                boolean deleted = documentService.deleteDocument(id);

                if (deleted) {
                    session.setAttribute("success", "Document supprimé avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la suppression");
                }

            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID invalide");
            }

            response.sendRedirect(request.getContextPath() + "/admin/documents");
            return;
        }

        // Sinon, afficher les détails
        String idStr = pathInfo.substring(1);

        try {
            Long id = Long.parseLong(idStr);
            Optional<Document> docOpt = documentService.getDocumentById(id);

            if (docOpt.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document non trouvé");
                return;
            }

            request.setAttribute("document", docOpt.get());
            request.getRequestDispatcher("/WEB-INF/views/admin/documents/details.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID invalide");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.endsWith("/edit")) {
            String idStr = request.getParameter("id");
            String title = request.getParameter("title");
            int totalCopies = Integer.parseInt(request.getParameter("totalCopies"));

            try {
                Long id = Long.parseLong(idStr);
                Optional<Document> docOpt = documentService.getDocumentById(id);

                if (docOpt.isEmpty()) {
                    session.setAttribute("error", "Document non trouvé");
                    response.sendRedirect(request.getContextPath() + "/admin/documents");
                    return;
                }

                Document doc = docOpt.get();
                doc.setTitle(title);

                int oldTotal = doc.getTotalCopies();
                int diff = totalCopies - oldTotal;
                doc.setTotalCopies(totalCopies);
                doc.setAvailableCopies(doc.getAvailableCopies() + diff);

                if (doc instanceof Book) {
                    Book book = (Book) doc;
                    book.setIsbn(request.getParameter("isbn"));
                    book.setAuthor(request.getParameter("author"));
                    book.setPublisher(request.getParameter("publisher"));
                    if (request.getParameter("publicationYear") != null && !request.getParameter("publicationYear").isEmpty()) {
                        book.setPublicationYear(Integer.parseInt(request.getParameter("publicationYear")));
                    }
                    if (request.getParameter("numberOfPages") != null && !request.getParameter("numberOfPages").isEmpty()) {
                        book.setNumberOfPages(Integer.parseInt(request.getParameter("numberOfPages")));
                    }
                } else if (doc instanceof CD) {
                    CD cd = (CD) doc;
                    cd.setArtist(request.getParameter("artist"));
                    if (request.getParameter("duration") != null && !request.getParameter("duration").isEmpty()) {
                        cd.setDuration(Integer.parseInt(request.getParameter("duration")));
                    }
                    cd.setRecordCompany(request.getParameter("recordCompany"));
                } else if (doc instanceof DVD) {
                    DVD dvd = (DVD) doc;
                    dvd.setDirector(request.getParameter("director"));
                    if (request.getParameter("duration") != null && !request.getParameter("duration").isEmpty()) {
                        dvd.setDuration(Integer.parseInt(request.getParameter("duration")));
                    }
                    dvd.setSubtitles(request.getParameter("subtitles"));
                }

                documentService.updateDocument(doc);
                session.setAttribute("success", "Document modifié avec succès");

            } catch (Exception e) {
                session.setAttribute("error", "Erreur lors de la modification : " + e.getMessage());
            }

            response.sendRedirect(request.getContextPath() + "/admin/documents");
        }
    }

    @Override
    public void destroy() {
        if (documentService != null) {
            documentService.close();
        }
    }
}