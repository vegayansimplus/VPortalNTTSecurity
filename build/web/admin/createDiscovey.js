/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var color;
var bgcolor;
var table_data = [];
var rectifier_table_data = [];
var input_data;
var max;
var min;
var status = 0;
var csvData = {};
var node_yes_count = 0;
var node_yes_count_rect = 0;
var NODEIP;
var NODEIPRECT;
var currentData;
var pingDeviceCounts = 0;



$(document).ready(function () {
    $(".new_device_content").show();
    $('#sampleCsv').click(function (e) {
        e.preventDefault();  //stop the browser from following
        window.location.href = "Sample-IP-Discover.csv";
    });

    $('#sampleRectifierCsv').click(function (e) {
        e.preventDefault();  //stop the browser from following
        window.location.href = "sampleRectifierCSV.csv";
    });

    $('#rootwizard').bootstrapWizard({//for 
        tabClass: 'nav nav-pills nav-justified',
        onTabShow: function (tab, navigation, index) {
            var $total = navigation.find('li').length;
            var $current = index + 1;
            var $percent = ($current / $total) * 100;
            $('#rootwizard').find('.bar').css({width: $percent + '%'});

            // If it's the last tab then hide the last button and show the finish instead
            if ($current >= $total) {
                $('#rootwizard').find('.pager .next').hide();
                $('#rootwizard').find('.pager .finish').show();
                $('#rootwizard').find('.pager .finish').removeClass('disabled');
            } else {
                $('#rootwizard').find('.pager .next').show();
                $('#rootwizard').find('.pager .finish').hide();

            }
        },
        onTabClick: function (tab, navigation, index) {
            return false;
        },
        onNext: function (tab, navigation, index) {
            if (index == 1) {
                if (status == 0) {
                    //console.log("for New Discovery");
                    if ($("#uploadCSV").val() == "") {
                        alert("Please Upload a CSV");
                        return false;
                    } else if ($('#disp_table').is(':empty')) {
                        return false;
                    }
                } else {
                    //console.log("for retry Discovery");
                    status = 0;
                }
                //console.log("Table Data value:");
                //console.log(table_data);
                $("#disp_table_2").html("");
                $("#disp_table_2").html("Loading....");
                $('#preCheckPB').css('width', '0').attr('aria-valuenow', "0");
                $('#preCheckPB').css('color', '#FFF').css('background-color', "#990033");
                saveSnmpDetails().done(function (data) {
                    console.log(username1);
                    console.log("data:"+data);
//                    writeToWebLogMultiple(data);
                    //console.log("data saving done..");
                    if (data == "success") {
                        var row_count = table_data.length;
                        CheckEngineID().done(function (data) {
                            dispFinalData(row_count);
                        });
                    }
                });
            }
            if (index == 2) {
                $("#previous").show();
                if (node_yes_count == 0) {
                    alert("IPs are not ready to discover. Start Again");
                    return false;
                } else {
                    $("#tab3").html("");
                    $("#tab3").html("<b style='font-size:14px;'>Device Added for discovery. It will  be discovered in next discovery cycle...</b>");

                }

            }
        }
    });
    function writeToWebLogMultiple(status) {
        console.log("status:"+status);
        var dataSNMP = "";
        for (var i = 0; i < table_data.length; i++) {
            dataSNMP = dataSNMP + table_data[i] + "&&";
        }
        dataSNMP = dataSNMP.substring(0, (dataSNMP.length - 1));
        $.ajax({
            type: "POST",
            url: "../writeToWebLog",
            data: {"requestType": 2, nodeip: dataSNMP, username: username1, activity: "Device Discovery", status: status},
            dataType: "text",
            success: function (data) {
                console.log(data);


            }
        });
    }




    $("#btnExport").click(function (e) {
        $("#table").table2excel({
            exclude: ".noExl",
            name: "Sheet1",
            filename: "SNMPStausTable", //do not include extension
            fileext: ".xls"
        });
    });
    $('#rootwizard .finish').click(function () {
        alert('Finished!, Starting over!');
        $('#rootwizard').find(".container a[href='#tab1']").tab("show");
        $("#li1").addClass('active_element');
        $("#li2").removeClass('active_element');
        $("#li3").removeClass('active_element');
        table_data = [];
        snmp_data = [];
        $("#disp_table").html('');
        $("#disp_table_2").html('');
        $("#uploadCSV").val("");
    });
});


