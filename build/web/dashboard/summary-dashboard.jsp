<%-- 
    Document   : summary-dashboard
    Created on : 31 Mar, 2025, 3:54:05 PM
    Author     : lapto
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
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
            System.out.println("role:"+role);
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
            .tbhover{
                cursor:pointer;
            }
            thead {
                background-color: #990033;
                color: white;
                font-size: 14PX !IMPORTANT;
            }

            .table-bordered>tbody>tr>td, .table-bordered>tbody>tr>th, .table-bordered>tfoot>tr>td, .table-bordered>tfoot>tr>th, .table-bordered>thead>tr>td, .table-bordered>thead>tr>th {
                border-bottom: 0px solid #ddd;
                border-left: 1px solid #ddd;
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
            thead {
                background-color: #b71d4b;
                color: white;
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
            .row-eq-height{
                display: -webkit-box;
                display: -webkit-flex;
                display: -ms-flexbox;
                display: flex;
                margin-left: 5px;
                margin-right: 5px;
            }
            .container-fluid{
                width: calc(100%/1);
            }
            .page-content{
                padding:0 !important;
            }
            tr{
                height:0px !important;
            }
            tbody {
                cursor:initial !important;
            }
            .pageHeading{
                text-align: center;
                font-size: 13px;
                margin: 1vh;
                color:#000;
            }
            .card {
                position: relative;
                display: flex;
                flex-direction: column;
                min-width: 0;
                word-wrap: break-word;
                background-color: #fff;
                background-clip: border-box;
                border: 1px solid #e3e3e3;
                border-radius: 20px;
            }
            .card {
                box-shadow: none;
                -webkit-box-shadow: none;
                -moz-box-shadow: none;
                -ms-box-shadow: none;
                transition: background 0.25s ease;
                -webkit-transition: background 0.25s ease;
                -moz-transition: background 0.25s ease;
                -ms-transition: background 0.25s ease;
                border: none;
                box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0), 0 2px 10px 0 rgba(0,0,0,0.22);
            }
            .card.card-tale {
                background: #b71d4b !important;
                color: #ffffff;
            }
            .card-body {
                flex: 1 1 auto;
                padding: 1rem 1rem;
                text-align: center;
            }
            .mb-4 {
                margin-bottom: 0.5rem !important;
            }
            .fs-30 {
                font-size: 20px;
                font-weight: 600;
            }
            .mb-2 {
                margin-bottom: 0.5rem !important;
            }
            p {
                font-size: 12px;
                font-weight: 500;
                line-height: 1.3rem;
            }
            .pr-0{
                padding-right: 0;
            }
            .nodecard{
                width: calc(50% - 6px);
                height: 4rem;
                padding: 6px;
                margin:3px;
                color:black;
                background-color: #fff;
                border-radius: 5px;
                text-align: center;
                display: inline-flex;
                cursor: pointer;
                -webkit-box-shadow: 0px 6px 8px 1px rgb(0 0 0 / 14%);
                -moz-box-shadow: 0px 6px 8px 1px rgba(0,0,0,0.14);
            }
            .panboxvalue{
                width: calc(48%);
                background: white;
                border-radius: 5px;
                -webkit-box-shadow: 0px 6px 8px 1px rgb(0 0 0 / 14%);
                -moz-box-shadow: 0px 6px 8px 1px rgba(0,0,0,0.14);
                padding:6px;
                margin:1px;
                cursor:pointer;
            }
            .valueofbox{
                color:black;
            }
            .cardblog{
                position: relative;
                display: flex;
                flex-direction: column;
                min-width: 0;
                word-wrap: break-word;
                background-clip: border-box;
                border: 1px solid #e3e3e3;
                border-radius: 20px;
            }
            .cellElements{
                text-align: center;
                padding-top: 0.1vh;
                padding-bottom: 0.1vh;
            }
            .cellElements1{
                text-align: center;
                padding-top: 1.1vh;
                padding-bottom: 1.1vh;
            }
            .cellElements2{
                padding-top: 1.1vh;
                padding-bottom: 1.1vh;
            }
            .blockDiv{
                margin-top: -1rem;
                border: 1px solid #ccc;
                height: 65vh;
                border-radius: 5px;
            }
            .blockDiv::-webkit-scrollbar {
                width: 6px;
                height: 6px;
                background-color: #F5F5F5;
            }
            .blockDiv::-webkit-scrollbar-thumb {
                background-color: #777;
                border-radius: 10px;
            }
            .blockDiv::-webkit-scrollbar-track {
                -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
                background-color: #F5F5F5;
                border-radius: 10px;
            }
            .card-basic1{
                background-color: #004d40;
                color:white;
                font-weight: 600;
            }
            .card-basic{
                background-color: #e3e0e1;
                color:#333;
                font-weight: 600;
            }
            .blockHeader{
                text-align: center;
                padding: 3px;
                font-size: 13px;
                font-weight: 600;
                color:#eee;
                text-decoration: underline;
                text-underline-position: from-font;
            }
            .cellElementsContent{
                text-align: center;
                cursor: pointer;
                width: 100%;
                margin: 2px;
                font-size: 10px;
                border-radius: 5px;
                padding: 1px;
                display: block;
                -webkit-box-shadow: 0px 6px 8px 1px rgb(0 0 0 / 14%);
                color: black;
                font-weight: 500;
            }
            .cellElementsContent3{
                height: 3rem;
                text-align: center;
                cursor: pointer;
                width: 100%;
                margin: 2px;
                font-size: 10px;
                border-radius: 5px;
                padding: 10px;
                display: block;
                -webkit-box-shadow: 0px 6px 8px 1px rgb(0 0 0 / 14%);
                color: black;
                font-weight: 500;
            }
            .cellElementsContent1{
                height: 3rem;
                text-align: center;
                cursor: pointer;
                width: 100%;
                margin: 2px;
                font-size: 10px;
                border-radius: 5px;
                padding: 10px;
                display: block;
                -webkit-box-shadow: 0px 6px 8px 1px rgb(0 0 0 / 14%);
                color: white;
                font-weight: 500;
            }
            .barblock{
                border:1px solid white;
                border-radius: 5px;
                -webkit-box-shadow: 0px 6px 8px 1px rgb(0 0 0 / 14%);
                -moz-box-shadow: 0px 6px 8px 1px rgba(0,0,0,0.14);
                padding:10px;
            }
            thead {
                background-color: #990033;
                color: white;
                font-size: 14PX !IMPORTANT;
            }
            .table-bordered>tbody>tr>td, .table-bordered>tbody>tr>th, .table-bordered>tfoot>tr>td, .table-bordered>tfoot>tr>th, .table-bordered>thead>tr>td, .table-bordered>thead>tr>th {
                border-bottom: 0px solid #ddd;
                border-left: 1px solid #ddd;
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
            .card-red{
                background-color: #ff471a;
                font-weight: 600;
            }
            .tick text {
                stroke: black;
            }
            .c3-axis-x text
            {
                font-size: 6px;
                font-weight: 100;
            }
            .c3-axis-y text
            {
                font-size: 6px;
                font-weight: 100;
            }
            .c3-axis-x{
                color:black;
            }
            .c3-axis-y{
                color:black;
            }
            .tick text {
                stroke: #000;
                font-size: 7px;
                font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";
            }
            .c3-tooltip-container {
                color: black;
                z-index: 10;
            }
            .c3 path, .c3 line {
                fill: none;
                stroke: black;
            }
            text.c3-text{
                font-size: 11px;
            }
            .blockheading{
                color:black;
                text-align: center;
            }
            .blockheader{
                color:white;
            }
            .circlediv{
                background-color: #004d40;
                color:white;
                font-weight: 500;
            }
            .shadow{
                box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0), 0 2px 10px 0 rgba(0,0,0,0.22);
                width: 68rem;
                margin-right: 5px;
                margin-left: 5px;
                border-radius:5px;
            }
            .cardHeader{
                /*background-color: #EAECC6;*/
                background-color: #c8e6c9;
                color:black;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
            }









        </style>
    </head>
    <body data-sidebar="dark" style="background:ghostwhite;">
        <jsp:include page="../common/usermenu.jsp"/>
        <div class="main-content">
            <div class="page-content">
                <div class="container-fluid">

                    <div class="col-md-12 pageHeading">
                        <div class="col-md-4" style="display: flex;">
                            <div class="col-md-6"></div>

                        </div>
                        <div class="col-md-4">Network Summary Dashboard</div>
                        <div class="col-md-4" style="display: flex;">

                        </div>

                    </div>
                    <div class="col-md-12">
                        <div class="col-md-3 pr-0">
                            <div class="card card-tale">
                                <div class="card-body">
                                    <p class="mb-4">Total Nodes</p>
                                    <div class="col-md-12" style="padding:4px;">
                                        <div class="col-md-6 totaldown">Total</div>
                                        <div class="col-md-6 totaldown">Down</div>

                                    </div>
                                    <div class="col-md-12">
                                        <div class="col-md-6 panboxvalue" onclick="getTabList('Total')"><div class="total valueofbox">0000</div></div>
                                        <div class="col-md-6 panboxvalue" onclick="getTabList('Down')"><div class="down valueofbox">0000</div></div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 pr-0">
                            <div class="card card-tale">
                                <div class="card-body">
                                    <p class="mb-4">BackBone Nodes</p>
                                    <div class="col-md-12" style="padding:4px;">
                                        <div class="col-md-6 totaldown">Total</div>
                                        <div class="col-md-6 totaldown">Down</div>

                                    </div>
                                    <div class="col-md-12">
                                        <div class="col-md-6 panboxvalue" onclick="getTabList('Total_BackBone')"><div class="backbonetotal valueofbox">0000</div></div>
                                        <div class="col-md-6 panboxvalue" onclick="getTabList('Down_BackBone')"><div class="backbonedown valueofbox">0000</div></div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 pr-0">
                            <div class="card card-tale">
                                <div class="card-body">
                                    <p class="mb-4">Customer Nodes</p>
                                    <div class="col-md-12" style="padding:4px;">
                                        <div class="col-md-6 totaldown">Total</div>
                                        <div class="col-md-6 totaldown">Down</div>

                                    </div>
                                    <div class="col-md-12">
                                        <div class="col-md-6 panboxvalue" onclick="getTabList('Total_Customer')"><div class="customertotal valueofbox">0000</div></div>
                                        <div class="col-md-6 panboxvalue" onclick="getTabList('Down_Customer')"><div class="customerdown valueofbox">0000</div></div>

                                    </div>

                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 pr-0">
                            <div class="card card-tale">
                                <div class="card-body">
                                    <p class="mb-4">Other Nodes</p>
                                    <div class="col-md-12" style="padding:4px;">
                                        <div class="col-md-6 totaldown">Total</div>
                                        <div class="col-md-6 totaldown">Down</div>

                                    </div>
                                    <div class="col-md-12">
                                        <div class="col-md-6 panboxvalue" onclick="getTabList('Total_Other')"><div class="othertotal valueofbox">0000</div></div>
                                        <div class="col-md-6 panboxvalue" onclick="getTabList('Down_Other')"><div class="otherdown valueofbox">0000</div></div>

                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="col-md-12 row-eq-height">
                        <div class="col-md-12">
                            <div class="col-md-6 barblock" style="margin-top:5px;">
                                <div class="blockheading">Top 10 Utilized interface</div>
                                <div class="col-md-12" style="padding:5px;">
                                </div>

                            </div>
                            <div class="col-md-6 barblock" style="margin-top:5px;">
                                <div class="blockheading">Top 10 CPU</div>
                                <div class="col-md-12" style="padding:5px;">
                                </div>
                                <!--<div id="peeringPieChart1" style="margin-left:-2rem;"></div>-->
                            </div>
                            <div class="col-md-6 barblock" style="margin-top:5px;">
                                <div class="blockheading">Top 10 Temp</div>
                                <div class="col-md-12" style="padding:5px;">
                                </div>
                                <!--<div id="peeringPieChart2" style="margin-left:-2rem;"></div>-->
                            </div>
                            <div class="col-md-6 barblock" style="margin-top:5px;">
                                <div class="blockheading">Network Availability Details</div>
                                <div class="col-md-12" style="padding:5px;">
                                </div>
                                <!--<div id="peeringPieChart2" style="margin-left:-2rem;"></div>-->
                            </div>
                        </div>


                    </div>



                </div>
            </div>
        </div>

        <div class="detailed_view_popup" style="display:none; width: 110rem;height: 52rem;overflow: hidden;">
            <div class="row header" style="margin-top:-3rem;">
                <h5>You are viewing detailed view for <b id="headerFancy"></b></h5>
            </div>
            <br>
            <div class="dashboard_tbl" style="margin-top: -2rem;"></div>
        </div>


        <jsp:include page="../common/user-footer.jsp"/>

        <script src="https://gitcdn.github.io/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js"></script>
        <script rel="stylesheet" href="../assets/js/bootstraptoggle.js"></script>
        <script type="text/javascript" src="../assets/js/metismenu/metisMenu.min.js"></script>
        <script type="text/javascript">
                                            var dataTableObject;
                                            $(document).ready(function () {
                                                $('.shrink-btn').trigger("click");
                                                getSummaryCount();
                                            });
                                            function getSummaryCount() {
                                                $.ajax({
                                                    type: "POST",
                                                    url: "../Summarydashboard",
                                                    data: {requestType: "1"},
                                                    dataType: "json",
                                                    success: function (data) {
                                                        console.log(data);
                                                        $('.total').html(data[0][0]);
                                                        $('.down').html(data[0][1]);
                                                        $('.backbonetotal').html(data[1][0]);
                                                        $('.backbonedown').html(data[1][1]);
                                                        $('.customertotal').html(data[2][0]);
                                                        $('.customerdown').html(data[2][1]);
                                                        $('.othertotal').html(data[3][0]);
                                                        $('.otherdown').html(data[3][1]);
                                                    }

                                                });
                                            }

                                            function getTabList(flag)
                                            {
                                                if (dataTableObject)
                                                {
                                                    $(".dashboard_tbl").html('');
                                                    $(".dashboard_tbl").html('<table class="table table-bordered table-hoverable dashboard_tbl_data" width="100%"> </table>');
                                                } else
                                                {
                                                    $(".dashboard_tbl").html('<table class="table table-bordered table-hoverable dashboard_tbl_data" width="100%"> </table>');
                                                }
                                                $.ajax({
                                                    type: "POST",
                                                    url: "../Summarydashboard",
                                                    data: {requestType: 2, flag: flag},
                                                    dataType: "json",
                                                    success: function (data) {
                                                        $.fancybox.open($(".detailed_view_popup"), {
                                                            title: 'Custom Title',
                                                            closeEffect: 'none',
                                                            autoSize: false,
                                                            width: "90%",
                                                            height: "80%"
                                                        });
                                                        var st = flag + " nodes";
                                                        var dashflag = "";
                                                        $("#headerFancy").html(dashflag);
                                                        dataTableObject = $('.dashboard_tbl_data').DataTable({
                                                            data: data,
                                                            "columnDefs": [
                                                                {"targets": 0},
                                                                {"targets": 1},
                                                                {"targets": 2},
                                                                {"targets": 3},
                                                                {"targets": 4},
                                                            ],
                                                            columns: [
                                                                {title: "Group Name"},
                                                                {title: "Node Type"},
                                                                {title: "Node IP"},
                                                                {title: "Node Name"},

                                                                {title: "Vendor Name"}
                                                            ],
                                                            "scrollX": true,
                                                            "info": true,
                                                            searching: true,
                                                            lengthChange: false,
                                                            "pageLength": 15,
                                                            "autoWidth": true,
                                                            fixedHeader: true, dom: 'Blfrtip',
                                                            buttons: [
                                                                {
                                                                    extend: 'excelHtml5',
                                                                    title: dashflag
                                                                }
                                                            ]
                                                        });


                                                    }}
                                                );
                                            }

        </script>

    </body>

</html>    

