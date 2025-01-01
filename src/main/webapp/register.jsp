<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>博客系统 - 注册</title>
  <style>
    /* 页面整体样式 */
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      margin: 0;
      padding: 0;
      /* 动态彩色渐变背景 */
      background: linear-gradient(135deg, #a8e063, #56ab2f, #a8e063, #56ab2f);
      background-size: 600% 600%;
      animation: GradientAnimation 15s ease infinite;
      color: #333;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      position: relative;
    }

    /* 动态渐变动画 */
    @keyframes GradientAnimation {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    /* 高斯模糊效果的背景层 */
    .background-blur {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      background: rgba(255, 255, 255, 0.2);
      z-index: 1;
    }

    /* 容器样式 */
    .container {
      position: relative;
      z-index: 2;
      text-align: center;
      background-color: rgba(255, 255, 255, 0.85); /* 半透明背景 */
      padding: 40px 50px;
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3); /* 阴影效果 */
      width: 90%;
      max-width: 400px;
      animation: slideIn 1s ease-in-out;
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
      color: #43a047;
      margin-bottom: 20px;
      font-size: 2rem;
      font-weight: bold;
      text-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); /* 添加文字阴影 */
    }

    /* 表单标签样式 */
    label {
      font-size: 1.1em;
      color: #555;
      display: block;
      text-align: left;
      margin-bottom: 8px;
    }

    /* 输入框样式 */
    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 12px;
      margin-bottom: 15px;
      border: 1px solid #ddd;
      border-radius: 5px;
      box-sizing: border-box;
      font-size: 1rem;
      transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    input[type="text"]:focus, input[type="password"]:focus {
      border-color: #43a047;
      box-shadow: 0 0 8px rgba(67, 160, 71, 0.3);
      outline: none;
    }

    /* 密码强度指示器样式 */
    .password-strength {
      height: 10px;
      width: 100%;
      background-color: #ddd;
      border-radius: 5px;
      margin-bottom: 15px;
      overflow: hidden;
    }

    .password-strength-bar {
      height: 100%;
      width: 0;
      transition: width 0.3s ease, background-color 0.3s ease;
    }

    /* 按钮样式 */
    button {
      width: 100%;
      padding: 12px;
      font-size: 1rem;
      font-weight: bold;
      background: #56ab2f;
      color: #fff;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      text-transform: uppercase;
      transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
    }

    button:hover {
      background: linear-gradient(to right, #56ab2f, #a8e063); /* 按钮悬停效果 */
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(86, 171, 47, 0.3);
    }

    button:active {
      transform: translateY(1px);
      box-shadow: 0 2px 8px rgba(86, 171, 47, 0.2);
    }

    /* 返回链接样式 */
    .back-link {
      display: inline-block;
      margin-top: 20px;
      color: #43a047;
      text-decoration: none;
      font-size: 0.9rem;
      font-weight: bold;
      transition: color 0.3s ease;
    }

    .back-link:hover {
      color: #388e3c;
      text-decoration: underline;
    }

    /* 错误信息样式 */
    .error-message {
      color: #dc3545;
      font-size: 0.9rem;
      margin-bottom: 15px;
      text-align: left;
    }

    /* 滑动验证样式 */
    .slider-container {
      position: relative;
      width: 100%;
      height: 50px;
      background-color: #ddd;
      border-radius: 25px;
      overflow: hidden;
      margin-bottom: 15px;
    }

    .slider-track {
      position: absolute;
      top: 0;
      left: 0;
      height: 100%;
      width: 0;
      background-color: #43a047;
      transition: width 0.3s ease;
    }

    .slider-button {
      position: absolute;
      top: 0;
      left: 0;
      width: 50px;
      height: 50px;
      background-color: #fff;
      border: 2px solid #43a047;
      border-radius: 50%;
      cursor: pointer;
      transition: background-color 0.3s ease, transform 0.2s ease;
    }

    .slider-button:active {
      transform: scale(1.1);
    }

    .slider-button.dragging {
      background-color: #e0e0e0;
    }

    .slider-text {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: #555;
      font-weight: bold;
      pointer-events: none;
      transition: color 0.3s ease;
    }

    .slider-container.verified .slider-track {
      width: 100%;
    }

    .slider-container.verified .slider-button {
      left: calc(100% - 50px);
      background-color: #43a047;
      border-color: #43a047;
      cursor: default;
    }

    .slider-container.verified .slider-text {
      color: #43a047;
    }

    /* 响应式优化 */
    @media (max-width: 600px) {
      .container {
        padding: 30px 20px;
      }

      h1 {
        font-size: 1.8rem;
      }
    }
  </style>
</head>
<body>
<!-- 高斯模糊背景层 -->
<div class="background-blur"></div>

<div class="container">
  <h1>注册账号</h1>
  <form id="registerForm" action="register" method="post" onsubmit="return validateForm();">
    <!-- 显示错误信息 -->
    <div id="errorMessage" class="error-message" style="display: none;"></div>

    <label for="username">用户名:</label>
    <input type="text" id="username" name="username" placeholder="请输入您的用户名" required>

    <label for="password">密码:</label>
    <input type="password" id="password" name="password" placeholder="请输入您的密码" required>

    <!-- 密码强度指示器 -->
    <div class="password-strength">
      <div id="passwordStrengthBar" class="password-strength-bar"></div>
    </div>

    <!-- 滑动验证 -->
    <div class="slider-container" id="sliderContainer">
      <div class="slider-track" id="sliderTrack"></div>
      <div class="slider-button" id="sliderButton"></div>
      <div class="slider-text" id="sliderText">滑动验证</div>
    </div>
    <input type="hidden" id="sliderVerified" name="sliderVerified" value="false">

    <button type="submit">注册</button>
  </form>
  <p>已有账号？<a class="back-link" href="login.jsp">点击登录</a></p>
</div>

<!-- JavaScript 部分 -->
<script>
  // 密码强度评估函数
  function evaluatePasswordStrength(password) {
    let strength = 0;

    if (password.length >= 8) strength += 1;
    if (/[A-Z]/.test(password)) strength += 1;
    if (/[a-z]/.test(password)) strength += 1;
    if (/[0-9]/.test(password)) strength += 1;
    if (/[^A-Za-z0-9]/.test(password)) strength += 1;

    return strength;
  }

  // 更新密码强度指示器
  function updatePasswordStrength() {
    const password = document.getElementById('password').value;
    const strength = evaluatePasswordStrength(password);
    const strengthBar = document.getElementById('passwordStrengthBar');

    switch(strength) {
      case 0:
      case 1:
        strengthBar.style.width = '20%';
        strengthBar.style.backgroundColor = '#dc3545'; // 红色
        break;
      case 2:
      case 3:
        strengthBar.style.width = '60%';
        strengthBar.style.backgroundColor = '#ffc107'; // 黄色
        break;
      case 4:
      case 5:
        strengthBar.style.width = '100%';
        strengthBar.style.backgroundColor = '#28a745'; // 绿色
        break;
    }
  }

  // 表单验证函数
  function validateForm() {
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value;
    const sliderVerified = document.getElementById('sliderVerified').value;
    const errorMessage = document.getElementById('errorMessage');

    // 清除之前的错误信息
    errorMessage.style.display = 'none';
    errorMessage.innerText = '';

    // 用户名合法性校验（例如，至少3个字符，只允许字母和数字）
    const usernameRegex = /^[A-Za-z0-9]{3,}$/;
    if (!usernameRegex.test(username)) {
      errorMessage.innerText = '用户名至少包含3个字母或数字，且不包含特殊字符。';
      errorMessage.style.display = 'block';
      return false;
    }

    // 密码合法性校验
    if (password.length < 8) {
      errorMessage.innerText = '密码长度至少为8个字符。';
      errorMessage.style.display = 'block';
      return false;
    }

    // 验证密码强度
    const strength = evaluatePasswordStrength(password);
    if (strength < 3) {
      errorMessage.innerText = '密码强度过低，请使用大小写字母、数字和特殊字符。';
      errorMessage.style.display = 'block';
      return false;
    }

    // 验证滑动验证
    if (sliderVerified !== 'true') {
      errorMessage.innerText = '请完成滑动验证。';
      errorMessage.style.display = 'block';
      return false;
    }

    return true;
  }

  // 监听密码输入事件，实时更新密码强度
  document.getElementById('password').addEventListener('input', updatePasswordStrength);

  // 滑动验证功能
  (function() {
    const sliderContainer = document.getElementById('sliderContainer');
    const sliderButton = document.getElementById('sliderButton');
    const sliderTrack = document.getElementById('sliderTrack');
    const sliderText = document.getElementById('sliderText');
    const sliderVerified = document.getElementById('sliderVerified');

    let isDragging = false;
    let startX;
    let currentX;
    const containerWidth = sliderContainer.offsetWidth;
    const buttonWidth = sliderButton.offsetWidth;
    const maxMove = containerWidth - buttonWidth - 2; // 2px for border

    sliderButton.addEventListener('mousedown', function(e) {
      if (sliderContainer.classList.contains('verified')) return;
      isDragging = true;
      startX = e.clientX;
      sliderButton.classList.add('dragging');
    });

    document.addEventListener('mousemove', function(e) {
      if (!isDragging) return;
      e.preventDefault();
      currentX = e.clientX - startX;
      if (currentX > maxMove) currentX = maxMove;
      if (currentX < 0) currentX = 0;
      sliderButton.style.left = currentX + 'px';
      sliderTrack.style.width = (currentX + buttonWidth / 2) + 'px';
    });

    document.addEventListener('mouseup', function(e) {
      if (!isDragging) return;
      isDragging = false;
      sliderButton.classList.remove('dragging');
      if (currentX >= maxMove * 0.95) { // 95% to account for slight inaccuracies
        sliderContainer.classList.add('verified');
        sliderButton.style.left = maxMove + 'px';
        sliderTrack.style.width = (maxMove + buttonWidth / 2) + 'px';
        sliderText.innerText = '验证通过';
        sliderVerified.value = 'true';
      } else {
        // Reset slider
        sliderButton.style.left = '0px';
        sliderTrack.style.width = '0px';
      }
    });

    // Touch events for mobile compatibility
    sliderButton.addEventListener('touchstart', function(e) {
      if (sliderContainer.classList.contains('verified')) return;
      isDragging = true;
      startX = e.touches[0].clientX;
      sliderButton.classList.add('dragging');
    });

    document.addEventListener('touchmove', function(e) {
      if (!isDragging) return;
      e.preventDefault();
      currentX = e.touches[0].clientX - startX;
      if (currentX > maxMove) currentX = maxMove;
      if (currentX < 0) currentX = 0;
      sliderButton.style.left = currentX + 'px';
      sliderTrack.style.width = (currentX + buttonWidth / 2) + 'px';
    }, { passive: false });

    document.addEventListener('touchend', function(e) {
      if (!isDragging) return;
      isDragging = false;
      sliderButton.classList.remove('dragging');
      if (currentX >= maxMove * 0.95) { // 95% to account for slight inaccuracies
        sliderContainer.classList.add('verified');
        sliderButton.style.left = maxMove + 'px';
        sliderTrack.style.width = (maxMove + buttonWidth / 2) + 'px';
        sliderText.innerText = '验证通过';
        sliderVerified.value = 'true';
      } else {
        // Reset slider
        sliderButton.style.left = '0px';
        sliderTrack.style.width = '0px';
      }
    });
  })();
</script>
</body>
</html>