function getCurrentDevices() {
    $("#li1").addClass('active_element');
    $("#li2").removeClass('active_element');
    $("#li3").removeClass('active_element');
    $(".current_device_content").show();
    $(".new_device_content").hide();
    $(".new_rectifier_content").hide();
    $(".new_device_content_range").hide();
    $.ajax({
        type: "POST",
        url: "../AdminDiscovery",
        data: {requesttype: "1"},
        datatype: "json",
        success: function (data) {
            //console.log("Device data");
            data = JSON.parse(data);
            //console.log(data);
            for (var i = 0; i < data.length; i++) {
                data[i][6] = '<input type = "checkbox" name="delcheck" id="ck' + i + '" value="' + data[i][1] + '">';
            }
            currentData = data;
            var dataTableObject = $('#device_table').DataTable({
                data: data,
                "columnDefs": [
                    {"width": "200px", "targets": 0},
                    {"width": "100px", "targets": 1},
                    {"width": "150px", "targets": 2},
                    {"width": "150px", "targets": 3},
                    {"width": "150px", "targets": 4},
                    {"width": "150px", "targets": 5},
                    {"width": "50px", "targets": 6}
                ],
                columns: [
                    {title: "Node Name"},
                    {title: "Node ID"},
                    {title: "Node Description"},
                    {title: "Node Location"},
                    {title: "Latitude"},
                    {title: "Longitude"},
                    {title: ""}
                ],
                scrollX: "50vh",
                scrolly: "390px",
                fixedHeader: true, dom: 'Blfrtip',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'All Added Device List'
                    },
                    {
                        extend: 'pdfHtml5',
                        title: 'All Added Device List',
                        orientation: 'landscape'
                    }
                ]
            });
        }
    });
}

function deleteSelectedNode() {
    if (confirm("Are you sure?")) {
        var favorite = [];
        $.each($("input[name='delcheck']:checked"), function () {
            favorite.push($(this).val());
        });
        var data = favorite.join(",");
        //console.log("My favourite sports are: " + data);
        $.ajax({
            type: "POST",
            url: "../AdminDiscovery",
            data: {requesttype: "5", nodeIP: data},
            datatype: "json",
            success: function (data) {
                //console.log(data);
                if (data == "success") {
                    $(".currentTableContent").html('');
                    $(".currentTableContent").html('<table id="device_table" class="display compact cell-border" cellspacing="0"  width="60%"></table>');
                    $(".currentTableContent").append('<button class="vega-btn btn" onclick="deleteSelectedNode()" style="float: right">Delete Node</button>');
                    getCurrentDevices();
                } else {
                    alert("Deletion was unsuccessful.");
                }

            }
        });
    } else {
    }

}

function addNewDevice() {
    $("#li2").addClass('active_element');
    $("#li1").removeClass('active_element');
    $("#li3").removeClass('active_element');
    $("#li4").removeClass('active_element');
    $(".current_device_content").hide();
    $(".new_device_content_range").hide();
    $(".new_rectifier_content").hide();
    $(".new_device_content").show();
    $("#finalResult").hide();

}
function addNewDeviceRange() {
    $("#li3").addClass('active_element');
    $("#li1").removeClass('active_element');
    $("#li2").removeClass('active_element');
    $("#li4").removeClass('active_element');

    $(".current_device_content").hide();
    $(".new_device_content_range").show();
    $(".new_rectifier_content").hide();
    $(".new_device_content").hide();
    $("#finalResult").hide();

}

