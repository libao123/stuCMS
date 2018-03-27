var jsType;
$(function(){
	//Flat red color scheme for iCheck
    $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
      	checkboxClass: 'icheckbox_flat-green',
      	radioClass: 'iradio_flat-green'
    });
    
	if(jsType && jsType == 'infoBase'){
		$("#editInfo").on('click', function(){
			var _modal = $("#infoModal"), _form = _modal.find('form'), _content = $("#content");
			//TODO 找到相应data赋值
			_form.find('input, textarea').each(function(){
				var _t = $(this);
				if(_t.attr('name') != undefined){
					var _eachContent = _content.find('[name='+_t.attr('name')+']');
					if(_t.attr('name') != "skills"){
						_t.val(_eachContent.text());
					}else{
						var dataArr = [];
						_eachContent.find('span').each(function(){
							dataArr.push($(this).text());
						});
						if(dataArr.length > 0){
							_t.val(dataArr);							
						}
						
					}
//					console.log(_eachContent);
				}
			});
			_modal.modal();
		});
		
		$("#personInfo").on('click', '.btn-edit', function(){
			var _form = $("#personInfo"), _input = _form.find('input').not('[name=undefined]');
			console.log(_input);
			_input.each(function(){
				$(this).prop('disabled', false);
				$(this).removeClass('no-border');
			});
			$(this).addClass('hidden');
			$("#personInfo .btn-submit").removeClass('hidden');
		});
		$("#personInfo").on('click', '.btn-submit', function(){
			var _form = $("#personInfo"), _input = _form.find('input').not('[name=undefined]');
			console.log(_input);
			_input.each(function(){
				$(this).prop('disabled', true);
				$(this).addClass('no-border');
			});
			$(this).addClass('hidden');
			$("#personInfo .btn-edit").removeClass('hidden');
		});
		$("#avatar").on('click', function(){
			var _modal = $("#avatarModal"), _form = _modal.find('form');
			
			
			_modal.modal();
		});
	}else if(jsType && jsType == "statistics"){
		
		/* S chartjs*/
		// Get context with jQuery - using jQuery's .get() method.
	    var areaChartCanvas = $("#statisticChart").get(0).getContext("2d");
	    // This will get the first returned node in the jQuery collection.
	    var areaChart = new Chart(areaChartCanvas);
			    
	    var areaChartOptions = {
	      	//Boolean - If we should show the scale at all
	      	showScale: true,
	      	//Boolean - Whether grid lines are shown across the chart
	      	scaleShowGridLines: false,
	      	//String - Colour of the grid lines
	      	scaleGridLineColor: "rgba(0,0,0,.05)",
	      	//Number - Width of the grid lines
	      	scaleGridLineWidth: 1,
	      	//Boolean - Whether to show horizontal lines (except X axis)
	      	scaleShowHorizontalLines: true,
	      	//Boolean - Whether to show vertical lines (except Y axis)
	      	scaleShowVerticalLines: true,
	      	//Boolean - Whether the line is curved between points
	      	bezierCurve: true,
	      	//Number - Tension of the bezier curve between points
	      	bezierCurveTension: 0.3,
	      	//Boolean - Whether to show a dot for each point
	      	pointDot: false,
	      	//Number - Radius of each point dot in pixels
	      	pointDotRadius: 4,
	      	//Number - Pixel width of point dot stroke
	      	pointDotStrokeWidth: 1,
	      	//Number - amount extra to add to the radius to cater for hit detection outside the drawn point
	      	pointHitDetectionRadius: 20,
	      	//Boolean - Whether to show a stroke for datasets
	      	datasetStroke: true,
	      	//Number - Pixel width of dataset stroke
	      	datasetStrokeWidth: 2,
	      	//Boolean - Whether to fill the dataset with a color
	      	datasetFill: true,
	      	//String - A legend template
	      	legendTemplate: "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].lineColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>",
	      	//Boolean - whether to maintain the starting aspect ratio or not when responsive, if set to false, will take up entire container
	      	maintainAspectRatio: true,
	      	//Boolean - whether to make the chart responsive to window resizing
	      	responsive: true
	    };

    	//Create the line chart
    	areaChart.Line(areaChartData, areaChartOptions);
    	
    	/* E chartjs*/
	}else if(jsType && jsType == "commonTable"){
		var _content = $("#content"), 
			_modal = $("#infoModal"), 
			_delModal = $('#delModal');
		try{
			_arr = tableArr;
		}catch(e){
			//TODO handle the exception
			_arr = [];
			console.log(e);
		}
		try{
			//Date picker
		    $('#datepicker').datepicker({
		      autoclose: true
		    });
		}catch(e){
			//TODO handle the exception
		}
		var setValToModal = function(_modal, _row, _arr){
	   		_row.find('td').each(function(){
	    		var _t = $(this), _s = _modal.find('[name='+_arr[_t.index()]+']');
	//  				console.log(_t.index());
	//					console.log(_s);
				if(_s.length > 0){
//					console.log(_s.prop("nodeName"));
					if(_s.prop("nodeName") != 'TEXTAREA'){
						if(_s.attr('type') != "checkbox"){
							_s.val(_t.text());
						}else{
							var _box = _t.find('[name=status]').val();
							if(parseInt(_box) > 0 && parseInt(_box) != undefined)
	//							_s.prop('checked', true);
								_s.iCheck('check');
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
	    	
	    	setValToModal(_modal, _row, _arr);
	    	
	    	_modal.modal();
	    });
	    
	    $(_content).on("click", '.btn-del', function(){
	    	var _row = $(this).parent().parent(),
		    	_form = _modal.find('form');
		    var _id = _row.find('td:eq(0)').text();
			_form.find('input[name=id]').val(_id);
	    	_delModal.modal();
	    });
	    
	}else{
		
	}
});
