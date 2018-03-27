var easyAlert = {
	/*
	 * d{
	 * 	type, content, others
	 * }
	 */
	locationShow:	function(d){
		var _html = easyAlert.buildLocation(d);
		$(d['to']).append(_html);
		var _t = $(_html);
		_t.modal();
		if(d['duration']){
			setTimeout(function(){
				_t.modal('hide');
			}, parseInt(d['duration'])*1000);
		}
	},
	timeShow:	function(d){
		var _html = easyAlert.buildModal(d);
		$('body').append(_html);
		var _t = $(_html);
		_t.modal();
		if(!d['duration']){
			d['duration'] = 2000;
		}
		setTimeout(function(){
			_t.modal('hide');
		}, parseInt(d['duration'])*1000);
	},
	createOne:	function(d){
		switch (d['type']){
			case 'danger':
				d['class'] = 'alert-danger';
				break;
			case 'info':
				d['class'] = 'alert-info';
				break;
			case 'warn':
				d['class'] = 'alert-warning';
				break;
			case 'success':
				d['class'] = 'alert-success';
				break;

			default:
				d['class'] = 'alert-info';
				break;
		}
		var str = '<div class="alert '+d['class']+' alert-dismissible">'+
                '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>'+
                '<p>'+d['content']+'</p>'+
              '</div>';
		return str;
	},
	buildModal:	function(d){
		var str = '<div class="modal fade">'+
          '<div class="modal-dialog">';
			str += easyAlert.createOne(d);
        str += '</div>';

        return str;
	},
	buildLocation:	function(d){
		var str = easyAlert.createOne(d);
		return str;
	}
}
var easyConfirm = {
	/*
	 * d{
	 * 	type, content, others
	 * }
	 */
	locationShow:	function(d){
		var _html = easyConfirm.buildModal(d);
		$('body').append(_html);
		var _t = $(_html);
		_t.modal();
		_t.on('click', '.btn-save', function(){
			try {
				d['callback'](this);
			} catch (e) {
			}
		});
	},
	createOne:	function(d){
		switch (d['type']){
			case 'danger':
				d['class'] = 'alert-danger';
				break;
			case 'info':
				d['class'] = 'alert-info';
				break;
			case 'warn':
				d['class'] = 'alert-warning';
				break;
			case 'success':
				d['class'] = 'alert-success';
				break;

			default:
				d['class'] = undefined;
				break;
		}
		var str = '<div class="alert '+d['class']+' alert-dismissible">'+
                '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>'+
                '<h4>'+d['type']+'</h4>'+
                '<p>'+d['content']+'</p>'+
              '</div>';
		return str;
	},
	buildModal:	function(d){
		switch (d['type']){
			case 'danger':
				d['class'] = 'modal-danger';
				break;
			case 'info':
				d['class'] = 'modal-info';
				break;
			case 'warn':
				d['class'] = 'modal-warning';
				break;
			case 'success':
				d['class'] = 'modal-success';
				break;

			default:
				d['class'] = undefined;
				break;
		}
		var str = '<div class="Confirm_Div modal fade '+d['class']+'">'+
        	'<div class="modal-dialog">'+
            '<div class="modal-content">'+
              '<div class="modal-header">'+
                '<button type="button" class="close" data-dismiss="modal" aria-label="Close">'+
                  '<span aria-hidden="true">×</span></button>'+
                '<h4 class="modal-title">'+d['title']+'</h4>'+
              '</div>'+
              '<div class="modal-body">'+
                '<p>'+d['content']+'</p>'+
              '</div>'+
              '<div class="modal-footer">';
              	if (d['class'] != undefined) {
              		str += '<button type="button" class="btn btn-outline pull-left" data-dismiss="modal">取消</button>'+
                '<button type="button" class="btn btn-save btn-outline">确定</button>';
              	} else{
              		str += '<button type="button" class="btn btn-default pull-left" data-dismiss="modal">取消</button>'+
                '<button type="button" class="btn btn-save btn-primary">确定</button>';
              	}

              str += '</div>';
            str += '</div>';

        str += '</div>';

        return str;
	},
}

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
				autoclose: true,
				language: "zh-CN"
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
var adaptionHeight = function(){
	var _pageH = $(document).height();
	//console.log("document height"+_pageH);
    if (window.parent) {
      	//console.log(window.parent);
      			//$('#id', window.parent.document)
      	var _parentIfm = $('#iframe_box', window.parent.document);
      	if (_parentIfm.height() < _pageH) {
        	_parentIfm.css({'height':_pageH+5,});
      	} else{

      	}
      	//console.log(_parentIfm.height());
    }
}


