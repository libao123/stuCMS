$(function(){
	var resetPass = '#resetPass';
	$(resetPass).on('click', function(){
		var _modal = $('#'+$(this).attr('id')+'Modal');
		_modal.modal();
	});
});
