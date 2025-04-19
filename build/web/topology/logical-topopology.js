/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
var getParentTraps;
var fancyflag = "1";
var dataTableObject;
var set_interval = "";
var flag_logical_view = 0;
var width = 1850, height = 1000, shiftKey;
var zoom_scale;
var zoom_translate;
var globalInterfaceName;
var globalNodeName;
var globalFromTime;
var globalToTime;
var globalMapData;
var showText = true;
var globalgroupname = "";
$('.vrfId').select2();
$('.loading').hide();
$('input[type=radio][name=topologyNamefilter]').change(function () {
    var nodeTypeFlag = this.value;
    DrawTopologyFilter(nodeTypeFlag);

});
document.addEventListener("DOMContentLoaded", function () {
// Open the pop-up when the button is clicked
    document.getElementById("openPopupBtn").addEventListener("click", function () {
        document.getElementById("popupContainer").style.display = "block";
        $('#topologynode').select2();
        $('#topologygroupname').select2();

    });
    document.getElementById("closefancy").addEventListener("click", function () {
        document.getElementById("popupContainer").style.display = "none";

    });
});

//function getFilterDetails() {
//    $('#topologynode').select2();
//    getTopologyNode();
//    $.fancybox.open($(".detailed_view_popup2"), {
//        title: 'Custom Title',
//        closeEffect: 'none',
//        autoSize: false,
//        width: "90%",
//        height: "80%"
//    });
//}
function getTopologyNode() {
    $.ajax({
        type: "POST",
        url: "../ipmplsReportsFilter",
        data: {requestType: "12"},
        dataType: "json",
        success: function (data) {
            console.log(data)
            $('#topologynode').html('<option value="">Select Group Name</option>')
//            $('#groupnameId').html('Select Group Name');
            for (var i = 0; i < data.length; i++)
            {
                if (data[i] != null)
                    $('#topologynode').append('<option value="' + data[i] + '">' + data[i] + '</option>')
            }
            $('#topologynode').select2();
        },
        error: function (xhr, status, text) {

        }
    })
}
function getTopologyGroupName() {
    var topologynode = $('#topologynode').val();
    $.ajax({
        type: "POST",
        url: "../ipmplsReportsFilter",
        data: {requestType: "13", topologynode: topologynode},
        dataType: "json",
        success: function (data) {
            console.log(data)
            $('#topologygroupname').html('<option value="">Select Group Name</option>')
//            $('#groupnameId').html('Select Group Name');
            for (var i = 0; i < data.length; i++)
            {
                if (data[i] != null)
                    $('#topologygroupname').append('<option value="' + data[i] + '">' + data[i] + '</option>')
            }
            $('#topologygroupname').select2();
        },
        error: function (xhr, status, text) {

        }
    })
}
function viewReport() {
    var groupname = $('#topologygroupname').val();
    console.log(groupname);
    $(".loading").show();
    $(".nodedetaillegend").hide();
    $(".legends").removeClass("disabled");
    $("#svg_topology").attr("class", "svg_background_img1");
    drawNetworkView("1", groupname);
    document.getElementById("popupContainer").style.display = "none";
    fancyflag = "1";

}
function DrawTopologyFilter(flag) {
    clearElements();
    $(".crcLegend").removeClass("disabledDiv");
    graph = globalMapData;
    console.log("graph.links || graph.node")
    console.log(graph.nodes)
    var total_nodes = graph.nodes.length;
    var sp_nodes = 0;
    var cpe_nodes = 0;
    var down_nodes = 0;
    var up_nodes = 0;
    mapTest = {}
    for (var i = 0; i < graph.nodes.length; i++)
    {
        if (graph.nodes[i].NodeDesc == "service provider")
        {
            sp_nodes = sp_nodes + 1;
        } else {
            cpe_nodes = cpe_nodes + 1;
        }
        if (graph.nodes[i].status == "1" && graph.nodes[i].NodeDesc != "service provider")
            up_nodes = up_nodes + 1;
        else
            down_nodes = down_nodes + 1;
    }
    var health_pannel = "";
    global_total_nodes = cpe_nodes;
    global_down_nodes = 0;
    global_up_nodes = up_nodes;
    health_pannel = health_pannel + "<table border='1'  style='background-color:white;'><tr><td><table><tr><td><center><b>Device Status</b><center</td></tr><tr><td>Total Nodes : " + cpe_nodes + "</td><tr><td><div style='color:green;'>Up Nodes : " + up_nodes + "</div></td></tr><tr><td><div style='color:red;'> Down Nodes : " + (down_nodes - sp_nodes) + "</div></tr></td>";
    health_pannel = health_pannel + "</tr></table></td></tr></table>";
    setNodeList(graph.nodes)
    setLinkList(graph.links)
    loadNodeList();
    var cx = width / 2
    var cy = height / 2
    var radiusInner = 0
    var radiusOuterEven = 260
    var radiusOuterOdd = 260
    var radiusOuter = 260
    graph.nodes.forEach(function (d) {
        if (d.nodeType == "SP")
        {
            peList.push(d)
        } else {
            cpeList.push(d)
        }
    })
    var cpeNumber = cpeList.length;
    var peNumber = peList.length;
    var peAngleNode = 360 / peNumber
    var innerAngle = 0;
    var outerAngle = 0
    for (var i = 0; i < peList.length; i++)
    {
        var d = peList[i]
        finalNodeList.push(d)
        outerAngle = innerAngle
        if (i % 2 == 0)
        {
            radiusOuter = radiusOuterEven
        } else {
            radiusOuter = radiusOuterOdd
        }
        var pesFromCpe = getCpeFromPe(d.nodeNo)
        var lengthOfArray = Math.round(pesFromCpe.length / 2)
        for (var j = 0; j < lengthOfArray; j++)
        {
            var t = pesFromCpe[j]
            cpeList = removeFromArray(cpeList, 'nodeNo', t.nodeNo)
            finalNodeList.push(t)
            outerAngle = outerAngle + 6
        }
        outerAngle = innerAngle - 6
        for (var k = lengthOfArray; k < pesFromCpe.length; k++)
        {
            var t = pesFromCpe[k]
            cpeList = removeFromArray(cpeList, 'nodeNo', t.nodeNo)
            finalNodeList.push(t)
            outerAngle = outerAngle - 6
        }
        innerAngle = innerAngle + peAngleNode
    }
    outerAngle = outerAngle + 12
    for (var k = 0; k < cpeList.length; k++)
    {
        var t = cpeList[k]
        finalNodeList.push(t)
        outerAngle = outerAngle + 6
    }
    graph.nodes = []
    graph.nodes = finalNodeList.slice(0)
    graph.links.forEach(function (d) {
        var tmpsrc, tmpdest;
        var key = d.sourceID + ":" + d.destinationID // src and dest combination as a first key
        var key2 = d.destinationID + ":" + d.sourceID // dest and src combination as second key
        tmpsrc = getNodeObject(d.sourceID);
        tmpdest = getNodeObject(d.destinationID);
        if (tmpsrc != undefined && tmpdest != undefined)
        {
            d.sourceID = tmpsrc;
            d.destinationID = tmpdest; //getNodeObject(d.destinationID)
            if (key in mapTest || key2 in mapTest) {
                key = (key in mapTest) ? key : key2;
                var temp = get(key)
                var test = temp.slice()
                test.push({
                    "bandwidth": d.bandwidth,
                    "linkName": d.linkName,
                    "sourceIfIp": d.sourceIfIp,
                    "destinationIfIp": d.destinationIfIp,
                    "status": d.status
                })
                mapTest[key] = test
            } else {
                mapTest[key] = new Array({
                    "bandwidth": d.bandwidth,
                    "linkName": d.linkName,
                    "sourceIfIp": d.sourceIfIp,
                    "destinationIfIp": d.destinationIfIp,
                    "status": d.status
                })
            }
        }
    });
    var shift_count_tf = false;
    var shift_count = 0;
    link = link.data(graph.links).enter().append("line")
            .attr("class", function (d) {
                var multiLink = false;
                var multiLinkDown = false;
                var key = d.sourceID.nodeNo + ":" + d.destinationID.nodeNo // src and dest combination as a first key
                var key2 = d.destinationID.nodeNo + ":" + d.sourceID.nodeNo // dest and src combination as second key
                if (key in mapTest || key2 in mapTest) {
                    key = (key in mapTest) ? key : key2;
                    var temp = get(key);
                    var test = temp.slice();
                    if (test.length > 2)
                    {
                        d.linknum = test.length
                        multiLink = true;
                        shift_count_tf = true;
                        shift_count = test.length;
                        for (var j = 0; j < test.length; j++)
                        {
                            if (test[j].status == "2")
                            {
                                multiLinkDown = true;
                                break;
                            }
                        }
                    }
                }
                if (multiLink)
                {
                    if (multiLinkDown)
                        return "multiLinkDown"
                    else {
                        return "multiLink";
                    }
                } else {
                    if (d.status == "2")
                    {
                        return "downLink";
                    } else
                    {
                        if ($("#utilFilterSelector").prop("checked")) {
                            var Utilization = parseInt(d.utilization);
                            if (Utilization <= 25)
                            {
                                return "link025";
                            } else if (Utilization > 25 && Utilization <= 50)
                            {
                                return "link2550";
                            } else if (Utilization > 50 && Utilization <= 75)
                            {
                                return "link5075";
                            } else if (Utilization > 75)
                            {
                                return "link75";
                            } else {
                                return "link";
                            }
                        } else {

                            if (d.crc == "NA") {
                                return "link025";
                            } else {
                                var crcValue = parseInt(d.crc);
                                if (crcValue == 0) {
                                    return "link025";
                                } else if (crcValue > 0 && crcValue <= 500) {
                                    return "link2550";
                                } else {
                                    return "link5075";
                                }
                            }

                        }
                    }
                }
            })
            .attr("x1", function (d) {
                if (shift_count_tf) {
                    return d.sourceID.x;
                } else
                    return d.sourceID.x + 10;
            })
            .attr("y1", function (d) {
                return d.sourceID.y;
            })
            .attr("x2", function (d) {
                return d.destinationID.x;
            })
            .attr("y2", function (d) {

                return d.destinationID.y;
            })
            .classed("testButton", true)
            .on("mouseover", function (d) {
                div.transition()
                        .duration(200)
                        .style("opacity", .9);
                div.html('<table class="table" style="margin-bottom:0;"><tr><td>LinkName:</td><td><b>' + d.linkName + '</b></td></tr><tr><td>Bandwidth:</td><td><b>' + d.bandwidth + '</b></td></tr><tr><td>Utilization :</td><td><b>' + d.utilization + ' %</b></td></tr><tr><td style="width:10rem">Down Since :</td><td><b>' + d.downSince + '</b></td></tr></table>')
                        .style("left", (d3.event.pageX) + "px")
                        .style("top", (d3.event.pageY - 28) + "px")
                        .style("width", 500 + "px");
            })
            .on("mousedown", function (d, i) {

            })
            .on("mouseout", function (d) {
                div.transition()
                        .duration(500)
                        .style("opacity", 0);
            })
            .on("contextmenu", function (data, event) {
                var linkName = data.linkName.split(" - ");
                var link = linkName[0].split(":");
                globalInterfaceName = link[1];
                globalNodeName = link[0]
                d3.event.preventDefault();
                $(".custom-menu").finish().toggle(100).
                        css({
                            top: d3.event.pageY + "px",
                            left: d3.event.pageX + "px"
                        });
            });
    text = text.data(graph.nodes)
            .enter().append("text")
            .text(function (d) {
                if (flag == "nodename") {
                    if ($("#vrfId").val().includes("-T4")) {
                        return d.shortNodeName;
                    } else {
                        if (d.nodeType == "VN") {

                        } else {
                            return d.shortNodeName;
                        }
                    }
                } else {

                    if (d.nodeType == "VN") {

                    } else {
                        return d.nodeid;
                    }
                }


            })
            .attr("font-weight", function (d) {
                var temp = d.nodeType;
                if (temp == "VN")
                    return 400;
                else
                    return 500;
            })
            .attr("letter-spacing", function (d) {
                var temp = d.nodeType;
                if (temp == "VN")
                    return "0em";
                else
                    return "0.1em";
            })
            .attr("font-size", function (d) {
                var temp = d.nodeType;
                if (temp == "VN")
                    return 9;
                else
                    return 11;
            })
            .attr("display", function (d) {//to display text on the basis of node name checkbox
                if (showText) {
                    return "inline";
                } else {
                    return "none";
                }
            })
            .attr("x", function (d) {
                var temp = d.nodeType;
                if (temp == "SP")
                    return d.x - 45;
                else
                    return d.x - 20;
            })
            .attr("y", function (d) {
                if (d.nodeType == "VN") {
                    return d.y - 8;
                } else {
                    return d.y + 15;
                }
            });
    node = node.data(graph.nodes).enter().append("svg:image")
            .attr('width', function (d) {
                if (d.nodeType == "VN")
                    return 1 * 5;
                else {
                    if (d.tier == "T1")
                        return 45;
                    else if (d.tier == "T2")
                        return 35;
                    else if (d.tier == "T3")
                        return 30;
                    else if (d.tier == "T4")
                        return 25;
                    else if (d.tier == "T4")
                        return 25;
                    else if (d.tier == "T4_CNC")
                        return 25;
                    else if (d.tier == "T5")
                        return 20;
                    else if (d.tier == "T6")
                        return 15;
                    else
                        return 10;
                }
            })
            .attr('height', function (d) {
                if (d.nodeType == "VN")
                    return 5 * 10;
                else
                {
                    if (d.tier == "T1")
                        return 25.5;
                    else if (d.tier == "T2")
                        return 22;
                    else if (d.tier == "T3")
                        return 20.5;
                    else if (d.tier == "T4")
                        return 17;
                    else if (d.tier == "T4")
                        return 17;
                    else if (d.tier == "T4_CNC")
                        return 17;
                    else if (d.tier == "T5")
                        return 15.5;
                    else if (d.tier == "T6")
                        return 13;
                    else
                        return 10;
                }
            })
            .attr("x", function (d) {
                if (d.nodeType == "VN")
                    return d.x * 1 - 2;
                else
                    return (d.x * 1) - 10;
            })
            .attr("y", function (d) {
                if (d.nodeType == "VN")
                    return d.y - 25;
                else
                    return d.y - 15;
            })
            .attr("xlink:href", function (d) {
                if (d.status == '2') {
                    var icon = "../assets/images/gis/other.png";
                    var temp = d.nodeType;
                    switch (temp) {
                        case 'Switch':
                            icon = "../assets/images/gis/logical/Switchdown.png";
                            break;
                        case 'POP-Switch':
                            icon = "../assets/images/gis/logical/POP-Switch1.png";
                            break;
                        case 'WiFi':
                            icon = "../assets/images/gis/logical/BNG1.png";
                            break;
                        case 'OLT':
                            icon = "../assets/images/gis/logical/OLT1.png";
                            break;
                        case 'Router':
                            icon = "../assets/images/gis/logical/Router1.png";
                            break;
                        case 'Internet':
                            icon = "../assets/images/gis/logical/Internet.png";
                            break;
                        case 'Service':
                            icon = "../assets/images/gis/logical/Service.png";
                            break;
                        case 'PE':
                            icon = "../assets/images/gis/logical/Router1.png";
                            break;
                        case 'CPE':
                            icon = "../assets/images/gis/logical/switch2.png";
                            break;
                        default:
                            icon = "../assets/images/gis/logical/Router1.png";
                            break;
                    }
                    return icon;
                } else {

                    var temp = d.tier;
                    var icon = "../assets/images/gis/other.png";
                    switch (temp) {
                        case 'T1':
                            icon = "../assets/images/T2.png";
                            break;
                        case 'T2':
                            icon = "../assets/images/greenswitch.png";
//                            icon = "../assets/images/switch_cisco.png";
                            break;
                        case 'T3':
                            icon = "../assets/images/T3.png";
                            break;
                        case 'T4':
                            icon = "../assets/images/03.png";
                            break;
                        case 'T5':
                            icon = "../assets/images/03.png";
                            break;
                        case 'T6':
                            icon = "../assets/images/03.png";
                            break;
                        case 'T4_colo':
                            icon = "../assets/images/04.png";
                            break;
                        case 'T4_CNC':
                            icon = "../assets/images/07.png";
                            break;
                    }
                    return icon;
                }
            })
            .on("mousedown", function (d, i) {

                if (!d.selected) {
                    d3.selectAll("text").style("display", function (p) {
                        if (p.NodeName === d.NodeName) {
                            fetchnodedata(p.NodeName);
                            return "inline";
                        } else {
                            if (showText) {
                                return "inline";
                            } else {
                                return "none";
                            }

                        }
                    });
                    if (!shiftKey) {
                        node.classed("selected", function (p) {
                            return p.selected = d === p;
                        });
                    } else {
                        d3.select(this).classed("selected", d.selected = true);
                    }

                }
            })
            .classed("testButton", true)
            .call(d3.behavior.drag()
                    .on("dragstart", function () {
                        d3.event.sourceEvent.stopPropagation();
                    })
                    .on("drag", function (d) {
                        nudge(d3.event.dx, d3.event.dy);
                    }))



    $(".loading").hide();
    function nudge(dx, dy) {

        node.filter(function (d) {
            return d.selected;
        })
                .attr("x", function (d) {
                    return d.x += dx;
                })
                .attr("y", function (d) {
                    return d.y += dy;
                })
                .attr("x", function (d) {
                    if (d.nodeType == "VN")
                        return (d.x * 1) - 5;
                    else
                        return d.x * 1 - 10;
                })
                .attr("y", function (d) {
                    if (d.nodeType == "VN")
                        return (d.y * 1) - 25;
                    else
                        return d.y * 1 - 15;
                })

        text.filter(function (d) {
            return d.selected;
        })
                .attr("x", function (d) {
                    var temp = d.nodeType;
                    if (temp == "VN")
                        return (d.x + 5) - 40;
                    else
                        return d.x - 20;
                })
                .attr("y", function (d) {
                    var temp = d.nodeType;
                    if (temp == "VN")
                        return (d.y + 2) - 20;
                    else
                        return d.y + 15;
                })


        link.filter(function (d) {
            return d.sourceID.selected;
        })
                .attr("x1", function (d) {
                    return d.sourceID.x;
                })
                .attr("y1", function (d) {
                    return d.sourceID.y;
                });
        link.filter(function (d) {
            return d.destinationID.selected;
        })
                .attr("x2", function (d) {
                    return d.destinationID.x;
                })
                .attr("y2", function (d) {
                    return d.destinationID.y;
                });
        d3.event.preventDefault();
    }
}
$(document)
        .ajaxStart(function () {
            $(".loading").show();
        })
        .ajaxStop(function () {
            $(".loading").hide();
        });
