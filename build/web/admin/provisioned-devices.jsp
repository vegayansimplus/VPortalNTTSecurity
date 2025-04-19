<%-- 
    Document   : provisioned-devices
    Created on : 3 Apr, 2025, 2:51:48 PM
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
        <jsp:include page="../common/CommonHeader.jsp"/>
        <link rel="stylesheet" href="../assets/css/font-awesome.min.css">
        <title>Devices</title>
        <link rel="icon" href="../assets/images/vsicon.png" type="image/x-icon" />
        <link rel="stylesheet" href="../assets/css/font-awesome.min.css">
        <style>
            body{
                font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
                font-size: 12px;
                line-height: 1.42857143;
                position: relative;
                overflow-x: hidden;
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
                height: 25px;
                padding: 3px 10px;
                margin-top: 5px;
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
        <div class="main-content">
            <div class="page-content">
                <div class="container">


                    <div class="row reportTableContainer" style="    margin-top: 3rem;">
                        <div class="col-md-12 reportBar">
                            <div class="row" id="reportTitle" align="center"></div>
                            <table id="reportTable" class="display compact cell-border" cellspacing="0"  style="width:100%;"></table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <jsp:include page="../common/user-footer.jsp"/>
    <%--<jsp:include page="../common/BFLFooter.jsp"/>--%>
    <script>
        var dataTableObject;
        $(document).ready(function () {
            $('.shrink-btn').trigger("click");
            getProviosionedDevices();
        });

        function getProviosionedDevices() {
            if (dataTableObject) { // Check if table object exists and needs to be flushed
                $(".reportBar").html('');
                $(".reportBar").html('<div class="row" id="reportTitle" style="text-align:center;font-size: 14px;font-weight: 600;"></div><div align="right" class="row col-md-offset-11 legend123" ></div><table id="reportTable" class="display compact cell-border" cellspacing="0"  width="100%"></table>');
            }
            $.ajax({
                type: "POST",
                url: "../DeviceReport",
                data: {requestType: "1"},
                dataType: 'json',
                success: function (data) {
                    console.log(data);
                    for (var i = 0; i < data.length; i++) {
                        data[i][2] = data[i][2].split('.')[0];
                      
                    }
                    dataTableObject = $('#reportTable').DataTable({
                        data: data,
                        "columnDefs": [
                            {"width": "100px", "targets": 0},
                            {"width": "120px", "targets": 1},
                            {"width": "120px", "targets": 2}
                        ],
                        columns: [

                            {title: "Node ID"},
                            {title: "Node Name"},
                            {title: "Time"}
                        ],
                        "scrollX": true,
                        "scrollY": "340px",
                        dom: 'Blfrtip',
                        buttons: [
                            {
                                extend: 'excelHtml5',
                                title: 'Provisioned Device Report'

                            }
                        ]
                    });
                    $("#reportTitle").html("<b>Provisioned Devices</b>");
                }
            });
        }
    </script>

</body>
</html>
