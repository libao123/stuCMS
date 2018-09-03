var quickEnter = {
  init: function(to, data){
    var _ts = this;
    var _qe = _ts.createOne(data);
		var _html = _qe.struct();
		$(to).append(_html);
  },
  createOne: function(data){
    var _quick = {}, _this = null;
    var $data = data;
    var createBtn = function(d){
    	if (d['url'] != undefined && d['url'].length > 0) {
    		var _url = d['url'];
    	} else{
    		var _url = "#";
    	}
      var str = '<a class="btn btn-app" href="'+_url+'">'+
                '<i class="fa fa-edit"></i>'+d['str']+'</a>';
      return str;
    };
    _quick.struct = function(){
      var len = $data.length;
      var baseStr = "";
			if(len > 0){
        for (var i = 0; i < len; i++) {
          // $data[i]
          baseStr += createBtn($data[i]);
        }
      }else {

      }
      return baseStr;
    }

    return _quick;
  },

}
var indexNotice = {
  init: function(to, data){
    var _ts = this;
    var _in = _ts.createOne(data);
		var _html = _in.struct();
		$(to).append(_html);
  },
  createOne: function(data){
    var _quick = {}, _this = null;
    var $data = data;
    var createMsg = function(d){
    	if (d['url'] != undefined && d['url'].length > 0) {
    		var _url = d['url'];
    	} else{
    		var _url = "#";
    	}
      var str = '<li><a href="'+_url+'"><i class="fa fa-inbox"></i>'+d['title']+'</a></li>';
      return str;
    };
    _quick.struct = function(){
      var len = $data.length;
      var baseStr = "";
			if(len > 0){
        baseStr += '<ul class="nav nav-pills nav-stacked">';
        for (var i = 0; i < len; i++) {
          // $data[i]
          baseStr += createMsg($data[i]);
        }
        baseStr += '</ul>';
      }else {

      }
      return baseStr;
    }

    return _quick;
  },
}

var indexLoginLog = {
  init: function(to, data){
    var _ts = this;
    var _il = _ts.createOne(data);
		var _html = _il.struct();
		$(to).append(_html);
  },
  createOne: function(data){
    var _quick = {}, _this = null;
    var $data = data;
    var createMsg = function(d){
    	if (d['link'] != undefined && d['link'].length > 0) {
    		var _url = d['link'];
    	} else{
    		var _url = "#";
    	}
      var str = '<li>'+
                '<img src="'+d['imgurl']+'" alt="">'+
                '<a class="users-list-name" href="'+_url+'">'+d['name']+'</a>'+
                '<span class="users-list-date">'+d['date']+'</span>'+
                '</li>';

      return str;
    };
    _quick.struct = function(){
      var len = $data.length;
      var baseStr = "";
			if(len > 0){
        baseStr += '<ul class="users-list clearfix">';
        for (var i = 0; i < len; i++) {
          // $data[i]
          baseStr += createMsg($data[i]);
        }
        baseStr += '</ul>';
      }else {

      }
      return baseStr;
    }

    return _quick;
  },
}

var indexRangeDay = {
	/* data
	 * [{'date', 'events':[{'user','title','url','msg','time','btns':['type':'more/del/view','link']}]}]
	 */
	init:	function(to, data, config){
		var _ts = this;
		var _ra = _ts.createOne(data);
		var _html = _ra.struct();
		$(to).append(_html);
	},
	createOne:	function(data, config){
		var _range = {}, _this = null;
		var $data = data;
		var $config = config;
//		var createMsg = function(d){
//			
//		}
		var createDateLine = function(d){
			//createTimeLine
			var str = '<li class="time-label">'+
								'<span class="bg-red">'+d['date']+'</span>'+
								'</li>';
			if(d['events'] != undefined && d['events'].length > 0){
				for (var i = 0; i < d['events'].length; i++) {
					var _e = d['events'][i];
					str += createTimeLine(_e);
				}
			}
			return str;
		}
		var createTimeLine = function(d){
			if(d['url'] == undefined || d['url'] == ''){
				d['url'] = '#';
			}
			var str = '<li><i class="fa fa-envelope bg-blue"></i>'+
								'<div class="timeline-item">'+
								'<span class="time"><i class="fa fa-clock-o"></i>'+d['time']+'</span>'+
								'<h3 class="timeline-header"><a href="'+d['url']+'">'+d['user']+'</a>'+d['title']+'</h3>'+
								'<div class="timeline-body">'+d['msg']+'</div>';
			if(d['btns'] != undefined && d['btns'].length > 0){
				str += '<div class="timeline-footer">';
				for (var i = 0; i < d['btns'].length; i++) {
					var _btn = d['btns'][i];
					if(_btn['link'] == undefined || _btn['link'] == ''){
						_btn['link'] = '#';
					}
					if(_btn['type'] == 'more'){
						str += '<a href="'+_btn['link']+'" class="btn btn-primary btn-xs">Read more</a>';
					}else if(_btn['type'] == 'del'){
						str += '<a href="'+_btn['link']+'" class="btn btn-danger btn-xs">Delete</a>';
					}else if(_btn['type'] == 'view'){
						str += '<a href="'+_btn['link']+'" class="btn btn-warning btn-flat btn-xs">View comment</a>';
					}else{
						console.log(_btn);
					}
				}
				str += '</div>';
			}
			str += '</div></li>';
			return str;
		}
		_range.struct = function(){
			var baseStr = "";
			try{
				var len = $data.length;
			}catch(e){
				//TODO handle the exception
				var len = 0;
			}
			if(len > 0){
				baseStr += '<ul class="timeline">';
				for (var i = 0; i < len; i++) {
					baseStr += createDateLine($data[i]); 
				}
				baseStr += '<li><i class="fa fa-clock-o bg-gray"></i></li></ul>';
			}
			return baseStr;
		}
		
		return _range;
	},
	
}
$(function(){
	

});
