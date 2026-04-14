package com.kabobi.bibliotheque.filter;

import com.kabobi.bibliotheque.entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // Pages publiques (accessibles sans authentification)
        boolean isPublicPage = path.equals("/login") ||
                path.equals("/register") ||
                path.equals("/forgot-password") ||
                path.equals("/reset-password") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/images/") ||
                path.equals("/") ||
                path.equals("/index.jsp");

        // Pages d'erreur
        boolean isErrorPage = path.startsWith("/WEB-INF/views/error/");

        if (isPublicPage || isErrorPage) {
            chain.doFilter(request, response);
            return;
        }

        // Vérifier l'authentification
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // Vérifier les permissions
        User user = (User) session.getAttribute("user");

        // URLs accessibles uniquement par ADMIN
        boolean isAdminOnly = path.startsWith("/admin/");

        // URLs accessibles par ADMIN et LIBRARIAN
        boolean isLibrarianAccessible = path.startsWith("/librarian/");

        // URLs accessibles par tous les utilisateurs connectés (membres aussi)
        boolean isMemberAccessible = path.startsWith("/member/");

        if (isAdminOnly && !user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (isLibrarianAccessible && !(user.isAdmin() || user.isLibrarian())) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation
    }

    @Override
    public void destroy() {
        // Nettoyage
    }
}