function getCurrentDate() {
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!
    var hh = today.getHours();
    var MM = today.getMinutes();
    var ss = today.getSeconds();
    var yyyy = today.getFullYear();
    if (dd < 10) {
        dd = '0' + dd;
    }
    if (mm < 10) {
        mm = '0' + mm;
    }
    if (hh < 10) {
        hh = '0' + hh;
    }
    if (MM < 10) {
        MM = '0' + MM;
    }
    if (ss < 10) {
        ss = '0' + ss;
    }
    var today = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
    globalToTime = today;
    $today = new Date();
    $yesterday = new Date($today);
    $yesterday.setDate($today.getDate() - 2);
    var $dd = $yesterday.getDate();
    var $mm = $yesterday.getMonth() + 1; //January is 0!
    // var $yyyy = $yesterday.getFullYear();
    if ($dd < 10) {
        $dd = '0' + $dd;
    }
    if ($mm < 10) {
        $mm = '0' + $mm;
    }

    var today = $yyyy + '-' + $mm + '-' + $dd + ' ' + hh + ':' + MM + ':' + ss;
    globalFromTime = today;
}
var mapTest = {}
function get(k) {
    return mapTest[k];
}
//2nd for building lable
function buildlabel(inputArray) {
    var label = ""
    for (var i in inputArray) {
        var linkName = inputArray[i].linkName
        var bandwidth = inputArray[i].bandwidth
        var status = inputArray[i].status
        var sourceIfIp = inputArray[i].sourceIfIp
        var destinationIfIp = inputArray[i].destinationIfIp
        var className = ""
        if (status == "2")
        {
            className = "background-color:#ff4c4c;"

        }
        label = label + "<li style=\"" + className + "\"> <strong>" + linkName + "</strong> <strong>Source:</strong>" + sourceIfIp + "<strong>Destination:</strong> " + destinationIfIp + " </li>"

    }
    return label;
}
//getVRFnames();
getGroupnames();
getTopologyNode();
var cloudtag = "";
var spcounter = 0;
var nodecounter = 0;
var main_node_list = [];
var main_link_list = [];
var cpeList = [];
var peList = [];
var finalNodeList = [];
var global_total_nodes = 0;
var global_down_nodes = 0;
var global_up_nodes = 0;
var global_checked_value = []
var width = 2500, height = 2000, shiftKey;
var zoom_scale;
var zoom_translate;
var svg = d3.select("body")
        .attr("tabindex", 1)
        .on("keydown.brush", keydown)
        .on("keyup.brush", keyup)
        .on("click", function () {
            d3.select("#rmenu").classed("hide", true);
        })
        .select("svg")
        .attr("width", width)
        .attr("height", height)
        .call(d3.behavior.zoom().on("zoom", function () {
            svg.attr("transform", "translate(" + d3.event.translate + ")" + " scale(" + d3.event.scale + ")");
        }))
        .append("g");
var link = svg.append("g")
        .selectAll("line");
var brush = svg.append("g")
        .datum(function () {
            return {selected: false, previouslySelected: false};
        })
        .attr("class", "brush");
var node = svg.append("g")
        .attr("class", "node")
        .selectAll("circle");
var div = d3.select("body").append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);
var text = svg.append("g")
        .attr("class", "name")
        .selectAll("text");
