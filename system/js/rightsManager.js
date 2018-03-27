$(function(){
	/* members */
	var members = "#members", memArr = [];
	var _row = $(members).find('table tr')[1];
	$(_row).find('td').each(function(){
		var _t = $(this);
		if(_t.attr('name') != undefined && _t.attr('name') != '' && _t.attr('name') != null){
			memArr.push(_t.attr('name'));
		}
	});
	console.log(memArr);
	/* actor */
	var actor = "#actor", actorArr = [];
	var _row = $(actor).find('table tr')[1];
	$(_row).find('td').each(function(){
		var _t = $(this);
		if(_t.attr('name') != undefined && _t.attr('name') != '' && _t.attr('name') != null){
			actorArr.push(_t.attr('name'));
		}
	});
	/* group */
	var group = "#group", groupArr = [];
	var _row = $(group).find('table tr')[1];
	$(_row).find('td').each(function(){
		var _t = $(this);
		if(_t.attr('name') != undefined && _t.attr('name') != '' && _t.attr('name') != null){
			groupArr.push(_t.attr('name'));
		}
	});
	
   	var setValToModal = function(_modal, _row, _arr){
   		_row.find('td').each(function(){
    		var _t = $(this), _s = _modal.find('[name='+_arr[_t.index()]+']');
			if(_s.length > 0){
				console.log(_s.prop("nodeName"));
				if(_s.prop("nodeName") != 'TEXTAREA' && _s.prop("nodeName") != 'SELECT'){
					if(_s.attr('type') != "checkbox"){
						_s.val(_t.text());
					}else{
						var _box = _t.find('[name=status]').val();
						if(parseInt(_box) > 0 && parseInt(_box) != undefined)
							_s.iCheck('check');
						else
							_s.iCheck('uncheck');
					}
				}else if(_s.prop("nodeName") == 'SELECT'){
//					_s.val(_t.text());
					_s.find('option').each(function(){
						if($(this).text() == _t.text()){
							$(this).prop('selected', true);
						}
					});
				}else{
					_s.val(_t.text());
				}
			}
    	});
   	}	
	$(members+','+actor+','+group).on('click', '.btn-add', function(){
		var _section = $(this).parentsUntil("section").parent(), 
	    	_modal = $("#"+_section.attr('id')+'Modal'),
	    	_form = _modal.find('form');
	    //
	    _modal.find('input').each(function(){
    		$(this).val('');
    	});
    	_modal.find('option:selected').each(function(){
    		$(this).prop('selected', false);
    	});
    	_modal.find('textarea').each(function(){
    		$(this).val('');
    	});
    	switch (_section.attr('id')){
    		case "members":
    			_form.attr('action', 'xxx');
    			break;
    		case "actor":
    			_form.attr('action', 'XXXXX');
    			break;
    		default:
    			break;
    	}
	    _modal.modal();
	});
	$(members+','+actor+','+group).on('click', '.btn-edit', function(){
		var _section = $(this).parentsUntil("section").parent(), 
	    	_modal = $("#"+_section.attr('id')+'Modal'),
	    	_row = $(this).parent().parent(),
	    	_tds = $(this).parents(),
	    	_form = _modal.find('form');
	    //
	    switch (_section.attr('id')){
    		case "members":
    			_form.attr('action', 'xxx');
				setValToModal(_modal, _row, memArr);
    			break;
    		case "actor":
    			_form.attr('action', 'xxx');
				setValToModal(_modal, _row, actorArr);
    			break;
    		default:
    			break;
    	}
	    _modal.modal();
	});
	
});
