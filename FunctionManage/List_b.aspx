<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.BDM.Notice.List" %>

<%@ Register Assembly="HQ.WebControl" Namespace="HQ.WebControl" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
<div class="wrapper">
  <div id="menuFrame" class="content-wrapper" id="main-container">
	<!-- Main content -->
	<section class="content" id="content">
		<div class="row">
			<div class="col-xs-12">
				<div id="alertDiv"></div>
				<div class="box box-default">
					<table id="dataTable1" class="table table-bordered table-striped table-hover">
    				</table>
				</div>
			</div>
		</div>
	</section>
	
  </div>
</div>
		<!-- msg modal -->
		<div class="modal" id="tableModal">
          	<div class="modal-dialog">
	            <form action="#" method="post" name="form" class="modal-content form-horizontal" onsubmit="modalSubmit(this);">
	              	<div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		                  	<span aria-hidden="true">×</span></button>
		                <h4 class="modal-title">公告通知管理</h4>
	              	</div>
	              	<div class="modal-body">
	              		<input name="ID" type="hidden" class="form-control" placeholder="Id" />
						<div class="form-group">
		                  	<label class="col-sm-2 control-label">信息类型</label>
		                  	<div class="col-sm-10">
		                    	<select class="form-control" name="NOTICE_TYPE">
				                    <option value="1">通知公共</option>
				                    <option value="2">消息</option>
	                  			</select>
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">标题</label>
		                  	<div class="col-sm-10">
		                    	<input name="TITLE" type="text" class="form-control" placeholder="" />
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">副标题</label>
		                  	<div class="col-sm-10">
		                    	<input name="SUB_TITLE" type="text" class="form-control" placeholder="" />
		                  	</div>
		                </div>
		                <div class="form-group">
			                <label class="col-sm-2 control-label">开始时间</label>
			                <div class="col-sm-4">
				            	<input type="text" class="form-control timeSingle" name="START_TIME" />
			                </div>
		                	
			                <label class="col-sm-1 control-label">至</label>
			                <div class="col-sm-5">
				            	<input type="text" class="form-control timeSingle" name="END_TIME" />
			                </div>
		            	</div>
		            	<div class="form-group">
		                  	<label class="col-sm-2 control-label">查阅角色</label>
		                  	<div class="col-sm-10">
		                    	<input name="ROLEID" type="text" class="form-control" placeholder="" />
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">发布内容</label>
		                  	<div class="col-sm-10">
		                    	<textarea class="form-control ckEditor" name="ck_editor" id="editor1" rows="4" ></textarea>
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">发布人</label>
		                  	<div class="col-sm-4" style="margin-bottom: 10px;">
		                    	<input name="SEND_NAME" type="text" class="form-control" placeholder="" />
		                  	</div>
		                  	<label class="col-sm-2 control-label">发布时间</label>
		                  	<div class="col-sm-4">
		                    	<input name="SEND_TIME" type="text" class="form-control timeSingle" placeholder="" />
		                  	</div>
		                </div>
	              	</div>
		              	<div class="modal-footer">
		                	<button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
		                	<button type="submit" class="btn btn-primary btn-save">保存</button>
		              	</div>
	            </form>
	            <!-- /.modal-content -->
          	</div>
          	<!-- /.modal-dialog -->
        </div>
	<!-- del -->
	<div class="modal modal-warning" id="delModal">
        <div class="modal-dialog">
          	<form action="./List.aspx?optype=delete" method="POST" name="form" class="modal-content  form-horizontal">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">删除</h4>
              </div>
              <div class="modal-body">
                <p>确定要删除该信息？</p>
                <input type="hidden" name="ID" value="" />
                <input type="hidden" name="TITLE" value="" />
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">取消</button>
                <button type="submit" class="btn btn-outline">确定</button>
              </div>
            </form>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
	<script type="text/javascript">
		$(function () {
		window.onload = function(){
      		if (window.parent) {
      			setTimeout(function(){
	      			var _pageH = $("body").height();
	      			console.log(_pageH);
	      			var _parentIfm = $('#iframe_box', window.parent.document);
	      			if (_parentIfm.height() < _pageH) {
	        			_parentIfm.css({'height':_pageH+5,});
	      			} else{
	      				
	      			}
	      			console.log(_parentIfm.height());
      			}, 200);
      		}
      	}
		tablePackage.filed = [//配置表格各栏参数
				{ "data": "ID",
					"createdCell": function (nTd, sData, oData, iRow, iCol) {
						$(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
					},
					"head":	"checkbox", "id":"checkAll",
				},
				{ "data": "NOTICE_TYPE", "head":"信息类型"},
				{ "data": "TITLE", "head":"标题" },
				{ "data": "START_TIME", "head":"信息有效开始时间" },
				{ "data": "END_TIME", "head":"信息有效结束时间" },
				{ "data": "ROLEID", "head":"可查阅角色" },
				{ "data": "SEND_NAME", "head":"发布人" },
				{ "data": "SEND_TIME", "head":"发布时间" },
		];
		/////////////////////////////////////////////////////
					tablePackage.createOne({
						hasAjax:{//可ajax ing
							/*~client~*/
							//type:"client",//server是服务器分页，client是客户端分页，必须
							//url:"./json/long.json",//必须
							//method:"GET",//默认GET
							/*~server~*/
							type:"server"
							url:"./Notice/List.aspx?optype=getlist",
							method:"GET",
						},
						attrs:	{//表格参数
							tableId:"dataTable1",//表格id
							buttonId:"buttonId",//拓展按钮区域id
							tableTitle:"公共信息",
							checkAllId:"checkAll",//全选id
							tableConfig:{
								'pageLength':25,//每页显示个数，默认10条
								'selectSingle':true,//是否单选，默认为true
								'lengthChange':true,//用户改变分页
								//'ordering':true,//是否默认排序，默认为false
							}
						},
						hasSearch:	{
							"cols":[
								{"data":"NOTICE_TYPE", "pre":"公共类型", "col":1, "type":"select", "options":[{'text':'通知公共', 'value':'通知公共'}, {'text':'消息', 'value':'消息'}]},
								{"data":"TITLE", "pre":"公共标题", "col":2, "type":"input"},
							],
						},
						//hasModal:	modalConfigs,//弹出层参数
						hasModal:	false,//弹出层参数
						hasBtns:	["reload","add","edit","del"],//需要的按钮
						hasCtrl:	{
							"buildModal":	false,
						},
					});
			//ctrl
			var _content = $("#content"), 
				_btns = {
					reload:	'.btn-reload',
					add:	'.btn-add',
					del:	'.btn-del',
					edit:	'.btn-edit',
				};
			if($(".timeSingle").length > 0){
				var dateConfig = {
					'type':'single',//类型，range或者single或者default
					'pluginConfig':{},//时间样式配置
					'dateId':'.timeSingle',//选择的位置
				}
				datePackage.init(dateConfig);
			}
			var loadEditor = function(id) {
	            var instance = CKEDITOR.instances[id];
	            if (instance) {
	                CKEDITOR.remove(instance);
	            }
	            //CKEDITOR.replace(id, { customConfig: '../common/js/plugins/ckeditor/config.js' });
	            CKEDITOR.replace(id);
	        }
			var editorid = "editor1";
            loadEditor(editorid);
            //CKEDITOR.on('instanceReady', function (e) {
            //});
			_content.on('click', _btns.reload, function(){
				tablePackage.reload();
			});
			_content.on('click', _btns.add, function(){
				var _modal = $("#tableModal");
				var _form = _modal.find('form');
				_form.attr({
					action:'Edit.aspx?optype=add',
				});
				_modal.find('input, textarea').each(function(){
			    	$(this).val('');
			    });
		    	_modal.modal();
			});
			_content.on('click', _btns.del, function(){
				var $d = tablePackage.selection();
				var _delModal = $('#delModal');
				if ($d != undefined && $d.length > 0) {
					var _form = _delModal.find('form');
					_form.find('input').each(function(){
						var _t = $(this);
						if(_t.attr('name') != undefined){
							var valArr = [];
							for (var j = 0; j < $d.length; j++) {
								valArr.push($d[j][_t.attr('name')]);
							}
							_form.find('input[name='+_t.attr('name')+']').val(valArr);
						}
					});
					_delModal.modal();
				}else{

				}
			});
			_content.on('click', _btns.edit, function(){
				var _modal = $("#tableModal");
				var _form = _modal.find('form');
				_form.attr({
					action:'Edit.aspx?optype=edit',
				});
				var $d = tablePackage.selectSingle();
				var setValToModal = function(_data){
					for (var e in _data) {
						if (_data.hasOwnProperty(e)) {
							var _s = _modal.find('[name='+e+']');
							if(_s.length > 0){
								var _val = _data[e];
								//console.log(_s.prop("nodeName"));
								if(_s.prop("nodeName") != 'TEXTAREA' && _s.prop('nodeName') != "SELECT"){
									if(_s.attr('type') == "checkbox"){
										if(parseInt(_val) > 0 && _val != undefined && _val != ''){
											_s.prop('checked', true);
										}else{
											_s.prop('checked', false);
										}
									}else if(_s.attr('type') == "file"){
	
									}else{
										_s.val(_val);
									}
								}else if(_s.prop('nodeName') == "SELECT") {
									_s.val(_val);
								}else{
									if (_s.className('ckEditor')) {
										var editorElement = CKEDITOR.document.getById(_s.attr('id'));
										editorElement.setHtml(
							      			_val
							      		);
									} else{
										_s.val(_val);
									}
								}
							}
						}
					}
				};
				if (JSON.stringify($d) != "{}") {
					console.log($d);
					setValToModal($d);
					_modal.modal();
				}else {
					//console.log($d);
				}
				return false;
			});
			////验证
			validatePackage.init({
    			model:	'#tableModal form',
    			config: {
	              	rules : {//input 的name 属性的值
	                  	TITLE : {
	                      	required : true
	                  	},
	                  	START_TIME : {
	                      	required : true
	                  	},
	                  	END_TIME : {
	                      	required : true
	                  	},
	                  	ckEditor:{
	                  		required:true
	                  	},
	              	},
	              	messages : {//相应提示语
	                  	TITLE : {
	                      	required : "标题必须填。"
	                  	},
	                  	START_TIME : {
	                      	required : "开始时间必须填。"
	                  	},
	                  	END_TIME : {
	                      	required : "结束时间必须填。"
	                  	},
	                  	ckEditor:{
	                  		required:"发布内容不能为空"
	                  	},
	              	},
            	},
    		});
		});
		
		function modalSubmit(e){
    		console.log(e);
    		var _form = $(e);	
    		console.log(_form);	
    		return false;
    	}
    </script>
</asp:Content>