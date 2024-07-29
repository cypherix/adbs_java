<%@ page import="java.sql.SQLException" %>
<%@ page import="org.example.adbs.DatabaseUtils" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %><%--
  Created by IntelliJ IDEA.
  User: Yogesh
  Date: 12-07-2024
  Time: 16:43
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<html>
<head>
    <title>TODO List</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .todo-item {
            text-align: left;
            margin: 10px 0;
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        .todo-item.done {
            text-decoration: line-through;
        }
        .todo-item button {
            margin-left: 10px;
        }
        .todo-item form {
            display: inline;
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="text-center">TODO List</h1>
    <form action="todo" method="post" class="mb-4">
        <input type="hidden" name="action" value="add">
        <div class="input-group">
            <input type="text" name="description" class="form-control" placeholder="New TODO" required>
            <div class="input-group-append">
                <button type="submit" class="btn btn-primary">Add</button>
            </div>
        </div>
    </form>
    <%
        String username = (String) session.getAttribute("user");
        if (username != null) {
            try (Connection connection = DatabaseUtils.getConnection()) {
                String sql = "SELECT * FROM todos WHERE user_id = (SELECT id FROM users WHERE username = ?)";
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, username);
                ResultSet resultSet = statement.executeQuery();

                while (resultSet.next()) {
                    int id = resultSet.getInt("id");
                    String description = resultSet.getString("description");
                    boolean isDone = resultSet.getBoolean("is_done");
    %>
    <div class="todo-item <%= isDone ? "done" : "" %>">
        <%= description %>
        <form action="todo" method="post">
            <input type="hidden" name="action" value="strike">
            <input type="hidden" name="id" value="<%= id %>">
            <button type="submit" class="btn btn-success btn-sm"><%= isDone ? "Undo" : "Done" %></button>
        </form>
        <form action="todo" method="post">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" value="<%= id %>">
            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
        </form>
    </div>
    <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</div>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>
</html>

