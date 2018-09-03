var $delModal = {
  init: function(to, data){
    var _ts = this;
    var _in = _ts.createOne(data);
		var _html = _in.struct();
		$(to).append(_html);
    // return $(_html);
  },
  createOne: function(data){
    var _delModal = {}, _this = null;
    var $data = data;
    var createForm = function(d){
      var str = '<input type="hidden" name="'+d+'" value="" />';
      return str;
    }
    var createMsg = function(d){
      var str = '<div class="modal modal-warning" id="'+d['id']+'">'+
        '<div class="modal-dialog">'+
          '<form action="'+d['action']+'" method="post" name="form" class="modal-content form-horizontal">'+
            '<div class="modal-header">'+
              '<button type="button" class="close" data-dismiss="modal" aria-label="Close">'+
                '<span aria-hidden="true">×</span>'+
              '</button>'+
              '<h4 class="modal-title">删除</h4>'+
            '</div>'+
            '<div class="modal-body">'+
              '<p>确定要删除选中信息？</p>';
          for (var i = 0; i < d['columns'].length; i++) {
            str += createForm(d['columns'][i]);
          }
          str += '</div>'+
            '<div class="modal-footer">'+
              '<button type="button" class="btn btn-outline pull-left" data-dismiss="modal">取消</button>'+
              '<button type="submit" class="btn btn-outline">确定</button>'+
            '</div>'+
          '</form>'+
        '</div>'+
      '</div>';
      return str;
    };
    _delModal.struct = function(){
      var baseStr = "";
			if($data['id'] != undefined && $data['id'] != ''){
        baseStr += createMsg($data);
      }else {

      }
      return baseStr;
    }

    return _delModal;
  },
	controls:	function($ctrl){
		var buildModal = $ctrl['buildModal'] || true;
		var delModal = $ctrl['delModal'] || null;
		var delCol = $ctrl['delCol'] || [];
		var delBtn = $ctrl['delBtn'] || ".btn-del";
		var delSubmit = $ctrl['delSubmit'] || ".btn-save";
		var delAction = $ctrl['delAction'] || '/del';
		var content = $ctrl['content'] || null;
		var table = $ctrl['table'] || null;
		var _submitType = $ctrl['submitType'] || "form";
    var beforeShow = $ctrl['beforeShow'] || null;
		var submitCallBack = $ctrl['submitCallBack'] || function(a){};
		if (buildModal) {
			_delModal = $('#'+delModal);
			_content = $('#'+content);
			_table = $("#"+table);
			var doSubmit = function(){
				_modal.on("click", delSubmit, function(){
					var _ts = $(this);
					submitCallBack(this);
				});
			}
			var delDialog = function(data){
				// var delBtn = $config['delBtn'];
				_content.on("click", delBtn, function(){
					var $d = tablePackage.selection();
					if ($d != undefined && $d.length > 0) {
            if (typeof (beforeShow) == "function") {
							if (!beforeShow($d)) return false;
						}
						// console.log($d);
						var _form = _delModal.find('form');
						_form.find('input').each(function(){
			 				var _t = $(this);
			 				if(_t.attr('name') != undefined){
			 					console.log(_t.attr('name'));
			 					var valArr = [];
				 				for (var j = 0; j < $d.length; j++) {
				 					valArr.push($d[j][_t.attr('name')]);
				 				}
								_form.find('input[name='+_t.attr('name')+']').val(valArr);
			 				}
			 			});
						_delModal.modal();
					}else{

					}
				});
			};
			delDialog(delCol);
      doSubmit();
		} else {

		}


	}
}