/**loading**/
window.ZENG=window.ZENG || {};

ZENG.dom = {getById: function(id) {
        return document.getElementById(id);
    },get: function(e) {
        return (typeof (e) == "string") ? document.getElementById(e) : e;
    },createElementIn: function(tagName, elem, insertFirst, attrs) {
        var _e = (elem = ZENG.dom.get(elem) || document.body).ownerDocument.createElement(tagName || "div"), k;
        if (typeof (attrs) == 'object') {
            for (k in attrs) {
                if (k == "class") {
                    _e.className = attrs[k];
                } else if (k == "style") {
                    _e.style.cssText = attrs[k];
                } else {
                    _e[k] = attrs[k];
                }
            }
        }
        insertFirst ? elem.insertBefore(_e, elem.firstChild) : elem.appendChild(_e);
        return _e;
    },getStyle: function(el, property) {
        el = ZENG.dom.get(el);
        if (!el || el.nodeType == 9) {
            return null;
        }
        var w3cMode = document.defaultView && document.defaultView.getComputedStyle, computed = !w3cMode ? null : document.defaultView.getComputedStyle(el, ''), value = "";
        switch (property) {
            case "float":
                property = w3cMode ? "cssFloat" : "styleFloat";
                break;
            case "opacity":
                if (!w3cMode) {
                    var val = 100;
                    try {
                        val = el.filters['DXImageTransform.Microsoft.Alpha'].opacity;
                    } catch (e) {
                        try {
                            val = el.filters('alpha').opacity;
                        } catch (e) {
                        }
                    }
                    return val / 100;
                } else {
                    return parseFloat((computed || el.style)[property]);
                }
                break;
            case "backgroundPositionX":
                if (w3cMode) {
                    property = "backgroundPosition";
                    return ((computed || el.style)[property]).split(" ")[0];
                }
                break;
            case "backgroundPositionY":
                if (w3cMode) {
                    property = "backgroundPosition";
                    return ((computed || el.style)[property]).split(" ")[1];
                }
                break;
        }
        if (w3cMode) {
            return (computed || el.style)[property];
        } else {
            return (el.currentStyle[property] || el.style[property]);
        }
    },setStyle: function(el, properties, value) {
        if (!(el = ZENG.dom.get(el)) || el.nodeType != 1) {
            return false;
        }
        var tmp, bRtn = true, w3cMode = (tmp = document.defaultView) && tmp.getComputedStyle, rexclude = /z-?index|font-?weight|opacity|zoom|line-?height/i;
        if (typeof (properties) == 'string') {
            tmp = properties;
            properties = {};
            properties[tmp] = value;
        }
        for (var prop in properties) {
            value = properties[prop];
            if (prop == 'float') {
                prop = w3cMode ? "cssFloat" : "styleFloat";
            } else if (prop == 'opacity') {
                if (!w3cMode) {
                    prop = 'filter';
                    value = value >= 1 ? '' : ('alpha(opacity=' + Math.round(value * 100) + ')');
                }
            } else if (prop == 'backgroundPositionX' || prop == 'backgroundPositionY') {
                tmp = prop.slice(-1) == 'X' ? 'Y' : 'X';
                if (w3cMode) {
                    var v = ZENG.dom.getStyle(el, "backgroundPosition" + tmp);
                    prop = 'backgroundPosition';
                    typeof (value) == 'number' && (value = value + 'px');
                    value = tmp == 'Y' ? (value + " " + (v || "top")) : ((v || 'left') + " " + value);
                }
            }
            if (typeof el.style[prop] != "undefined") {
                el.style[prop] = value + (typeof value === "number" && !rexclude.test(prop) ? 'px' : '');
                bRtn = bRtn && true;
            } else {
                bRtn = bRtn && false;
            }
        }
        return bRtn;
    },getScrollTop: function(doc) {
        var _doc = doc || document;
        return Math.max(_doc.documentElement.scrollTop, _doc.body.scrollTop);
    },getClientHeight: function(doc) {
        var _doc = doc || document;
        return _doc.compatMode == "CSS1Compat" ? _doc.documentElement.clientHeight : _doc.body.clientHeight;
    }
};