function addNewRectifier() {
    $("#li4").addClass('active_element');
    $("#li1").removeClass('active_element');
    $("#li3").removeClass('active_element');
    $("#li2").removeClass('active_element');
    $(".new_rectifier_content").show();
    $(".current_device_content").hide();
    $(".new_device_content_range").hide();
    $(".rectifierTableDisp").hide();
    $(".new_device_content").hide();
    $("#finalResult").hide();

}

function checkIPAddress() {
    var val = $("#ipAddress").val().trim();
    if (!val.includes(".")) {
        alert("Enter correct IP Address . not present");
        return;
    }
    var valarr = val.split(".");
    //console.log("valarr.length");
    //console.log(valarr.length);
    if (valarr.length != 4) {
        alert("enter correct IP Address length not proper");
        return false;
    }
    if (!(valarr[0] >= 0 && valarr[0] <= 255)) {
        alert("enter correct IP Address ragnge not proper");
        return false;
    } else if (!(valarr[1] >= 0 && valarr[1] <= 255)) {
        alert("enter correct IP Address ragnge not proper");
        return false;
    } else if (!(valarr[2] >= 0 && valarr[2] <= 255)) {
        alert("enter correct IP Address ragnge not proper");
        return false;
    } else if (!(valarr[3] >= 0 && valarr[3] <= 255)) {
        alert("enter correct IP Address ragnge not proper");
        return false;
    }
    return true;
}
function addDevice() {
    $("#addDeviceResult").html('Loading...');
    var val = $("#ipAddress").val();
    if (checkIPAddress()) {
        $.ajax({
            type: "POST",
            url: "../DeviceSSHServlet",
            data: {ipaddress: val},
            datatype: "text",
            success: function (data) {
                //console.log(data);
                if (data.includes("PingTest") && data.includes("SNMPTest")) {
                    var dataLoc = data.indexOf('PingTest');
                    //console.log(dataLoc);
                    var dataGet = data.substr(dataLoc);
                    //console.log(dataGet);
                    $("#addDeviceResult").html('');
                    var resData = dataGet.split(",");
                    var resdata1 = resData[0].split(":");
                    var resdata2 = resData[1].split(":");
                    var nodeip = resData[2];
                    var htmlData = '<div style="text-align: center"> <b>Device Reachability Check</b> </div><br><table class="display compact cell-border"  width="60%" id="resultTable"><thead><tr><td>Test Name</td><td>Test Result</td></tr></thead><tbody><tr><td>' + resdata1[0] + '</td><td>' + resdata1[1] + '</td></tr><tr><td>' + resdata2[0] + '</td><td>' + resdata2[1] + '</td></tr></tbody></table><br><br>';
                    $("#addDeviceResult").html(htmlData);
                    $("#resultTable").dataTable({
                        "bFilter": false,
                        "paging": false,
                        "bLengthChange": false,
                        "ordering": false,
                        "info": false
                    });
                    $("#finalResult").show();
                    getTestResults(resdata1[1], resdata2[1], nodeip);

                } else {
                    $("#addDeviceResult").html('');
                    $("#addDeviceResult").html('Script Run failed');
                }
            }
        });
    }
}

function getTestResults(d1, d2, nodeip) {
    if (d1.trim() == "Successful" && d2.trim() == "Successful") {
        var d = new Date();
        var hr = d.getHours();
        var nexttime = "";
        if (hr > 0 && hr < 6) {
            nexttime = 6 - hr;
            //console.log(nexttime);
        } else if (hr > 6 && hr < 12) {
            nexttime = 12 - hr;
            //console.log(nexttime);
        } else if (hr > 12 && hr < 18) {
            nexttime = 18 - hr;
            //console.log(nexttime);
        } else if (hr > 18 && hr < 24) {
            nexttime = 24 - hr;
            //console.log(nexttime);
        }
        $("#finalResult").html("<b>Adding Device for ip " + nodeip + " successful. Discovery will start in " + nexttime + " hours.</b>");
    } else {
        $("#finalResult").html("<b>Adding Device for ip " + nodeip + " failed. Please try again!!!</b>");

    }
}