$(document).ready(function () {
    $('.shrink-btn').trigger("click");
    $("#powerLegend").hide();
    $("#crcLegend").hide();
    $(".nodedetaillegend").hide();
    $(".legends").addClass("disabled");
    $("#crcLegend").hide();
//                $(".crcLegend").addClass("disabledDiv");
    $('.showTiers').change(function () {
        let flag = "Tier";
        console.log("Tier Flag is clicked");
        $('input[name="utilValue"]').prop('checked', true);
        drawNetworkViewUpdate(flag);
    });
    $('.showUtils').change(function () {
        let flag = "Util";
        console.log("Util Flag is clicked");
        $('input[name="tierValue"]').prop('checked', true);
        drawNetworkViewUpdate(flag);
    });
    $('.showCrcs').change(function () {
        let flag = "CRC";
        console.log("CRC Flag is clicked");
        $('input[name="tierValue"]').prop('checked', true);
        drawNetworkViewUpdate(flag);
    });
    $("#routerName").change(function () {
        if (this.checked) {
            showText = true;
        } else {
            showText = false;
        }
    });
    d3.select("#download")
            .on('click', function () {
                let fileName = $("#vrfId").val() + "_Group.png";
                saveSvgAsPng(document.getElementById("svg_topology"), fileName, {backgroundColor: "#FFFFFF"});
            });
});
$("#NodeList").select2({placeholder: "Select Node"});
$("#selectView").click(function () {
    $(".loading").show();
    $(".nodedetaillegend").hide();
    $(".legends").removeClass("disabled");
    $("#svg_topology").attr("class", "svg_background_img1");
    var customer = $("#vrfId").val();
    fancyflag = "2";
    drawNetworkView("1", customer);
//                if ($("#flag1").prop("checked")) {
//                    $(".loading").show();
//                    drawNetworkView("1");
//                } else if ($("#flag2").prop("checked")) {
//                    var groupName = $("#vrfId").val();
//                    if (groupName.includes("T4") || groupName.includes("ISP-INT")) {
//                        alert("Please select bundle option");
//                    } else {
//                        drawNetworkView("2");
//                    }
//                    $(".loading").hide();
//                }
//    if ($("#utilFilterSelector").prop("checked")) {
//        $(".crcLegend").addClass("disabledDiv");
//        $(".utilLegend").removeClass("disabledDiv");
//    } else {
//        $(".utilLegend").addClass("disabledDiv");
//        $(".crcLegend").removeClass("disabledDiv");
//    }
})
$("#selectView1").click(function () {
    $(".loading").show();
    $(".nodedetaillegend").hide();
    $(".legends").removeClass("disabled");
    $("#svg_topology").attr("class", "svg_background_img1");
    var customer = $("#topologygroupname").val();
    drawNetworkView("1", customer);
//                if ($("#flag1").prop("checked")) {
//                    $(".loading").show();
//                    drawNetworkView("1");
//                } else if ($("#flag2").prop("checked")) {
//                    var groupName = $("#vrfId").val();
//                    if (groupName.includes("T4") || groupName.includes("ISP-INT")) {
//                        alert("Please select bundle option");
//                    } else {
//                        drawNetworkView("2");
//                    }
//                    $(".loading").hide();
//                }
//    if ($("#utilFilterSelector").prop("checked")) {
//        $(".crcLegend").addClass("disabledDiv");
//        $(".utilLegend").removeClass("disabledDiv");
//    } else {
//        $(".utilLegend").addClass("disabledDiv");
//        $(".crcLegend").removeClass("disabledDiv");
//    }
})
$('#routerName').click(function () {
    if ($('#routerName').is(':checked'))
    {
        d3.selectAll("text").style("display", "inline");
        showText = true;
    } else {
        d3.selectAll("text").style("display", function (p) {
            showText = false;
            return "none";
        });
    }
})
$('#vrfId').change(function ()
{
    $("#NodeList").select2("val", "");
    $(".flagGroup").prop("checked", false);
    $("#flag1").prop("checked", true);
});
$('#NodeList').change(function ()
{
    var nodename = $('#NodeList').val()
    d3.selectAll("circle").classed("selected", function (d) {
        if (d != undefined) {
            if (d.NodeName === nodename)
            {
                return d.NodeName === nodename;
            }
        }
    });
    d3.selectAll("text").style("display", function (d) {
        if (d.NodeName === nodename || d.nodeType == "SP")
        {
            return "inline";
        } else
        {
            return "none";
        }
    });
});
$('#routerNames').change(function () {
    if ($(this).val() == "select")
    {
        alert("Please select Node");
    } else
    {
        getCustomerNameForNode($(this).val());
    }

});
function getCustomerNameForNode(nodeip)
{
    $.ajax({type: "POST",
        url: "FiltersServlet",
        data: {requestType: "6", routerIP: nodeip},
        success: function (data) {
            $("#customerName").val(data);
            $("#customerName").removeAttr("disabled");
        },
        error: function (xhr, status, text) {

        }
    });
}
function loadNodeList()
{
    for (var i = 0; i < main_node_list.length; i++)
    {
        var NodeName = main_node_list[i].NodeName;
        var NodeType = main_node_list[i].nodeType;
        if (NodeName != "")
        {
            if (NodeType == "VN")
            {

            } else
            {
                $('.nodelegenddata').append('<li onClick="fetchnodedata(\'' + main_node_list[i].NodeName + '\')">' + main_node_list[i].NodeName + '</li>');
                $('#NodeList').append('<option value=' + main_node_list[i].NodeName + '>' + main_node_list[i].NodeName + '</option>')
            }
        }
    }

}
function getNodeOb(id)
{
    return id;
}
function setNodeList(passList)
{
    main_node_list = passList;
}
function setLinkList(passList)
{
    main_link_list = passList;
}
function getNodeList() {
    return main_node_list;
}
function getLinkList()
{
    return main_link_list;
}
function getNodeObject(id)
{
    for (var i = 0; i < finalNodeList.length; i++)
    {
        var d = finalNodeList[i];
        if (d.nodeNo == id)
        {
            return d;
        }
    }
}
function removeFromArray(arrO, attr, value) {
    var i = arrO.length;
    while (i--) {

        if (arrO[i] && arrO[i].hasOwnProperty(attr) && (arguments.length > 2 && arrO[i][attr] === value)) {

            arrO.splice(i, 1);
        }
    }
    return arrO;
}
$('#save').click(function () {
    var coordinateArray = [];
    d3.selectAll("image").each(function (d, i) {
        var temp = []
        temp.push(d.NodeName)
        temp.push(d.x)
        temp.push(d.y)
        coordinateArray.push(temp)
    })
    var objectData = JSON.stringify(coordinateArray);
    $.ajax({
        type: 'POST',
        url: "../LogicalTopology",
        dataType: 'json',
        data: {requestType: "14", cord: objectData, groupName: $("#vrfId").val()},
        success: function (data, textStatus, jqXHR) {
            alert("Coordinates updated")
        }

    });
})
function getCpeFromPe(cpeIP) {
    var tempList = []
    for (var i = 0; i < main_link_list.length; i++)
    {
        var d = main_link_list[i]
        if (d.sourceID == cpeIP || d.destinationID == cpeIP)
        {
            for (var j = 0; j < cpeList.length; j++)
            {
                if (d.destinationID == cpeList[j].nodeNo || d.sourceID == cpeList[j].nodeNo)
                {
                    tempList.push(cpeList[j])
                }
            }
        }

    }
    return tempList
}
function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}
function clearElements() {
    $(".nodelegenddata").empty();
    svg.selectAll("*").remove();
    var url = "../assets/images/india_outline.png";
    svg = d3.select("body")
            .attr("tabindex", 1)
            .on("keydown.brush", keydown)
            .on("keyup.brush", keyup)
            .on("click", function () {
                d3.select("#rmenu").classed("hide", true);
            })
            .select("svg")
            .attr("width", width)
            .attr("height", height)
            .attr("preserveAspectRatio", "xMinYMin")
            .call(d3.behavior.zoom().on("zoom", function () {
                svg.attr("transform", "translate(" + d3.event.translate + ")" + " scale(" + d3.event.scale + ")")
            }))
            .append("g");
    link = svg.append("g")
            .selectAll("line");
    brush = svg.append("g")
            .datum(function () {
                return {selected: false, previouslySelected: false};
            })
            .attr("class", "brush");
    node = svg.append("g")
            .attr("class", "node")
            .selectAll("circle");
    text = svg.append("g")
            .attr("class", "name")
            .selectAll("text")

    force = d3.layout.force()
            .charge(-120)
            .linkDistance(30)
            .size([width, height]);
    main_node_list = []
    main_link_list = []
    cpeList = []
    peList = []
    finalNodeList = []
}
function updatePropertyBox(data) {
    $('#rmenu').empty()
    $('#rmenu').html('<b>NODE NAME:</b>' + data.NodeName + '')
}
function selectNode(selectednode) {
    d3.selectAll(node).classed("selected", function (d) {
        d.selected = selectednode === d.selected
    })
}
function keydown() {
    if (!d3.event.metaKey)
        switch (d3.event.keyCode) {
            case 38:
                nudge(0, -1);
                break; // UP
            case 40:
                nudge(0, +1);
                break; // DOWN
            case 37:
                nudge(-1, 0);
                break; // LEFT
            case 39:
                nudge(+1, 0);
                break; // RIGHT
        }
    shiftKey = d3.event.shiftKey || d3.event.metaKey;
}
function keyup() {
    shiftKey = d3.event.shiftKey || d3.event.metaKey;
}
function getGroupnames() {
    $.ajax({
        type: "POST",
        url: "../ipmplsReportsFilter",
        data: {requestType: "4"},
        dataType: "json",
        success: function (data) {
            console.log(data)
            $('#groupnameId').html('<option value="">Select Group Name</option>')
//            $('#groupnameId').html('Select Group Name');
            for (var i = 0; i < data.length; i++)
            {
                if (data[i] != null)
                    $('#groupnameId').append('<option value="' + data[i] + '">' + data[i] + '</option>')
            }
            $('#groupnameId').select2();
        },
        error: function (xhr, status, text) {

        }
    })
}
function getVRFnames() {
    var grouptype = $('#groupnameId').val();
    console.log("grouptype:" + grouptype);
    $.ajax({
        type: "POST",
        url: "../LogicalTopology",
        data: {requestType: "16", grouptype: grouptype},
        dataType: "json",
        success: function (data) {
            console.log(data)
            updateVRFname(data)
        },
        error: function (xhr, status, text) {

        }
    })
}
function updateVRFname(data) {
    if (data != null) {
//        $('#vrfId').html('');
        $('#vrfId').html('<option value="">Select Group Name</option>')
        for (var i = 0; i < data.length; i++)
        {
            if (data[i] != null)
                $('#vrfId').append('<option value="' + data[i] + '">' + data[i] + '</option>')
        }
        $('#vrfId').select2();
    }
}
function getNodenames() {
    $("#customerName").val("");
    $.ajax({
        type: "POST",
        url: "../LogicalTopology",
        data: {requestType: "2"},
        dataType: "json",
        success: function (data) {
            updateNodename(data)
        },
        error: function (xhr, status, text) {
        }
    })
}
function updateNodename(data) {
    $('#routerNames').empty();
    $('#routerNames').append('<option value="select">Select Node</option>')
    if (data != null) {
        for (var i = 0; i < data.length; i++)
        {
            $('#routerNames').append('<option value="' + data[i][0] + '">' + data[i][0] + " : " + data[i][1] + '</option>')
        }
        $('#routerNames').select2({placeholder: "Select Node"});
    }
}
set_interval = setInterval(drawChart, 300 * 1000);
getParentTraps = function ()
{
    var trapList;
    var linkList;
    var nodeList;
    $.ajax({
        type: "POST",
        url: "../LogicalTopology",
        data: {requestType: "10"},
        dataType: "json",
        success: function (data) {
            console.log("get Trap List data");
            console.log(data);
            trapList = data;
            linkList = trapList[0];
            nodeList = trapList[1];
            var flag1 = 1;
            if (nodeList.length == 0) {
                d3.selectAll("image")
                        .filter(function (d) {
                            return 1;
                        })
                        .attr("xlink:href", function (d) {
                            var temp = d.nodeType;
                            var icon = "../assets/images/gis/other.png";
                            switch (temp) {
                                case 'Core-Switch':
                                    icon = "../assets/images/gis/logical/Core-Switch.png";
                                    break;
                                case 'POP-Switch':
                                    icon = "../assets/images/gis/logical/POP-Switch.png";
                                    break;
                                case 'BNG':
                                    icon = "../assets/images/gis/logical/BNG.png";
                                    break;
                                case 'OLT':
                                    icon = "../assets/images/gis/logical/OLT.png";
                                    break;
                                case 'Router':
                                    icon = "../assets/images/gis/logical/Router.png";
                                    break;
                                case 'Internet':
                                    icon = "../assets/images/gis/logical/Internet.png";
                                    break;
                                case 'Service':
                                    icon = "../assets/images/gis/logical/Service.png";
                                    break;
                                default:
                                    icon = "../assets/images/gis/logical/Router.png";
                                    break;
                            }
                            return icon;
                        })
            }

            for (var i = 0; i < nodeList.length; i++)
            {
                d3.selectAll("image")
                        .filter(function (d) {
                            return d.NodeName == nodeList[i].NodeName;
                        })
                        .attr("xlink:href", function (d) {
                            if (nodeList[i].status == '2') {
                                var temp = d.nodeType;
                                var icon = "../assets/images/gis/other.png";
                                switch (temp) {
                                    case 'Core-Switch':
                                        icon = "../assets/images/gis/logical/Core-Switch1.png";
                                        break;
                                    case 'POP-Switch':
                                        icon = "../assets/images/gis/logical/POP-Switch1.png";
                                        break;
                                    case 'BNG':
                                        icon = "../assets/images/gis/logical/BNG1.png";
                                        break;
                                    case 'OLT':
                                        icon = "../assets/images/gis/logical/OLT1.png";
                                        break;
                                    case 'Router':
                                        icon = "../assets/images/gis/logical/Router1.png";
                                        break;
                                    case 'Internet':
                                        icon = "../assets/images/gis/logical/Internet.png";
                                        break;
                                    case 'Service':
                                        icon = "../assets/images/gis/logical/Service.png";
                                        break;
                                    default:
                                        icon = "../assets/images/gis/logical/Router.png";
                                        break;
                                }
                                return icon;
                            } else {
                                var temp = d.nodeType;
                                var icon = "../assets/images/gis/other.png";
                                switch (temp) {
                                    case 'Core-Switch':
                                        icon = "../assets/images/gis/logical/Core-Switch.png";
                                        break;
                                    case 'POP-Switch':
                                        icon = "../assets/images/gis/logical/POP-Switch.png";
                                        break;
                                    case 'BNG':
                                        icon = "../assets/images/gis/logical/BNG.png";
                                        break;
                                    case 'OLT':
                                        icon = "../assets/images/gis/logical/OLT.png";
                                        break;
                                    case 'Router':
                                        icon = "../assets/images/gis/logical/Router.png";
                                        break;
                                    case 'Internet':
                                        icon = "../assets/images/gis/logical/Internet.png";
                                        break;
                                    case 'Service':
                                        icon = "../assets/images/gis/logical/Service.png";
                                        break;
                                    default:
                                        icon = "../assets/images/gis/logical/Router.png";
                                        break;
                                }
                                return icon;
                            }
                        })
            }
            //loop through all paths n make them if status is equals to 2
            for (var i = 0; i < linkList.length; i++)
            {
                d3.selectAll("line")
                        .filter(function (d) {
                            var key = d.sourceID.nodeNo + ":" + d.destinationID.nodeNo // src and dest combination as a first key
                            var key2 = d.destinationID.nodeNo + ":" + d.sourceID.nodeNo // dest and src combination as second key
                            if (key in mapTest || key2 in mapTest)
                            {
                                key = (key in mapTest) ? key : key2;
                                var temp = get(key)
                                var test = temp.slice()
                                if (test.length > 1)
                                {
                                    var testArray = []
                                    for (var j = 0; j < test.length; j++)
                                    {
                                        var temp = {}
                                        temp.bandwidth = test[j].bandwidth
                                        temp.linkName = test[j].linkName
                                        temp.sourceIfIp = test[j].sourceIfIp
                                        temp.destinationIfIp = test[j].destinationIfIp
                                        if (test[j].linkName == linkList[i].linkName)
                                        {
                                            temp.status = linkList[i].status

                                        } else
                                        {
                                            temp.status = test[j].status
                                        }
                                        testArray.push(temp)
                                    }
                                    mapTest[key] = testArray
                                    return true;
                                } else {
                                    return d.linkName == linkList[i].linkName;
                                }
                            }

                        })
                        .attr("class", function (d) {
                            var multiLink = false;
                            var multiLinkDown = false;
                            var key = d.sourceID.nodeNo + ":" + d.destinationID.nodeNo // src and dest combination as a first key
                            var key2 = d.destinationID.nodeNo + ":" + d.sourceID.nodeNo // dest and src combination as second key
                            if (key in mapTest || key2 in mapTest) {
                                key = (key in mapTest) ? key : key2;
                                var temp = get(key)
                                var test = temp.slice()
                                if (test.length > 1)
                                {
                                    multiLink = true;
                                    for (var j = 0; j < test.length; j++)
                                    {
                                        if (test[j].status == "2")
                                        {
                                            multiLinkDown = true;
                                            break;
                                        }
                                    }
                                }
                            }
                            if (multiLink)
                            {
                                if (multiLinkDown)
                                    return "multiLinkDown"
                                else
                                    return "multiLink";
                            } else {
                                if (linkList[i].status == "2")
                                {
                                    return "downLink";
                                } else
                                {
                                    var Utilization = parseInt(d.utilization);
                                    if (Utilization <= 25)
                                    {
                                        return "link025";
                                    } else if (Utilization > 25 && Utilization <= 50)
                                    {
                                        return "link2550";
                                    } else if (Utilization > 50 && Utilization <= 75)
                                    {
                                        return "link5075";
                                    } else if (Utilization > 75)
                                    {
                                        return "link75";
                                    } else {
                                        return "link";
                                    }

                                }
                            }
                        });
            }
            if (linkList.length == 0) {
                d3.selectAll("line")
                        .filter(function (d) {
                            return 1;
                        })
                        .attr("class", function (d) {
                            var multiLink = false;
                            var multiLinkDown = false;
                            if (multiLink)
                            {
                                return "multiLink";
                            } else {
                                var Utilization = parseInt(d.utilization);
                                if (Utilization > 0 && Utilization <= 25)
                                {
                                    return "link025";
                                } else if (Utilization > 25 && Utilization <= 50)
                                {
                                    return "link2550";
                                } else if (Utilization > 50 && Utilization <= 75)
                                {
                                    return "link5075";
                                } else if (Utilization > 75)
                                {
                                    return "link75";
                                } else {
                                    return "link025";
                                }
                            }
                        });
            }
            var total_nodes = nodeList;
            var sp_nodes = 0;
            var cpe_nodes = 0;
            var down_nodes = 0;
            var up_nodes = 0;
            for (var i = 0; i < nodeList.length; i++)
            {
                if (nodeList[i].NodeDesc == "service provider")
                {
                    sp_nodes = sp_nodes + 1;
                } else {
                    cpe_nodes = cpe_nodes + 1;
                }
                if (nodeList[i].status == "1" && nodeList[i].NodeDesc != "service provider")
                    up_nodes = up_nodes + 1;
                else
                    down_nodes = down_nodes + 1;
            }
            var health_pannel = "";
            if (nodeList.length == 0)
            {
                cpe_nodes = global_total_nodes;
                global_down_nodes = 0;
                up_nodes = global_up_nodes;
                down_nodes = 0;
                sp_nodes = 0;
            }
            health_pannel = health_pannel + "<table border='1'  style='background-color:white;'><tr><td><table><tr><td><center><b>Device Status</b><center</td></tr><tr><td>Total Nodes : " + cpe_nodes + "</td><tr><td><div style='color:green;'>Up Nodes : " + up_nodes + "</div></td></tr><tr><td><div style='color:red;'> Down Nodes : " + (down_nodes - sp_nodes) + "</div></tr></td>";
            health_pannel = health_pannel + "</tr></table></td></tr></table>";
        }
    });
}
function drawChart() {
    var flag = window.parent.parent.frame_flag;
    if (window.parent.parent.frame_flag == "1") {
        if ($("#flag1").prop("checked")) {
            drawNetworkView(1);
        } else if ($("#flag2").prop("checked")) {
            drawNetworkView(2);
        }
    } else {
        clearInterval(set_interval)
    }
}
function drawNetworkView(flag, groupname) {
    $(".crcLegend").removeClass("disabledDiv");
    clearElements();



    var dateVal = "";
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!
    var hh = today.getHours();
    var MM = today.getMinutes();
    var ss = today.getSeconds();
    var yyyy = today.getFullYear();
    if (dd < 10) {
        dd = '0' + dd;
    }
    if (mm < 10) {
        mm = '0' + mm;
    }
    if (hh < 10) {
        hh = '0' + hh;
    }
    if (MM < 10) {
        MM = '0' + MM;
    }
    if (ss < 10) {
        ss = '0' + ss;
    }
    dateVal = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
    var tempstring = "../getNetwork?customer=" + groupname + "&flag=" + flag + "&dateVal=" + dateVal + "&username1=" + username1;
    d3.json(tempstring, function (error, graph) {
        globalMapData = graph;
        console.log("graph.links || graph.node");
        console.log(graph.nodes);
        console.log(graph.links);
        var total_nodes = graph.nodes.length;
        var sp_nodes = 0;
        var cpe_nodes = 0;
        var down_nodes = 0;
        var up_nodes = 0;
        mapTest = {}
        for (var i = 0; i < graph.nodes.length; i++)
        {
            if (graph.nodes[i].NodeDesc == "service provider")
            {
                sp_nodes = sp_nodes + 1;
            } else {
                cpe_nodes = cpe_nodes + 1;
            }
            if (graph.nodes[i].status == "1" && graph.nodes[i].NodeDesc != "service provider")
                up_nodes = up_nodes + 1;
            else
                down_nodes = down_nodes + 1;
        }
        var health_pannel = "";
        global_total_nodes = cpe_nodes;
        global_down_nodes = 0;
        global_up_nodes = up_nodes;
        health_pannel = health_pannel + "<table border='1'  style='background-color:white;'><tr><td><table><tr><td><center><b>Device Status</b><center</td></tr><tr><td>Total Nodes : " + cpe_nodes + "</td><tr><td><div style='color:green;'>Up Nodes : " + up_nodes + "</div></td></tr><tr><td><div style='color:red;'> Down Nodes : " + (down_nodes - sp_nodes) + "</div></tr></td>";
        health_pannel = health_pannel + "</tr></table></td></tr></table>";
        setNodeList(graph.nodes)
        setLinkList(graph.links)
        loadNodeList();
        var cx = width / 2
        var cy = height / 2
        var radiusInner = 0
        var radiusOuterEven = 260
        var radiusOuterOdd = 260
        var radiusOuter = 260
        graph.nodes.forEach(function (d) {
            if (d.nodeType == "SP")
            {
                peList.push(d)
            } else {
                cpeList.push(d)
            }
        })
        var cpeNumber = cpeList.length;
        var peNumber = peList.length;
        var peAngleNode = 360 / peNumber
        var innerAngle = 0;
        var outerAngle = 0
        for (var i = 0; i < peList.length; i++)
        {
            var d = peList[i]
            finalNodeList.push(d)
            outerAngle = innerAngle
            if (i % 2 == 0)
            {
                radiusOuter = radiusOuterEven
            } else {
                radiusOuter = radiusOuterOdd
            }
            var pesFromCpe = getCpeFromPe(d.nodeNo)
            var lengthOfArray = Math.round(pesFromCpe.length / 2)
            for (var j = 0; j < lengthOfArray; j++)
            {
                var t = pesFromCpe[j]
                cpeList = removeFromArray(cpeList, 'nodeNo', t.nodeNo)
                finalNodeList.push(t)
                outerAngle = outerAngle + 6
            }
            outerAngle = innerAngle - 6
            for (var k = lengthOfArray; k < pesFromCpe.length; k++)
            {
                var t = pesFromCpe[k]
                cpeList = removeFromArray(cpeList, 'nodeNo', t.nodeNo)
                finalNodeList.push(t)
                outerAngle = outerAngle - 6
            }
            innerAngle = innerAngle + peAngleNode
        }
        outerAngle = outerAngle + 12
        for (var k = 0; k < cpeList.length; k++)
        {
            var t = cpeList[k]
            finalNodeList.push(t)
            outerAngle = outerAngle + 6
        }
        graph.nodes = []
        graph.nodes = finalNodeList.slice(0)
        graph.links.forEach(function (d) {
            var tmpsrc, tmpdest;
            var key = d.sourceID + ":" + d.destinationID // src and dest combination as a first key
            var key2 = d.destinationID + ":" + d.sourceID // dest and src combination as second key
            tmpsrc = getNodeObject(d.sourceID);
            tmpdest = getNodeObject(d.destinationID);
            if (tmpsrc != undefined && tmpdest != undefined)
            {
                d.sourceID = tmpsrc;
                d.destinationID = tmpdest; //getNodeObject(d.destinationID)
                if (key in mapTest || key2 in mapTest) {
                    key = (key in mapTest) ? key : key2;
                    var temp = get(key)
                    var test = temp.slice()
                    test.push({
                        "bandwidth": d.bandwidth,
                        "linkName": d.linkName,
                        "sourceIfIp": d.sourceIfIp,
                        "destinationIfIp": d.destinationIfIp,
                        "status": d.status
                    })
                    mapTest[key] = test
                } else {
                    mapTest[key] = new Array({
                        "bandwidth": d.bandwidth,
                        "linkName": d.linkName,
                        "sourceIfIp": d.sourceIfIp,
                        "destinationIfIp": d.destinationIfIp,
                        "status": d.status
                    })
                }
            }
        });
        var shift_count_tf = false;
        var shift_count = 0;
        link = link.data(graph.links).enter().append("line")
                .attr("class", function (d) {
                    var multiLink = false;
                    var multiLinkDown = false;
                    var key = d.sourceID.nodeNo + ":" + d.destinationID.nodeNo // src and dest combination as a first key
                    var key2 = d.destinationID.nodeNo + ":" + d.sourceID.nodeNo // dest and src combination as second key
                    if (key in mapTest || key2 in mapTest) {
                        key = (key in mapTest) ? key : key2;
                        var temp = get(key);
                        var test = temp.slice();
                        if (test.length > 2)
                        {
                            d.linknum = test.length
                            multiLink = true;
                            shift_count_tf = true;
                            shift_count = test.length;
                            for (var j = 0; j < test.length; j++)
                            {
                                if (test[j].status == "2")
                                {
                                    multiLinkDown = true;
                                    break;
                                }
                            }
                        }
                    }
                    if (multiLink)
                    {
                        if (multiLinkDown)
                            return "multiLinkDown"
                        else {
                            return "multiLink";
                        }
                    } else {
                        if (d.status == "2")
                        {
                            return "downLink";
                        } else
                        {
                            if ($("#utilFilterSelector").prop("checked")) {
                                var Utilization = parseInt(d.utilization);
                                if (Utilization <= 25)
                                {
                                    return "link025";
                                } else if (Utilization > 25 && Utilization <= 50)
                                {
                                    return "link2550";
                                } else if (Utilization > 50 && Utilization <= 75)
                                {
                                    return "link5075";
                                } else if (Utilization > 75)
                                {
                                    return "link75";
                                } else {
                                    return "link";
                                }
                            } else {

                                if (d.crc == "NA") {
                                    return "link025";
                                } else {
                                    var crcValue = parseInt(d.crc);
                                    if (crcValue == 0) {
                                        return "link025";
                                    } else if (crcValue > 0 && crcValue <= 500) {
                                        return "link2550";
                                    } else {
                                        return "link5075";
                                    }
                                }

                            }
                        }
                    }
                })
                .attr("x1", function (d) {
                    if (shift_count_tf) {
                        return d.sourceID.x;
                    } else
                        return d.sourceID.x + 10;
                })
                .attr("y1", function (d) {
                    return d.sourceID.y;
                })
                .attr("x2", function (d) {
                    return d.destinationID.x;
                })
                .attr("y2", function (d) {

                    return d.destinationID.y;
                })
                .classed("testButton", true)
                .on("mouseover", function (d) {
                    div.transition()
                            .duration(200)
                            .style("opacity", .9);
                    div.html('<table class="table" style="margin-bottom:0;"><tr><td>LinkName:</td><td><b>' + d.linkName + '</b></td></tr><tr><td>Bandwidth:</td><td><b>' + d.bandwidth + '</b></td></tr><tr><td>Utilization :</td><td><b>' + d.utilization + ' %</b></td></tr><tr><td style="width:10rem">Down Since :</td><td><b>' + d.downSince + '</b></td></tr></table>')
                            .style("left", (d3.event.pageX) + "px")
                            .style("top", (d3.event.pageY - 28) + "px")
                            .style("width", 500 + "px");
                })
                .on("mousedown", function (d, i) {

                })
                .on("mouseout", function (d) {
                    div.transition()
                            .duration(500)
                            .style("opacity", 0);
                })
                .on("contextmenu", function (data, event) {
                    var linkName = data.linkName.split(" - ");
                    var link = linkName[0].split(":");
                    globalInterfaceName = link[1];
                    globalNodeName = link[0]
                    d3.event.preventDefault();
                    $(".custom-menu").finish().toggle(100).
                            css({
                                top: d3.event.pageY + "px",
                                left: d3.event.pageX + "px"
                            });
                });
        text = text.data(graph.nodes)
                .enter().append("text")
                .text(function (d) {
                    if (fancyflag == "1") {
                        if ($("#topologygroupname").val().includes("-T4")) {
                            return d.shortNodeName;
                        } else {
                            if (d.nodeType == "VN") {

                            } else {
                                return d.shortNodeName;
                            }
                        }
                    } else {
                        if ($("#vrfId").val().includes("-T4")) {
                            return d.shortNodeName;
                        } else {
                            if (d.nodeType == "VN") {

                            } else {
                                return d.shortNodeName;
                            }
                        }
                    }

                })
                .attr("font-weight", function (d) {
                    var temp = d.nodeType;
                    if (temp == "VN")
                        return 400;
                    else
                        return 500;
                })
                .attr("letter-spacing", function (d) {
                    var temp = d.nodeType;
                    if (temp == "VN")
                        return "0em";
                    else
                        return "0.1em";
                })
                .attr("font-size", function (d) {
                    var temp = d.nodeType;
                    if (temp == "VN")
                        return 9;
                    else
                        return 11;
                })
                .attr("display", function (d) {//to display text on the basis of node name checkbox
                    if (showText) {
                        return "inline";
                    } else {
                        return "none";
                    }
                })
                .attr("x", function (d) {
                    var temp = d.nodeType;
                    if (temp == "SP")
                        return d.x - 45;
                    else
                        return d.x - 20;
                })
                .attr("y", function (d) {
                    if (d.nodeType == "VN") {
                        return d.y - 8;
                    } else {
                        return d.y + 15;
                    }
                });
        node = node.data(graph.nodes).enter().append("svg:image")
                .attr('width', function (d) {
                    if (d.nodeType == "VN")
                        return 1 * 5;
                    else {
                        if (d.tier == "T1")
                            return 45;
                        else if (d.tier == "T2")
                            return 35;
                        else if (d.tier == "T3")
                            return 30;
                        else if (d.tier == "T4")
                            return 25;
                        else if (d.tier == "T4_colo")
                            return 25;
                        else if (d.tier == "T4_CNC")
                            return 25;
                        else if (d.tier == "T5")
                            return 20;
                        else if (d.tier == "T6")
                            return 15;
                        else
                            return 10;
                    }
                })
                .attr('height', function (d) {
                    if (d.nodeType == "VN")
                        return 5 * 10;
                    else
                    {
                        if (d.tier == "T1")
                            return 25.5;
                        else if (d.tier == "T2")
                            return 22;
                        else if (d.tier == "T3")
                            return 20.5;
                        else if (d.tier == "T4")
                            return 17;
                        else if (d.tier == "T4_colo")
                            return 17;
                        else if (d.tier == "T4_CNC")
                            return 17;
                        else if (d.tier == "T5")
                            return 15.5;
                        else if (d.tier == "T6")
                            return 13;
                        else
                            return 10;
                    }
                })
                .attr("x", function (d) {
                    if (d.nodeType == "VN")
                        return d.x * 1 - 2;
                    else
                        return (d.x * 1) - 10;
                })
                .attr("y", function (d) {
                    if (d.nodeType == "VN")
                        return d.y - 25;
                    else
                        return d.y - 15;
                })
                .attr("xlink:href", function (d) {
                    if (d.status == '2') {
                        var icon = "../assets/images/gis/other.png";
                        var temp = d.nodeType;
                        switch (temp) {
                            case 'Switch':
                                icon = "../assets/images/gis/logical/Switchdown.png";
                                break;
                            case 'POP-Switch':
                                icon = "../assets/images/gis/logical/POP-Switch1.png";
                                break;
                            case 'BNG':
                                icon = "../assets/images/gis/logical/BNG1.png";
                                break;
                            case 'OLT':
                                icon = "../assets/images/gis/logical/OLT1.png";
                                break;
                            case 'Router':
                                icon = "../assets/images/gis/logical/Router1.png";
                                break;
                            case 'Internet':
                                icon = "../assets/images/gis/logical/Internet.png";
                                break;
                            case 'Service':
                                icon = "../assets/images/gis/logical/Service.png";
                                break;
                            case 'PE':
                                icon = "../assets/images/gis/logical/Router1.png";
                                break;
                            case 'CPE':
                                icon = "../assets/images/gis/logical/switch2.png";
                                break;
                            default:
                                icon = "../assets/images/gis/logical/Router1.png";
                                break;
                        }
                        return icon;
                    } else {

                        var temp = d.tier;
                        var icon = "../assets/images/gis/other.png";
                        switch (temp) {
                            case 'T1':
                                icon = "../assets/images/T2.png";
                                break;
                            case 'T2':
                                icon = "../assets/images/greenswitch.png";
                                break;
                            case 'T3':
                                icon = "../assets/images/T3.png";
                                break;
                            case 'T4':
                                icon = "../assets/images/03.png";
                                break;
                            case 'T5':
                                icon = "../assets/images/03.png";
                                break;
                            case 'T6':
                                icon = "../assets/images/03.png";
                                break;
                            case 'T4_colo':
                                icon = "../assets/images/04.png";
                                break;
                            case 'T4_CNC':
                                icon = "../assets/images/07.png";
                                break;
                        }
                        return icon;
                    }
                })
                .on("mousedown", function (d, i) {

                    if (!d.selected) {
                        d3.selectAll("text").style("display", function (p) {
                            if (p.NodeName === d.NodeName) {
                                fetchnodedata(p.NodeName);
                                return "inline";
                            } else {
                                if (showText) {
                                    return "inline";
                                } else {
                                    return "none";
                                }

                            }
                        });
                        if (!shiftKey) {
                            node.classed("selected", function (p) {
                                return p.selected = d === p;
                            });
                        } else {
                            d3.select(this).classed("selected", d.selected = true);
                        }

                    }
                })
                .classed("testButton", true)
                .call(d3.behavior.drag()
                        .on("dragstart", function () {
                            d3.event.sourceEvent.stopPropagation();
                        })
                        .on("drag", function (d) {
                            nudge(d3.event.dx, d3.event.dy);
                        }))



        $(".loading").hide();
    });
    function nudge(dx, dy) {

        node.filter(function (d) {
            return d.selected;
        })
                .attr("x", function (d) {
                    return d.x += dx;
                })
                .attr("y", function (d) {
                    return d.y += dy;
                })
                .attr("x", function (d) {
                    if (d.nodeType == "VN")
                        return (d.x * 1) - 5;
                    else
                        return d.x * 1 - 10;
                })
                .attr("y", function (d) {
                    if (d.nodeType == "VN")
                        return (d.y * 1) - 25;
                    else
                        return d.y * 1 - 15;
                })

        text.filter(function (d) {
            return d.selected;
        })
                .attr("x", function (d) {
                    var temp = d.nodeType;
                    if (temp == "VN")
                        return (d.x + 5) - 40;
                    else
                        return d.x - 20;
                })
                .attr("y", function (d) {
                    var temp = d.nodeType;
                    if (temp == "VN")
                        return (d.y + 2) - 20;
                    else
                        return d.y + 15;
                })


        link.filter(function (d) {
            return d.sourceID.selected;
        })
                .attr("x1", function (d) {
                    return d.sourceID.x;
                })
                .attr("y1", function (d) {
                    return d.sourceID.y;
                });
        link.filter(function (d) {
            return d.destinationID.selected;
        })
                .attr("x2", function (d) {
                    return d.destinationID.x;
                })
                .attr("y2", function (d) {
                    return d.destinationID.y;
                });
        d3.event.preventDefault();
    }
}
function drawNetworkViewUpdate(flag) {
    clearElements();
    var graph = globalMapData;
    let nodeMap = new Map();
    let nodeTierMap = new Map();
    var checkedValue = [];
    if ($('#routerName').is(':checked'))
    {
        d3.selectAll("text").style("display", "inline");
        showText = true;
    } else {
        d3.selectAll("text").style("display", "none");
        showText = false;
    }
    if (flag == "Tier") {
        $('input[name=tierValue]:checked').each(function () {
            let status = (this.checked ? $(this).val() : "");
            console.log("*******status************" + status);
            checkedValue.push(status);
        });
    } else if (flag == "Util") {
        $('input[name=utilValue]:checked').each(function () {
            let status = (this.checked ? $(this).val() : "");
            checkedValue.push(status);
        });
    } else if (flag == "CRC") {
        $('input[name=crcValue]:checked').each(function () {
            let status = (this.checked ? $(this).val() : "");
            checkedValue.push(status);
        });
    }

    var total_nodes = graph.nodes.length;
    var sp_nodes = 0;
    var cpe_nodes = 0;
    var down_nodes = 0;
    var up_nodes = 0;
    mapTest = {}
    for (var i = 0; i < graph.nodes.length; i++)
    {
        if (graph.nodes[i].NodeDesc == "service provider")
        {
            sp_nodes = sp_nodes + 1;
        } else {
            cpe_nodes = cpe_nodes + 1;
        }
        if (graph.nodes[i].status == "1" && graph.nodes[i].NodeDesc != "service provider")
            up_nodes = up_nodes + 1;
        else
            down_nodes = down_nodes + 1;
    }
    var health_pannel = "";
    global_total_nodes = cpe_nodes;
    global_down_nodes = 0;
    global_up_nodes = up_nodes;
    health_pannel = health_pannel + "<table border='1'  style='background-color:white;'><tr><td><table><tr><td><center><b>Device Status</b><center</td></tr><tr><td>Total Nodes : " + cpe_nodes + "</td><tr><td><div style='color:green;'>Up Nodes : " + up_nodes + "</div></td></tr><tr><td><div style='color:red;'> Down Nodes : " + (down_nodes - sp_nodes) + "</div></tr></td>";
    health_pannel = health_pannel + "</tr></table></td></tr></table>";
    setNodeList(graph.nodes)
    setLinkList(graph.links)
    loadNodeList();
    var cx = width / 2;
    var cy = height / 2;
    var radiusInner = 0;
    var radiusOuterEven = 260;
    var radiusOuterOdd = 260;
    var radiusOuter = 260;
    graph.nodes.forEach(function (d) {
        nodeTierMap.set(d.NodeName, d.tier);
        if (d.nodeType == "SP")
        {
            peList.push(d)
        } else {
            cpeList.push(d)
        }
    })
    var cpeNumber = cpeList.length;
    var peNumber = peList.length;
    var peAngleNode = 360 / peNumber
    var innerAngle = 0;
    var outerAngle = 0
    for (var i = 0; i < peList.length; i++)
    {
        var d = peList[i]
        finalNodeList.push(d)
        outerAngle = innerAngle;
        if (i % 2 == 0)
        {
            radiusOuter = radiusOuterEven;
        } else {
            radiusOuter = radiusOuterOdd;
        }
        var pesFromCpe = getCpeFromPe(d.nodeNo)
        var lengthOfArray = Math.round(pesFromCpe.length / 2);
        for (var j = 0; j < lengthOfArray; j++)
        {
            var t = pesFromCpe[j]
            cpeList = removeFromArray(cpeList, 'nodeNo', t.nodeNo)
            finalNodeList.push(t)
            outerAngle = outerAngle + 6
        }
        outerAngle = innerAngle - 6
        for (var k = lengthOfArray; k < pesFromCpe.length; k++)
        {
            var t = pesFromCpe[k]
            cpeList = removeFromArray(cpeList, 'nodeNo', t.nodeNo)
            finalNodeList.push(t)
            outerAngle = outerAngle - 6
        }
        innerAngle = innerAngle + peAngleNode
    }
    outerAngle = outerAngle + 12
    for (var k = 0; k < cpeList.length; k++)
    {
        var t = cpeList[k]
        finalNodeList.push(t);
        outerAngle = outerAngle + 6;
    }
    graph.nodes = [];
    graph.nodes = finalNodeList.slice(0);
    graph.links.forEach(function (d) {
        var tmpsrc, tmpdest;
        if (flag == "Util") {
            let value;
            let currentValue;
            if (d.status == 2) {
                if (checkedValue.includes("down")) {
                    currentValue = true;
                } else {
                    currentValue = false;
                }
                nodeMap.set(d.sourceID.nodeNo, currentValue);
            } else if (d.utilization == "NA" || d.utilization == undefined) {
                currentValue = true;
                nodeMap.set(d.sourceID.nodeNo, currentValue);
            } else {
                if (nodeMap.size == 0) {
                    for (let i = 0; i < checkedValue.length; i++) {
                        let utilVal = checkedValue[i].split("-");
                        if (parseFloat(d.utilization) >= parseFloat(utilVal[0]) && parseFloat(d.utilization) <= parseFloat(utilVal[1])) {
                            currentValue = "true";
                            break;
                        } else {
                            currentValue = "false";
                        }
                    }
                    nodeMap.set(d.sourceID.nodeNo, currentValue);
                } else {
                    if (nodeMap.has(d.sourceID.nodeNo)) {
                        value = nodeMap.get(d.sourceID.nodeNo);
                        for (let i = 0; i < checkedValue.length; i++) {
                            let utilVal = checkedValue[i].split("-");
                            if (parseFloat(d.utilization) >= parseFloat(utilVal[0]) && parseFloat(d.utilization) <= parseFloat(utilVal[1])) {
                                currentValue = "true";
                                break;
                            } else {
                                currentValue = "false";
                            }
                        }

                        if (value == currentValue) {
                            value = currentValue;
                        } else {
                            value = true;
                        }
                        nodeMap.set(d.sourceID.nodeNo, value);
                    } else {
                        for (let i = 0; i < checkedValue.length; i++) {
                            let utilVal = checkedValue[i].split("-");
                            if (parseFloat(d.utilization) >= parseFloat(utilVal[0]) && parseFloat(d.utilization) <= parseFloat(utilVal[1])) {
                                currentValue = "true";
                                break;
                            } else {
                                currentValue = "false";
                            }
                        }

                        nodeMap.set(d.sourceID.nodeNo, currentValue);
                    }
                }
            }
        } else if (flag == "CRC") {
            let value;
            let currentValue;
            if (nodeMap.size == 0) {
                for (let i = 0; i < checkedValue.length; i++) {
                    let crcVal = checkedValue[i];
                    if (crcVal == 0) {
                        if (d.crc === parseInt(crcVal)) {
                            currentValue = "true";
                            break;
                        } else {
                            currentValue = "false";
                        }
                    } else if (crcVal === "1-500") {
                        if (d.crc > 0 && d.crc < 500) {
                            currentValue = "true";
                            break;
                        } else {
                            currentValue = "false";
                        }
                    } else {
                        if (d.crc > 500) {
                            currentValue = "true";
                            break;
                        } else {
                            currentValue = "false";
                        }
                    }
                }
                nodeMap.set(d.sourceID.nodeNo, currentValue);
            } else {
                if (nodeMap.has(d.sourceID.nodeNo)) {
                    value = nodeMap.get(d.sourceID.nodeNo);
                    for (let i = 0; i < checkedValue.length; i++) {
                        let crcVal = checkedValue[i];
                        if (crcVal == "0") {
                            if (d.crc == 0) {
                                currentValue = "true";
                                break;
                            } else {
                                currentValue = "false";
                            }
                        } else if (crcVal == "1-500") {
                            if (d.crc > 0 && d.crc <= 500) {
                                currentValue = "true";
                                break;
                            } else {
                                currentValue = "false";
                            }
                        } else {
                            if (d.crc > 500) {
                                currentValue = "true";
                                break;
                            } else {
                                currentValue = "false";
                            }
                        }
                    }
                    if (value == currentValue) {
                        value = currentValue;
                    } else {
                        value = true;
                    }
                    nodeMap.set(d.sourceID.nodeNo, value);
                } else {
                    for (let i = 0; i < checkedValue.length; i++) {
                        let crcVal = checkedValue[i];
                        if (crcVal === "0") {
                            if (d.crc === 0) {
                                currentValue = "true";
                                break;
                            } else {
                                currentValue = "false";
                            }
                        } else if (crcVal === "1-500") {
                            if (d.crc > 0 && d.crc <= 500) {
                                currentValue = "true";
                                break;
                            } else {
                                currentValue = "false";
                            }
                        } else {
                            if (d.crc > 500) {
                                currentValue = "true";
                                break;
                            } else {
                                currentValue = "false";
                            }
                        }
                    }
                    nodeMap.set(d.sourceID.nodeNo, currentValue);
                }
            }
        }
        var key = d.sourceID + ":" + d.destinationID; // src and dest combination as a first key
        var key2 = d.destinationID + ":" + d.sourceID; // dest and src combination as second key
        tmpsrc = getNodeObject(d.sourceID);
        tmpdest = getNodeObject(d.destinationID);
        if (tmpsrc != undefined && tmpdest != undefined)
        {
            d.sourceID = tmpsrc;
            d.destinationID = tmpdest;
            if (key in mapTest || key2 in mapTest) {
                key = (key in mapTest) ? key : key2;
                var temp = get(key);
                var test = temp.slice();
                test.push({
                    "bandwidth": d.bandwidth,
                    "linkName": d.linkName,
                    "sourceIfIp": d.sourceIfIp,
                    "destinationIfIp": d.destinationIfIp,
                    "status": d.status
                })
                mapTest[key] = test;
            } else {
                mapTest[key] = new Array({
                    "bandwidth": d.bandwidth,
                    "linkName": d.linkName,
                    "sourceIfIp": d.sourceIfIp,
                    "destinationIfIp": d.destinationIfIp,
                    "status": d.status
                })
            }
        }
    });
    var shift_count_tf = false;
    var shift_count = 0;
    link = link.data(graph.links).enter().append("line")
            .attr("class", function (d) {
                var classVal = "";
                var fl1 = "";
                if (flag == "Tier") {
                    if (checkedValue.includes(d.sourceTier)) {
                        fl1 = "enabled";
                    }
                    let linkNodeNames = d.linkName.split(" - ");
                    let nodeNameA = linkNodeNames[0].split(":")[0];
                    let nodeNameB = linkNodeNames[1].split(":")[0]
                    let tierenableflagA;
                    let tierenableflagB;
                    if (nodeTierMap.get(nodeNameA) == "T4_colo" || nodeTierMap.get(nodeNameA) == "T4_CNC") {
                        tierenableflagA = "T4";
                    } else {
                        tierenableflagA = nodeTierMap.get(nodeNameA);
                    }
                    if (nodeTierMap.get(nodeNameB) == "T4_colo" || nodeTierMap.get(nodeNameB) == "T4_CNC") {
                        tierenableflagB = "T4";
                    } else {
                        tierenableflagB = nodeTierMap.get(nodeNameB);
                    }
                    if (nodeTierMap.get(nodeNameA) == nodeTierMap.get(nodeNameB)) {
                        if (checkedValue.includes(tierenableflagA) || checkedValue.includes(tierenableflagB)) {
                            console.log("in loop" + tierenableflagA + "" + tierenableflagB)
                            fl1 = "enabled";
                        } else {
                            fl1 = "disabled";
                        }
                    } else {
                        if (checkedValue.includes(tierenableflagA) && checkedValue.includes(tierenableflagB)) {
                            fl1 = "enabled";
                        } else {
                            fl1 = "disabled";
                        }
                    }
                } else if (flag == "Util") {
                    if (d.status == 2) {
                        if (checkedValue.includes("down")) {
                            fl1 = "enabled";
                        } else {
                            fl1 = "disabled";
                        }
                    } else if (d.utilization == "NA" || d.utilization == undefined) {
                        fl1 = "enabled";
                    } else {
                        for (let i = 0; i < checkedValue.length; i++) {
                            let utilVal = checkedValue[i].split("-");
                            if (parseFloat(d.utilization) >= parseFloat(utilVal[0]) && parseFloat(d.utilization) <= parseFloat(utilVal[1])) {
                                fl1 = "enabled";
                                break;
                            } else {
                                fl1 = "disabled";
                            }
                        }
                    }

                } else if (flag == "CRC") {
                    for (let i = 0; i < checkedValue.length; i++) {
                        let crcVal = checkedValue[i];
                        if (crcVal == "0") {
//                                        console.log(crcVal);
                            if (d.crc == 0) {
                                fl1 = "enabled";
                                break;
                            } else {
                                fl1 = "disabled";
                            }
                        } else if (crcVal == "1-500") {
                            if (d.crc > 0 && d.crc <= 500) {
                                fl1 = "enabled";
                                break;
                            } else {
                                fl1 = "disabled";
                            }
                        } else {
                            if (d.crc > 500) {
                                fl1 = "enabled";
                                break;
                            } else {
                                fl1 = "disabled";
                            }
                        }
                    }
                }
                var multiLink = false;
                var multiLinkDown = false;
                var key = d.sourceID.nodeNo + ":" + d.destinationID.nodeNo // src and dest combination as a first key
                var key2 = d.destinationID.nodeNo + ":" + d.sourceID.nodeNo // dest and src combination as second key
                if (key in mapTest || key2 in mapTest) {
                    key = (key in mapTest) ? key : key2;
                    var temp = get(key);
                    var test = temp.slice();
                    if (test.length > 2)
                    {
                        d.linknum = test.length
                        multiLink = true;
                        shift_count_tf = true;
                        shift_count = test.length;
                        for (var j = 0; j < test.length; j++)
                        {
                            if (test[j].status == "2")
                            {
                                multiLinkDown = true;
                                break;
                            }
                        }
                    }
                }
                if (multiLink)
                {
                    if (multiLinkDown)
                        classVal = "multiLinkDown";
                    else {
                        classVal = "multiLink";
                    }
                } else {
                    if (d.status == "2")
                    {
                        classVal = "downLink";
                    } else
                    {
                        if ($("#utilFilterSelector").prop("checked")) {
                            var Utilization = parseInt(d.utilization);
                            if (Utilization <= 25)
                            {
                                classVal = "link025";
                            } else if (Utilization > 25 && Utilization <= 50)
                            {
                                classVal = "link2550";
                            } else if (Utilization > 50 && Utilization <= 75)
                            {
                                classVal = "link5075";
                            } else if (Utilization > 75)
                            {
                                classVal = "link75";
                            } else {
                                classVal = "link";
                            }
                        } else {
                            if (d.crc == "NA") {
                                classVal = "link025";
                            } else {
                                var crcValue = parseInt(d.crc);
                                if (crcValue == 0) {
                                    classVal = "link025";
                                } else if (crcValue > 0 && crcValue <= 500) {
                                    classVal = "link2550";
                                } else {
                                    classVal = "link5075";
                                }
                            }

                        }

                    }
                }
                var val = classVal + " " + fl1;
                console.log("class Assigned  : " + val)
                return val;
            })
            .attr("x1", function (d) {
                if (shift_count_tf) {
                    return d.sourceID.x;
                } else
                    return d.sourceID.x + 10;
            })
            .attr("y1", function (d) {
                return d.sourceID.y;
            })
            .attr("x2", function (d) {
                return d.destinationID.x;
            })
            .attr("y2", function (d) {

                return d.destinationID.y;
            })
            .classed("testButton", true)
            .on("mouseover", function (d) {
                div.transition()
                        .duration(200)
                        .style("opacity", .9);
                div.html('<table class="table" style="margin-bottom:0;"><tr><td>LinkName:</td><td><b>' + d.linkName + '</b></td></tr><tr><td>Bandwidth:</td><td><b>' + d.bandwidth + '</b></td></tr><tr><td>Utilization :</td><td><b>' + d.utilization + ' %</b></td></tr><tr><td style="width:10rem;">Down Since :</td><td><b>' + d.downSince + '</b></td></tr></table>')
                        .style("left", (d3.event.pageX - 20) + "px")
                        .style("top", (d3.event.pageY - 28) + "px")
                        .style("width", 500 + "px");
                ;
            })
            .on("mousedown", function (d, i) {

            })
            .on("mouseout", function (d) {
                div.transition()
                        .duration(500)
                        .style("opacity", 0);
            })
            .on("contextmenu", function (data, event) {
                var linkName = data.linkName.split(" - ");
                var link = linkName[0].split(":");
                globalInterfaceName = link[1];
                globalNodeName = link[0]
                d3.event.preventDefault();
                $(".custom-menu").finish().toggle(100).
                        css({
                            top: d3.event.pageY + "px",
                            left: d3.event.pageX + "px"
                        });
            });
    text = text.data(graph.nodes)
            .enter().append("text")
            .text(function (d) {
                if (fancyflag == "1") {
                    if ($("#topologygroupname").val().includes("-T4")) {
                        return d.shortNodeName;
                    } else {
                        if (d.nodeType == "VN") {

                        } else {
                            return d.shortNodeName;
                        }
                    }
                } else {
                    if ($("#vrfId").val().includes("-T4")) {
                        return d.shortNodeName;
                    } else {
                        if (d.nodeType == "VN") {

                        } else {
                            return d.shortNodeName;
                        }
                    }
                }
                if (fancyflag == "1") {
                    if ($("#topologygroupname").val().includes("-T4")) {
                        return d.shortNodeName;
                    } else {
                        if (d.nodeType == "VN") {

                        } else {
                            return d.shortNodeName;
                        }
                    }
                } else {
                    if ($("#vrfId").val().includes("-T4")) {
                        return d.shortNodeName;
                    } else {
                        if (d.nodeType == "VN") {

                        } else {
                            return d.shortNodeName;
                        }
                    }
                }

            })
            .attr("font-weight", function (d) {
                var temp = d.nodeType;
                if (temp == "VN")
                    return 0;
                else
                    return 600;
            })
            .attr("letter-spacing", function (d) {
                var temp = d.nodeType;
                if (temp == "VN")
                    return "0em";
                else
                    return "0.1em";
            })
            .attr("font-size", function (d) {
                var temp = d.nodeType;
                if (temp == "VN")
                    return 9;
                else
                    return 11;
            })
            .attr("display", function (d) {//to display text on the basis of node name checkbox
                if (showText) {
                    return "inline";
                } else {
                    return "none";
                }
            })
            .attr("x", function (d) {
                var temp = d.nodeType;
                if (temp == "SP")
                    return d.x - 45;
                else
                    return d.x - 20;
            })
            .attr("y", function (d) {
                if (d.nodeType == "VN") {
                    return d.y - 8;
                } else {
                    return d.y + 15;
                }
            }).attr("class", function (d) {
        let fl;
        if (flag == "Tier") {
            var tierflag1;
            if (d.tier == "T4_colo" || d.tier == "T4_CNC") {
                tierflag1 = "T4";
            } else {
                tierflag1 = d.tier;
            }
            if (checkedValue.includes(tierflag1)) {
                fl = "enabled";
            } else {
                fl = "disabled";
            }
        } else if (flag == "Util") {
            let val = nodeMap.get(d.nodeNo);
            if (val == "true") {
                fl = "enabled";
            } else if (val == "false") {
                fl = "disabled";
            } else if (d.nodeType == "VN") {
                fl = "disabled";
            }
        } else if (flag == "CRC") {
            let val = nodeMap.get(d.nodeNo);
            if (val == "true") {
                fl = "enabled";
            } else if (val == "false") {
                fl = "disabled";
            } else if (d.nodeType == "VN") {
                fl = "disabled";
            }
        }
        return fl;
    })
            .style("visibility", function (d) {

            });
    node = node.data(graph.nodes).enter().append("svg:image")
            .attr('width', function (d) {
                if (d.nodeType == "VN")
                    return 1 * 5;
                else {
                    if (d.tier == "T1")
                        return 45;
                    else if (d.tier == "T2")
                        return 35;
                    else if (d.tier == "T3")
                        return 30;
                    else if (d.tier == "T4")
                        return 25;
                    else if (d.tier == "T4_colo")
                        return 25;
                    else if (d.tier == "T4_CNC")
                        return 25;
                    else if (d.tier == "T5")
                        return 20;
                    else if (d.tier == "T6")
                        return 15;
                    else
                        return 10;
                }
            })
            .attr('height', function (d) {
                if (d.nodeType == "VN")
                    return 5 * 10;
                else
                {
                    if (d.tier == "T1")
                        return 25.5;
                    else if (d.tier == "T2")
                        return 22;
                    else if (d.tier == "T3")
                        return 20.5;
                    else if (d.tier == "T4")
                        return 17;
                    else if (d.tier == "T4_colo")
                        return 17;
                    else if (d.tier == "T4_CNC")
                        return 17;
                    else if (d.tier == "T5")
                        return 15.5;
                    else if (d.tier == "T6")
                        return 13;
                    else
                        return 10;
                }
            })
            .attr("x", function (d) {
                if (d.nodeType == "VN")
                    return d.x * 1 - 2;
                else
                    return (d.x * 1) - 10;
            })
            .attr("y", function (d) {
                if (d.nodeType == "VN")
                    return d.y - 25;
                else
                    return d.y - 15;
            })
            .attr("xlink:href", function (d) {
                if (d.status == '2') {
                    var icon = "../assets/images/gis/other.png";
                    var temp = d.nodeType;
                    switch (temp) {
                        case 'Core-Switch':
                            icon = "../assets/images/gis/logical/Core-Switch1.png";
                            break;
                        case 'POP-Switch':
                            icon = "../assets/images/gis/logical/POP-Switch1.png";
                            break;
                        case 'BNG':
                            icon = "../assets/images/gis/logical/BNG1.png";
                            break;
                        case 'OLT':
                            icon = "../assets/images/gis/logical/OLT1.png";
                            break;
                        case 'Router':
                            icon = "../assets/images/gis/logical/Router1.png";
                            break;
                        case 'Internet':
                            icon = "../assets/images/gis/logical/Internet.png";
                            break;
                        case 'Service':
                            icon = "../assets/images/gis/logical/Service.png";
                            break;
                        case 'PE':
                            icon = "../assets/images/gis/logical/Router1.png";
                            break;
                        case 'CPE':
                            icon = "../assets/images/gis/logical/switch2.png";
                            break;
                        default:
                            icon = "../assets/images/gis/logical/Router1.png";
                            break;
                    }
                    return icon;
                } else {

                    var temp = d.tier;
                    var icon = "../assets/images/gis/other.png";
                    switch (temp) {
                        case 'T1':
                            icon = "../assets/images/T2.png";
                            break;
                        case 'T2':
                            icon = "../assets/images/greenswitch.png";
                            break;
                        case 'T3':
                            icon = "../assets/images/T3.png";
                            break;
                        case 'T4':
                            icon = "../assets/images/03.png";
                            break;
                        case 'T5':
                            icon = "../assets/images/03.png";
                            break;
                        case 'T6':
                            icon = "../assets/images/03.png";
                            break;
                        case 'T4_colo':
                            icon = "../assets/images/04.png";
                            break;
                        case 'T4_CNC':
                            icon = "../assets/images/07.png";
                            break;
                    }
                    return icon;
                }
            }).attr("class", function (d) {
        let fl;
        if (flag == "Tier") {
            var tierflag = d.tier;
            var flagoft4;
            if (tierflag == "T4_colo") {
                flagoft4 = "T4";
            } else if (tierflag == "T4_CNC") {
                flagoft4 = "T4";
            } else {
                flagoft4 = tierflag;
            }

            if (checkedValue.includes(flagoft4)) {
                fl = "enabled";
            } else {
                fl = "disabled";
            }
        } else if (flag == "Util") {
            let val = nodeMap.get(d.nodeNo);
            if (val == "true") {
                fl = "enabled";
            } else if (val == "false") {
                fl = "disabled";
            } else if (d.nodeType == "VN") {
                fl = "disabled"
            }
        } else if (flag == "CRC") {
            let val = nodeMap.get(d.nodeNo);
            if (val == "true") {
                fl = "enabled";
            } else if (val == "false") {
                fl = "disabled";
            } else if (d.nodeType == "VN") {
                fl = "disabled"
            }
        }
        return fl;
    })
            .on("mousedown", function (d, i) {
                if (!d.selected) {
                    d3.selectAll("text").style("display", function (p) {
                        if (p.NodeName === d.NodeName) {
                            fetchnodedata(p.NodeName);
                            return "inline";
                        } else {
                            if (showText) {
                                return "inline";
                            } else {
                                return "none";
                            }

                        }
                    });
                    if (!shiftKey) {
                        node.classed("selected", function (p) {
                            return p.selected = d === p;
                        });
                    } else {
                        d3.select(this).classed("selected", d.selected = true);
                    }

                }
            })
            .classed("testButton", true)
            .call(d3.behavior.drag()
                    .on("dragstart", function () {
                        d3.event.sourceEvent.stopPropagation();
                    })
                    .on("drag", function (d) {
                        nudge(d3.event.dx, d3.event.dy);
                    }))
    function nudge(dx, dy) {
        node.filter(function (d) {
            return d.selected;
        })
                .attr("x", function (d) {
                    return d.x += dx;
                })
                .attr("y", function (d) {
                    return d.y += dy;
                })
                .attr("x", function (d) {
                    if (d.nodeType == "VN")
                        return (d.x * 1) - 5;
                    else
                        return d.x * 1 - 15;
                })
                .attr("y", function (d) {
                    if (d.nodeType == "VN")
                        return (d.y * 1) - 25;
                    else
                        return d.y * 1 - 15;
                })

        text.filter(function (d) {
            return d.selected;
        })
                .attr("x", function (d) {
                    var temp = d.nodeType;
                    if (temp == "SP")
                        return (d.x + 5) - 40;
                    else
                        return d.x - 20;
                })
                .attr("y", function (d) {
                    var temp = d.nodeType;
                    if (temp == "VN")
                        return (d.y + 2) - 20;
                    else
                        return d.y + 15;
                })


        link.filter(function (d) {
            return d.sourceID.selected;
        })
                .attr("x1", function (d) {
                    return d.sourceID.x;
                })
                .attr("y1", function (d) {
                    return d.sourceID.y;
                });
        link.filter(function (d) {
            return d.destinationID.selected;
        })
                .attr("x2", function (d) {
                    return d.destinationID.x;
                })
                .attr("y2", function (d) {
                    return d.destinationID.y;
                });
    }
}
function showNodeNeighbours(nodeNumber) {
    console.log("inside physical");
    if (fancyflag == "1") {
        var groupName = $("#topologygroupname").val();
    } else {
        var groupName = $("#vrfId").val();
    }

    console.log("NodeNUmber : " + nodeNumber)
    $.ajax({
        type: "POST",
        url: "../LogicalTopology",
        data: {requestType: "26", nodeNumber: nodeNumber, groupName: groupName},
        dataType: "text",
        success: function (data) {
            var flag = $('input[name="groupFlag"]:checked').val();
            console.log("Flag Value is " + flag);
            drawNetworkView(flag);
        }
    });
}

