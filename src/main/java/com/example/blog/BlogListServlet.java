package com.example.blog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BlogListServlet", value = "/blogs")
public class BlogListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        List<BlogPost> blogPosts = new ArrayList<>();

        try (Connection connection = DBUtil.getConnection()) {
            String query = "SELECT title, content, username, created_at FROM posts ORDER BY created_at DESC";
            PreparedStatement statement = connection.prepareStatement(query);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                BlogPost post = new BlogPost();
                post.setTitle(resultSet.getString("title"));
                post.setContent(resultSet.getString("content"));
                post.setUsername(resultSet.getString("username"));
                post.setCreatedAt(resultSet.getTimestamp("created_at"));
                blogPosts.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "无法检索博客文章");
            return;
        }

        request.setAttribute("blogPosts", blogPosts);
        request.getRequestDispatcher("/blogs.jsp").forward(request, response);
    }
}