function uploadData1() {
    //console.log("Upload data1 called")
    $.ajax({
        url: uploadData(),
        success: function (data) {
            if (data == "fail") {

            } else {
                dispTable();
            }
        }
    });
}
function uploadRectifierData1() {
    //console.log("Upload data1 called")
    $(".rectifierTableDisp").hide();
    $.ajax({
        url: uploadRectifierData(),
        success: function (data) {
            if (data == "fail") {

            } else {
                dispRectifierTable();
            }
        }
    });
}



function uploadData() {
    //console.log("UploadData Called")
    $("#disp_table").html('');
    $("#disp_table_2").html('');
    table_data = [];
    var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.csv|.txt)$/;
    if (regex.test($("#uploadCSV").val().toLowerCase())) {
        if (typeof (FileReader) != "undefined") {
            var reader = new FileReader();
            reader.onload = function (e) {
                var rows = e.target.result.split("\n");
                dataCSV = JSON.stringify(rows);
                input_data = "";
                for (var i = 0; i <= rows.length; i++)
                {
                    console.log(i);
                    console.log(rows[i]);
                    var row_data = rows[i].toString();
                    if (row_data[0] == "#" || row_data[0] == " ") {
                    } else {
                        table_data.push(row_data);
                        var split_data = row_data.split(",");
                        var line = "";
                        line = split_data[0] + "," + split_data[1] + "," + split_data[2] + "," + split_data[3] + "," + split_data[4] + "," + split_data[5] + "," + split_data[6] + "," + split_data[7] + "," + split_data[8];
                        input_data = input_data + ":" + line;
                        csvData[split_data[0]] = row_data;
                    }
                }
            }
            reader.readAsText($("#uploadCSV")[0].files[0]);
        } else {
            alert("This browser does not support HTML5.");
        }
    } else {
        alert("Please upload a valid CSV file.");
        return "fail";
    }

}

function uploadRectifierData() {
    //console.log("UploadData Called")
    $("#rect_table").html('');
    //$("#disp_table_2").html('');
    rectifier_table_data = [];
    var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.csv|.txt)$/;
    if (regex.test($("#uploadRectCSV").val().toLowerCase())) {
        if (typeof (FileReader) != "undefined") {
            var reader = new FileReader();
            reader.onload = function (e) {
                var rows = e.target.result.split("\n");
                console.log(rows.length);
                dataCSV = JSON.stringify(rows);
                input_data = "";
                for (var i = 0; i < rows.length; i++)
                {
                    console.log(i);
                    console.log(rows[i]);
                    var row_data = rows[i].toString();
                    if (row_data[0] == "#" || row_data[0] == " ") {
                    } else {
                        rectifier_table_data.push(row_data);
                        var split_data = row_data.split(",");
                        var line = "";
                        line = split_data[0] + "," + split_data[1] + "," + split_data[2] + "," + split_data[3] + "," + split_data[4] + "," + split_data[5];
                        input_data = input_data + ":" + line;
                        csvData[split_data[0]] = row_data;
                    }
                }
            }
            reader.readAsText($("#uploadRectCSV")[0].files[0]);
        } else {
            alert("This browser does not support HTML5.");
        }
    } else {
        alert("Please upload a valid CSV file.");
        return "fail";
    }

}



function dispTable() {
    //console.log("In dsip table");
    //console.log(table_data);
    $("#fileFormat").hide();
    var table_html = '<table class="table table-bordered"><thead  class ="table_header"><tr><td>Node IP</td><td>Version</td><td>Username</td><td>Group Name</td><td>Vendor Name</td><td>Sub GroupName</td><td>Auth Proto</td><td>Encryption</td></thead><tbody>';
    for (var i = 1; i < table_data.length; i++)
    {
        var data = table_data[i].split(",");
        table_html = table_html + '<tr>';
        for (var j = 0; j < data.length; j++) {
            table_html = table_html + '<td>' + data[j] + '</td>'
        }
        table_html = table_html + '</tr>';
    }
    table_html = table_html + '<tbody></table>';
    $("#disp_table").html(table_html);
}

