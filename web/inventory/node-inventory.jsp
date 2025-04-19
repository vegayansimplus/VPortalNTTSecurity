<%-- 
    Document   : node-inventory
    Created on : 31 Mar, 2025, 4:06:01 PM
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
        response.sendRedirect("/BFL/login.jsp");
        return;
    } else {
        if (session.getAttribute("user") != null) {
            user = session.getAttribute("user").toString();
            role = session.getAttribute("role").toString();
        } else {
            response.sendRedirect("/BFL/login.jsp");
            return;
        }
    }
  
    USER = user.toUpperCase();

%>
<html>
    <head>
        <jsp:include page="../common/user-header.jsp"/>
        <jsp:include page="../common/CommonHeader.jsp"/>
        <title>Inventory</title>
        <link rel="icon" href="../assets/images/vsicon.png" type="image/x-icon" />


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
        </style>
    </head>
    <body data-sidebar="dark">
        <jsp:include page="../common/usermenu.jsp"/>
        <div class="main-content">
            <div class="page-content">
                <div class="container">
                    <div class="row" style="margin-left: -4rem">
                        <div class="col-md-12">
                            <div id="nodeType" class="form-group col-md-3" style="width: 24rem;">
                                <label for="first-name" style="width: 10rem;">Group Name</label>
                                <select class="form-control" id="groupName" onchange="getDeviceType();" style="height:10px;display: inline-flex"></select>
                            </div>
                            <div id="routertypediv" class="form-group col-md-4" style="width: 24rem;">
                                <label for="first-name" style="width: 13rem;">Device Type</label>
                                <select class="form-control" id="deviceType" onchange="getNodeName();" style="height:10px;display: inline-flex"></select>
                            </div>
                            <div id="circleNameDiv" class="form-group col-md-4" style="width: 24rem;">
                                <label for="first-name" style="width: 13rem;">Node Name</label>
                                <select class="form-control" id="nodeName"  style="height:10px;display: inline-flex"></select>
                            </div>

                            <div class="col-md-4" style="padding: 0;padding-left: 25rem;float: right;">
                                <button id="getReport" class="btn vega-btn" onclick="viewReport();">View Report</button>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="col-md-12 loading_sign ">
                        <div class="yoyLodingTextArea" style="font-size:13px;"></div>
                        <img align="right" src="../assets/images/loading_1.gif" width="100px">
                    </div>
                    <div class="row reportTableContainer" style="margin-left: -4rem;width: 119rem;">
                        <div class="col-md-12 reportBar">
                            <div class="row" id="reportTitle" align="center"></div>
                            <table id="reportTable" class="display compact cell-border" cellspacing="0"  style="width:100%;"></table>
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
                $(".loading_sign").hide();
            });
            function getGroupName() {
                $.ajax({
                    type: "POST",
                    url: "../UserFilters",
                    data: {requestType: "1"},
                    dataType: "json",
                    success: function (data) {
                        $("#groupName").html('<option value = "">Select Group Name</option>');
                        for (var i = 0; i < data.length; i++) {
                            $("#groupName").append('<option value = "' + data[i] + '">' + data[i] + '</option>');
                        }
                        $("#groupName").select2();
                    },
                    error: function (xhr, status, text) {

                    }
                });
            }
            function getDeviceType() {
                var groupName = $("#groupName").val();
                $.ajax({
                    type: "POST",
                    url: "../UserFilters",
                    data: {requestType: "2", groupName: groupName},
                    dataType: "json",
                    success: function (data) {
                        $("#deviceType").html('<option value = "">Select Group Name</option>');
                        for (var i = 0; i < data.length; i++) {
                            $("#deviceType").append('<option value = "' + data[i] + '">' + data[i] + '</option>');
                        }
                        $("#deviceType").select2();
                    },
                    error: function (xhr, status, text) {

                    }
                });
            }
            function getNodeName()
            {
                var groupName = $("#groupName").val();
                var deviceType = $("#deviceType").val();
                $.ajax({
                    type: "POST",
                    url: "../UserFilters",
                    data: {requestType: "3", groupName: groupName, deviceType: deviceType},
                    dataType: "json",
                    success: function (data) {
                        $("#nodeName").html('<option value = "">Select Node Name</option>');
                        for (var i = 0; i < data.length; i++) {
                            $("#nodeName").append('<option value = "' + data[i] + '">' + data[i] + '</option>');
                        }
                        $("#nodeName").select2();
                    },
                    error: function (xhr, status, text) {

                    }
                });

            }
            function viewReport() {
                $(".loading_sign").show();
                var nodeName = $("#nodeName").val();
                if (dataTableObject)
                {
                    $(".reportBar").html('');
                    $(".reportBar").html('<div class="row" id="reportTitle" align="center"></div><div align="right" class="row col-md-offset-11 legend123" ></div><table id="reportTable" class="display compact cell-border" cellspacing="0"  width="100%"></table>');
                }
                $.ajax({
                    type: "POST",
                    url: "../UserInventory",
                    data: {
                        "requestType": "1",
                        nodeName: nodeName
                    },
                    dataType: 'json',
                    success: function (data)
                    {
                         $(".loading_sign").hide();
                        dataTableObject = $('#reportTable').DataTable({
                            data: data,
                            "autoWidth": true,
                            "columnDefs": [
                                {className: "dt-left", "targets": 0},
                                {className: "dt-left", "targets": 1},
                                {className: "dt-left", "targets": 2},
                                {className: "dt-left", "targets": 3},
                                {className: "dt-left", "targets": 4},
                                {className: "dt-left", "targets": 5},
                                {className: "dt-left", "targets": 6},
                                {className: "dt-left", "targets": 7},
                                {className: "dt-left", "targets": 8},
                                {className: "dt-left", "targets": 9},
                                {className: "dt-left", "targets": 10},
                            ],
                            columns: [
                                {title: "Node ID"},
                                {title: "Node Name"},
                                {title: "Vendor Name"},
                                {title: "Interface Name"},
                                {title: "If IPAddress"},
                                {title: "If Admin Status"},
                                {title: "IfOperStatus"},
                                {title: "IfMtu"},
                                {title: "IfSpeed"},
                                {title: "IfPhyAddress"},
                                {title: "Interface Desc"},
                            ],
                            "scrollX": true,
                            "scrollY": "340px",
                            "pageLength": 15,
                            fixedHeader: false, dom: 'Blfrtip',
                            buttons: [
                                {
                                    extend: 'excelHtml5',
                                    title: 'Nodes Inventory  Report',
                                }
                            ]
                        });
                        $("#reportTitle").html("<b>Node Inventory Report</b>");
                    },
                    error: function (jqXHR, exception) {

                    }
                });
            }

        </script>

    </body>
</html>