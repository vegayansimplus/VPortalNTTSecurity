<%-- 
    Document   : adminmenu
    Created on : 24 Mar, 2025, 3:12:30 PM
    Author     : lapto
--%>
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

<div id="layout-wrapper">
    <!--        <header id="page-topbar">-->
    <div class="navbar-header">
        <div class="d-flex">
            <!-- LOGO -->

            <div class="navbar-brand-box">
                <a href="index.html" class="logo logo-dark">
                    <span class="logo-sm">
                        <img src="../assets/images/NTT_icon.jpg" alt="" height="40" width="60">
                    </span>
                    <span class="logo-lg">
                        <img src="../assets/images/NTT_icon.jpg" alt="" height="40" width="60">
                    </span>
                </a>

                <a href="index.html" class="logo logo-light">
                    <span class="logo-sm">
                        <img src="../assets/images/NTT_icon.jpg" alt="" height="30" width="30" style="margin-top: -2rem;">
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
                            <i class="ic-dashboard"></i>
                            <span key="t-users">Discovery</span>
                        </a>
                        <ul class="sub-menu" aria-expanded="false">
                            <li>
                                <a href="../admin/createDiscovery.jsp" key="t-noc"> <i class='ic-arrowsubmenu'></i>Discovery</a>
                            </li>

                        </ul>
                    </li>
                    <li>
                        <a href="javascript: void(0);" class="has-arrow waves-effect">
                            <i class="ic-dashboard"></i>
                            <span key="t-users">Devices</span>
                        </a>
                        <ul class="sub-menu" aria-expanded="false">
                            <li>
                                <a href="../admin/provisioned-devices.jsp" key="t-ipv6free"><i class='ic-arrowsubmenu'></i>Provisioned Devices</a>
                            </li>
                            <li>
                                <a href="../admin/deprovisioned-devices.jsp" key="t-ipv6free"><i class='ic-arrowsubmenu'></i>DeProvisioned Devices</a>
                            </li>
                            <li>
                                <a href="../admin/delete-device.jsp" key="t-ipv6free2"><i class='ic-arrowsubmenu'></i>Delete Devices</a>
                            </li>

                        </ul>
                    </li>
                    <li>
                        <a href="javascript: void(0);" class="has-arrow waves-effect">
                            <i class="ic-dashboard"></i>
                            <span key="t-users">Devices Reachability</span>
                        </a>
                        <ul class="sub-menu" aria-expanded="false">
                            <li>
                                <a href="../admin/snmpUpdate.jsp" key="t-noc"> <i class='ic-arrowsubmenu'></i>SNMP Update</a>
                            </li>
                            <li>
                                <a href="../admin/icmpReachability.jsp" key="t-noc"> <i class='ic-arrowsubmenu'></i>ICMP Reachability</a>
                            </li>
                            <li>
                                <a href="../admin/traceReachability.jsp" key="t-noc"> <i class='ic-arrowsubmenu'></i>Trace Reachability</a>
                            </li>

                        </ul>
                    </li>
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
    <script>
        function viewCurrentThreshold() {

            window.open("../user/b2bServices.jsp?type=home", "_blank");
        }
    </script>
