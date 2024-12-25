<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.blog.BlogPost" %>
<%
    HttpSession Session = request.getSession(false);
    String username = Session != null ? (String) Session.getAttribute("username") : null;
    List<BlogPost> blogPosts = (List<BlogPost>) request.getAttribute("blogPosts");
    String filter = request.getParameter("filter") == null ? "all" : request.getParameter("filter");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>博客系统 - 博文</title>
    <style>
        /* 通用样式 */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #ece9e6, #ffffff);
            color: #333;
            line-height: 1.6;
        }

        header {
            background-color: #3f51b5;
            color: #fff;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        header .welcome {
            font-size: 1.2rem;
            font-weight: bold;
            display: flex;
            align-items: center;
        }

        header .welcome span {
            margin-left: 10px;
            color: #ffeb3b;
            font-size: 1rem;
        }

        header .settings {
            position: relative;
            cursor: pointer;
            display: flex;
            align-items: center;
        }

        header .settings img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            margin-right: 10px;
        }

        header .settings-menu {
            display: none;
            position: absolute;
            top: 50px;
            right: 0;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            z-index: 2000;
            width: 150px;
            text-align: center;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        header .settings-menu a {
            display: block;
            padding: 10px 15px;
            text-decoration: none;
            color: #333;
            font-size: 0.9rem;
            font-weight: bold;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        header .settings-menu a:hover {
            background-color: #f4f4f9;
            transform: translateY(-2px);
        }

        .settings-menu.active {
            display: block !important;
            opacity: 1;
            visibility: visible;
        }

        h1 {
            color: #3f51b5;
            text-align: left;
            margin: 20px 0;
            font-size: 2rem;
        }

        /* 博客列表容器 */
        .blog-container {
            max-width: 900px;
            margin: 20px auto;
            padding: 0 20px;
        }

        .filter-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 2px solid #ccc;
            padding-bottom: 10px;
        }

        .filter-bar h1 {
            color: #3f51b5;
            margin: 0;
            font-size: 2rem;
        }

        .filter-bar .filter-section select {
            padding: 10px;
            font-size: 1rem;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        /* 博客列表样式 */
        .blog-post {
            background-color: #fff;
            padding: 20px;
            margin: 20px auto;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            max-width: 85%;
            position: relative;
        }

        .blog-post:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
        }

        .blog-post h2 {
            color: #333;
            margin-bottom: 10px;
            font-size: 1.8em;
        }

        .blog-post p {
            margin: 5px 0 15px 0;
            color: #555;
            line-height: 1.6;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .blog-post p.expanded {
            overflow: visible;
            white-space: normal;
        }

        .blog-post .toggle {
            position: absolute;
            bottom: 20px;
            right: 20px;
            font-size: 0.9rem;
            color: #888;
            cursor: pointer;
        }

        .blog-post .toggle:hover {
            color: #333;
        }

        /* 当前用户博客高亮 */
        .blog-post.current-user {
            background-color: #e8f5e9;
            border-left: 5px solid #4caf50;
        }

        .blog-post.current-user h2 {
            color: #388e3c;
        }

        .blog-post.current-user small {
            color: #4caf50;
        }

        /* 暂无内容提示 */
        .no-content {
            text-align: center;
            color: #999;
            font-size: 1.2em;
            margin: 50px 0;
        }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const MAX_LENGTH = 100; // 最大显示字符数

            // 初始化菜单悬停逻辑
            const settings = document.querySelector(".settings");
            const menu = document.querySelector(".settings-menu");
            let hideTimeout;

            settings.addEventListener("mouseenter", () => {
                clearTimeout(hideTimeout); // 清除隐藏计时器
                menu.classList.add("active");
            });

            settings.addEventListener("mouseleave", () => {
                hideTimeout = setTimeout(() => {
                    menu.classList.remove("active");
                }, 800); // 延时隐藏菜单
            });

            // 初始化博客折叠/展开
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
                        e.stopPropagation();
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
                    toggleBtn.style.display = 'none';
                }
            });

            document.body.addEventListener('click', () => {
                document.querySelectorAll('.blog-post p.expanded').forEach(content => {
                    const toggleBtn = content.closest('.blog-post').querySelector('.toggle');
                    const fullContent = content.textContent.trim();
                    const truncatedContent = fullContent.substring(0, MAX_LENGTH) + '...';
                    content.textContent = truncatedContent;
                    content.classList.remove('expanded');
                    toggleBtn.textContent = '展开';
                });
            });
        });
    </script>
</head>
<body>
<header>
    <div class="welcome">
        <% if (username != null) { %>
        欢迎您， <span><%= username %></span>!
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
        <div class="filter-section">
            <form method="get" action="/blogs">
                <select name="filter" onchange="this.form.submit()">
                    <option value="all" <%= "all".equals(filter) ? "selected" : "" %>>查看所有博客</option>
                    <option value="mine" <%= "mine".equals(filter) ? "selected" : "" %>>仅查看我的博客</option>
                </select>
            </form>
        </div>
    </div>
    <%
        boolean hasPosts = false;
        if (blogPosts != null && !blogPosts.isEmpty()) {
            for (BlogPost post : blogPosts) {
                if ("mine".equals(filter) && !post.getUsername().equals(username)) {
                    continue;
                }
                hasPosts = true;
    %>
    <div class="blog-post <%= username != null && username.equals(post.getUsername()) ? "current-user" : "" %>">
        <h2><%= post.getTitle() %></h2>
        <p><%= post.getContent() %></p>
        <span class="toggle"></span>
        <small>由 <strong><%= post.getUsername() %></strong> 于 <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(post.getCreatedAt()) %> 发布</small>
    </div>
    <%
            }
        }
        if (!hasPosts) {
    %>
    <div class="no-content">
        <% if ("mine".equals(filter)) { %>
        您还没有发布任何博客，快去创建一篇吧！
        <% } else { %>
        暂无博客内容，快去发布第一篇博客吧！
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
