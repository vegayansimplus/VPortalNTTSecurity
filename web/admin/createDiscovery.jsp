<%-- 
    Document   : createDiscovery
    Created on : 24 Mar, 2025, 3:16:45 PM
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
<html lang="en">

    <head>
        <%--<jsp:include page="../common/BFLHeader.jsp"/>--%>
        <jsp:include page="../common/user-header.jsp"/>
        <title>Discovery</title>
        <link rel="icon" href="../assets/images/vsicon.png" type="image/x-icon" />
        <link rel="stylesheet" href="../assets/css/font-awesome.min.css">
        <style>
            tbody#tbld tr:first-child {
                display: none;
            }
            .col-md-12.message_handler {
                margin-top: 20px;
            }
            body{
                overflow: hidden;
                background-color: #FAFAFA;
            }
            thead {
                background-color: #990033;
                color: white;
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
            table{
                margin: 0 auto;
                clear: both;
                border: 1px solid black !important;
                /*                border-collapse: collapse;*/
                table-layout: fixed;
                word-wrap:break-word;
            }
            a.dt-button.buttons-pdf.buttons-html5 {
                background: #990033;
                color: white;
                padding:8px;

            }
            a.dt-button.buttons-excel.buttons-html5 {
                background: #990033;
                color: white;
                padding:8px;
                margin-right: 10px;

            }
            .dt-buttons {
                text-align: -webkit-left;
                padding-bottom: 20px;
            }
            .select_node{
                margin-left: 20px;
            }

            ul.user_management_options li {
                padding-top: 10px;
                padding-bottom: 10px;
                border-bottom:1px solid gray;
                margin-left: -10px;
                padding-left: 10px;
                cursor: pointer;
            }

            ul.user_management_options li:hover {
                background: #990033;
                color: white;
            }

            .active_element{
                background: #990033;
                color: white;
            }
            #finalResult {
                box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 1px 5px 0 rgba(0,0,0,0.12), 0 3px 1px -2px rgba(0,0,0,0.2);
                padding:1em;
                background: #F1F1F1;
                width: 65%;
                margin-left: 15em;
            }
            .nav-pills>li.active>a, .nav-pills>li.active>a:focus, .nav-pills>li.active>a:hover {
                color: #fff;
                background-color: #990033 !important;
            }
            .btn-primary {
                color: #fff;
                background-color: #990033 !important;
                border-color: #990033 !important;
            }
            .thumbnail {
                min-height: 350px ! important;
                max-height: 350px;
                overflow-y: scroll;
            }
            #welcombar{
                height: 40px;
                text-align: end;
                padding-right: 50px;
                padding-top: 12px;
            }
            b, strong {
                font-weight: 700 !important;
            }
            #disp_table{
                padding-top: 15px;
                width: 87em;
                overflow-x: auto;
                overflow-y: auto;
                white-space: nowrap;
            }
            #disp_table_2{
                padding-top: 15px;
                width: 87em;
                overflow-x: auto;
                overflow-y: auto;
                /*white-space: nowrap;*/
            }
            #discResultTable{
                overflow-x: auto;
                overflow-y: auto;
                /*white-space: nowrap;*/
            }
            #myProgress {
                position: relative;
                width: 100%;
                height: 15px;
                background-color: #DDD;
            }
            #myBar {
                position: absolute;
                width: 1%;
                height: 100%;
                background-color: #990033;
            }
            #discResultTable{
                margin-left: 350px;
                width:590px;
            }
            .wrapper {
                text-align: center;
            }
            .nav>li>a {
                position: relative;
                display: block;
                padding: 10px 15px;
                font-size: 12px;
                letter-spacing: 1px;
            }
            .thumbnail {
                border: 1px solid black;
            }
            .nav>li>a {
                background: #eee;
            }
            .container{
                margin-left: 6rem;
            }
            
        </style>

    </head>
    <body data-sidebar="dark">
        <jsp:include page="../common/adminmenu.jsp"/>
        <div id="wrapper">
            <div class="overlay"></div>
            <div class="container">

                <div class="row new_device_content">
                    <!--Root Wizard Content starts-->
                    <div class="col-md-12" id="rootwizard" style="width:95%">
                        <!--navbar starts -->
                        <div class="navbar">
                            <div class="navbar-inner nav-justified">

                                <ul >
                                    <li id="li1" style="width:22rem;text-align: center;"><a href="#tab1" data-toggle="tab"><center>Step 1 </center><b>Upload Node Details</b></a></li>
                                    <li id="li2" style="width:22rem;text-align: center;"><a href="#tab2" data-toggle="tab"><center>Step 2 </center><b>Verifying Pre-Requisite</b></a></li>
                                    <li id="li3" style="width:22rem;text-align: center;"><a href="#tab3" data-toggle="tab"><center>Step 3 </center><b>Discovery Result</b></a></li>
                                </ul>

                            </div>
                        </div>
                        <!--navbar ends -->


                        <!-- form wizard content starts -->
                        <div class="tab-content">
                            <!-- wizard step 1 starts-->
                            <div class="tab-pane" id="tab1">
                                <div class="row form-group thumbnail" style="margin-left: 3px;margin-right: 2px;">
                                    <div class="" style="margin-top: 20px;">
                                        <div class="row col-md-12">
                                            <div class="col-md-8" style="display:flex">
                                                <div class="col-md-2">
                                                    <label>Upload CSV</label>
                                                </div>
                                                <div class="col-md-4" id="myLabel">
                                                    <input type="file" id="uploadCSV" class="btn form-control">
                                                </div>
                                                <div class="col-md-4" style="margin-left:2rem;"><button type="button" id="uploadBtn" class="btn btn-primary" onclick="uploadData1()">Upload</button></div>
                                            </div>
                                            <div class="col-md-4" ><a id="sampleCsv" href="#" class="btn btn-primary" style="float:right;">Download Sample CSV</a></div>
                                        </div>
                                        <div class="col-md-12" id="disp_table" style="padding-top: 15px;width:100%">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- wizard step 1 ends-->

                            <div class="tab-pane" id="tab2">
                                <div class="row  thumbnail" style="max-height: 390px !important;">
                                    <div class="col-md-12">
                                        <label id="verifiedText">Verifying following points please wait.. </label>
                                        <ul>
                                            <li>The Device should be reachable from the SiMPLuS Application Servers.</li>
                                            <li>There must be proper, continuous and non-breaking SNMP response from the device.</li>
                                            <!--<li>Device Groupname should be one of the predefined groups  (Branch,CC-Branch,CCDC-DR,HO,DC-DR,Partner).</li>-->
                                        </ul>
                                        <hr>
                                        <div class="col-md-12">
                                            <div class="col-md-9">
                                                <div class="progress progress-striped active" id="preCheckPBContainer">
                                                    <div class="progress-bar" id="preCheckPB" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%;color: rgb(255, 255, 255);background-color: rgb(153, 0, 51);">Complete</div>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <button type="button" id="btnExport" class="btn btn-primary" style="float:right;">Export Table data into Excel</button>
                                            </div>
                                        </div>   
                                    </div>
                                    <div class="col-md-12" id="disp_table_2" style="margin-top: -10px;width:100%">

                                    </div>
                                    <!--<iframe src="fileUpload_discovery.jsp" style="width: 100%; height: 500px;border-width: 0px;"></iframe>-->
                                </div>
                            </div>
                            <div class="tab-pane  thumbnail" id="tab3" style="overflow-y: auto">

                            </div>
                            <ul class="pager wizard" style="margin : 22px 0;">
                                <li class="previous" id="previous"><a href="javascript:;" style="background-color: #990033;color: white;">Previous</a></li>
                                <li class="next"><a href="javascript:;"  style="background-color: #990033;color: white;">Next</a></li>
                                <li class="next finish" style="display:none;background-color: #990033;color: white;" ><a href="javascript:;">Finish</a></li>
                            </ul>
                        </div>	
                    </div>
                    <!--Root Wizard Content Ends-->
                </div>
            </div>



        </div>


        <jsp:include page="../common/user-footer.jsp"/>
        <script type="text/javascript" src="../assets/admin/js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="../assets/admin/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="../assets/admin/js/moment.min.js"></script>
        <script type="text/javascript" src="../assets/admin/js/bootstrap-datetimepicker.min.js"></script>
        <script type="text/javascript" src="../assets/admin/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="../assets/admin/js/select2.min.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap-wizard/1.2/jquery.bootstrap.wizard.js"></script>
        <script type="text/javascript" src="../assets/admin/js/table2excel.js"></script>
        <script>
                                                    var username1 = '<%=user%>';
                                                    $(document).ready(function () {
                                                        $('.shrink-btn').trigger("click");
                                                    });
        </script>
        <script type="text/javascript" src="createDiscovey.js"></script>
    </body>

</html>    
