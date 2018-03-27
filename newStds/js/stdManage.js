var jsType = jsType || '';
var tableArr = tableArr || [];

$(function(){
  //Flat red color scheme for iCheck
//$('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
//	checkboxClass: 'icheckbox_flat-green',
//	radioClass: 'iradio_flat-green'
//});
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

		// var setValToModal = function(_modal, _row, _arr){
	  //  		_row.find('td').each(function(){
	  //   		var _t = $(this), _s = _modal.find('[name='+_arr[_t.index()]+']');
  	// 			if(_s.length > 0){
  	// 				if(_s.prop("nodeName") != 'TEXTAREA'){
  	// 					if(_s.attr('type') != "checkbox"){
  	// 						_s.val(_t.text());
  	// 					}else{
  	// 						var _box = _t.find('[name=status]').val();
  	// 						if(parseInt(_box) > 0 && parseInt(_box) != undefined){
  	// 							_s.iCheck('check');
  	// 						}else{
  	// 							_s.iCheck('uncheck');
    //             }
  	// 					}
  	// 				}else{
  	// 					_s.val(_t.text());
  	// 				}
  	// 			}
	  //   	});
	  //  	}

		// $(_content).on("click", '.btn-add', function(){
	  //   	var _form = _modal.find('form');
	  //   	_form.find('input, textarea').each(function(){
	  //   		$(this).val('');
	  //   	});
	  //   	_modal.modal();
	  // });

	  // $(_content).on("click", '.btn-edit', function(){
	  // 	var _row = $(this).parent().parent(),
		//       _tds = $(this).parents(),
		//   	  _form = _modal.find('form');
	  //   //TODO 把_row里的data赋值给modal里的表单，还有action信息等
	  //   if(tableArr.length > 0){
		// 	  setValToModal(_modal, _row, tableArr);
	  //     _modal.modal();
	  //   }else{
	  //   	return false;
	  //   }
    //
	  // });

	  // $(_content).on("click", '.btn-del', function(){
	  // 	var _row = $(this).parent().parent(),
		//       _form = _modal.find('form');
		// 	var _id = _row.find('td:eq(0)').text();
		// 	_form.find('input[name=id]').val(_id);
	  //   _delModal.modal();
	  // });

//    var buildData = function(data, type){
//      if(type == 'operate'){
//        var _operateBtn = '<button type="button" class="btn btn-block btn-primary btn-xs btn-edit">编辑</button><button type="button" class="btn btn-block btn-warning btn-xs btn-del">删除</button>';
//        for (var i = 0; i < data.length; i++) {
//          // grid_data[i]['']
//          data[i]['operate'] = _operateBtn;
//        }
//      }
//      console.log(data);
//      return data;
//    };

      // $('#dataTable1').DataTable({
      //   "data": buildData(grid_data, 'operate'),
      //   //使用对象数组，一定要配置columns，告诉 DataTables 每列对应的属性
      //   //data 这里是固定不变的，name，position，salary，office 为你数据里对应的属性
      //   columns: [
      //     { data: 'id' },
      //     { data: 'name' },
      //     { data: 'note' },
      //     { data: 'stock' },
      //     { data: 'ship' },
      //     { data: 'sdate' },
      //     { data: 'operate' },
      //   ],
      //   "paging": true,
      //   "lengthChange": false,
      //   "searching": true,
      //   "ordering": true,
      //   "info": false,
      //   "autoWidth": false,
      //   // "scrollX": true,
      //   "ordering":  false,
      //   "responsive": true,
      //   // "columnDefs": [
      //   //   { responsivePriority: 1, targets: 0 },
      //   //   { responsivePriority: 2, targets: -1 }
      //   // ],
      //   // "dom": 'Bfrtip',
      //   // "buttons": ['colvis', 'excel', 'print'],
      // });
//    <th name="name">name</th>
//									            <th name="sex">sex</th>
//									            <th name="birthday">birthday</th>
//									            <th name="phone">phone</th>
//												<th name="id_card">id card</th>
//												<th name="address">address</th>
//												<th name="college">college</th>
//												<th name="major">major</th>
//				var columns = [
//					{ "data": 'check' },
//		    	{ "data": 'id' },
//		      { "data": 'name' },
//		      { "data": 'sex' },
//		      { "data": 'birthday' },
//		      { "data": 'phone' },
//		      { "data": 'id_card' },
//		      { "data": 'address' },
//		      { "data": 'college' },
//		      { "data": 'major' },
//		      { "data": 'operate' },
//				]
//    	var tableConfig = {
//		        'table': '#dataTable1',
//		        'config':{
//		        	"data": buildData(grid_data, 'operate'),
//		          "columns": columns,
//		        }
//		    };
//		    var EventConfig = {
//		        "content":    "#content",
//		        "table":      "#dataTable1",
//		        "modal":      "#dataModal",
//		        "addBtn":     ".btn-add",
//		        "editBtn":    ".btn-edit",
//		        "delModal":   "#delModal",
//		        "delBtn":     ".btn-del",
//		        "submitType": "form",
//		        "columns":		columns,
//		    };
      var a = bootDataTable.init(tableConfig, EventConfig, modalConfig);
      //
      $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
		  	checkboxClass: 'icheckbox_flat-green',
		  	radioClass: 'iradio_flat-green'
		  });
      $("#checkAll").on('change', function(){
      	var _t = $(this);
      	$("#dataTable1").find('input[name=check]').each(function(){
      		$(this).prop("checked", _t.prop("checked"));
      	});
      });
      $("#dataTable1").find('input[name=check]').on("click", function(){
      	var _t = $(this);
      });
      ///////////////////
      // var table = $('#table_id_example').DataTable({
      // //这样配置后，即可用DT的API来访问表格数据
      //   columns: [
      //     {data: "column1"},
      //     {data: "column2"}
      //   ]
      // });
      // //给行绑定选中事件
      // $('#table_id_example tbody').on( 'click', 'tr', function () {
      //   if ($(this).hasClass('selected')) {
      //     $(this).removeClass('selected');
      //   }else {
      //     table.$('tr.selected').removeClass('selected');
      //     $(this).addClass('selected');
      //   }
      // } );
      // //给按钮绑定点击事件
      // $("#table_id_example_button").click(function () {
      //   var column1 = table.row('.selected').data().column1;
      //   var column2 = table.row('.selected').data().column2;
      //   alert("第一列内容："+column1 + "；第二列内容： " + column2);
      // });

	}

});
