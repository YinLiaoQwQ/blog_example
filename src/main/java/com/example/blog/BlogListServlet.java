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
        String filter = request.getParameter("filter") == null ? "all" : request.getParameter("filter");
        String query = request.getParameter("query");

        try (Connection connection = DBUtil.getConnection()) {
            StringBuilder sql = new StringBuilder("SELECT id, title, content, username, created_at FROM posts WHERE 1=1");

            if ("mine".equals(filter)) {
                sql.append(" AND username = ?");
            }

            if (query != null && !query.trim().isEmpty()) {
                sql.append(" AND (title LIKE ? OR content LIKE ?)");
            }

            sql.append(" ORDER BY created_at DESC");
            PreparedStatement statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            if ("mine".equals(filter)) {
                String username = (String) request.getSession().getAttribute("username");
                statement.setString(paramIndex++, username);
            }

            if (query != null && !query.trim().isEmpty()) {
                String keyword = "%" + query.trim() + "%";
                statement.setString(paramIndex++, keyword);
                statement.setString(paramIndex, keyword);
            }

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                BlogPost post = new BlogPost();
                post.setId(resultSet.getInt("id"));
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
        request.setAttribute("filter", filter);
        request.setAttribute("query", query);
        request.getRequestDispatcher("/blogs.jsp").forward(request, response);
    }
}
