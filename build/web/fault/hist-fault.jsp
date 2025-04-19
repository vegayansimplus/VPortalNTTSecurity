<%-- 
    Document   : hist-fault
    Created on : 16 Apr, 2025, 12:10:48 PM
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
        } else {
            response.sendRedirect("/VPortalNTT/login.jsp");
            return;
        }
    }
  
    USER = user.toUpperCase();

%>
<html ng-app="TrapHistoric">
    <head>
        <jsp:include page="../common/user-header.jsp"/>
        <jsp:include page="../common/TrapHeader.jsp"/>
        <script src="../assets/uigrid/angular-1.4.3.js"></script>
        <link rel="stylesheet" href="../assets/css/font-awesome.min.css">
        <title>Faults</title>
        <link rel="icon" href="../assets/images/vsicon.png" type="image/x-icon" />
        <script src="hist-fault.js"></script>


        <style>
            body{
                overflow: hidden;
                width: 100vw;
                height:100vh;
                font-size: 12px;
                background-color: #f9f6fd;
                font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";
            }
            .modal-dialog {
                width: 70vw;
            }
            #checkfilters {
                width: 100px;
            }
            .col-xs-15,
            .col-sm-15,
            .col-md-15,
            .col-lg-15 {
                position: relative;
                min-height: 1px;
                padding-right: 10px;
                padding-left: 10px;
            }
            .col-xs-15 {
                width: 20%;
                float: left;
            }
            @media (min-width: 768px) {
                .col-sm-15 {
                    width: 20%;
                    float: left;
                }
            }
            @media (min-width: 992px) {
                .col-md-15 {
                    width: 20%;
                    float: left;
                }
            }
            @media (min-width: 1200px) {
                .col-lg-15 {
                    width: 20%;
                    float: left;
                }
            }

            .loading_sign {
                position: fixed;
                right: 0px;
                top: 0px;
            }

            #gridWrapper {
                height: 100%;
                width: 100%;
            }

            .grid {
                /*width: 95vw;*/
                height: 93vh;
            }
            .container{
                margin-left: -2rem;
                margin-right: 0;
                width: 99vw;
                height: 98vh;
                margin-top: -2rem;
            }
            #gridSaveState{
                display: grid;
                grid-gap: 1em;
                height: 88vh !important;
                width:92vw;
            }
            .btn {
                width: 7em;
                font-size: 1em;
                height: 2em;
                padding: 3px 10px;
            }
            .flag-info {

                background-color: greenyellow  !important;
            }
            .flag-major {

                background-color: #FF7F50 !important;
            }
            .flag-clear {

                background-color: #2baa08 !important; /*#518723*/
            }
            .flag-acknowledge {

                background-color: yellow !important;
            }
            .flag-critical {
                background-color: #ff0000 !important;
            }
            .flag-minor {
                background-color: gold !important;
            }
            /*            .select2-container .select2-choice {
                            display: block!important;
                            height: 25px!important;
                            white-space: nowrap!important;
                            line-height: 25px!important;
                        }
            
                        input.select2-input {
                            height: 25px;
                        }
            
                        .select2-container .select2-selection {
                            height: 25px;
                            overflow-y: auto !important;
                        }
                        .select2-container .select2-container-multi {
                            height: 25px !important;
                            overflow-y: auto !important;
                        }*/

            #difffromTime1, #difftoTime1 {
                width: 125px;
            }

            #save {
                margin-left: 0px !important;

            }
            #selectView {
                float: none !important;
            }

            #buttonDiv {
                width: 180px;
            }

            #container {
                width: 100%;
            }

            .legend {
                float: right !important;
            }
            #inputTable {
                width: 90%;
            }

            .grid {
                width: 1350px;
                height: 450px !important;
            }
            button#ack {
                margin-left: 3.2em;
            }
            button#clear {
                margin-left: 1.2em;
            }
            .trapTypeList{
                margin-right: 0.5em;
                background-color: cyan;
                padding: 0.2em;
                border-radius: 0.8em;
                padding-left: 0.6em;
                padding-right: 0.6em;
                font-weight: 600;
            }
            .ui-grid-viewport{
                overflow-anchor:none;
            }
            .navbar-header {
                margin-top: -1rem;
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
            .btn-primary{
                background: #990033;
            }
            .modal-content {
                width: 102rem;
                margin-left: -27rem;
            }


            input {
                border-width: 1px !important;
            }
            .form-group {
                display: flex;
                flex-direction: row;
                justify-content: center;
                align-items: center;
            }
            .form-check{
                margin-left: 8px;
            }
            #TrafficscaleDiv{
                width: 28rem;
                background-color: darkseagreen;
                height: 3rem;
            }


        </style>


    </head>
    <body ng-controller="MainCtrl"  data-sidebar="dark">
        <jsp:include page="../common/usermenu.jsp"/>
        <div class="main-content" style="margin-top: -2rem;">
            <div class="page-content">
                <div class="container">
                   
                    <hr style=" width: 100%; margin-bottom: 1em;">
                    <div id="gridWrapper" style="margin-top: -3rem;">
                        <img src="../assets/images/loading_1.gif"  class="loading_sign" width="100px" ng-show="loading" /> 
                        <div id="gridSaveState" ng-show="showGrid" data-ng-init="startAutoRefresh()"  ui-grid="gridOptions"  ui-grid-save-state ui-grid-selection ui-grid-cellNav ui-grid-resize-columns ui-grid-move-columns ui-grid-pinning ui-grid-exporter  class="grid">

                        </div>
                    </div>
                    <div class="modal fade" id="myModal" role="dialog">
                        <div class="modal-dialog">

                            <!-- Modal content-->
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title">Trap Type Filters</h4>
                                </div>
                                <div class="modal-body filtersbody">
                                    <div class="row filterList"></div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal" ng-click = "GetFilterdTraps()">Ok</button>
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>


        <jsp:include page="../common/user-footer.jsp"/>
        <jsp:include page="../common/TrapFooter.jsp"/>
    <ng-include src="'../assets/uigrid/views/PopUpHist.html'"></ng-include>
    <ng-include src="'uigrid/views/ContextMenu.html'"></ng-include>
    <script type="text/javascript" src="../assets/js/select2.min.js"></script>
    <script type="text/javascript">
                                               
                                                $(document).ready(function () {
                                                  
                                                    final_link_latlng = [];
                                                    $('.shrink-btn').trigger("click");
                                                    $("#grouptype").select2();
                                                    $('#activetraptype').select2();
                                                  
                                                    $('#ActiveTraptypeDiv').show();

                                                    $("#filter").button();
                                                    $("#selectView").click(function () {

                                                    });
                                                    $("#difffromTime1").change(function () {
                                                        var frmTime = $("#difffromTime1").val();
                                                        $("#timeFrom").val(frmTime).trigger('input');
                                                    });
                                                    $("#difftoTime1").change(function () {
                                                        var toTime = $("#difftoTime1").val();
                                                        $("#timeTo").val(toTime).trigger('input');

                                                    });



                                                    $("#timeFrom").datetimepicker({
                                                        showSecond: true,
                                                        timeFormat: 'hh:mm:ss',
                                                        dateFormat: "yy-mm-dd"
                                                    });
                                                    $("#timeTo").datetimepicker({
                                                        showSecond: true,
                                                        timeFormat: 'hh:mm:ss',
                                                        dateFormat: "yy-mm-dd"
                                                    });

                                                    $("#zoomout").hide();
                                                    $("#zoomin").click(function () {
                                                        $("#zoomout").show();
                                                        $("#zoomin").hide();
                                                        $('#content1', window.parent.document).toggleClass('content1tog');
                                                        $('#content2', window.parent.document).toggleClass('content2tog');
                                                        $("#inputTable").hide();
                                                    });
                                                    $("#zoomout").click(function () {
                                                        $("#zoomout").hide();
                                                        $("#zoomin").show();
                                                        $('#content1', window.parent.document).toggleClass('content1tog');
                                                        $('#content2', window.parent.document).toggleClass('content2tog');
                                                        $("#inputTable").show();
                                                    });
                                                });
                                              


    </script>
</body>
</html>

