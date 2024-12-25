<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.blog.BlogPost" %>
<%
    BlogPost post = (BlogPost) request.getAttribute("blogPost");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>编辑博客</title>
</head>
<body>
<h1>编辑博客</h1>
<form action="/edit-blog" method="post" accept-charset="UTF-8">
    <input type="hidden" name="id" value="<%= post.getId() %>">
    <label for="title">标题：</label>
    <input type="text" id="title" name="title" value="<%= post.getTitle() %>">
    <label for="content">内容：</label>
    <textarea id="content" name="content"><%= post.getContent() %></textarea>
    <button type="submit">保存</button>
</form>
</body>
</html>
