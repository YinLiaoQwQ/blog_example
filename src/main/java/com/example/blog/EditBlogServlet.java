package com.example.blog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "EditBlogServlet", value = "/edit-blog")
public class EditBlogServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "博客ID不能为空");
            return;
        }

        int id = Integer.parseInt(idStr);
        BlogService blogService = new BlogService();
        BlogPost blogPost = blogService.getBlogById(id);

        if (blogPost == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "找不到该博客");
            return;
        }

        request.setAttribute("blogPost", blogPost);
        request.getRequestDispatcher("/edit-blog.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        if (idStr == null || idStr.isEmpty() || title == null || content == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID、标题或内容不能为空");
            return;
        }

        int id = Integer.parseInt(idStr);

        BlogService blogService = new BlogService();
        boolean updated = blogService.updateBlog(id, title, content);

        if (updated) {
            response.sendRedirect("/blogs");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "更新博客失败");
        }
    }
}
