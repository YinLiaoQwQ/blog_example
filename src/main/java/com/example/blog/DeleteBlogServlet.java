package com.example.blog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DeleteBlogServlet", value = "/delete-blog")
public class DeleteBlogServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少文章ID参数");
            return;
        }

        int postId;
        try {
            postId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的文章ID");
            return;
        }

        BlogService blogService = new BlogService();
        boolean success = blogService.deleteBlogPost(postId);

        if (success) {
            response.sendRedirect("/blogs");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "删除文章失败");
        }
    }
}
