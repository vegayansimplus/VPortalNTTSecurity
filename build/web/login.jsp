<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Security Headers
    response.setHeader("X-Content-Type-Options", "nosniff");
    response.setHeader("X-XSS-Protection", "1; mode=block");
    response.setHeader("X-Frame-Options", "SAMEORIGIN");
    response.setHeader("Content-Security-Policy",
        "default-src 'self'; " +
        "script-src 'self' 'unsafe-inline'; " +
        "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; " +
        "font-src 'self' https://fonts.gstatic.com;");
    response.setHeader("Referrer-Policy", "no-referrer");
    response.setHeader("Permissions-Policy", "geolocation=(), microphone=()");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setDateHeader("Expires", 0);

    Logger loginLogger = Logger.getLogger("SecurityLogger");
    loginLogger.info("Login page accessed from IP: " + request.getRemoteAddr());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login | Vegayan</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="assets/images/vsicon.png" type="image/x-icon" />
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/icons.min.css">
    <link rel="stylesheet" href="assets/css/app.min.css">
    <script src="assets/js/jquery-3.3.1.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <style>
        .auth-container {
            max-width: 400px;
            margin: 60px auto;
            padding: 30px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
        }
        .auth-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        canvas#captcha {
            background: #f2f2f2;
            border-radius: 5px;
            padding: 5px;
        }
        .errorcaptch {
            margin-top: 1rem;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <h2>Login</h2>
        <form action="Login" method="post" autocomplete="off" id="loginform">
            <div class="mb-3">
                <label for="username">Username</label>
                <input type="text" class="form-control" id="username" name="username"
                       placeholder="Enter username" required minlength="3" maxlength="30"
                       pattern="[a-zA-Z0-9._-]+" title="Only alphanumeric characters, dots, underscores, and hyphens are allowed" />
            </div>

            <div class="mb-3">
                <label for="password">Password</label>
                <div class="input-group">
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Enter password" required minlength="6" autocomplete="off" />
                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword();">
                        <i class="ic-password"></i>
                    </button>
                </div>
            </div>

            <div class="mb-3">
                <label>Captcha</label>
                <div class="input-group">
                    <canvas id="captcha" width="130" height="40" class="form-control border-0" style="height:40px;"></canvas>
                    <button class="btn btn-outline-secondary" id="refreshButton" type="button">
                        <img src="assets/images/arrows-rotate-solid.svg" style="height:20px;" alt="Refresh" />
                    </button>
                </div>
            </div>

            <div class="mb-3">
                <label for="textBox">Enter Captcha</label>
                <input class="form-control" type="text" id="textBox" placeholder="Enter Captcha" autocomplete="off" required />
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-primary">Log In</button>
            </div>
            <div class="errorcaptch text-danger"></div>
        </form>

        <% String error = request.getParameter("error");
            if (error != null) {
                loginLogger.warning("Failed login attempt from IP: " + request.getRemoteAddr());
        %>
        <div class="alert alert-danger mt-3">Invalid credentials. Please try again.</div>
        <% } %>
    </div>

    <script>
        let captchaCode = "";

        function generateCaptcha() {
            const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            captchaCode = "";
            for (let i = 0; i < 6; i++) {
                captchaCode += chars.charAt(Math.floor(Math.random() * chars.length));
            }

            const canvas = document.getElementById("captcha");
            const ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.font = "30px Arial";
            ctx.fillStyle = "#000";
            ctx.fillText(captchaCode, 10, 30);
        }

        function togglePassword() {
            const pwd = document.getElementById("password");
            pwd.type = pwd.type === "password" ? "text" : "password";
        }

        function disableBack() {
            window.history.forward();
        }

        document.addEventListener("DOMContentLoaded", function () {
            generateCaptcha();

            document.getElementById("refreshButton").addEventListener("click", function () {
                generateCaptcha();
            });

            document.getElementById("loginform").addEventListener("submit", function (e) {
                const userText = document.getElementById("textBox").value.trim();
                if (userText !== captchaCode) {
                    e.preventDefault();
                    document.querySelector(".errorcaptch").innerHTML = "Incorrect Captcha, please try again.";
                    generateCaptcha();
                }
            });
        });

        window.onload = disableBack;
        window.onpageshow = function (evt) {
            if (evt.persisted) disableBack();
        };
    </script>
</body>
</html>
