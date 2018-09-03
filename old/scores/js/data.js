var jsType = jsType || '';
var tableArr = tableArr || [];
$(function(){
	if(jsType && jsType == "commonTable"){
		var _content = $("#content"), 
			_modal = $("#infoModal"), 
			_delModal = $('#delModal'),
			_enterModal = $("#enterModal");
//		try{
//			//Date picker
//		    $('#datepicker').datepicker({
//		      autoclose: true
//		    });
//		}catch(e){
//			//TODO handle the exception
//		}

		if(_enterModal.length > 0){
			$("#dataEnter").on('click', function(){
				var _modal = $("#enterModal");				
				_modal.modal();
			});
		}
		
		var setValToModal = function(_modal, _row, _arr){
	   		_row.find('td').each(function(){
	    		var _t = $(this), _s = _modal.find('[name='+_arr[_t.index()]+']');
				if(_s.length > 0){
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
	    
	}else if(jsType == "chart"){
		/* S chart */
		var pieChartCanvas = $("#pieChart").get(0).getContext("2d");
	    var pieChart = new Chart(pieChartCanvas);
	    
	    var pieOptions = {
	      	//Boolean - Whether we should show a stroke on each segment
	      	segmentShowStroke: true,
	      	//String - The colour of each segment stroke
	      	segmentStrokeColor: "#fff",
	      	//Number - The width of each segment stroke
	      	segmentStrokeWidth: 2,
	      	//Number - The percentage of the chart that we cut out of the middle
	      	percentageInnerCutout: 50, // This is 0 for Pie charts
	      	//Number - Amount of animation steps
	      	animationSteps: 100,
	      	//String - Animation easing effect
	      	animationEasing: "easeOutBounce",
	      	//Boolean - Whether we animate the rotation of the Doughnut
	      	animateRotate: true,
	      	//Boolean - Whether we animate scaling the Doughnut from the centre
	      	animateScale: false,
	      	//Boolean - whether to make the chart responsive to window resizing
	      	responsive: true,
	      	// Boolean - whether to maintain the starting aspect ratio or not when responsive, if set to false, will take up entire container
	      	maintainAspectRatio: true,
	      	//String - A legend template
	      	legendTemplate: "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<segments.length; i++){%><li><span style=\"background-color:<%=segments[i].fillColor%>\"></span><%if(segments[i].label){%><%=segments[i].label%><%}%></li><%}%></ul>"
	    };
	    //Create pie or douhnut chart
	    // You can switch between pie and douhnut using the method below.
	    pieChart.Doughnut(PieData, pieOptions);
	    
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

	}
	
});
