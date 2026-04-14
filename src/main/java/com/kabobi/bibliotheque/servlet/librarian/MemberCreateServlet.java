package com.kabobi.bibliotheque.servlet.librarian;

import com.kabobi.bibliotheque.entity.Role;
import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.entity.UserStatus;
import com.kabobi.bibliotheque.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/librarian/members/create")
public class MemberCreateServlet extends HttpServlet {

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

        if (currentUser == null || (!currentUser.isLibrarian() && !currentUser.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/librarian/members/create.jsp")
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

        // Récupérer les paramètres
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");

        // Validation
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "L'email est requis");
            request.getRequestDispatcher("/WEB-INF/views/librarian/members/create.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Le mot de passe doit contenir au moins 6 caractères");
            request.getRequestDispatcher("/WEB-INF/views/librarian/members/create.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas");
            request.getRequestDispatcher("/WEB-INF/views/librarian/members/create.jsp").forward(request, response);
            return;
        }

        // Le bibliothécaire ne peut créer que des MEMBERS
        User newUser = new User(email, password, firstName, lastName, Role.MEMBER);
        newUser.setStatus(UserStatus.PENDING); // En attente de validation

        boolean created = userService.createUser(newUser, password);

        if (created) {
            session.setAttribute("success", "Membre créé avec succès ! En attente de validation.");
            response.sendRedirect(request.getContextPath() + "/librarian/members");
        } else {
            request.setAttribute("error", "Cet email est déjà utilisé");
            request.setAttribute("email", email);
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.getRequestDispatcher("/WEB-INF/views/librarian/members/create.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}