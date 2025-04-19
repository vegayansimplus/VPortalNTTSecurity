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
                    <div class="row">
                        <div class="col-md-12" style="width: 147rem !important; margin-left: -5rem;display: inline-flex">
                            <div id="nodeType" class="form-group col-md-2" style="width: 22rem;">
                                <label for="first-name" style="width: 10rem;">Group Name</label>
                                <select class="form-control" id="groupName" onchange="getDeviceType();" style="height:10px;display: inline-flex"></select>
                            </div>
                            <div id="routertypediv" class="form-group col-md-2" style="width: 18rem;">
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
                            <div id="TrafficscaleDiv" class="form-group col-md-1" style="width: 23rem;">
                                <label for="first-name" style="width: 8rem;">TrafficScale</label>
                                <select class="form-control" id="TrafficScale"  style="height:30px;width: 14rem;display: inline-flex">
                                    <option value="Kbps">Kbps</option>
                                    <option value="Mbps">Mbps</option>
                                    <option value="Gbps">Gbps</option> 
                                </select>
                            </div>

                            <div class="col-md-2">
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
        <script src="https://gitcdn.github.io/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js"></script>
        <script rel="stylesheet" href="../assets/js/bootstraptoggle.js"></script>
        <script type="text/javascript" src="../assets/js/html2pdf.js"></script>

        <script>
                                    var dataTableObject;
                                    var toTime;
                                    var fromTime;
                                    var dbType;
                                    var globalStartTime1;
                                    var globalEndTime1;
                                    var dateflag = "curr";

// Sanitize user inputs to prevent XSS attacks

// Function to refresh filter options
                                    function AllFlter() {
                                        $("#nodeName").html('');
                                        $("#nodeIP").html('');
                                        getNodeName();
                                        getNodeIP();
                                    }

// Document ready function
                                    $(document).ready(function () {
                                        $('.shrink-btn').trigger("click");
                                        getGroupName();
                                        $(".loading_sign").hide();
                                    });

// Database Type Filter Change
                                    $(document).on("change", "input[name=DatabaseTypeFilter]", function () {
                                        if ($(this).val() === "Userdefined") {
                                            $("#userDateInputs").show();
                                        } else {
                                            $("#userDateInputs").hide();
                                        }
                                    });

// Toggle between chart and data containers
                                    $("#ChartDataButton").click(function () {
                                        $("#chartContainer").hide();
                                        $("#dataContainer").show();
                                    });

                                    $("#ChartPlotButton").click(function () {
                                        $("#chartContainer").show();
                                        $("#dataContainer").hide();
                                    });

// Download chart as PDF
                                    $('#download').click(function () {
                                        var element = document.getElementById('chart3');
                                        var opt = {
                                            margin: 1,
                                            filename: 'plot.pdf',
                                            image: {type: 'jpeg', quality: 0.98},
                                            html2canvas: {scale: 1},
                                            jsPDF: {unit: 'in', format: 'letter', orientation: 'portrait'}
                                        };
                                        html2pdf(element);
                                    });

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

// Fetch Group Names for the filter
                                    function getGroupName() {
                                        $.ajax({
                                            type: "POST",
                                            url: "../UserFilters",
                                            data: {requestType: "1"},
                                            dataType: "json",
                                            success: function (data) {
                                                $("#groupName").html('<option value = "">Select Group Name</option>');
                                                data.forEach(function (item) {
                                                    $("#groupName").append('<option value = "' + sanitizeInput(item) + '">' + sanitizeInput(item) + '</option>');
                                                });
                                                $("#groupName").select2();
                                            },
                                            error: function (xhr, status, text) {
                                                console.error("Error fetching group names:", status, text);
                                                alert("Error fetching group names.");
                                            }
                                        });
                                    }

// Fetch Device Types based on selected Group
                                    function getDeviceType() {
                                        var groupName = $("#groupName").val();
                                        $.ajax({
                                            type: "POST",
                                            url: "../UserFilters",
                                            data: {requestType: "2", groupName: groupName},
                                            dataType: "json",
                                            success: function (data) {
                                                $("#deviceType").html('<option value = "">Select Device Type</option>');
                                                data.forEach(function (item) {
                                                    $("#deviceType").append('<option value = "' + sanitizeInput(item) + '">' + sanitizeInput(item) + '</option>');
                                                });
                                                $("#deviceType").select2();
                                            },
                                            error: function (xhr, status, text) {
                                                console.error("Error fetching device types:", status, text);
                                                alert("Error fetching device types.");
                                            }
                                        });
                                    }

