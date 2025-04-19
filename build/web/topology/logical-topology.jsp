<%-- 
    Document   : logical-topology
    Created on : 31 Mar, 2025, 4:29:42 PM
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
        <link rel="stylesheet" href="../assets/css/morris.css" />
        <link rel="stylesheet" href="../assets/admin/css/bootstrap.min.css">
        <link rel="stylesheet" href="../assets/css/font-awesome.min.css">
        <title>Topology</title>
        <link rel="icon" href="../assets/images/vsicon.png" type="image/x-icon" />
        <style>
            body{
                font-family-sans-serif: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";
                font-family-monospace: SFMono-Regular,Menlo,Monaco,Consolas,"Liberation Mono","Courier New",monospace;
                font-size: 1rem;
                margin-top: 30px;
                line-height: 1.5;
                background: #fff7f8;
                color:#1a1a1a;
            }
            .vega_btn {
                color: white;
                background: #990033;
                letter-spacing:0.1em;
            }
            .node {
                z-index: 100;
                position: absolute;
                stroke: #fff;
                stroke-width: 1.5px;
                cursor:  pointer;
            }
            .node .selected {
                fill:  #66FF00;
                stroke: #ff6117;
            }
            .downNode {
                fill:#FF0000;
            }
            .link {
                stroke-width: 2;
                width: 60px;
                stroke:#333;
                cursor:  pointer;
            }
            #canvasdiv {
                width: 85.5%;
                margin-left: 5px;
                overflow-x: scroll;
                overflow-y: scroll;
                height: 85vh;
                border: 1px solid #990033;
                border-radius: 5px;
            }
            /*            #svg_topology {
                background-size: 30px 25px;
                background-image: linear-gradient(to right, #E1E1E1 1px, transparent 1px), linear-gradient(to bottom, #E1E1E1 1px, transparent 1px);
            }*/
            .cloundname{
                font-size: 20px;
                top: 280px;
                left: 350px;
                position: absolute;
            }
            table {
                border-collapse: collapse;
            }
            td {
                padding-left: 5px;
                padding-right: 5px;
            }
            tr{
                padding-top:10px;
                padding-bottom:10px;
            }
            .downLink {
                stroke-width: 1.5;
                animation: blinker 1.7s cubic-bezier(.5, 0, 1, 1) infinite alternate;
                width: 20px;
                stroke:#FF0000;
                fill:#FF0000;
                cursor:  pointer;
            }
            .multiLink {
                stroke-width: 2;
                stroke: #999;
                fill: #999;
                cursor: cursor;
                -webkit-transform: translate3d(0,0,0);
                -moz-transform: translate3d(0,0,0);
                -ms-transform: translate3d(0,0,0);
                -o-transform: translate3d(0,0,0);
                transform: translate3d(0,0,0);
            }
            .multiLinkDown {
                stroke-width:1;
                stroke:#FF1493;
                fill:#FF1493;
                cursor:  pointer;
            }
            .name
            {
                position: absolute;
                font-size: 20px;
                fill : black;
                font-family: 'Lato', sans-serif !Important;
                cursor: default;
                -moz-user-select:none;
                -webkit-user-select: none;
                -ms-user-select:none;
                user-select:none;
                z-index:-1;
            }
            .name.hidden
            {
                display:  none;
            }
            .brush .extent {
                fill-opacity: .1;
                stroke: #fff;
                shape-rendering: crispEdges;
            }
            #rmenu.show  {
                position:  absolute;
                display: block;
                margin: 0;
            }
            .legends tr {
                padding-left: 5px;
                padding-right: 5px;
                border: 1px solid gray;
                padding: 4px;
            }
            /*            #canvasdiv {
                            width: 86.2%;
                            margin-left: 5px;
                            overflow-x: scroll;
                            overflow-y: scroll;
                            height: 92vh;
                            border: 1px solid #990033;
                            border-radius: 5px;
                        }*/
            .crc0{
                height: 5px;
                width: 20px;
                background:#999;
                margin: 5px;
                border-radius: 3px;
            }
            .crc0500{
                height: 5px;
                width: 20px;
                background:#4db6ac;
                margin: 5px;
                border-radius: 3px;
            }
            .crc500{
                height: 5px;
                width: 20px;
                background:#F57F17;
                margin: 5px;
                border-radius: 3px;
            }
            .u25{
                height: 5px;
                width: 20px;
                background:#999;
                margin: 5px;
                border-radius: 3px;
            }
            .link025 {
                stroke-width: 2;
                width: 60px;
                stroke:#999;
                stroke-opacity: 0.8;
                cursor:  pointer;
            }
            .u2550{
                height: 5px;
                width: 20px;
                background:#4db6ac;
                margin: 5px;
                border-radius: 3px;
            }
            .link2550 {
                stroke-width: 2;
                width: 60px;
                stroke:#4db6ac;
                stroke-opacity: 0.8;
                cursor:  cusor;
            }
            .u5075{
                height: 5px;
                width: 20px;
                background:#F57F17;
                margin: 5px;
                border-radius: 3px;
            }
            .link5075 {
                stroke-width: 2;
                width: 60px;
                stroke:#F57F17;
                stroke-opacity: 0.8;
                cursor:  pointer;
            }
            .u75{
                height: 5px;
                width: 20px;
                background:#880E4F;
                margin: 5px;
                border-radius: 3px;
            }
            .dl{
                height: 5px;
                width: 20px;
                background:red;
                margin: 5px;
                border-radius: 3px;
                animation-name: example;
                animation-duration: 1s;
                animation-iteration-count: infinite;
            }
            .link75 {
                stroke-width: 2;
                width: 60px;
                stroke-opacity: 0.8;
                stroke:#880E4F;
                cursor:  pointer;
            }
            .crcLegend
            {
                position: fixed;
                top: 36.5vh;
                right: 1rem;
                font-size: 12px;
                width: 11vw;
                padding: 5px;
                font-size: 12px;
                background-color: #fff;
                color: #1a1a1a;
                border-radius: 4px;
                box-shadow: 0 2px 5px 0 rgb(0 0 0 / 20%), 0 2px 10px 0 rgb(0 0 0 / 10%);
            }
            .crcLegend li{
                display: inline-flex;
                background-color: #F6F3FB;
                color: #1a1a1a;
                padding: 0.2vw;
                width: 10vw;
                margin: 1px;
                font-weight: 600;
            }
            .tierLegend {
                position: fixed;
                top: 45vh;
                right: 1rem;
                font-size: 12px;
                width: 11vw;
                padding: 5px;
                font-size: 12px;
                background-color: #fff;
                color: #1a1a1a;
                border-radius: 4px;
                box-shadow: 0 2px 5px 0 rgb(0 0 0 / 20%), 0 2px 10px 0 rgb(0 0 0 / 10%);
            }
            .utilLegend {
                position: fixed;
                top: 71vh;
                right: 0rem;
                font-size: 12px;
                width: 12vw;
                padding: 5px;
                font-size: 12px;
                background-color: #fff;
                color: #1a1a1a;
                border-radius: 4px;
                box-shadow: 0 2px 5px 0 rgb(0 0 0 / 20%), 0 2px 10px 0 rgb(0 0 0 / 10%);
            }
            .tierLegendList li{
                display: inline-flex;
                background-color: #F6F3FB;
                color: #1a1a1a;
                padding: 0.2vw;
                width: 10vw;
                margin: 1px;
                font-weight: 600;
            }
            .utilLegend li{
                display: inline-flex;
                background-color: #F6F3FB;
                color: #1a1a1a;
                padding: 0.2vw;
                width: 10vw;
                margin: 1px;
                font-weight: 600;
            }
            .linkNa {
                stroke-width: 2;
                width: 60px;
                stroke-opacity: 0.8;
                stroke:#111;
                cursor:  pointer;
            }
            .linkNa:hover {
                stroke-width: 2;
                stroke-opacity: 1;
            }
            .link025:hover {
                stroke-width: 2;
                stroke-opacity: 1;
            }
            .link2550:hover {
                stroke-width: 2;
                stroke-opacity: 1;
            }
            .link5075:hover {
                stroke-width: 2;
                stroke-opacity: 1;
            }
            .link75:hover {
                stroke-width: 2;
                stroke-opacity: 1;
            }
            @keyframes example {
                from {
                    stroke:#880E4F;
                }
                to {
                    stroke:red;
                }
            }

            @keyframes blinker {
                to {
                    opacity: 0;
                }
            }
            div.tooltip {
                position: absolute;
                text-align: left;
                width: 25rem;
                height: auto;
                padding: 8px;
                font: 12px sans-serif;
                background: #ffffff;
                color: #1a1a1a;
                border: 0px;
                border-radius: 8px;
                border:1px solid #1a1a1a;
                pointer-events: none;
            }
            #rmenu.hide {
                display: none;
            }
            #rmenu.show ul{
                background-color:  #ffffff;
                text-align:left;
            }
            #rmenu.show li{
                text-align:left;
                padding:3px 10px 3px 5px;
                margin:0;
                cursor:povarer;
                font-family: 'Lato', sans-serif !Important;
                text-decoration:none;
                color:#333;
                font-size:12px;
                font-weight:bold;
                border-top:1px solid #fff;
                border-left:1px solid #fff;
                border-bottom:1px solid #999;
                border-right:1px solid #999;
            }
            #rmenu.show a {
                border: 0 !important;
                text-decoration: none;
            }
            #rmenu.show a:hover {
                text-decoration: underline !important;
            }
            #healthstatus{
                right:90px;
                top: 100px;
                position: absolute;
            }
            .ui-widget-overlay {
                background: #eee url("../assets/images/ui-bg_diagonals-thick_90_eeeeee_40x40.png") 50% 50% repeat;
                opacity: 0;
                filter: Alpha(Opacity=0);
            }
            ul.nodelegenddata {
                position: fixed;
                top: 42px;
                left: 9px;
                list-style: none;
                letter-spacing: 0.1em;
                max-height: 500px;
                min-height: 500px;
                overflow-y: scroll;
                background: #990033;
            }
            .nodedetaillegend{
                position: fixed;
                top: 1rem;
                right: 10px;
                padding: 0.2vw;
                width: 11.2vw;
                font-size: 12px;
                background-color: #fff;
                color: #1a1a1a;
                border-radius: 4px;
                box-shadow: 0 2px 5px 0 rgb(0 0 0 / 20%),
                    0 2px 10px 0 rgb(0 0 0 / 10%);

            }
            .nodedetaillegenddata li {
                width: 10.3vw;
                background-color: #F6F3FB;
                color: #1a1a1a;
                padding: 0.2vw 0.3vw;
                border-radius: 5px;
                margin-bottom: 3px;
                text-decoration: none;
                letter-spacing: 0.1px;
                border-bottom: 0.1px solid white;
            }
            ul.nodelegenddata li {
                padding: 5px;
                font-size: 12px;
                background: #990033;
                color: white;
                border-bottom: 0.1px solid white;
                cursor: pointer;

                margin-left: -40px;
            }
            ul.nodelegenddata li:hover{
                background: #4a148c !Important;
            }
            .svg_background_img{
                background-image: url(../assets/images/india_outline.png);
                background-repeat: no-repeat;
                background-size: 1960px 1600px;
                /*background-size:  978px 474px;;*/
            }
            .svg_background_img1{
                background-size: 1960px 1600px;
            }
            div.dataTables_info {
                padding-left: 5px;
            }
            .dashboard_tbl_data{
                color: #000;
            }
            .row{
                margin-right: -5px;
                margin-left: -5px;
            }
            thead {
                background-color: #990033;
                color: white;
            }
            .header{
                -webkit-box-shadow: 0px 6px 8px 1px rgba(0,0,0,0.14);
                -moz-box-shadow: 0px 6px 8px 1px rgba(0,0,0,0.14);
                box-shadow: 0px 6px 8px 1px rgba(0,0,0,0.14);
            }
            .headerText{
                font-weight: 700;
            }
            .fancybox-content{
                color: #000;
                padding:35px;
            }
            .btn.focus, .btn:focus, .btn:hover{
                color:#eee;
            }
            .btn{
                vertical-align: bottom;
                border: 0;
                box-shadow: 0 2px 5px 0 rgb(0 0 0 / 20%), 0 2px 10px 0 rgb(0 0 0 / 10%);
                font-weight: 500;
                padding: 0.625rem 1rem 0.7rem;
                font-size: 1.1rem;
                line-height: 1.5;
                margin-top:1rem;
            }
            ::-webkit-scrollbar {
                width: 6px;
                height:6px;
            }
            ::-webkit-scrollbar-track {
                -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
                -webkit-border-radius: 5px;
                border-radius: 5px;
            }
            ::-webkit-scrollbar-thumb {
                -webkit-border-radius: 10px;
                border-radius: 10px;
                background: #bbb;
                -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.5);
            }
            ::-webkit-scrollbar-thumb:window-inactive {
                background: #888;
            }
            .custom-menu {
                display: none;
                list-style-type: none;
                z-index: 1000;
                position: absolute;
                overflow: hidden;
                border: 1px solid #CCC;
                white-space: nowrap;
                font-family: sans-serif;
                background: #FFF;
                color: #333;
                width:5vw;
                border-radius: 5px;
                transform: translate(-50%, -50%);
                padding:0;
            }
            .custom-menu li {
                cursor: pointer;
                border-bottom:1px solid #888;
            }
            .custom-menu a {
                display: block;
                padding: 6px 10px;
                position: relative;
                color: #000;
                background: #4db6ac;
            }
            .custom-menu li a:hover {
                background-color: #c8e6c9;
            }
            .nodeDetailsHeading{
                margin-bottom: 5px;
                font-weight: normal;
                border-bottom: 1px solid;
                width: 95%;
                font-size: 10px;
                margin-left: 5px;
            }
            .nodeDetailsValue{
                font-size: 11px;
                font-weight: 700;
                word-wrap: break-word;
            }
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
            .loading:not(:required) {
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
            .disabled{
                pointer-events: none;
                opacity: 0.1 !important;
            }
            .enabled{
                pointer-events: visible;
                opacity: 1;
            }
            .row .col.m6 {
                width: 50%;
                margin-left: auto;
                left: auto;
                right: auto;
            }
            .input-field {
                position: relative;
                margin-top: 1rem;
                margin-bottom: 1rem;
            }
            .select-wrapper {
                position: relative;
            }
            .select-wrapper input.select-dropdown {
                position: relative;
                cursor: pointer;
                background-color: transparent;
                border: none;
                border-bottom: 1px solid #9e9e9e;
                outline: none;
                height: 3rem;
                line-height: 3rem;
                width: 100%;
                font-size: 16px;
                margin: 0 0 8px 0;
                padding: 0;
                display: block;
                -webkit-user-select: none;
                -moz-user-select: none;
                -ms-user-select: none;
                user-select: none;
                z-index: 1;
            }
            ul:not(.browser-default) {
                padding-left: 0;
                list-style-type: none;
            }
            .dropdown-content {
                background-color: #fff;
                margin: 0;
                display: none;
                min-width: 100px;
                overflow-y: auto;
                opacity: 0;
                position: absolute;
                left: 0;
                top: 0;
                z-index: 9999;
                -webkit-transform-origin: 0 0;
                transform-origin: 0 0;
            }
            .select-dropdown.dropdown-content li.selected {
                background-color: rgba(0,0,0,0.03);
            }
            .select-wrapper .caret {
                position: absolute;
                right: 0;
                top: 0;
                bottom: 0;
                margin: auto 0;
                z-index: 0;
                fill: rgba(0,0,0,0.87);
            }
            select {
                background-color: rgba(255,255,255,0.9);
                width: 100%;
                padding: 5px;
                border: 1px solid #f2f2f2;
                border-radius: 2px;
                height: 3rem;
            }
            .comboBtn {
                padding: 0.5rem;
                background: #7986cb;
                color:#eee;
                letter-spacing: 0.1em;
                margin: 3px;
                display:inline-flex;
            }
            .custom-card {
                border: 0;
                box-shadow: 0 10px 30px 0 rgba(98, 89, 202, 0.05);
                margin-bottom: 20px;
            }
            *, :after, :before {
                box-sizing: border-box;
            }
            ul{
                margin-bottom:0;
            }
            /*            #svg_topology{
                            background-size: 30px 25px;
                            background-image: linear-gradient(to right, #e1e1e1 1px, transparent 1px), linear-gradient(to bottom, #e1e1e1 1px, transparent 1px);
                        }*/
            .padding-0{
                text-align: center;
                padding: 0;
            }
            .veticalLabel{
                width: 0px;
                word-break: break-all;
                white-space: pre-wrap;
                margin-top: 20px;
                font-family: initial;
            }
            .disabledDiv {
                pointer-events: none;
                opacity: 0.4;
            }
            .navbar-header {
                margin-top: -3rem;
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
            tr {
                height: 0px !important;
            }
            div#DataTables_Table_1_length label{
                display:flex;
            }
            .popup {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                border: 1px solid #ccc;
                padding: 20px;
                background-color: #fff;
                z-index: 1000;
            }

            .popup-content {
                position: relative;
            }

            .close {
                position: absolute;
                top: 10px;
                right: 10px;
                font-size: 20px;
                cursor: pointer;
            }
            .vega-btn1{
                background: #990033;
                color: white;
                font-size: 12px;
                text-align: center;
                height: 30px;
                padding: 3px 10px;
                margin-top: 2rem;
                width: 7rem;
            }
            .vega-btn1:hover{
                background: #990033;
                color: white;
                font-size: 12px;
                text-align: center;
                height: 30px;
                padding: 3px 10px;
                margin-top: 2rem;
                width: 7rem;
            }
        </style>
    </head>
    <body data-sidebar="dark">
        <jsp:include page="../common/usermenu.jsp"/>
        <div class="loading">Loading&#8230;</div>
        <div class="main-content">
            <div id="healthstatus"></div>


            <table style="margin-left: 2px;
                   margin-bottom: 5px;width:86%;">
                <tr>
                    <td style="width:10vw;">Group Type:<select id="groupnameId" style="width:140px;
                                                               height" onchange="getVRFnames()"></select></td>
                    <td style="width:10vw;">Group Name:<select id="vrfId" style="width:140px;
                                                               height"></select></td>
                    <td style="width:20vw;">
                        <button class="btn vega_btn" id="selectView">View</button>&nbsp;&nbsp;&nbsp; 
                        <button class="btn vega_btn" id="save" style="width:15rem;">Save Coordinates</button>
                    </td>
                    <td style="width:40rem;">
                        <input type="radio" name="topologyNamefilter" id="topologyNamefilter" value="nodename" checked="checked"/> &nbsp;&nbsp;<label>NodeName</label>
                        &nbsp;&nbsp; &nbsp;&nbsp;<input type="radio" name="topologyNamefilter" id="topologyNamefilter" value="nodeid"> &nbsp;&nbsp;<label>Node IP</label>
                    </td>

                    <td>
                        <button class="btn" id="openPopupBtn">Search</button>
                    </td>
                    <td><a class="btn" id="download" href="#">Download SVG</a></td>
                </tr>

            </table> 
            <div id="canvasdiv" >
                <svg id="svg_topology"></svg>
            </div>  
            <div id="dialogBox" title="" >
                <center>
                    <iframe src="" name="plot_iframe"  style=" width: 450px;
                            height: 180px; " frameborder="0"></iframe>
                </center>
            </div>
            <!--        
            -->

            <div class="tierLegend">
                <div class="col-md-12 padding-0">
                    <div class="col-md-1 padding-0" style="text-align: left;">
                        <label class="veticalLabel">TIER</label>
                    </div>
                    <div class="col-md-11 padding-0">
                        <ul class="tierLegendList">
                            <li>
                                <div class="col-md-8 padding-0"><img src="../assets/images/T2.png" style="height: 16px;width: 16px;"/>&nbsp;&nbsp;&nbsp; Router</div>
                                <div class="col-md-4 padding-0"><input type="checkbox" class="showTiers" name="tierValue" id="tier1" value="T1" checked="checked" /></div>
                            </li>
                            <li>
                                <div class="col-md-8 padding-0"><img src="../assets/images/greenswitch.png" style="height: 16px;width: 16px;"/>&nbsp;&nbsp;&nbsp; Switch</div>
                                <div class="col-md-4 padding-0"><input type="checkbox" class="showTiers" name="tierValue" id="tier2" value="T2" checked="checked" /></div>
                            </li>
                            <li>
                                <div class="col-md-8 padding-0"><img src="../assets/images/T3.png" style="height: 16px;width: 16px;"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Wifi</div>
                                <div class="col-md-4 padding-0"><input type="checkbox" class="showTiers" name="tierValue" id="tier3" value="T3" checked="checked" /></div>
                            </li>
                            <li>
                                <div class="col-md-8 padding-0" style="display:inline-flex;">
                                    <div style="margin-left:13px;"><img src="../assets/images/03.png" style="height: 16px;width: 16px"/></div><div style="margin-left:17px;">Other</div></div>
                                <div class="col-md-4 padding-0"><input type="checkbox" class="showTiers" name="tierValue" id="tier4" value="T4" checked="checked" /></div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="utilLegend">
                <div class="col-md-12 padding-0">
                    <div class="col-md-1 padding-0" style="text-align: left;">
                        <label class="veticalLabel" style="margin-top:40px;">UTIL</label>
                    </div>
                    <div class="col-md-11 padding-0">
                        <ul>
                            <li>
                                <div class="col-md-9 padding-0" style="display: inline-flex;padding:2px"><span class="u25"></span>&nbsp;&nbsp;&nbsp;0-25%</div>
                                <div class="col-md-3 padding-0"><input type="checkbox" class="showUtils" name="utilValue" id="util1" value="0-25" checked="checked"/></div>
                            </li>
                            <li>
                                <div class="col-md-9 padding-0" style="display: inline-flex;padding:2px"><span class="u2550"></span>&nbsp;&nbsp;&nbsp;25-50%</div>
                                <div class="col-md-3 padding-0"><input type="checkbox" class="showUtils" name="utilValue" id="util2" value="25-50" checked="checked"/></div>
                            </li>
                            <li>
                                <div class="col-md-9 padding-0" style="display: inline-flex;padding:2px"><span class="u5075"></span>&nbsp;&nbsp;&nbsp;50-75%</div>
                                <div class="col-md-3 padding-0"><input type="checkbox" class="showUtils" name="utilValue" id="util3" value="50-75" checked="checked"/></div>
                            </li>
                            <li>
                                <div class="col-md-9 padding-0" style="display: inline-flex;padding:2px"><span class="u75"></span>&nbsp;&nbsp;75-100%</div>
                                <div class="col-md-3 padding-0"><input type="checkbox" class="showUtils" name="utilValue" id="util4" value="75-100" checked="checked"/></div>
                            </li>
                            <li>
                                <div class="col-md-9 padding-0" style="display: inline-flex;padding:0px;"><span class="dl"></span>Down Link</div>
                                <div class="col-md-3 padding-0"><input type="checkbox" class="showUtils" name="utilValue" id="util5" value="down" checked="checked"/></div>
                            </li>
                        </ul>
                    </div>
                </div>

            </div>
            <div class="nodedetaillegend">
                <div style="font-weight: 600;padding: 6px;font-size: 13px;padding-top:0;">NODE DETAILS</div>
                <ul class="nodedetaillegenddata"></ul>
            </div>
            <div class="detailed_view_popup" style="display:none;">
                <div class="row header">
                    <h5>Physical Interface for <b id="headerFancy"></b></h5>
                </div>
                <br>
                <div class="dashboard_tbl" style="max-height: 375px;
                     overflow-y: scroll;"></div>
            </div>
            <div class="detailed_view_popup1" style="display:none;">
                <div class="row header">
                    <h5>Inventory</h5>
                </div>
                <br>
                <div class="dashboard_tbl" style="max-height: 375px;
                     overflow-y: scroll;"></div>
            </div>
            <div id="popupContainer" class="popup" style="display:none; height: 30rem;width: 80rem;border: 2px solid black">

                <div class="row popup-content">
                    <div class="col-md-12">
                        <div id="nodeType" class="form-group col-md-2" style="width: 25rem;">
                            <label for="first-name" style="width: 12rem;">Node Name</label>
                            <select  id="topologynode" onchange="getTopologyGroupName();" style="height:10px;display: inline-flex"></select>
                        </div>
                        <div id="nodeNameDiv" class="form-group col-md-3" style="width: 28rem;">
                            <label for="first-name" style="width: 10rem;">Group Name</label>
                            <select id="topologygroupname"  style="height:30px;display: inline-flex"></select>
                        </div>
                        <div id="TimeViewReport" class="col-md-1" >
                            <button id="getReport" class="btn vega-btn1"  onclick="viewReport();">View</button>
                        </div>
                        <div id="TimeViewReport" class="col-md-1">
                            <button id="closefancy" class="btn vega-btn1" style="margin-left:2rem">Close</button>
                        </div>
                    </div>
                </div>

            </div>
            <div class="modal fade" id="chartModalPlot" role="dialog">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header chartModelHeader" >
                            <h6 class="modal-title chartModelTitlePlot"></h6>
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <div class="row" id="chartContainerPlot"> </div>
                            <div class="row" id="dataContainerPlot" style="width:96%;
                                 margin-left: 18px;">
                                <table id="chartTablePlot" class="display compact cell-border" cellspacing="0"  width="100%"></table>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn" id="chartDataButton" style="float: left;
                                    background-color: #990033;
                                    color: white;">Data</button>
                            <button type="button" class="btn" id="ChartPlotButton" style="float: left;
                                    background-color: #990033;
                                    color: white;" >Graph</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <!--<button type="button" class="btn btn-default" onClick='myFunction()'>Download PDF</button>-->
                        </div>
                    </div>
                </div>
            </div>

            <ul class='custom-menu' >
                <li data-action = "first"><a href="#">Interface</a></li>
            </ul>
        </div>

        <jsp:include page="../common/user-footer.jsp"/>
        <script type="text/javascript" src="../assets/js/d3.v3.min.js"  charset="utf-8"></script>
        <script type="text/javascript" src="logical-topopology.js"></script>
        <script type="text/javascript" src="../assets/js/saveSvgAsPng.js"></script>
        <script>
                                var username1 = '<%=user%>';
                                $(document).ready(function () {
                                    $('.shrink-btn').trigger("click");
                                });
        </script>

    </body>
</html>