ZENG.string = {RegExps: {trim: /^\s+|\s+$/g,ltrim: /^\s+/,rtrim: /\s+$/,nl2br: /\n/g,s2nb: /[\x20]{2}/g,URIencode: /[\x09\x0A\x0D\x20\x21-\x29\x2B\x2C\x2F\x3A-\x3F\x5B-\x5E\x60\x7B-\x7E]/g,escHTML: {re_amp: /&/g,re_lt: /</g,re_gt: />/g,re_apos: /\x27/g,re_quot: /\x22/g},escString: {bsls: /\\/g,sls: /\//g,nl: /\n/g,rt: /\r/g,tab: /\t/g},restXHTML: {re_amp: /&amp;/g,re_lt: /&lt;/g,re_gt: /&gt;/g,re_apos: /&(?:apos|#0?39);/g,re_quot: /&quot;/g},write: /\{(\d{1,2})(?:\:([xodQqb]))?\}/g,isURL: /^(?:ht|f)tp(?:s)?\:\/\/(?:[\w\-\.]+)\.\w+/i,cut: /[\x00-\xFF]/,getRealLen: {r0: /[^\x00-\xFF]/g,r1: /[\x00-\xFF]/g},format: /\{([\d\w\.]+)\}/g},commonReplace: function(s, p, r) {
        return s.replace(p, r);
    },format: function(str) {
        var args = Array.prototype.slice.call(arguments), v;
        str = String(args.shift());
        if (args.length == 1 && typeof (args[0]) == 'object') {
            args = args[0];
        }
        ZENG.string.RegExps.format.lastIndex = 0;
        return str.replace(ZENG.string.RegExps.format, function(m, n) {
            v = ZENG.object.route(args, n);
            return v === undefined ? m : v;
        });
    }};

ZENG.object = {
	routeRE: /([\d\w_]+)/g,
	route: function(obj, path) {
        obj = obj || {};
        path = String(path);
        var r = ZENG.object.routeRE, m;
        r.lastIndex = 0;
        while ((m = r.exec(path)) !== null) {
            obj = obj[m[0]];
            if (obj === undefined || obj === null) {
                break;
            }
        }
        return obj;
    }};

var ua = ZENG.userAgent = {}, agent = navigator.userAgent;
ua.ie = 9 - ((agent.indexOf('Trident/5.0') > -1) ? 0 : 1) - (window.XDomainRequest ? 0 : 1) - (window.XMLHttpRequest ? 0 : 1);

if (typeof (ZENG.msgbox) == 'undefined') {
    ZENG.msgbox = {};
}
ZENG.msgbox._timer = null;
ZENG.msgbox.loadingAnimationPath = ZENG.msgbox.loadingAnimationPath || ("loading.gif");
ZENG.msgbox.show = function(msgHtml, type, timeout, opts) {
    if (typeof (opts) == 'number') {
        opts = {topPosition: opts};
    }
    opts = opts || {};
    var _s = ZENG.msgbox,
	 template = '<span class="zeng_msgbox_layer" style="display:none;z-index:10000;" id="mode_tips_v2"><span class="gtl_ico_{type}"></span>{loadIcon}{msgHtml}<span class="gtl_end"></span></span>', loading = '<span class="gtl_ico_loading"></span>', typeClass = [0, 0, 0, 0, "succ", "fail", "clear"], mBox, tips;
    _s._loadCss && _s._loadCss(opts.cssPath);
    mBox = ZENG.dom.get("q_Msgbox") || ZENG.dom.createElementIn("div", document.body, false, {className: "zeng_msgbox_layer_wrap"});
    mBox.id = "q_Msgbox";
    mBox.style.display = "";
    mBox.innerHTML = ZENG.string.format(template, {type: typeClass[type] || "hits",msgHtml: msgHtml || "",loadIcon: type == 6 ? loading : ""});
    _s._setPosition(mBox, timeout, opts.topPosition);
};
ZENG.msgbox._setPosition = function(tips, timeout, topPosition) {
    timeout = timeout || 5000;
    var _s = ZENG.msgbox, bt = ZENG.dom.getScrollTop(), ch = ZENG.dom.getClientHeight(), t = Math.floor(ch / 2) - 40;
    ZENG.dom.setStyle(tips, "top", ((document.compatMode == "BackCompat" || ZENG.userAgent.ie < 7) ? bt : 0) + ((typeof (topPosition) == "number") ? topPosition : t) + "px");
    clearTimeout(_s._timer);
    tips.firstChild.style.display = "";
    timeout && (_s._timer = setTimeout(_s.hide, timeout));
};
ZENG.msgbox.hide = function(timeout) {
    var _s = ZENG.msgbox;
    if (timeout) {
        clearTimeout(_s._timer);
        _s._timer = setTimeout(_s._hide, timeout);
    } else {
        _s._hide();
    }
};
ZENG.msgbox._hide = function() {
    var _mBox = ZENG.dom.get("q_Msgbox"), _s = ZENG.msgbox;
    clearTimeout(_s._timer);
    if (_mBox) {
        var _tips = _mBox.firstChild;
        ZENG.dom.setStyle(_mBox, "display", "none");
    }
};

/*
设置赋值绑定方法
*/
var PageValueControl = {
	init:	function(modal_id, data, config){
		//modal_id是form id
		var $this = {};
		var _this = this;
		var $data = data || {},
				$state = config || {},
				$modalId = modal_id || "";
		//
		var $modal = $("#"+modal_id);
		$this.data = $data;
		if ($modal.length > 0) {
			$this.modal = $modal;
			$this.disableAll = function(){
				$this.modal.find('input').each(function(){
					$(this).attr("disabled", true);
				});
				$this.modal.find('select').each(function(){
					$(this).attr("disabled", true);
				});
				$this.modal.find('textarea').each(function(){
					$(this).attr("disabled", true);
				});
			}
			$this.disableForm = function(data){
				for (var e in data) {
					if (data.hasOwnProperty(e)) {
						var _s = $this.modal.find('[name=' + e + ']');
						if (_s.length == 0) {
							_s = $this.modal.find("#" + e);
						}
						if (_s.length > 0) {
							_s.attr("disabled", data[e]);
						}
					}
				}
			}
			$this.setFormData = function (_data) {
				if (_data) {
					var data = _data;
					$this.data = data;
				}else {
					var data = $this.data;
				}
					var tablemodel_id = $modalId;
					for (var e in data) {
						if (data.hasOwnProperty(e)) {
							var _s = $this.modal.find('[name=' + e + ']');
							if (_s.length == 0) {
								_s = $this.modal.find("#" + e);
							}
							if (_s.length > 0) {
								var _val = data[e];
								if (_s.prop("nodeName") != 'TEXTAREA' && _s.prop('nodeName') != "SELECT") {
									if (_s.attr('type') == "checkbox") {
										if (parseInt(_val) > 0 && _val != undefined && _val != '') {
											_s.prop('checked', true);
											try {
												_s.iCheck('check');
											} catch (e) {
												console.log(e);
											}
										} else {
											_s.prop('checked', false);
											try {
												_s.iCheck('uncheck');
											} catch (e) {
												console.log(e);
											}
										}
									} else if (_s.attr('type') == "file") {
										console.log("file");
									} else if (_s.attr('type') == "radio") {
										if (_val)
											$this.modal.find('[name=' + e + '][value=' + _val + ']').prop("checked", "checked");
									} else {
										if (_s[0]["nodeName"] == "P")
											_s.text(_val);
										else
											_s.val(_val);
									}
								} else if (_s.prop('nodeName') == "SELECT") {
									_s.val(_val);
								} else {
									if (_s.hasClass('ckEditor')) {
										var editorElement = CKEDITOR.document.getById(_s.attr('id'));
										editorElement.setHtml(_val);
									} else {
										_s.val(_val);
									}
								}
							}
						}
					}
			}
			$this.reset = function(){
				try {
					document.getElementById($modalId).reset();
				} catch (e) {
					console.log(e);
					$modal.find('input, textarea').each(function(){
						$(this).val("");
						if ($(this).attr('type') == "checkbox") {
							$(this).prop('checked', false);
							try {
								$(this).iCheck('uncheck');
							} catch (e) {
								//console.log(e);
							}
						}
					});
				}
			}
		}
		return $this;
	},

}
/*
审核流转跟踪公共界面
*/
var _m_wfklog_list;
var WfkLog = {
	process: false,
	setProcess: function(type){
		tablePackage.process = type;
	},
	createOne:	function(data){
		var $this = {};
		var _this = this;
		var $data = data, $state = {};
		//table thead
		$this.buildHtml = function(){
			var str = "";
			var _config = $data.modalAttr || {};
			var buildbody = function(){
				var body = '\
                <table id="tablelist_history" class="table table-bordered table-striped table-hover">\
                                </table>\
				';

				return body;
			}
			str ='<div class="modal" id="'+_config.id+'">';
			str +='\
		          	<div class="modal-dialog" style="width: 60%">\
			            <form action="#" method="post" name="form" class="modal-content" onsubmit="">\
			              	<div class="modal-body">\
			';
			str += buildbody();
			str += '\
			              	</div>\
			              	<div class="modal-footer">\
			                	<button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>\
			              	</div>\
			            </form>\
			        </div>\
			    </div>\
			';

			return str;
		}
		$this.buildInto = function(){
			var html = $this.buildHtml();
			$("body").append(html);
			$state.modal = $("#"+$data.modalAttr.id);
			$state.form = $state.modal.find("form");
			try{
                        //配置表格列
            tablePackageMany.filed = [
                    { "data": "DECLARE_TYPE", "head": "申请类型" },
           			{ "data": "RET_CHANNEL", "head": "状态结果" },
                    { "data": "OP_USER", "head": "操作人" },
                    { "data": "POST_CODE", "head": "操作角色" },
                    { "data": "OP_TIME", "head": "操作时间" },
                    { "data": "OP_NOTES", "head": "操作说明" }
		    ];

            //配置表格
            _m_wfklog_list = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/Common/ComPage/WkfLogList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_history", //表格id
                    buttonId: "buttonId_history", //拓展按钮区域id
                    tableTitle: "审批流程跟踪",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true//用户改变分页
                    }
                },
                //查询栏
                hasSearch: {
                },
                hasModal: false, //弹出层参数
                hasBtns: [], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
			}catch(e){
				//TODO handle the exception
			}
		}
		$this.controls = function(){
			var _config = $data.modalAttr;
			var _ctrl = $data.control;
			if (_ctrl.btnId != undefined && $state.modal.length > 0) {
				$(_ctrl.content).on("click", _ctrl.btnId, function(){
					if (_ctrl.beforeShow && typeof (_ctrl.beforeShow) == "function") {
						_ctrl.beforeShow(this, $state.form);
					}
					$state.modal.modal();
					if (_ctrl.afterShow && typeof (_ctrl.afterShow) == "function") {
						_ctrl.afterShow(this, $state.form);
					}
				});
				$state.modal.on("click", ".btn-save", function(){
					if (_ctrl.beforeSubmit && typeof (_ctrl.beforeSubmit) == "function") {
						_ctrl.beforeSubmit();
					}
				});
			}
		}
		$this.init = function(){
			$this.buildInto();
			$this.controls();
		}
		$this.init();
		return $this;
	}
}

