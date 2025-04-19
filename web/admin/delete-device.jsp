<%-- 
    Document   : delete-device
    Created on : 18 Apr, 2025, 3:41:24 PM
    Author     : lapto
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    response.setHeader("X-Content-Type-Options", "nosniff");
    response.setHeader("X-XSS-Protection", "1; mode=block");
    response.setHeader("X-Frame-Options", "SAMEORIGIN");
    response.setHeader("Content-Security-Policy", "script-src 'self';");
    response.setHeader("Content-Security-Policy", "frame-src 'self';"); 
%>
<%
    String USER = "";
    String user = "";
    String role = "";
    
    if (session == null) {
        response.sendRedirect("/VPortalNTT/login.jsp");
        return;
    } else {
        if (session.getAttribute("user") != null) {
            user = session.getAttribute("user").toString();
            role = session.getAttribute("role").toString();
        } else {
            response.sendRedirect("/VPortalNTT/login.jsp");
            return;
        }
    }
  
    USER = user.toUpperCase();

%>
<html>
    <head>
        <jsp:include page="../common/user-header.jsp"/>
        <jsp:include page="../common/CommonHeader.jsp"/>

        <title>Devices</title>
        <link rel="icon" href="../assets/images/vsicon.png" type="image/x-icon" />
        <link rel="stylesheet" href="../assets/css/font-awesome.min.css">


        <style>
            body{
                font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
                font-size: 12px;
                height: 100vh;
                width: 100vw;
                line-height: 1.42857143;
                position: relative;
                overflow: hidden;
            }
            .vega-btn{
                background: #990033;
                color: white;
                font-size: 12px;
                text-align: center;
                height: 25px;
                padding: 3px 10px;
                margin-top: 5px;
            }
            .vega-btn:hover{
                background: #990033;
                color: white;
                font-size: 12px;
                text-align: center;
                height: 25px;
                padding: 3px 10px;
                margin-top: 5px;
            }
            hr {
                margin-top: 0rem;
                margin-bottom: 5px;
                border: 0;
                margin-left: -9rem;
                border-top: 1px solid #eee;
            }
            .container {
                width:100%;
                height: 100rem;
            }
            thead {
                background-color: #990033;
                color: white;
            }
            table{
                margin: 0 auto;
                width: 100%;
                clear: both;
                border-collapse: collapse;
                word-wrap:break-word;
            }
            table.dataTable.compact thead th, table.dataTable.compact thead td {
                padding: 4px 17px 4px 4px;
                font-weight: 500;
                font-size: 12px;
                font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
            }
            table.dataTable tbody th, table.dataTable tbody td {
                padding: 0px 10px !important;
                font-size: 12px;
                white-space: nowrap;
            }
            button.dt-button, div.dt-button, a.dt-button{
                padding: 0.3em 0.8em;
            }
            .form-control {
                display: block;
                width: 100%;
                height: 28px;
                padding: 4px 12px;
                font-size: 12px;
                line-height: 1.42857143;
                color: #555;
                background-color: #fff;
                background-image: none;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
                -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
                transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
            }
            .overlay {
                position: fixed;
                display: none;
                width: 100%;
                height: 100%;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: rgba(250,250,250,.8);
                z-index: 1;
            }
            header#page-topbar {
                height: 1px;
            }
            .form-group {
                display: flex;
                flex-direction: row;
                justify-content: center;
                align-items: center;
            }
            .pageHeading{
                text-align: center;
                font-size: 14px;
                font-weight: 600;
                margin: 1vh;
                color:#000;
            }
            .ic-server {
                /* optional custom styling */
                color: #4CAF50;
                font-size: 20px;
            }
        </style>
    </head>
    <body data-sidebar="dark">
        <jsp:include page="../common/adminmenu.jsp"/>
        <div class="main-content">
            <div class="page-content">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <div  class="form-group col-md-3">
                                <label for="first-name" style="width: 5rem;">Group:</label>
                                <select class="form-control" id="distinctcity" onchange="getGroupwiseIP();" style="height:10px;display: inline-flex"></select>
                            </div>
                            <div  class="form-group col-md-3">
                                <label for="first-name" style="width: 6rem;">Node IP:</label>
                                <select class="form-control" id="nodeip"  style="height:10px;display: inline-flex"></select>
                            </div>
                            <div class="col-md-2">
                                <button id="getReport" class="btn vega-btn" onclick="deleteDevice();">Delete Device</button>
                            </div>
                        </div>
                    </div>



                </div>
            </div>
        </div>


        <jsp:include page="../common/user-footer.jsp"/>

        <script>
            var dataTableObject;
            $(document).ready(function () {
                $('.shrink-btn').trigger("click");
                getGroupName();
            });
            function getGroupName() {
                $.ajax({
                    type: "POST",
                    url: "../AdminFilters",
                    data: {requestType: "1"},
                    dataType: "json",
                    success: function (data) {
                        $("#distinctcity").html('<option value = "">Select Group Name</option>');
                        for (var i = 0; i < data.length; i++) {
                            $("#distinctcity").append('<option value = "' + data[i] + '">' + data[i] + '</option>');
                        }
                        $("#distinctcity").select2();
                    },
                    error: function (xhr, status, text) {

                    }
                });
            }
            function getGroupwiseIP() {
                var group = $('#distinctcity').val();
                $.ajax({
                    type: "POST",
                    url: "../AdminFilters",
                    data: {requestType: "5", group: group},
                    dataType: "json",
                    success: function (data) {
                        $("#nodeip").html('<option value = "">Select IP</option>');
                        for (var i = 0; i < data.length; i++) {
                            $("#nodeip").append('<option value = "' + data[i] + '">' + data[i] + '</option>');
                        }
                        $("#nodeip").select2();
                    },
                    error: function (xhr, status, text) {

                    }
                });
            }
            function deleteDevice()
            {
                var nodeip = $('#nodeip').val();
                bootbox.confirm("Are you want to sure deleting  IP?", function (result) {
                    if (result) {
                        $.ajax({
                            type: "POST",
                            url: "../DeviceReport",
                            data: {"requestType": 3, nodeip: nodeip},
                            dataType: "text",
                            success: function (data) {
                                if (data == "success") {
                                    alert("Device Deleted Succesfully");
                                } else {
                                    alert("Device Failed to Deleted");
                                }

                            }
                        });
                    } else {
                        $('.loading_sign').hide();
                        return;
                    }
                });


            }


        </script>

    </body>
</html>