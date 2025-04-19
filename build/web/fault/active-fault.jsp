<%-- 
    Document   : active-fault
    Created on : 31 Mar, 2025, 4:31:47 PM
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
<html ng-app="TrapActive">
    <head>
        <jsp:include page="../common/user-header.jsp"/>
        <jsp:include page="../common/TrapHeader.jsp"/>
        <script src="../assets/uigrid/angular-1.4.3.js"></script>
        <link rel="stylesheet" href="../assets/css/font-awesome.min.css">
        <title>Faults</title>
        <link rel="icon" href="../assets/images/vsicon.png" type="image/x-icon" />

        <script src="active-fault.js"></script>


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
            .select2-container .select2-choice {
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
            }

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
            .ui-grid-row:hover{
                cursor:pointer;
            }
            .btn-disable
            {
                cursor: not-allowed;
                pointer-events: none;
                opacity:0.65;

            }
        </style>


    </head>
    <body ng-controller="MainCtrl" data-ng-init="startAutoRefresh()" data-sidebar="dark">
        <jsp:include page="../common/usermenu.jsp"/>
        <div class="main-content" style="margin-top: -2rem;">
            <div class="page-content">
                <div class="container">
                    <div class="row" id="horizRow">
                        <div class="row " id="horizRow" >
                            <div class="col-md-4 pull-left" style="margin-right: 0;margin-left:0;width:28vw;display:inline-flex;">               
                                <div class="col-md-4" style="display:inline-flex;">
                                    <div style="margin-left: 0em;"><button data-toggle="button" style="background-color: #ff0000 !important;color: white;border-radius: 3px; border-color: #ff0000; padding: 0px; width: 35px; height: 25px;" ng-click="filterSeverity('Critical')"  class="btn btn-primary">{{criticalCount}}</button></div>
                                    <div style="margin-left: 10px;">Critical</div>
                                </div>
                                <div class="col-md-4" style="display:inline-flex;">
                                    <div style="margin-left: 0em;"><button data-toggle="button" style="background-color: #FF7F50 !important;color: white;border-radius: 3px; border-color: #FF7F50; padding: 0px; width: 35px; height: 25px;" ng-click="filterSeverity('Major')"  class="btn btn-primary">{{majorCount}}</button></div>
                                    <div style="margin-left: 10px;">Major</div>
                                </div>
                                <div class="col-md-4" style="display:inline-flex;width:11vw;padding:0">
                                    <div style="margin-right: 0em;"><button data-toggle="button" style="background-color: gold !important;color: white; border-radius: 3px; border-color: gold; padding: 0px; width: 35px; height: 25px;" ng-click="filterSeverity('MinorWarn')" class="btn btn-primary">{{minorCount}}</button></div>
                                    <div style="margin-left: 10px;">Minor Warning</div>
                                </div>
                            </div>
                            <div class="col-md-4" style="display:inline-flex">
                                <label style="width:10vw;padding-top:5px;">Group Type</label>
                                <select class="form-control" id="trapTypes" multiple="multiple" style="width:100%;height:25px;min-height: 25px !important;"> 
                                    <option value="">Select Group Type</option>
                                    <option value="BackBoneDown">BackBone-Down</option>
                                   
                                </select>
                                <div style="padding-left:5px;"> <button class="btn btn-primary vega-btn" id="trapTypeView" onclick="openFaultNewTab()">View</button></div>
                            </div>
                            <div class="col-md-2" style="display:inline-flex">
                                <button id="clear" type="button" class="btn btn-primary pageBtn" style="margin-top:6px;" ng-disabled="!selectedRow" ng-click="clear()" >Clear</button> &nbsp;
                                <button id="ack" type="button"  style="background-color: yellow !important;color: black;margin-top:6px;" class="btn btn-primary pageBtn" ng-disabled="!selectedRow" ng-click="acknowledge()" >Ack</button>
                                <!--<button id="clear" type="button"  style="background-color: yellow !important;color: black;margin-top: 5px;" ng-show="showGrid"   class="btn btn-primary " ng-click="acknowledge()">Ack</button>-->
                            </div>

                        </div>
                    </div>
                    <hr style=" width: 100%; margin-bottom: 1em">
                    <div id="gridWrapper" style="margin-top: -3rem;">
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
    <ng-include src="'../assets/uigrid/views/HistPopUp.html'"></ng-include>
    <ng-include src="'uigrid/views/ContextMenu.html'"></ng-include>
    <script type="text/javascript">
                $(document).ready(function () {
                    $('.shrink-btn').trigger("click");

                    $("#trapTypes").select2();
                    final_link_latlng = [];
                    getNodeNames();
                    // getTrapTypes();
                    $("#filter").button();
                    $("#difffromTime1").change(function () {
                        var frmTime = $("#difffromTime1").val();
                        console.log(" difffromTime1 changed " + frmTime);
                        $("#timeFrom").val(frmTime).trigger('input');
                    });
                    $("#difftoTime1").change(function () {

                        var toTime = $("#difftoTime1").val();
                        console.log(" difftoTime1 changed " + toTime);
                        $("#timeTo").val(toTime).trigger('input');
                    });
                    $("#vrfId").change(function () {

                        var nName = $("#vrfId").val();
                        var nstr = '"';
                        if (nName == null || nName == "")
                        {
                            nName = "ALL";
                        } else {
                            var j = 0;
                            nName.forEach(function (row) {
                                console.log(row);
                                if (j != 0)
                                    row = '","' + row;
                                nstr = nstr + row

                                j++;
                            });
                        }
                        nstr = nstr + '"';
                        $("#testinput").val(nstr).trigger('input');
                    });
                    $("#trapTypes").change(function () {

                        var tName = $("#trapTypes").val();
                        var str = '"';
                        if (tName == null || tName == "")
                        {
                            tName = "ALL";
                            str = str + "ALL";
                        } else {
                            var i = 0;
                            tName.forEach(function (row) {
                                console.log(row);
                                if (i != 0)
                                    row = '","' + row;
                                str = str + row

                                i++;
                            });
                        }
                        str = str + '"';
                        $("#trapinput").val(str).trigger('input');
                        console.warn($("#trapinput").val());
                    });
                    $('#difftimeCheckbox1').click(function () {
                        if ($(this).is(':checked')) {
                            $("#difftimerange1").show();
                        } else {
                            $("#difftimerange1").hide();
                        }
                    });
                    $("#difffromTime1").datetimepicker({
                        showSecond: true,
                        timeFormat: 'hh:mm:ss',
                        dateFormat: "yy-mm-dd",
                    });
                    $("#difftoTime1").datetimepicker({
                        showSecond: true,
                        timeFormat: 'hh:mm:ss',
                        dateFormat: "yy-mm-dd",
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
                function getTraps()
                {
                    var nodeName = $("#vrfId").val();
                    if (nodeName == "")
                        nodeName = "ALL";
                    var trapType = $("#trapTypes").val();
                    if (trapType == "")
                        trapType = "ALL";
                    var fromTime = $("#difffromTime1").val();
                    var toTime = $("#difftoTime1").val();
                    $.ajax({
                        type: "POST",
                        url: "../filters",
                        data: {requestType: "10", nodeName: nodeName, trapType: trapType, startTime: fromTime, endTime: toTime},
                        dataType: "json",
                        success: function (data) {
                        },
                        error: function (xhr, status, text) {

                        }
                    })
                }


                function getTrapTypes()
                {

                    $.ajax({
                        type: "POST",
                        url: "../FilterServlet",
                        data: {requestType: "12"},
                        dataType: "json",
                        success: function (data) {
                            updateTrapTypes(data)
                        },
                        error: function (xhr, status, text) {

                        }
                    })
                }
                function getNodeNames()
                {
                    $.ajax({
                        type: "POST",
                        url: "../FilterServlet",
                        data: {requestType: "11"},
                        dataType: "json",
                        success: function (data) {
                            updateNodeNames(data)
                        },
                        error: function (xhr, status, text) {

                        }
                    })
                }


                function updateTrapTypes(data)
                {
                    $('#trapTypes').empty();
                    if (data != null) {
                        for (var i = 0; i < data.length; i++)
                        {
                            $('#trapTypes').append('<option value="' + data[i] + '">' + data[i] + '</option>')
                        }
                        $('#trapTypes').select2({placeholder: "Select Trap Types"});
                    }

                }

                function updateNodeNames(data)
                {
                    $('#vrfId').empty();
                    if (data != null) {
                        for (var i = 0; i < data.length; i++)
                        {

                            $('#vrfId').append('<option value="' + data[i] + '">' + data[i] + '</option>')
                        }
                        $('#vrfId').select2({placeholder: "Select Node Names"});
                    }

                }

                $('#start_date_cal').datepicker({
                    todayHighlight: true,
                    autoclose: true,
                }).on('changeDate', function (selected) {
                    $(this).datepicker('hide');
                    startDate = new Date(selected.date.valueOf());
                    startDate.setDate(startDate.getDate(new Date(selected.date.valueOf())));
                    $('#end_date').datepicker('setStartDate', startDate);
                });

                function openFaultNewTab() {
                    var trapTypeVal = $("#trapTypes").val();
                    console.log("data from servlet: " + trapTypeVal);
                    var trapType = "";
                    for (var i = 0; i < trapTypeVal.length; i++) {
                        trapType += trapTypeVal[i] + ",";
                    }
                    trapType = trapType.substring(0, (trapType.length - 1));
                    console.log("TrapType : " + trapType);
                    $.ajax({
                        type: "POST",
                        url: "../Faults",
                        data: {requestType: "6", trapType: trapType},
                        dataType: "text",
                        success: function (data) {
                            console.log("New Tab Response : " + data)
                            if (data == "success") {
                                window.open("BFLTypeActive.jsp", "_blank");
                            }
                        },
                        error: function (xhr, status, text) {

                        }
                    })


                }
    </script>
</body>
</html>


