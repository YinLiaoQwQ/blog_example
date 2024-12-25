<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.blog.BlogPost" %>
<%@ page import="java.util.List" %>
<%
    List<BlogPost> blogPosts = (List<BlogPost>) request.getAttribute("blogPosts");
    String username = (String) request.getSession().getAttribute("username");
    String filter = request.getParameter("filter") == null ? "all" : request.getParameter("filter");
    String query = request.getParameter("query") == null ? "" : request.getParameter("query");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>博客系统 - 博文</title>
    <link rel="stylesheet" href="css/blogs_styles.css">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const MAX_LENGTH = 100;

            // 初始化博客的折叠/展开逻辑
            document.querySelectorAll('.blog-post').forEach(post => {
                const content = post.querySelector('p');
                const toggleBtn = post.querySelector('.toggle');
                const fullContent = content.textContent.trim();

                if (fullContent.length > MAX_LENGTH) {
                    const truncatedContent = fullContent.substring(0, MAX_LENGTH) + '...';
                    content.textContent = truncatedContent;

                    toggleBtn.style.display = 'block';
                    toggleBtn.textContent = '展开';

                    toggleBtn.addEventListener('click', function (e) {
                        e.stopPropagation(); // 防止冒泡
                        if (content.classList.contains('expanded')) {
                            content.textContent = truncatedContent;
                            content.classList.remove('expanded');
                            toggleBtn.textContent = '展开';
                        } else {
                            content.textContent = fullContent;
                            content.classList.add('expanded');
                            toggleBtn.textContent = '折叠';
                        }
                    });
                } else {
                    toggleBtn.style.display = 'none'; // 如果内容较短，不显示按钮
                }
            });

            // 点击空白区域折叠所有已展开的博客内容
            document.body.addEventListener('click', function (e) {
                if (!e.target.closest('.blog-post')) {
                    // 检查点击是否在博客框外
                    document.querySelectorAll('.blog-post p.expanded').forEach(content => {
                        const toggleBtn = content.closest('.blog-post').querySelector('.toggle');
                        const fullContent = content.dataset.fullContent;
                        const truncatedContent = fullContent.substring(0, MAX_LENGTH) + '...';
                        content.textContent = truncatedContent;
                        content.classList.remove('expanded');
                        toggleBtn.textContent = '展开';
                    });
                }
            });

            document.querySelectorAll('.blog-post').forEach(post => {
                post.addEventListener('click', function (e) {
                    e.stopPropagation();
                });
            });

            // 悬停菜单功能
            const settingsMenu = document.querySelector('.settings-menu');
            const settings = document.querySelector('.settings');
            let timeout;

            settings.addEventListener('mouseenter', () => {
                clearTimeout(timeout);
                settingsMenu.style.display = 'block';
            });

            settings.addEventListener('mouseleave', () => {
                timeout = setTimeout(() => {
                    settingsMenu.style.display = 'none';
                }, 300);
            });

            // 切换筛选模式
            const filterToggle = document.querySelector('.filter-toggle');
            const filterForm = document.querySelector('#filter-form');
            filterToggle.addEventListener('click', function () {
                const currentFilter = filterToggle.dataset.filter;
                const newFilter = currentFilter === 'all' ? 'mine' : 'all';
                filterToggle.dataset.filter = newFilter;
                filterForm.querySelector('input[name="filter"]').value = newFilter;
                filterForm.submit();
            });
        });
    </script>
</head>
<body>
<header>
    <div class="welcome">
        <% if (username != null) { %>
        欢迎您，<span><%= username %></span>!
        <% } else { %>
        <a href="/login.jsp">登录</a> | <a href="/register.jsp">注册</a>
        <% } %>
    </div>
    <div class="settings">
        <img src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="Settings">
        <div class="settings-menu">
            <a href="/new-blog.jsp">创建新博文</a>
            <a href="/logout">退出</a>
        </div>
    </div>
</header>
<div class="blog-container">
    <div class="filter-bar">
        <h1>博客列表</h1>
        <div style="display: flex; gap: 10px; align-items: center;">
            <!-- 筛选功能：眼睛图标切换 -->
            <form method="get" action="/blogs" id="filter-form" style="display: none;">
                <input type="hidden" name="filter" value="<%= filter %>">
            </form>
            <img
                    src="https://cdn-icons-png.flaticon.com/512/709/709612.png"
                    alt="Toggle Filter"
                    class="filter-toggle"
                    style="width: 30px; height: 30px; cursor: pointer;"
                    data-filter="<%= filter %>"
                    title="<%= "mine".equals(filter) ? "切换到查看所有博客" : "切换到仅查看我的博客" %>">
            <!-- 搜索框 -->
            <form method="get" action="/blogs" style="display: flex; gap: 10px; align-items: center;">
                <input type="hidden" name="filter" value="<%= filter %>">
                <input
                        type="text"
                        name="query"
                        placeholder="搜索标题或内容..."
                        value="<%= query %>"
                        style="padding: 10px; font-size: 1rem; border-radius: 5px; border: 1px solid #ccc; width: 250px;">
                <button
                        type="submit"
                        style="padding: 10px 20px; background-color: #3f51b5; color: white; border: none; border-radius: 5px; cursor: pointer;">
                    搜索
                </button>
            </form>
        </div>
    </div>
    <%
        boolean hasPosts = false;
        if (blogPosts != null && !blogPosts.isEmpty()) {
            for (BlogPost post : blogPosts) {
                if ("mine".equals(filter) && !post.getUsername().equals(username)) continue;
                if (!query.isEmpty() && !(post.getTitle().contains(query) || post.getContent().contains(query))) continue;
                hasPosts = true;
    %>
    <div class="blog-post <%= post.getUsername().equals(username) ? "current-user" : "" %>">
        <h2><%= post.getTitle() %></h2>
        <p><%= post.getContent() %></p>
        <span class="toggle"></span>
        <% if (post.getUsername().equals(username)) { %>
        <div class="actions">
            <button onclick="location.href='/edit-blog?id=<%= post.getId() %>'" class="edit-btn">编辑</button>
            <form action="/delete-blog" method="post" style="display:inline;">
                <input type="hidden" name="id" value="<%= post.getId() %>">
                <button type="submit" class="delete-btn">删除</button>
            </form>
        </div>
        <% } %>
        <small>由 <strong><%= post.getUsername() %></strong> 于 <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(post.getCreatedAt()) %> 发布</small>
    </div>
    <%
            }
        }
        if (!hasPosts) {
    %>
    <div class="no-content">暂无博客内容</div>
    <% } %>
</div>
</body>
</html>
