function stopDefault(e){
		if (e&&e.preventDefault)
		{
				e.preventDefault();//非IE
		}
		else
		{
				window.event.returnValue = false;//IE
				return false;
		}
}
$(function(){
	//登录切换元素的父元素
	var regTop=document.getElementById('reg-top');
	//获取普通登录元素
	var normal=document.getElementById('normal');
	//获取普通登录对应的div
	var rc=document.getElementById('rc');
	//获取无密码登录对应的div
	var lc=document.getElementById('lc');
	//获取扫码登录对应的div
	var sm=document.getElementById('sm');
	//获取提示框元素
	var rcInnerNum=document.getElementById('rc-inner-num');
	var rcinnerText=rcInnerNum.getElementsByTagName('span')[0];
	var rcInnerVirity=document.getElementById('rc-inner-virity');
	var rcInnerVirityText=rcInnerVirity.getElementsByTagName('span')[0];

	//登录状态标识位
	var rcFlag=true;
	var lcFlag=false;
	//密码输入框验证
	var passFlag=false;
	//手机输入正确标识位
	var nFlag=false;
	nFlag=true;
	//手机号码输入框
	var inputPhone = $("input[name='phone-num']");
	//密码输入框
	var inputPassword = $("input[name='password']");
	//获取登录按钮
	var loginBtn = $('#login-btn');
	inputPhone.on("blur", function(){
		// //手机号码的正则验证
		// var reg=/^(1([358][0-9]|(47)|[7][0178]))[0-9]{8}$/;
		// //邮箱的正则验证
		// var reg1=/^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
		// //昵称的正则验证
		// var reg2=/^[\u4e00-\u9fa5_a-zA-Z0-9_]{4,10}$/i;
		//console.log(this.value);
		if(this.value==""){
			rcInnerNum.style.display="block";
			rcInnerVirity.style.display="none";
			return;
		}
		// if(reg.test(this.value)||reg1.test(this.value)||reg2.test(this.value)){
		if(this.value!=""){
			var value=$(this).val();
			//console.log(value);
			$.post(//验证用户工号，学号信息
				'./login.php',//验证链接
				{phone:value},
					function(data){
					//console.log(data);
					if(data=='0'){
						$('#rc-inner-num').show().text();
						$('#rc-inner-virity').hide();
						$('#rc-inner-num > span').text('用户名不存在，请重新输入！');
					}else{
						$('.success').show();
						nFlag=true;
					}
				});
			return;
		}else{
			rcInnerNum.style.display="block";
			rcInnerVirity.style.display="none";
		}
	});
	inputPhone.on("focus", function(){
		rcInnerNum.style.display="none";
		$('.success').hide();
		$('#rc-innerError').eq(0).hide();
	});
	inputPassword.on("blur", function(){
		if(this.value==""){
			if(nFlag){
				rcInnerVirity.style.display="block";
				rcInnerNum.style.display="none";
				rcInnerVirityText.innerText="请输入密码";
			}
			return;
		}
		// var reg=/((?=.*[a-z])(?=.*\d)|(?=[a-z])(?=.*[#@!~%^&*])|(?=.*\d)(?=.*[#@!~%^&*]))[a-z\d#@!~%^&*]{8,16}/i;
		// //*密码必须为8-16位<br/>*必须有字母、数字或特殊字符其中两种
		// if(!reg.test(this.value)){
		// 	rcInnerVirity.style.display="block";
		// 	rcInnerVirityText.innerText="密码为8-16位的字母或数字或特殊字符的结合";
		// 	rcInnerNum.style.display="none";
		if (this.value.length < 6) {
			rcInnerVirity.style.display="block";
			rcInnerVirityText.innerText="密码不小于6位";
			rcInnerNum.style.display="none";

		}else{
			passFlag=true;
			return;
		}
	});
	inputPassword.on("focus", function(){
		rcInnerVirity.style.display="none";
		$('#rc-innerError').eq(0).hide();
	});
	//按钮验证
	loginBtn.on("click", function(e){
		alert("click");
		stopDefault(e);
		$('.maskBg').show();
		ZENG.msgbox.show("正在加载中，请稍后...", 6, 5000);
		setTimeout(function(){
			$('.maskBg').hide();
		}, 5000);
		// console.log(inputPhone.val());
		if(inputPhone.val()==""){
			rcInnerNum.style.display="block";
			rcinnerText.innerText="请输入学号/工号";
			rcInnerVirity.style.display="none";
			return;
		}
		if(inputPassword.val()==""){
			// console.log(nFlag);
			if(nFlag){
				rcInnerVirity.style.display="block";
				rcInnerNum.style.display="none";
			}
			return;
		}
		if(passFlag&&nFlag){
			var phone = inputPhone.val();
			var pass = inputPassword.val();
			/*console.log(phone);
			console.log(pass);*/
			$.post(
				'./js/validate.php',
				{phone:phone,pass:pass},
				function(data){
					if(data=='0'){
						$('#rc-innerError').eq(0).show();
					}else{
						window.location.href='../main/index.html';
					}
				}
			);
		}
	});
});
