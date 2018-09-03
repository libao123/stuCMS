var mainHeader = {
	init:function(to, dataMsg, dataNotice, config){
		var _ts = this;
		var _notice = _ts.createNotify(dataNotice);
		var noticeHtml = _notice.struct();
		$(to).prepend(noticeHtml);
		_notice.control();

		var _messages = _ts.createMessage(dataMsg);
		var msgHtml = _messages.struct();
		$(to).prepend(msgHtml);
		_messages.control();
	},
	createMessage:function(data, config){
		var _headerMessage = {}, _this = null;
		/*data[{'icon', 'title', 'time', 'msg'}]
		 */
		var $data = data;
		var each = function(d){
			if (d["href"] == undefined || d["href"] == "") {
				d["href"] = "#";
			}
			if (d["title"] == undefined || d["title"] == "") {
				d["title"] = "";
			}
			var str = '<li><a href="javascript:void(0);" data-href="'+d["href"]+'" data-title="'+d["title"]+'">'+
			          '<div class="pull-left">'+
			          '<img src="'+d["icon"]+'" class="img-circle" alt="" />'+
								'</div>'+
			          '<h4>'+d["title"]+'<small><i class="fa fa-clock-o"></i>'+d["time"]+'</small></h4>'+
			          '<p class="title-f">'+d['msg']+'</p>'+
			          '</a></li>';
			return str;
		}
		_headerMessage.struct = function(){
			var len = $data.length;
			if(len > 0){
				var baseStr = '<li class="dropdown messages-menu">'+
										'<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-envelope-o"></i><span class="label label-success">'+len+'</span></a>'+
										'<ul class="dropdown-menu"><li class="header">有'+len+'条信息</li>'+
										'<li><ul class="menu">';
				for (var i = 0; i < len; i++) {
					baseStr += each($data[i]);
				}
//				baseStr += '</ul></li>'+
//									'<li class="footer"><a href="#">全部信息</a></li>';
				baseStr += "</ul></li>"; 
			}else{
				var baseStr = '<li class="dropdown messages-menu">'+
										'<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-envelope-o"></i><span class="label label-success">0</span></a>'+
										'<ul class="dropdown-menu"><li class="header">有0条信息</li>'+
										'</ul></li>';
			}

			return baseStr;
		}
		_headerMessage.control = function(){
			var _msgMenu = $(".messages-menu");
			var _msgdropdown = _msgMenu.find(".dropdown-menu .menu a");
			_msgdropdown.on("click", function(){
				console.log("msg list");
				if ($(this).attr("data-href") != undefined && $(this).attr("data-href") != "" && $(this).attr("data-href") != "#") {
					Hui_admin_tab(this);
				} else{
					
				}
			});
		}

		return _headerMessage;
	},
	createNotify:function(data, config){
		var _headerNotify = {}, _this = null;
		/*data[{'iconClass', 'msg'}]
		 */
		var $data = data;
		var each = function(d){
			console.log(d);
			if (d["href"] == undefined || d["href"] == "") {
				d["href"] = "#";
			}
			if (d["title"] == undefined || d["title"] == "") {
				d["title"] = "";
			}
			var str = '<li><a href="javascript:void(0);" data-href="'+d["href"]+'" data-title="'+d["title"]+'">'+
			          '<i class="'+d['iconClass']+'"></i>'+d['msg']+'</a>'+
			          '</li>';
			return str;
		}
		_headerNotify.struct = function(){
			var len = $data.length;
			if(len > 0){
				var baseStr = '<li class="dropdown notifications-menu">'+
											'<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-bell-o"></i><span class="label label-warning">'+len+'</span></a>'+
											'<ul class="dropdown-menu"><li class="header">有'+len+'条提示</li>'+
											'<li><ul class="menu">';
				for (var i = 0; i < len; i++) {
					baseStr += each($data[i]);
				}
//				baseStr += '</ul></li><li class="footer"><a href="#">全部提示信息</a></li>'
				baseStr += '</ul></li>';
			}else{
				var baseStr = '<li class="dropdown notifications-menu">'+
											'<a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-bell-o"></i><span class="label label-warning">0</span></a>'+
											'<ul class="dropdown-menu"><li class="header">有0条提示</li>'+
										'</ul></li>';
			}
			return baseStr;
		}
		_headerNotify.control = function(){
			var _notiMenu = $(".notifications-menu");
			var _notidropdown = _notiMenu.find(".dropdown-menu .menu a"); 
			// Hui_admin_tab(this);
			_notidropdown.on("click", function(){
				console.log("noti list"+$(this).attr("data-href"));
				if ($(this).attr("data-href") != undefined && $(this).attr("data-href") != "" && $(this).attr("data-href") != "#" ){
					Hui_admin_tab(this);
				} else{
					
				}
			});
		}
		return _headerNotify;
	},
	
}