function dispRectifierTable() {
    //console.log("In dsip table");
    //console.log(table_data);
    $("#fileFormat").hide();
    var table_html = '<table class="table table-bordered"><thead  class ="table_header"><tr><td>Node ID</td><td>Node Name</td><td>Node Location</td><td>Node Type</td></tr></thead><tbody>';
    for (var i = 0; i < rectifier_table_data.length; i++)
    {
        var data = rectifier_table_data[i].split(",");
        table_html = table_html + '<tr>';
        for (var j = 0; j < data.length; j++) {
            table_html = table_html + '<td>' + data[j] + '</td>'
        }
        table_html = table_html + '</tr>';
    }
    table_html = table_html + '</tbody></table>';
    $("#rect_table").html(table_html);
    $("#saveRectifier").show();
}


function saveSnmpDetails() {
    var dataSNMP = "";
    for (var i = 0; i < table_data.length; i++) {
        dataSNMP = dataSNMP + table_data[i] + ":";
    }
    //console.log("*******dataSNMP*******");
    dataSNMP = dataSNMP.substring(0, (dataSNMP.length - 1));
    return $.ajax({
        type: "POST",
        url: "../AdminDiscovery",
        dataType: "text",
        data: {requesttype: 2, data: dataSNMP}
    });
}

function saveRectifierDetails() {
    var dataRectifier = "";
    $('#preCheckPBRect').css('width', '0').attr('aria-valuenow', "0");

    for (var i = 0; i < rectifier_table_data.length; i++) {
        dataRectifier = dataRectifier + rectifier_table_data[i] + ":";
    }
    pingDeviceCounts = rectifier_table_data.length;

    //console.log("*******dataSNMP*******");
    dataRectifier = dataRectifier.substring(0, (dataRectifier.length - 1));
    console.log(dataRectifier);
    console.log(rectifier_table_data);
    console.log(pingDeviceCounts);
    console.log("*******dataRectifier*******");
    $.ajax({
        type: "POST",
        url: "../AdminDiscovery",
        dataType: "text",
        data: {requesttype: 6, data: dataRectifier},
        success: function (data) {
            if (data == "fail") {
                alert("Error while saving");
            } else {
                $(".rectifierTableDisp").show();
                CheckPingForDevices().done(function (data) {
                    //getPingIPDetails();
                    console.log("Check for ping script call done")
                    dispRectifierTable2(pingDeviceCounts);
                });
            }
        }
    });
}


function CheckPingForDevices() {
    var url = "../ConfigSSHServlet";
    return $.ajax({
        type: 'POST',
        url: url,
        dataType: "text",
        data: {requesttype: "5"}
    });
}

