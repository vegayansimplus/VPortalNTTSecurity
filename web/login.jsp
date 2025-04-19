<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Security Headers - A05
    response.setHeader("X-Content-Type-Options", "nosniff");
    response.setHeader("X-XSS-Protection", "1; mode=block");
    response.setHeader("X-Frame-Options", "SAMEORIGIN");
    response.setHeader("Content-Security-Policy", "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:;");
    response.setHeader("Referrer-Policy", "no-referrer");
    response.setHeader("Permissions-Policy", "geolocation=(), microphone=()");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setDateHeader("Expires", 0);

    // Logger setup
    Logger loginLogger = Logger.getLogger("SecurityLogger");

    // Log login page access
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
        <script src="assets/js/jquery-3.6.0.min.js"></script>
        <script src="assets/lib/bootstrap/bootstrap.bundle.min.js"></script>
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
             .captchaDiv{
                border: 1px solid #e5e5e5;
                height: 3rem;
                padding: 0.2rem;
                background: #f2f2f2;
                text-align: center;
                border-radius: 0.5rem;
            }
            .captchaInput{
                padding:0;
                margin-top:1rem;
            }
        </style>
    </head>
    <body onload="disableBack();">
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
                               placeholder="Enter password" required minlength="6" />
                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword();">
                            <i class="ic-password"></i>
                        </button>
                    </div>
                </div>


                <div class="mb-3">
                    <div class="col-xs-12">
                        <div class="input-group">
                            <span class="form-control" style="height:55px;">
                                <canvas id="captcha">captcha text</canvas>
                            </span>
                            <div class="input-group-btn">
                                <button class="btn btn-default" id="refreshButton" type="button" style="height:5.4vh">
                                    <img src="assets/images/arrows-rotate-solid.svg"  style="height:2vh"/>
                                </button>
                            </div>
                        </div>

                    </div>
                </div>
                <div class=" mb-3">
                    <div class="col-xs-12">
                        <div class="input-group">
                            <input class="form-control" type="text"  placeholder="Enter Captcha" id="textBox" >
                            <div class="input-group-btn">
                                <button type="button" class="btn btn-default" style="height:5.4vh">
                                    <img src="assets/images/pass_icon.svg"  style="height:2vh"></i></button>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary" onclick="checkCaptcha()" > Log In</button>
                </div>
                <div class="errorcaptch"></div>
            </form>

            <%
                // Display error if any (without revealing internal details)
                String error = request.getParameter("error");
                if (error != null) {
                    loginLogger.warning("Failed login attempt from IP: " + request.getRemoteAddr());
            %>
            <div class="alert alert-danger mt-3">Invalid credentials. Please try again.</div>
            <% }%>
        </div>
        <script src="assets/js/captcha.js"></script>
        <script>
                        function togglePassword() {
                            const pwd = document.getElementById("password");
                            pwd.type = pwd.type === "password" ? "text" : "password";
                        }

                        function disableBack() {
                            window.history.forward();
                        }

                        window.onload = disableBack;
                        window.onpageshow = function (evt) {
                            if (evt.persisted)
                                disableBack();
                        };

                        function checkCaptcha() {
                            $("#loginform").submit();
                            if (userText.value === c) {
                                result = "correctCaptcha";
                                popup.classList.add("correctCaptcha");
                                console.log("captcha is matched");
                                $("#loginform").submit();

                            } else {
                                result = "incorrectCaptcha";
                                popup.classList.add("incorrectCaptcha");
                                popup.innerHTML = "Incorrect Captcha, please try again";
                                console.log("captcha is not matched");
                            }
                        }

        </script>
    </body>
</html>
