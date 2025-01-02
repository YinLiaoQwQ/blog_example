<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.blog.BlogPost" %>
<%@ page import="java.util.List" %>
<%
    // 从请求中获取博客帖子列表
    List<BlogPost> blogPosts = (List<BlogPost>) request.getAttribute("blogPosts");
    // 获取当前用户名
    String username = (String) request.getSession().getAttribute("username");
    // 获取筛选参数，默认为 "all"
    String filter = request.getParameter("filter") == null ? "all" : request.getParameter("filter");
    // 获取搜索查询，默认为空
    String query = request.getParameter("query") == null ? "" : request.getParameter("query");
%>
<!DOCTYPE html>
<html lang="zh-CN" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>博客系统 - 博文</title>
    <!-- 外部CSS文件链接（如果有的话） -->
    <link rel="stylesheet" href="css/blogs_styles.css">
    <link rel="stylesheet" href="css/blogs.css">
</head>
<body>
<!-- 高斯模糊背景层 -->
<div class="background-blur"></div>

<!-- 头部部分 -->
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
        <button class="dark-mode-toggle" title="切换深色模式" aria-label="切换深色模式">
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
            <form method="get" action="blogs" style="display: flex; gap: 10px; align-items: center;">
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
                // 筛选逻辑
                if ("mine".equals(filter) && !post.getUsername().equals(username)) continue;
                if (!query.isEmpty() && !(post.getTitle().contains(query) || post.getContent().contains(query))) continue;
                hasPosts = true;
    %>
    <div class="blog-post <%= post.getUsername().equals(username) ? "current-user" : "" %>">
        <h2><%= post.getTitle() %></h2>
        <div class="content">
            <%= post.getContent() %>
        </div>
        <button class="toggle" aria-expanded="false">展开</button>
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

<!-- JavaScript 部分 -->
<script>
    window.onload = function () {
        // 设置菜单显示与隐藏
        const settingsMenu = document.querySelector('.settings-menu');
        const settingsButton = document.querySelector('.settings');

        // 使用点击事件代替鼠标悬停，提高移动设备的兼容性
        settingsButton.addEventListener('click', function (e) {
            e.stopPropagation(); // 防止事件冒泡
            const isVisible = settingsMenu.style.display === 'flex';
            settingsMenu.style.display = isVisible ? 'none' : 'flex';
            settingsMenu.style.flexDirection = 'column';
        });

        // 点击页面其他地方关闭设置菜单
        document.addEventListener('click', function () {
            settingsMenu.style.display = 'none';
        });

        // 博客内容折叠/展开功能
        const MAX_HEIGHT_PX = 100; // 设置内容显示的最大高度（px）

        document.querySelectorAll('.blog-post').forEach(post => {
            const contentDiv = post.querySelector('.content');
            const toggleBtn = post.querySelector('.toggle');

            // 检查内容是否垂直或水平溢出
            const isOverflowing = contentDiv.scrollHeight > contentDiv.clientHeight || contentDiv.scrollWidth > contentDiv.clientWidth;

            if (isOverflowing) {
                // 添加 'collapsed' 类
                contentDiv.classList.add('collapsed');

                // 检查是否是单行溢出
                const isSingleLine = contentDiv.scrollWidth > contentDiv.clientWidth && contentDiv.scrollHeight <= contentDiv.clientHeight;

                if (isSingleLine) {
                    contentDiv.classList.add('single-line');
                }

                // 显示“展开”按钮
                toggleBtn.style.display = 'block';
                toggleBtn.textContent = '展开';
                toggleBtn.setAttribute('aria-expanded', 'false');

                // 绑定点击事件
                toggleBtn.addEventListener('click', function (e) {
                    e.stopPropagation(); // 防止事件冒泡
                    const isExpanded = contentDiv.classList.toggle('expanded');

                    if (isExpanded) {
                        // 展开内容
                        contentDiv.classList.remove('collapsed');
                        contentDiv.classList.remove('single-line');
                        toggleBtn.textContent = '折叠';
                        toggleBtn.setAttribute('aria-expanded', 'true');
                    } else {
                        // 折叠内容
                        contentDiv.classList.add('collapsed');
                        if (isSingleLine) {
                            contentDiv.classList.add('single-line');
                        }
                        toggleBtn.textContent = '展开';
                        toggleBtn.setAttribute('aria-expanded', 'false');
                    }
                });
            } else {
                // 内容不超过最大高度或宽度，隐藏展开按钮
                toggleBtn.style.display = 'none';
            }
        });

        // 点击空白区域折叠所有已展开的博客内容
        document.body.addEventListener('click', function (e) {
            if (!e.target.closest('.blog-post')) {
                document.querySelectorAll('.blog-post .content.expanded').forEach(content => {
                    content.classList.remove('expanded');
                    content.classList.add('collapsed');
                    // 检查是否需要添加 'single-line' 类
                    if (content.scrollWidth > content.clientWidth && content.scrollHeight <= content.clientHeight) {
                        content.classList.add('single-line');
                    }
                    const toggleBtn = content.closest('.blog-post').querySelector('.toggle');
                    toggleBtn.textContent = '展开';
                    toggleBtn.setAttribute('aria-expanded', 'false');
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
        } else {
            document.documentElement.setAttribute('data-theme', 'light'); // 确保默认是浅色模式
            darkModeToggle.textContent = '🌙'; // 切换到深色模式的图标
        }

        darkModeToggle.addEventListener('click', function () {
            const currentTheme = document.documentElement.getAttribute('data-theme');
            const newTheme = currentTheme === 'light' ? 'dark' : 'light';
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            darkModeToggle.textContent = newTheme === 'dark' ? '☀️' : '🌙';
        });
    };
</script>
</body>
</html>
