<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.BDM.Notice.List" %>

<%@ Register Assembly="HQ.WebControl" Namespace="HQ.WebControl" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript">
    $(function(){
        window.onload = function () {
            if (window.parent) {
                setTimeout(function () {
                    var _pageH = $("body").height();
                    var _parentIfm = $('#iframe_box', window.parent.document);
                    if (_parentIfm.height() < _pageH) {
                        _parentIfm.css({ 'height': _pageH + 5 });
                    } else {

                    }
                    console.log(_parentIfm.height());
                }, 200);
            }
        }
        loadTableList();
        loadModalBtnInit();
        loadModalPageDataInit();
        loadModalPageValidate();
    });
</script>
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
	            <form action="#" method="post" name="form" class="modal-content form-horizontal" onsubmit="">
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
		                    	<select class="form-control" name="NOTICE_TYPE" id="NOTICE_TYPE" d_value='<%=head.NOTICE_TYPE %>' ddl_name='ddl_notice_type' show_type='t'>
	                  			</select>
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">标题</label>
		                  	<div class="col-sm-10">
		                    	<input name="TITLE" type="text" class="form-control" placeholder="" d_value='<%=head.TITLE %>' ddl_name='ddl_title' show_type='t' />
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">副标题</label>
		                  	<div class="col-sm-10">
		                    	<input name="SUB_TITLE" type="text" class="form-control" placeholder="" d_value='<%=head.SUB_TITLE %>' ddl_name='ddl_sub_title' show_type='t' />
		                  	</div>
		                </div>
		                <div class="form-group">
			                <label class="col-sm-2 control-label">开始时间</label>
			                <div class="col-sm-4">
				            	<input type="text" class="form-control timeSingle" name="START_TIME" d_value='<%=head.START_TIME %>' ddl_name='start_time' show_type='t' />
			                </div>

			                <label class="col-sm-1 control-label">至</label>
			                <div class="col-sm-5">
				            	<input type="text" class="form-control timeSingle" name="END_TIME" d_value='<%=head.END_TIME %>' ddl_name='end_time' show_type='t' />
			                </div>
		            	</div>
		            	<div class="form-group">
		                  	<label class="col-sm-2 control-label">查阅角色</label>
		                  	<div class="col-sm-10">
		                    	<input name="ROLEID" type="text" class="form-control" placeholder="" d_value='<%=head.ROLEID %>' ddl_name='roleid' show_type='t' />
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">发布内容</label>
		                  	<div class="col-sm-10">
		                    	<textarea class="form-control ckEditor" name="ck_editor" id="editor1" rows="4" d_value='<%=head.ck_editor %>' ddl_name='ck_editor' show_type='t'></textarea>
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">发布人</label>
		                  	<div class="col-sm-4" style="margin-bottom: 10px;">
		                    	<input name="SEND_NAME" type="text" class="form-control" placeholder="" d_value='<%=head.SEND_NAME %>' ddl_name='send_name' show_type='t' />
		                  	</div>
		                  	<label class="col-sm-2 control-label">发布时间</label>
		                  	<div class="col-sm-4">
		                    	<input name="SEND_TIME" type="text" class="form-control timeSingle" placeholder="" d_value='<%=head.SEND_TIME %>' ddl_name='send_time' show_type='t' />
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
                <input type="hidden" id="DEL_ID" name="DEL_ID" value="" />
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

		function loadTableList() {
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
				{ "data": "SEND_TIME", "head":"发布时间" }
			];
			tablePackage.createOne({
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
						'serverSide': false,//如果是服务器方式，必须要设置为true
			      'ajax' : {//通过ajax访问后台获取数据
			    	  "url": "../json/long.json",//后台地址
			      },

					}
				},
				hasSearch:	{
					"cols":[
						{"data":"NOTICE_TYPE", "pre":"公共类型", "col":1, "type":"select", "options":<%=strNOTICETypeJson %>},
						{"data":"TITLE", "pre":"公共标题", "col":2, "type":"input"},
					],
				},
				hasBtns:	["reload","add","edit","del"]//需要的按钮
			});
		}
		function loadModalBtnInit(){
			//ctrl
			var _content = $("#content"),
				_btns = {
					reload:	'.btn-reload',
				};
			var loadEditor = function(id) {
	      var instance = CKEDITOR.instances[id];
	      if (instance) {
	        CKEDITOR.remove(instance);
	      }
	      CKEDITOR.replace(id);
	    }
			var editorid = "editor1";
      loadEditor(editorid);
			_content.on('click', _btns.reload, function(){
				tablePackage.reload();
			});
    		$dataModal.controls({
		        "content":	"content",
		        "modal":      "tableModal",//弹出层id
		        "hasTime":    true,//时间控件控制
		        "submitType":"form",//form或者ajax
		        "submitBtn":  ".btn-save",
		        "submitCallback":function(btn){
    					console.log(btn);

    				},//ajax下自定义ajax方法
    				"valiConfig":{
    					model:	'#tableModal form',
    					validate:[
    						{'name':'TITLE', 'tips':'标题必须填。'},
    						{'name':'START_TIME', 'tips':'开始时间必须填。'},
    						{'name':'END_TIME', 'tips':'结束时间必须填。'},
    						{'name':'ckEditor', 'tips':'发布内容不能为空。'},
    					],
    					callback:function(form){
    						console.log(form);
    						SaveData();
    					}//验证成功后的操作
    				}
      		});
      		$delModal.controls({
		      	"content":"content",
		        "delModal":"delModal",//弹出层id
		        //"delCol":"delCol",
		        //"delAction":"./List.aspx?optype=delete",
		        "submitCallBack":function(btn){
    					console.log(btn);
    					DeleteData();
    				}
      		});
		}
		function SaveData() {
            GetCheckBoxSelected(); //获得选中的用户角色
            if ($("#hidUserRoles").val().length == 0) {
                easyAlert.timeShow("请选择用户所属角色！");
                return false;
            }

            var password = $("#LOGIN_PW").val();
            var password_comit = $("#LOGIN_PW_COMIT").val();
            if (password != password_comit) {
                easyAlert.timeShow("密码与确认密码不一致，请确认！");
                return false;
            }

            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length == 0) {
                    easyAlert.timeShow("保存失败！");
                    return;
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    tablePackage.reload();
                }
            });
        }

        //删除事件
        function DeleteData() {
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=delete"), $("#form_del").serialize(), function (msg) {
                if (msg.length == 0) {
                    easyAlert.timeShow("保存失败！");
                    return;
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    tablePackage.reload();
                }
            });
        }
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            // DropDownUtils.initDropDown("USER_TYPE");
            // DropDownUtils.initDropDown("XY_CODE");
            // DropDownUtils.initDropDown("STU_TYPE");
            // DropDownUtils.initDropDown("IS_ASSISTANT");
            // //用户角色加载
            // GetUserRoleHtml();
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        }

        function loadModalPageValidate() {
            // LimitUtils.onlyNum("USER_ID"); //代码限制只能录入数字
            // LimitUtils.onlyNumAlpha("LOGIN_PW"); //代码限制只能录入数字或者字母
            // LimitUtils.onlyNumAlpha("LOGIN_PW_COMIT"); //代码限制只能录入数字或者字母
        }
        //获得初始角色HTML
        function GetUserRoleHtml() {
            $("#divUserRole").html('');
            var result = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getuserrole');
            if (result.length > 0)
                $("#divUserRole").html(result);
        }

        //编辑状态下，个性化处理
        function ModalPage_ModiStatus(id, value) {
            //修改时，用户编码不能修改
            // if (id == "USER_ID")
            //     ControlUtils.Input_SetReadOnly("USER_ID", true);
            // //确认密码默认为登录密码
            // if (id == "LOGIN_PW")
            //     $("#LOGIN_PW_COMIT").val(value);
            // //角色选中加载
            // if (id == "USER_ROLE")
            //     GetCheckBoxSelectedLoad(value);
        }
    </script>
</asp:Content>