function fetchnodedata(nodename) {
    $(".nodedetaillegend").show();
    $(".nodedetaillegenddata").empty();
    $(".nodedetaillegenddata").append("<li>Loading Data...</li>");
    $.ajax({
        type: "POST",
        url: "../LogicalTopology",
        data: {requestType: "11", nodename: nodename},
        dataType: "json",
        success: function (data) {
            $(".nodedetaillegenddata").empty();
            $(".nodedetaillegenddata").append('<li style="border-radius: 5px;"><div style="color: #990033;font-weight: 600;">Node Name</div><span class="nodeDetailsValue">' + nodename + '</span></li>');
            $(".nodedetaillegenddata").append('<li style="border-radius: 5px;"><div style="color: #990033;font-weight: 600;">Node IP</div><span class="nodeDetailsValue">' + data[0] + '</span></li>');
            $(".nodedetaillegenddata").append('<li style="border-radius: 5px;"><div style="color: #990033;font-weight: 600;">Node Type</div><span class="nodeDetailsValue">' + data[1] + '</span></li>');
            $(".nodedetaillegenddata").append("<li style='background: transparent;text-align: center;'><button class='btn vega_btn' style='width: 100%;margin-left: -4px;' onClick='getInventoryDetail(\"" + nodename + "\")'>Get Inventory</button></li>");
        }
    })

}
function getInventoryDetail(nodename) {
    console.log(nodename);
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
        url: "../Inventory",
        data: {
            "requestType": 1,
            nodeip: nodename
        },
        dataType: 'json',
        success: function (data)
        {
            console.log("data: " + data);
            $.fancybox.open($(".detailed_view_popup1"), {
                title: 'Custom Title',
                closeEffect: 'none',
                autoSize: false,
                width: "90%",
                height: "80%"
            });
            console.log(nodename);
            $("#headerFancy").html(nodename);
            dataTableObject = $('.dashboard_tbl_data').DataTable({
                data: data,
                "autoWidth": true,
                "columnDefs": [
                    {className: "dt-left", "targets": 0},
                    {className: "dt-left", "targets": 1},
                    {className: "dt-left", "targets": 2},
                    {className: "dt-left", "targets": 3},
                    {className: "dt-left", "targets": 4},
                    {className: "dt-left", "targets": 5},
                    {className: "dt-left", "targets": 6},
                    {className: "dt-left", "targets": 7},
                    {className: "dt-left", "targets": 8},
                    {className: "dt-left", "targets": 9},
                    {className: "dt-left", "targets": 10},
                ],
                columns: [
                    {title: "Node ID"},
                    {title: "Node Name"},
                    {title: "Vendor Name"},
                    {title: "Interface Name"},
                    {title: "If IPAddress"},
                    {title: "If Admin Status"},
                    {title: "IfOperStatus"},
                    {title: "IfMtu"},
                    {title: "IfSpeed"},
                    {title: "IfPhyAddress"},
                    {title: "Interface Desc"},
                ],
                "scrollX": true,
                "scrollY": "210px",
                "pageLength": 15,
                fixedHeader: false, dom: 'Blfrtip',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Nodes Inventory  Report',
                    }
                ]
            });
        },
        error: function (jqXHR, exception) {
            var msg = '';
            if (jqXHR.status === 0) {
                msg = 'Not connect.\n Verify Network.';
            } else if (jqXHR.status == 404) {
                msg = 'Requested page not found. [404]';
            } else if (jqXHR.status == 500) {
                msg = 'Internal Server Error [500].';
            } else if (exception === 'parsererror') {
                msg = 'Requested JSON parse failed.';
            } else if (exception === 'timeout') {
                msg = 'Time out error.';
            } else if (exception === 'abort') {
                msg = 'Ajax request aborted.';
            } else {
                msg = 'Uncaught Error.\n' + jqXHR.responseText;
            }
            //////console.log(msg);
        }
    });
}

