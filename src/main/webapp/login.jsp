<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>博客系统 - 登录</title>
  <style>
    /* 页面整体样式 */
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      margin: 0;
      padding: 0;
      background: linear-gradient(135deg, #74ebd5, #9face6); /* 背景渐变 */
      color: #333;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      animation: fadeIn 1.2s ease-in-out; /* 页面淡入效果 */
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: scale(0.95);
      }
      to {
        opacity: 1;
        transform: scale(1);
      }
    }

    /* 表单容器 */
    .form-container {
      width: 100%;
      max-width: 400px;
      background: rgba(255, 255, 255, 0.3); /* 半透明背景 */
      backdrop-filter: blur(8px);           /* 高斯模糊 */
      -webkit-backdrop-filter: blur(8px);   /* 兼容 Safari */
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
      text-align: center;
      animation: slideIn 1s ease-out; /* 容器滑入效果 */
    }

    @keyframes slideIn {
      from {
        transform: translateY(-20px);
        opacity: 0;
      }
      to {
        transform: translateY(0);
        opacity: 1;
      }
    }

    /* 标题样式 */
    h1 {
      text-align: center;
      color: #333;
      font-size: 2rem;
      margin-bottom: 20px;
      font-weight: bold;
    }

    /* 标签和输入框外层容器，用来居中对齐 */
    .input-group {
      text-align: left;
      margin: 0 auto 20px auto;
      max-width: 300px; /* 控制输入框整体区域宽度 */
    }

    /* 标签样式 */
    label {
      font-weight: bold;
      display: block;
      margin-bottom: 5px;
      color: #555;
    }

    /* 输入框样式 */
    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 16px;
      transition: border-color 0.3s ease, box-shadow 0.3s ease;
      margin-bottom: 15px;
      box-sizing: border-box;
    }

    input[type="text"]:focus, input[type="password"]:focus {
      border-color: #2196F3;
      box-shadow: 0 0 8px rgba(33, 150, 243, 0.3);
      outline: none;
    }

    /* 按钮样式 */
    button {
      width: 70%;
      padding: 12px;
      background: #2196F3;
      color: #fff;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      cursor: pointer;
      font-weight: bold;
      text-transform: uppercase;
      transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
    }

    button:hover {
      background: #1976D2;
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(33, 150, 243, 0.4);
    }

    /* 错误信息样式 */
    .error-message {
      color: #D8000C;
      background-color: #FFD2D2;
      padding: 12px;
      border-radius: 5px;
      margin-bottom: 20px;
      text-align: center;
      font-size: 14px;
      box-shadow: 0 4px 8px rgba(216, 0, 12, 0.2);
    }

    /* 注册链接样式 */
    .register-link {
      text-align: center;
      margin-top: 20px;
      font-size: 14px;
    }

    .register-link a {
      text-decoration: none;
      color: #2196F3;
      font-weight: bold;
      transition: color 0.3s ease;
    }

    .register-link a:hover {
      color: #1976D2;
      text-decoration: underline;
    }

    /* 滑动验证码样式 */
    .captcha-container {
      margin: 20px auto;
      max-width: 300px;
      position: relative;
      user-select: none;
    }

    .captcha-track {
      width: 100%;
      height: 40px;
      background-color: #f0f0f0;
      border-radius: 5px;
      position: relative;
      overflow: hidden;
      border: 1px solid #ddd;
    }

    .captcha-slider {
      width: 40px;
      height: 100%;
      background-color: #2196F3;
      border-radius: 5px;
      position: absolute;
      top: 0;
      left: 0;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }

    .captcha-slider:hover {
      background-color: #1976D2;
    }

    .captcha-text {
      position: absolute;
      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      color: #555;
      font-size: 14px;
      pointer-events: none;
    }

    .captcha-success {
      background-color: #4CAF50 !important;
    }

    /* 禁用选择文本 */
    .captcha-container, .captcha-track, .captcha-slider, .captcha-text {
      -webkit-user-select: none; /* Safari */
      -ms-user-select: none; /* IE 10+/Edge */
      user-select: none; /* Standard */
    }

    /* 适配移动设备的触摸事件 */
    @media (max-width: 600px) {
      .form-container {
        padding: 30px 20px;
      }

      h1 {
        font-size: 1.8rem;
      }

      .input-group {
        max-width: 100%;
      }

      .captcha-container {
        max-width: 100%;
      }

      button {
        width: 100%;
      }
    }
  </style>