// Handle AJAX request errors by logging and providing a generic message
                                    function handleAjaxError(xhr, status, text) {
                                        console.error("AJAX request failed:", status, text);
                                        alert("An error occurred while processing your request. Please try again later.");
                                    }

// Ensure all inputs are sanitized
                                    function sanitizeInputsAndSubmit() {
                                        var groupName = sanitizeInput($("#groupName").val());
                                        var deviceType = sanitizeInput($("#deviceType").val());

                                        // Proceed with the submission or further processing
                                        console.log("Group: " + groupName, "Device: " + deviceType);
                                    }

// Fetch Node Names based on selected Group and Device Type
                                    function getNodeName() {
                                        var groupName = $("#groupName").val();
                                        var deviceType = $("#deviceType").val();
                                        var nodeIP = $("#nodeIP").val();
                                        if (nodeIP === "" || nodeIP === null) {
                                            nodeIP = "NULL";
                                        }
                                        $.ajax({
                                            type: "POST",
                                            url: "../UserFilters",
                                            data: {requestType: "5", groupName: groupName, deviceType: deviceType, nodeIP: nodeIP},
                                            dataType: "json",
                                            success: function (data) {
                                                if (data.length === 1) {
                                                    $("#nodeName").html('<option value="' + data[0] + '">' + data[0] + '</option>');
                                                } else {
                                                    $("#nodeName").html('<option value = "">Select Node Name</option>');
                                                    data.forEach(function (item) {
                                                        $("#nodeName").append('<option value = "' + item + '">' + item + '</option>');
                                                    });
                                                    $("#nodeName").select2();
                                                }
                                            },
                                            error: handleAjaxError
                                        });
                                    }