function dispRectifierTable2(row_count) {
    console.log("dispRectifierTable2 called")
    checkUpdatedStatusRectifier().done(function (data) {
        console.log("Data from Ping only requosite");
        console.log(data);
        var length = data.length;
        min = 0;
        max = row_count;
        //console.log("Checking Table status in DB");
        //console.log(data);
        //console.log(length);
        NODEIPRECT = "";
        var value;
        $("#table_rect").find("tr:gt(0)").remove();
        if (length > 0 && length < row_count) {
            value = ((parseInt(length) * 100) / parseInt(row_count));
            value = Math.floor(value);
            $('#preCheckPBRect').css('width', value + '%').attr('aria-valuenow', value);
            $('#preCheckPBRect').html(value + "%");
            $("#verifiedText").html("");
            $("#verifiedText").html("Pre-Requisite verification result");
            $("#disp_table_rectifier").html('<table id="table_rect" class="table table-bordered table2excel" data-tableName="Test Table 1"> <tbody> <tr class="table_header" style="background-color:#990033;color:#ffffff;"><td>Node ID</td><td>Node Name</td><td>Node Location</td><td>Ping Status</td><td>Ready to Save</td></tr> </tbody> </table>');
            for (j = 0; j < length; j++)
            {
                if (data[j][4] == "yes") {
                    bgcolor = "white";
                } else {
                    bgcolor = "rgba(153,0,51,0.3)";
                    color = "#555";
                }
                $('#table_rect tr:last').after('<tr style="background:' + bgcolor + ';color:' + color + '"><td>' + data[j][0] + '</td><td>' + data[j][1] + '</td><td>' + data[j][2] + '</td><td>' + data[j][3] + '</td><td>' + data[j][4] + '</td></tr>');
            }
            setTimeout(function () {
                dispRectifierTable2(row_count);
            }, 5000);
        } else if (length == row_count) {
            value = 100;
            console.log(rectifier_table_data);
            $('#preCheckPBRect').css('width', value + '%').attr('aria-valuenow', value);
            $('#preCheckPBRect').html("Complete");
            $("#verifiedText").html("");
            $("#verifiedText").html("Pre-Requisite verification result");
            $("#disp_table_rectifier").html('<table id="table_rect" class="table table-bordered table2excel" data-tableName="Test Table 1"> <tbody> <tr class="table_header" style="background-color:#990033;color:#ffffff;"><td>Node ID</td><td>Node Name</td><td>Node Location</td><td>Ping Status</td><td>Ready to Save</td></tr> </tbody> </table>');
            for (j = 0; j < length; j++)
            {
                if (data[j][4] == "yes") {
                    var tableData = rectifier_table_data[j].split(",");
                    NODEIPRECT = NODEIPRECT + "," + data[j][0] + ":" + tableData[5];
                    node_yes_count_rect++;
                    bgcolor = "white";
                } else {
                    bgcolor = "rgba(153,0,51,0.3)";
                    color = "#555";
                }
                $('#table_rect tr:last').after('<tr style="background:' + bgcolor + ';color:' + color + '"><td>' + data[j][0] + '</td><td>' + data[j][1] + '</td><td>' + data[j][2] + '</td><td>' + data[j][3] + '</td><td>' + data[j][4] + '</td></tr>');
            }
            $("#disp_table_rectifier").append('<div class="col-md-12" style="text-align:center;margin-bottom:10px;"><button class="btn btn-success" style="background-color:#990033;color:#ffffff;" id="saveIPs" onclick="getPingIPDetails()">Save</button></div>');
        } else {
            setTimeout(function () {
                dispRectifierTable2(row_count);
            }, 5000);
        }
    });
}

function CheckEngineID() {
    var url = "../ConfigSSHServlet";
    return $.ajax({
        type: 'POST',
        url: url,
        dataType: "text",
        data: {requesttype: "3"}
    });
}