/*
审核（通过/不通过）公共界面
*/
var approveComPage = {
	process: false,
	setProcess: function(type){
		tablePackage.process = type;
	},
	createOne:	function(data){
		var $this = {};
		var _this = this;
		var $data = data, $state = {};
		// console.log(data);

		//table thead
		$this.buildHtml = function(){
			var str = "";
			var _config = $data.modalAttr || {};
			var buildbody = function(){
				var body = '\
						<div class="form-group">\
		                	<label>审核结果</label>\
		                  	<div class="form-control no-border">\
		                  		<div class="col-xs-12">\
			                  		<input type="radio" id="approvePass" class="flat-red" value="P" name="approveType" checked />\
                                    <label for="approvePass" id="lab_approvePass" style="margin-right: 10px;">通过</label>\
			                  		<span>&nbsp;&nbsp;</span>\
			                  		<input type="radio" id="approveNoPass" class="flat-red" value="N" name="approveType" />\
                                    <label for="approveNoPass" id="lab_approveNoPass" style="margin-right: 10px;">不通过</label>\
			                  	</div>\
		                  	</div>\
		                </div>\
		                <div class="form-group">\
		                	<label>审核信息</label>\
		                	<textarea class="form-control" name="approveMsg" rows="5" cols="" maxlength="100" ></textarea>\
		                </div>\
				';

				return body;
			}
			str ='<div class="modal" id="'+_config.id+'">';
			str +='\
		          	<div class="modal-dialog">\
			            <form action="#" method="post" id="form_approve" name="form_approve" class="modal-content" onsubmit="">\
			              	<div class="modal-header">\
				                <button type="button" class="close" data-dismiss="modal" aria-label="Close">\
				                  	<span aria-hidden="true">×</span>\
				                </button>\
				                <h4 class="modal-title">审核信息</h4>\
			              	</div>\
			              	<div class="modal-body">\
			';
			str += buildbody();
			str += '\
			              	</div>\
			              	<div class="modal-footer">\
			                	<button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>\
			                	<button type="button" class="btn btn-primary btn-save">确认</button>\
			              	</div>\
			            </form>\
			        </div>\
			    </div>\
			';

			return str;
		}
		$this.buildInto = function(){
			var html = $this.buildHtml();
			//console.log(html);
			$("body").append(html);
			$state.modal = $("#"+$data.modalAttr.id);
			$state.form = $state.modal.find("form");
			try{
				$('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
	      			checkboxClass: 'icheckbox_flat-green',
	      			radioClass: 'iradio_flat-green'
	    		});
			}catch(e){
				//TODO handle the exception
			}
		}
		$this.controls = function(){
			var _config = $data.modalAttr;
			var _ctrl = $data.control;
			if (_ctrl.btnId != undefined && $state.modal.length > 0) {
				$(_ctrl.content).on("click", _ctrl.btnId, function(){
					if (_ctrl.beforeShow && typeof (_ctrl.beforeShow) == "function") {
						if (!_ctrl.beforeShow(this, $state.form))
                            return false;
					}
					$state.modal.modal();
					if (_ctrl.afterShow && typeof (_ctrl.afterShow) == "function") {
						if (!_ctrl.afterShow(this, $state.form))
                             return false;
					}
				});
				$state.modal.on("click", ".btn-save", function(){
					if (_ctrl.beforeSubmit && typeof (_ctrl.beforeSubmit) == "function") {
						if (!_ctrl.beforeSubmit(this, $state.form))
                            return false;
					}
					$state.form.submit();
				});
				//validate
				$this.valid(_ctrl.validCallback);
			}
		}
		$this.setVerifyMsg = function(str){//填写审核信息
			var _text = $state.form.find("textarea[name=approveMsg]");
			if (_text.length > 0) {
				_text.val(str);

				return true;
			}
			return false;
		}
		$this.getData = function(){//获取form下所有的data
			var ds = {};
			var seri = $state.form.serialize();
		    var farr = seri.split("&");
		    for(var i = 0; i < farr.length; i++){
		    	var eh = farr[i];
		    	var ear = eh.split("=");
		    	if(ear[1] != "" && ear[1] != undefined){
		    		ds[ear[0]] = ear[1];
		    	}
		    }
			return ds;
		}
		$this.valid = function(call){
			try {
				$state.form.validate({
					errorElement : 'span',
					// errorClass : 'help-block col-md-12',
					errorClass : 'help-block',
					focusInvalid : false,
					rules : {
						approveType:{
		        	required: true
		      	},
						approveMsg:{
							required: true
						}
					},
					messages : {
						approveType:{
							required: "请选择一种状态"
						},
						approveMsg:{
							required: "审核信息不能为空"
						}
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
							if(call && typeof (call) == "function"){
								call(form);
							}
					}
				});
			} catch (e) {
				console.log(e);
			}
		}
		$this.init = function(){
			$this.buildInto();
			$this.controls();
		}
		$this.init();
		return $this;
	}
}

