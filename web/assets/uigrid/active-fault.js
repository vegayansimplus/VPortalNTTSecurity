/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var TrapActive = angular.module('TrapActive', ['ngAnimate', 'ui.grid', 'ui.grid.saveState', 'ui.grid.selection', 'ui.grid.cellNav', 'ui.grid.resizeColumns', 'ui.grid.moveColumns', 'ui.grid.pinning', 'ui.grid.exporter', 'ui.grid.grouping', 'ui.bootstrap'], function ($httpProvider) {
    $httpProvider.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=utf-8';
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

    $httpProvider.defaults.transformRequest = [function (data) {
            return angular.isObject(data) && String(data) !== '[object File]' ? param(data) : data;
        }];
});





TrapActive.controller('MainCtrl', ['$scope', '$http', '$interval', '$modal', 'uiGridConstants', function ($scope, $http, $interval, $modal, uiGridConstants) {
        $scope.gridOptions1 = {};
        $scope.mySelections = [];
        $scope.showGrid = false;
        $scope.showButton = true;
        $scope.nodeNames = "ALL";
        $scope.trapTypeValuesSelected = "";
        $scope.trapType = "ALL";
        $scope.selectedRow = null;
        $scope.mySelections = [];
        var d = new Date();
        $scope.toTime = d.toISOString().slice(0, 19).replace('T', ' ');
        d.setDate(d.getDate() - 1);
        $scope.fromTime = d.toISOString().slice(0, 19).replace('T', ' ');

        $scope.filterSeverity = function (severity) {
            if ($scope.severity == "") {
                $scope.severity = severity;
            } else if ($scope.severity == severity) {
                $scope.severity = "";
            } else {
                $scope.severity = severity;
            }
            $.each($scope.gridApi.grid.columns, function (index, column) {
                switch (column.field) {
                    case 'trapSeverity':
                        column.filters[0].term = $scope.severity;
                        break;
                }
            });
        };


        function countAll() {
            for (var i = 0; i < $scope.gridOptions.data.length; i++) {
                if ($scope.gridOptions.data[i].trapSeverity == "Major")
                    $scope.majorCount++;
                else if ($scope.gridOptions.data[i].trapSeverity == "Critical")
                    $scope.criticalCount++;
                else if ($scope.gridOptions.data[i].trapSeverity == "Minor")
                    $scope.minorCount++;
            }
        }

        $scope.filterFunction = function (renderableRows) {
            var validValues = [];
            $('.trapFilterChk:checked').each(function () {
                validValues.push($(this).val());
            });
            renderableRows.forEach(function (row) {
                var match = false;
                if (validValues.indexOf(row.trapType) > -1) {
                    match = true;
                }
                if (!match) {
                    row.visible = false;
                }
            });
            return renderableRows;
        };




        $scope.autoRefresh = true;
        $scope.myAppScopeProvider = {

            showInfo: function (row) {

                var modalInstance = $modal.open({
                    controller: 'InfoController',
                    templateUrl: 'ngTemplate/HistPopUp.html',
                    resolve: {
                        selectedRow: function () {
                            return row.entity;
                        },
                        showDetails: function () {
                            return "Shree";
                        }


                    }
                });

                modalInstance.result.then(function (selectedItem) {
                }, function () {
                });
            }
        }
        $scope.gridOptions = {
            showGridFooter: false,
            showColumnFooter: false,
            saveFocus: true,
            saveScroll: true,
            enableRowSelection: true,
            modifierKeysToMultiSelect: false,

            saveGroupingExpandedStates: true,
            enableFiltering: true,
            rowHeight: 21,
            appScopeProvider: $scope.myAppScopeProvider,
            rowTemplate: '<div ng-dblclick=\"grid.appScope.showInfo(row)\"  ng-right-click="grid.appScope.showMenu(row)" ng-class="{\'flag-acknowledge\':row.entity.ack_Time_1!=\'\'&&row.entity.clear_Time_1==\'\',\'flag-clear\':row.entity.clear_Time_1!=\'\',\'flag-info\':row.entity.trapSeverity==\'Info\',  \'flag-major\':row.entity.trapSeverity==\'Major\',  \'flag-critical\':row.entity.trapSeverity==\'Critical\'&&row.entity.ack_Time_1==\'\',\'flag-minor\':row.entity.trapSeverity==\'MinorWarn\', }"> <div ng-repeat="col in colContainer.renderedColumns track by col.colDef.name"  class="ui-grid-cell" context-menu data-target="myMenu"  context-menu-margin-bottom="10" ui-grid-cell></div></div>',
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
            exporterPdfOrientation: 'landscape',
            exporterPdfPageSize: 'TABLOID',
            exporterPdfMaxGridWidth: 1000,
            enableGridMenu: true,
            fastWatch: true,
            columnDefs: [
                {name: 'nodeType', visible: true, minWidth: 50, maxWidth: 10},
                {name: 'trapSeverity', width: 80, visible: true,
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
                {name: 'trapType', displayName: 'Trap Type', width: 80, visible: true},
                {name: 'parameter1', visible: false, displayName: 'Sub Type', minWidth: 70, maxWidth: 200},
                {name: 'nodeName', displayName: 'Node Name', enableCellEdit: true, width: 200},
                {name: 'senderIP', displayName: 'Sender IP', enableCellEdit: true, width: 120},
                {name: 'ifDescription', displayName: 'Interface Name', width: 100, visible: true},
                {name: 'peerIp', visible: false, displayName: 'Peer IP', minWidth: 70, maxWidth: 200},
                {name: 'rcvd_Time1', displayName: 'Time', sort: {direction: uiGridConstants.DESC}, width: 130},
                {name: 'ifDescription2', displayName: 'Parent Interface', width: 150, visible: false},
                {name: 'Status', displayName: 'Status', enableCellEdit: true, width: 80, visible: false},
                {name: 'clear_message', displayName: 'Clear Message', enableCellEdit: true, visible: false, width: 120},
                {name: 'clear_Time_1', displayName: 'Clear Time', enableCellEdit: true, visible: false, width: 150},
                {name: 'clearUserName', displayName: 'Clear By', enableCellEdit: true, visible: false},
                {name: 'ack_message', displayName: 'Ack. Msg', enableCellEdit: true, visible: false},
                {name: 'ack_Time_1', displayName: 'Ack. Time', enableCellEdit: true, visible: false},
                {name: 'ackUserName', displayName: 'Ack. By', enableCellEdit: true, visible: false},
                {name: 'ticketNo', visible: true, displayName: 'Ticket No', minWidth: 70, maxWidth: 80},
                {name: 'miscTrapDesc', visible: true, minWidth: 70, maxWidth: 800},
                {name: 'trapSource', displayName: 'Source', visible: false},
                {name: 'trapID', visible: false, displayName: 'ID', minWidth: 70, maxWidth: 200},
                {name: 'ifIndex', visible: false, displayName: 'IfIndex', minWidth: 70, maxWidth: 200},
                {name: 'alarmValue', displayName: 'Alarm Value', visible: false, minWidth: 70, maxWidth: 200},
                {name: 'relatedTrapId', visible: false, displayName: 'Related TrapId', minWidth: 70, maxWidth: 200},
                {name: 'parameter2', visible: false, displayName: 'Parameter 2', minWidth: 70, maxWidth: 200},
                {name: 'parameter3', visible: false, displayName: 'Parameter 3', minWidth: 70, maxWidth: 200},
                {name: 'parameter4', visible: false, displayName: 'Parameter 4', minWidth: 70, maxWidth: 200},
                {name: 'parameter5', visible: false, displayName: 'Parameter 5', minWidth: 70, maxWidth: 200},
            ],
            onRegisterApi: function (gridApi) {
                $scope.gridApi = gridApi;
                gridApi.selection.on.rowSelectionChanged($scope, function (row) {
                    $scope.selectedRow = row.isSelected ? row.entity : null;
                    console.log('Selected row:', $scope.selectedRow);
                });
            }

        };
//        $scope.getSelectedRows = function () {
//            console.log($scope.gridApi);
//            console.log($scope.gridApi.selection);
//            $scope.mySelections = $scope.gridApi.selection.getSelectedGridRows();
//            for (let i = 0; i < $scope.mySelections.length; i++) {
//                $scope.mySelections[i] = $scope.mySelections[i].entity;
//            }
//            console.log("$scope.mySelections");
//            console.log($scope.mySelections);
//            // Do something with the selected rows
//        };
//        function getRowId(row) {
//            return row.id;
//        }
//        $scope.toggleFilterRow = function () {
//            $scope.gridOptions.enableFiltering = !$scope.gridOptions.enableFiltering;
//            $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.COLUMN);
//        };
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


        $scope.showTraps = function () {
//            console.log("insert into function")
            if ($scope.trapTypeValuesSelected == "") {
                $scope.trapTypeValuesSelected = "ALL";
            }
            $http.post('../Faults', {requestType: '1', trapType: $scope.trapTypeValuesSelected})
                    .success(function (data) {
//                        console.log(data);
                        $scope.gridOptions.data = data;
                        $scope.majorCount = 0;
                        $scope.minorCount = 0;
                        $scope.criticalCount = 0;
                        countAll();
                        $scope.showGrid = true;
                        $scope.gridApi.core.refresh();
                        $scope.gridOptions.data = data;
                        $scope.showGrid = true;
                        $scope.loading = false;
                    });

        };

        $scope.intervalTimer = null;
        $scope.scopeFlag = true;
        $scope.startAutoRefresh = function () {
             $scope.showTraps();
//            $scope.scopeInterval;
//            if ($scope.scopeFlag == true) {
//                $scope.scopeInterval = 1;
//            } else {
//                $scope.scopeInterval = 60;
//            }
//            $scope.intervalTimer = $interval(function () {
//
//                if ($scope.scopeFlag == true) {
//                    $scope.scopeInterval = 1;
//                } else {
//                    $scope.scopeInterval = 60;
//                }
//                $scope.showTraps();
//                $scope.scopeFlag = false;
//            }, 1000 * $scope.scopeInterval);
        };


        $scope.stopAutoRefresh = function () {

            if (angular.isDefined($scope.intervalTimer)) {
                $interval.cancel($scope.intervalTimer);
            }
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
            $http.post('../Faults', {requestType: '3', trapIDs: msg.trapids, trapId: msg.trapId, trapids: msg.ids});
            $scope.showTraps();
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
                msg = {};
                msg.time = dformat;
                msg.username = window.userName;
                msg.requestType = 1;
                msg.message = ack_msg;
                msg.trapids = [];
                msg.noOfTrapIds = $scope.mySelections.length;
                for (var i = 0; i < $scope.mySelections.length; i++) {
                    $scope.mySelections[i].trapSeverity = $scope.mySelections[i].trapSeverity;
                    $scope.mySelections[i].ack_message = msg.message;
                    $scope.mySelections[i].ack_Time_1 = msg.time;
                    $scope.mySelections[i].AckUserName = msg.username;
                    msg.trapids.push($scope.mySelections[i].trapID);
                    msg.trapId = $scope.mySelections[i].trapID;

                }
                $http.post('../Faults', {requestType: '4', trapIDs: msg.trapids, trapId: msg.trapId, ackFlag: "ACK", ackUser: msg.username, ackTime: msg.time, ackMsg: msg.message})
            }
            $scope.gridApi.selection.clearSelectedRows();


        };
        $scope.clear = function () {
            if ($scope.selectedRow) {
                var clear_msg = prompt("Please enter Clear Message", "Manual Clearing Trap");
                if (clear_msg != null) {
                    const now = new Date();
                    const year = now.getFullYear();
                    const month = String(now.getMonth() + 1).padStart(2, '0');
                    const day = String(now.getDate()).padStart(2, '0');
                    const hours = String(now.getHours()).padStart(2, '0');
                    const minutes = String(now.getMinutes()).padStart(2, '0');
                    const seconds = String(now.getSeconds()).padStart(2, '0');
                    const formattedDateTime = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
                    console.log(formattedDateTime);
                    console.log("selectedRow.generated_Time:" + $scope.selectedRow.generated_Time);
                    $http.post('../Faults', {requestType: '4', trapId: $scope.selectedRow.trapID, ackFlag: "CLEAR", ackUser: window.userName, ackTime: formattedDateTime, ackMsg: clear_msg,trapType: $scope.selectedRow.trapType})
                } else {
                    console.log("enter into empty message");
                }
            } else {
                console.log('No row selected.');
            }
        };

        $scope.opticalTrail = function () {
        };
        $scope.GetFilterdTraps = function () {
            var validValues = [];
            $('.trapFilterChk:checked').each(function () {
                validValues.push($(this).val());
            });
            $scope.trapTypeValuesSelected = validValues.toString();
            $scope.showTraps();
        }

        $scope.showFilters = function () {
            $("#myModal").modal("show")
        }


    }])




