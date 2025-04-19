<%-- 
    Document   : usermenu
    Created on : 27 Mar, 2025, 5:48:59 PM
    Author     : lapto
--%>
<%
    String USER = "";
    String user = "";
    String role = "";
    
    if (session == null) {
        response.sendRedirect("/BFL/sessionexp.jsp");
        return;
    } else {
        if (session.getAttribute("user") != null) {
            user = session.getAttribute("user").toString();
            role = session.getAttribute("role").toString();
        } else {
            response.sendRedirect("/BFL/sessionexp.jsp");
            return;
        }
    }
    USER = user.toUpperCase();

%>


<div id="layout-wrapper">
    <!--        <header id="page-topbar">-->
    <div class="navbar-header">
        <div class="d-flex">
            <!-- LOGO -->

            <div class="navbar-brand-box">
                <a href="#" class="logo logo-dark" style="cursor: default">
                    <span class="logo-sm">
                        <img src="../assets/images/NTT_icon.jpg" alt="" height="20" width="40">
                    </span>
                    <span class="logo-lg">
                        <img src="../assets/images/NTT_icon.jpg" alt="" height="40" width="60">
                    </span>
                </a>

                <a href="#" class="logo logo-light" style="cursor: default">
                    <span class="logo-sm">
                        <img src="../assets/images/NTT_icon.jpg" alt="" height="20" width="40" style="margin-top: -2rem;">
                    </span>
                    <span class="logo-lg">
                        <img src="../assets/images/NTT_icon.jpg" alt="" height="40" width="60"> 
                    </span>
                </a>
            </div>
            <div class="sidebar-top">
                <span class="shrink-btn header-item waves-effect" id="vertical-menu-btn">
                    <i class='ic-arrow-left'></i>
                </span>

            </div>

        </div>

    </div>
    <!--</header>-->

    <!-- ========== Left Sidebar Start ========== -->
    <div class="vertical-menu">

        <div data-simplebar class="h-100">

            <!--- Sidemenu -->
            <div id="sidebar-menu">
                <!-- Left Menu Start -->
                <ul class="metismenu list-unstyled" id="side-menu">

                    <li>
                        <a href="javascript: void(0);" class="has-arrow waves-effect">
                            <!--<i class="ic-dashboard"></i>-->
                            <i class="ic-dashboard" style="font-size: 16px;"></i>
                            <span key="t-users">Dashboard</span>
                        </a>
                        <ul class="sub-menu" aria-expanded="false">
                            <li>
                                <a href="../dashboard/summary-dashboard.jsp" key="t-ipv6free"><i class='ic-arrowsubmenu'></i>Network Summary</a>
                            </li>
                            <li>
                                <a href="../dashboard/node-dashboard.jsp" key="t-ipv6free"><i class='ic-arrowsubmenu'></i>Node Dashboard</a>
                            </li>
                            <li>
                                <a href="../dashboard/backbone-dashboard.jsp" key="t-ipv6free"><i class='ic-arrowsubmenu'></i>BackBone Dashboard</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="javascript: void(0);" class="has-arrow waves-effect">
                            <!--<i class="ic-dashboard"></i>-->
                            <i class="ic-reports" style="font-size: 16px;"></i>
                            <span key="t-report">Reports</span>
                        </a>
                        <ul class="sub-menu" aria-expanded="false">
                            <li>
                                <a href="../performanceReport/port-traffic.jsp" key="t-ipv6free"><i class='ic-arrowsubmenu'></i>Port Traffic</a>
                            </li>
                            <li>
                                <a href="../performanceReport/cpu-traffic.jsp" key="t-ipv6free"><i class='ic-arrowsubmenu'></i>CPU</a>
                            </li>
                            <li>
                                <a href="../performanceReport/temp-traffic.jsp" key="t-ipv6free"><i class='ic-arrowsubmenu'></i>Temp</a>
                            </li>
                            <li>
                                <a href="../performanceReport/storage-traffic.jsp" key="t-ipv6free"><i class='ic-arrowsubmenu'></i>Storage</a>
                            </li>
                             <li>
                                <a href="../performanceReport/ospf-report.jsp" key="t-ipv6free"><i class='ic-arrowsubmenu'></i>OSPF Report</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="javascript: void(0);" class="has-arrow waves-effect">
                            <i class="ic-dashboard"></i>
                            <span key="t-users">Inventory</span>
                        </a>
                        <ul class="sub-menu" aria-expanded="false">
                            <li>
                                <a href="../inventory/node-inventory.jsp" key="t-noc"> <i class='ic-arrowsubmenu'></i>Nodes</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="javascript: void(0);" class="has-arrow waves-effect">
                            <!--<i class="ic-dashboard"></i>-->
                            <i class="fa fa-bell" style="font-size: 16px;"></i>
                            <span key="t-users">Faults</span>
                        </a>
                        <ul class="sub-menu" aria-expanded="false">
                            <li>
                                <a href="../fault/active-fault.jsp" key="t-noc"> <i class='ic-arrowsubmenu'></i>Active Faults</a>
                            </li>
                             <li>
                                <a href="../fault/hist-fault.jsp" key="t-noc"> <i class='ic-arrowsubmenu'></i>Historic Faults</a>
                            </li>
                        </ul>
                    </li>

                    <li>
                        <a href="javascript: void(0);" class="has-arrow waves-effect">
                            <!--<i class="ic-dashboard"></i>-->
                            <i class="fa fa-sitemap" style="font-size: 16px;"></i>
                            <span key="t-users">Topology</span>
                        </a>
                        <ul class="sub-menu" aria-expanded="false">
                            <li>
                                <a href="../topology/logical-topology.jsp" key="t-noc"> <i class='ic-arrowsubmenu'></i>Logical</a>
                            </li>
                        </ul>
                    </li>

                    <li>
                        <a href="../scheduleReports/canned-report.jsp" class="waves-effect">
                            <!--<i class="ic-reports"></i>-->
                            <i class="fa fa-code-fork" style="font-size: 20px;"></i>
                            <span key="t-report">Scheduled Reports</span>
                        </a>
                    </li>
                    <%
                           if(role == "NTTAdmin"){
                    %>
                    <li>
                        <a onclick="viewAdminPortal();" href="javascript:void(0);" class="waves-effect">
                            <!--<i class="ic-reports"></i>-->
                            <i class="fa fa-user" style="font-size: 20px;"></i>
                            <span key="t-report">Admin Portal</span>
                        </a>
                    </li>
                  
                    <!--</li>-->
                    <%
                           }  
                    %>
                   
                    <li>
                        <a href="../Logout?user=<%=user%>" class="waves-effect">
                            <i class="fa fa-sign-out" style="font-size: 20px;"></i>
                            <span key="t-report">LogOut</span>
                        </a>
                    </li>

                </ul>
                <div class="sidebar-footer">

                    <div class="admin-user tooltip-element" data-tooltip="1">
                        <div class="admin-profile">
                        </div>

                    </div>
                </div>
            </div>
            <!-- Sidebar -->
        </div>
    </div>
    <div id="myModalTrapPop" class="modal fade" data-backdrop="static" role="dialog" style="margin-left:17rem;width: 130rem;">
        <div class="modal-dialog  modal-lg" style="width: 1100px;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">

                    <h4 class="modal-title" style="margin-left:1rem;">Trap Details</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body modalBody" style="margin-left:2rem;overflow: scroll;height: 32rem;">
                    <!--<table id="example" class="display compact cell-border" cellspacing="0"  width="100%"></table>-->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>



        </div>
    </div>


    <script>
        var dataTableObject;
        function viewCurrentThreshold() {

            window.open("../user/slidderDashboard.jsp", "_blank");
        }
        function viewAdminPortal() {
            window.open("../admin/AdminHome.jsp", "_blank");
        }
        function getHelpdocument() {
            window.open("../user/User_Manual_BFL.pdf", "_blank");

        }
        function sayHello(flag, traptype, senderip, starttime, endtime, status) {

            $(".modal-title").text("Counter Details");

            console.log(starttime);
            console.log(endtime);
            $(".modalBody").html('<center>Loading...</center>');
            $.ajax({
                type: "POST",
                url: "../FilterServlet",
                data: {requestType: "20",
                    flag: flag,
                    senderip: senderip,
                    starttime: starttime,
                    endtime: endtime,
                    traptype: traptype,
                    status: status


                },
                dataType: "json",
                success: function (data) {
                    var tabledata = '<table id="example" class="display compact cell-border" cellspacing="0"  width="100%">';
                    tabledata = tabledata + '<tr><th>Node Name</th><th>Sender IP</th><th>Trap Type</th><th>Status</th><th>Rev Time</th><th>clear Time</th></tr>';
                    for (var i = 0; i < data.length; i++) {
                        tabledata = tabledata + "<tr><td>" + data[i][0] + "</td><td>" + data[i][1] + "</td><td>" + data[i][2] + "</td><td>" + data[i][3] + "</td><td>" + data[i][4] + "</td><td>" + data[i][5] + "</td></tr>";
                    }
                    tabledata = tabledata + '</table>'
                    $(".modalBody").html(tabledata);
                    $('#example').dataTable({

                    })
                },
                error: function (exception) {
                    console.log('Exeption:' + exception);
                    console.log(exception);
                }
            });
            $('#myModalTrapPop').modal('toggle');
        }
        function generateTableSayHello(data) {

            var dataTableObject = $('#example').DataTable({
                data: data,
                "columnDefs": [
                    {"width": "160px", "targets": 0},
                    {"width": "80px", "targets": 1},
                    {"width": "100px", "targets": 2},
                    {"width": "200px", "targets": 3},
                    {"width": "200px", "targets": 4},
                    {"width": "200px", "targets": 5},
                    {"width": "200px", "targets": 6},
                ],
                columns: [
                    {title: "Node Name"},
                    {title: "Sender IP"},
                    {title: "Trap Type"},
                    {title: "Status1"},
                    {title: "Received Time"},
                    {title: "Status2"},
                    {title: "Cleared Time"},
                ],
                "scrollX": true,
                fixedHeader: true, dom: 'Blfrtip',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Counter Details'
                    },
                    {
                        extend: 'pdfHtml5',
                        title: 'Counter Details'
                    }
                ]
            });


        }
    </script>
