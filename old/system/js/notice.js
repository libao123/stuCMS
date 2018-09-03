$(function(){
//				$("#testModal").modal();
//	var msgType = "#msgType", msgManager = "#msgManager";
//	//Date range picker
//  $('#reservation').daterangepicker({
//  	timePicker: false,
//  	format: 'YYYY/MM/DD',
//  });
//  $(msgType+","+msgManager).on('click', function(){
//  	var _modal = "#"+$(this).attr('id')+"Modal",
//  		_form = _modal.find('form');
//  	//TODO 根据入口modal赋值_form的action，还有相关信息
//  	switch ($(this).attr('id')){
//  		case "msgType":
//  			_form.attr('action', 'xxx');
//  			break;
//  		case "msgManager":
//  			_form.attr('action', 'xxx');
//  			break;
//  		default:
//  			break;
//  	}
//  	$(_modal).modal();
//  });
//  //Flat red color scheme for iCheck
    $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
      	checkboxClass: 'icheckbox_flat-green',
      	radioClass: 'iradio_flat-green'
    });
//  /* tables */
   	var _msgType = "#msgType", _msgManager = "#msgManager";
   	var setValToModal = function(_modal, _row, _arr){
   		_row.find('td').each(function(){
    		var _t = $(this), _s = _modal.find('[name='+_arr[_t.index()]+']');
//  				console.log(_t.index());
//					console.log(_s);
			if(_s.length > 0){
				console.log(_s.prop("nodeName"));
				if(_s.prop("nodeName") != 'TEXTAREA'){
					if(_s.attr('type') != "checkbox"){
						_s.val(_t.text());
					}else{
						var _box = _t.find('[name=status]').val();
						console.log(parseInt(_box))
						
						if(parseInt(_box) > 0)
							_s.iCheck('check');
//							_s.prop('checked', true);
						else
//							_s.prop('checked', false);
							_s.iCheck('uncheck');
					}
				}else{
					_s.val(_t.text());
				}
			}
    	});
   	}

    $(_msgType+","+_msgManager).on("click", '.btn-add', function(){
    	var _section = $(this).parentsUntil("section").parent(), 
	    	_modal = $("#"+_section.attr('id')+'Modal'),
	    	_form = _modal.find('form');
    	console.log(_modal);
    	//TODO 根据入口modal赋值_form的action，还有相关信息
    	switch (_section.attr('id')){
    		case "msgType":
    			_form.attr('action', 'xxx');
    			break;
    		case "msgManager":
    			_form.attr('action', 'xxx');
    			break;
    		default:
    			break;
    	}
    	_modal.find('input').each(function(){
    		$(this).val('');
    	});
    	_modal.find('textarea').each(function(){
    		$(this).val('');
    	});
    	_modal.modal();
    });
    $(_msgType+","+_msgManager).on("click", '.btn-edit', function(){
    	var _section = $(this).parentsUntil("section").parent(), 
	    	_modal = $("#"+_section.attr('id')+'Modal'),
	    	_row = $(this).parent().parent(),
	    	_tds = $(this).parents(),
	    	_form = _modal.find('form');
    	//TODO 把_row里的data赋值给modal里的表单，还有action信息等
    	console.log(_row.find('td'));
    	switch (_section.attr('id')){
    		case "msgType":
    			_form.attr('action', 'xxx');
    			var _arr = ['id', 'category', 'content'];
				setValToModal(_modal, _row, _arr);
    			break;
    		case "msgManager":
    			_form.attr('action', 'xxx');
    			var _arr = ['id', 'category', 'content', 'status'];
				setValToModal(_modal, _row, _arr);
    			break;
    		default:
    			break;
    	}
    	_modal.modal();
    });
    
    $(_msgType+","+_msgManager).on("click", '.btn-del', function(){
    	var _section = $(this).parentsUntil("section").parent(), 
	    	_row = $(this).parent().parent(),
	    	_modal = $('#delModal'),
	    	_form = _modal.find('form');
    	//TODO 根据入口modal赋值_form的action，还有相关信息
    	switch (_section.attr('id')){
    		case "msgType":
    			_form.attr('action', 'xxx');
    			break;
    		case "msgManager":
    			_form.attr('action', 'xxx');
    			break;
    		default:
    			break;
    	}
    	_modal.modal();
    });
    
//  $('#example2').DataTable({
//    "paging": true,
//    "lengthChange": false,
//    "searching": false,
//    "ordering": true,
//    "info": true,
//    "autoWidth": false,
//    "ajax": "",
//    "columns": [
//    	{'title': 'id', data: null},
//    	{'title': 'sex', data: null},
//    	{'title': 'name', data: null},
//    	{'title': 'opera', data: null},
//    ],
//  });
});