function showPhysicalInterface(nodename) {
    $.ajax({
        type: "POST",
        url: "../LogicalTopology",
        data: {requestType: "1", nodeName: nodename},
        dataType: "json",
        success: function (data) {
            $("#headerFancy").html(nodename);
            $.fancybox.open($(".detailed_view_popup"), {
                title: 'Custom Title',
                closeEffect: 'none',
                autoSize: false,
                width: "auto",
                height: "80%"
            });
            var htmlData = '<table class="table table-bordered table-hoverable"><thead><tr><td>Source NodeName</td><td>Source Bundle Interface</td><td>Dest NodeName</td><td>Dest Bundle Interface</td><td>Source Physical Interface</td></tr></thead><body>';
            console.log("physical Interface data");
            console.log(data);
            for (let i = 0; i < data.length; i++) {
                let bundleList = data[i][4].split(",");
                let bundleCount = bundleList.length;
                console.log(bundleList);
                console.log(bundleCount);
                htmlData = htmlData + '<tr><td rowspan="' + bundleCount + '" style="vertical-align : middle;text-align:center;">' + data[i][0] + '</td><td rowspan="' + bundleCount + '" style="vertical-align : middle;text-align:center;">' + data[i][1] + '</td><td rowspan="' + bundleCount + '" style="vertical-align : middle;text-align:center;">' + data[i][2] + '</td><td rowspan="' + bundleCount + '" style="vertical-align : middle;text-align:center;">' + data[i][3] + '</td>';
                for (let j = 0; j < bundleCount; j++) {
                    if (j == 0) {
                        var bundle = bundleList[j].split(":");
                        if (bundle[1] == "2") {
                            htmlData = htmlData + '<td style="background-color:red;">' + bundle[0] + '</td></tr>';
                        } else {
                            htmlData = htmlData + '<td>' + bundle[0] + '</td></tr>';
                        }

                    } else {
                        var bundle = bundleList[j].split(":");
                        if (bundle[1] == "2") {
                            htmlData = htmlData + '<tr><td style="background-color:red;">' + bundle[0] + '</td></tr>';
                        } else {
                            htmlData = htmlData + '<tr><td>' + bundle[0] + '</td></tr>';
                        }
                    }
                }
            }
            htmlData = htmlData + '</tbody></table>';
            console.log(htmlData);
            $(".dashboard_tbl").html(htmlData);
        }
    });
}
function showModal(rqType, nodename) {

    parent.triggerLogicalViewModal(rqType, nodename);
}

