package com.kabobi.bibliotheque.servlet.member;

import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/member/profile")
public class ProfileServlet extends HttpServlet {

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

        request.setAttribute("member", currentUser);
        request.getRequestDispatcher("/WEB-INF/views/member/profile.jsp")
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

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Vérifier l'email unique
        Optional<User> existingUser = userService.getUserByEmail(email);
        if (existingUser.isPresent() && !existingUser.get().getId().equals(currentUser.getId())) {
            session.setAttribute("error", "Cet email est déjà utilisé");
            response.sendRedirect(request.getContextPath() + "/member/profile");
            return;
        }

        // Mettre à jour les informations
        userService.updateUserInfo(currentUser.getId(), firstName, lastName, email);

        // Changer le mot de passe si demandé
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (newPassword.length() < 6) {
                session.setAttribute("error", "Le mot de passe doit contenir au moins 6 caractères");
                response.sendRedirect(request.getContextPath() + "/member/profile");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("error", "Les mots de passe ne correspondent pas");
                response.sendRedirect(request.getContextPath() + "/member/profile");
                return;
            }

            userService.changePassword(currentUser.getId(), newPassword);
        }

        // Mettre à jour la session
        session.setAttribute("user", userService.getUserById(currentUser.getId()).get());
        session.setAttribute("success", "Profil mis à jour avec succès");

        response.sendRedirect(request.getContextPath() + "/member/profile");
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}