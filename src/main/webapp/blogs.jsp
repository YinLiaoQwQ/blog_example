<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.blog.BlogPost" %>
<%@ page import="java.util.List" %>
<%
    List<BlogPost> blogPosts = (List<BlogPost>) request.getAttribute("blogPosts");
    String username = (String) request.getSession().getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>博客系统 - 博文</title>
    <link rel="stylesheet" href="blogs_styles.css">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const MAX_LENGTH = 100; // 最大显示字符数

            // 初始化每篇博客的内容
            document.querySelectorAll('.blog-post').forEach(post => {
                const content = post.querySelector('p');
                const toggleBtn = post.querySelector('.toggle');

                // 获取完整内容
                const fullContent = content.textContent.trim();

                if (fullContent.length > MAX_LENGTH) {
                    // 截断内容并显示“展开”按钮
                    const truncatedContent = fullContent.substring(0, MAX_LENGTH) + '...';
                    content.textContent = truncatedContent;

                    toggleBtn.style.display = 'block'; // 显示按钮
                    toggleBtn.textContent = '展开';

                    toggleBtn.addEventListener('click', function (e) {
                        e.stopPropagation();
                        if (content.classList.contains('expanded')) {
                            // 折叠内容
                            content.textContent = truncatedContent;
                            content.classList.remove('expanded');
                            toggleBtn.textContent = '展开';
                        } else {
                            // 展开内容
                            content.textContent = fullContent;
                            content.classList.add('expanded');
                            toggleBtn.textContent = '折叠';
                        }
                    });
                } else {
                    toggleBtn.style.display = 'none'; // 隐藏按钮
                }
            });

            // 点击空白区域折叠所有内容
            document.body.addEventListener('click', function () {
                document.querySelectorAll('.blog-post p.expanded').forEach(content => {
                    const toggleBtn = content.closest('.blog-post').querySelector('.toggle');
                    const fullContent = content.textContent.trim();
                    const truncatedContent = fullContent.substring(0, MAX_LENGTH) + '...';
                    content.textContent = truncatedContent;
                    content.classList.remove('expanded');
                    toggleBtn.textContent = '展开';
                });
            });

            // 防止点击博客内容时触发 body 的折叠事件
            document.querySelectorAll('.blog-post').forEach(post => {
                post.addEventListener('click', function (e) {
                    e.stopPropagation();
                });
            });

            // 右上角菜单的显示和隐藏
            const settingsMenu = document.querySelector('.settings-menu');
            const settingsButton = document.querySelector('.settings');
            let menuTimeout;

            settingsButton.addEventListener('mouseenter', () => {
                clearTimeout(menuTimeout);
                settingsMenu.style.display = 'block';
            });

            settingsButton.addEventListener('mouseleave', () => {
                menuTimeout = setTimeout(() => {
                    settingsMenu.style.display = 'none';
                }, 500);
            });

            settingsMenu.addEventListener('mouseenter', () => {
                clearTimeout(menuTimeout);
            });

            settingsMenu.addEventListener('mouseleave', () => {
                menuTimeout = setTimeout(() => {
                    settingsMenu.style.display = 'none';
                }, 500);
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
        <img src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="设置" style="width:30px; height:30px;">
        <div class="settings-menu" style="display:none; position:absolute; top:40px; right:10px; background:#fff; box-shadow:0 4px 12px rgba(0, 0, 0, 0.2); border-radius:5px; padding:10px;">
            <a href="/new-blog.jsp" style="display:block; padding:5px; text-decoration:none; color:#333;">创建新博文</a>
            <a href="/logout" style="display:block; padding:5px; text-decoration:none; color:#333;">退出</a>
        </div>
    </div>
</header>
<div class="blog-container">
    <%
        for (BlogPost post : blogPosts) {
    %>
    <div class="blog-post <%= post.getUsername().equals(username) ? "current-user" : "" %>">
        <h2><%= post.getTitle() %></h2>
        <p><%= post.getContent() %></p>
        <span class="toggle"></span>
        <% if (post.getUsername().equals(username)) { %>
        <div class="actions">
            <button onclick="location.href='/edit-blog?id=<%= post.getId() %>'">编辑</button>
            <form action="/delete-blog" method="post" style="display:inline;">
                <input type="hidden" name="id" value="<%= post.getId() %>">
                <button type="submit">删除</button>
            </form>
        </div>
        <% } %>
        <small>由 <strong><%= post.getUsername() %></strong> 于 <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(post.getCreatedAt()) %> 发布</small>
    </div>
    <%
        }
    %>
</div>
</body>
</html>
