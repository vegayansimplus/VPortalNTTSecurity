<%-- 
    Document   : node-dashboard
    Created on : 31 Mar, 2025, 4:05:09 PM
    Author     : lapto
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<%
   <%
    response.setHeader("X-Content-Type-Options", "nosniff");
    response.setHeader("X-XSS-Protection", "1; mode=block");
    response.setHeader("X-Frame-Options", "SAMEORIGIN");
    response.setHeader("Content-Security-Policy", "script-src 'self';");
    response.setHeader("Content-Security-Policy", "frame-src 'self';"); 
%>
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
<html lang="en">

    <head>
        <jsp:include page="../common/CommonHeader.jsp"/>
        <jsp:include page="../common/user-header.jsp"/>
        <link href="https://gitcdn.github.io/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../assets/css/morris.css" />
        <link rel="stylesheet" href="../assets/admin/css/bootstrap.min.css">
        <link rel="stylesheet" href="../assets/css/font-awesome.min.css">
        <title>Dashboard</title>
        <link rel="icon" href="../assets/images/vsicon.png" type="image/x-icon" />
        <style>
            body{
                overflow: hidden;
                height:100vh;
                width: 100vw;
                font-size: 12px;
            }
            .row-eq-height{
                display: -webkit-box;
                display: -webkit-flex;
                display: -ms-flexbox;
                display: flex;
                margin-left: 5px;
                margin-right: 5px;
                height: 260px;
            }
            .shadow1{
                box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0), 0 2px 10px 0 rgba(0,0,0,0.22);
                margin-right: 10px;
                margin-left: 10px;
                border-radius:5px;
                padding-left: 0px;
                padding-right: 0px;
                width: calc(99%/1);
            }
            .interfaceStats{
                height:80px;
                background-color:#b71d4b !important;
                color:white;
            }
            span.fa {
                font-size: 30px;
                padding-top: 10px;
                text-align: -webkit-center;
                width: 100%;
                padding-left: 10px;
            }
            #tableTitle {
                font-weight: bold;
                color: #222;
                padding: 25px 25px;
                padding-bottom: 0px;
                text-align: left;
            }
            #vegaGrad {
                margin-right: 0px !Important;
                margin-left: 0px !Important;
                color: white;
                background: #4a148c; /* For browsers that do not support gradients */
                /*                background: -webkit-linear-gradient(left, rgb(183, 29, 76) , rgb(112, 0, 52));  For Safari 5.1 to 6.0 
                                background: -o-linear-gradient(right, rgb(183, 29, 76), rgb(112, 0, 52));  For Opera 11.1 to 12.0 
                                background: -moz-linear-gradient(right, rgb(183, 29, 76), rgb(112, 0, 52));  For Firefox 3.6 to 15 
                                background: linear-gradient(to right, rgb(183, 29, 76) , rgb(112, 0, 52));  Standard syntax (must be last) */
            }
            .tbhover{
                cursor:pointer;
            }
            .tooltip-inner {
                max-width: 390px;
                padding: 3px 8px;
                color: #fff;
                text-align: center;
                background-color: #000;
                border-radius: 4px;
                margin-left: -1em;
                z-index: 999;

            }
            .row-eq-height {
                display: -webkit-box;
                display: -webkit-flex;
                display: -ms-flexbox;
                display: flex;
            }
            .toolti p {

                letter-spacing: normal !important ;
                word-break: break-word !important ;
                word-spacing: normal !important ;
                word-wrap: break-word !important ;

            }


            table tr:first-child [data-tooltip]:hover:after {
                bottom: -60%;
                right: 170%;
            }
            table tr:first-child [data-tooltip]:hover:before {
                bottom: -35%;
                right: 140%;
                border-left: 20px solid orangered;
                border-top: 2px solid transparent;
                border-bottom: 18px solid transparent;
            }


            table.dataTable tbody th, table.dataTable tbody td {
                padding: 0px 10px !important;
                font-size: 12px;
            }
            /*.dataTables_info {
                display: none;
            }*/

            #placeholder {
                width: 150px;
                height: 256.5px;
            }
            #placeholder1 {
                width: 150px;
                height: 256px;
            }
            #placeholder2 {
                width: 150px;
                height: 256.5px;
            }
            #placeholder3 {
                width: 150px;
                height: 256.5px;
            }
            div#myModal1 {
                top: 27em;
            }
            div#pieModel {
                top: 27em;
            }

            .widget-box {
                padding: 0px;
                cursor: pointer;
                height: 120px;
                color: white !Important;
                -webkit-border-radius: 5px;
                border-radius: 5px;
                -moz-border-radius: 5px;
                background-clip: padding-box;
                margin-top: 10px;
                background-color: rgba(255, 255, 255, 0.2);
                -webkit-box-shadow: 0 8px 6px -6px black;
                -moz-box-shadow: 0 8px 6px -6px black;
                box-shadow: 0 8px 6px -6px black;
            }
            .CounterText span {
                font-size: 20px;
                display: block;
            }
            .col-md-6.CounterText {
                font-size: 12px;
                display: block;
            }
            .col-md-12.CounterText {
                text-align: -webkit-center;
                padding-bottom:7px;
            }
            .icot {
                text-align: -webkit-center !Important;
                font-size: 60px;
            }
            thead {
                background-color: #990033;
                color: white;
                font-size: 14PX !IMPORTANT;
            }

            .table-bordered>tbody>tr>td, .table-bordered>tbody>tr>th, .table-bordered>tfoot>tr>td, .table-bordered>tfoot>tr>th, .table-bordered>thead>tr>td, .table-bordered>thead>tr>th {
                border-bottom: 0px solid #ddd;
                border-left: 1px solid #ddd;
                /* padding: 10px !important; */
            }


            table.dataTable.compact thead th, table.dataTable.compact thead td {
                padding: 4px 17px 4px 4px;
                font-weight: 500;
                font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
            }
            table.dataTable tbody th, table.dataTable tbody td {
                padding: 0px 10px !important;
                font-size: 12px;

            }

            body{
                background-color: #F3F3F5;
                /*background-color: #aaeeff;*/
            }
            .text1{
                font-size: 20px;
                margin-top:5px;
            }
            .c3-legend-item text {
                fill: white;
            }
            .c3 path, .c3 line, .tick text {
                stoke: white;
            }
            g.tick {
                fill: white;
            }
            g.c3-axis {
                fill: white;
            }
            hr{
                margin-top: 5px;
                margin-bottom: 5px;
            }

            .card {
                border-radius: 5px;
                -webkit-box-shadow: 0 1px 2.94px 0.06px rgba(4,26,55,.16);
                box-shadow: 0 1px 2.94px 0.06px rgba(4,26,55,.16);
                border: 0;
                margin-bottom: 10px;
                -webkit-transition: all .3s ease-in-out;
                transition: all .3s ease-in-out;
            }

            .card {
                position: relative;
                display: -ms-flexbox;
                display: flex;
                width: 22rem;
                -ms-flex-direction: column;
                flex-direction: column;
                min-width: 0;
                word-wrap: break-word;
                background-color: #004d40;
                background-clip: border-box;
                border: 1px solid rgba(0,0,0,.125);
                border-radius: .25rem;
            }
            .card1 {
                position: relative;
                display: -ms-flexbox;
                display: flex;
                width: 22rem;
                -ms-flex-direction: column;
                flex-direction: column;
                min-width: 0;
                word-wrap: break-word;
                background-color: #b71d4b;
                background-clip: border-box;
                border: 1px solid rgba(0,0,0,.125);
                border-radius: .25rem;
            }
            .card .card-block {
                padding: 3px 30px;
                min-height: 135px;
            }
            .m-b-20 {
                /*margin-bottom: 20px;*/
                text-align: center;
                letter-spacing: 0.5px;
                font-weight: normal;
                font-size: 14px;
                color:#fff;
                /* width: 174px; */
                /* text-decoration: underline; */
            }
            .card .card-block p {
                line-height: 1.4;
            }
            .f-right {
                float: right;
            }
            .order-card {
                height:64px;
                color: black;

            }
            .card .fa {
                padding-top: 0px;
                text-align: left;
                width: auto;
                padding-left: 0px;
                float: left;
                font-size: 26px;
            }
            div#tableDivSection {
                padding: 25px;
            }
            #tableTitle{
                font-weight: bold;
                color: #222;
            }

            span.fa.fa-eye {
                font-size: 13px;
                position: absolute;
                right: 5px;
                padding-top: 1px;
                cursor: pointer;
                color: white;
                transition: all 0.1s ease-in;
                border: 1px solid white;
                border-radius: 100%;
                height: 18px;
                padding-left: 1.5px;
                width: 18px;
                background: black;
            }
            span.fa.fa-eye:hover {
                color: black;
                background: white;
                border: 1px solid black;
            }
            div#tableDivSections {
                padding: 20px;
            }



            /* Absolute Center Spinner */
            .loading {
                position: fixed;
                z-index: 999;
                height: 2em;
                width: 2em;
                overflow: show;
                margin: auto;
                top: 0;
                left: 0;
                bottom: 0;
                right: 0;
            }

            /* Transparent Overlay */
            .loading:before {
                content: '';
                display: block;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.7);
            }

            /* :not(:required) hides these rules from IE9 and below */
            .loading:not(:required) {
                /* hide "loading..." text */
                font: 0/0 a;
                color: transparent;
                text-shadow: none;
                background-color: transparent;
                border: 0;
            }

            .loading:not(:required):after {
                content: '';
                display: block;
                font-size: 10px;
                width: 1em;
                height: 1em;
                margin-top: -0.5em;
                -webkit-animation: spinner 1500ms infinite linear;
                -moz-animation: spinner 1500ms infinite linear;
                -ms-animation: spinner 1500ms infinite linear;
                -o-animation: spinner 1500ms infinite linear;
                animation: spinner 1500ms infinite linear;
                border-radius: 0.5em;
                -webkit-box-shadow: rgba(0, 0, 0, 0.75) 1.5em 0 0 0, rgba(0, 0, 0, 0.75) 1.1em 1.1em 0 0, rgba(0, 0, 0, 0.75) 0 1.5em 0 0, rgba(0, 0, 0, 0.75) -1.1em 1.1em 0 0, rgba(0, 0, 0, 0.5) -1.5em 0 0 0, rgba(0, 0, 0, 0.5) -1.1em -1.1em 0 0, rgba(0, 0, 0, 0.75) 0 -1.5em 0 0, rgba(0, 0, 0, 0.75) 1.1em -1.1em 0 0;
                box-shadow: rgba(0, 0, 0, 0.75) 1.5em 0 0 0, rgba(0, 0, 0, 0.75) 1.1em 1.1em 0 0, rgba(0, 0, 0, 0.75) 0 1.5em 0 0, rgba(0, 0, 0, 0.75) -1.1em 1.1em 0 0, rgba(0, 0, 0, 0.75) -1.5em 0 0 0, rgba(0, 0, 0, 0.75) -1.1em -1.1em 0 0, rgba(0, 0, 0, 0.75) 0 -1.5em 0 0, rgba(0, 0, 0, 0.75) 1.1em -1.1em 0 0;
            }

            /* Animation */

            @-webkit-keyframes spinner {
                0% {
                    -webkit-transform: rotate(0deg);
                    -moz-transform: rotate(0deg);
                    -ms-transform: rotate(0deg);
                    -o-transform: rotate(0deg);
                    transform: rotate(0deg);
                }
                100% {
                    -webkit-transform: rotate(360deg);
                    -moz-transform: rotate(360deg);
                    -ms-transform: rotate(360deg);
                    -o-transform: rotate(360deg);
                    transform: rotate(360deg);
                }
            }
            @-moz-keyframes spinner {
                0% {
                    -webkit-transform: rotate(0deg);
                    -moz-transform: rotate(0deg);
                    -ms-transform: rotate(0deg);
                    -o-transform: rotate(0deg);
                    transform: rotate(0deg);
                }
                100% {
                    -webkit-transform: rotate(360deg);
                    -moz-transform: rotate(360deg);
                    -ms-transform: rotate(360deg);
                    -o-transform: rotate(360deg);
                    transform: rotate(360deg);
                }
            }
            @-o-keyframes spinner {
                0% {
                    -webkit-transform: rotate(0deg);
                    -moz-transform: rotate(0deg);
                    -ms-transform: rotate(0deg);
                    -o-transform: rotate(0deg);
                    transform: rotate(0deg);
                }
                100% {
                    -webkit-transform: rotate(360deg);
                    -moz-transform: rotate(360deg);
                    -ms-transform: rotate(360deg);
                    -o-transform: rotate(360deg);
                    transform: rotate(360deg);
                }
            }
            @keyframes spinner {
                0% {
                    -webkit-transform: rotate(0deg);
                    -moz-transform: rotate(0deg);
                    -ms-transform: rotate(0deg);
                    -o-transform: rotate(0deg);
                    transform: rotate(0deg);
                }
                100% {
                    -webkit-transform: rotate(360deg);
                    -moz-transform: rotate(360deg);
                    -ms-transform: rotate(360deg);
                    -o-transform: rotate(360deg);
                    transform: rotate(360deg);
                }
            }
            .shadow{
                margin-left: -2rem;
                width: 116rem;
                background: ghostwhite;
                height: 20rem;
            }
            .dataTables_info{
                display: none;
            }
            .customized-scrollbar::-webkit-scrollbar {
                width: 5px;
                height: 8px;
                background-color: #aaa;
            }
            .form-group {
                display: flex;
                flex-direction: row;
                justify-content: center;
                align-items: center;
            }
            .cardvalue{
                text-align: center;
                color:#fff;

            }
            .interfacecard{
                background-color: black;
                height: 24rem;
                border: 1px solid white;
                margin: 2px;
                width: 49%;
                margin-bottom: 10px;
                color:#fff;
            }
            .example{
                background: #000;
            }
            #chart{
                margin-left:-4rem;
            }
            .c3-legend-item text{
                fill:white;
            }
            .container-fluid{
                width: calc(100%/1);
            }
            .pageHeading{
                text-align: center;
                font-size: 14px;
                font-weight: 600;
                margin: 1vh;
                color:#fff;
            }
            tr{
                height:0px !important;
            }
            #chart{
                margin-left:-2rem;
            }
            .c3 line, .c3 path {
                fill: none;
                stroke: #fff;
            }
            .c3-tooltip-container {
                color:black;
            }

        </style>
    </head>
    <body data-sidebar="dark" style="background-color: black;">
        <jsp:include page="../common/usermenu.jsp"/>
        <div class="main-content">
            <div class="page-content">
                <div class="container-fluid">
                    <div class="loading">Loading&#8230;</div>
                    <div class="col-md-12 pageHeading"> Node Dashboard</div>

                    <div class="row row-eq-height" style="height:60px;margin-left: -2rem;margin-top: -2rem;">
                        <div class="form-group col-md-4" style="width: 38rem;"><label style="width: 10rem;color:#fff">Group Name:</label><select class="form-control" id="groupname" onchange="getRouterType();" style="height:30px;display: inline-flex"></select></div>
                        <div class="form-group col-md-4" style="width: 38rem;"> <label style="width: 10rem;color:#fff">Device Type:</label><select class="form-control" id="devicetype" onchange="getNodeIP();" style="height:30px;display: inline-flex"></select></div>
                        <div class="form-group col-md-4" style="width: 38rem;"><label style="width: 8rem;color:#fff">Node IP:</label><select class="form-control" id="nodeip"  onchange="getNodeReport()" style="height:30px;display: inline-flex"></select></div>
                    </div>
                    <div class="row" style="margin-left: -32px;margin-top:-1rem;">
                        <div class="col-lg-2">
                            <div class="card1 order-card">
                                <div class="card-block">
                                    <h6 class="m-b-20">Node Status</h6>
                                    <div class="cardvalue status">Up</div>
                                </div>
                            </div>    
                        </div>
                        <div class="col-lg-2" style="margin-left:4rem">
                            <div class="card1 order-card">
                                <div class="card-block">
                                    <h6 class="m-b-20">Alarms</h6>
                                    <div class="cardvalue alaram">0</div>
                                </div>
                            </div>    
                        </div>
                        <div class="col-lg-2" style="margin-left:4rem">
                            <div class="card1 order-card">
                                <div class="card-block">
                                    <h6 class="m-b-20">CPU</h6>
                                    <div class="cardvalue cpu">0</div>
                                </div>
                            </div>   
                        </div>
                        <div class="col-lg-2" style="margin-left:4rem">
                            <div class="card1 order-card">
                                <div class="card-block">
                                    <h6 class="m-b-20">Temp</h6>
                                    <div class="cardvalue temp">0</div>
                                </div>
                            </div>   
                        </div>
                        <div class="col-lg-2" style="margin-left:3rem">
                            <div class="card1 order-card">
                                <div class="card-block">
                                    <h6 class="m-b-20">Memory</h6>
                                    <div class="cardvalue memory">0</div>
                                </div>
                            </div>   
                        </div>

                    </div>
                    <div class="col-md-12" style="margin-left: -20px;padding:0;width: calc(104%);">
                        <div class="col-md-6 interfacecard">
                            <div class="col-md-12 interfacecardtitle">Interface Utilization</div>
                            <div class="example row_counter"></div>
                        </div>
                        <div class="col-md-6 interfacecard">
                            <div class="col-md-12 interfacecardtitle">Interface Graph</div> 
                            <div class="batmans" ></div>

                        </div>
                    </div>
                    <div class="row" style="margin-left: -32px;margin-top:3px;">
                        <div class="col-lg-4">
                            <div class="card  order-card  bg-c-blue" style="width: 38rem;height:65px;">
                                <div class="card-block">
                                    <h6 class="m-b-20">Host Name</h6>
                                    <div class="cardvalue hostname">0</div>
                                </div>
                            </div>    
                        </div>
                        <div class="col-lg-4">
                            <div class="card order-card bg-c-green" style="width: 38rem;height:65px;">
                                <div class="card-block">
                                    <h6 class="m-b-20">OS Version </h6>
                                    <div class="cardvalue version">0</div>
                                </div>
                            </div>    
                        </div>
                        <div class="col-lg-4">
                            <div class="card  order-card bg-c-yellow" style="width: 37rem;height:65px;">
                                <div class="card-block">
                                    <h6 class="m-b-20">Firmware Version</h6>
                                    <div class="cardvalue firmware">0</div>
                                </div>
                            </div>   
                        </div>

                    </div>
                    <div class="row" style="margin-left: -32px;margin-top:-5px;">
                        <div class="col-lg-4">
                            <div class="card order-card bg-c-blue" style="width: 38rem;height:65px;">
                                <div class="card-block">
                                    <h6 class="m-b-20">AMC End Date</h6>
                                    <div class="cardvalue amc">0</div>
                                </div>
                            </div>    
                        </div>
                        <div class="col-lg-4">
                            <div class="card order-card bg-c-green" style="width: 38rem;height:65px;">
                                <div class="card-block">
                                    <h6 class="m-b-20">Last Config Change</h6>
                                    <div class="cardvalue config">0</div>
                                </div>
                            </div>    
                        </div>
                        <div class="col-lg-4">
                            <div class="card order-card bg-c-yellow" style="width: 37rem;height:65px;">
                                <div class="card-block">
                                    <h6 class="m-b-20">Compliance</h6>
                                    <div class="cardvalue compliance">0</div>
                                </div>
                            </div>   
                        </div>



                    </div>

                </div>
            </div>
        </div>
        <jsp:include page="../common/user-footer.jsp"/>
        <script src="../assets/js/jquery.flot.js"></script>
        <script src="../assets/js/jquery.flot.pie.js"></script>
        <script src="https://gitcdn.github.io/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js"></script>
        <script rel="stylesheet" href="../assets/js/bootstraptoggle.js"></script>
        <script>
                            var interfacename = "";
                            $(document).ready(function () {
                                $('.loading').hide();
                                $('.shrink-btn').trigger("click");
                                getGroupName();
                                $("#groupname").select2();
                                $("#devicetype").select2();
                                $("#nodeip").select2();
                                getNodeReport();

                            });
                            function getGroupName() {
                                $.ajax({
                                    type: "POST",
                                    url: "../UserFilters",
                                    data: {requestType: "1"},
                                    dataType: "json",
                                    success: function (data) {
                                        $("#groupname").html('<option value = "">Select Group Name</option>');
                                        for (var i = 0; i < data.length; i++) {
                                            $("#groupname").append('<option value = "' + data[i] + '">' + data[i] + '</option>');
                                        }
                                        $("#groupname").select2();
                                    },
                                    error: function (xhr, status, text) {
                                    }
                                });
                            }
                            function getRouterType() {
                                var groupName = $('#groupname').val();
                                $.ajax({
                                    type: "POST",
                                    url: "../UserFilters",
                                    data: {requestType: "2", groupName: groupName},
                                    dataType: "json",
                                    success: function (data) {
                                        console.log(data);
                                        $("#devicetype").html('<option value = "">Select device Type</option>');
                                        for (var i = 0; i < data.length; i++) {
                                            $("#devicetype").append('<option value = "' + data[i] + '">' + data[i] + '</option>');
                                        }
                                        $("#devicetype").select2();
                                    },
                                    error: function (xhr, status, text) {

                                    }
                                });
                            }
                            function getNodeIP() {
                                var groupName = $('#groupname').val();
                                var deviceType = $("#devicetype").val();
                                $.ajax({
                                    type: "POST",
                                    url: "../UserFilters",
                                    data: {requestType: "4", groupName: groupName, deviceType: deviceType},
                                    dataType: "json",
                                    success: function (data) {
                                        console.log(data);
                                        $("#nodeip").html('<option value = "">Select Node IP</option>');
                                        for (var i = 0; i < data.length; i++) {
                                            $("#nodeip").append('<option value = "' + data[i] + '">' + data[i] + '</option>');
                                        }
                                        $("#nodeip").select2();
                                    },
                                    error: function (xhr, status, text) {

                                    }
                                });
                            }
                            function getNodeReport() {
                                getNodeHealth();
                                getInterfaceTable();
                                getbottomNodeHealth();

                            }
                            function getNodeHealth()
                            {
                                var nodeip = $("#nodeip").val();
                                if ($("#nodeip").val() === null) {
                                    nodeip = "10.121.0.40";
                                }
                                $.ajax({
                                    type: "POST",
                                    url: "../NodeDashboard",
                                    data: {requestType: "1", nodeip: nodeip},
                                    dataType: "json",
                                    success: function (data) {

                                        $('.status').html(data[0]);
                                        $('.alaram').html(data[1]);
                                        $(".cpu").html(data[2]);
                                        $(".temp").html(data[3]);
                                        $(".memory").html(data[4]);
                                    }
                                });
                            }
                            function getInterfaceTable() {
                                var nodeip = $("#nodeip").val();
                                if ($("#nodeip").val() === null) {
                                    nodeip = "10.121.0.40";
                                }
                                $(".example").html('<table id="example" class="table compact table-striped table-bordered" cellspacing="0" width="100%"></table>');
                                $.ajax({
                                    type: "POST",
                                    url: "../NodeDashboard",
                                    data: {requestType: "2", nodeip: nodeip},
                                    dataType: "json",
                                    success: function (data) {
                                        for (var i = 0; i < 1; i++)
                                        {
                                            if (data == "") {

                                            } else {
                                                interfacename = data[i][0];
                                                accumulateChartData();
                                            }

                                        }
                                        console.log("interfacename:" + interfacename);

                                        $('#example').DataTable({
                                            data: data,
                                            paging: false,
                                            searching: false,
                                            "info": false,
                                            scrollY: '29.9vh',
                                            columns: [
                                                {title: "Interface Name"},
                                                {title: "Status"},
                                                {title: "In"},
                                                {title: "Out"}
                                            ]
                                        });
                                        $("#example tbody").css('cursor', 'pointer');
                                        $('#example tbody').on('click', 'tr', function () {
                                            interfacename = $('#example').DataTable().row(this).data()[0];
                                            accumulateChartData();
                                        });
                                    }

                                });
                            }


                            function getbottomNodeHealth()
                            {
                                var nodeip = $("#nodeip").val();
                                if ($("#nodeip").val() === null) {
                                    nodeip = "10.121.0.40";
                                }
                                $.ajax({
                                    type: "POST",
                                    url: "../NodeDashboard",
                                    data: {requestType: "4", nodeip: nodeip},
                                    dataType: "json",
                                    success: function (data) {
                                        $('.hostname').html(data[0][0]);
                                        $('.version').html(data[0][1]);
                                        $(".firmware").html(data[0][2]);
                                        $(".amc").html(data[0][3]);
                                        $(".config").html(data[0][4]);
                                        $(".compliance").html(data[0][5]);
                                    }
                                });
                            }
                            function accumulateChartData()
                            {
                                var nodeip = $("#nodeip").val();
                                if ($("#nodeip").val() === null) {
                                    nodeip = "10.121.0.40";
                                }
                                $.ajax({
                                    type: "POST",
                                    url: "../NodeDashboard",
                                    data: {requestType: "3", nodeip: nodeip, interfacename: interfacename},
                                    dataType: "json",
                                    success: function (data) {
                                        $(".batmans").html("<div id='chart' ></div>");
                                        console.log("Chart data");
                                        console.log(data);
                                        var temp = "<table id='example2' class='display compact cell-border' cellspacing='0'  width='100%'><thead><tr><th>In</th><th>Out</th><th>Time</th></tr></thead><tbody>";
                                        var jsonData = data;
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
                                            temp = temp + "<tr><td>" + jsonData[i].in + "</td><td>" + jsonData[i].out + "</td><td>" + test + "</td></tr>";
                                        }
                                        temp = temp + "</tbody></table>";


                                        drawMainChart(jsonData);

                                    }
                                });
                            }
                            function drawMainChart(json_data) {
                                //console.log(json_data);
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
                                                    return  d.getDate() + "-" + (d.getMonth() + 1) + "-" + d.getUTCFullYear() + "   " + d.getHours() + ":" + mins;
                                                },
                                                fit: true,
                                                culling: {
                                                    max: 5
                                                }
                                            },
                                            label: {
                                                text: 'Time',
                                                position: 'outer-center'
                                            }
                                        },
                                        y: {
                                            tick: {
                                                format: d3.format('.2f'),
                                                count: 8
                                            },
                                            label: {
                                                text: "Traffic in Mbps",
                                                position: 'outer-middle'
                                            }
                                        }
                                    },
                                    color: {
                                        pattern: ['#1F77B4', '#C4A35A', '#4CAF50', '#673AB7', '#3F51B5', '#2196F3', '#03A9F4', '#00BCD4', '#009688', '#4CAF50', '#8BC34A', '#CDDC39', '#FFEB3B', '#FFC107', '#FF9800', '#FF5722']
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
                                    }, size: {
                                        height: 220,
                                        width: 560
                                    },
                                });

                            }

        </script>

    </body>

</html>    