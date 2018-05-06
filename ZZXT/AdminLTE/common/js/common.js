/////resize 插件
(function($, window, undefined) {
	var elems = $([]),
    jq_resize = $.resize = $.extend($.resize, {}),
    timeout_id,
    str_setTimeout = 'setTimeout',
    str_resize = 'resize',
    str_data = str_resize + '-special-event',
    str_delay = 'delay',
    str_throttle = 'throttleWindow';
	jq_resize[str_delay] = 250;
	jq_resize[str_throttle] = true;
	$.event.special[str_resize] = {
	    setup: function() {
	      if (!jq_resize[str_throttle] && this[str_setTimeout]) {
	        return false;
	      }
	      var elem = $(this);
	      elems = elems.add(elem);
	      $.data(this, str_data, {
	        w: elem.width(),
	        h: elem.height()
	      });
	      if (elems.length === 1) {
	        loopy();
	      }
	    },
	    teardown: function() {
	      if (!jq_resize[str_throttle] && this[str_setTimeout]) {
	        return false;
	      }
	      var elem = $(this);
	      elems = elems.not(elem);
	      elem.removeData(str_data);
	      if (!elems.length) {
	        clearTimeout(timeout_id);
	      }
	    },
	    add: function(handleObj) {
	      if (!jq_resize[str_throttle] && this[str_setTimeout]) {
	        return false;
	      }
	      var old_handler;
	      function new_handler(e, w, h) {
	        var elem = $(this),
	          data = $.data(this, str_data);
	        data.w = w !== undefined ? w : elem.width();
	        data.h = h !== undefined ? h : elem.height();
	        old_handler.apply(this, arguments);
	      }
	      if ($.isFunction(handleObj)) {
	        old_handler = handleObj;
	        return new_handler;
	      } else {
	        old_handler = handleObj.handler;
	        handleObj.handler = new_handler;
	      }
	    }
	};

	function loopy() {
	    timeout_id = window[str_setTimeout](function() {
	      elems.each(function() {
	        var elem = $(this),
	          width = elem.width(),
	          height = elem.height(),
	          data = $.data(this, str_data);
	        if (width !== data.w || height !== data.h) {
	          elem.trigger(str_resize, [data.w = width, data.h = height]);
	        }
	      });
	      loopy();
	    }, jq_resize[str_delay]);
	}
})(jQuery, this);
$(function(){
		// 通过该方法来为每次弹出的模态框设置最新的zIndex值，从而使最新的modal显示在最前面
		$(document).on('show.bs.modal', '.modal', function (event) {
				var zIndex = 1041 + (10 * $('.modal:visible').length);
				$(this).css('z-index', zIndex);
				setTimeout(function() {
				    $('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
				}, 0);
		});
});
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
				setTimeout(function(){
					_t.remove();
				}, 1000);
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
			setTimeout(function(){
				_t.remove();
			}, 1000);
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
		var str = '<div class="modal fade" style="z-index:10000;">'+
          '<div class="modal-dialog"><div class="modal-content" style="background:none;">';
			str += easyAlert.createOne(d);
        str += '</div></div></div>';

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
		d['class'] = '';
		switch (d['type']){
			case 'danger':
				//d['class'] = 'alert-danger';
				break;
			case 'info':
				//d['class'] = 'alert-info';
				break;
			case 'warn':
				//d['class'] = 'alert-warning';
				break;
			case 'success':
				//d['class'] = 'alert-success';
				break;

			default:
				//d['class'] = undefined;
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
		d['class'] = undefined;
		switch (d['type']){
			case 'danger':
				//d['class'] = 'modal-danger';
				break;
			case 'info':
				//d['class'] = 'modal-info';
				break;
			case 'warn':
				//d['class'] = 'modal-warning';
				break;
			case 'success':
				//d['class'] = 'modal-success';
				break;

			default:
				//d['class'] = undefined;
				break;
		}
		var str = '<div class="Confirm_Div modal fade '+d['class']+'" style="z-index:10000;">'+
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

var bodyCallouts = {
	/*
	 * d{
	 * 	type, content, others
	 * }
	 */
	locationShow:	function(d, time){
		var _html = bodyCallouts.buildModal(d);
		//console.log(_html);
		$('.content').prepend(_html);
		var _t = $(_html);
		if(time != undefined){
			setTimeout(function(){
				//console.log(_t);
				try{
					$(".content").find(".callout").remove();
				}catch(e){
					//TODO handle the exception
					console.log(e);
				}
//				parseInt(d['duration'])*1000
			}, parseInt(time));
		}
	},
	hide:function(){
		$(".content").find(".callout").remove();
	},
	buildModal:	function(d){
		d['class'] = undefined;
		switch (d['type']){
			case 'danger':
				d['class'] = 'callout-danger';
				break;
			case 'info':
				d['class'] = 'callout-info';
				break;
			case 'warn':
				d['class'] = 'callout-warning';
				break;
			case 'success':
				d['class'] = 'callout-success';
				break;

			default:
				d['class'] = "callout-info";
				break;
		}
		var str = "";
		str += '<div class="callout '+d["class"]+'" style="z-index:10000;">\
                <h4>'+d["title"]+'</h4>\
                <p>'+d["msg"]+'</p>\
              </div>';

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
			// $(_config['dateId']).datepicker({
		  //   	format: 'yyyy-mm-dd',
			// 	autoclose: true,
			// 	language: "zh-CN"
			// 		// format: 'MM/DD/YYYY h:mm A'
		  // });
			lay(_config['dateId']).each(function(inx, element){
				laydate.render({
					elem: this,
					// trigger: 'click',
					type: 'datetime',
					change: function(value, date){
						$(".layui-laydate .laydate-btns-time").click();
					}
				});
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
    timeout = timeout || undefined;
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

//iframe自适应高度
var adaptionHeight = function(){
	var _pageH = $(document).height();
    if (window.parent) {
//    	var _parentIfm = $('#iframe_box', window.parent.document);
//    	if (_parentIfm.height() < _pageH) {
//      	_parentIfm.css({'height':_pageH+5,});
//    	} else{
//    	}
		var _parentIfm = $('#iframe_box', window.parent.document);
		//console.log(_parentIfm);
		var _sidebar = $(".main-sidebar", window.parent.document);
//		console.log(_sidebar.height());
//		$('body', window.parent.document).resize(function(){
//			console.log($(this).height());
//		});
    }
}
//////创建icheckbox插件
var easyCheckbox = {
    constructor:function(config){
        var $ts = {};
    		var _this = this;
        $ts.config = config;
        $ts.html = function(d){
          var str = "";
          str += '<label>\
            <input name="'+d['name']+'" type="checkbox" class="flat-red" value="'+d['value']+'" />\
            '+d['msg']+'\
          </label>';
          return str;
        }
        $ts.control = function(){
          $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
            checkboxClass: 'icheckbox_flat-green',
            radioClass: 'iradio_flat-green'
          });
        }
        $ts.init = function(){
          /*
          id,//加按钮的模块id
          checkArr,//按钮数组
          */
          var $parent = $($ts.config.id);
          //console.log("init");
          //console.log($parent);
          if ($parent.length > 0) {
            var $cAr = $ts.config.checkArr, $html = "";
            for (var i = 0; i < $cAr.length; i++) {
              var $e = $cAr[i];
              $html += $ts.html($e);
            }
            $parent.append($html);
            $ts.control();
          }
        }
        $ts.init();
        return $ts;
    }
}
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
            //设置界面不可编辑
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
            //设置界面可编辑
            $this.cancel_disableAll = function(){
				$this.modal.find('input').each(function(){
					$(this).attr("disabled", false);
				});
				$this.modal.find('select').each(function(){
					$(this).attr("disabled", false);
				});
				$this.modal.find('textarea').each(function(){
					$(this).attr("disabled", false);
				});
			}
            //传数据进行不可编辑
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
            //界面数据赋值操作
			$this.setFormData = function (_data) {
				var data = _data;
				$this.data = data;
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
	}
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
                    { "data": "DECLARE_TYPE", "head": "申请类型", "type": "td-keep"  },
           			{ "data": "RET_CHANNEL", "head": "状态结果", "type": "td-keep"  },
                    { "data": "OP_USER_NAME", "head": "操作人", "type": "td-keep"  },
                    { "data": "POST_CODE", "head": "操作角色" , "type": "td-keep" },
                    { "data": "OP_TIME", "head": "操作时间" , "type": "td-keep" },
                    { "data": "OP_NOTES", "head": "操作说明", "type": "td-keep"  }
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
						if (!_ctrl.beforeShow(this, $state.form))
							return;
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
			                  		<input type="radio" id="approvePass" class="flat-red" value="P" name="approveType"/>\
                                    <label for="approvePass" id="lab_approvePass" style="margin-right: 10px;">通过</label>\
			                  		<span>&nbsp;&nbsp;</span>\
			                  		<input type="radio" id="approveNoPass" class="flat-red" value="N" name="approveType" />\
                                    <label for="approveNoPass" id="lab_approveNoPass" style="margin-right: 10px;">不通过</label>\
			                  	</div>\
		                  	</div>\
		                </div>\
		                <div class="form-group">\
		                	<label>审核信息</label>\
		                	<textarea class="form-control" id="approveMsg" name="approveMsg" rows="5" cols="" maxlength="100" ></textarea>\
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

//奖助管理通用方法
var JzCom=
{
    //通过奖助类型获得对应打印预览的Url地址
    ByJzTypeToPrint:function (type,apply_oid,str_file_oid)
    {
        var url = "/AdminLTE_Mod/BDM/ScholarshipAssis/Print/";
        var arr_file_oid;
        //附件
        if (str_file_oid){
            arr_file_oid = str_file_oid.split(',');
        }
        //COUNTRY_B：国家奖学金（本科）：表11+1,11+2
        if (type == "COUNTRY_B"){
            OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ 'Print_11.aspx?optype=print&id=' + apply_oid),Math.random().toString());
            OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ 'Print_11_2.aspx?optype=print&id=' + apply_oid),Math.random().toString());
        }
        //COUNTRY_ENCOUR：国家励志奖学金：表12
        //AREA_GOV：自治区人民政府奖学金：表15
        else if (type == "COUNTRY_ENCOUR" || type == "AREA_GOV"){
             OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ 'Print_12_15.aspx?optype=print&id=' + apply_oid),Math.random().toString());
        }
        //COUNTRY_FIRST：国家一等助学金：表13
        //COUNTRY_SECOND：国家二等助学金：表14
        //SOCIETY_OFFER：社会捐资类奖学金：表16
        else if (type == "COUNTRY_FIRST" || type == "COUNTRY_SECOND" || type == "SOCIETY_OFFER"){
             OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ 'Print_13_14_16.aspx?optype=print&id=' + apply_oid),Math.random().toString());
        }
        //SCHOOL_GOOD：三好学生：表17+1
        //SCHOOL_MODEL：三好学生标兵：表17+1,17+2（与11+2一致）,17+3
        else if (type == "SCHOOL_GOOD" || type == "SCHOOL_MODEL")
        {
             OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+'Print_17.aspx?optype=print&id=' + apply_oid),Math.random().toString());
            if (type == "SCHOOL_MODEL") {
                 OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+'Print_11_2.aspx?optype=print&id=' + apply_oid),Math.random().toString());
            }
        }
        //SCHOOL_SINGLE：单项奖学金：表18
        else if (type == "SCHOOL_SINGLE"){
             OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ 'Print_18.aspx?optype=print&id=' + apply_oid),Math.random().toString());
        }
        //COUNTRY_YP：国家奖学金（研究生/博士）：表19+1,19+2
        //COUNTRY_STUDY：国家学业奖学金：表20
        //SCHOOL_NOTCOUNTRY：非国家级奖学金：表21
        //SOCIETY_NOCOUNTRY：非国家级奖学金：表21
        else if (type == "COUNTRY_YP" || type == "COUNTRY_STUDY" || type == "SCHOOL_NOTCOUNTRY" || type == "SOCIETY_NOCOUNTRY"){
            OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ 'Print_19_20_21.aspx?optype=print&id=' + apply_oid),Math.random().toString());
            if (type == "COUNTRY_YP") {
                 OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+'Print_19_2.aspx?optype=print&id=' + apply_oid),Math.random().toString());
            }
        }
        else{
        }
        //附件
        for(var i = 0; i < arr_file_oid.length; i++){
            if (arr_file_oid[i] == null || arr_file_oid[i].length == 0)
                continue;
                OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+'PrintFile.aspx?optype=print&id=' + arr_file_oid[i]),Math.random().toString());
        }
    },
    //通过奖助类型获得对应下载Url地址
    ByJzTypeToDownload:function (type,apply_oid)
    {
        var url = "/Word/ExportWord.aspx";
        //COUNTRY_B：国家奖学金（本科）：表11+1,11+2
        if (type == "COUNTRY_B"){
            OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ '?optype=project&id=' + apply_oid),Math.random().toString());
            OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ '?optype=project_sub&id=' + apply_oid),Math.random().toString());
        }
        //COUNTRY_ENCOUR：国家励志奖学金：表12
        //AREA_GOV：自治区人民政府奖学金：表15
        else if (type == "COUNTRY_ENCOUR" || type == "AREA_GOV"){
             OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ '?optype=project&id=' + apply_oid),Math.random().toString());
        }
        //COUNTRY_FIRST：国家一等助学金：表13
        //COUNTRY_SECOND：国家二等助学金：表14
        //SOCIETY_OFFER：社会捐资类奖学金：表16
        else if (type == "COUNTRY_FIRST" || type == "COUNTRY_SECOND" || type == "SOCIETY_OFFER"){
             OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ '?optype=project&id=' + apply_oid),Math.random().toString());
        }
        //SCHOOL_GOOD：三好学生：表17+1
        //SCHOOL_MODEL：三好学生标兵：表17+1,17+2（与11+2一致）,17+3
        else if (type == "SCHOOL_GOOD" || type == "SCHOOL_MODEL")
        {
            OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ '?optype=project&id=' + apply_oid),Math.random().toString());
            if (type == "SCHOOL_MODEL") {
                 OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ '?optype=project_sub&id=' + apply_oid),Math.random().toString());
            }
        }
        //SCHOOL_SINGLE：单项奖学金：表18
        else if (type == "SCHOOL_SINGLE"){
             OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ '?optype=project&id=' + apply_oid),Math.random().toString());
        }
        //COUNTRY_YP：国家奖学金（研究生/博士）：表19+1,19+2
        //COUNTRY_STUDY：国家学业奖学金：表20
        //SCHOOL_NOTCOUNTRY：非国家级奖学金：表21
        //SOCIETY_NOCOUNTRY：非国家级奖学金：表21
        else if (type == "COUNTRY_YP" || type == "COUNTRY_STUDY" || type == "SCHOOL_NOTCOUNTRY" || type == "SOCIETY_NOCOUNTRY"){
            OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ '?optype=project&id=' + apply_oid),Math.random().toString());
            if (type == "COUNTRY_YP") {
                 OptimizeUtils.WindowOpenNewWin(OptimizeUtils.FormatUrl(url+ '?optype=project_sub&id=' + apply_oid),Math.random().toString());
            }
        }
    }
}
/* ** */
var huiTabs = {
	init:function(){
		var _ts = {}, _this = null;
		_ts.tabNav = "#min_title_list";
		_ts.tabArt = "#iframe_box";
		_ts.constructor = function(){
		}
		_ts.controls = function(){
		}
		/*菜单导航*/
		function Hui_admin_tab(obj){
			var bStop = false,
				bStopIndex = 0,
				href = $(obj).attr('data-href'),
				title = $(obj).attr("data-title"),
				topWindow = $(window.parent.document),
				show_navLi = topWindow.find("#min_title_list li"),
				iframe_box = topWindow.find("#iframe_box");
			//console.log(topWindow);
			if(!href||href==""){
				alert("data-href不存在，v2.5版本之前用_href属性，升级后请改为data-href属性");
				return false;
			}if(!title){
				alert("v2.5版本之后使用data-title属性");
				return false;
			}
			if(title==""){
				alert("data-title属性不能为空");
				return false;
			}
			show_navLi.each(function() {
				if($(this).find('span').attr("data-href")==href){
					bStop=true;
					bStopIndex=show_navLi.index($(this));
					return false;
				}
			});
			if(!bStop){
				creatIframe(href,title);
				min_titleList();
			}
			else{
				show_navLi.removeClass("active").eq(bStopIndex).addClass("active");
				iframe_box.find(".show_iframe").hide().eq(bStopIndex).show().find("iframe").attr("src",href);
			}
		}
		/*最新tab标题栏列表*/
		function min_titleList(){
			var topWindow = $(window.parent.document),
				show_nav = topWindow.find("#min_title_list"),
				aLi = show_nav.find("li");
		}

		/*创建iframe*/
		function creatIframe(href,titleName){
			var topWindow=$(window.parent.document),
				show_nav=topWindow.find('#min_title_list'),
				iframe_box=topWindow.find('#iframe_box'),
				iframeBox=iframe_box.find('.show_iframe'),
				$tabNav = topWindow.find(".acrossTab"),
				$tabNavWp = topWindow.find(".Hui-tabNav-wp"),
				$tabNavmore =topWindow.find(".Hui-tabNav-more");
			var taballwidth=0;

			show_nav.find('li').removeClass("active");
			show_nav.append('<li class="active"><span data-href="'+href+'">'+titleName+'</span><i></i><em></em></li>');
			if('function'==typeof $('#min_title_list li').contextMenu){
				$("#min_title_list li").contextMenu('Huiadminmenu', {
					bindings: {
						'closethis': function(t) {
							var $t = $(t);
							if($t.find("i")){
								$t.find("i").trigger("click");
							}
						},
						'closeall': function(t) {
							$("#min_title_list li i").trigger("click");
						},
					}
				});
			}else {
			}
			var $tabNavitem = topWindow.find(".acrossTab li");
			if (!$tabNav[0]){return}
			$tabNavitem.each(function(index, element) {
		        taballwidth+=Number(parseFloat($(this).width()+60))
		    });
			$tabNav.width(taballwidth+25);
			var w = $tabNavWp.width();
			if(taballwidth+25>w){
				$tabNavmore.show()}
			else{
				$tabNavmore.hide();
				$tabNav.css({left:0})
			}
			iframeBox.hide();
			iframe_box.append('<div class="show_iframe"><div class="loading"></div><iframe frameborder="0" src='+href+'></iframe></div>');
			var showBox=iframe_box.find('.show_iframe:visible');
			showBox.find('iframe').load(function(){
				showBox.find('.loading').hide();
			});
		}

		return _ts;
	}
}
