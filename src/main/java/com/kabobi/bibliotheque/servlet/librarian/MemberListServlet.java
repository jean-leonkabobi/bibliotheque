package com.kabobi.bibliotheque.servlet.librarian;

import com.kabobi.bibliotheque.entity.User;
import com.kabobi.bibliotheque.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/librarian/members")
public class MemberListServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        System.out.println("=== Librarian MemberListServlet INITIALISEE ===");
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

        String statusFilter = request.getParameter("status");
        String search = request.getParameter("search");

        // Récupérer uniquement les MEMBERS
        List<User> users = userService.getAllMembers();

        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
            users = users.stream()
                    .filter(u -> u.getStatus().name().equals(statusFilter))
                    .toList();
        }

        if (search != null && !search.isEmpty()) {
            String searchLower = search.toLowerCase().trim();
            users = users.stream()
                    .filter(u -> {
                        String fullName = (u.getFirstName() + " " + u.getLastName()).toLowerCase();
                        return fullName.contains(searchLower) ||
                                u.getFirstName().toLowerCase().contains(searchLower) ||
                                u.getLastName().toLowerCase().contains(searchLower) ||
                                u.getEmail().toLowerCase().contains(searchLower);
                    })
                    .toList();
        }

        long activeMembers = users.stream().filter(u -> u.getStatus().name().equals("ACTIVE")).count();
        long pendingMembers = users.stream().filter(u -> u.getStatus().name().equals("PENDING")).count();
        long suspendedMembers = users.stream().filter(u -> u.getStatus().name().equals("SUSPENDED")).count();

        request.setAttribute("users", users);
        request.setAttribute("totalMembers", users.size());
        request.setAttribute("activeMembers", activeMembers);
        request.setAttribute("pendingMembers", pendingMembers);
        request.setAttribute("suspendedMembers", suspendedMembers);
        request.setAttribute("currentStatus", statusFilter);
        request.setAttribute("currentSearch", search);

        request.getRequestDispatcher("/WEB-INF/views/librarian/members/list.jsp")
                .forward(request, response);
    }

    @Override
    public void destroy() {
        if (userService != null) {
            userService.close();
        }
    }
}