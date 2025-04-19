<%-- 
    Document   : error
    Created on : 19 Apr, 2025, 11:58:52 AM
    Author     : lapto
--%>
<%@ page isErrorPage="true" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Error | Vegayan</title>
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .error-box {
                max-width: 600px;
                margin: 100px auto;
                text-align: center;
                padding: 40px;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .error-box h1 {
                font-size: 3rem;
                color: #dc3545;
            }
        </style>
    </head>
    <body>
        <div class="error-box">
            <h1>Oops!</h1>
            <p>Something went wrong. Please try again later.</p>
            <p><a href="login.jsp" class="btn btn-primary mt-3">Return to Login</a></p>

        </div>
    </body>
</html>
