package org.example.adbs;

import java.io.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.sql.*;

@WebServlet(name = "todoServlet", value = "/todo")
public class TodoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            handleAdd(request, response);
        } else if ("strike".equals(action)) {
            handleStrike(request, response);
        } else if ("delete".equals(action)) {
            handleDelete(request, response);
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String description = request.getParameter("description");
        String username = (String) request.getSession().getAttribute("user");

        try (Connection connection = DatabaseUtils.getConnection()) {
            String sql = "INSERT INTO todos (user_id, description) VALUES ((SELECT id FROM users WHERE username = ?), ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, description);
            statement.executeUpdate();

            response.sendRedirect("todo.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("todo.jsp?error=Database error");
        }
    }

    private void handleStrike(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int todoId = Integer.parseInt(request.getParameter("id"));

        try (Connection connection = DatabaseUtils.getConnection()) {
            String sql = "UPDATE todos SET is_done = NOT is_done WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, todoId);
            statement.executeUpdate();

            response.sendRedirect("todo.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("todo.jsp?error=Database error");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int todoId = Integer.parseInt(request.getParameter("id"));

        try (Connection connection = DatabaseUtils.getConnection()) {
            String sql = "DELETE FROM todos WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, todoId);
            statement.executeUpdate();

            response.sendRedirect("todo.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("todo.jsp?error=Database error");
        }
    }
}
