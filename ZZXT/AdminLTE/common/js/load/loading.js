//显示Loading
(function($){
	$.fn.propLoading = function(options){
		var $this = $(this);
		var _this = this;
		return this.each(function(){
		    var loadingPosition = '';
		    var defaultProp = {
		    	direction: 				'column',												//方向，column纵向   row 横向
					animateIn: 	 			'fadeInNoTransform',    								//进入类型
					title:                  '',      										//显示什么内容 请稍等...
					name: 					'loadingName', 											//loading的data-name的属性值  用于删除loading需要的参数
					type: 			        'origin', 			  									//pic   origin
					discription: 			'', 										//loading的描述 这是一个描述
					titleColor: 			'rgba(255,255,255,0.7)',								//title文本颜色
					discColor: 				'rgba(255,255,255,0.7)',								//disc文本颜色
					loadingWidth:           260,                									//中间的背景宽度width
					loadingBg:        		'rgba(0, 0, 0, 0.6)',  									//中间的背景色
					borderRadius:     		12,                 									//中间的背景色的borderRadius
					loadingMaskBg:    		'transparent',          								//背景遮罩层颜色
					zIndex:           		1000001,              									//层级

					// 这是圆形旋转的loading样式
					originDivWidth:        	60,           											//loadingDiv的width
					originDivHeight:       	60,           											//loadingDiv的Height

					originWidth:      		8,                  									//小圆点width
					originHeight:     		8,                  									//小圆点Height
					originBg:         		'#fefefe',              								//小圆点背景色
					smallLoading:     		false,                  								//显示小的loading

					// 这是图片的样式   (pic)
					imgSrc: 				'http://www.daiwei.org/index/images/logo/dw.png',    	//默认的图片地址
					imgDivWidth: 			80,           											//imgDiv的width
					imgDivHeight: 			80,           											//imgDiv的Height

					flexCenter: 	 		false, 													//是否用flex布局让loading-div垂直水平居中
					flexDirection: 			'row',													//row column  flex的方向   横向 和 纵向
					mustRelative: 			false, 													//$this是否规定relative
		    };

		    var opt = $.extend(defaultProp,options || {});

		    //根据用户是针对body还是元素  设置对应的定位方式
		    if($this.selector == 'body'){
		    	$('body,html').css({
		    		overflow:'hidden',
		    	});
		    	loadingPosition = 'fixed';
		    }else if(opt.mustRelative){
		    	$this.css({
			    	position:'relative',
			    });
			    loadingPosition = 'absolute';
		    }else{
		    	loadingPosition = 'absolute';
		    }

		    defaultProp._showOriginLoading = function(){
		    	var smallLoadingMargin = opt.smallLoading ? 0 : '-10px';
					//悬浮层
		    	if(opt.direction == 'row'){smallLoadingMargin='-6px'}

		      	_this.cpt_loading_mask = $('<div class="cpt-loading-mask animated '+opt.animateIn+' '+opt.direction+'" data-name="'+opt.name+'"></div>').css({
			        'background':opt.loadingMaskBg,
			        'z-index':opt.zIndex,
			        'position':loadingPosition,
						}).appendTo($this);

		      	//中间的显示层
				_this.div_loading = $('<div class="div-loading"></div>').css({
			  	'background':opt.loadingBg,
			    'width':opt.loadingWidth,
			    'height':opt.loadingHeight,
			    '-webkit-border-radius':opt.borderRadius,
			    '-moz-border-radius':opt.borderRadius,
			    'border-radius':opt.borderRadius,
		    }).appendTo(_this.cpt_loading_mask);

				if(opt.flexCenter){
					_this.div_loading.css({
						"display": "-webkit-flex",
						"display": "flex",
						"-webkit-flex-direction":opt.flexDirection,
						"flex-direction":opt.flexDirection,
						"-webkit-align-items": "center",
						"align-items": "center",
						"-webkit-justify-content": "center",
						"justify-content":"center",
					});
				}

				//loading标题
	      _this.loading_title = $('<p class="loading-title txt-textOneRow"></p>').css({
	      	color:opt.titleColor,
	      }).html(opt.title).appendTo(_this.div_loading);

	        	//loading中间的内容  可以是图片或者转动的小圆球
		     	_this.loading = $('<div class="loading '+opt.type+'"></div>').css({
			      'width':opt.originDivWidth,
			      'height':opt.originDivHeight,
		      }).appendTo(_this.div_loading);

		     		//描述
	        	_this.loading_discription = $('<p class="loading-discription txt-textOneRow"></p>').css({
	        		color:opt.discColor,
	        	}).html(opt.discription).appendTo(_this.div_loading);

	        	if(opt.type == 'origin'){
	        		_this.loadingOrigin = $('<div class="div-loadingOrigin"><span></span></div><div class="div-loadingOrigin"><span></span></div><div class="div_loadingOrigin"><span></span></div><div class="div_loadingOrigin"><span></span></div><div class="div_loadingOrigin"><span></span></div>').appendTo(_this.loading);
			      	_this.loadingOrigin.children().css({
				        "margin-top":smallLoadingMargin,
				        "margin-left":smallLoadingMargin,
				        "width":opt.originWidth,
				        "height":opt.originHeight,
				        "background":opt.originBg,
			      	});
	        	}

	        	if(opt.type == 'pic'){
	        		_this.loadingPic = $('<img src="'+opt.imgSrc+'" alt="loading" />').appendTo(_this.loading);
	        	}

		      //关闭事件冒泡  和默认的事件
			    _this.cpt_loading_mask.on('touchstart touchend touchmove click',function(e){
						e.stopPropagation();
						e.preventDefault();
			    });
		    };
		    defaultProp._createLoading = function(){
		    	//不能生成两个loading data-name 一样的loading
		    	if($(".cpt-loading-mask[data-name="+opt.name+"]").length > 0){
		    		// console.error('loading mask cant has same date-name('+opt.name+'), you cant set "date-name" prop when you create it');
		    		return
		    	}

					defaultProp._showOriginLoading();
		    };
		    defaultProp._createLoading();
		});
	}

})(jQuery)