var mainSidebar = {
	init:function(to, data, config){
		var _ts = this;
		var _sidebar = _ts.createOne(data);
		var _html = _sidebar.struct();
		$(to).append(_html);
	},
	createOne:function(data, config){
		var _sidebar = {}, _this = null;
		var $data = data;
		//TODO
		/*
		data[
			{'url','str','class','child':[
				{'url','str','child':[
					{'url','str'}
				]}
			]}
		]
		*/
		var _commonStr = function(d){
			var str = '<li class="'+d['class']+'">';
			if( d['child'] != undefined && d['child'].length > 0 ){
				var _dChild = d['child'];
				//console.log(d['icon']);
				if(d['icon'] == undefined || d['icon'] == ''){
					d['icon'] = 'dashboard';
				}
				//TODO 第二层
				str += '<a href="#">'+
					'<i class="fa fa-'+d['icon']+'"></i><span>'+d['str']+'</span>'+
					'<span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>'+
					'</a>'+
					'<ul class="treeview-menu">';
			//TODO 判断第三层
			for (var i = 0; i < _dChild.length; i++) {
      		var _cChild = _dChild[i]['child'];
	      	if(_cChild != undefined && _cChild.length > 0){
	      		str += '<li><a href="#"><i class="fa fa-circle-o"></i>'+_dChild[i]['str']+
	      				'<span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>';

	      		str +=	'</a>'+
	      						'<ul class="treeview-menu">';
		      	for (var j = 0; j < _cChild.length; j++) {
		      		str += '<li><a data-href="'+_cChild[j]['url']+'" data-title="'+_cChild[j]['str']+'" href="javascript:void(0)"><i class="fa fa-circle-o"></i>'+_cChild[j]['str']+'</a></li>';
		      	}
		      	str += '</ul></li>';
	      	}else{
	      		str += '<li><a data-href="'+_dChild[i]['url']+'" href="javascript:void(0)" data-title="'+_dChild[i]['str']+'"><i class="fa fa-circle-o"></i>'+_dChild[i]['str']+'</a></li>';
	      	}

	      	}

			str += '</ul>';

			}else{
				str += '<a data-href="'+d['url']+'" href="javascript:void(0)" data-title="'+d['str']+'">'+
            					'<i class="fa fa-laptop"></i><span>'+d['str']+'</span>'+
          		'</a>';
			}


      str += '</li>';
      return str;
		}
		var _firstLevel = function(d){
			var str = '<li class="'+d['class']+'">'+
          					'<a data-href="'+d['url']+'" href="javascript:void(0)" data-title="'+d['str']+'">'+
            					'<i class="fa fa-laptop"></i><span>'+d['str']+'</span>'+
          					'</a>'+
       					'</li>';
      return str;
		}
		var _secondLevel = function(d){
			var str = '<li class="'+d['class']+'">'+
          					'<a href="#">'+
            					'<i class="fa fa-laptop"></i><span>'+d['str']+'</span>'+
            					'<span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>'+
          					'</a>'+
          					'<ul class="treeview-menu">';
      for (var i = 0; i < d['child'].length; i++) {
      	str += '<li><a data-href="'+d['child'][i]['url']+'" data-title="'+d['child'][i]['str']+'" href="javascript:void(0)"><i class="fa fa-circle-o"></i>'+d['child'][i]['str']+'</a></li>';
      }

      str += '</ul></li>';
      return str;
		}
		var _thirdLevel = function(d){
			var str = '<li class="'+d['class']+'">'+
          					'<a href="#">'+
            					'<i class="fa fa-laptop"></i><span>'+d['str']+'</span>'+
            					'<span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>'+
          					'</a>'+
          					'<ul class="treeview-menu">';
      var _c = d['child'];
      for (var i = 0; i < _c.length; i++) {
      	var _cChild = _c[i]['child'];
      	if(_cChild.length > 0 && _cChild != undefined){
      		str += '<li><a href="#"><i class="fa fa-circle-o"></i>'+_c[i]['str']+
      						'<span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>';
      	}else{
      		str += '<li><a data-href="'+_c[i]['url']+'" href="javascript:void(0)" data-title="'+_c[i]['str']+'"><i class="fa fa-circle-o"></i>'+_c[i]['str'];
      	}

      	str +=	'</a>'+
      					'<ul class="treeview-menu">';
      	for (var j = 0; j < _cChild.length; j++) {
      		str += '<li><a data-href="'+_cChild[j]['url']+'" data-title="'+_cChild[j]['str']+'" href="javascript:void(0)"><i class="fa fa-circle-o"></i>'+_cChild[j]['str']+'</a></li>';
      	}

      	str += '</ul></li>';
      }

      str += '</ul></li>';
      return str;
		}

		_sidebar.struct = function(){
			var _html = '';
			for (var i = 0; i < $data.length; i++) {
				var _t = $data[i];
				_html += _commonStr(_t);
			}
			return _html;
		}

		return _sidebar;
	},
}

var indexRole = {
  init:function(){
    var _ts = this;
    var _in = _ts.createOne();
  },
  createOne: function(){
    var _quick = {}, _this = null;
    //var $data = data, $to = to;
    _quick.config = {
      modal:"roleModal",
      //attr:data.attr,
      btn:"changeRole",
      iframeSrc:"/AdminLTE_Mod/UserAuthority/ChangRole/Edit.aspx",
    }
    _quick.init = function(){
      // $($to).append(_quick.struct(_quick.config.attr));
      $(".wrapper").append(_quick.modal(_quick.config.modal));
      _quick.controls();
    }
    _quick.modal = function(d){
      var str = "";
      str += '<div class="modal" id="roleModal">';
      str += '<div class="modal-dialog">\
          <div class="modal-content">\
            <div class="modal-header">\
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>';
      str += '<h4 class="modal-title">切换角色</h4>';
      str += '</div>\
            <div class="modal-body">\
                <iframe class="" style="border:none; width:100%; min-height:460px;" src=""></iframe>\
            </div>\
          </div>\
        </div>\
      </div>';
      /*<div class="box box-default" style="border:none;"></div>\*/
      return str;
    }
    _quick.controls = function(){
      var $config = _quick.config;
      var $modal = $config.modal//, $attr = _quick.config.attr;
      var _modal = $("#"+$modal);
      //var _block = $($to);
      $("#"+$config.btn).on("click", function(){
        var _ts = $(this);
        // console.log(_ts.attr("data-href"));
        _modal.find('iframe').attr('src', $config.iframeSrc);
        _modal.modal();
      });

    }
    _quick.init();
    return _quick;
  },
}
