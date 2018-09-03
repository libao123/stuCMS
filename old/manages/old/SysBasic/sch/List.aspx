<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.SysBasic.sch.List" ValidateRequest="false"%>

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
    <!--<script type="text/javascript">
        $(function () {
            PageUtils.initComboBox();
        });

        //保存
        function SaveInfo() {
            if (FormUtils.validateForm() == false) {
                MsgUtils.info("请输入必填项！");
                return false;
            }

            $.post(MiscUtils.FormatUrl('List.aspx?optype=save'),
            $("#form_sch").serialize(), function (msg) {
                if (msg.length == 0) {
                    MsgUtils.info("保存失败！");
                    return false;
                }
            });

            return true;
        }
    </script>-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
<div class="wrapper">
  <div class="content-wrapper" id="main-container">
	<!-- Main content -->
	<section class="content" id="content">
		<div class="row">
			<div class="col-xs-12">
				<div id="alertDiv"></div>
				<div class="box box-default">
					<form action="#" method="post" name="form" class="modal-content form-horizontal" onsubmit="return false;">
	              	<div class="modal-header">
		                <h4 class="modal-title">当前学年设置</h4>
	              	</div>
	              	<div class="modal-body">
	              		<input name="ID" type="hidden" class="form-control" placeholder="Id" />
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">学校名称</label>
		                  	<div class="col-sm-10">
		                    	<input name="SCHOOL_NAME" type="text" class="form-control" placeholder="" />
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">当前学年</label>
		                  	<div class="col-sm-10">
		                    	<select class="form-control" name="CURRENT_YEAR">
		                    		<option value="2018-2019">2018-2019</option>
				                    <option value="2017-2018">2017-2018</option>
				                    <option value="2016-2017">2016-2017</option>
	                  			</select>
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">当前学期</label>
		                  	<div class="col-sm-10">
		                    	<select class="form-control" name="CURRENT_YEAR">
		                    		<option value="1">上</option>
				                    <option value="2">下</option>
	                  			</select>
		                  	</div>
		                </div>
		                <div class="form-group">
			                <label class="col-sm-2 control-label">当前学年</label>
			                <div class="col-sm-10">
				            	<input type="text" class="form-control timeSingle" name="CURRENT_YEAR" />
			                </div>

		            	</div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">简介</label>
		                  	<div class="col-sm-10">
		                    	<textarea class="form-control ckEditor" name="REMARK" id="editor1" rows="4" ></textarea>
		                  	</div>
		                </div>
		                <!-- -->
	              	</div>
		            <div class="modal-footer">
		            	<button type="submit" class="btn btn-primary pull-left btn-save">保存</button>
		            </div>
	            	</form>

				</div>
			</div>
		</div>
	</section>

  </div>
</div>

<script type="text/javascript">
      function loadModalBtnInit(){
        var loadEditor = function(id) {
            var instance = CKEDITOR.instances[id];
            if (instance) {
                CKEDITOR.remove(instance);
            }
            CKEDITOR.replace(id);
        }
        var editorid = "editor1";
        loadEditor(editorid);
        $dataModal.controls({
          "content":	"content",
          "modal":      "content",//弹出层id
          "hasTime":    true,//时间控件控制
          "modalAction":  "Edit.aspx?optype=edit",//弹出层url
          "submitType":"form",//form或者ajax
          "submitCallback":function(btn){
            console.log(btn);
          },//ajax下自定义ajax方法
          "valiConfig":{
            model:	'#content form',
            validate:[
              {'name':'SCHOOL_NAME', 'tips':'请输入学校名称。'},
              {'name':'CURRENT_YEAR', 'tips':'请选择学年。'},
              {'name':'CURRENT_YEAR', 'tips':'请选择学期。'},
              {'name':'REMARK', 'tips':'简介不能为空。'},
            ],
            callback:function(form){
              console.log(form);
              form.submit();
            },
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
