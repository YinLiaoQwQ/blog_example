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
    <link rel="stylesheet" href="css/blogs_styles.css">
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