function viewGraphPlot() {
    getCurrentDate();
    var tscale = "Kbps";
    var dbType = "current";
    var fromTime = globalFromTime;
    var toTime = globalToTime;
    $("#chartContainerPlot").html('');
    $("#dataContainerPlot").html('');
    $("#dataContainerPlot").hide();
    $(".chartModelTitlePlot").html("Traffic Plot for   " + globalNodeName + " : " + globalInterfaceName);
    $("#chartContainerPlot").html('<div class="timeRange" style="display:inline-flex; padding-left: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;From&nbsp;<input type="text" id="FromTimeFilter" class="form-control" placeholder="From Time" style="width:123px;height:28px;padding: 1px 1px;margin-top: -4px;font-size: 12px;">&nbsp;&nbsp;To&nbsp;&nbsp;<input type="text" id="ToTimeFilter" class="form-control" placeholder="To Time" style="width:123px;height:28px;padding: 1px 1px;margin-top: -4px;font-size: 12px;" >&nbsp;&nbsp;&nbsp;<input type="radio" id="CurrentDb" name="DatabaseTypeFilter" value="current" style="margin: 0px 0 0;" />&nbsp;Current Traffic &nbsp;&nbsp;&nbsp;<input type="radio" id="HistoricDb" name="DatabaseTypeFilter" value="historic" style="margin: 0px 0 0;"/>&nbsp;Historic Traffic</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Traffic Scale&nbsp;<select id="trafficScaleModal" class="form-control" style="width:8% !important;height:28px !important;"><option value="Kbps">Kbps</option> <option value="Mbps">Mbps</option><option value="Gbps">Gbps</option></select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button class="btn" style="padding: 2px 15px;color:white;background-color:#990033" onclick="getDomesticBackGraph(\'' + globalNodeName + '\',\'' + globalInterfaceName + '\')">View</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<div class="col-md-12 loadingLabel "><img align="right" src="../assets/images/loading_1.gif" width="100px"></div><br><br><div class="col-md-12"><div id="chart3"></div></div>');
    $("#dataContainerPlot").html('<table id="chartTablePlot" class="display compact cell-border" cellspacing="0"  width="100%"></table>');
    $("#trafficScaleModal").select2();
    $("#FromTimeFilter").val(fromTime);
    $("#ToTimeFilter").val(toTime);
    $("#FromTimeFilter").datetimepicker({format: 'YYYY-MM-DD HH:mm:ss'});
    $("#ToTimeFilter").datetimepicker({format: 'YYYY-MM-DD HH:mm:ss'});
    $("#CurrentDb").prop("checked", true);
    $.ajax({
        type: "POST",
        url: "../LogicalTopology",
        data: {requestType: "9", nodeName: globalNodeName, interfaceName: globalInterfaceName, fromTime: fromTime, toTime: toTime, dbType: dbType, trafficScale: tscale},
        dataType: "json",
        success: function (data) {
            console.log("data  of chart");
            console.log(data);
            var jsonData = data;
            var temp = "<table id='example5' class='display compact cell-border' cellspacing='0'  width='100%'><thead><tr><th>In</th><th>Out</th><th>Time</th></tr></thead><tbody>";
            for (var i = 0; i < jsonData.length; i++) {
                var t2 = jsonData[i].timeseries;
                var t1 = t2.split(".");
                var t = t1[0];
                var test = t;
                var t = t.split(/[- :]/);
                var d = new Date(t[0], t[1] - 1, t[2], t[3], t[4], t[5]);
                jsonData[i].timeseries = d;
                jsonData[i].value = parseInt(jsonData[i].value);
                temp = temp + "<tr><td>" + jsonData[i].in + "</td><td>" + jsonData[i].out + "</td><td>" + test + "</td></tr>";
            }
            var ytitle = "Traffic in " + tscale;
            var xtitle = "Time";
            temp = temp + "</tbody></table>";
            $("#dataContainerPlot").html(temp)
            $('#example5').DataTable({
                "scrollX": true,
                "order": [[2, "desc"]],
                fixedHeader: true, dom: 'Blfrtip',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Plot Report for   ' + globalNodeName + ' : ' + globalInterfaceName
                    },
                    {
                        extend: 'pdfHtml5',
                        title: 'Plot Report    ' + globalNodeName + ' : ' + globalInterfaceName
                    }
                ],
                "initComplete": function (settings, json) {
                    $('.dataTables_scrollBody thead tr').css({visibility: 'collapse'});
                },
                "fnDrawCallback": function () {
                    $("#dataContainerPlot").show();
                    this.api().columns.adjust();
                }
            });
            $("#dataContainerPlot").hide();
            drawChartLinkTraffic(jsonData, xtitle, ytitle);
        }
    });
    $('#chartModalPlot').modal("toggle");
}