/*
撤销申请公共界面
*/
var revokeComPage = {
	process: false,
	setProcess: function(type){
		tablePackage.process = type;
	},
	createOne:	function(data){
		var $this = {};
		var _this = this;
		var $data = data, $state = {};
		// console.log(data);

		//table thead
		$this.buildHtml = function(){
			var str = "";
			var _config = $data.modalAttr || {};
			var buildbody = function(){
				var body = '\
		                <div class="form-group">\
		                	<label>撤销申请理由</label>\
		                	<textarea class="form-control" name="revokeMsg" rows="5" cols="" maxlength="100" ></textarea>\
		                </div>\
				';

				return body;
			}
			str ='<div class="modal" id="'+_config.id+'">';
			str +='\
		          	<div class="modal-dialog">\
			            <form action="#" method="post" id="form_revoke" name="form_revoke" class="modal-content" onsubmit="">\
			              	<div class="modal-header">\
				                <button type="button" class="close" data-dismiss="modal" aria-label="Close">\
				                  	<span aria-hidden="true">×</span>\
				                </button>\
				                <h4 class="modal-title">撤销申请</h4>\
			              	</div>\
			              	<div class="modal-body">\
			';
			str += buildbody();
			str += '\
			              	</div>\
			              	<div class="modal-footer">\
			                	<button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>\
			                	<button type="button" class="btn btn-primary btn-save">确认</button>\
			              	</div>\
			            </form>\
			        </div>\
			    </div>\
			';

			return str;
		}
		$this.buildInto = function(){
			var html = $this.buildHtml();
			//console.log(html);
			$("body").append(html);
			$state.modal = $("#"+$data.modalAttr.id);
			$state.form = $state.modal.find("form");
			try{
				$('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
	      			checkboxClass: 'icheckbox_flat-green',
	      			radioClass: 'iradio_flat-green'
	    		});
			}catch(e){
				//TODO handle the exception
			}
		}
		$this.controls = function(){
			var _config = $data.modalAttr;
			var _ctrl = $data.control;
			if (_ctrl.btnId != undefined && $state.modal.length > 0) {
				console.log("r"+_ctrl.btnId);
				$(_ctrl.content).on("click", _ctrl.btnId, function(){
					console.log($state);
					if (_ctrl.beforeShow && typeof (_ctrl.beforeShow) == "function") {
						if (!_ctrl.beforeShow(this, $state.form))
              return false;
					}
					$state.modal.modal();
					if (_ctrl.afterShow && typeof (_ctrl.afterShow) == "function") {
						if (!_ctrl.afterShow(this, $state.form))
              return false;
					}
				});
				$state.modal.on("click", ".btn-save", function(){
					if (_ctrl.beforeSubmit && typeof (_ctrl.beforeSubmit) == "function") {
						if (!_ctrl.beforeSubmit(this, $state.form))
              return false;
					}
					$state.form.submit();
				});
				//validate
				$this.valid(_ctrl.validCallback);
			}
		}
		$this.setVerifyMsg = function(str){//填写审核信息
			var _text = $state.form.find("textarea[name=revokeMsg]");
			if (_text.length > 0) {
				_text.val(str);

				return true;
			}
			return false;
		}
		$this.getData = function(){//获取form下所有的data
			var ds = {};
			var seri = $state.form.serialize();
		    var farr = seri.split("&");
		    for(var i = 0; i < farr.length; i++){
		    	var eh = farr[i];
		    	var ear = eh.split("=");
		    	if(ear[1] != "" && ear[1] != undefined){
		    		ds[ear[0]] = ear[1];
		    	}
		    }
			return ds;
		}
		$this.valid = function(call){
			try {
				$state.form.validate({
					errorElement : 'span',
					// errorClass : 'help-block col-md-12',
					errorClass : 'help-block',
					focusInvalid : false,
					rules : {
						revokeMsg:{
							required: true
						}
					},
					messages : {
						revokeMsg:{
							required: "撤销申请理由不能为空"
						}
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
							if(call && typeof (call) == "function"){
								call(form);
							}
					}
				});
			} catch (e) {
				console.log(e);
			}
		}
		$this.init = function(){
			$this.buildInto();
			$this.controls();
		}
		$this.init();
		return $this;
	}
}
