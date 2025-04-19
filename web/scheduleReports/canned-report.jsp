<%-- 
    Document   : canned-report
    Created on : 31 Mar, 2025, 4:31:07 PM
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
        <jsp:include page="../common/CommonHeader.jsp"/>
        <jsp:include page="../common/user-header.jsp"/>
        <link href="https://gitcdn.github.io/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css" rel="stylesheet">
        <link rel="stylesheet" href="../assets/css/morris.css" />
        <link rel="stylesheet" href="../assets/admin/css/bootstrap.min.css">
        <link rel="stylesheet" href="../assets/css/select2.min.css">
        <link rel="stylesheet" href="../assets/css/font-awesome.min.css">
        <title>Canned | Report</title>
        <link rel="icon" href="../assets/images/vsicon.png" type="image/x-icon" />
        <style>
            body{
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




            .form-control {
                display: block !important;
                width: 100% !important;
                height: auto !important;
                padding: 1px 5px !important;
                font-size: 12px !important;
                line-height: 1.42857143 !important;
                color: #555 !important;
                background-color: #fff !important;
                background-image: none !important;
                border: 1px solid #ccc !important;
                border-radius: 4px !important;
                -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
                box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
                -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
                -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
                transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
            }
            .cannedContentHeading{

                background-color: #990033;
                color: white;
                padding: 10px;
                margin: 10px;
            }
            .cannedContent{
                border: 1px solid #a7a7a7;
            }
            td.disabled.day {
                text-decoration: line-through;
            }
            .cannedContent_content{
                padding:5px;
            }
            .content-start{
                margin-left: 10px;
                margin-right: 10px;
                margin-top: -60px;
            }

            ul.reportList {
                list-style: none;
            }

            ul.reportList li {
                margin-left: -75px;
                padding-top: 5px;
                padding-left: 40px;
                padding-bottom: 5px;
                cursor: pointer;
            }
            ul.reportList li:hover{
                background: #990033;
                color: white !important;
            }
            .row-eq-height {
                display: -webkit-box;
                display: -webkit-flex;
                display: -ms-flexbox;
                display: flex;

            }
            .divider {
                border-right: 1px solid #990033;
                height: 450px;
                overflow-y: scroll;
            }
            .rprts{
                word-wrap: break-word;
            }
            .rprts li {
                border :  1px solid #990033;
                color: black;
                cursor: pointer;
                padding: 20px;
                background: #EAECC6;
                margin: 10px;
                display: inline-block;
            }
            .nav-pills>li.active>a, .nav-pills>li.active>a:focus, .nav-pills>li.active>a:hover {
                color: #fff;
                background-color: #990033 !important;
                margin-left: 60px;
                margin-right: 60px;
            }

            .nav-justified>li>a {
                color: #000;
                width:25rem;
                background-color: #EAECC6 !important;
                margin-left: 60px;
                margin-right: 60px;
                font-size: 14px;
            }
            .navbar-brand-box {
                margin-top: 4rem;
            }
            .tab-content > .active {
                display: contents;
            }

            .tab-content {
                margin-top: 10px;
                border-top: 1px solid #990033 ;
            }

            .text-here{

                font-size: 15px;
                padding: 5px;

            }
            .text-here:hover{
                cursor: pointer;
                text-decoration: underline;
                color: #990033 !important
            }
            .breadCrum {
                background: #EAECC6 !important;
                padding: 10px;
                margin-left: -15px;
            }

            body {
                color: #3A3A3A !important;
                font-size: 12px;
            }
            /*header#page-topbar {
                height: 1px;
            }*/
            .navbar-header{
                height:1px !important;
            }
            .sidebar-top {
                margin-top: 3rem;
            }
            .navbar-brand-box {
                margin-top: 4rem;
            }
            .tab-content > .active {
                display: contents;
            }
            #page-content-wrapper {
                width: 100%;
                padding-top: 50px;
            }

            #wrapper.toggled #page-content-wrapper {
                position: absolute;
                margin-right: -220px;
            }
            .row{
                margin-top:-1rem;
            }
        </style>
    </head>
    <body data-sidebar="dark">
        <jsp:include page="../common/usermenu.jsp"/>
        <div class="main-content">
            <div class="page-content">
                <div id="wrapper" >
                    <div class="overlay"></div>
                    <div id="page-content-wrapper">
                        <div class="content-start">
                            <ul class="nav nav-pills nav-justified">
                                <li class="active"><a data-toggle="tab" href="#daily">Daily</a></li>
                                <li><a data-toggle="tab" href="#weekly" style="margin-left: 39rem;">Weekly</a></li>
                                <li><a data-toggle="tab" href="#monthly" style="margin-left: 76rem;">Monthly</a></li>
                            </ul>
                            <div class="tab-content">
                                <div id="daily" class="tab-pane fade in active">
                                    <div class="row row-eq-height" style="margin-top:1px;">
                                        <div class="col-md-3 divider">
                                            <br/>
                                            <label>Date Filter</label>
                                            <select style="width:100%;" id="dailyList_opt" onChange="getReport(this.value, 1)"><option value="">Select Date</option></select>
                                            <hr/>
                                            <label>Report List</label>
                                            <ul id ="dailyList"  class="reportList"></ul>
                                        </div>
                                        <div class="col-md-9" style="overflow-y:scroll;height:450px;">
                                            <div class="breadCrum breadCrum1">Daily Reports</div>
                                            <div id ="dailyrprts" class="rprts"></div>
                                        </div>
                                    </div>
                                </div>
                                <div id="weekly" class="tab-pane fade">
                                    <div class="row row-eq-height  ">
                                        <div class="col-md-3 divider">
                                            <br/>
                                            <label>Date Filter</label>
                                            <select style="width:100%;" id="weeklyList_opt" onChange="getReport(this.value, 2)"></select>
                                            <hr/>
                                            <label>Report List</label>
                                            <ul id="weeklyList" class="reportList"></ul>
                                        </div>
                                        <div class="col-md-9" style="overflow-y:scroll;height:530px;">
                                            <div class="breadCrum breadCrum2">Weekly Reports</div>
                                            <ul id ="weeklyrprts"  class="rprts"></ul>
                                        </div>
                                    </div>
                                </div>
                                <div id="monthly" class="tab-pane fade">
                                    <div class="row row-eq-height  ">
                                        <div class="col-md-3 divider">

                                            <br/>
                                            <label>Date Filter</label>
                                            <select style="width:100%;" id="monthlyList_opt" onChange="getReport(this.value, 3)"></select>
                                            <hr/>
                                            <label>Report List</label>
                                            <ul id="monthlyList" class="reportList"></ul>
                                        </div>
                                        <div class="col-md-9" style="overflow-y:scroll;height:530px;">
                                            <div class="breadCrum breadCrum3">Monthly Reports</div>
                                            <ul id ="monthlyrprts"  class="rprts"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>


                    </div>
                    <!-- /#wrapper -->
                </div>
            </div>
        </div>

        <jsp:include page="../common/user-footer.jsp"/>
        <script type="text/javascript" src="../assets/js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="../assets/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="../assets/js/moment.min.js"></script>
        <script type="text/javascript" src="../assets/js/bootstrap-datetimepicker.min.js"></script>
        <script type="text/javascript" src="../assets/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="../assets/js/select2.min.js"></script>
        <script type="text/javascript" src="../assets/js/d3.min.js"></script>
        <script type="text/javascript" src="../assets/js/c3.min.js"></script>
        <script type="text/javascript" src="../assets/js/buttons.html5.min.js"></script>
        <script type="text/javascript" src="../assets/js/jszip.min.js"></script>
        <script type="text/javascript" src="../assets/js/pdfmake.min.js"></script>
        <script type="text/javascript" src="../assets/js/vfs_fonts.js"></script>
        <script src="../assets/js/dataTables.fixedHeader.min.js"></script>
        <script>
                                                $(document).ready(function () {
                                                    $('.shrink-btn').trigger("click");
                                                    fetchDailyReportsDates();
                                                    fetchWeeklyReportsDates();
                                                    fetchMonthlyReportsDates();
                                                });


                                                function getReport(folder_name, report_type) {
                                                    var groupname = $('#groupNameFilter').val();
                                                    $.ajax({
                                                        type: "POST",
                                                        url: "../CannedReport",
                                                        data: {reportType: "4", folderName: folder_name, report_type: report_type, groupname: groupname},
                                                        dataType: "json",
                                                        success: function (data) {
                                                            console.log("============ get report ==============")
                                                            console.log(data);

                                                            if (report_type == 1) {
                                                                $("#dailyrprts").empty();
                                                                $(".breadCrum1").html("Daily Reports > " + folder_name);
                                                                for (i = 0; i < data.length; i++) {
                                                                    $("#dailyrprts").append('<div class="col-md-12"><div class="text-here" onClick=\'getReport1("' + data[i] + '","' + folder_name + '",1)\'>' + data[i] + '</div></div>');
                                                                }
                                                            } else if (report_type == 2) {
                                                                $("#weeklyrprts").empty();
                                                                $(".breadCrum2").html("Weekly Reports > " + folder_name);
                                                                for (i = 0; i < data.length; i++) {
                                                                    $("#weeklyrprts").append('<div class="col-md-12"><div  class="text-here" onClick=\'getReport1("' + data[i] + '","' + folder_name + '",2)\'>' + data[i] + '</div></div>');
                                                                }
                                                            } else if (report_type == 3) {
                                                                $("#monthlyrprts").empty();
                                                                $(".breadCrum3").html("Monthly Reports > " + folder_name);
                                                                for (i = 0; i < data.length; i++) {
                                                                    $("#monthlyrprts").append('<div class="col-md-12"><div  class="text-here" onClick=\'getReport1("' + data[i] + '","' + folder_name + '",3)\'>' + data[i] + '</div></div>');
                                                                }
                                                            }
                                                        }
                                                    });
                                                }

                                                function getReport1(reportName, folderName, reportType) {
                                                    var groupname = $('#groupNameFilter').val();
                                                    if (reportType == "1") {
                                                        if (groupname == "Branch") {
                                                            reportName = "/Reports/Branch/Daily/" + folderName + "/" + reportName;
                                                        } else if (groupname == "HO")
                                                        {
                                                            reportName = "/Reports/HO/Daily/" + folderName + "/" + reportName;
                                                        } else if (groupname == "Partner")
                                                        {
                                                            reportName = "/Reports/Partner/Daily/" + folderName + "/" + reportName;
                                                        } else if (groupname == "CC-Branch")
                                                        {
                                                            reportName = "/Reports/CC-Branch/Daily/" + folderName + "/" + reportName;
                                                        } else if (groupname == "DC-DR-HA")
                                                        {
                                                            reportName = "/Reports/DC-DR-HA/Daily/" + folderName + "/" + reportName;
                                                        } else if (groupname == "M_C_Reports")
                                                        {
                                                            reportName = "/Reports/M_C_Reports/Daily/" + folderName + "/" + reportName;
                                                        } else {
                                                            reportName = "/Reports/CCDC-DR/Daily/" + folderName + "/" + reportName;
                                                        }
                                                    } else if (reportType == "2") {
                                                        if (groupname == "Branch") {
                                                            reportName = "/Reports/Branch/Weekly/" + folderName + "/" + reportName;
                                                        } else if (groupname == "HO")
                                                        {
                                                            reportName = "/Reports/HO/Weekly/" + folderName + "/" + reportName;
                                                        } else if (groupname == "Partner")
                                                        {
                                                            reportName = "/Reports/Partner/Weekly/" + folderName + "/" + reportName;
                                                        } else if (groupname == "CC-Branch")
                                                        {
                                                            reportName = "/Reports/CC-Branch/Weekly/" + folderName + "/" + reportName;
                                                        } else if (groupname == "DC-DR-HA")
                                                        {
                                                            reportName = "/Reports/DC-DR-HA/Weekly/" + folderName + "/" + reportName;
                                                        } else if (groupname == "M_C_Reports")
                                                        {
                                                            reportName = "/Reports/M_C_Reports/Weekly/" + folderName + "/" + reportName;
                                                        } else {
                                                            reportName = "/Reports/CCDC-DR/Weekly/" + folderName + "/" + reportName;
                                                        }
//                                                        reportName = "/BFL_Reports/Weekly/" + folderName + "/" + reportName;
                                                    } else {
                                                        if (groupname == "Branch") {
                                                            reportName = "/Reports/Branch/Monthly/" + folderName + "/" + reportName;
                                                        } else if (groupname == "HO")
                                                        {
                                                            reportName = "/Reports/HO/Monthly/" + folderName + "/" + reportName;
                                                        } else if (groupname == "Partner")
                                                        {
                                                            reportName = "/Reports/Partner/Monthly/" + folderName + "/" + reportName;
                                                        } else if (groupname == "CC-Branch")
                                                        {
                                                            reportName = "/Reports/CC-Branch/Monthly/" + folderName + "/" + reportName;
                                                        } else if (groupname == "DC-DR-HA")
                                                        {
                                                            reportName = "/Reports/DC-DR-HA/Monthly/" + folderName + "/" + reportName;
                                                        } else if (groupname == "M_C_Reports")
                                                        {
                                                            reportName = "/Reports/M_C_Reports/Monthly/" + folderName + "/" + reportName;
                                                        } else {
                                                            reportName = "/Reports/CCDC-DR/Monthly/" + folderName + "/" + reportName;
                                                        }
//                                                        reportName = "/BFL_Reports/Monthly/" + folderName + "/" + reportName;
                                                    }

                                                    console.log("+++++++++++++++++++++++++");
                                                    console.log(reportName);
                                                    console.log(folderName);
                                                    console.log(reportType);
                                                    console.log("+++++++++++++++++++++++++");
                                                    $.post("../GetReport", {filePath: reportName}, function (data, status) {
                                                        if (data != null)
                                                        {
                                                            //console.log(data);
                                                            window.location = data;
                                                        } else
                                                        {
                                                            alert("No report found on this date");
                                                        }

                                                    });

                                                }
                                                function fetchDailyReportsDates() {
                                                    var groupname = $('#groupNameFilter').val();
                                                    console.log(groupname);
                                                    console.log("groupname: " + groupname);
                                                    $.ajax({type: "POST",
                                                        url: "../CannedReport",
                                                        data: {reportType: "1", groupname: groupname},
                                                        dataType: "json",
                                                        success: function (data) {
                                                            console.log(data);
                                                            $("#dailyList").html('');
                                                            //data = data.reverse();
                                                            data.sort(function (a, b) {
                                                                return new Date(b) - new Date(a)
                                                            });
                                                            for (i = 0; i < data.length; i++) {
                                                                $("#dailyList").append('<li onClick=\'getReport("' + data[i] + '",1)\'>' + data[i] + '</li>');
                                                                $("#dailyList_opt").append('<option value="' + data[i] + '">' + data[i] + '</option>');
                                                            }
                                                            $("#dailyList_opt").select2();
                                                        }
                                                    });
                                                }
                                                function fetchWeeklyReportsDates() {
                                                    var groupname = $('#groupNameFilter').val();
                                                    $.ajax({type: "POST",
                                                        url: "../CannedReport",
                                                        data: {reportType: "2", groupname: groupname},
                                                        dataType: "json",
                                                        success: function (data) {
                                                            console.log(data);
//                                                    data = data.reverse();
                                                            $("#weeklyList").html('');
                                                            data.sort(function (a, b) {
                                                                return new Date(b) - new Date(a)
                                                            });
                                                            for (i = 0; i < data.length; i++) {
                                                                $("#weeklyList").append('<li onClick=\'getReport("' + data[i] + '",2)\'>' + data[i] + '</li>');
                                                                $("#weeklyList_opt").append('<option value="' + data[i] + '">' + data[i] + '</option>');
                                                            }
                                                            $("#weeklyList_opt").select2();
                                                        }
                                                    });
                                                }
                                                function writeToLogWebAcess(name)
                                                {
                                                    $.ajax({
                                                        type: "POST",
                                                        url: "../Writetologwebaccess",
                                                        data: {name: name},
                                                        success: function (data) {

                                                            console.log("access logged......")
                                                        }
                                                    });
                                                }
                                                function fetchMonthlyReportsDates() {
                                                    var groupname = $('#groupNameFilter').val();
                                                    $.ajax({type: "POST",
                                                        url: "../CannedReport",
                                                        data: {reportType: "3", groupname: groupname},
                                                        dataType: "json",
                                                        success: function (data) {
                                                            $("#monthlyList").html('');
                                                            data.sort(function (a, b) {
                                                                return new Date(b) - new Date(a)
                                                            });
                                                            for (i = 0; i < data.length; i++) {
                                                                $("#monthlyList").append('<li onClick=\'getReport("' + data[i] + '",3)\'>' + data[i] + '</li>');
                                                                $("#monthlyList_opt").append('<option value="' + data[i] + '">' + data[i] + '</option>');
                                                            }
                                                            $("#monthlyList_opt").select2();
                                                        }
                                                    });
                                                }

        </script>
        <!--<script type="text/javascript" src="BFLThreshold.js"></script>-->
    </body>
</html>