</head>
<body>
<div class="form-container">
  <h1>登录</h1>
  <!-- 如果后端传递了错误信息，则在页面中显示 -->
  <% if (request.getAttribute("errorMessage") != null) { %>
  <div class="error-message">
    <%= request.getAttribute("errorMessage") %>
  </div>
  <% } %>

  <!-- 表单开始 -->
  <form id="loginForm" action="login" method="post" novalidate>
    <!-- 用户名输入框组 -->
    <div class="input-group">
      <label for="username">账号:</label>
      <!-- pattern 仅作前端简单校验(英文数字6-16位)，可根据需要自定义 -->
      <input
              type="text"
              id="username"
              name="username"
              placeholder="请输入您的账号"
              pattern="[A-Za-z0-9_]{6,16}"
              title="账号应由6-16位的英文、数字或下划线组成"
              required>
    </div>

    <!-- 密码输入框组 -->
    <div class="input-group">
      <label for="password">密码:</label>
      <!-- pattern 示例：至少8位，可根据需要自定义规则 -->
      <input
              type="password"
              id="password"
              name="password"
              placeholder="请输入您的密码"
              pattern=".{8,}"
              title="密码至少需要8位"
              required>
    </div>

    <!-- 滑动验证码 -->
    <div class="captcha-container">
      <div class="captcha-track" id="captchaTrack">
        <div class="captcha-slider" id="captchaSlider"></div>
        <div class="captcha-text" id="captchaText">请滑动验证</div>
      </div>
    </div>

    <!-- 隐藏输入以标记验证码是否通过 -->
    <input type="hidden" id="captchaPassed" name="captchaPassed" value="false">

    <button type="submit" id="submitBtn" disabled>登录</button>
  </form>
  <!-- 表单结束 -->

  <div class="register-link">
    <p>还没有账号？<a href="register.jsp">立即注册</a></p>
  </div>
</div>

<!-- 滑动验证码脚本 -->
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const slider = document.getElementById('captchaSlider');
    const track = document.getElementById('captchaTrack');
    const text = document.getElementById('captchaText');
    const submitBtn = document.getElementById('submitBtn');
    const captchaPassedInput = document.getElementById('captchaPassed');

    let isDragging = false;
    let startX = 0;
    let startLeft = 0;
    let maxMove = 0;

    // 计算滑动的最大距离
    function calculateMaxMove() {
      maxMove = track.offsetWidth - slider.offsetWidth;
    }

    window.addEventListener('resize', calculateMaxMove);
    calculateMaxMove();

    // 鼠标事件
    slider.addEventListener('mousedown', startDrag);
    document.addEventListener('mousemove', duringDrag);
    document.addEventListener('mouseup', endDrag);

    // 触摸事件
    slider.addEventListener('touchstart', startDrag, {passive: false});
    document.addEventListener('touchmove', duringDrag, {passive: false});
    document.addEventListener('touchend', endDrag);

    function startDrag(e) {
      if (submitBtn.disabled === false) { // 如果已经通过，不允许再次拖动
        return;
      }
      isDragging = true;
      startX = getClientX(e);
      startLeft = slider.offsetLeft;
      slider.style.transition = 'none';
      e.preventDefault();
    }

    function duringDrag(e) {
      if (!isDragging) return;
      const currentX = getClientX(e);
      let deltaX = currentX - startX;
      let newLeft = startLeft + deltaX;

      if (newLeft < 0) newLeft = 0;
      if (newLeft > maxMove) newLeft = maxMove;

      slider.style.left = newLeft + 'px';
      e.preventDefault();
    }

    function endDrag(e) {
      if (!isDragging) return;
      isDragging = false;
      const finalLeft = slider.offsetLeft;
      const threshold = maxMove - 10; // 允许误差10px

      if (finalLeft >= threshold) { // 通过验证
        slider.style.left = maxMove + 'px';
        slider.classList.add('captcha-success');
        text.textContent = '验证通过';
        submitBtn.disabled = false;
        captchaPassedInput.value = 'true';
      } else { // 重置
        slider.style.transition = 'left 0.5s ease';
        slider.style.left = '0px';
      }
    }

    function getClientX(e) {
      if (e.touches && e.touches.length > 0) {
        return e.touches[0].clientX;
      } else {
        return e.clientX;
      }
    }

    // 重置滑动验证码功能（可选）
    function resetCaptcha() {
      slider.style.transition = 'left 0.5s ease';
      slider.style.left = '0px';
      slider.classList.remove('captcha-success');
      text.textContent = '请滑动验证';
      submitBtn.disabled = true;
      captchaPassedInput.value = 'false';
    }

    // 如果需要重置验证码，可以在此调用 resetCaptcha()
    // 例如，在表单提交后或其他条件下
  });
</script>
</body>
</html>