function viewCRCGraphPlot() {
    getCurrentDate();
    var tscale = "Kbps";
    var dbType = "current";
    var fromTime = "2022-07-05 12:35:46"; //globalFromTime;
    var toTime = "2022-07-07 12:35:46"; //globalToTime;
    $("#chartContainerPlot").html('');
    $("#dataContainerPlot").html('');
    $("#dataContainerPlot").hide();
    $(".chartModelTitlePlot").html("Traffic Plot for   " + globalNodeName + " : " + globalInterfaceName);
    $("#chartContainerPlot").html('<div class="timeRange" style="display:inline-flex; padding-left: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;From&nbsp;<input type="text" id="FromTimeFilter" class="form-control" placeholder="From Time" style="width:123px;height:28px;padding: 1px 1px;margin-top: -4px;font-size: 12px;">&nbsp;&nbsp;To&nbsp;&nbsp;<input type="text" id="ToTimeFilter" class="form-control" placeholder="To Time" style="width:123px;height:28px;padding: 1px 1px;margin-top: -4px;font-size: 12px;" >&nbsp;&nbsp;&nbsp;<input type="radio" id="CurrentDb" name="DatabaseTypeFilter" value="current" style="margin: 0px 0 0;" />&nbsp;Current Traffic &nbsp;&nbsp;&nbsp;<input type="radio" id="HistoricDb" name="DatabaseTypeFilter" value="historic" style="margin: 0px 0 0;"/>&nbsp;Historic Traffic</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Traffic Scale&nbsp;<select id="trafficScaleModal" class="form-control" style="width:8% !important;height:28px !important;"><option value="Kbps">Kbps</option> <option value="Mbps">Mbps</option><option value="Gbps">Gbps</option></select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button class="btn" style="padding: 2px 15px;color:white;background-color:#990033" onclick="getDomesticBackGraph(\'' + globalNodeName + '\',\'' + globalInterfaceName + '\')">View</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<div class="col-md-12 loadingLabel "><img align="right" src="../assets/images/loading_1.gif" width="100px"></div><br><br><div class="col-md-12"><div id="chart3"></div></div>');
    $("#dataContainerPlot").html('<table id="chartTablePlot" class="display compact cell-border" cellspacing="0"  width="100%"></table>');
    $("#trafficScaleModal").select2();
    $("#FromTimeFilter").val(fromTime);
    $("#ToTimeFilter").val(toTime);
    $("#FromTimeFilter").datetimepicker({format: 'YYYY-MM-DD HH:mm:ss'});
    $("#ToTimeFilter").datetimepicker({format: 'YYYY-MM-DD HH:mm:ss'});
    $("#CurrentDb").prop("checked", true);
    $.ajax({
        type: "POST",
        url: "../LogicalTopology",
        data: {requestType: "4", nodeName: globalNodeName, interfaceName: globalInterfaceName, fromTime: fromTime, toTime: toTime, dbType: dbType, interval: "5", trafficScale: tscale},
        dataType: "json",
        success: function (data) {
            console.log("data  of chart");
            console.log(data);
            var jsonData = data;
            var temp = "<table id='example5' class='display compact cell-border' cellspacing='0'  width='100%'><thead><tr><th>data</th><<th>Time</th></tr></thead><tbody>";
            for (var i = 0; i < jsonData.length; i++) {
                var t2 = jsonData[i].timeseries;
                var t1 = t2.split(".");
                var t = t1[0];
                var test = t;
                var t = t.split(/[- :]/);
                var d = new Date(t[0], t[1] - 1, t[2], t[3], t[4], t[5]);
                jsonData[i].timeseries = d;
                jsonData[i].value = parseInt(jsonData[i].value);
                temp = temp + "<tr><td>" + jsonData[i].data + "</td><td>" + test + "</td></tr>";
            }
            var ytitle = "CRC Value";
            var xtitle = "Time";
            temp = temp + "</tbody></table>";
            $("#dataContainerPlot").html(temp)
            $('#example5').DataTable({
                "scrollX": true,
                "order": [[2, "desc"]],
                fixedHeader: true, dom: 'Blfrtip',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Plot Report for   ' + globalNodeName + ' : ' + globalInterfaceName
                    },
                    {
                        extend: 'pdfHtml5',
                        title: 'Plot Report    ' + globalNodeName + ' : ' + globalInterfaceName
                    }
                ],
                "initComplete": function (settings, json) {
                    $('.dataTables_scrollBody thead tr').css({visibility: 'collapse'});
                },
                "fnDrawCallback": function () {
                    $("#dataContainerPlot").show();
                    this.api().columns.adjust();
                }
            });
            $("#dataContainerPlot").hide();
            drawOneInputChart()(jsonData, xtitle, ytitle);
        }
    });
    $('#chartModalPlot').modal("toggle");
}

