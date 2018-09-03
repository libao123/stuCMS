var jsType = jsType || '';
$(function(){	
if (jsType == 'timeModel') {
	var setRZ = "#setRZ", setDC = "#setDC", setSQ = "#setSQ", rangeTime = "#rangeTime";
	//
	
	$('.timepicking').daterangepicker({
    	timePicker: false,
    	format: 'YYYY/MM/DD',
    });
    
	$("#rangeTime .btn-app").on('click', function(){
    	var _modal = $("#timeModal"),
    		_form = _modal.find('form');
    	var _t = $(this), _action = _t.data('action');
    	//TODO 根据入口modal赋值_form的action，还有相关信息
    	_form.attr('action', _action);
	    	
    	$(_modal).modal();
    });
}else if(jsType == 'commonTable'){
		var _content = $("#content"), 
			_modal = $("#infoModal"), 
			_delModal = $('#delModal'),
			_enterModal = $("#enterModal");

		if(_enterModal.length > 0){
			$("#dataEnter").on('click', function(){
				var _modal = $("#enterModal");				
				_modal.modal();
			});
		}
		//Flat red color scheme for iCheck
	    $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
	      	checkboxClass: 'icheckbox_flat-green',
	      	radioClass: 'iradio_flat-green'
	    });
		var setValToModal = function(_modal, _row, _arr){
	   		_row.find('td').each(function(){
	    		var _t = $(this), _s = _modal.find('[name='+_arr[_t.index()]+']');
				if(_s.length > 0){
					if(_s.prop("nodeName") != 'TEXTAREA'){
						if(_s.attr('type') != "checkbox"){
							_s.val(_t.text());
						}else{
							var _box = _t.find('[name=status]').val();
							if(parseInt(_box) > 0 && parseInt(_box) != undefined){
	//							_s.prop('checked', true);
								_s.iCheck('check');
							}else{
	//							_s.prop('checked', false);
								_s.iCheck('uncheck');
							}
						}
					}else{
						_s.val(_t.text());
					}
				}
	    	});

	   	}
				
		$(_content).on("click", '.btn-add', function(){
	    	var _form = _modal.find('form');
	    	_form.find('input, textarea').each(function(){
	    		$(this).val('');
	    	});
	    	_modal.modal();
	    });
	    $(_content).on("click", '.btn-edit', function(){
	    	var _row = $(this).parent().parent(),
		    	_tds = $(this).parents(),
		    	_form = _modal.find('form');
	    	//TODO 把_row里的data赋值给modal里的表单，还有action信息等
	    	if(tableArr.length > 0){
				setValToModal(_modal, _row, tableArr);	    	
	    		_modal.modal();	    		
	    	}else{
	    		return false;
	    	}
	    	
	    });
	    
	    $(_content).on("click", '.btn-del', function(){
	    	var _row = $(this).parent().parent(),
		    	_form = _modal.find('form');
			var _id = _row.find('td:eq(0)').text();
			_form.find('input[name=id]').val(_id);
	    	_delModal.modal();
	    });
}else if(jsType == "process"){
	var _content = $("#content"), 
		_modal = $("#infoModal");
	var editBtn = $("#editBtn"), downBtn = $('#downBtn');
//	/*  */
//	CKEDITOR.config.height = 350;
//  CKEDITOR.config.width = 'auto';
//
//  var initSample = ( function() {
//	      	var wysiwygareaAvailable = isWysiwygareaAvailable(),
//	      		isBBCodeBuiltIn = !!CKEDITOR.plugins.get( 'bbcode' );
//	
//	      	return function() {
//	      		var editorElement = CKEDITOR.document.getById( 'editor' );
//	
//	      		// :(((
//	      		if ( isBBCodeBuiltIn ) {
//	      			editorElement.setHtml(
//	      				'Hello world!\n\n'
//	      			);
//	      		}
//	
//	      		// Depending on the wysiwygare plugin availability initialize classic or inline editor.
//	      		if ( wysiwygareaAvailable ) {
//	      			CKEDITOR.replace( 'editor' );
//	      		} else {
//	      			editorElement.setAttribute( 'contenteditable', 'true' );
//	      			CKEDITOR.inline( 'editor' );
//	
//	      			// TODO we can consider displaying some info box that
//	      			// without wysiwygarea the classic editor may not work.
//	      		}
//	      	};
//	
//	      	function isWysiwygareaAvailable() {
//	      		// If in development mode, then the wysiwygarea must be available.
//	      		// Split REV into two strings so builder does not replace it :D.
//	      		if ( CKEDITOR.revision == ( '%RE' + 'V%' ) ) {
//	      			return true;
//	      		}
//	
//	      		return !!CKEDITOR.plugins.get( 'wysiwygarea' );
//	      	}
//  } )();
//  
//	editBtn.on('click', function(){
//		_modal.modal();
//	});
//	downBtn.on('click', function(){
//		window.location.href = "####";
//	});
//	///////
//	initSample();
		CKEDITOR.config.height = 350;
      	CKEDITOR.config.width = 'auto';

      	var initSample = ( function() {
	      	var wysiwygareaAvailable = isWysiwygareaAvailable(),
	      		isBBCodeBuiltIn = !!CKEDITOR.plugins.get( 'bbcode' );
	
	      	return function() {
	      		var editorElement = CKEDITOR.document.getById( 'editor' );
	
	      		// :(((
	      		if ( isBBCodeBuiltIn ) {
	      			editorElement.setHtml(
	      				'Hello world!\n\n'
	      			);
	      		}
	
	      		// Depending on the wysiwygare plugin availability initialize classic or inline editor.
	      		if ( wysiwygareaAvailable ) {
	      			CKEDITOR.replace( 'editor' );
	      		} else {
	      			editorElement.setAttribute( 'contenteditable', 'true' );
	      			CKEDITOR.inline( 'editor' );
	
	      			// TODO we can consider displaying some info box that
	      			// without wysiwygarea the classic editor may not work.
	      		}
	      	};
	
	      	function isWysiwygareaAvailable() {
	      		// If in development mode, then the wysiwygarea must be available.
	      		// Split REV into two strings so builder does not replace it :D.
	      		if ( CKEDITOR.revision == ( '%RE' + 'V%' ) ) {
	      			return true;
	      		}
	
	      		return !!CKEDITOR.plugins.get( 'wysiwygarea' );
	      	}
      	} )();
	var _w = _Bwizard.createOne("#wizard");
	_w.addOne("#settingWizard .btn-add", "#addModal", '.btn-save');
	/* S editor */
	initSample();
} else{
		
}
});
