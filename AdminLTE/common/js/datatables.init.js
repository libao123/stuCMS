var tablePackage = {
	process: false,
	setProcess: function (type) {
		tablePackage.process = type;
	},
	property: {
		version: "v1.0",
		name: "name",
		tableId: "dataTable1",
		checkAllId: "checkAll",
		buttonId: "buttonId",
		formId: "formId",
		corporateFormId: "corporateFormId",
		returnStatus: "SUCCESS",
		returnTitle: "操作成功",
		statusTitle: "请选择一条数据！",
		idFailure: "获取id失败",
		prompt: "提示",
		pleaseConfirm: "请确认！",
		wantToDelete: "您确定要删除吗?",
		sexMan: "男",
		sexWoman: "女",
		isTest: "是",
		noTest: "否",
		banned: "禁用",
		enable: "启用",
		searchs: "",
		dosearch:null,
	},
	ajax: function ($d) {
		var elo = this;
		if ($d.hasOwnProperty('url') && $d['url'] != undefined) {
			if ($d['method'] == undefined || $d['method'] == null) {
				$d['method'] = "GET";
			}
			if ($d['type'] == "client") {
				elo.changeGridInit({
					serverSide: false,
				});
				var _ajax = {
					url: $d['url'],//请求后台路径
					type: $d['method'],
					data: elo.search,
					error: function (jqXHR, textStatus, errorMsg) {
						easyAlert.timeShow({
							'type': 'danger',
							'content': '请求失败',
							'duration': 3,
						});
					}
				}
				elo.gridInit.ajax = _ajax;
			} else if ($d['type'] == "server") {
				elo.changeGridInit({
					serverSide: true,
				});
				var _ajax = {
					url: $d['url'],//请求后台路径
					type: $d['method'],
					cache: false,
					// data: 	elo.search,
					error: function (jqXHR, textStatus, errorMsg) {
						easyAlert.timeShow({
							'type': 'danger',
							'content': '请求失败',
							'duration': 3,
						});
					}
				}
				elo.gridInit.ajax = _ajax;
			}
			return true;
		} else {
			return false;
		}
	},
	gridInit: {
		searching: false,//搜索框，默认是开启
		lengthChange: false,//是否允许用户改变表格每页显示的记录数，默认是开启
		paging: true,
		serverSide: false,
		search: false,
		processing: true,
		ordering: false,
		responsive: true,
		// scrollCollapse:true,
		// scrollY:500,
		// scrollX:"100%",
		// scrollXInner:"100%",
		scrollCollapse: true,
		jQueryUI: false,
		autoWidth: false,
		autoSearch: false,
		buttons: "",
		// "ordering": true,
		// "autoWidth": false,
		// "ordering":  false,
		// "responsive": true,
	},
	requestUrl: {
		queryList: "",
	},
	search: {
		uuid: "",
	},
	buildSearch: function ($ctrl) {
		var elo = this;
		var prop = elo.property;
		var searchId = $ctrl['id'] || 'searchBox';
		var boxId = $ctrl['boxId'] || 'searchBox';
		var tabId = $ctrl['tabId'] || '';
		var tabMsg = $ctrl['tabMsg'] || '查询';
		var searchBtn = $ctrl['searchBtn'] || '.btn-search';
		var searchCallBack = $ctrl['searchCallBack'] || function (a) { };
		var searchLink = $ctrl['searchLink'] || '/search';
		var $search = $("#"+searchId);
		elo.changeGridInit({
			searching: true,
			search: true,
		});
		if ($ctrl['cols'] != undefined && $ctrl['cols']) {
			var str = '<div class="search-box">' +
				'<label class="form-label" style="margin:0 6px 5px 6px; font-size:14px;">查询：</label>';////style="margin-right:6px;"
			// var str = '<div class="search-box">';
			var buildEach = function (d) {
				var s = '';
				s += '<div class="form-group">';
				// s += '<label class="control-sidebar-subheading">'+d['pre']+'</label>';
				if (d['type'] == "select") {
					s += '<select class="form-control" data-column="' + d['col'] + '" name="' + d['data'] + '" id="search-' + d['data'] + '" ddl_name="' + d['ddl_name'] +'" show_type="t" pre="' + d['pre'] + '" d_value="' + d['d_value'] + '" style="margin-right:6px;">';
					if (d['options']) {
						s += '<option value=""></option>';
						for (var i = 0; i < d['options'].length; i++) {
							var _e = d['options'][i];
							s += '<option value="' + _e['value'] + '">' + _e['text'] + '</option>';
						}
					}
					s += '</select>';
				} else if (d['type'] == "timeSingle") {
					s += '<input type="text" name="' + d['data'] + '" style="margin-right:6px;" data-column="' + d['col'] + '" class="form-control timeSingle" placeholder="' + d['pre'] + '"/>';
				} else if (d['type'] == "timeRange") {
					s += '<input type="text" name="' + d['data'] + '" style="margin-right:6px;" data-column="' + d['col'] + '" class="form-control timeRange" placeholder="' + d['pre'] + '"/>';
				} else {
					s += '<input type="text" name="' + d['data'] + '" style="margin-right:6px;" data-column="' + d['col'] + '" class="form-control" placeholder="' + d['pre'] + '"/>';
				}

				s += '</div>';
				return s;
			}
			for (var i = 0; i < $ctrl['cols'].length; i++) {
				var each = $ctrl['cols'][i];
				str += buildEach(each);
			}
			str += '<div class="form-group">' +
				'<button type="button" class="btn btn-primary btn-flat btn-search" style="margin-right:6px;">搜索</button>' +
				'<button type="button" class="btn btn-default btn-flat btn-clearData">清除</button></div>';
			str += '</div>';

			var bEach = function(){
				var _s = "";
				for (var i = 0; i < $ctrl['cols'].length; i++) {
					var each = $ctrl['cols'][i];
					_s += buildEach(each);
				}
				_s += '<div class="form-group"><div class="col-md-12">' +
				'<button type="button" class="btn btn-primary btn-flat btn-search" style="margin-right:6px;">搜索</button>' +
				'<button type="button" class="btn btn-default btn-flat btn-clearData">清除</button></div></div>';
				return _s;
			}
			var buildEach = function (d) {
				//console.log(d);
				var s = '<div class="col-md-4 form-group">'
				//start detail
				s += '<div class="">';
				// s += '<label class="control-sidebar-subheading">'+d['pre']+'</label>';
				s += '<label>'+d['pre']+'</label>';
				if (d['type'] == "select") {
					s += '<select class="form-control" data-column="' + d['col'] + '" name="' + d['data'] + '" id="search-' + d['data'] + '" ddl_name="' + d['ddl_name'] +'" d_value="' + d['d_value'] + '" show_type="t" pre="' + d['pre'] + '" style="margin-right:6px;">';
					if (d['options']) {
						s += '<option value=""></option>';
						for (var i = 0; i < d['options'].length; i++) {
							var _e = d['options'][i];
							s += '<option value="' + _e['value'] + '">' + _e['text'] + '</option>';
						}
					}
					s += '</select>';
				} else if (d['type'] == "timeSingle") {
					s += '<input type="text" name="' + d['data'] + '" id="search-' + d['data'] + '" style="margin-right:6px;" data-column="' + d['col'] + '" class="form-control timeSingle" placeholder="' + d['pre'] + '"/>';
				} else if (d['type'] == "timeRange") {
					s += '<input type="text" name="' + d['data'] + '" id="search-' + d['data'] + '" style="margin-right:6px;" data-column="' + d['col'] + '" class="form-control timeRange" placeholder="' + d['pre'] + '"/>';
				} else {
					s += '<input type="text" name="' + d['data'] + '" id="search-' + d['data'] + '" style="margin-right:6px;" data-column="' + d['col'] + '" class="form-control" placeholder="' + d['pre'] + '"/>';
				}

				s += '</div>';
				//end
            	s += '</div>';

				return s;
			}
			var buildBox = function(){
var s = '<div class="box box-default" id="'+boxId+'">\
<div class="box-header with-border"><h3 class="box-title">'+tabMsg+'：</h3>\
<div class="box-tools pull-right">\
<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>\
</div>\
</div>\
<div class="box-body">\
<div class="row">\
'+bEach()+'\
</div>\
</div>\
</div>';
      			return s;
			}

			// console.log(str);
			prop.searchs = str;
			prop.boxId = boxId;
			var a  = $("#" + elo.property.tableId).parent();
			a.before(buildBox());
			/* new */
			var search = function (btn, elo) {
				//console.log(elo);
				//console.log("search");
				var grid = elo.table.grid;
				var searchVal = {};
				//prop.tableId
				$("#" + boxId).find("[data-column]").each(function () {
					var _t = $(this);
					//console.log(_t);
					if (_t.attr('name') != undefined) {
						searchVal[_t.attr('name')] = _t.val();
					}
				});
				console.log(searchVal);
				elo.table.grid.settings()[0].ajax.data = searchVal;
				elo.table.grid.ajax.reload();
			}
			prop.dosearch = search;
			$("#" + boxId).on('click', searchBtn, function () {
			 	//按钮搜索方法
				console.log("click");
			 	search(this, elo);
			});
			$("#" + boxId).find("select").each(function () {
						//console.log($(this));
						if ($(this).attr("ddl_name") && $(this).attr("ddl_name") != "undefined")
                        {
							DropDownUtils.initDropDown($(this).attr("id"),$(this).attr("pre"));
                        }
			});

			$("#"+boxId).on("click", ".btn-clearData", function(){
			 	var _ts = $(this);
			 	// var $searchBox = $(".search-box");
			 	var $searchBox = $("#"+boxId);
			 	//console.log($(this));
			 	$searchBox.find("input, select, textarea").val("");
			 	try {
			 		$searchBox.find("input[type=checkbox]").iCheck('uncheck');
			 	} catch (e) {
			 		$searchBox.find("input[type=checkbox]").prop("checked", false);
			 	}
			});
		}
	},
	status: [
		{ "searchable": false, "orderable": false, "targets": 0 },//第一行不进行排序和搜索
		// {"targets": [12], "visible": false},    //设置第13列隐藏/显示
		// {"width": "10%", "targets": [1]},  //设置第2列宽度
		// {
		// 		对第7列内容进行替换处理
		// 		targets: 6,
		// 		render: function (data, type, row, meta) {
		// 				if (data == "1") {
		// 						return employee.table.sexMan;
		// 				}
		// 				if (data == "0") {
		// 						return employee.table.sexWoman;
		// 				}
		// 		}
		// },
		{ defaultContent: '', targets: ['_all'] } //所有列设置默认值为空字符串
	],
	changeProperty: function (r) {
		var elo = this;
		var pty = elo.property;
		for (var each in r) {
			if (r.hasOwnProperty(each)) {
				if (each != "tableConfig") {
					//console.log(each);
					pty[each] = r[each];
				} else {
					elo.changeGridInit(r[each]);
				}
			}
		}
	},
	changeGridInit: function (d) {
		//console.log(d);
		var elo = this;
		var grid = elo.gridInit;
		for (var each in d) {
			if (d.hasOwnProperty(each)) {
				grid[each] = d[each];
			}
		}
	},
	filed: [
		{
			"data": "extn",
			"createdCell": function (nTd, sData, oData, iRow, iCol) {
				$(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
			}
		},
		{ "data": "name" },
		{ "data": "position" },
		{ "data": "salary" },
		{ "data": "start_date" },
		{ "data": "office" },
		{ "data": "extn" }
	],
	data: function (dd) {
		var elo = this;
		var returnData = [];
		for (var i = 0; i < dd.length; i++) {
			var _d = dd[i];
			var f = true;
			// console.log(_d);
			for (var j = 0; j < elo.filed.length; j++) {
				var _e = elo.filed[j];
				//console.log(_e);
				if (_e != undefined && _d.hasOwnProperty(_e['data'])) {
				} else {
					f = false;
				}
			}
			if (f) {
				returnData.push(_d);
			}
		}
		//console.log(returnData);
		if (returnData.length > 0) {
			elo.gridInit.data = returnData;
		}
		return returnData;
	},
	createdCell: function (nTd, sData, oData, iRow, iCol) {
		$(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
	},
	buttons: function (btnData, searchData) {
		var elo = this;
		//<div class="box-tools">
		var btnStr = '<div class="box-tools"><div class="input-group input-group-sm">' + '<div class="input-group-btn">';
		// if (searchData != undefined) {
		// 	console.log(searchData);
		// 	btnStr += '<button type="button" class="btn btn-success btn-xs btn-search" style="margin-left: 6px;" data-toggle="control-sidebar" data-id="'+searchData['tabId']+'">搜索</button>';
		// }
		for (var i = 0; i < btnData.length; i++) {
			//btnData[i]
			var _btn = btnData[i];
			var _dType = typeof _btn;
			//console.log(_dType);
			if (_dType != "object") {
				switch (_btn) {
					case 'add':
						btnStr += '<button type="button" class="btn btn-primary btn-xs btn-add" style="margin-left: 6px;">新增</button>';
						break;
					case 'edit':
						btnStr += '<button type="button" class="btn btn-primary btn-xs btn-edit" style="margin-left: 6px;">编辑</button>';
						break;
					case 'enter':
						btnStr += '<button id="dataEnter" style="margin-left: 6px;" type="button" class="btn btn-primary btn-xs btn-enter">导入</button>';
						break;
					case 'del':
						btnStr += '<button style="margin-left: 6px;" type="button" class="btn btn-warning btn-xs btn-del">删除</button>';
						break;
					case 'reload':
						btnStr += '<button style="margin-left: 6px;" type="button" class="btn btn-default btn-xs btn-reload">刷新</button>';
						break;
					// case 'search':
					// 	btnStr += '<button style="margin-left: 6px;" type="button" class="btn btn-warning btn-xs btn-del">搜索</button>';
					// 	break;
					default:

						break;
				}
			} else {
				if (_btn.type && _btn.type == "enter") {
					btnStr += '<button style="margin-left: 6px;" type="button" class="btn btn-primary btn-xs btn-enter" data-action="' + _btn.action + '" data-modal="' + _btn.modal + '">' + _btn.title + '</button>';
				} else if(_btn.type && _btn.type == "userDefined") {
					var _attr = "";
					if(_btn.attr != undefined){
						for (var e in _btn.attr) {
							if(_btn.attr[e] != ''){
								_attr += e+"='"+_btn.attr[e]+"' ";
							}
						}
					}
					if(_btn.action != undefined){
						var $act = ' data-action="'+_btn.action+'"';
					}else{
						var $act = '';
					}
					if(_btn.id != undefined){
						var $id = ' id='+_btn.id;
					}else{
						var $id = '';
					}
					if (_btn.className != undefined) {
						var $css = _btn.className;
					}else {
						var $css = "btn-primary";
					}
					//console.log(_attr);
					btnStr += '<button style="margin-left: 6px;" type="button" class="btn  '+$css+' btn-xs btn-userDefined" '+_attr+$id+$act+'>'+_btn.title+'</button>';
				} else {
				}
			}
		}

		btnStr += '</div>' + '</div>' + '</div>';
		//+'</div>'
		elo.gridInit.buttons = btnStr;
		return btnStr;
	},
	table: {
		"grid": "",
		"statusTitle": "请选择一条数据！",
	},
	init: function () {
		var elo = this;
		// console.log(elo);
		// console.log(elo.property);
		var dataConfig = elo.gridInit;
		dataConfig["columns"] = elo.filed;//字段
		dataConfig["columnDefs"] = elo.status;//列表状态
		dataConfig['language'] = {
			"sProcessing": "处理中...",
			"sLengthMenu": "显示 _MENU_ 项结果",
			"sZeroRecords": "没有匹配结果",
			"sInfo": " 共 _TOTAL_ 项",//"显示第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项",
			"sInfoEmpty": " 共 0 项",//"显示第 0 至 0 项结果，共 0 项",
			"sInfoFiltered": "(由 _MAX_ 项结果过滤)",
			"sInfoPostFix": "",
			"sSearch": "搜索:",
			"sUrl": "",
			"sEmptyTable": "未搜索到数据",
			"sLoadingRecords": "载入中...",
			"sInfoThousands": ",",
			"oPaginate": {
				"sFirst": "首页",
				"sPrevious": "上页",
				"sNext": "下页",
				"sLast": "末页"
			},
			"oAria": {
				"sSortAscending": ": 以升序排列此列",
				"sSortDescending": ": 以降序排列此列"
			}
		};
		dataConfig['dom'] = "<'#" + elo.property.buttonId + ".box-header'r><'box-body't<''<'col-sm-3'i><'col-sm-3'l><'col-sm-6'p>>>";
		//datatable 补充方法
		dataConfig['initComplete'] = function () {
			// var btnStr = elo.buttons();
			if (elo.property.tableTitle)
				$("#" + elo.property.buttonId).append('<h3 class="box-title">' + elo.property.tableTitle + '</h3>');
			// console.log(elo.gridInit.buttons);
			$("#" + elo.property.buttonId).append(elo.gridInit.buttons);
			//input-group input-group-sm
//			var sIn = elo.property.searchs;
//			$("#" + elo.property.tableId).parent().prepend(sIn);
			$("#dataTable1_length").css({ 'margin-top': '4px', });
			setTimeout(function(){
				elo.property.dosearch(null, elo);
			}, 1000);
			//$("#" + elo.property.boxId).find(".btn-search").trigger("click");
			//elo.property.dosearch(null, elo);
			if ($(".timeSingle").length > 0) {
				var dateConfig = {
					'type': 'single',//类型，range或者single或者default
					'pluginConfig': {},//时间样式配置
					'dateId': '.timeSingle',//选择的位置
				}
				datePackage.init(dateConfig);
			}
			if ($(".timeRange").length > 0) {
				var dateConfig = {
					'type': 'range',//类型，range或者single或者default
					'pluginConfig': {},//时间样式配置
					'dateId': '.timeRange',//选择的位置
				}
				datePackage.init(dateConfig);
			}
			//加载完成之后 初始化checkbox
			elo.checkbox(elo.property.tableId);
			//checkbox全选
			$("#" + elo.property.checkAllId).on('click', function () {
				console.log("check all");
				console.log(elo.gridInit.selectSingle);
				if (!elo.gridInit.selectSingle) {
					if ($(this).prop("checked")) {
						$("input[name='checkList']").prop("checked", true);
						$("tr").addClass('selected');
					} else {
						$("input[name='checkList']").prop("checked", false);
						$("tr").removeClass('selected');
					}
				}
			});

			//$(".search-box select").each(function () {
			//	if ($(this).attr("ddl_name") && $(this).attr("ddl_name") != "undefined")
			//	{
			//		DropDownUtils.initDropDown($(this).attr("id"),$(this).attr("pre"));
			//	}
			//});
			adaptionHeight();
		}
		//console.log(dataConfig);
		elo.table.grid = $('#' + elo.property.tableId).DataTable(dataConfig);
		//错误信息提示
		$.fn.dataTable.ext.errMode = function (s, h, m) {
			if (h == 1) {
				// alert("连接服务器失败！");
				easyAlert.timeShow({
					'type': 'warn',
					'content': '连接服务器失败！',
					'duration': 3
				});
			} else if (h == 7) {
				// alert("返回数据错误！");
				easyAlert.timeShow({
					'type': 'warn',
					'content': '返回数据错误',
					'duration': 3
				});
			}
		};
		//回调，如果返回的时候有问题提示信息
		elo.table.grid.on('xhr.dt', function (e, settings, json, xhr) {
			// console.log(json);
			if (typeof (json.code) != "undefined" && json.code != "0") {
				// alert(json.message);
				easyAlert.timeShow({
					'type': 'warn',
					'content': json.message,
					'duration': 3
				});
			}
		});
		//鼠标经过高亮
		var lastIdx = null;
	},
	reload: function () {
		var elo = this;
		try {
			elo.table.grid.ajax.reload();
		} catch (e) {
			window.location.reload(true);
		}
	},
	refresh: function (url) {
		var elo = this;
		try {
			elo.table.grid.settings()[0].ajax.data = {};
			$("#" + elo.property.buttonId).parent().find(".search-box :input").val("");
			if (url)
				elo.table.grid.ajax.url(url).load();
			else
				elo.table.grid.ajax.reload();
		} catch (e) {
			window.location.reload(true);
		}
	},
	checkbox: function (tableId) {
		var _t = this;
		//每次加载时都先清理
		$('#' + tableId + ' tbody').off("click", "tr").on("click", "tr", function () {
			if ($(this).find("input[type=checkbox]").eq(0).attr("disabled")) {
			}else{
				if (_t.gridInit.selectSingle != undefined && _t.gridInit.selectSingle == false) {
					var isSingle = false;
				} else {
					var isSingle = true;
				}
				console.log(isSingle+" is single");
				$(this).toggleClass("selected");
				if (isSingle) {
					if ($(this).hasClass("selected")) {
						$(this).find("input[type=checkbox]").prop("checked", true);
						// $(this).siblings().removeClass("selected");
						$(this).siblings().removeClass("selected").find("input[type=checkbox]").prop("checked", false);
					} else {
						$(this).find("input[type=checkbox]").prop("checked", false);
					}
				} else {
					if ($(this).hasClass("selected")) {
						$(this).find("input[type=checkbox]").prop("checked", true);
					} else {
						$(this).find("input[type=checkbox]").prop("checked", false);
					}
				}
			}
		});
	},
	createOne: function (sData) {
		var _this = this;
		var cols = _this.filed;
		//table thead
		var buildThead = function (cols) {
			var str = "<thead><tr>";
			for (var i = 0; i < cols.length; i++) {
				if (cols[i]['type']) {
					var _cl = cols[i]['type'];
				}else{
					var _cl = "";
				}
				if (cols[i]['head'] == "checkbox") {
					str += "<th><input type='checkbox' id='"+cols[i]['id']+"' /></th>";
				} else{
					str += "<th class='"+_cl+"'>"+cols[i]['head']+"</th>";
				}
			}
			str += '</tr></thead>';
			return str;
		}
		if (sData['attrs'] != undefined && sData.hasOwnProperty('attrs')) {
			var _table = $("#" + sData['attrs']['tableId']);
			if (_table.find("thead").length == 0) {
				var str = buildThead(cols);
				_table.append(str);
			}

			_this.changeProperty(sData['attrs']);
		}
		if (sData['hasSearch'] != undefined && sData.hasOwnProperty('hasSearch')) {
			_this.buildSearch(sData['hasSearch']);
		}
		if (sData['hasData'] != undefined && sData.hasOwnProperty('hasData')) {
			_this.data(sData['hasData']);
		}
		if (sData['hasAjax'] != undefined && sData.hasOwnProperty('hasAjax')) {
			_this.ajax(sData['hasAjax']);
		}
		if (sData['hasBtns'] != undefined && sData.hasOwnProperty('hasBtns')) {
			_this.buttons(sData['hasBtns'], sData['hasSearch']);
		}

		_this.init();
		return _this;
	},
	selectSingle: function () {//单选
		var eloancn = this;
		var $data = eloancn.table.grid.rows(".selected").data();
		if ($data.length == 1) {
			// console.log($data);
			var tData = eloancn.table.grid.row(".selected").data();
			// console.log(tData);
			var uuid = tData.id;
			if (uuid == "") {
				easyAlert.timeShow({
					'type': 'warn',
					'content': eloancn.table.statusTitle,
					'duration': 2
				});
			} else {
				return tData;
			}
		} else {
			easyAlert.timeShow({
				'type': 'warn',
				'content': eloancn.table.statusTitle,
				'duration': 2,
			});
		}
		return {};
	},
	selection: function () {//多选
		var eloancn = this;
		var $data = eloancn.table.grid.rows(".selected").data();
		var arr = [];
		console.log($data);
		if ($data.length == 0) {
			easyAlert.timeShow({
				'type': 'warn',
				'content': eloancn.table.statusTitle,
				'duration': 2
			});
		} else {
			for (var i = 0; i < $data.length; i++) {
				arr.push($data[i]);
			}
		}
		return arr;
	},
	disabledLine: function(row){
		try {
			//.css({"background":color})
			$("#" + property.tableId).find('tr').eq(row).css({"background":"#eee", "color":"#999"});
			$("#" + property.tableId).find('tr input[type=checkbox]').eq(row).attr({"disabled": true});
		} catch (e) {
		}
	},
	changeLine: function(row, color){
		try {
			$("#" + property.tableId).find('tr').eq(row).css({"background":color});
		} catch (e) {
		}
	},
	reDraw: function () {
		var elo = this;
		elo.table.grid.draw();
	},
	statusSpan:	function(_row, data){
		var _span = '', _type = data.type || '', _msg = data.msg || '';
		if (_type != '' && _msg != '') {
			var classType = 'label-'+_type;
			_span += '<span class="label '+classType+'">'+_msg+'</span>';
			_row.html(_span);
		}else{
			console.log('no type');
		}

		return false;
	},
}
//elo.table.grid 保存datatable对象
var tablePackageMany = {
	process: false,
	setProcess: function(type){
		tablePackage.process = type;
	},
	filed:[
			{ "data": "extn",
					"createdCell": function (nTd, sData, oData, iRow, iCol) {
							$(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
					}
			},
			{"data": "name"},
			{"data": "position"},
			{"data": "salary"},
			{"data": "start_date"},
			{"data": "office"},
			{"data": "extn"}
	],
	createdCell:	function(nTd, sData, oData, iRow, iCol){
		$(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
	},
	table:	{
		"grid":"",
		"statusTitle":"请选择一条数据！",
	},
	createOne:	function(sData){
		var $table = {};
		var _this = this;
		var cols = _this.filed;
		// console.log(sData);
		//table thead
		$table.table = {
			"grid":"",
			"statusTitle":"请选择一条数据！",
		};
		var buildThead = function(cols){
			var str = "<thead><tr>";
			for (var i = 0; i < cols.length; i++) {
				if (cols[i]['type']) {
					var _cl = cols[i]['type'];
				}else{
					var _cl = "";
				}
				if (cols[i]['head'] == "checkbox") {
					str += "<th><input type='checkbox' id='"+cols[i]['id']+"' /></th>";
				} else{
					str += "<th class='"+_cl+"'>"+cols[i]['head']+"</th>";
				}
			}
			str += '</tr></thead>';
			return str;
		}
		var property = {
			version:"v1.0",
			name:"name",
			tableId:"dataTable1",
			checkAllId:"checkAll",
			buttonId:"buttonId",
			formId:"formId",
			corporateFormId:"corporateFormId",
			returnStatus:"SUCCESS",
			returnTitle:"操作成功",
			statusTitle:"请选择一条数据！",
			idFailure:"获取id失败",
			prompt:"提示",
			pleaseConfirm:"请确认！",
			wantToDelete:"您确定要删除吗?",
			sexMan:"男",
			sexWoman:"女",
			isTest:"是",
			noTest:"否",
			banned:"禁用",
			enable:"启用",
			searchs:"",
			dosearch:null,
		};
		var gridInit = {
			// data:null,
			// ajax:null,
			searching:false,//搜索框，默认是开启
			lengthChange:false,//是否允许用户改变表格每页显示的记录数，默认是开启
			paging:true,
			serverSide:false,
			search:false,
			processing:true,
			ordering:  false,
			responsive: true,
			// scrollCollapse:true,
			// scrollY:500,
			// scrollX:"100%",
			// scrollXInner:"100%",
			scrollCollapse:true,
			jQueryUI:false,
			autoWidth:false,
			autoSearch:false,
			buttons:"",
			// "ordering": true,
			// "autoWidth": false,
			// "ordering":  false,
			// "responsive": true,
			// fnRowCallback: function( nRow, aData, iDisplayIndex ) {
			// 	/* Append the grade to the default row class name */
			// 	console.log(nRow);
			// 	console.log(aData);
			// 	console.log(iDisplayIndex);
			// 	// if ( aData[4] == "A" )
			// 	// {
			// 	// 	$('td:eq(4)', nRow).html( '<b>A</b>' );
			// 	// }
			// 	return nRow;
			// },
		};
		$table.gridInit = gridInit;
		$table.filed = _this.filed;
		$table.property = property;
		$table.requestUrl = {
			queryList:"",
		};
		$table.search = {
			uuid:"",
		};
		$table.changeProperty = function(r){
			var elo = $table;
			var pty = property;
			for (var each in r) {
				if (r.hasOwnProperty(each)) {
					if(each != "tableConfig"){
					//console.log(each);
						pty[each] = r[each];
					}else{
						elo.changeGridInit(r[each]);
					}
				}
			}
		}
		$table.changeGridInit = function(d){
			//console.log(d);
			var elo = this;
			var grid = gridInit;
			for (var each in d) {
				if (d.hasOwnProperty(each)) {
					grid[each] = d[each];
				}
			}
		};
		$table.buildSearch = function($ctrl){
			var elo = $table;
			var prop = property;
			var searchId = $ctrl['id'] || 'searchBox';
			var boxId = $ctrl['boxId'] || 'searchBox';
			var tabId = $ctrl['tabId'] || '';
			var tabMsg = $ctrl['tabMsg'] || '查询';
			var searchBtn = $ctrl['searchBtn'] || '.btn-search';
			var searchCallBack = $ctrl['searchCallBack'] || function(a){};
			var searchLink = $ctrl['searchLink'] || '/search';
			$table.changeGridInit({
				searching:	true,
				search:	true,
			});
			if ($ctrl['cols'] != undefined && $ctrl['cols']) {
				var str = '<div class="search-box">'+
							'<label class="form-label" style="margin:0 6px 5px 6px; font-size:14px;">查询：</label>';
				var buildEach = function(d){
					var s = '';
					s += '<div class="form-group">';
					if (d['type'] == "select") {
						s += '<select class="form-control" data-column="' + d['col'] + '" name="' + d['data'] + '" id="search-' + d['data'] + '" ddl_name="' + d['ddl_name'] + '" show_type="t" pre="'+d['pre']+ '" d_value="' + d['d_value'] +'" style="margin-right:6px;">';
						if (d['options']) {
							s += '<option value=""></option>';
							for (var i = 0; i < d['options'].length; i++) {
								var _e = d['options'][i];
								s += '<option value="'+_e['value']+'">'+_e['text']+'</option>';
							}
						}
	          s += '</select>';
					}else if (d['type'] == "timeSingle") {
						s += '<input type="text" name="'+d['data']+'" id="search-' + d['data'] + '" style="margin-right:6px;" data-column="'+d['col']+'" class="form-control timeSingle" placeholder="'+d['pre']+'"/>';
					}else if (d['type'] == "timeRange") {
						s += '<input type="text" name="'+d['data']+'" id="search-' + d['data'] + '" style="margin-right:6px;" data-column="'+d['col']+'" class="form-control timeRange" placeholder="'+d['pre']+'"/>';
					}else {
						s += '<input type="text" name="'+d['data']+'" id="search-' + d['data'] + '" style="margin-right:6px;" data-column="'+d['col']+'" class="form-control" placeholder="'+d['pre']+'"/>';
					}

					s += '</div>';
					return s;
				}
				for (var i = 0; i < $ctrl['cols'].length; i++) {
					var each = $ctrl['cols'][i];
					str += buildEach(each);
				}

				str += '<div class="form-group"><button type="button" class="btn btn-primary btn-flat btn-search" style="margin-right:6px;">搜索</button></div>';
				str += '<div class="form-group"><button type="button" class="btn btn-default btn-flat  btn-clearData">清除</button></div>';
				str += '</div>';

			/* new search */
			var bEach = function(){
				var _s = "";
				for (var i = 0; i < $ctrl['cols'].length; i++) {
					var each = $ctrl['cols'][i];
					_s += buildEach(each);
				}
				_s += '<div class="form-group"><div class="col-md-12">' +
				'<button type="button" class="btn btn-primary btn-flat btn-search" style="margin-right:6px;">搜索</button>' +
				'<button type="button" class="btn btn-default btn-flat btn-clearData">清除</button></div></div>';
				return _s;
			}
			var buildEach = function (d) {
				//console.log(d);
				var s = '<div class="col-md-4 form-group">'
				//start detail
				s += '<div class="">';
				// s += '<label class="control-sidebar-subheading">'+d['pre']+'</label>';
				s += '<label>'+d['pre']+'</label>';
				if (d['type'] == "select") {
					s += '<select class="form-control" data-column="' + d['col'] + '" name="' + d['data'] + '" id="search-' + d['data'] + '" ddl_name="' + d['ddl_name'] +'" d_value="'+ d['d_value'] +'" show_type="t" pre="' + d['pre'] + '" style="margin-right:6px;">';
					if (d['options']) {
						s += '<option value=""></option>';
						for (var i = 0; i < d['options'].length; i++) {
							var _e = d['options'][i];
							s += '<option value="' + _e['value'] + '">' + _e['text'] + '</option>';
						}
					}
					s += '</select>';
				} else if (d['type'] == "timeSingle") {
					s += '<input type="text" name="' + d['data'] + '" id="search-' + d['data'] + '" style="margin-right:6px;" data-column="' + d['col'] + '" class="form-control timeSingle" placeholder="' + d['pre'] + '"/>';
				} else if (d['type'] == "timeRange") {
					s += '<input type="text" name="' + d['data'] + '" id="search-' + d['data'] + '" style="margin-right:6px;" data-column="' + d['col'] + '" class="form-control timeRange" placeholder="' + d['pre'] + '"/>';
				} else {
					s += '<input type="text" name="' + d['data'] + '" id="search-' + d['data'] + '" style="margin-right:6px;" data-column="' + d['col'] + '" class="form-control" placeholder="' + d['pre'] + '"/>';
				}

				s += '</div>';
				//end
            	s += '</div>';

				return s;
			}
			var buildBox = function(){
var s = '<div class="box box-default" id="'+boxId+'">\
<div class="box-header with-border"><h3 class="box-title">'+tabMsg+'：</h3>\
<div class="box-tools pull-right">\
<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>\
</div>\
</div>\
<div class="box-body">\
<div class="row">\
'+bEach()+'\
</div>\
</div>\
</div>';
      			return s;
			}
				//console.log(str);
				prop.searchs = str;
				prop.boxId = boxId;
				//console.log(boxId);
				// console.log(prop.tableId + " " + searchBtn);
				var a  = $("#" + elo.property.tableId).parent();
				a.before(buildBox());
				var search = function(btn, elo){
						var grid = elo.table.grid;
						var oSettings = "";
						var searchVal = {};
						$("#" + boxId).find("[data-column]").each(function(){
							var _t = $(this);
							if(_t.attr('name') != undefined){
								searchVal[_t.attr('name')] = _t.val();
							}
						});
						elo.table.grid.settings()[0].ajax.data = searchVal;
						elo.table.grid.ajax.reload();
				}
				//prop.dosearch = search;
				elo.dosearch = search;
				//console.log(elo.dosearch);
				$("#" + boxId).find("select").each(function () {
						//console.log($(this));
						if ($(this).attr("ddl_name") && $(this).attr("ddl_name") != "undefined")
                        {
							DropDownUtils.initDropDown($(this).attr("id"),$(this).attr("pre"));
                        }
				});
				$("#" + boxId).on('click', searchBtn, function () {
				 	//按钮搜索方法
				 	search(this, elo);
				});

				$("#"+boxId).on("click", ".btn-clearData", function(){
				 	var _ts = $(this);
				 	// var $searchBox = $(".search-box");
				 	var $searchBox = $("#"+boxId);
				 	//console.log($(this));
				 	$searchBox.find("input, select, textarea").val("");
				 	try {
				 		$searchBox.find("input[type=checkbox]").iCheck('uncheck');
				 	} catch (e) {
				 		$searchBox.find("input[type=checkbox]").prop("checked", false);
				 	}
				});
			}
		};
		$table.data = function(dd){
			var elo = $table;
			var returnData = [];
			for (var i = 0; i < dd.length; i++) {
				var _d = dd[i];
				var f = true;
				// console.log(_d);
				for (var j = 0; j < elo.filed.length; j++) {
					var _e = elo.filed[j];
					//console.log(_e);
					if (_e != undefined && _d.hasOwnProperty(_e['data'])) {
					}else{
						f = false;
					}
				}
				if(f){
					returnData.push(_d);
				}
			}
			//console.log(returnData);
			if(returnData.length > 0){
				elo.gridInit.data = returnData;
			}
			return returnData;
		};
		$table.ajax = function($d){
			var elo = $table;
			// url: elo.requestUrl.queryList,//请求后台路径
			// type: 'POST',
			// data: elo.search,
			// error: function(jqXHR, textStatus, errorMsg){
			// 		alert("请求失败");
			// }
			if ($d.hasOwnProperty('url') && $d['url'] != undefined) {
				if ($d['method'] == undefined || $d['method'] == null) {
					$d['method'] = "GET";
				}
				if ($d['type'] == "client") {
					elo.changeGridInit({
						serverSide: false,
					});
					var _ajax = {
						url: 		$d['url'],//请求后台路径
						type: 	$d['method'],
						data: 	elo.search,
						error:	function(jqXHR, textStatus, errorMsg){
							// console.log(jqXHR);
							// console.log(textStatus);
							// console.log(errorMsg);
							// alert("请求失败");
							easyAlert.timeShow({
						    	'type':	'danger',
						    	'content':	'请求失败',
						    	'duration':	3,
						  });
						}
					}
					elo.gridInit.ajax = _ajax;
				}else if ($d['type'] == "server") {
					elo.changeGridInit({
						serverSide: true,
					});
					var _ajax = {
						url: 		$d['url'],//请求后台路径
						type: 	$d['method'],
						cache : false,
						// data: 	elo.search,
						error:	function(jqXHR, textStatus, errorMsg){
							// console.log(jqXHR);
							// console.log(textStatus);
							// console.log(errorMsg);
							// alert("请求失败");
							easyAlert.timeShow({
						    	'type':	'danger',
						    	'content':	'请求失败',
						    	'duration':	3,
						  });
						}
					}
					elo.gridInit.ajax = _ajax;
				}

				return true;
			}else {
				// return null;
				return false;
			}
		};
		$table.buttons = function(btnData){
			var elo = $table;
			//<div class="box-tools">
			var btnStr = '<div class="box-tools"><div class="input-group input-group-sm">'+'<div class="input-group-btn">';
			for (var i = 0; i < btnData.length; i++) {
				//btnData[i]
				var _btn = btnData[i];
				var _dType = typeof _btn;
				//console.log(_dType);
				if(_dType != "object"){
					switch (_btn) {
						case 'add':
							btnStr += '<button type="button" class="btn btn-primary btn-xs btn-add" style="margin-left: 6px;">新增</button>';
							break;
						case 'edit':
							btnStr += '<button type="button" class="btn btn-primary btn-xs btn-edit" style="margin-left: 6px;">编辑</button>';
							break;
						case 'enter':
							btnStr += '<button id="dataEnter" style="margin-left: 6px;" type="button" class="btn btn-primary btn-xs btn-enter">导入</button>';
							break;
						case 'del':
							btnStr += '<button style="margin-left: 6px;" type="button" class="btn btn-warning btn-xs btn-del">删除</button>';
							break;
						case 'reload':
							btnStr += '<button style="margin-left: 6px;" type="button" class="btn btn-default btn-xs btn-reload">刷新</button>';
							break;
						// case 'clearData':
						// 	btnStr += '<button style="margin-left: 6px;" type="button" class="btn btn-default btn-xs btn-clearData">清除查询</button>';
						// 	break;
						// case 'search':
						// 	btnStr += '<button style="margin-left: 6px;" type="button" class="btn btn-warning btn-xs btn-del">搜索</button>';
						// 	break;
						default:
							break;
					}
				}else{
					if (_btn.type && _btn.type == "enter") {
						btnStr += '<button style="margin-left: 6px;" type="button" class="btn btn-primary btn-xs btn-enter" data-action="'+_btn.action+'" data-modal="'+_btn.modal+'">'+_btn.title+'</button>';
					} else if(_btn.type && _btn.type == "userDefined") {
						var _attr = "";
						if(_btn.attr != undefined){
							for (var e in _btn.attr) {
								if(_btn.attr[e] != ''){
									_attr += e+"='"+_btn.attr[e]+"' ";
								}
							}
						}
						if(_btn.action != undefined){
							var $act = ' data-action="'+_btn.action+'"';
						}else{
							var $act = '';
						}
						if(_btn.id != undefined){
							var $id = ' id='+_btn.id;
						}else{
							var $id = '';
						}
						if (_btn.className != undefined) {
							var $css = _btn.className;
						}else {
							var $css = "btn-primary";
						}
						//console.log(_attr);
						btnStr += '<button style="margin-left: 6px;" type="button" class="btn  '+$css+' btn-xs btn-userDefined" '+_attr+$id+$act+'>'+_btn.title+'</button>';
					} else {
					}
				}
			}

			btnStr += '</div>'+'</div>'+'</div>';
			//+'</div>'
			elo.gridInit.buttons = btnStr;
			return btnStr;
		};
		$table.dosearch = function(){};
		$table.status = [
				{"searchable": false, "orderable": false, "targets": 0},//第一行不进行排序和搜索
				// {"targets": [12], "visible": false},    //设置第13列隐藏/显示
				// {"width": "10%", "targets": [1]},  //设置第2列宽度
				// {
				// 		对第7列内容进行替换处理
				// 		targets: 6,
				// 		render: function (data, type, row, meta) {
				// 				if (data == "1") {
				// 						return employee.table.sexMan;
				// 				}
				// 				if (data == "0") {
				// 						return employee.table.sexWoman;
				// 				}
				// 		}
				// },
				{defaultContent: '', targets: ['_all']} //所有列设置默认值为空字符串
		];
		$table.reload = function(){
			var elo = $table;
			try {
				elo.table.grid.ajax.reload();
			} catch (e) {
				window.location.reload(true);
			}
		};
		$table.refresh = function (url) {
			var elo = $table;
			try {
				elo.table.grid.settings()[0].ajax.data = {};
				$("#" + property.buttonId).parent().find(".search-box :input").val("");
				if (url)
					elo.table.grid.ajax.url(url).load();
				else
					elo.table.grid.ajax.reload();
			} catch (e) {
				window.location.reload(true);
			}
		};
		$table.checkbox = function(tableId){
			var _t = $table;
			//每次加载时都先清理
			$('#'+tableId+' tbody').off("click", "tr").on("click", "tr", function () {
				if ($(this).find("input[type=checkbox]").eq(0).attr("disabled")) {
				}else{
					if (_t.gridInit.selectSingle != undefined && _t.gridInit.selectSingle == false) {
						var isSingle = false;
					}else {
						var isSingle = true;
					}
					console.log(isSingle+" is single");
					$(this).toggleClass("selected");
					if (isSingle) {
						if($(this).hasClass("selected")){
							$(this).find("input[type=checkbox]").prop("checked", true);
							// $(this).siblings().removeClass("selected");
							$(this).siblings().removeClass("selected").find("input[type=checkbox]").prop("checked", false);
						}else{
							$(this).find("input[type=checkbox]").prop("checked", false);
						}
					} else{
						if($(this).hasClass("selected")){
							$(this).find("input[type=checkbox]").prop("checked", true);
						}else{
							$(this).find("input[type=checkbox]").prop("checked", false);
						}
					}
				}
			});
		};
		$table.selectSingle = function(){//单选
			var eloancn = $table;
			var $data = eloancn.table.grid.rows(".selected").data();
				if ($data.length == 1) {
						// console.log($data);
						var tData = eloancn.table.grid.row(".selected").data();
						// console.log(tData);
						var uuid = tData.id;
						if(uuid == ""){
								// alert(eloancn.table.statusTitle);
								easyAlert.timeShow({
							    	'type':	'warn',
							    	'content':	eloancn.table.statusTitle,
							    	'duration':	2
							  });
              	return;
						}else{
								return tData;
						}
				}else{
						easyAlert.timeShow({
					    	'type':	'warn',
					    	'content':	eloancn.table.statusTitle,
					    	'duration':	2
					  });
            return;
				}
				return {};
		};
		$table.selection = function(){
			var eloancn = $table;
			var $data = eloancn.table.grid.rows(".selected").data();
			var arr = [];
			console.log($data);
			if ($data.length == 0) {
				easyAlert.timeShow({
					'type':	'warn',
					'content':	eloancn.table.statusTitle,
					'duration':	2,
				});
			}else {
				for (var i = 0; i < $data.length; i++) {
					arr.push($data[i]);
				}
			}

			return arr;
		};
		$table.changeLine = function(row, color){
			try {
				//.css({"background":color})
				//console.log(row);
				//console.log(color);
				$("#" + property.tableId).find('tr').eq(row).css({"background":color});
				// $("#" + property.tableId).find('tr input[type=checkbox]').eq(row).attr({"disabled": true});
			} catch (e) {
				console.log(e);
			}
		}
		$table.disabledLine = function(row){
			// console.log($("#" + property.tableId).find("tbody tr"));
			try {
				//.css({"background":color})
				$("#" + property.tableId).find('tr').eq(row).css({"background":"#eee", "color":"#999"});
				$("#" + property.tableId).find('tr input[type=checkbox]').eq(row).attr({"disabled": true});
			} catch (e) {
				console.log(e);
			}
		}
		// $table.rowCallback = function(nRow, aData, iDisplayIndex){
		// 	// console.log(nRow);
		// 	// console.log(aData);
		// 	// console.log(iDisplayIndex);
		// 	if(sData['attrs'] != undefined && sData.hasOwnProperty("attrs")){
		//
		// 	}
		// };
		$table.statusSpan =	function(_row, data){
			var _span = '', _type = data.type || '', _msg = data.msg || '';
			if (_type != '' && _msg != '') {
				var classType = 'label-'+_type;
				_span += '<span class="label '+classType+'">'+_msg+'</span>';
				_row.html(_span);
			}else{
				console.log('no type');
			}

			return false;
		}
		$table.init = function(){
			var elo = $table;
			// console.log(elo);
			// console.log(property);
			var dataConfig = elo.gridInit;
			dataConfig["columns"] = elo.filed;//字段
			dataConfig["columnDefs"] = elo.status;//列表状态
			dataConfig['language'] = {
					"sProcessing": "处理中...",
					"sLengthMenu": "显示 _MENU_ 项结果",
					"sZeroRecords": "没有匹配结果",
					"sInfo": " 共 _TOTAL_ 项",//"显示第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项",
					"sInfoEmpty": " 共 0 项",//"显示第 0 至 0 项结果，共 0 项",
					"sInfoFiltered": "(由 _MAX_ 项结果过滤)",
					"sInfoPostFix": "",
					"sSearch": "搜索:",
					"sUrl": "",
					"sEmptyTable": "未搜索到数据",
					"sLoadingRecords": "载入中...",
					"sInfoThousands": ",",
					"oPaginate": {
							"sFirst": "首页",
							"sPrevious": "上页",
							"sNext": "下页",
							"sLast": "末页"
					},
					"oAria": {
							"sSortAscending": ": 以升序排列此列",
							"sSortDescending": ": 以降序排列此列"
					}
			};
			dataConfig['dom'] = "<'#"+property.buttonId+".box-header'r><'box-body't<''<'col-sm-3'i><'col-sm-3'l><'col-sm-6'p>>>";
			// dataConfig["fnRowCallback"] = elo.rowCallback;

			//datatable 补充方法
			dataConfig['initComplete'] = function(){
					// var btnStr = elo.buttons();
					if (elo.property.tableTitle)
						$("#"+property.buttonId).append('<h3 class="box-title">'+property.tableTitle+'</h3>');
					// console.log(elo.gridInit.buttons);
					$("#"+property.buttonId).append(elo.gridInit.buttons);
					//input-group input-group-sm
					//var sIn = property.searchs;
					//$("#"+property.tableId).parent().prepend(sIn);
					//$("#dataTable1_length").css({'margin-top':'4px',});
					$("#"+property.tableId+"_length").css({'margin-top':'4px',});
					//console.log(property);
					setTimeout(function(){
					//	property.dosearch(null, elo);
						elo.dosearch(null, elo);
					}, 1000);
					//$("#" + property.boxId).find(".btn-search").trigger("click");
					//property.dosearch(null, elo);
					if($(".timeSingle").length > 0){
						var dateConfig = {
							'type':'single',//类型，range或者single或者default
							'pluginConfig':{},//时间样式配置
							'dateId':'.timeSingle',//选择的位置
						}
						datePackage.init(dateConfig);
					}
					if ($(".timeRange").length > 0) {
						var dateConfig = {
							'type':'range',//类型，range或者single或者default
							'pluginConfig':{},//时间样式配置
							'dateId':'.timeRange',//选择的位置
						}
						datePackage.init(dateConfig);
					}
					//加载完成之后 初始化checkbox
					elo.checkbox(property.tableId);
					//checkbox全选
					$("#"+property.checkAllId).on('click', function () {
						console.log("check all");
						console.log(elo.gridInit.selectSingle);
						if (!elo.gridInit.selectSingle) {
							if ($(this).prop("checked")) {
									$("input[name='checkList']").prop("checked", true);
									$("tr").addClass('selected');
							} else {
									$("input[name='checkList']").prop("checked", false);
									$("tr").removeClass('selected');
							}
						}
					});

					adaptionHeight();
			}
			// console.log(dataConfig);
			elo.table.grid = $('#'+property.tableId).DataTable(dataConfig);
			//错误信息提示
			$.fn.dataTable.ext.errMode = function(s,h,m){
					if(h == 1){
						easyAlert.timeShow({
					    	'type':	'warn',
					    	'content':	'连接服务器失败！',
					    	'duration':	3,
					  });
					}else if(h == 7){
						easyAlert.timeShow({
					    	'type':	'warn',
					    	'content':	'返回数据错误',
					    	'duration':	3,
					    });
					}
			};
			//回调，如果返回的时候有问题提示信息
			elo.table.grid.on('xhr.dt', function ( e, settings, json, xhr ) {
					// console.log(json);
					if(typeof(json.code)!="undefined"	&&	json.code!="0"){
						easyAlert.timeShow({
					    	'type':	'warn',
					    	'content':	json.message,
					    	'duration':	3,
					  });
					}
			} );
			//鼠标经过高亮
			var lastIdx = null;
		};

		if(sData['attrs'] != undefined && sData.hasOwnProperty('attrs')){
			var _table = $("#" + sData['attrs']['tableId']);
			if (_table.find("thead").length == 0) {
				var str = buildThead(cols);
				_table.append(str);
			}
			$table.changeProperty(sData['attrs']);
		}
		if(sData['hasSearch'] != undefined && sData.hasOwnProperty('hasSearch')){
			$table.buildSearch(sData['hasSearch']);
		}
		if(sData['hasData'] != undefined && sData.hasOwnProperty('hasData')){
			$table.data(sData['hasData']);
		}
		if(sData['hasAjax'] != undefined && sData.hasOwnProperty('hasAjax')){
			$table.ajax(sData['hasAjax']);
		}
		if(sData['hasBtns'] != undefined && sData.hasOwnProperty('hasBtns')){
			$table.buttons(sData['hasBtns']);
		}

		$table.init();

		// if(sData['hasModal'] != undefined && sData.hasOwnProperty('hasModal')){
		// 	_this.tableModal(sData['hasModal'], sData['hasCtrl']);
		// }

		return $table;
	},
	after:	function(){
		//
	},
}