function viewPowerData() {
    getCurrentDate();
    var dbType = "current";
    $("#dataContainerPlot").html('');
    $("#dataContainerPlot").html('<input type="radio" id="CurrentDb" name="DatabaseTypeFilter" value="current" style="margin: 0px 0 0;" />&nbsp;Current Traffic &nbsp;&nbsp;&nbsp;<input type="radio" id="HistoricDb" name="DatabaseTypeFilter" value="historic" style="margin: 0px 0 0;"/>&nbsp;Historic Traffic</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button class="btn" style="padding: 2px 15px;color:white;background-color:#990033" onclick="getPowerDataValues(\'' + globalNodeName + '\',\'' + globalInterfaceName + '\')">View</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<div class="col-md-12 loadingLabel "><img align="right" src="../assets/images/loading_1.gif" width="100px"></div><br><br><div class="col-md-12"><div id="dataTableContainer"><table id="chartTablePlot" class="display compact cell-border" cellspacing="0"  width="100%"></table></div></div>');
    $("#CurrentDb").prop("checked", true);
    $.ajax({
        type: "POST",
        url: "../LogicalTopology",
        data: {requestType: "5", nodeName: globalNodeName, interfaceName: globalInterfaceName, dbType: dbType},
        dataType: "json",
        success: function (tableData) {
            console.log("data  of chart");
            console.log(tableData);
            for (var j = 0; j < tableData.length; j++) {
                tableData[j][8] = tableData[j][8].split(".")[0];
            }
            $('#chartPlotTable').DataTable({
                data: tableData,
                "columnDefs": [
                    {className: "dt-left", "width": "200px", "targets": 0},
                    {className: "dt-left", "width": "150px", "targets": 1},
                    {className: "dt-left", "width": "80px", "targets": 2},
                    {className: "dt-left", "width": "80px", "targets": 3},
                    {className: "dt-left", "width": "80px", "targets": 4},
                    {className: "dt-left", "width": "80px", "targets": 5},
                    {className: "dt-left", "width": "80px", "targets": 6},
                    {className: "dt-left", "width": "80px", "targets": 7},
                    {className: "dt-left", "width": "140px", "targets": 8}
                ],
                columns: [
                    {title: "Node Name"},
                    {title: "Interface Name"},
                    {title: "Rx Power(dbm)"},
                    {title: "Tx Power(dbm)"},
                    {title: "Upper Threshold"},
                    {title: "Lower Threshold"},
                    {title: "Upper Warning"},
                    {title: "Lower Warning"},
                    {title: "Time"}
                ],
                paging: false,
                searching: false,
                "bInfo": false
            });
            $("#dataContainerPlot").show();
        }
    });
    $('#powerDataModal').modal("toggle");
}

$(document).bind("mousedown", function (e) {
    if (!$(e.target).parents(".custom-menu").length > 0) {
        $(".custom-menu").hide(100);
    }
});
$(".custom-menu li").click(function () {
    switch ($(this).attr("data-action")) {
        case "first":
            viewGraphPlot();
            break;
        case "second":
            viewCRCGraphPlot();
            break;
        case "third":
            viewPowerData();
            break;
    }
    $(".custom-menu").hide(100);
});
function drawChartLinkTraffic(json_data, xTitle, yTitle) {
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
                    text: xTitle,
                    position: 'outer-center'
                }
            },
            y: {
                label: {
                    text: yTitle,
                    position: 'outer-middle'
                }
            }
        },
        color: {
            pattern: ['#4CAF50', '#3F51B5', '#4CAF50', '#673AB7', '#3F51B5', '#2196F3', '#03A9F4', '#00BCD4', '#009688', '#4CAF50', '#8BC34A', '#CDDC39', '#FFEB3B', '#FFC107', '#FF9800', '#FF5722']
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
        },
        size: {
            height: 320,
            width: 850
        }, bindto: '#chart3'
    });
}

function drawOneInputChart(json_data, xTitle, yTitle) {
    var chart = c3.generate({
        point: {
            r: 1
        },
        data: {
            json: json_data,
            keys: {
                x: 'timeseries',
                value: ['data']
            },
            type: 'area'
        },
        axis: {
            x: {
                type: 'timeseries',
                tick: {
                    count: 6,
                    format: function (d) {
                        return  d.getDate() + "-" + (d.getMonth() + 1) + "-" + d.getFullYear() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
                    }
                },
                label: {
                    text: xTitle,
                    position: 'outer-center'
                }
            },
            y: {
                label: {
                    text: yTitle,
                    position: 'outer-middle'
                }
            }
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
        },
        size: {
            height: 270,
            width: 1050
        }, bindto: '#chart3'
    });
}
function getDomesticBackGraph(nodeName, InterfaceName) {
    var fromTime = $("#FromTimeFilter").val();
    var toTime = $("#ToTimeFilter").val();
    var DbType = $("input[name='DatabaseTypeFilter']:checked").val();
    var TrafficScale = $("#trafficScaleModal").val();
    $.ajax({
        type: "POST",
        url: "../LogicalTopology",
        data: {requestType: "9", nodeName: nodeName, interfaceName: InterfaceName, fromTime: fromTime, toTime: toTime, dbType: DbType, trafficScale: TrafficScale},
        dataType: "json",
        success: function (data) {
            console.log("data  of chart");
            console.log(data);
            var jsonData = data;
            var temp = "<table id='example3' class='display compact cell-border' cellspacing='0'  width='100%'><thead><tr><th>In</th><th>Out</th><th>Time</th></tr></thead><tbody>";
            for (var i = 0; i < jsonData.length; i++) {
                var t2 = jsonData[i].timeseries;
                var t1 = t2.split(".");
                var t = t1[0];
                var test = t;
                var t = t.split(/[- :]/);
                var d = new Date(t[0], t[1] - 1, t[2], t[3], t[4], t[5]);
                jsonData[i].timeseries = d;
                jsonData[i].value = parseInt(jsonData[i].value);
                temp = temp + "<tr><td>" + jsonData[i].in + "</td><td>" + jsonData[i].out + "</td><td>" + test + "</td></tr>";
            }
            var ytitle = "Traffic in " + TrafficScale;
            var xtitle = "Time";
            temp = temp + "</tbody></table>";
            $("#dataContainerPlot").html(temp)
            $('#example3').DataTable({
                "scrollX": true,
                fixedHeader: true, dom: 'Blfrtip',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Plot Report'
                    },
                    {
                        extend: 'pdfHtml5',
                        title: 'Plot Report'
                    }
                ],
                "initComplete": function (settings, json) {
                    $('.dataTables_scrollBody thead tr').css({visibility: 'collapse'});
                },
                "fnDrawCallback": function () {
                    $("#dataContainerPlot").show();
                    this.api().columns.adjust();
                }
            });
            $("#dataContainerPlot").hide();
            drawChartLinkTraffic(jsonData, xtitle, ytitle);
        }
    });
}
function tick() {
    path.attr("d", function (d) {
        var dx = d.target.x - d.source.x,
                dy = d.target.y - d.source.y,
                dr = 75 / d.linknum; //linknum is defined above
        return "M" + d.source.x + "," + d.source.y + "A" + dr + "," + dr + " 0 0,1 " + d.target.x + "," + d.target.y;
    });
    circle.attr("transform", function (d) {
        return "translate(" + d.x + "," + d.y + ")";
    });
    text.attr("transform", function (d) {
        return "translate(" + d.x + "," + d.y + ")";
    });
}






