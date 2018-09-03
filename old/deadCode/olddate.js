var datePackage = {
	config:	{
		'type':'',
		'pluginConfig':{
			// timePicker: true,
			// timePickerIncrement: 30,
			format: 'YYYY-MM-DD HH:mm:ss',
		},
		'dateId':'',
	},
	init:	function(d){
		var _config = datePackage.config;
		for (var e in d) {
			if(_config.hasOwnProperty(e)){
				_config[e] = d[e];
			}
		}
		var type = _config['type'];
		if (type == 'range') {
			$(_config['dateId']).daterangepicker(_config['pluginConfig']);
		} else{
			$(_config['dateId']).datepicker({
		    	format: 'yyyy-mm-dd',
					autoclose:true,
					// format: 'MM/DD/YYYY h:mm A'
		  });
		}
	},
	createDefault:	function(){
		var _config = datePackage.config;

	},
	createRange:	function(){
		var _config = datePackage.config;

	},

}


var bootDataTable = {
  process: false,
  setProcess: function(type){
    process = type;
  },
  // init: function($table, $config, $data, $addModal, $editModal, $addBtn, $addSave, $editBtn, $editSave, $delBtn, $type){
  init: function($tableConfig, $EventConfig, $modalConfig){
    // var tableConfig = {
    //   'table': '#dataTable1',
    //   'config':{
    //     "data": buildData(grid_data, 'operate'),
    //     "columns": [
    //         { "data": 'id' },
    //         { "data": 'name' },
    //         { "data": 'note' },
    //         { "data": 'stock' },
    //         { "data": 'ship' },
    //         { "data": 'sdate' },
    //         { "data": 'operate' },
    //     ],
    //   }
    // };
    // var EventConfig = {
    //   "content":    "#content",
    //   "modal":      "#dataModal",
    //   "addBtn":     ".btn-add",
    //   "editBtn":    ".btn-edit",
    //   "delModal":   "#delModal",
    //   "delBtn":     ".btn-del",
    //   "submitType": "form",
    // };
    var _ts = this;
    var _table = _ts.createOne($tableConfig['table']);
    _table.changeConfig($tableConfig['config']);
    var _dataTable = _table.instantiation();
    if($modalConfig != undefined){
    	_ts.buildModal($modalConfig);
    }

    _ts.events($EventConfig);
  },
  createOne: function($table){
    var _table = {}, _this = $($table);
    //自助修改配置文件
    var datatableConfig = {
      // "data": $data,
      //使用对象数组，一定要配置columns，告诉 DataTables 每列对应的属性
      //data 这里是固定不变的，name，position，salary，office 为你数据里对应的属性
      // "columns": [
      //   { data: 'id' },
      //   { data: 'name' },
      //   { data: 'note' },
      //   { data: 'stock' },
      //   { data: 'ship' },
      //   { data: 'sdate' },
      //   { data: 'operate' },
      // ],
      "paging": true,
      "lengthChange": false,
      "searching": true,
      "ordering": true,
      "info": false,
      "autoWidth": false,
      "ordering":  false,
      "responsive": true,
      // "scrollX": true,
      // "columnDefs": [
      //   { responsivePriority: 1, targets: 0 },
      //   { responsivePriority: 2, targets: -1 }
      // ],
      // "dom": 'Bfrtip',
      // "buttons": ['colvis', 'excel', 'print'],
    };
    _table.changeConfig = function(obj){
      for(var e in obj){
        datatableConfig[e] = obj[e];
      }
    };
    _table.getConfig = function(){
      console.log(datatableConfig);
    };
    _table.instantiation = function(){
      try {
        if(datatableConfig.hasOwnProperty('data')){
          //实例化datatables
          var _newDataTable = _this.DataTable(datatableConfig);
        }else {
          // return null;
          var _newDataTable = _this.DataTable(datatableConfig);
        }
      } catch(e) {
        console.log(e);
        return null;
      }
      return _newDataTable;
    };

    return _table;
  },
  buildModal:function($config){
  	var _submitType = $config['submitType'] || "";
  	var modal = $config['modal'] || null;
    var delModal = $config['delModal'] || null;
    var columns = $config['columns'] || [];
    var delCol = $config['delCol'] || [];
    var delAction = $config['delAction'] || '/del';
    var modalAction = $config['modalAction'] || '/post';
    var struct = $config['struct'] || [];
    //
    var $data = {
        'id': 			modal.split('#')[1],
        'columns':	columns,
				'action':		modalAction,
				'title':		document.title,
				'struct':		struct,
				'submitType':_submitType,
				'success':	$config['modalSuccess'],
    }
		var $del = {
      'id': delModal.split('#')[1],
      'columns':  delCol,
      'action':   delAction
    }
    var dataM = $dataModal.init('body', $data);
    var delM = $delModal.init('body', $del);

  },
  events: function($config){
    var _msg = {}, _public = {};
    var _submitType = $config['submitType'] || "",  //提交类型有两种，form类型直接提交，或者ajax提交
        buildModal = $config['buildModal'] || true;
    var _content = $($config['content']) || null,
        _table = $($config['table']) || null;
    //
    var dataModal = $config['modal'] || null;
    var delModal = $config['delModal'] || null;
    var columns = $config['columns'] || [];
    var delCol = $config['delCol'] || [];
    var delAction = $config['delAction'] || '/del';
    var modalAction = $config['modalAction'] || '/post';
    // var tableArr = [];
    // _table.find('thead tr th').each(function(){
    //   var _t = $(this);
    //   if(_t.attr('name') != undefined && _t.attr('name') != null && _t.attr('name') != ""){
    //     tableArr.push(_t.attr('name'));
    //   }
    // });
    //TODO build _modal and add function edit function
    if (buildModal) {
  	//  var dataM = $dataModal.init('body', $data);
  	//  var delM = $delModal.init('body', $del);
      _modal = $(dataModal);
      _delModal = $(delModal);
      var addDialog = function(){
	      var addBtn = $config['addBtn'];
	      _content.on('click', addBtn, function(){
		      // var _form = _modal.find('form');
		      // _form.find('input, textarea').each(function(){
		      //   $(this).val('');
		      // });
		      //   _form[0].reset();
		      //   if(_submitType == "form" || _submitType == ""){
		      //     _modal.modal();
		      //   }
					_modal.find('input, textarea').each(function(){
						$(this).val();
					});

					_modal.modal();
	        return false;
	      });
	    };
		var setValToModal = function(_modal, _row, _arr){
      _row.find('td').each(function(){
				//var _t = $(this), _s = _modal.find('[name='+_arr[_t.index()]+']');
        var _t = $(this), _l = _arr[_t.index()];
				var _s = _modal.find('[name='+_l['data']+']');
        if(_s.length > 0){
          // console.log(_s.prop("nodeName"));
          if(_s.prop("nodeName") != 'TEXTAREA' && _s.prop('nodeName') != "SELECT"){
            if(_s.attr('type') != "checkbox"){
              // console.log(_t.find('div').length);
              if(_t.find('div').length > 0){
                _s.val(_t.find('div').text());
              }else{
                _s.val(_t.text());
              }
            }else{
              if(_t.find('input').val() > 0 && _t.find('input').val() != undefined && _t.find('input').val() > '0'){
                _s.prop('checked', true);
              }else{
                _s.prop('checked', false);
              }
            }
          }else if(_s.prop('nodeName') == "SELECT") {
            // console.log(_s);
            _s.val(_t.text());
          }else{
            _s.val(_t.text());
          }
        }
      });
	  };

    var editDialog = function(){
      var editBtn = $config['editBtn'];
      _content.on("click", editBtn, function(){
  	  	var _row = $(this).parentsUntil('tr').parent(),
  		  	  _form = _modal.find('form');
  		  if(columns.length > 0){
    			setValToModal(_modal, _row, columns);
    	    _modal.modal();
    	  }
        return false;
  	  });
    };
      var delDialog = function(data){
        var delBtn = $config['delBtn'];
        _content.on("click", delBtn, function(){
          var _row = $(this).parentsUntil('tr').parent(),
              _form = _delModal.find('form');
          //TODO 找到所需col所在的位置
          // var tableArr = [];
          var arrPosi = [];
          _table.find('thead tr th').each(function(){
            var _t = $(this);
            if(_t.attr('name') != undefined && _t.attr('name') != null && _t.attr('name') != ""){
              // tableArr.push(_t.attr('name'));
              for (var i = 0; i < data.length; i++) {
                // data[i]
                if(_t.attr('name') == data[i]){
                  arrPosi.push({'key':_t.attr('name'), 'index':_t.index()});
                }
              }
            }
          });
					//console.log(arrPosi);
          // var _id = _row.find('td:eq(1)').text();
          if(_submitType == "form" || _submitType == ""){
            for (var i = 0; i < arrPosi.length; i++) {
              // arrPosi[i]
							//console.log(arrPosi[i]['key']+'//'+arrPosi[i]['index']);
              var _val = _row.find('td:eq('+arrPosi[i]['index']+')').text();
              _form.find('input[name='+arrPosi[i]['key']+']').val(_val);
              // console.log( _form.find('input[name='+arrPosi[i]['key']+']') );
            }
            _delModal.modal();
          }
        });
      };
      addDialog();
      editDialog();
      delDialog(delCol);
      // console.log(_delModal.length);
    } else {
      _modal = $(dataModal);
      _delModal = $(delModal);

			var addDialog = function(){
	      var addBtn = $config['addBtn'];
	      _content.on('click', addBtn, function(){
	        var _form = _modal.find('form');
	        // _form.find('input, textarea').each(function(){
	        //   $(this).val('');
	        // });
	        _form[0].reset();
	        if(_submitType == "form" || _submitType == ""){
	          _modal.modal();
	        }

	        return false;
	      });
	    };
      var delDialog = function(){
        var delBtn = $config['delBtn'];
        _content.on("click", delBtn, function(){
    	  	var _row = $(this).parentsUntil('tr').parent(),
    		      _form = _modal.find('form');
    			var _id = _row.find('td:eq(1)').text();
          if(_submitType == "form" || _submitType == ""){
      			_form.find('input[name=id]').val(_id);
            console.log(_id);
            // console.log(_delModal.length);
      	    _delModal.modal();
          }
    	  });
      };
      delDialog();
      addDialog();
    }

    //删除
    function _deleteFun(id) {
      $.ajax({
          url: "http://dt.thxopen.com/example/resources/user_share/basic_curd/deleteFun.php",
          data: {"id": id},
          type: "post",
          success: function (backdata) {
              if (backdata) {
                  oTable.fnReloadAjax(oTable.fnSettings());
              } else {
                  alert("删除失败");
              }
          }, error: function (error) {
              console.log(error);
          }
      });
    }
    //新增
    function _addFun() {
      var jsonData = {
          'name': $("#inputName").val(),
          'job': $("#inputJob").val(),
          'note': $("#inputNote").val()
      };
      $.ajax({
          url: "http://dt.thxopen.com/example/resources/user_share/basic_curd/insertFun.php",
          data: jsonData,
          type: "post",
          success: function (backdata) {
              if (backdata == 1) {
                  $("#myModal").modal("hide");
                  resetFrom();
                  oTable.fnReloadAjax(oTable.fnSettings());
              } else if (backdata == 0) {
                  alert("插入失败");
              } else {
                  alert("防止数据不断增长，会影响速度，请先删掉一些数据再做测试");
              }
          }, error: function (error) {
              console.log(error);
          }
      });
    }
    //重写ajax function
    // $.fn.dataTableExt.oApi.fnReloadAjax = function (oSettings) {
    // //oSettings.sAjaxSource = sNewSource;
    // this.fnClearTable(this);
    // this.oApi._fnProcessingDisplay(oSettings, true);
    // var that = this;
    //
    // $.getJSON(oSettings.sAjaxSource, null, function (json) {
    //     /* Got the data - add it to the table */
    //     for (var i = 0; i < json.aaData.length; i++) {
    //         that.oApi._fnAddData(oSettings, json.aaData[i]);
    //     }
    //     oSettings.aiDisplay = oSettings.aiDisplayMaster.slice();
    //     that.fnDraw(that);
    //     that.oApi._fnProcessingDisplay(oSettings, false);
    // });
    // }

    // addDialog();
    // editDialog();

  },
};