// Fetch Node IPs based on selected Node Name
                                    function getNodeIP() {
                                        var groupName = $("#groupName").val();
                                        var deviceType = $("#deviceType").val();
                                        var nodeName = $("#nodeName").val();
                                        if (nodeName === "" || nodeName === null) {
                                            nodeName = "NULL";
                                        }
                                        $.ajax({
                                            type: "POST",
                                            url: "../UserFilters",
                                            data: {requestType: "6", groupName: groupName, deviceType: deviceType, nodeName: nodeName},
                                            dataType: "json",
                                            success: function (data) {
                                                if (data.length === 1) {
                                                    $("#nodeIP").html('<option value="' + data[0] + '">' + data[0] + '</option>');
                                                } else {
                                                    $("#nodeIP").html('<option value = "">Select Node IP</option>');
                                                    data.forEach(function (item) {
                                                        $("#nodeIP").append('<option value = "' + item + '">' + item + '</option>');
                                                    });
                                                    $("#nodeIP").select2();
                                                }
                                            },
                                            error: handleAjaxError
                                        });
                                    }


                                    function viewReport() {
                                        $(".loading_sign").show();

                                        // Sanitize input values to prevent XSS or invalid inputs
                                        var nodeName = $('#nodeName').val().trim();
                                        var TrafficScale = $('#TrafficScale').val().trim();

                                        // Basic validation for inputs
                                        if (!nodeName || !TrafficScale) {
                                            alert('Please fill in all required fields.');
                                            $(".loading_sign").hide();
                                            return;
                                        }

                                        // Validate TrafficScale value (assuming it can only be 'Kbps', 'Mbps', or 'Gbps')
                                        const validTrafficScales = ['Kbps', 'Mbps', 'Gbps'];
                                        if (!validTrafficScales.includes(TrafficScale)) {
                                            alert('Invalid traffic scale selected.');
                                            $(".loading_sign").hide();
                                            return;
                                        }

                                        var today = new Date();
                                        var dd = today.getDate();
                                        var mm = today.getMonth() + 1; // January is 0!
                                        var hh = today.getHours();
                                        var MM = today.getMinutes();
                                        var ss = today.getSeconds();
                                        var yyyy = today.getFullYear();

                                        // Formatting the date and time
                                        var formattedToday = `${yyyy}-${mm < 10 ? '0' + mm : mm}-${dd < 10 ? '0' + dd : dd} ${hh < 10 ? '0' + hh : hh}:${MM < 10 ? '0' + MM : MM}:${ss < 10 ? '0' + ss : ss}`;
                                                var toTime = formattedToday;

                                                // Get yesterday's date
                                                var yesterday = new Date(today);
                                                yesterday.setDate(today.getDate() - 1);
                                                var $dd = yesterday.getDate();
                                                var $mm = yesterday.getMonth() + 1;
                                                var $yyyy = yesterday.getFullYear();
                                                var formattedYesterday = `${$yyyy}-${$mm < 10 ? '0' + $mm : $mm}-${$dd < 10 ? '0' + $dd : $dd} ${hh < 10 ? '0' + hh : hh}:${MM < 10 ? '0' + MM : MM}:${ss < 10 ? '0' + ss : ss}`;
                                                        var fromTime = formattedYesterday;

                                                        // Reset the report table if dataTableObject is already defined
                                                        if (dataTableObject) {
                                                            $(".reportBar").html('');
                                                            $(".reportBar").html('<div class="row" id="reportTitle" align="center"></div><div align="right" class="row col-md-offset-11 legend123" ></div><table id="reportTable" class="display compact cell-border" cellspacing="0"  width="100%"></table>');
                                                        }

                                                        // Secure AJAX call with HTTPS
                                                        $.ajax({
                                                            type: "POST",
                                                            url: "../PerformanceReport",
                                                            data: {
                                                                "requestType": "1",
                                                                nodeName: nodeName,
                                                                TrafficScale: TrafficScale,
                                                                toTime: toTime,
                                                                fromTime: fromTime
                                                            },
                                                            dataType: 'json',
                                                            success: function (data) {
                                                                $(".loading_sign").hide();
                                                                dataTableObject = $('#reportTable').DataTable({
                                                                    data: data,
                                                                    "autoWidth": true,
                                                                    "columnDefs": [
                                                                        {className: "dt-left", "width": "200px", "targets": 0},
                                                                        {className: "dt-left", "width": "200px", "targets": 1},
                                                                        {className: "dt-left", "width": "150px", "targets": 2},
                                                                        {className: "dt-left", "width": "110px", "targets": 3},
                                                                        {className: "dt-left", "width": "120px", "targets": 4},
                                                                        {className: "dt-right", "width": "90px", "targets": 5},
                                                                        {className: "dt-right", "width": "70px", "targets": 6},
                                                                        {className: "dt-left", "width": "70px", "targets": 7},
                                                                        {className: "dt-left", "width": "70px", "targets": 8},
                                                                        {className: "dt-left", "width": "70px", "targets": 9},
                                                                        {className: "dt-left", "width": "70px", "targets": 10},
                                                                        {className: "dt-left", "width": "70px", "targets": 11},
                                                                        {className: "dt-left", "width": "70px", "targets": 12},
                                                                        {className: "dt-left", "width": "70px", "targets": 13},
                                                                        {className: "dt-left", "width": "70px", "targets": 14},
                                                                        {className: "dt-left", "width": "70px", "targets": 15},
                                                                        {className: "dt-left", "width": "70px", "targets": 16},
                                                                        {className: "dt-left", "width": "70px", "targets": 17},
                                                                        {className: "dt-left", "width": "70px", "targets": 18}
                                                                    ],
                                                                    columns: [
                                                                        {title: "Node ID"},
                                                                        {title: "Node Name"},
                                                                        {title: "VendorName"},
                                                                        {title: "Interface Name"},
                                                                        {title: "Interface Speed"},
                                                                        {title: "Interface IP Address"},
                                                                        {title: "Curr In"},
                                                                        {title: "Curr out"},
                                                                        {title: "Peak In"},
                                                                        {title: "Peak Out"},
                                                                        {title: "Avg In"},
                                                                        {title: "Avg Out"},
                                                                        {title: "Util In(%)"},
                                                                        {title: "Util Out(%)"},
                                                                        {title: "Peak In(%)"},
                                                                        {title: "Peak Out(%)"},
                                                                        {title: "Peak Time In"},
                                                                        {title: "Peak Time Out"},
                                                                        {title: "Description"}
                                                                    ],
                                                                    "scrollX": true,
                                                                    "scrollY": "340px",
                                                                    "pageLength": 15,
                                                                    fixedHeader: false, dom: 'Blfrtip',
                                                                    buttons: [
                                                                        {
                                                                            extend: 'excelHtml5',
                                                                            title: 'Port Inventory Report',
                                                                        },
                                                                        {
                                                                            extend: 'pdfHtml5',
                                                                            title: 'Port Inventory Report',
                                                                            orientation: 'landscape', // optional: portrait or landscape
                                                                            pageSize: 'A4', // optional: A4, A3, etc.
                                                                            exportOptions: {
                                                                                columns: ':visible'   // optional: exports only visible columns
                                                                            }
                                                                        }
                                                                    ]
                                                                });

                                                                // Additional processing after receiving the report data
                                                                $("#reportTitle").html("<b>Port Traffic Report</b>");
                                                                $("#reportTable tbody").css('cursor', 'pointer');
                                                                $('#reportTable tbody').on('click', 'tr', function () {
                                                                    var nodeName = $('#reportTable').DataTable().row(this).data()[1];
                                                                    var interfaceName = $('#reportTable').DataTable().row(this).data()[3];

                                                                    // Show chart container and data table container
                                                                    $("#chartContainer").html('');
                                                                    $("#dataContainer").html('');
                                                                    $("#dataContainer").hide();
                                                                    $("#chartContainer").show();

                                                                    $(".chartModelTitle").html("<b>Port Traffic for</b>  " + nodeName + " : " + interfaceName);
                                                                    $("#dataContainer").html('<div id="datac" class="col-md-12" style="margin-top: -10px;"><table id="example2" class="display compact cell-border" cellspacing="0"  width="100%"><thead><tr><th>In</th><th>Out</th><th>Time</th></tr></thead><tbody id="exmp2Body"></tbody></table></div>');
                                                                    $("#chartContainer").html('<div class="col-md-12 loadingLabel"><img align="right" src="../assets/images/loading_1.gif" width="100px"></div><br><br><div class="col-md-12" style="display:inline-flex; flex-wrap: wrap; gap: 1rem; align-items: center;"> <div class="plottrafficScale"><label for="plotTrafficScale" style="width: 8rem;">TrafficScale</label><select class="form-control" id="plotTrafficScale" style="height:30px; width: 14rem; display: inline-flex"><option value="Kbps">Kbps</option><option value="Mbps">Mbps</option><option value="Gbps">Gbps</option></select></div><div id="radioOptions"><label><input type="radio" name="DatabaseTypeFilter" value="Last Day" checked> Last Day</label>&nbsp;&nbsp;<label><input type="radio" name="DatabaseTypeFilter" value="3 Day"> 3 Day</label>&nbsp;&nbsp;<label><input type="radio" name="DatabaseTypeFilter" value="7 Day"> 7 Day</label>&nbsp;&nbsp;</div></div>');
                                                                });
                                                            },
                                                            error: function () {
                                                                alert("Error loading report data.");
                                                                $(".loading_sign").hide();
                                                            }
                                                        });
                                                    }

                                                    function drawChartLinkTraffic(json_data, xTitle, yTitle) {
                                                        var chart = c3.generate({
                                                            data: {
                                                                json: json_data,
                                                                keys: {
                                                                    x: 'timeseries',
                                                                    value: ['in', 'out']
                                                                },
                                                                type: 'area'
                                                            },
                                                            axis: {
                                                                x: {
                                                                    type: 'timeseries',
                                                                    tick: {
                                                                        format: function (d) {
                                                                            var mins = d.getMinutes();
                                                                            if (mins < 10) {
                                                                                mins = "0" + mins;
                                                                            }
                                                                            return d.getDate() + "-" + (d.getMonth() + 1) + "-" + d.getUTCFullYear() + "   " + d.getHours() + ":" + mins;
                                                                        },
                                                                        fit: true,
                                                                        culling: {
                                                                            max: 5
                                                                        }
                                                                    },
                                                                    label: {
                                                                        text: xTitle,
                                                                        position: 'outer-center'
                                                                    }
                                                                },
                                                                y: {
                                                                    label: {
                                                                        text: yTitle,
                                                                        position: 'outer-middle'
                                                                    }
                                                                }
                                                            },
                                                            color: {
                                                                pattern: ['#4CAF50', '#3F51B5', '#4CAF50', '#673AB7', '#3F51B5', '#2196F3', '#03A9F4', '#00BCD4', '#009688', '#4CAF50', '#8BC34A', '#CDDC39', '#FFEB3B', '#FFC107', '#FF9800', '#FF5722']
                                                            },
                                                            grid: {
                                                                x: {
                                                                    show: true
                                                                },
                                                                y: {
                                                                    show: true
                                                                }
                                                            },
                                                            zoom: {
                                                                enabled: true
                                                            },
                                                            size: {
                                                                height: 320,
                                                                width: 870
                                                            },
                                                            bindto: '#chart3'
                                                        });
                                                    }

                                                    function getPortTrafficGraph(nodeName, interfaceName, TrafficScale) {
                                                        console.log("nodeName:" + nodeName);
                                                        console.log("interfaceName:" + interfaceName);

                                                        var temptrafficscale = $("#plotTrafficScale").val().trim();  // Ensure input is sanitized
                                                        console.log(temptrafficscale);

                                                        var dbtype1 = $('input[name="DatabaseTypeFilter"]:checked').val().trim(); // Sanitize input
                                                        console.log(dbtype1);

                                                        // Validate inputs before proceeding
                                                        if (!nodeName || !interfaceName || !temptrafficscale || !dbtype1) {
                                                            alert("Please fill in all the required fields.");
                                                            return;
                                                        }

                                                        if (dbtype1 === "Userdefined") {
                                                            globalStartTime1 = $('#fromDate').val();
                                                            globalEndTime1 = $('#toDate').val();

                                                            // Ensure valid datetime format
                                                            if (!validateDate(globalStartTime1) || !validateDate(globalEndTime1)) {
                                                                alert("Invalid date format.");
                                                                return;
                                                            }

                                                            fromTime = globalStartTime1.replace('T', ' ') + ':00';
                                                            toTime = globalEndTime1.replace('T', ' ') + ':00';
                                                        } else {
                                                            fromTime = $("#FromTimeFilter").val();
                                                            toTime = $("#ToTimeFilter").val();

                                                            // Validate time format
                                                            if (!validateTime(fromTime) || !validateTime(toTime)) {
                                                                alert("Invalid time format.");
                                                                return;
                                                            }
                                                        }

                                                        handleRadio(dbtype1);

                                                        $("#dataContainer").html('');
                                                        $("#dataContainer").html('<table id="chartTable" class="display compact cell-border" cellspacing="0"  width="100%"></table>');

                                                        $.ajax({
                                                            type: "POST",
                                                            url: "../ReportPlots",
                                                            data: {
                                                                requestType: "2",
                                                                nodeName: sanitizeInput(nodeName), // Sanitize input
                                                                interfaceName: sanitizeInput(interfaceName), // Sanitize input
                                                                fromTime: globalStartTime1,
                                                                toTime: globalEndTime1,
                                                                unit: temptrafficscale,
                                                                dateflag: dateflag
                                                            },
                                                            dataType: "json",
                                                            success: function (data) {
                                                                console.log("data chart");
                                                                console.log(data);
                                                                var jsonData = data;
                                                                var temp = '<div id="datac" class="col-md-12" style="margin-top: -10px;"><table id="example2" class="display compact cell-border" cellspacing="0"  width="100%"><thead><tr><th>In</th><th>Out</th><th>Time</th></tr></thead><tbody id="exmp2Body">';

                                                                for (var i = 0; i < jsonData.length; i++) {
                                                                    var t2 = jsonData[i].timeseries;
                                                                    var t1 = t2.split(".");
                                                                    var t = t1[0];
                                                                    var test = t;

                                                                    // Split timestamp into [ Y, M, D, h, m, s ]
                                                                    var t = t.split(/[- :]/);
                                                                    // Apply each element to the Date function
                                                                    var d = new Date(t[0], t[1] - 1, t[2], t[3], t[4], t[5]);
                                                                    jsonData[i].timeseries = d;
                                                                    jsonData[i].value = parseInt(jsonData[i].value);
                                                                    temp += "<tr><td>" + jsonData[i].in + "</td><td>" + jsonData[i].out + "</td><td>" + test + "</td></tr>";
                                                                }

                                                                var ytitle = "Traffic (" + temptrafficscale + ")";
                                                                var xtitle = "Time";
                                                                temp += "</tbody></table>";
                                                                $("#dataContainer").html(temp);
                                                                $('#example2').DataTable({
                                                                    "scrollX": true,
                                                                    fixedHeader: true, dom: 'Blfrtip',
                                                                    buttons: [
                                                                        {
                                                                            extend: 'excelHtml5',
                                                                            title: 'Port Traffic Report'
                                                                        }
                                                                    ],
                                                                    "fnDrawCallback": function () {
                                                                        $("#dataContainer").show();
                                                                        this.api().columns.adjust();
                                                                    }
                                                                });

                                                                $("#dataContainer").hide();
                                                                drawChartLinkTraffic(jsonData, xtitle, ytitle);
                                                            },
                                                            error: function () {
                                                                alert("Error loading report data.");
                                                                $(".loading_sign").hide();
                                                            }
                                                        });
                                                    }

