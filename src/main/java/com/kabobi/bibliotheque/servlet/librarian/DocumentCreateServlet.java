package com.kabobi.bibliotheque.servlet.librarian;

import com.kabobi.bibliotheque.entity.Book;
import com.kabobi.bibliotheque.entity.CD;
import com.kabobi.bibliotheque.entity.DVD;
import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.DocumentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/librarian/documents/create")
public class DocumentCreateServlet extends HttpServlet {

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

        if (currentUser == null || (!currentUser.isLibrarian() && !currentUser.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String type = request.getParameter("type");
        request.setAttribute("type", type);
        request.getRequestDispatcher("/WEB-INF/views/librarian/documents/create.jsp")
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

        String type = request.getParameter("type");
        String title = request.getParameter("title");
        int totalCopies = Integer.parseInt(request.getParameter("totalCopies"));

        try {
            if ("BOOK".equals(type)) {
                Book book = new Book();
                book.setTitle(title);
                book.setTotalCopies(totalCopies);
                book.setAvailableCopies(totalCopies);
                book.setIsbn(request.getParameter("isbn"));
                book.setAuthor(request.getParameter("author"));
                book.setPublisher(request.getParameter("publisher"));
                if (request.getParameter("publicationYear") != null && !request.getParameter("publicationYear").isEmpty()) {
                    book.setPublicationYear(Integer.parseInt(request.getParameter("publicationYear")));
                }
                if (request.getParameter("numberOfPages") != null && !request.getParameter("numberOfPages").isEmpty()) {
                    book.setNumberOfPages(Integer.parseInt(request.getParameter("numberOfPages")));
                }
                documentService.createBook(book);

            } else if ("CD".equals(type)) {
                CD cd = new CD();
                cd.setTitle(title);
                cd.setTotalCopies(totalCopies);
                cd.setAvailableCopies(totalCopies);
                cd.setArtist(request.getParameter("artist"));
                if (request.getParameter("duration") != null && !request.getParameter("duration").isEmpty()) {
                    cd.setDuration(Integer.parseInt(request.getParameter("duration")));
                }
                cd.setRecordCompany(request.getParameter("recordCompany"));
                documentService.createCD(cd);

            } else if ("DVD".equals(type)) {
                DVD dvd = new DVD();
                dvd.setTitle(title);
                dvd.setTotalCopies(totalCopies);
                dvd.setAvailableCopies(totalCopies);
                dvd.setDirector(request.getParameter("director"));
                if (request.getParameter("duration") != null && !request.getParameter("duration").isEmpty()) {
                    dvd.setDuration(Integer.parseInt(request.getParameter("duration")));
                }
                dvd.setSubtitles(request.getParameter("subtitles"));
                documentService.createDVD(dvd);
            }

            session.setAttribute("success", "Document créé avec succès !");
            response.sendRedirect(request.getContextPath() + "/librarian/documents");

        } catch (Exception e) {
            session.setAttribute("error", "Erreur lors de la création : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/librarian/documents/create?type=" + type);
        }
    }

    @Override
    public void destroy() {
        if (documentService != null) {
            documentService.close();
        }
    }
}