TrapActive.controller('InfoController',
        ['$scope', '$modal', '$modalInstance', '$filter', '$interval', 'selectedRow',
            function ($scope, $modal, $modalInstance, $filter, $interval, selectedRow) {

                $scope.selectedRow = selectedRow;

                $scope.ok = function () {
                    $scope.selectedRow = null;
                    $modalInstance.close();
                };

                $scope.cancel = function () {
                    $scope.selectedRow = null;
                    $modalInstance.dismiss('cancel');
                };

                $scope.somefunction = function () {
                    var obj = {};
                    obj['nodename'] = $scope.selectedRow.NodeName;
                    obj['senderip'] = $scope.selectedRow.SenderIP;
                    obj['traptype'] = $scope.selectedRow.trapType;
                    obj['status'] = $scope.selectedRow.Status;
                    obj['trapSeverity'] = $scope.selectedRow.trapSeverity;
                    obj['rcvdtime'] = $scope.selectedRow.rcvd_Time1;
                    obj['ifindex'] = $scope.selectedRow.IfIndex;
                    obj['lspname'] = $scope.selectedRow.LspName;
                    obj['ospfnbrrtrip'] = $scope.selectedRow.OSPFNbrRtrIP;
                    obj['ospfnbrifip'] = $scope.selectedRow.OSPFNbrIfIP;
                    obj['bgpstate'] = $scope.selectedRow.BGPState;
                    obj['pathname'] = $scope.selectedRow.PathName;
                    obj['adminstatus'] = $scope.selectedRow.AdminStatus;
                    obj['operstatus'] = $scope.selectedRow.OperStatus;
                    obj['ospfifip'] = $scope.selectedRow.OSPFIfIP;
                    obj['rttmontargetip'] = $scope.selectedRow.RttMonTargetIP;
                    obj['rttmonresult'] = $scope.selectedRow.RttMonResult;
                    obj['counter'] = $scope.selectedRow.counterofTraps;
                    var type = "ACTIVE";
                    parent.parent.sayHello(obj, type);
                };
                $scope.opTrail = function () {
                    var nodeName = $scope.selectedRow.NodeName;
                    var interfaceName = $scope.selectedRow.LspName;

                    parent.parent.openOpticalTrail(nodeName, interfaceName);

                };
            }
        ]);