// Helper function to sanitize inputs and prevent XSS
                                                    function sanitizeInput(input) {
                                                        return input.replace(/</g, "&lt;").replace(/>/g, "&gt;").trim();
                                                    }

// Simple date validation function
                                                    function validateDate(date) {
                                                        var regex = /^\d{4}-\d{2}-\d{2}$/; // Simple date format (YYYY-MM-DD)
                                                        return regex.test(date);
                                                    }

// Simple time validation function
                                                    function validateTime(time) {
                                                        var regex = /^\d{2}:\d{2}$/; // Simple time format (HH:MM)
                                                        return regex.test(time);
                                                    }


// Simple date validation function
                                                    function validateDate(date) {
                                                        var regex = /^\d{4}-\d{2}-\d{2}$/; // Simple date format (YYYY-MM-DD)
                                                        return regex.test(date);
                                                    }

// Simple time validation function


                                                    function handleRadio(opt) {
                                                        switch (opt) {
                                                            case "Last Day":
                                                                var today = new Date();
                                                                var dd = today.getDate();
                                                                var mm = today.getMonth() + 1; //January is 0!
                                                                var hh = today.getHours();
                                                                var MM = today.getMinutes();
                                                                var ss = today.getSeconds();
                                                                var yyyy = today.getFullYear();
                                                                if (dd < 10) {
                                                                    dd = '0' + dd
                                                                }
                                                                if (mm < 10) {
                                                                    mm = '0' + mm
                                                                }
                                                                if (hh < 10) {
                                                                    hh = '0' + hh
                                                                }
                                                                if (MM < 10) {
                                                                    MM = '0' + MM
                                                                }
                                                                if (ss < 10) {
                                                                    ss = '0' + ss
                                                                }
                                                                var today = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
                                                                globalEndTime1 = today;


                                                                var today = new Date();
                                                                today.setHours(today.getHours() - 24)
                                                                var dd = today.getDate();
                                                                var mm = today.getMonth() + 1; //January is 0!
                                                                var hh = today.getHours();
                                                                var MM = today.getMinutes();
                                                                var ss = today.getSeconds();
                                                                var yyyy = today.getFullYear();
                                                                if (dd < 10) {
                                                                    dd = '0' + dd
                                                                }
                                                                if (mm < 10) {
                                                                    mm = '0' + mm
                                                                }
                                                                if (hh < 10) {
                                                                    hh = '0' + hh
                                                                }
                                                                if (MM < 10) {
                                                                    MM = '0' + MM
                                                                }
                                                                if (ss < 10) {
                                                                    ss = '0' + ss
                                                                }
                                                                var today = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
                                                                globalStartTime1 = today;

                                                                dateflag = "curr";
                                                                break;
                                                            case "3 Day":
                                                                var today = new Date();
                                                                today.setHours('00');
                                                                today.setMinutes('00');
                                                                today.setSeconds('00');
                                                                var dd = today.getDate();
                                                                var mm = today.getMonth() + 1; //January is 0!
                                                                var hh = today.getHours();
                                                                var MM = today.getMinutes();
                                                                var ss = today.getSeconds();
                                                                var yyyy = today.getFullYear();
                                                                if (dd < 10) {
                                                                    dd = '0' + dd
                                                                }
                                                                if (mm < 10) {
                                                                    mm = '0' + mm
                                                                }
                                                                if (hh < 10) {
                                                                    hh = '0' + hh
                                                                }
                                                                if (MM < 10) {
                                                                    MM = '0' + MM
                                                                }
                                                                if (ss < 10) {
                                                                    ss = '0' + ss
                                                                }
                                                                var today = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
                                                                globalEndTime1 = today;


                                                                var today = new Date();
                                                                today.setHours('00');
                                                                today.setMinutes('00');
                                                                today.setSeconds('00');
                                                                today.setDate(today.getDate() - 3)
                                                                var dd = today.getDate();
                                                                var mm = today.getMonth() + 1; //January is 0!
                                                                var hh = today.getHours();
                                                                var MM = today.getMinutes();
                                                                var ss = today.getSeconds();
                                                                var yyyy = today.getFullYear();
                                                                if (dd < 10) {
                                                                    dd = '0' + dd
                                                                }
                                                                if (mm < 10) {
                                                                    mm = '0' + mm
                                                                }
                                                                if (hh < 10) {
                                                                    hh = '0' + hh
                                                                }
                                                                if (MM < 10) {
                                                                    MM = '0' + MM
                                                                }
                                                                if (ss < 10) {
                                                                    ss = '0' + ss
                                                                }
                                                                var today = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
                                                                globalStartTime1 = today;

                                                                dateflag = "user defined 3 days";
                                                                break;
                                                            case "Weekly":
                                                                var today = new Date();
                                                                today.setHours('00');
                                                                today.setMinutes('00');
                                                                today.setSeconds('00');
                                                                var dd = today.getDate();
                                                                var mm = today.getMonth() + 1; //January is 0!
                                                                var hh = today.getHours();
                                                                var MM = today.getMinutes();
                                                                var ss = today.getSeconds();
                                                                var yyyy = today.getFullYear();
                                                                if (dd < 10) {
                                                                    dd = '0' + dd
                                                                }
                                                                if (mm < 10) {
                                                                    mm = '0' + mm
                                                                }
                                                                if (hh < 10) {
                                                                    hh = '0' + hh
                                                                }
                                                                if (MM < 10) {
                                                                    MM = '0' + MM
                                                                }
                                                                if (ss < 10) {
                                                                    ss = '0' + ss
                                                                }
                                                                var today = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
                                                                globalEndTime1 = today;


                                                                var today = new Date();
                                                                today.setHours('00');
                                                                today.setMinutes('00');
                                                                today.setSeconds('00');
                                                                today.setDate(today.getDate() - 7)
                                                                var dd = today.getDate();
                                                                var mm = today.getMonth() + 1; //January is 0!
                                                                var hh = today.getHours();
                                                                var MM = today.getMinutes();
                                                                var ss = today.getSeconds();
                                                                var yyyy = today.getFullYear();
                                                                if (dd < 10) {
                                                                    dd = '0' + dd
                                                                }
                                                                if (mm < 10) {
                                                                    mm = '0' + mm
                                                                }
                                                                if (hh < 10) {
                                                                    hh = '0' + hh
                                                                }
                                                                if (MM < 10) {
                                                                    MM = '0' + MM
                                                                }
                                                                if (ss < 10) {
                                                                    ss = '0' + ss
                                                                }
                                                                var today = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
                                                                globalStartTime1 = today;

                                                                dateflag = "Weekly";
                                                                break;
                                                            case "Monthly":
                                                                var today = new Date();

                                                                var dd = today.getDate();
                                                                var mm = today.getMonth() + 1; //January is 0!
                                                                var hh = today.getHours();
                                                                var MM = today.getMinutes();
                                                                var ss = today.getSeconds();
                                                                var yyyy = today.getFullYear();
                                                                if (dd < 10) {
                                                                    dd = '0' + dd
                                                                }
                                                                if (mm < 10) {
                                                                    mm = '0' + mm
                                                                }
                                                                if (hh < 10) {
                                                                    hh = '0' + hh
                                                                }
                                                                if (MM < 10) {
                                                                    MM = '0' + MM
                                                                }
                                                                if (ss < 10) {
                                                                    ss = '0' + ss
                                                                }
                                                                var today = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
                                                                globalEndTime1 = today;


                                                                var today = new Date();

                                                                today.setMonth(today.getMonth() - 1);
                                                                var dd = today.getDate();
                                                                var mm = today.getMonth() + 1; //January is 0!
                                                                var hh = today.getHours();
                                                                var MM = today.getMinutes();
                                                                var ss = today.getSeconds();
                                                                var yyyy = today.getFullYear();
                                                                if (dd < 10) {
                                                                    dd = '0' + dd
                                                                }
                                                                if (mm < 10) {
                                                                    mm = '0' + mm
                                                                }
                                                                if (hh < 10) {
                                                                    hh = '0' + hh
                                                                }
                                                                if (MM < 10) {
                                                                    MM = '0' + MM
                                                                }
                                                                if (ss < 10) {
                                                                    ss = '0' + ss
                                                                }
                                                                var today = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
                                                                globalStartTime1 = today;

                                                                dateflag = "Monthly";
                                                                break;
                                                        }
                                                    }

        </script>

    </body>
</html>