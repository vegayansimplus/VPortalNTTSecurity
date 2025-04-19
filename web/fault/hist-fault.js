/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

var counterflag = "";
var counterFromTime = "";
var counterToTime = "";
var dbflag = "";
var TrapHistoric = angular.module('TrapHistoric', ['ngAnimate', 'ui.grid', 'ui.grid.saveState', 'ui.grid.selection', 'ui.grid.cellNav', 'ui.grid.resizeColumns', 'ui.grid.moveColumns', 'ui.grid.pinning', 'ui.grid.exporter', 'ui.grid.grouping', 'ui.bootstrap'], function ($httpProvider) {
    // Use x-www-form-urlencoded Content-Type
    $httpProvider.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=utf-8';

    /**
     * The workhorse; converts an object to x-www-form-urlencoded serialization.
     * @param {Object} obj
     * @return {String}
     */
    var param = function (obj) {
        var query = '', name, value, fullSubName, subName, subValue, innerObj, i;

        for (name in obj) {
            value = obj[name];

            if (value instanceof Array) {
                for (i = 0; i < value.length; ++i) {
                    subValue = value[i];
                    fullSubName = name + '[' + i + ']';
                    innerObj = {};
                    innerObj[fullSubName] = subValue;
                    query += param(innerObj) + '&';
                }
            } else if (value instanceof Object) {
                for (subName in value) {
                    subValue = value[subName];
                    fullSubName = name + '[' + subName + ']';
                    innerObj = {};
                    innerObj[fullSubName] = subValue;
                    query += param(innerObj) + '&';
                }
            } else if (value !== undefined && value !== null)
                query += encodeURIComponent(name) + '=' + encodeURIComponent(value) + '&';
        }

        return query.length ? query.substr(0, query.length - 1) : query;
    };

    // Override $http service's default transformRequest
    $httpProvider.defaults.transformRequest = [function (data) {
            return angular.isObject(data) && String(data) !== '[object File]' ? param(data) : data;
        }];
});