var $fileModal = {
  init: function(to, data){
    var _ts = this;
  },
  createOne: function(data){
    var _delModal = {}, _this = null;
    var $data = data;

    return _delModal;
  },
	controls:	function($ctrl){
		var fileModal = $ctrl['fileModal'] || null;
		var fileBtn = $ctrl['fileBtn'] || ".btn-enter";
		var fileAction = $ctrl['fileAction'] || '/file';
		var content = $ctrl['content'] || null;
    var submitBtn = $ctrl['submitBtn'] || ".btn-save";
		var _submitType = $ctrl['submitType'] || "form";
    var submitCallback = $ctrl['submitCallback'] || null;

		_fileModal = $('#'+fileModal);
		_content = $('#'+content);
		var clearFile = function(file){
			file.after(file.clone().val(""));
			file.remove();
		}
    var doSubmit = function(){
      _fileModal.on("click", submitBtn, function(){
        submitCallback();
      });
    }
		var fileDialog = function(){
			_content.on("click", fileBtn, function(){
				var _ts = $(this);
				if (_ts.attr("data-action")) {
					fileAction = _ts.attr("data-action");
				}
				if (_ts.attr("data-modal")) {
					fileModal = _ts.attr("data-modal");
					_fileModal = $('#'+fileModal);
				}
				var _form = _fileModal.find('form');
				_form.attr({
					"action":fileAction,
				});
				_form.find("input[type=file]").each(function(){
					clearFile($(this));
				});
				_fileModal.modal();
			});
		};
		fileDialog();
    doSubmit();

	}
}

