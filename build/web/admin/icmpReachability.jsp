<%-- 
    Document   : icmpReachability
    Created on : 11 Apr, 2025, 3:35:58 PM
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
        response.sendRedirect("/VPortalNTT/sessionexp.jsp");
        return;
    } else {
        if (session.getAttribute("user") != null) {
            user = session.getAttribute("user").toString();
            role = session.getAttribute("role").toString();
        } else {
            response.sendRedirect("/VPortalNTT/sessionexp.jsp");
            return;
        }
    }
  
    USER = user.toUpperCase();

%>
<html>
    <head>
        <jsp:include page="../common/user-header.jsp"/>
        <%--<jsp:include page="../common/BFLHeader.jsp"/>--%>
        <title>Devices</title>
        <link rel="icon" href="../assets/images/vsicon.png" type="image/x-icon" />
        <link rel="stylesheet" href="../assets/css/font-awesome.min.css">
        <style>
            body{
                font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
                font-size: 12px;
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
                margin-top: -1px;
            }
            hr {
                margin-top: -8px;
                margin-bottom: 5px;
                border: 0;
                border-top: 1px solid #eee;
            }
            .container {
                /*                padding-right: 30px;
                                padding-left: 70px;*/
                width:100%;
                height: 100rem;
                /*                margin-right: 0px;
                                margin-left: 0px;*/
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
                /*table-layout: fixed;*/
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
            .dataTables_scrollHeadInner{
                width:100% !important;
            }
            .dataTables_scrollHeadInner table{
                width:100% !important;
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
                /*-webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);*/
                box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
                /*-webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;*/
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
            .vega-btn:hover{
                background: #990033;
                color: white;
                font-size: 12px;
                text-align: center;
                height: 29px;
                padding: 4px 17px;
                margin-top: -1px;
            }
            .form-group {
                display: flex;
                flex-direction: row;
                justify-content: center;
                align-items: center;
            }
        </style>
    </head>
    <body data-sidebar="dark">
        <jsp:include page="../common/adminmenu.jsp"/>
        <div class="main-content" style="margin-top:-5rem">
            <div class="page-content">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12" style="display:flex">

                            <div id="nodeNameDiv" class=" form-group col-md-3">
                                <label style="width:2rem;">IP:</label>
                                <input type="text" class="form-control" id="ip"  style="width:16rem !important;height:30px;">
                                <!--<select class="form-control" id="distinctcity1"  style="width:100%;height:30px;"></select>-->
                            </div>
                            <div id="nodeNameDiv" class=" form-group col-md-3">
                                <label style="width:5rem;">Packet:</label>
                                <input type="text" class="form-control" id="packet"  style="width:16rem !important;height:30px;">
                            </div>
                            <div id="nodeNameDiv" class=" form-group col-md-3">
                                <label style="width:4rem;">Byte:</label>
                                <input type="text" class="form-control" id="byte"  style="width:16rem !important;height:30px;">
                            </div>
                            <div id="TimeViewReport" class="col-md-2" style="width: 250px;">
                                <div class="col-md-3">
                                    <button id="getReport" class="btn vega-btn" onclick="getPingStatus();">Ping</button>
                                </div>
                            </div>
                        </div>
                    </div>
                   
                    <div class="col-md-12 loading_sign ">
                        <div class="yoyLodingTextArea" style="font-size:13px;"></div>
                        <img align="right" src="../assets/images/loading_1.gif" width="100px">
                    </div>
                    <div class="row reportTableContainer">
                        <div class="col-md-12"><textarea style="width: 100%;margin: 1px;border-radius: 5px;" id="fileOutputData" rows="16" cols="99"></textarea></div>
                    </div>

                </div>
            </div>
        </div>

    </div>
    <jsp:include page="../common/user-footer.jsp"/>
    <%--<jsp:include page="../common/BFLFooter.jsp"/>--%>
    <script>
        var username1 = '<%=user%>';
        $(document).ready(function () {
            $('.loading_sign').hide();
            $('.shrink-btn').trigger("click");
            $("#fileOutputData").hide();

        });
        function getPingStatus() {
            $('.loading_sign').show();
            var ip = $("#ip").val();
            var packet = $("#packet").val();
            var byte = $("#byte").val();
            $.ajax({
                type: "POST",
                url: "../DeviceReachability",
                data: {filterType: "1", ip: ip, packet: packet, byte: byte, status: status},
                dataType: "text",
                success: function (data) {
                    $('.loading_sign').hide();
                    console.log(data);
                    $("#fileOutputData").show();
                    $("#fileOutputData").html(data);
                    $("textarea").prop('disabled', true);

                }
            });
        }

        function writeToWebLog(status) {
            var nodeip = $('#nodeip').val();
            var distinctcity1 = $('#distinctcity1').val();
            console.log(username1);
            var activity = "Changing Device Type " + nodeip + " To:" + distinctcity1;
            $.ajax({
                type: "POST",
                url: "../writeToWebLog",
                data: {"requestType": 1, nodeip: nodeip, username: username1, activity: activity, status: status},
                dataType: "text",
                success: function (data) {
                    console.log(data);


                }
            });

        }

    </script>

</body>
</html>