TrapHistoric.controller('MainCtrl', ['$scope', '$http', '$interval', '$modal', 'uiGridConstants', function ($scope, $http, $interval, $modal, uiGridConstants) {
        $scope.gridOptions1 = {};
        $scope.mySelections = [];
        $scope.showGrid = false;
        $scope.showButton = true;
        $scope.nodeNames = "ALL";
        $scope.trapType = "ALL";

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
        $scope.toTime = today;
        $today = new Date();
        $yesterday = new Date($today);
        $yesterday.setDate($today.getDate());
        var $dd = $yesterday.getDate();
        var $mm = $yesterday.getMonth() + 1; //January is 0!

        var $yyyy = $yesterday.getFullYear();
        if ($dd < 10) {
            $dd = $dd;
        }
        if ($mm < 10) {
            $mm = '0' + $mm;
        }

        var today = $yyyy + '-' + $mm + '-' + $dd + ' ' + hh + ':' + MM + ':' + ss;
        $scope.fromTime = today;
        //$scope.fromTime = "2016-11-11";
//        var d = new Date();

//        //$scope.toTime = new Date().toISOString().slice(0, 19).replace('T', ' ');
//        $scope.toTime = d.toISOString().slice(0, 19).replace('T', ' ');
//        d.setDate(d.getDate() - 1);
//        $scope.fromTime = d.toISOString().slice(0, 19).replace('T', ' ');
//

        //$scope.toTime = "2016-11-30 1:00:00";




        $scope.traps = ['Alarm', 'Hardware', 'BGP', 'Interface', 'Link', 'Reachability'];
        $scope.selection = ['Alarm', 'Hardware', 'BGP', 'Interface', 'Link', 'Reachability'];

        $scope.autoRefresh = false;
        $scope.myAppScopeProvider = {
            showRow: function (row) {
                return row.RttMonResult !== 'disabled';
            },
            showMenu: function (row) {
                var modalInstance = $modal.open({
                    controller: 'ContextController',
                    templateUrl: 'ngTemplate/ContextMenu.html',
                    resolve: {
                        selectedRow: function () {
                            //getTable(row.entity);
                            return row.entity;
                        }

                    }
                });

                modalInstance.result.then(function (selectedItem) {
                    console.log('modal selected Row: ' + selectedItem);
                }, function () {
                    console.log('Modal dismissed at: ' + new Date());
                });
            },
            showInfo: function (row, histFlag) {

                var modalInstance = $modal.open({
                    controller: 'InfoController',
//                    templateUrl: 'ngTemplate/FaultHistPopup.html',
                    templateUrl: 'ngTemplate/PopUpHist.html',
                    resolve: {
                        selectedRow: function () {
                            //getTable(row.entity);
                            return row.entity;
                        },
                        histFlag: function () {
                            //return 'historic';
                            //return true;
                            return histFlag;
                        }

                    }
                });

                modalInstance.result.then(function (selectedItem) {
                    console.log('modal selected Row: ' + selectedItem);
                }, function () {
                    console.log('Modal dismissed at: ' + new Date());
                });
            }
        }

//        $scope.rightClick = function (event) {
//            var scope = angular.element(event.toElement).scope()
//            console.log('got here',scope.rowRenderIndex);
//        };



        $scope.gridOptions = {
            //data1: [],
            showGridFooter: false,
            showColumnFooter: false,
            saveFocus: false,
            saveScroll: true,
            //enableSelectAll: false,
            //selectionRowHeaderWidth: 50,
            // showGrid: false//
            saveGroupingExpandedStates: true,
            enableFiltering: true,
            rowHeight: 21,
            appScopeProvider: $scope.myAppScopeProvider,
            //rowTemplate: '<div ng-dblclick=\"grid.appScope.showInfo(row)\"  ng-right-click="grid.appScope.showMenu(row)" ng-class="{\'flag-acknowledge\':row.entity.ack_Time_1!=\'\'&&row.entity.clear_Time_1==\'\',\'flag-clear\':row.entity.clear_Time_1!=\'\',\'flag-info\':row.entity.TrapSeverity==\'Info\',  \'flag-major\':row.entity.TrapSeverity==\'Major\',  \'flag-critical\':row.entity.TrapSeverity==\'Critical\'&&row.entity.ack_Time_1==\'\',\'flag-minor\':row.entity.TrapSeverity==\'MinorWarn\', }"> <div ng-repeat="col in colContainer.renderedColumns track by col.colDef.name"  class="ui-grid-cell" context-menu data-target="myMenu"  context-menu-margin-bottom="10" ui-grid-cell></div></div>',
            //rowTemplate: '<div ng-dblclick=\"grid.appScope.showInfo(row)\" ng-if=\"grid.appScope.showRow(row.entity)\"  ng-class="{\'flag-acknowledge\':row.entity.ack_Time_1!=\'\'&&row.entity.clear_Time_1==\'\',\'flag-clear\':row.entity.clear_Time_1!=\'\',\'flag-info\':row.entity.TrapSeverity==\'Info\',  \'flag-major\':row.entity.TrapSeverity==\'Major\',  \'flag-critical\':row.entity.TrapSeverity==\'Critical\'&&row.entity.ack_Time_1==\'\',\'flag-minor\':row.entity.TrapSeverity==\'MinorWarn\', }"> <div ng-repeat="col in colContainer.renderedColumns track by col.colDef.name"  class="ui-grid-cell" context-menu data-target="myMenu"  context-menu-margin-bottom="10" ui-grid-cell></div></div>',
            rowTemplate: '<div ng-dblclick=\"grid.appScope.showInfo(row,\'historic\')\" ng-if=\"grid.appScope.showRow(row.entity)\" ng-class="{\'flag-acknowledge\':row.entity.ack_Time_1!=\'\'&&row.entity.clear_Time_1==\'\',}" > <div ng-repeat="col in colContainer.renderedColumns track by col.colDef.name"  class="ui-grid-cell" context-menu data-target="myMenu"  context-menu-margin-bottom="10" ui-grid-cell></div></div>',
            exporterCsvFilename: 'SiMPLuS_TRAP_Report_' + getDateTime() + '.csv',
            exporterPdfFilename: 'SiMPLuS_TRAP_Report_' + getDateTime() + '.pdf',
            exporterPdfDefaultStyle: {fontSize: 9},
            exporterPdfTableStyle: {margin: [0, 0, 0, 0]},
            exporterPdfTableHeaderStyle: {fontSize: 10, bold: true, italics: true, color: 'red'},
            exporterPdfHeader: {alignment: 'center', text: "SiMPLuS TRAP Report", style: 'headerStyle'},
            exporterPdfFooter: function (currentPage, pageCount) {
                return {text: currentPage.toString() + ' of ' + pageCount.toString(), style: 'footerStyle'};
            },
            exporterPdfCustomFormatter: function (docDefinition) {
                docDefinition.styles.headerStyle = {fontSize: 22, bold: true};
                docDefinition.styles.footerStyle = {fontSize: 10, bold: true};
                return docDefinition;
            },
            //exporterPdfOrientation: 'portrait',
            exporterPdfOrientation: 'landscape',
            //exporterPdfPageSize: 'LETTER',
            exporterPdfPageSize: 'TABLOID',
            exporterPdfMaxGridWidth: 1000,
            //exporterpageMargins: [ 90, 90, 90, 90 ],


            enableGridMenu: true,
            fastWatch: true,
            columnDefs: [
                {name: 'trapSeverity', width: 70, visible: true,
                    cellClass: function (grid, row, col, rowRenderIndex, colRenderIndex) {
                        var severity = row.entity.trapSeverity;
                        if (severity === "Info") {
                            return 'flag-info';
                        } else if (severity === "Major") {
                            return 'flag-major';
                        } else if (severity === "Critical") {
                            return 'flag-critical';
                        } else if (severity === "MinorWarn") {
                            return 'flag-minor';
                        }
                    }
                },
                {name: 'trapType', displayName: 'Trap Type', width: 70, visible: true},
                {name: 'parameter1', visible: false, displayName: 'Sub TrapType', minWidth: 70, maxWidth: 200},
                {name: 'nodeName', displayName: 'Node Name', enableCellEdit: true, width: 200},
                {name: 'senderIP', displayName: 'Sender IP', enableCellEdit: true, width: 100},
                {name: 'ticketNo', visible: true, displayName: 'Ticket No', minWidth: 70, maxWidth: 80},
                {name: 'ifDescription', displayName: 'Interface Name', width: 150, visible: false},
                {name: 'peerIp', visible: false, displayName: 'Peer IP', minWidth: 70, maxWidth: 200},
                {name: 'rcvd_Time1', displayName: 'Start Time', sort: {direction: uiGridConstants.DESC}, width: 150},
                {name: 'Status', displayName: 'Status', enableCellEdit: true, width: 80, visible: false},
                {name: 'clear_message', displayName: 'Clear Message', enableCellEdit: true, visible: false, width: 120},
                {name: 'clear_Time_1', displayName: 'End Time', enableCellEdit: true, visible: true, width: 150},
                {name: 'clearUserName', displayName: 'Clear By', enableCellEdit: true, visible: false},
                {name: 'ack_Time_1', displayName: 'Ack. Time', enableCellEdit: true, visible: false},
                {name: 'ackUserName', displayName: 'Ack. By', enableCellEdit: true, visible: false},
                {name: 'nodeType', visible: false, minWidth: 70, maxWidth: 200},
                {name: 'miscTrapDesc', visible: true, minWidth: 70, maxWidth: 700},
                {name: 'trapSource', displayName: 'Source', visible: false},
                {name: 'trapID', visible: false, displayName: 'ID', minWidth: 70, maxWidth: 200},
                {name: 'ifIndex', visible: false, displayName: 'IfIndex', minWidth: 70, maxWidth: 200},
                {name: 'alarmValue', displayName: 'Alarm Value', visible: false, minWidth: 70, maxWidth: 200},
                {name: 'relatedTrapId', visible: false, displayName: 'Related TrapId', minWidth: 70, maxWidth: 200},
                {name: 'parameter2', visible: true, displayName: 'IfAlias', minWidth: 70, maxWidth: 200},
                {name: 'parameter3', visible: false, displayName: 'Parameter 3', minWidth: 70, maxWidth: 200},
                {name: 'parameter4', visible: false, displayName: 'Parameter 4', minWidth: 70, maxWidth: 200},
                {name: 'parameter5', visible: false, displayName: 'Parameter 5', minWidth: 70, maxWidth: 200},
                {name: 'counter', displayName: 'Counter', width: 60, visible: true}

            ],
            onRegisterApi: function (gridApi) {
                $scope.gridApi = gridApi;


                $scope.gridApi.grid.options.multiSelect = true;

                gridApi.selection.on.rowSelectionChanged($scope, function (rows) {
                    $scope.mySelections = gridApi.selection.getSelectedRows();

                    console.log($scope.mySelections);
                });


            }

        };

        $scope.filter = function () {
            $scope.gridApi.grid.refresh();
        };




        $scope.state = {};

        $scope.saveState = function () {
            $scope.state = $scope.gridApi.saveState.save();
        };



        $scope.restoreState = function () {
            $scope.gridApi.saveState.restore($scope, $scope.state);
        };

        Number.prototype.padLeft = function (base, chr) {
            var len = (String(base || 10).length - String(this).length) + 1;
            return len > 0 ? new Array(len).join(chr || '0') + this : this;
        }
        $scope.checkflag = "1";
        $scope.checkboxtick = function () {
            console.log($scope.checkbox);
            if ($scope.checkbox == true) {

                $scope.checkflag = "2";
                $('.timeRange').hide();
            } else {
                $scope.checkflag = "1";
                $('.timeRange').show();
            }
            $scope.checkflag = $scope.checkflag;
        };
        $scope.showTraps = function () {
            counterflag = $scope.changedVal;
            $scope.loading = true;

                console.log("enter into function");
                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!
                var hh = today.getHours();
                var MM = today.getMinutes();
                var ss = today.getSeconds();
                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                if (hh < 10) {
                    hh = '0' + hh
                }
                if (MM < 10) {
                    MM = '0' + MM
                }
                if (ss < 10) {
                    ss = '0' + ss
                }
                $scope.toTime = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
                var today = new Date();
                today.setHours('00');
                today.setMinutes('00');
                today.setSeconds('00');
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!
                var hh = today.getHours();
                var MM = today.getMinutes();
                var ss = today.getSeconds();
                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                if (hh < 10) {
                    hh = '0' + hh
                }
                if (MM < 10) {
                    MM = '0' + MM
                }
                if (ss < 10) {
                    ss = '0' + ss
                }
                $scope.fromTime = yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + MM + ':' + ss;
                $scope.status = "today";
            
            console.log("Checkbox flag" + $scope.checkflag);
            console.log($scope.fromTime);
            console.log($scope.toTime);

            counterflag = $scope.changedVal;
            dbflag = $scope.status;
            $http.post('../Faults', {requestType: '2', nodeName: $scope.nodeNames, trapType: $scope.trapType, startTime: $scope.fromTime, endTime: $scope.toTime, trapDetail: $scope.changedVal, status: $scope.status})
                    .success(function (data) {
                        console.log(data);
                        $scope.gridOptions.data = data;
                        $scope.showGrid = true;
                        $scope.loading = false;
                    });



        };

//        /*$scope.intervalTimer = null;
        $scope.startAutoRefresh = function () {
            $scope.showTraps();

        };

        function getDateTime() {
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            var HH = today.getHours();
            var MM = today.getMinutes();
            var SS = today.getSeconds();

            if (dd < 10) {
                dd = '0' + dd
            }

            if (mm < 10) {
                mm = '0' + mm
            }

            today = mm + '_' + dd + '_' + yyyy + '_' + HH + '_' + MM + '_' + SS;
            return today
        }


        $scope.startRefresh = function () {
            if ($scope.autoRefresh)
            {
                //$scope.showButton = !$scope.showButton;
                $scope.showButton = false;
                $scope.showTraps();

                $scope.startAutoRefresh();
                $scope.gridApi.core.refresh();// added by yo

            } else
            {
                //alert("0");
                $scope.showButton = true;
                $scope.stopAutoRefresh();

            }
        };

        $scope.hideTraps = function () {
            msg = {};
            msg.trapids = [];
            msg.ids = ""
            msg.noOfTrapIds = $scope.mySelections.length;
            for (var i = 0; i < $scope.mySelections.length; i++) {
                msg.trapids.push($scope.mySelections[i].trapID);
                if (i != 0)
                    msg.ids = msg.ids + ",";
                msg.ids = msg.ids + $scope.mySelections[i].trapID;

                msg.trapId = $scope.mySelections[i].trapID;
            }
            console.log(msg.ids);
            $http.post('../filters', {requestType: '18', trapIDs: msg.trapids, trapId: msg.trapId, trapids: msg.ids});

            $scope.startRefresh();
        };

        $scope.genTicket = function () {
            console.log("  ------------ gen Ticket called ------------------------ ");

            var test = [];

            for (var i = 0; i < $scope.mySelections.length; i++) {
                var tickets = {};

                tickets.TrapID = $scope.mySelections[i].trapID;
                tickets.IncidentTitleIN = $scope.mySelections[i].trapType;
                tickets.DescriptionIN = $scope.mySelections[i].trapType;
                tickets.SubEntityTypeIN = $scope.mySelections[i].SenderIP;
                tickets.EntityNameIN = $scope.mySelections[i].NodeName;
                tickets.SeverityIN = $scope.mySelections[i].TrapSeverity;
                tickets.CategoryIN = $scope.mySelections[i].trapType;
                tickets.ReceivedTimeIN = $scope.mySelections[i].rcvd_Time1;

                if ($scope.mySelections[i].trapType == "Interface") {

                    tickets.InterfaceNameIN = $scope.mySelections[i].IfDescription;// LSP name commented, not used
                    tickets.statusIN = $scope.mySelections[i].Status;
                } else if ($scope.mySelections[i].trapType == "Bfd") {

                    tickets.OspfNbrRouterIpIN = $scope.mySelections[i].OSPFNbrRtrIP;
                    tickets.OspfNbrInterfaceIpIN = $scope.mySelections[i].OSPFNbrIfIP;
                    //tickets.statusIN = $scope.mySelections[i].Status;
                } else if ($scope.mySelections[i].trapType == "Isis") {

                    tickets.InterfaceNameIN = $scope.mySelections[i].IfDescription;// LSP name commented, not used
                    tickets.statusIN = $scope.mySelections[i].Status;
                    tickets.stateIN = $scope.mySelections[i].BGPState;
                } else if ($scope.mySelections[i].trapType == "Node") {

                    tickets.statusIN = $scope.mySelections[i].Status;
                }

                tickets.trapType = $scope.mySelections[i].trapType;
                test.push(tickets);
            }

            //ankitesh_function(tickets)
            console.log(test);
            processInterfaceTrapTicket(test);
            $scope.gridApi.selection.clearSelectedRows();
        };

        $scope.acknowledge = function () {

            var ack_msg = prompt("Please enter Acknowledge Message", "Acknowledging trap");// + $scope.gridOptions.currentRow.trapID);
            if (ack_msg != null) {


                var d = new Date,
                        dformat = [(d.getMonth() + 1).padLeft(),
                            d.getDate().padLeft(),
                            d.getFullYear()].join('/') + ' ' +
                        [d.getHours().padLeft(),
                            d.getMinutes().padLeft(),
                            d.getSeconds().padLeft()].join(':');

                //request = {};
                //request.type = 2;
                msg = {};
                msg.time = dformat;
                //msg.username = "VodaTrap_user1";
                msg.username = window.userName;
                msg.requestType = 1;
                msg.message = ack_msg;
                msg.trapids = [];
                msg.noOfTrapIds = $scope.mySelections.length;
                //console.log($scope.mySelections);
                for (var i = 0; i < $scope.mySelections.length; i++) {
                    //may be binarysearch required on $scope.gridOptions.data  
                    //$scope.mySelections[i].TrapSeverity = "Major";
                    $scope.mySelections[i].TrapSeverity = $scope.mySelections[i].TrapSeverity;
                    $scope.mySelections[i].ack_message = msg.message;
                    $scope.mySelections[i].ack_Time_1 = msg.time;
                    $scope.mySelections[i].AckUserName = msg.username;
                    console.log($scope.mySelections[i].trapID);
                    msg.trapids.push($scope.mySelections[i].trapID);
                    msg.trapId = $scope.mySelections[i].trapID;

                }

                //trapId = "26540";
                console.log(msg.trapId);
                //trapIDs,ackFlag,ackUser,ackTime,ackMsg)
                $http.post('../filters', {requestType: '15', trapIDs: msg.trapids, trapId: msg.trapId, ackFlag: "ACK", ackUser: msg.username, ackTime: msg.time, ackMsg: msg.message})

                //MyService.sendRequest(msg);
            }
            $scope.gridApi.selection.clearSelectedRows();


        };


        $scope.clear = function () {


            var clear_msg = prompt("Please enter Clear Message", "Clearing trap"); //+ $scope.gridOptions.currentRow.trapID);
            if (clear_msg != null) {


                var d = new Date,
                        dformat = [(d.getMonth() + 1).padLeft(),
                            d.getDate().padLeft(),
                            d.getFullYear()].join('/') + ' ' +
                        [d.getHours().padLeft(),
                            d.getMinutes().padLeft(),
                            d.getSeconds().padLeft()].join(':');


                msg = {};
                msg.time = dformat;
                //msg.username = "VodaTrap_user1";
                msg.username = window.userName;
                msg.requestType = 2;
                msg.message = clear_msg;
                msg.trapids = [];
                msg.noOfTrapIds = $scope.mySelections.length;
                console.log($scope.mySelections);
                for (var i = 0; i < $scope.mySelections.length; i++) {
                    $scope.mySelections[i].TrapSeverity = "Info";
                    $scope.mySelections[i].clear_message = msg.message;
                    $scope.mySelections[i].clear_Time_1 = msg.time;
                    $scope.mySelections[i].ClearUserName = msg.username;
                    msg.trapids.push($scope.mySelections[i].trapID);
                    msg.trapId = $scope.mySelections[i].trapID;
                }
                console.log(msg.trapids);

                $http.post('../filters', {requestType: '15', trapIDs: msg.trapids, trapId: msg.trapId, ackFlag: "CLEAR", ackUser: msg.username, ackTime: msg.time, ackMsg: msg.message})


                //MyService.sendRequest(msg);
            }
            $scope.gridApi.selection.clearSelectedRows();

        };


    }])