var $dataModal = {
  init: function(to, data){
    var _ts = this;
    var _in = _ts.createOne(data);
		var _html = _in.struct();
		$(to).append(_html);
		_in.doSubmit();
		var suct = data['struct'], hasCheckBox = false, hasTime = false, hasFile = false;
		for (var i = 0; i < suct.length; i++) {
			var _s = suct[i], _col = _s['columns'];
			for (var i = 0; i < _col.length; i++) {
				var _cl = _col[i];
				if (_cl['type'] == 'checkbox') {
					hasCheckBox = true;
				}else if (_cl['type'] == 'timeSingle' || _cl['type'] == 'timeRange') {
					hasTime = true;
				}else if (_cl['type'] == 'file') {
					hasFile = true;
				}
			}
		}
		if (hasCheckBox) {
			//如果有checkbox，要加这段js //强制加，有bug再说
			$('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
				checkboxClass: 'icheckbox_flat-green',
				radioClass: 'iradio_flat-green'
			});
		}
		if (hasTime) {
			//如果有Time，要加这段js
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
		}
		if (hasFile) {

		}
  },
  createOne: function(data){
    var _dataModal = {}, _this = null;
    var $data = data;
    var createMsg = function(d){
      var str = '';
      return str;
    };
    var eachCheckbox = function(d){
    	if(d['pre'] == undefined || d['pre'] == null){
    		d['pre'] = '';
    	}
			if (d['label'] == undefined && d['form'] == undefined) {
					d['label'] = 6;
					d['form'] = 6;
			}
			if (d['head'] == undefined || d['head'] == null) {
				d['head'] = d['data'];
			}
      var str = '<div class="form-group">'+
        '<div class="col-md-'+d['label']+'"><label class="control-label">'+d['head']+'：</label></div>'+
        '<div class="col-md-'+d['form']+' checkbox">'+
          '<input name="'+d['data']+'" type="checkbox" class="flat-red">'+
        '</div>'+
      '</div>';
      return str;
    }
    var eachInput = function(d){
    	if(d['pre'] == undefined || d['pre'] == null){
    		d['pre'] = '';
    	}
			if (d['label'] == undefined && d['form'] == undefined) {
					d['label'] = 6;
					d['form'] = 6;
			}
			if (d['head'] == undefined || d['head'] == null) {
				d['head'] = d['data'];
			}
      var str = '<div class="form-group">'+
        '<div class="col-md-'+d['label']+'"><label class="control-label">'+d['head']+'：</label></div>'+
        '<div class="col-md-'+d['form']+'">'+
          '<input name="'+d['data']+'" type="text" class="form-control" placeholder="'+d['pre']+'" />'+
        '</div>'+
      '</div>';
      return str;
    }
    var eachText = function(d){
    	if(d['pre'] == undefined || d['pre'] == null){
    		d['pre'] = '';
    	}
			if (d['label'] == undefined && d['form'] == undefined) {
					d['label'] = 6;
					d['form'] = 6;
			}
			if (d['head'] == undefined || d['head'] == null) {
				d['head'] = d['data'];
			}
      var str = '<div class="form-group">'+
          '<div class="col-md-'+d['label']+'"><label class="control-label">'+d['head']+'：</label></div>'+
          '<div class="col-md-'+d['form']+'">'+
            '<textarea name="'+d['data']+'" class="form-control" rows="3" placeholder="'+d['pre']+'"></textarea>'+
          '</div>'+
        '</div>';
      return str;
    }
    var eachSelect = function(d){
    	if(d['pre'] == undefined || d['pre'] == null){
    		d['pre'] = '';
    	}
			if (d['label'] == undefined && d['form'] == undefined) {
					d['label'] = 6;
					d['form'] = 6;
			}
			if (d['head'] == undefined || d['head'] == null) {
				d['head'] = d['data'];
			}
      var str = '<div class="form-group">'+
          '<div class="col-md-'+d['label']+'"><label class="control-label">'+d['head']+'：</label></div>'+
          '<div class="col-md-'+d['form']+'">'+
            '<select class="form-control" name='+d['data']+'>';
      for(var i = 0; i < d['options'].length; i++){
      	var _opt = d['options'][i];
      	if (_opt['value'] == undefined || _opt['value'] == null) {
      		_opt['value'] = '';
      	}
        str += '<option key="'+_opt['key']+'">'+_opt['value']+'</option>';
      }
          str += '</select>'+
          '</div>'+
        '</div>';
      return str;
    }
    var eachFile = function(d){
			if (d['label'] == undefined && d['form'] == undefined) {
					d['label'] = 6;
					d['form'] = 6;
			}
			if (d['head'] == undefined || d['head'] == null) {
				d['head'] = d['data'];
			}
    	var str = '<div class="form-group">'+
		                	'<div class="col-md-'+d['label']+'"><label for="InputFile">'+d['head']+'：</label></div>'+
		                	'<div class="col-md-'+d['form']+'">'+
		                	'<input id="InputFile" type="file" name="'+d['data']+'" multiple="multiple" />'+
											'</div>'+
		                '</div>';

    	return str;
    }
		var eachTime = function(d){
			if (d['label'] == undefined && d['form'] == undefined) {
					d['label'] = 6;
					d['form'] = 6;
			}
			if (d['head'] == undefined || d['head'] == null) {
				d['head'] = d['data'];
			}
			var str = '<div class="form-group">'+
											'<div class="col-md-'+d['label']+'"><label>'+d['head']+'：</label></div>'+
											'<div class="col-md-'+d['form']+'">'+
											'<input type="text" class="form-control '+d['type']+'" name="'+d['data']+'" />'+
											'</div>'+
										'</div>';

			return str;
		}
		var modalLine = function(d){
    	//TODO 每条编辑框
    	if (d.hasOwnProperty('parent')) {
    		var cl = 'col-md-'+d['parent'];
    	} else{
    		var cl = 'col-md-12';
    	}
      var str = '<div class="'+cl+'">';

      if(d['type'] == 'textarea'){
				str += eachText(d);
      }else if (d['type'] == 'checkbox') {
				str += eachCheckbox(d);
      }else if (d['type'] == 'select') {
				str += eachSelect(d);
      }else if(d['type'] == 'file'){
      	str += eachFile(d);
      }else if(d['type'] == 'timeSingle' || d['type'] == 'timeRange'){
      	str += eachTime(d);
      }else{
      	str += eachInput(d);
      }

      str += '</div>';
      return str;
    }
    var easyInput = function(d){
    	var str = '<input name="'+d['data']+'" type="hidden" class="form-control" placeholder="" value="" />';

    	return str;
    }
    var headTabs = function(d, struct){
    	var str = '';
    	str += '<ul class="nav nav-tabs">';
    			for (var i = 0; i < struct.length; i++) {
    				var theStruct = struct[i];
    				if(i == 0){
    					str += '<li class="active"><a href="#tab_'+i+'" data-toggle="tab">'+theStruct['tabs']+'</a></li>';
    				}else{
    					str += '<li><a href="#tab_'+i+'" data-toggle="tab">'+theStruct['tabs']+'</a></li>';
    				}
    			}
    	str += '</ul>';

    	return str;
    }
    var bodyTabs = function(d, struct, i){
    	var str = '';
    	if (i == 0) {
    		str += '<div class="tab-pane active row" id="tab_'+i+'">';
    	} else{
    		str += '<div class="tab-pane row" id="tab_'+i+'">';
    	}
    	if (struct['columns'].length > 0) {
    			for (var i = 0; i < struct['columns'].length; i++) {
    				var theCol = struct['columns'][i];
    				if (theCol.hasOwnProperty('data')) {
    					if (theCol.hasOwnProperty('label')) {
    						if (theCol.hasOwnProperty('form')) {
    							str += modalLine(theCol);
    						} else{
    							continue;
    						}
    					} else{
    						if (theCol.hasOwnProperty('form') && theCol['form'] == 'hide') {
    							str += easyInput(theCol);
    						} else{
    							continue;
    						}
    					}
    				} else{
    					continue;
    				}
    			}
    		} else{

    		}

    	str += '</div>';

    	return str;
    }
    var bodyNotab = function(d, struct){
    	var str = '<div class="modal-body"><div class="row">';
    		//TODO 没有tabs
    		if (struct['columns'].length > 0) {
    			for (var i = 0; i < struct['columns'].length; i++) {
    				var theCol = struct['columns'][i];
    				// console.log(theCol);
    				if (theCol.hasOwnProperty('data')) {
    					if (theCol.hasOwnProperty('label')) {
    						if (theCol.hasOwnProperty('form')) {
    							str += modalLine(theCol);
    						} else{
    							continue;
    						}
    					} else{
    						if (theCol.hasOwnProperty('form') && theCol['form'] == 'hide') {
    							str += easyInput(theCol);
    						} else{
    							continue;
    						}
    					}
    				} else{
    					continue;
    				}
    			}
    		} else{

    		}
    		str += '</div></div>';

    	return str;
    }
    var modalBody = function(d, struct){
    	//TODO 循环得出具体样式
    	//TODO 分两种，一种是直接添加html样式，一种是根据规则布局html样式
    	//TODO tabs要考虑
    	console.log(struct);
    	if(struct.hasOwnProperty('tabs')){
    		//TODO 有tabs
    		var str = bodyTabs(d, struct);
    	}else{
    		var str = bodyNotab(d, struct);
    	}
    	return str;
    }
    var modalHead = function(d){
    	var str = '<div class="modal-header">'+
								'<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>'+
								'<h4 class="modal-title">'+d['title']+'</h4>'+
							'</div>';
			return str;
    }
    var modalFootSubmit = function(d){
    	var str = '<div class="modal-footer">'+
								'<button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>'+
								'<button type="submit" class="btn btn-primary btn-save">保存</button>'+
							'</div>';

			return str;
    }
    var modalFootAjax = function(d){
    	var str = '<div class="modal-footer">'+
								'<button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>'+
								'<button type="button" class="btn btn-primary btn-save">保存</button>'+
							'</div>';

			return str;
    }
    var modalHtml = function(d, struct){
    	var str = '<div class="modal" id="'+d['id']+'"><div class="modal-dialog">';
    	//TODO 分两种，有form和普通div结构
    		str += '<div class="modal-content form-horizontal">'
    		//TODO 补充页面
    		str += modalHead(d);
    		if (struct.length > 0) {
    			//如果有tab，则先做tab
    			if(struct[0].hasOwnProperty('tabs')){
    				str += '<div class="modal-body"><div class="nav-tabs-custom">';
    				str += headTabs(d, struct);
    				str += '<div class="tab-content">';
	    			for (var i = 0; i < struct.length; i++) {
	    				var theStruct = struct[i];
			    		str += bodyTabs(d, theStruct, i);
	    			}
	    			str += '</div>';
    				str += '</div></div>';
    			}else{
    				for (var i = 0; i < struct.length; i++) {
	    				var theStruct = struct[i];
			    		str += bodyNotab(d, theStruct);
	    			}
    			}
    		} else{

    		}
    		str += modalFootAjax(d);
    		str += '</div>'
    	str += '</div></div>';
    	return str;
    }
    _dataModal.struct = function(){
      var baseStr = "";
			if($data['id'] != undefined && $data['id'] != ''){
        //TODO 慢慢从创建开始
        var dd = $data;
        var lay = $data['columns'];
        var struct = $data['struct'];
        baseStr += modalHtml(dd, struct);
      }else {

      }
      return baseStr;
    }
    var submitData = function(){
    	//TODO get data before submit
    	var _d = {};
    	$('#'+$data['id']).find("input[name!=undefined]").each(function(){
    		console.log('this is'+$(this).attr('name'));

    		var _t = $(this);
    		if(_t.attr('type') == 'file'){
					//  			_d[$(this).attr('name')] = $(this).val();
    		}else if (_t.attr('type') == 'checkbox') {
    			_d[$(this).attr('name')] = $(this).prop('checked');
    		} else{
    			_d[$(this).attr('name')] = $(this).val();
    		}
    	});
    	$('#'+$data['id']).find("select[name!=undefined]").each(function(){
				_d[$(this).attr('name')] = $(this).val();
    	});
    	$('#'+$data['id']).find("textarea[name!=undefined]").each(function(){
				_d[$(this).attr('name')] = $(this).val();
    	});
    	return _d;
    }
    _dataModal.doSubmit = function(){
    	//.btn-save
    	// console.log($data);
    	$('#'+$data['id']).on('click', '.btn-save', function(){
    		var subData = submitData();
    		console.log(subData);
    		$.ajax({
    			url: $data['action'],
    			type:'post',
    			data:	subData,
    			dataType:	'json',
    			success: function(res){
						//$(this).addClass("done");
						easyAlert.timeShow({
					    	'type':	'info',
					    	'content':	res.msg,
					    	'duration':	2,
					  });
						$data['success'](res);
      		},
    		});
    	});
    }

    return _dataModal;
  },
	controls:	function($ctrl){
		var buildModal = $ctrl['buildModal'] || true;
		var content = $ctrl['content'] || null;
		var table = $ctrl['table'] || null;
		var modal = $ctrl['modal'] || null;
		var modalAction = $ctrl['modalAction'] || '/post';
		var addAction = $ctrl['addAction'] || '/post';
		var editAction = $ctrl['editAction'] || '/post';
		var hasTime = $ctrl['hasTime'] || false;
		var hasCheckBox = $ctrl['hasCheckBox'] || false;
		var submitType = $ctrl['submitType'] || "form";
    var beforeSubmit = $ctrl['beforeSubmit'] || null;
		var submitCallback = $ctrl['submitCallback'] || function(){};
    var valiConfig = this.controls.valiConfig = $ctrl['valiConfig'] || null;
    var beforeShow = $ctrl['beforeShow'] || null;
		var afterShow = $ctrl['afterShow'] || null;
		var _btns = {
			reload:	$ctrl['reloadBtn'] || ".btn-reload",
			add:	$ctrl['addBtn'] || ".btn-add",
			edit:	$ctrl['editBtn'] || ".btn-edit",
			submit:$ctrl['submitBtn'] || ".btn-save",
		};
		if (buildModal) {
			_modal = $('#'+modal);
			_content = $('#'+content);
			var _form = _modal.find('form');
			if(modalAction){
				_form.attr({
					action:modalAction,
				});
			}
			if (hasTime) {
				if($(".timeSingle").length > 0){
					var dateConfig = {
						'type':'single',//类型，range或者single或者default
						'pluginConfig':{},//时间样式配置
						'dateId':'.timeSingle',//选择的位置
					}
					datePackage.init(dateConfig);
				}
				if($(".timeRange").length > 0){
					var dateConfig = {
						'type':'range',//类型，range或者single或者default
						'pluginConfig':{},//时间样式配置
						'dateId':'.timeRange',//选择的位置
					}
					datePackage.init(dateConfig);
				}
			}
			if (hasCheckBox) {
				//如果有checkbox，要加这段js //强制加，有bug再说
				$('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
					checkboxClass: 'icheckbox_flat-green',
					radioClass: 'iradio_flat-green'
				});
			}
			if(valiConfig && valiConfig.validate.length > 0){
				//console.log(valiConfig);
				var _state = {}, _c = {};
				_c['rules'] = {}, _c['messages'] = {};
				for(var e in valiConfig){
					if(e != 'validate' && e != 'callback'){
						_state[e] = valiConfig[e];
					}
				}
				for(var i = 0; i < valiConfig.validate.length; i++){
					var _vali = valiConfig.validate[i];
					_c['rules'][_vali.name] = {},
          _c['messages'][_vali.name] = {};
					_c['rules'][_vali.name]['required'] = true;
					_c['messages'][_vali.name]['required'] = _vali.tips;
          if (_vali.name == "email") {
            _c['rules'][_vali.name]['email'] = true;
            _c['messages'][_vali.name]['email'] = "格式不正确";
          }else if(_vali.name == "password" || _vali.name == "repassword"){
            _c['rules'][_vali.name]['minlength'] = 5;
            _c['messages'][_vali.name]['minlength'] = "密码不能小于5位";
            if (_vali.name == "repassword") {
              _c['rules'][_vali.name]['equalTo'] = "#password";
              _c['messages'][_vali.name]['equalTo'] = "两次输入密码不一致";
            }
          }
				}
				_state['config'] = _c;
				if(valiConfig.callback){
					_state['call'] = valiConfig.callback;
				}
				//console.log(_state);
				try{
					validatePackage.init(_state);
				}catch(e){
					//TODO handle the exception
					console.log(e);
				}
			}
			var addDialog = function(){
				_content.on('click', _btns.add, function(){
          _form.find(".form-group").removeClass("has-error");
					_form.find(".help-block").remove();
          if (typeof (beforeShow) == "function")
					{
						if (!beforeShow()) return false;
					}
					if (_form.length > 0) {
						_form.attr({
							action:addAction,
						});
					}
					_modal.find('input, textarea, select').each(function(){
						$(this).val('');
					});
					_modal.modal();
          if (typeof (afterShow) == "function") {
						afterShow();
					}
					return false;
				});
			};

			var setValToModal = function(_data){
				for (var e in _data) {
					if (_data.hasOwnProperty(e)) {
						var _s = _modal.find('[name='+e+']');
						if(_s.length > 0){
							var _val = _data[e];
							//console.log(_s.prop("nodeName"));
							if(_s.prop("nodeName") != 'TEXTAREA' && _s.prop('nodeName') != "SELECT"){
								if(_s.attr('type') == "checkbox"){
									// console.log(_t.find('div').length);
									if(parseInt(_val) > 0 && _val != undefined && _val != ''){
										_s.prop('checked', true);
										try {
											_s.iCheck('check');
										} catch (e) {

										}
									}else{
										_s.prop('checked', false);
										try {
											_s.iCheck('uncheck');
										} catch (e) {

										}
									}
								}else if(_s.attr('type') == "file"){

								}else{
									_s.val(_val);
								}
							}else if(_s.prop('nodeName') == "SELECT") {
								// console.log(_s);
								_s.val(_val);
							}else{
								if (_s.className('ckEditor')) {
									var editorElement = CKEDITOR.document.getById(_s.attr('id'));
									editorElement.setHtml(_val);
								} else{
									_s.val(_val);
								}
							}
						}
					}
				}
			};

			var editDialog = function(){
				// var editBtn = $config['editBtn'];
				_content.on("click", _btns.edit, function(){
					// var _form = _modal.find('form');
          _form.find(".form-group").removeClass("has-error");
          _form.find(".help-block").remove();
					if (_form.length > 0) {
						_form.attr({
							action:editAction,
						});
					}
					var $d = tablePackage.selectSingle();
          if (typeof (beforeShow) == "function") {
						if (!beforeShow($d)) return false;
					}
					if (JSON.stringify($d) != "{}") {
						// console.log($d);
						setValToModal($d);
						_modal.modal();
					}else {
						// console.log($d);
					}
          if (typeof (afterShow) == "function") {
						afterShow($d);
					}
					return false;
				});
			};

			var doSubmit = function(){
				if (submitType == "form") {

				}else {
					_form.attr("onsubmit", "return false;");
				}
				_modal.on("click", _btns.submit, function(){
          if (typeof (beforeSubmit) == "function") {
						if (!beforeSubmit()) return false;
					}
					console.log(submitType);
					var _ts = $(this);
					if (submitType == "form") {
						//
						if(_ts.attr('type') != "submit"){
							_form.submit();
						}
					}else {

					}
					submitCallback(this);
				});
			};

			addDialog();
			editDialog();
			doSubmit();
		} else {

		}
	}
}

