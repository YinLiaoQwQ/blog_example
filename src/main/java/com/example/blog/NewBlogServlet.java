package com.example.blog;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet(name = "NewBlogServlet", value = "/create-blog")
public class NewBlogServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 设置请求编码为 UTF-8
        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String content = request.getParameter("content");

        HttpSession session = request.getSession(false);
        String username = session != null ? (String) session.getAttribute("username") : null;

        if (username == null) {
            response.sendRedirect("/login.jsp");
            return;
        }

        try (Connection connection = DBUtil.getConnection()) {
            String query = "INSERT INTO posts (title, content, username, created_at) VALUES (?, ?, ?, NOW())";
            PreparedStatement statement = connection.prepareStatement(query);
            statement.setString(1, title);
            statement.setString(2, content);
            statement.setString(3, username);

            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("/blogs");
    }
}