TrapHistoric.directive('ngRightClick', function ($parse) {
    return function (scope, element, attrs) {
        var fn = $parse(attrs.ngRightClick);
        element.bind('contextmenu', function (event) {
            scope.$apply(function () {
                event.preventDefault();
                fn(scope, {$event: event});
            });
        });
    };
});



TrapHistoric.controller('ContextController',
        ['$scope', '$modal', '$modalInstance', '$filter', '$interval', '$http', 'uiGridConstants', 'selectedRow',
            function ($scope, $modal, $modalInstance, $filter, $interval, $http, uiGridConstants, selectedRow) {

                $scope.selectedRow = selectedRow;
                $scope.showRelGrid = false;
                $scope.gridOptions1 = {
                    columnDefs: [
                        {name: 'trapType', displayName: 'Type', minWidth: 70, maxWidth: 200},
                        {name: 'SenderIP', displayName: 'Sender', enableCellEdit: true},
                        {name: 'NodeName', enableCellEdit: true, width: 200},
                        {name: 'rcvd_Time1', displayName: 'Generation Time', sort: {direction: uiGridConstants.DESC}, width: 150},
                                //{name: 'Status', displayName: 'Status', enableCellEdit: true, width: 80},
                                //{name: 'counterofTraps', displayName: 'Counter', width: 80},
                                //{name: 'clear_message', displayName: 'Clear Message', enableCellEdit: true, visible: true},
                    ],
                    onRegisterApi: function (gridApi) {
                        $scope.gridApi = gridApi;
                    }

                };

                $scope.rel_details = function () {

                    $scope.nodeName_rel = selectedRow.NodeName;
                    $scope.fromTime_rel = "2015-11-11";
                    $scope.toTime_rel = "2016-12-21";

                    $http.post('../filters', {requestType: '10', nodeName: $scope.nodeName_rel, trapType: 'All', startTime: $scope.fromTime_rel, endTime: $scope.toTime_rel, autoRefresh: 'true'})
                            .success(function (data) {
                                console.log(data);
                                $scope.gridOptions1.data = data;
                                $scope.showRelGrid = true;
                                //grid.appScope.$parent = data;

                            });
                    //$scope.selectedRow = null;
                    //$modalInstance.close();
                };


                $scope.ok = function () {
                    $scope.selectedRow = null;
                    $modalInstance.close();
                };

                $scope.cancel = function () {
                    $scope.selectedRow = null;
                    $modalInstance.dismiss('cancel');
                };
            }
        ]);

TrapHistoric.controller('InfoController',
        ['$scope', '$modal', '$modalInstance', '$filter', '$interval', 'selectedRow', 'histFlag',
            function ($scope, $modal, $modalInstance, $filter, $interval, selectedRow, histFlag) {

                $scope.selectedRow = selectedRow;
                $scope.histFlag = histFlag;

                $scope.ok = function () {
                    $scope.selectedRow = null;
                    $modalInstance.close();
                };

                $scope.cancel = function () {
                    $scope.selectedRow = null;
                    $modalInstance.dismiss('cancel');
                };

                $scope.somefunction = function () {
                    console.log("somefunction called");
                    var obj = {};

                    console.log($scope.selectedRow.senderIP);

                    var senderip = $scope.selectedRow.senderIP;
                    var traptype = $scope.selectedRow.trapType;
                    var startTime = $scope.fromTime;
                    var endTime = $scope.toTime;
                    console.log(counterflag);
                    console.log(counterToTime);
                    console.log(counterFromTime);

                    $scope.ok()

                    parent.parent.sayHello(counterflag, traptype, senderip, counterFromTime, counterToTime, dbflag);
                };
            }
        ]);