var validatePackage = function() {
    var handleSubmit = function(model, config, call) {
		    var validateConfig = {
            errorElement : 'span',
            // errorClass : 'help-block col-md-12',
            errorClass : 'help-block',
            focusInvalid : false,
            rules : {

            },
            messages : {

            },
            invalidHandler: function (event, validator) { //display error alert on form submit
              //当未通过验证的表单提交时，可以在该回调函数中处理一些事情。该回调函数有两个参数：第一个为一个事件对象，第二个为验证器（validator）
            },
            highlight : function(element) {
                $(element).closest('.form-group').addClass('has-error');
            },
            success : function(label) {
                label.closest('.form-group').removeClass('has-error');
                label.remove();
            },
            errorPlacement : function(error, element) {
							//error是错误提示元素span对象  element是触发错误的input对象
        			//发现即使通过验证 本方法仍被触发
        			//当通过验证时 error是一个内容为空的span元素

								// element.append(error);
								if(element.is('input[type=checkbox]') || element.is('input[type=radio]')) {
									var controls = element.closest('div[class*="col-"]');
									if(controls.find(':checkbox,:radio').length > 1)	 controls.append(error);
									else error.insertAfter(element.nextAll('.lbl:eq(0)').eq(0));
								}else if(element.is('.select2')) {
									error.insertAfter(element.siblings('[class*="select2-container"]:eq(0)'));
								}else if(element.is('.chosen-select')) {
									error.insertAfter(element.siblings('[class*="chosen-container"]:eq(0)'));
								}else {
									// error.insertAfter(element.parent())
									element.parent('div').append(error);
								};
            },

            submitHandler : function(form) {
                //form.submit();
                if(call != undefined){
              		call(form);
                }
            }
        }
				//
				for (var e in config) {
					if (config.hasOwnProperty(e)) {
						validateConfig[e] = config[e];
					}
				}
				//
        $(model).validate(validateConfig);

        $(model+' input').keypress(function(e) {
            if (e.which == 13) {
                if ($(model).validate().form()) {
                    $(model).submit();
                }
                return false;
            }
        });
    }
    return {
        init : function(data) {
            handleSubmit(data['model'], data['config'], data['call']);
        }
    };

}();
