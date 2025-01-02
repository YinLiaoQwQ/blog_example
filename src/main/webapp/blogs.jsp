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
<%--    <link rel="stylesheet" href="css/blogs_styles.css">--%>
    <style>
        /* 通用样式 */
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

        .settings:hover .settings-menu,
        .settings-menu:hover {
            display: block;
            opacity: 1;
            visibility: visible;
        }

        /* 延长菜单悬停时间 */
        .settings:hover .settings-menu {
            animation: stay-visible 1.5s forwards;
        }

        @keyframes stay-visible {
            from {
                opacity: 1;
                visibility: visible;
            }
            to {
                opacity: 1;
                visibility: visible;
            }
        }

        h1 {
            color: #3f51b5;
            text-align: left;
            margin: 20px 0;
            font-size: 2rem;
        }

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
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .filter-bar .filter-section select:hover {
            border-color: #3f51b5;
            box-shadow: 0 0 5px rgba(63, 81, 181, 0.3);
        }

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

        /*.blog-post p {*/
        /*    margin: 5px 0 15px 0;*/
        /*    color: #555;*/
        /*    line-height: 1.6;*/
        /*    overflow: hidden;*/
        /*    text-overflow: ellipsis;*/
        /*    white-space: nowrap;*/
        /*}*/

        .blog-post .toggle {
            position: absolute;
            bottom: 20px;
            right: 20px;
            font-size: 0.9rem;
            color: #888;
            cursor: pointer;
            padding: 2px 6px;
            border: 1px solid #ccc;
            border-radius: 3px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .blog-post .toggle:hover {
            background-color: #3f51b5;
            color: #fff;
        }

        .blog-post .actions {
            margin-top: 10px;
            display: flex;
            gap: 10px;
        }

        .blog-post .actions button {
            padding: 5px 15px;
            font-size: 0.9rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, box-shadow 0.2s ease;
            color: #fff;
            font-weight: bold;
        }

        /* 编辑按钮样式 */
        .blog-post .actions .edit-btn {
            background-color: #64b5f6;
        }

        .blog-post .actions .edit-btn:hover {
            background-color: #42a5f5;
            box-shadow: 0 4px 8px rgba(66, 165, 245, 0.3);
        }

        /* 删除按钮样式 */
        .blog-post .actions .delete-btn {
            background-color: #e57373;
        }

        .blog-post .actions .delete-btn:hover {
            background-color: #ef5350;
            box-shadow: 0 4px 8px rgba(239, 83, 80, 0.3);
        }

        .blog-post.current-user h2 {
            color: #388e3c;
        }

        .blog-post.current-user small {
            color: #4caf50;
        }

        .no-content {
            text-align: center;
            color: #999;
            font-size: 1.2em;
            margin: 50px 0;
        }

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

        .settings:hover .settings-menu,
        .settings-menu:hover {
            display: block;
            opacity: 1;
            visibility: visible;
        }

        /* 延长菜单悬停时间 */
        .settings:hover .settings-menu {
            animation: stay-visible 1.5s forwards;
        }

        @keyframes stay-visible {
            from {
                opacity: 1;
                visibility: visible;
            }
            to {
                opacity: 1;
                visibility: visible;
            }
        }

        h1 {
            color: #3f51b5;
            text-align: left;
            margin: 20px 0;
            font-size: 2rem;
        }

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
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .filter-bar .filter-section select:hover {
            border-color: #3f51b5;
            box-shadow: 0 0 5px rgba(63, 81, 181, 0.3);
        }

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

        /*.blog-post p {*/
        /*    margin: 5px 0 15px 0;*/
        /*    color: #555;*/
        /*    line-height: 1.6;*/
        /*    overflow: hidden;*/
        /*    text-overflow: ellipsis;*/
        /*    white-space: nowrap;*/
        /*}*/

        .blog-post .toggle {
            position: absolute;
            bottom: 20px;
            right: 20px;
            font-size: 0.9rem;
            color: #888;
            cursor: pointer;
            padding: 2px 6px;
            border: 1px solid #ccc;
            border-radius: 3px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .blog-post .toggle:hover {
            background-color: #3f51b5;
            color: #fff;
        }

        .blog-post .actions {
            margin-top: 10px;
            display: flex;
            gap: 10px;
        }

        .blog-post .actions button {
            padding: 5px 15px;
            font-size: 0.9rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, box-shadow 0.2s ease;
            color: #fff;
            font-weight: bold;
        }

        /* 编辑按钮样式 */
        .blog-post .actions .edit-btn {
            background-color: #64b5f6;
        }

        .blog-post .actions .edit-btn:hover {
            background-color: #42a5f5;
            box-shadow: 0 4px 8px rgba(66, 165, 245, 0.3);
        }

        /* 删除按钮样式 */
        .blog-post .actions .delete-btn {
            background-color: #e57373;
        }

        .blog-post .actions .delete-btn:hover {
            background-color: #ef5350;
            box-shadow: 0 4px 8px rgba(239, 83, 80, 0.3);
        }

        .blog-post.current-user h2 {
            color: #388e3c;
        }

        .blog-post.current-user small {
            color: #4caf50;
        }

        .no-content {
            text-align: center;
            color: #999;
            font-size: 1.2em;
            margin: 50px 0;
        }

        /* 颜色主题定义 */
        :root {
            --background-gradient-start: #a8e063;
            --background-gradient-end: #56ab2f;
            --text-color: #333333; /* 浅色模式下的主文本颜色 */
            --header-bg: rgba(255, 255, 255, 0.8);
            --header-text-color: #333333;
            --form-bg: rgba(255, 255, 255, 0.85);
            --form-text-color: #333333;
            --button-bg: #3f51b5;
            --button-hover-bg: #5c6bc0;
            --toggle-bg: #333333;
            --toggle-color: #ffffff; /* 浅色模式下的切换按钮颜色 */
            --blur-amount: 10px; /* 模糊量 */
            --overlay-bg: rgba(255, 255, 255, 0.6); /* 覆盖层透明度 */
            --toggle-icon-light: "🌙";
            --toggle-icon-dark: "☀️";
            --gradient-mask: linear-gradient(to bottom, rgba(255, 255, 255, 0), rgba(255, 255, 255, 1));
        }

        [data-theme="dark"] {
            --background-gradient-start: #2c3e50;
            --background-gradient-end: #4ca1af;
            --text-color: #ecf0f1; /* 深色模式下的主文本颜色 */
            --header-bg: rgba(44, 62, 80, 0.9);
            --header-text-color: #ecf0f1;
            --form-bg: rgba(44, 62, 80, 0.9);
            --form-text-color: #ecf0f1;
            --button-bg: #2980b9;
            --button-hover-bg: #3498db;
            --toggle-bg: #ecf0f1;
            --toggle-color: #333333; /* 深色模式下的切换按钮颜色 */
            --blur-amount: 10px;
            --overlay-bg: rgba(44, 62, 80, 0.6); /* 调整覆盖层透明度 */
            --toggle-icon-light: "🌙";
            --toggle-icon-dark: "☀️";
            --gradient-mask: linear-gradient(to bottom, rgba(44, 62, 80, 0), rgba(44, 62, 80, 1));
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

        header .welcome {
            display: flex;
            align-items: center;
            font-size: 1rem;
            color: var(--header-text-color);
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
            color: var(--text-color);
            background: var(--form-bg);
            overflow-wrap: break-word; /* 确保长单词自动换行 */
            word-break: break-all; /* 允许在任何地方断行 */
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
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
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

        /* 内容折叠与展开样式 */
        .blog-post .content {
            color: var(--text-color);
            transition: max-height 0.3s ease, white-space 0.3s ease, text-overflow 0.3s ease;
            overflow: hidden;
            max-height: 100px; /* 默认显示高度 */
            position: relative;
            overflow-wrap: break-word; /* 确保长单词自动换行 */
            word-break: break-all; /* 允许在任何地方断行 */
            white-space: normal; /* 默认允许换行 */
        }

        .blog-post .content.collapsed {
            max-height: 100px;
            overflow: hidden;
            position: relative;
            /* 添加渐变遮罩以提示有更多内容 */
            background: linear-gradient(to bottom, rgba(255, 255, 255, 0), var(--form-bg) 80%);
        }

        .blog-post .content.collapsed.single-line {
            white-space: nowrap;
            text-overflow: ellipsis;
            background: none; /* 移除渐变遮罩 */
        }

        .blog-post .content.expanded {
            max-height: none; /* 展开时不限制高度 */
            white-space: normal; /* 恢复换行 */
            background: none; /* 移除渐变遮罩 */
        }

        /* 确保所有子元素继承颜色并允许换行 */
        .blog-post .content * {
            color: inherit;
            background: transparent;
            overflow-wrap: break-word;
            word-break: break-all;
        }

        .blog-post .content img {
            max-width: 100%;
            height: auto;
            display: block;
        }

        /* “展开”按钮样式 */
        .blog-post .toggle {
            display: none; /* 默认隐藏 */
            margin-top: 10px;
            color: #3f51b5;
            cursor: pointer;
            font-weight: bold;
            user-select: none;
            transition: color 0.3s ease;
            background: none;
            border: none;
            padding: 0;
            font-size: 1rem;
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
            color: #fff; /* 确保按钮文字颜色在深色模式下可见 */
        }

        .blog-post .edit-btn {
            background-color: #ffc107;
        }

        .blog-post .edit-btn:hover {
            background-color: #ffb300;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }

        .blog-post .delete-btn {
            background-color: #dc3545;
        }

        .blog-post .delete-btn:hover {
            background-color: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.2);
        }

        .blog-post small {
            display: block;
            margin-top: 10px;
            color: #777777;
        }

        /* 无内容提示 */
        .no-content {
            text-align: center;
            color: #777777;
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
            font-size: 1.2rem;
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

        /* 深色模式下的博客内容和切换按钮 */
        [data-theme="dark"] .blog-post .content.collapsed {
            background: linear-gradient(to bottom, rgba(44, 62, 80, 0), rgba(44, 62, 80, 0.9) 80%);
        }

        [data-theme="dark"] .blog-post .toggle {
            color: var(--toggle-color);
        }

        [data-theme="dark"] .blog-post .toggle:hover {
            color: #bdc3c7;
        }

        /* 深色模式下的其他元素颜色调整 */
        [data-theme="dark"] .blog-post h2 {
            color: var(--text-color);
        }

        [data-theme="dark"] .blog-post .actions button {
            color: #ffffff;
        }

        [data-theme="dark"] .blog-post .actions .edit-btn {
            background-color: #e0a800;
        }

        [data-theme="dark"] .blog-post .actions .delete-btn {
            background-color: #c82333;
        }

        /* 调整其他需要在深色模式下改变颜色的元素 */
        [data-theme="dark"] .filter-bar h1 {
            color: var(--text-color);
        }

        [data-theme="dark"] .filter-bar input[type="text"] {
            background-color: rgba(255, 255, 255, 0.2);
            color: var(--text-color);
            border: 1px solid #555555;
        }

        [data-theme="dark"] .filter-bar input[type="text"]::placeholder {
            color: #dddddd;
        }

        [data-theme="dark"] .filter-bar button {
            background-color: #2980b9;
        }
    </style>
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
