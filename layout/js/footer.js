(function() {
	var browser = {},
		userAgent = navigator.userAgent,
		key = {
			win: 'Windows',
			mac: 'Mac',
			ie: 'MSIE',
			ie6: 'MSIE 6',
			ie7: 'MSIE 7',
			ie8: 'MSIE 8',
			ie9: 'MSIE 9',
			safari: 'WebKit',
			webkit: 'WebKit',
			chrome: 'Chrome',
			ipad: 'iPad',
			iphone: 'iPhone',
			os4: 'OS 4',
			os5: 'OS 5',
			os6: 'OS 6',
			qq: 'QQBrowser',
			firefox: 'Firefox',
			tt: 'TencentTraveler',
			opera: 'Opera'
		};

	browser.win = browser.win || (userAgent.indexOf('Win32') != -1);
	for (var i in key) {
		browser[i] = (userAgent.indexOf(key[i]) != -1);
	}
	browser.ie6 = browser.ie6 && !browser.ie7 && !browser.ie8;
	browser.opera = window.opera || browser.opera;
	try {
		browser.maxthon = window.external && window.external.max_version;
	} catch (e) {
		browser.maxthon = false;
	}
	var m = /(msie\s|trident.*rv:)([\w.]+)/.exec(userAgent.toLowerCase());
	if (m && m.length > 0) {
		browser.ie = true;
		if (m[2]) {
			browser.ie = parseFloat(m[2]);
		}
	}
	if (browser.ie6 || browser.ie7 || document.documentMode < 8) {
		// window.location.href('http://ruc.tiup.cn/Login/upgrade');
	}
    //ie8 title附加锚点的问题
	if (browser.ie8){ 		
    	var ot = document.title.split('#')[0];
    	document.attachEvent('onpropertychange', function(e){
    		e = e || window.event;
    		if(e.propertyName == 'title' && document.title)
    			setTimeout(function(){document.title = ot;},1);
    	});
	}
})();

var cookieUtils = function(){
		return {
			setCookie : function(key, value, path){
				var expires = new Date();
				expires.setTime(expires.getTime() + expires * 24 *3600);
				document.cookie = key + "=" + value 
					+ (expires ? ";expires=" + expires.toGMTString() : "")
					+ (path ? ";path=" + path : "");
			},
			removeCookie : function(key, path){
				document.cookie = key + "=;expires=-1;"
					+ (path ? ";path=" + path : "");
			},
			getCookie : function(key){
				var cookie_start = document.cookie.indexOf(key + "=");
				var cookie_end  = document.cookie.indexOf(";", cookie_start);
				return cookie_start > -1 ? document.cookie.substring(cookie_start + key.length + 1, cookie_end >= cookie_start ? cookie_end : document.cookie.length) : "";
			}
		}
	}
	if (cookieUtils().getCookie("lang") == "en_US") {
		$("#langSelect option:selected").val("0").text("切换语言");
	} else {
		$("#langSelect option:selected").val("0").text("Switch Language");
	}
    $("#langSelect").change(function(){
    	if ($(this).val() == "eng"){
    		cookieUtils().removeCookie("lang", "/");
    		cookieUtils().setCookie("lang", "en_US", "/");
    		window.location.reload();
       	} else if ($(this).val() == "chn") {
    		cookieUtils().removeCookie("lang", "/");
    		window.location.reload();
    	}
    });