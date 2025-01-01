<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<html lang="zh-CN" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>博客系统 - 博文</title>
    <link rel="stylesheet" href="css/blogs_styles.css">
    <style>
        /* 颜色主题定义 */
        :root {
            --background-gradient-start: #a8e063;
            --background-gradient-end: #56ab2f;
            --text-color: #333;
            --header-bg: rgba(255, 255, 255, 0.8);
            --header-text-color: #333;
            --form-bg: rgba(255, 255, 255, 0.85);
            --form-text-color: #333;
            --button-bg: #3f51b5;
            --button-hover-bg: #5c6bc0;
            --toggle-bg: #333;
            --toggle-color: #fff;
            --blur-amount: 10px; /* 减少模糊量 */
            --overlay-bg: rgba(255, 255, 255, 0.6); /* 调整覆盖层透明度 */
        }

        [data-theme="dark"] {
            --background-gradient-start: #2c3e50;
            --background-gradient-end: #4ca1af;
            --text-color: #ecf0f1;
            --header-bg: rgba(44, 62, 80, 0.9);
            --header-text-color: #ecf0f1;
            --form-bg: rgba(44, 62, 80, 0.9);
            --form-text-color: #ecf0f1;
            --button-bg: #2980b9;
            --button-hover-bg: #3498db;
            --toggle-bg: #ecf0f1;
            --toggle-color: #333;
            --blur-amount: 10px;
            --overlay-bg: rgba(44, 62, 80, 0.6); /* 调整覆盖层透明度 */
        }

        /* 动态彩色渐变背景 */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(270deg, var(--background-gradient-start), var(--background-gradient-end));
            background-size: 600% 600%;
            animation: GradientAnimation 15s ease infinite;
            color: var(--text-color);
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            position: relative;
            transition: background 0.5s ease, color 0.5s ease;
        }

        @keyframes GradientAnimation {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* 高斯模糊背景层 */
        .background-blur {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            backdrop-filter: blur(var(--blur-amount));
            -webkit-backdrop-filter: blur(var(--blur-amount));
            background: var(--overlay-bg);
            z-index: 1;
            transition: background 0.5s ease;
        }

        /* 容器样式 */
        .blog-container {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 800px;
            padding: 20px;
            background: var(--form-bg);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            transition: background 0.5s ease, color 0.5s ease;
            margin-top: 80px; /* 确保内容不被固定头部覆盖 */
        }

        /* 头部样式 */
        header {
            width: 100%;
            padding: 15px 20px;
            background: var(--header-bg);
            border-bottom: 1px solid #ccc;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 3;
            transition: background 0.5s ease, color 0.5s ease;
            box-sizing: border-box;
        }

        header .welcome a {
            color: var(--header-text-color);
            text-decoration: none;
            margin: 0 5px;
        }

        header .settings-and-toggle {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        header .settings {
            position: relative;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        header .settings img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
        }

        header .settings-menu {
            position: absolute;
            top: 40px;
            right: 0;
            background: var(--form-bg);
            border: 1px solid #ccc;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            display: none;
            flex-direction: column;
            min-width: 150px;
            transition: background 0.5s ease, color 0.5s ease;
        }

        header .settings-menu a {
            padding: 10px 15px;
            text-decoration: none;
            color: var(--header-text-color);
            transition: background 0.3s ease;
        }

        header .settings-menu a:hover {
            background: rgba(0,0,0,0.1);
        }

        /* 过滤栏样式 */
        .filter-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-bar h1 {
            margin: 0;
            font-size: 2rem;
            color: var(--text-color);
        }

        /* 筛选和搜索 */
        .filter-bar .filter-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }

        .filter-toggle {
            width: 30px;
            height: 30px;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .filter-toggle:hover {
            transform: scale(1.1);
        }

        /* 搜索框样式 */
        .filter-bar form {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-bar input[type="text"] {
            padding: 10px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            flex: 1;
            min-width: 200px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .filter-bar input[type="text"]:focus {
            border-color: #3f51b5;
            box-shadow: 0 0 8px rgba(63, 81, 181, 0.3);
            outline: none;
        }

        .filter-bar button {
            padding: 10px 20px;
            background-color: var(--button-bg);
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
        }

        .filter-bar button:hover {
            background-color: var(--button-hover-bg);
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        .filter-bar button:active {
            transform: translateY(1px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        /* 博客文章样式 */
        .blog-post {
            background: var(--form-bg);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: background 0.5s ease, color 0.5s ease, transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            cursor: pointer;
        }

        .blog-post.current-user {
            border-left: 5px solid #3f51b5;
        }

        .blog-post:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .blog-post h2 {
            margin-top: 0;
            color: var(--text-color);
        }

        .blog-post p {
            color: var(--text-color);
            transition: max-height 0.3s ease;
            overflow: hidden;
            max-height: 100px;
        }

        .blog-post p.expanded {
            max-height: none;
            white-space: normal;
        }

        .blog-post .toggle {
            display: block;
            margin-top: 10px;
            color: #3f51b5;
            cursor: pointer;
            font-weight: bold;
            user-select: none;
            transition: color 0.3s ease;
        }

        .blog-post .toggle:hover {
            color: #5c6bc0;
            text-decoration: underline;
        }

        .blog-post .actions {
            margin-top: 15px;
            display: flex;
            gap: 10px;
        }

        .blog-post .edit-btn, .blog-post .delete-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: bold;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
        }

        .blog-post .edit-btn {
            background-color: #ffc107;
            color: #fff;
        }

        .blog-post .edit-btn:hover {
            background-color: #ffb300;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }

        .blog-post .delete-btn {
            background-color: #dc3545;
            color: #fff;
        }

        .blog-post .delete-btn:hover {
            background-color: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }

        .blog-post small {
            display: block;
            margin-top: 10px;
            color: #777;
        }

        /* 无内容提示 */
        .no-content {
            text-align: center;
            color: #777;
            font-size: 1.2rem;
            margin-top: 50px;
        }

        /* 深色模式切换按钮 */
        .dark-mode-toggle {
            background: var(--toggle-bg);
            color: var(--toggle-color);
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.5s ease, color 0.5s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            flex-shrink: 0;
        }

        .dark-mode-toggle:hover {
            background: var(--button-hover-bg);
        }

        /* 响应式设计 */
        @media (max-width: 600px) {
            .filter-bar {
                flex-direction: column;
                align-items: flex-start;
            }

            .filter-bar .filter-actions {
                width: 100%;
                justify-content: space-between;
            }

            .filter-bar input[type="text"] {
                width: 100%;
            }

            .filter-toggle {
                width: 25px;
                height: 25px;
            }
        }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // 右上角设置菜单的显示和隐藏
            const settingsMenu = document.querySelector('.settings-menu');
            const settingsButton = document.querySelector('.settings');
            let menuTimeout;

            settingsButton.addEventListener('mouseenter', () => {
                clearTimeout(menuTimeout);
                settingsMenu.style.display = 'flex';
                settingsMenu.style.flexDirection = 'column';
            });

            settingsButton.addEventListener('mouseleave', () => {
                menuTimeout = setTimeout(() => {
                    settingsMenu.style.display = 'none';
                }, 300);
            });

            settingsMenu.addEventListener('mouseenter', () => {
                clearTimeout(menuTimeout);
            });

            settingsMenu.addEventListener('mouseleave', () => {
                menuTimeout = setTimeout(() => {
                    settingsMenu.style.display = 'none';
                }, 300);
            });

            // 博客内容折叠/展开功能
            const MAX_LENGTH = 100;

            document.querySelectorAll('.blog-post').forEach(post => {
                const content = post.querySelector('p');
                const toggleBtn = post.querySelector('.toggle');
                const fullContent = content.textContent.trim();

                // 存储完整内容到 data-full-content
                content.dataset.fullContent = fullContent;

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

            // 阻止博客内容区域的点击事件冒泡
            document.querySelectorAll('.blog-post').forEach(post => {
                post.addEventListener('click', function (e) {
                    e.stopPropagation();
                });
            });

            // 筛选功能切换
            const filterToggle = document.querySelector('.filter-toggle');
            const filterForm = document.querySelector('#filter-form');
            filterToggle.addEventListener('click', function () {
                const currentFilter = filterToggle.dataset.filter;
                const newFilter = currentFilter === 'all' ? 'mine' : 'all';
                filterToggle.dataset.filter = newFilter;
                filterForm.querySelector('input[name="filter"]').value = newFilter;
                filterToggle.title = newFilter === 'mine' ? '切换到查看所有博客' : '切换到仅查看我的博客';
                filterForm.submit();
            });

            // 深色模式切换
            const darkModeToggle = document.querySelector('.dark-mode-toggle');

            // 检查用户之前的选择
            if (localStorage.getItem('theme') === 'dark') {
                document.documentElement.setAttribute('data-theme', 'dark');
                darkModeToggle.textContent = '☀️'; // 切换到浅色模式的图标
            }

            darkModeToggle.addEventListener('click', function () {
                const currentTheme = document.documentElement.getAttribute('data-theme');
                const newTheme = currentTheme === 'light' ? 'dark' : 'light';
                document.documentElement.setAttribute('data-theme', newTheme);
                localStorage.setItem('theme', newTheme);
                darkModeToggle.textContent = newTheme === 'dark' ? '☀️' : '🌙';
            });
        });
    </script>
</head>
<body>
<!-- 高斯模糊背景层 -->
<div class="background-blur"></div>

<!-- 头部部分，与博客列表页面保持一致 -->
<header>
    <div class="welcome">
        <% if (username != null) { %>
        欢迎您，<span><%= username %></span>!
        <% } else { %>
        <a href="login.jsp">登录</a> | <a href="register.jsp">注册</a>
        <% } %>
    </div>
    <div class="settings-and-toggle">
        <div class="settings">
            <img src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="Settings">
            <div class="settings-menu">
                <a href="new-blog.jsp">创建新博文</a>
                <a href="logout">退出</a>
            </div>
        </div>
        <!-- 深色模式切换按钮 -->
        <button class="dark-mode-toggle" title="切换深色模式">
            🌙
        </button>
    </div>
</header>

<!-- 过滤栏和搜索 -->
<div class="blog-container">
    <div class="filter-bar">
        <h1>博客列表</h1>
        <div class="filter-actions">
            <!-- 筛选功能：眼睛图标切换 -->
            <form method="get" action="blogs" id="filter-form" style="display: none;">
                <input type="hidden" name="filter" value="<%= filter %>">
            </form>
            <img
                    src="https://cdn-icons-png.flaticon.com/512/709/709612.png"
                    alt="Toggle Filter"
                    class="filter-toggle"
                    data-filter="<%= filter %>"
                    title="<%= "mine".equals(filter) ? "切换到查看所有博客" : "切换到仅查看我的博客" %>">
            <!-- 搜索框 -->
            <form method="get" action="<c:url value='blogs'/>" style="display: flex; gap: 10px; align-items: center;">
                <input type="hidden" name="filter" value="<%= filter %>">
                <input
                        type="text"
                        name="query"
                        placeholder="搜索标题或内容..."
                        value="<%= query %>"
                        style="padding: 10px; font-size: 1rem; border-radius: 5px; border: 1px solid #ccc; width: 250px;">
                <button
                        type="submit"
                        style="padding: 10px 20px; background-color: var(--button-bg); color: white; border: none; border-radius: 5px; cursor: pointer;">
                    搜索
                </button>
            </form>
        </div>
    </div>

    <!-- 博客文章列表 -->
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
            <button type="button" onclick="location.href='edit-blog?id=<%= post.getId() %>'" class="edit-btn">编辑</button>
            <form action="delete-blog" method="post" style="display:inline;">
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
