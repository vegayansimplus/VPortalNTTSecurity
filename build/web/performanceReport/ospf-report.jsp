<%-- 
    Document   : cpu-traffic
    Created on : 31 Mar, 2025, 4:29:06 PM
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
        <title>Report</title>
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
                            <div id="routertypediv" class="form-group col-md-3" style="width: 24rem;">
                                <label for="first-name" style="width: 13rem;">Device Type</label>
                                <select class="form-control" id="deviceType" onchange="AllFlter();" style="height:10px;display: inline-flex"></select>
                            </div>
                            <div id="circleNameDiv" class="form-group col-md-2" style="width: 19rem;">
                                <label for="first-name" style="width: 13rem;">Node IP</label>
                                <select class="form-control" id="nodeIP" onchange="getNodeName();" style="height:10px;display: inline-flex"></select>
                            </div>
                            <div id="circleNameDiv" class="form-group col-md-2" style="width: 24rem;">
                                <label for="first-name" style="width: 13rem;">Node Name</label>
                                <select class="form-control" id="nodeName" onchange="getNodeIP();" style="height:10px;display: inline-flex"></select>
                            </div>
                            <!--                            <div id="circleNameDiv" class="form-group col-md-3" style="width: 24rem;">
                                                            <label for="first-name" style="width: 13rem;">Node Name</label>
                                                            <select class="form-control" id="nodeName"  style="height:10px;display: inline-flex"></select>
                                                        </div>-->


                            <div class="col-md-1">
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
        <div class="modal fade" id="chartModal" role="dialog">
            <div class="modal-dialog modal-lg">
                <div class="modal-content" style="margin-left:-13rem;width: 112rem;">
                    <div class="modal-header chartModelHeader" style="padding:8px;padding-left: 15px;">
                        <h6 class="modal-title chartModelTitle"></h6>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>

                    </div>
                    <div class="modal-body" style="padding:5px;">
                        <div class="row" id="chartContainer"> </div>
                        <div class="row" id="dataContainer" style="width:96%;margin-left: 18px;margin-top:2rem">
                            <table id="chartTable" class="display compact cell-border" cellspacing="0"  width="100%"></table>
                        </div>
                    </div>
                    <div class="modal-footer" style="padding:8px;" id="chartModalFooter">
                        <button type="button" class="btn" id="chartDataButton" style="float: left; background-color: #990033;color: white;">Data</button>
                        <button type="button" class="btn" id="ChartPlotButton" style="float: left; background-color: #990033;color: white;" >Graph</button>
                        <!--<button type="button" class="btn" id="pdfDownloadButton" style="float: left; background-color: #990033;color: white;" >PDF</button>-->
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <!--<button type="button" class="btn btn-default" onClick='myFunction()'>Download PDF</button>-->
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/user-footer.jsp"/>

        <script>
            var dataTableObject;
            var toTime;
            var fromTime;
            var dbType;
            $(document).ready(function () {
                $('.shrink-btn').trigger("click");
                getGroupName();
                $(".loading_sign").hide();
                $("#ChartDataButton").click(function ()
                {
                    $("#chartContainer").hide();
                    $("#dataContainer").show();
                });
                $("#ChartPlotButton").click(function ()
                {
                    $("#chartContainer").show();
                    $("#dataContainer").hide();
                });
            });
            function AllFlter() {
                $("#nodeName").html('');
                $("#nodeIP").html('');
                getNodeName();
                getNodeIP();
            }
            $(document).ready(function () {
                // Show Data (Hide Graph)
                $('#chartDataButton').click(function () {
                    $('#dataContainer').show();
                    $('#chartContainer').hide();
                });

                // Show Graph (Hide Data)
                $('#ChartPlotButton').click(function () {
                    $('#chartContainer').show();
                    $('#dataContainer').hide();
                });

                // Optional: Set initial state when modal opens
                $('#chartModal').on('shown.bs.modal', function () {
                    $('#chartContainer').show();  // or hide if you want data view as default
                    $('#dataContainer').hide();   // or show if data view is default
                });
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
                var nodeIP = $("#nodeIP").val();
                if (nodeIP == "" || nodeIP == null) {
                    nodeIP = "NULL";
                }
                $.ajax({
                    type: "POST",
                    url: "../UserFilters",
                    data: {requestType: "5", groupName: groupName, deviceType: deviceType, nodeIP: nodeIP},
                    dataType: "json",
                    success: function (data) {
                        if (data.length == 1)
                        {
                            $("#nodeName").html('<option value="' + data[0] + '">' + data[0] + '</option>');
                        } else {
                            $("#nodeName").html('<option value = "">Select Node Name</option>');
                            for (var i = 0; i < data.length; i++) {
                                $("#nodeName").append('<option value = "' + data[i] + '">' + data[i] + '</option>');
                            }
                            $("#nodeName").select2();
                        }

                    },
                    error: function (xhr, status, text) {

                    }
                });

            }
            function getNodeIP()
            {
                var groupName = $("#groupName").val();
                var deviceType = $("#deviceType").val();
                var nodeName = $("#nodeName").val();
                if (nodeName == "" || nodeName == null) {
                    nodeName = "NULL";
                }
                $.ajax({
                    type: "POST",
                    url: "../UserFilters",
                    data: {requestType: "6", groupName: groupName, deviceType: deviceType, nodeName: nodeName},
                    dataType: "json",
                    success: function (data) {
                        if (data.length == 1)
                        {
                            $("#nodeIP").html('<option value="' + data[0] + '">' + data[0] + '</option>');
                        } else {
                            $("#nodeIP").html('<option value = "">Select Node IP</option>');
                            for (var i = 0; i < data.length; i++) {
                                $("#nodeIP").append('<option value = "' + data[i] + '">' + data[i] + '</option>');
                            }
                            $("#nodeIP").select2();
                        }
//                      
                    },
                    error: function (xhr, status, text) {

                    }
                });

            }
            function viewReport() {

                $(".loading_sign").show();
                var nodeIP = $('#nodeIP').val();
                if (dataTableObject)
                {
                    $(".reportBar").html('');
                    $(".reportBar").html('<div class="row" id="reportTitle" align="center"></div><div align="right" class="row col-md-offset-11 legend123" ></div><table id="reportTable" class="display compact cell-border" cellspacing="0"  width="100%"></table>');
                }
                $.ajax({
                    type: "POST",
                    url: "../PerformanceReport",
                    data: {
                        "requestType": "5",
                        nodeIP: nodeIP

                    },
                    dataType: 'json',
                    success: function (data)
                    {
                        $(".loading_sign").hide();
                        dataTableObject = $('#reportTable').DataTable({
                            data: data,
                            "autoWidth": true,
                            "columnDefs": [
                                {className: "dt-left", "width": "120px", "targets": 0},
                                {className: "dt-left", "width": "120px", "targets": 1},
                                {className: "dt-right", "width": "100px", "targets": 2},
                                {className: "dt-right", "width": "100px", "targets": 3}

                            ],
                            columns: [
                                {title: "Node IP"},
                                {title: "Neighbor IP"},
                                {title: "Neighbor State"},
                                {title: "Time"}

                            ],
                            "scrollX": true,
                            "scrollY": "340px",
                            "pageLength": 15,
                            fixedHeader: false, dom: 'Blfrtip',
                            buttons: [
                                {
                                    extend: 'excelHtml5',
                                    title: 'OSPF  Report',
                                },
                                {
                                    extend: 'pdfHtml5',
                                    title: 'OSPF Report',
                                    orientation: 'landscape', // optional: portrait or landscape
                                    pageSize: 'A4', // optional: A4, A3, etc.
                                    exportOptions: {
                                        columns: ':visible'   // optional: exports only visible columns
                                    }
                                }
                            ]
                        });
                        $("#reportTitle").html("<b>OSPF Report</b>");


                    },
                    error: function (jqXHR, exception) {

                    }
                });
            }



        </script>

    </body>
</html>
