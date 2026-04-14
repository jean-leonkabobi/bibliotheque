package com.kabobi.bibliotheque.servlet.admin;

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

@WebServlet("/admin/members/create")
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

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/members/create.jsp")
                .forward(request, response);
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

        // Récupérer les paramètres
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String roleStr = request.getParameter("role");
        String statusStr = request.getParameter("status");

        // Validation
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "L'email est requis");
            request.getRequestDispatcher("/WEB-INF/views/admin/members/create.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Le mot de passe doit contenir au moins 6 caractères");
            request.getRequestDispatcher("/WEB-INF/views/admin/members/create.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas");
            request.getRequestDispatcher("/WEB-INF/views/admin/members/create.jsp").forward(request, response);
            return;
        }

        // Déterminer le rôle
        Role role;
        try {
            role = Role.valueOf(roleStr);
        } catch (Exception e) {
            role = Role.MEMBER;
        }

        // Déterminer le statut
        UserStatus status;
        try {
            status = UserStatus.valueOf(statusStr);
        } catch (Exception e) {
            status = UserStatus.PENDING;
        }

        // Créer l'utilisateur
        User newUser = new User(email, password, firstName, lastName, role);
        newUser.setStatus(status);

        boolean created = userService.createUser(newUser, password);

        if (created) {
            session.setAttribute("success", "Compte créé avec succès !");
            response.sendRedirect(request.getContextPath() + "/admin/members");
        } else {
            request.setAttribute("error", "Cet email est déjà utilisé");
            request.setAttribute("email", email);
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("selectedRole", roleStr);
            request.setAttribute("selectedStatus", statusStr);
            request.getRequestDispatcher("/WEB-INF/views/admin/members/create.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}