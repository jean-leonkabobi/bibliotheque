package com.kabobi.bibliotheque.servlet;

import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String email = request.getParameter("email");

        if (token == null || email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        // TODO: Vérifier que le token est valide
        request.setAttribute("email", email);
        request.setAttribute("token", token);

        request.getRequestDispatcher("/WEB-INF/views/reset-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("error", "Le mot de passe doit contenir au moins 6 caractères");
            request.setAttribute("email", email);
            request.setAttribute("token", token);
            request.getRequestDispatcher("/WEB-INF/views/reset-password.jsp")
                    .forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas");
            request.setAttribute("email", email);
            request.setAttribute("token", token);
            request.getRequestDispatcher("/WEB-INF/views/reset-password.jsp")
                    .forward(request, response);
            return;
        }

        Optional<User> userOpt = userService.getUserByEmail(email);

        if (userOpt.isEmpty()) {
            request.setAttribute("error", "Utilisateur non trouvé");
            request.getRequestDispatcher("/WEB-INF/views/reset-password.jsp")
                    .forward(request, response);
            return;
        }

        // TODO: Vérifier que le token est valide avant de changer le mot de passe
        boolean success = userService.changePassword(userOpt.get().getId(), newPassword);

        if (success) {
            request.setAttribute("success", "Votre mot de passe a été modifié avec succès !");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                    .forward(request, response);
        } else {
            request.setAttribute("error", "Erreur lors de la modification du mot de passe");
            request.setAttribute("email", email);
            request.setAttribute("token", token);
            request.getRequestDispatcher("/WEB-INF/views/reset-password.jsp")
                    .forward(request, response);
        }
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}