function getPingIPDetails() {
    $.ajax({
        type: "POST",
        url: "../AdminDiscovery",
        dataType: "json",
        data: {requesttype: 7, deviceCount: pingDeviceCounts},
        success: function (data) {
            console.log("ping data For devices ");
            console.log(data);
//            var jsonData = JSON.stringify(data);
//            console.log(jsonData);
            var htmldata = '<table class="table table-bordered" ><thead><tr><th>Device Added</th><th>Devices Not Added</th></tr><tbody>';
            var htmlListyes = [];
            var htmlListno = [];
            var j = 0;
            var k = 0;
            var num = 0;
            for (var i = 0; i < data.length; i++) {
                if (data[i][5] == "yes") {
                    htmlListyes[j] = data[i][0];
                    j++;
                }
                if (data[i][5] == "no") {
                    htmlListno[k] = data[i][0];
                    k++;
                }
            }

            if (j > k) {
                num = j;
            } else if (k > j) {
                num = k;
            }
            for (i = 0; i < num; i++) {
                if (i < j && i < k) {
                    htmldata = htmldata + '<tr><td>' + htmlListyes[i] + '</td><td>' + htmlListno[i] + '</td></tr>'
                } else if (k > j) {
                    htmldata = htmldata + '<tr><td></td><td>' + htmlListno[i] + '</td></tr>'
                } else {
                    htmldata = htmldata + '<tr><td>' + htmlListyes[i] + '</td><td></td></tr>'
                }

            }
            htmldata = htmldata + '</tbody></table>';
            $(".outputDiv").html(htmldata);
        }
    });
}
function dispFinalData(row_count) {

    checkUpdatedStatus().done(function (data) {
        var length = data.length;
        min = 0;
        max = row_count;
        //console.log("Checking Table status in DB");
        //console.log(data);
        //console.log(length);
        NODEIP = "";
        var value;
        $("#table").find("tr:gt(0)").remove();
        if (length > 0 && length < row_count) {
//            value = ((parseInt(length) * 100) / parseInt(row_count));
//            value = Math.floor(value);
            value = 100;
            $('#preCheckPB').css('width', value + '%').attr('aria-valuenow', value);
            $('#preCheckPB').html(value + "%");
            $("#verifiedText").html("Complete");
            $("#verifiedText").html("Pre-Requisite verification result");
            $("#disp_table_2").html('<table id="table" class="table table-bordered table2excel" data-tableName="Test Table 1"> <tbody> <tr class="table_header"><td>Node IP</td><td>Ping Status</td><td>SNMP Status</td><td>Ready to Discover</td></tr> </tbody> </table>');
            for (j = 0; j < length; j++)
            {
                if (data[j][3] == "yes") {
                    node_yes_count++;
                    bgcolor = "white";
                } else {
                    bgcolor = "rgba(153,0,51,0.3)";
                    color = "#555";
                }
                $('#table tr:last').after('<tr style="background:' + bgcolor + ';color:' + color + '"><td>' + data[j][0] + '</td><td>' + data[j][1] + '</td><td>' + data[j][2] + '</td><td>' + data[j][3] + '</td></tr>');
            }
            setTimeout(function () {
                dispFinalData(row_count);
            }, 5000);
        } else if (length == row_count) {
            value = 100;
            console.log(table_data);
            $('#preCheckPB').css('width', value + '%').attr('aria-valuenow', value);
            $('#preCheckPB').html("Complete");
            $("#verifiedText").html("");
            $("#verifiedText").html("Pre-Requisite verification result");
            $("#disp_table_2").html('<table id="table" class="table table-bordered table2excel" data-tableName="Test Table 1"> <tbody> <tr class="table_header"><td>Node IP</td><td>Ping Status</td><td>SNMP Status</td><td>Ready to Discover</td></tr> </tbody> </table>');
            for (j = 0; j < length; j++)
            {
                if (data[j][3] == "yes") {
                    var tableData = table_data[j].split(",");
                    NODEIP = NODEIP + "," + data[j][0] + ":" + tableData[5];
                    node_yes_count++;
                    bgcolor = "white";
                } else {
                    bgcolor = "rgba(153,0,51,0.3)";
                    color = "#555";
                }
                $('#table tr:last').after('<tr style="background:' + bgcolor + ';color:' + color + '"><td>' + data[j][0] + '</td><td>' + data[j][1] + '</td><td>' + data[j][2] + '</td><td>' + data[j][3] + '</td></tr>');
            }
        } else {
            setTimeout(function () {
                dispFinalData(row_count);
            }, 5000);
        }
    });
}

function checkUpdatedStatus() {
//for deployment
    return $.ajax({
        type: 'POST',
        url: "../AdminDiscovery",
        dataType: "JSON",
        data: {requesttype: "3"},
    });
}

function checkUpdatedStatusRectifier() {
//for deployment
    return $.ajax({
        type: 'POST',
        url: "../AdminDiscovery",
        dataType: "JSON",
        data: {requesttype: "8"},
    });
}


function saveCpePeDetails() {
    console.log("*******CPEIP**********");
    console.log(NODEIP);
    console.log("**************PEIP************");
    return $.ajax({
        type: "POST",
        url: "../AdminDiscovery",
        dataType: "text",
        data: {requesttype: 4, NODEIP: NODEIP},
    });
}/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


