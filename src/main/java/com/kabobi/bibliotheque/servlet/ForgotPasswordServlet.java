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

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez saisir votre adresse email");
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
                    .forward(request, response);
            return;
        }

        Optional<User> userOpt = userService.getUserByEmail(email);

        if (userOpt.isEmpty()) {
            request.setAttribute("error", "Aucun compte trouvé avec cet email");
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
                    .forward(request, response);
            return;
        }

        // TODO: Envoyer un email avec un lien de réinitialisation
        // Pour l'instant, on affiche juste un message de succès

        request.setAttribute("success", "Un lien de réinitialisation a été envoyé à votre adresse email");
        request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
                .forward(request, response);
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}