//关闭Loading
// window.removeLoading = function(loadingName){
// 	var loadingName = loadingName || '';
// 	$('body,html').css({
// 		overflow:'auto',
// 	});
//
// 	if(loadingName == ''){
// 		$(".cpt-loading-mask").remove();
// 	}else{
// 		var name = loadingName || 'loadingName';
// 		$(".cpt-loading-mask[data-name="+name+"]").remove();
// 	}
// }

window.PropLoad = {
	loading: function (data) {
		if (data) {
			var _title = data.title ? data.title : '';
			var _name = data.name ? data.name : 'PopLoad';
			var _discription = data.discription ? data.discription : '';
			var _duration = data.duration ? data.duration : undefined;
		} else {
			var _duration = undefined;
		}
		$('body').propLoading({
			loadingWidth: 'auto',
			title: _title ? _title : '',
			name: _name ? _name : 'PopLoad',
			discription: _discription ? _discription : '',
			direction: 'column',
			type: 'origin',
			originDivWidth: 32,
			originDivHeight: 32,
			originWidth: 6,
			originHeight: 6,
			smallLoading: false,
			loadingMaskBg: 'rgba(0,0,0,0.2)'
		});
		if (_duration && typeof _duration === 'number' && !isNaN(_duration)) {
			setTimeout(function(){
				PropLoad.remove()
			}, _duration * 1000)
		}
		return _name
	},
	remove: function (loadingName) {
		var loadingName = loadingName || '';
		$('body,html').css({
			overflow:'auto',
		});

		if (loadingName == '') {
			$(".cpt-loading-mask").remove();
		} else {
			var name = loadingName || 'PopLoad';
			$(".cpt-loading-mask[data-name="+name+"]").remove();
		}
	}
}
/**
$('body').propLoading({
			loadingWidth:120,
			title:'',
			name:'test',
			discription:'',
			direction:'column',
			type:'origin',
			// originBg:'#71EA71',
			originDivWidth:40,
			originDivHeight:40,
			originWidth:6,
			originHeight:6,
			smallLoading:false,
			loadingMaskBg:'rgba(0,0,0,0.2)'
		});

		setTimeout(function(){
			removeLoading('test');
		},3000);
*/