var formGroupPackage = {
	process: false,
	setProcess: function(type) {
		formGroupPackage.process = type;
	},
	/*//TODO form 画表 配置，有几点。
			头头尾尾，
			适用，input？
	*/
	property: {
		action: "/post", //action
		formId: "", //ID
		name: "name",
		title: "", //标题
		editBtn: "btn-edit", //ID
		submitBtn: "btn-submit", //ID
		banned: "禁用",
		returnStatus: "SUCCESS",
		returnTitle: "保存成功",
		statusTitle: "请选择一条数据！",
		prompt: "提示",
		pleaseConfirm: "请确认！",
		wantToDelete: "您确定要删除吗?",
	},
	struct: [{ //第一层，每一列
		width: '12',
		cols: [ //第二层，每一子列
			{
				width: '6',
				group: [ //一列中包含的子group
					{
						label: '姓名',
						form: 'input', //默认
						formName: 'name',
						limit: '', //额外要求？
					},
					{
						label: '出生日期',
						form: 'input', //默认
						formName: 'born',
						limit: '', //额外要求？
					}
				]
			},
			{
				width: '6',
				group: [{
						label: '姓名',
						form: 'input', //默认
						formName: 'name',
						limit: '', //额外要求？
					},
					{
						label: '出生日期',
						form: 'input', //默认
						formName: 'born',
						limit: '', //额外要求？
					}
				]
			},
		]
	}, ],
	buildHtml:	function(){
		//根据 property 和 struct 做str
		var _t = this;

	},
	init:	function(){

	},

}
