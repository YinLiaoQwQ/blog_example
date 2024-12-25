package com.example.blog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BlogService {

    // 获取博客文章的方法
    public BlogPost getBlogById(int id) {
        BlogPost post = null;

        try (Connection connection = DBUtil.getConnection()) {
            String query = "SELECT id, title, content, username, created_at FROM posts WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(query);
            statement.setInt(1, id);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                post = new BlogPost();
                post.setId(resultSet.getInt("id"));
                post.setTitle(resultSet.getString("title"));
                post.setContent(resultSet.getString("content"));
                post.setUsername(resultSet.getString("username"));
                post.setCreatedAt(resultSet.getTimestamp("created_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return post;
    }

    // 更新博客文章的方法
    public boolean updateBlog(int id, String title, String content) {
        try (Connection connection = DBUtil.getConnection()) {
            String query = "UPDATE posts SET title = ?, content = ? WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(query);
            statement.setString(1, title);
            statement.setString(2, content);
            statement.setInt(3, id);

            int rowsUpdated = statement.executeUpdate();
            return rowsUpdated > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // 删除博客文章的方法
    public boolean deleteBlogPost(int id) {
        try (Connection connection = DBUtil.getConnection()) {
            String query = "DELETE FROM posts WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(query);
            statement.setInt(1, id);

            int rowsDeleted = statement.executeUpdate();
            return rowsDeleted > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
