<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.UserManage.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript">
    $(function(){
        window.onload = function () {
            if (window.parent) {
                setTimeout(function () {
                    var _pageH = $("body").height();
                    console.log(_pageH);
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
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content" id="content">
		        <div class="row">
			        <div class="col-xs-12">
				        <div id="alertDiv"></div>
				        <div class="box box-default">
					        <table id="tablelist" class="table table-bordered table-striped table-hover">
    				        </table>
				        </div>
			        </div>
		        </div>
	        </section>
        </div>
    </div>
    <!-- 列表界面 结束-->
    <!-- 编辑界面 开始 -->
    <div class="modal" id="tableModal">
        <div class="modal-dialog">
            <form id="form_edit" name="form_edit" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">用户管理</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidUserRoles" name="hidUserRoles" value="" />
                <div class="form-group">
                    <label class="col-sm-2 control-label">用户编码</label>
                    <div class="col-sm-4">
                        <input name="USER_ID" id="USER_ID" type="text" class="form-control" placeholder="用户编码" />
                    </div>
                    <label class="col-sm-2 control-label">用户名</label>
                    <div class="col-sm-4">
                        <input name="USER_NAME" id="USER_NAME" type="text" class="form-control" placeholder="用户名" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">用户类型</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="USER_TYPE" id="USER_TYPE" d_value='<%=head.USER_TYPE %>' ddl_name='ddl_user_type' show_type='t'>
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">所属学院</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="XY_CODE" id="XY_CODE" d_value='<%=head.XY_CODE %>' ddl_name='ddl_department' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">学生类型</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="STU_TYPE" id="STU_TYPE" d_value='<%=head.STU_TYPE %>' ddl_name='ddl_stu_type' show_type='t'>
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">是否辅导员</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="IS_ASSISTANT" id="IS_ASSISTANT" d_value='<%=head.IS_ASSISTANT %>' ddl_name='ddl_yes_no' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">所属角色</label>
                    <div class="col-sm-10">
                        <div id="divUserRole">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">登录密码</label>
                    <div class="col-sm-4">
                        <input name="LOGIN_PW" id="LOGIN_PW" type="password" class="form-control" placeholder="登录密码" />
                    </div>
                    <label class="col-sm-2 control-label">确认密码</label>
                    <div class="col-sm-4">
                        <input name="LOGIN_PW_COMIT" id="LOGIN_PW_COMIT" type="password" class="form-control" placeholder="确认密码" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary btn-save" id="btnSave" onclick="return SaveData();">保存</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 删除界面 结束-->
    <div class="modal modal-warning" id="delModal">
        <div class="modal-dialog">
            <form id="form_del" name="form_del" class="modal-content  form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除</h4>
            </div>
            <div class="modal-body">
                <p>确定要删除该信息？</p>
                <input type="hidden" id="DEL_USER_ID" name="DEL_USER_ID" value="" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-outline btn-save" id="btnDel" onclick="return DeleteData();">确定</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 删除界面 结束-->
    <!-- 列表JS 开始-->
    <script type="text/javascript">
    //列表初始化
	    function loadTableList() {
            //配置表格列
		    tablePackage.filed = [
				    { "data": "USER_ID",
					    "createdCell": function (nTd, sData, oData, iRow, iCol) {
						    $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
					    },
					    "head":	"checkbox", "id":"checkAll"
				    },
                    { "data": "USER_ID", "head":"用户编码"},
				    { "data": "USER_NAME", "head":"用户名"},
				    { "data": "USER_TYPE_NAME", "head":"用户类型" },
				    { "data": "XY_CODE_NAME", "head":"所属学院" },
				    { "data": "USER_ROLE_NAME", "head":"所属角色" },
				    { "data": "IS_ASSISTANT_NAME", "head":"是否辅导员" },
				    { "data": "CREATE_NAME", "head":"最后操作人" },
				    { "data": "CREATE_TIME", "head":"最后操作时间" }
		    ];

		    //配置表格
		    tablePackage.createOne({
                //可ajax ing
			    hasAjax:{
				    type:"server",
				    url:"List.aspx?optype=getlist",
				    method:"GET"
			    },
                //表格参数
			    attrs:	{
				    tableId:"tablelist",//表格id
				    buttonId:"buttonId",//拓展按钮区域id
				    tableTitle:"系统维护 >> 权限设置 >> 用户管理",
				    checkAllId:"checkAll",//全选id
				    tableConfig:{
					    'pageLength':25,//每页显示个数，默认10条
					    'selectSingle':true,//是否单选，默认为true
					    'lengthChange':true//用户改变分页
					    //'ordering':true//是否默认排序，默认为false
				    }
			    },
                //查询栏
			    hasSearch:	{
				    "cols":[
					    {"data":"USER_ID", "pre":"用户编码", "col":1, "type":"input"},
					    {"data":"USER_NAME", "pre":"用户名", "col":2, "type":"input"},
                        {"data":"USER_TYPE", "pre":"用户类型", "col":3, "type":"select", "options":<%=strUserTypeJson %>},
                        {"data":"XY_CODE", "pre":"所属学院", "col":4, "type":"select", "options":<%=strXyJson %>},
				    ],
				    "searchLink":	"#",
			        "searchCallBack":function(res, btn){
			        	console.log(btn);
			        	
			        },
			    },
			    hasModal:	false,//弹出层参数
			    hasBtns:	["reload","add","edit","del"],//需要的按钮
			    hasCtrl:	false
		    });
		}
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload',
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });
			/*弹出页控制*/
			$dataModal.controls({
				"content":	"content",
				"modal":    "tableModal",//弹出层id
				"hasTime":    true,//时间控件控制
				"hasCheckBox":    false,//checkbox控制
				//"addAction":  "Edit.aspx?optype=add",//弹出层url
				//"editAction": "Edit.aspx?optype=edit",//弹出层url
				"submitType":"form",//form或者ajax
				"submitBtn":  ".btn-save",
				"submitCallback":function(btn){
					console.log(btn);
					
				},//自定义方法
				"valiConfig":{
					model:	'#tableModal form',
					validate:[
						{'name':'USER_ID', 'tips':'用户编码必须填'},
						{'name':'USER_NAME', 'tips':'用户名必须填'},
						{'name':'USER_TYPE', 'tips':'用户类型必须填'},
						{'name':'XY_CODE', 'tips':'所属学院必须填'},
						{'name':'IS_ASSISTANT', 'tips':'请选择是否为辅导员'},
						{'name':'LOGIN_PW', 'tips':'密码必须填'},
						{'name':'LOGIN_PW_COMIT', 'tips':'确认密码必须填'},
					],
					callback:function(form){
						console.log(form);
						//SaveData();
					},//验证成功后的操作
				}
			});
			/*删除控制*/
			$delModal.controls({
				"content":"content",
				"delModal":"delModal",//弹出层id
				//"delCol":"delCol",
				//"delAction":"./List.aspx?optype=delete",
				"submitCallBack":function(btn){
					console.log(btn);
					//DeleteData();
				},//点击确定后的反馈方法
			});
        }

        //保存事件
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
            DropDownUtils.initDropDown("USER_TYPE");
            DropDownUtils.initDropDown("XY_CODE");
            DropDownUtils.initDropDown("STU_TYPE");
            DropDownUtils.initDropDown("IS_ASSISTANT");
            //用户角色加载
            GetUserRoleHtml();
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        }
        function loadModalPageValidate() {
            LimitUtils.onlyNum("USER_ID"); //代码限制只能录入数字
            LimitUtils.onlyNumAlpha("LOGIN_PW"); //代码限制只能录入数字或者字母
            LimitUtils.onlyNumAlpha("LOGIN_PW_COMIT"); //代码限制只能录入数字或者字母
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
            if (id == "USER_ID")
                ControlUtils.Input_SetReadOnly("USER_ID", true);
            //确认密码默认为登录密码
            if (id == "LOGIN_PW")
                $("#LOGIN_PW_COMIT").val(value);
            //角色选中加载
            if (id == "USER_ROLE")
                GetCheckBoxSelectedLoad(value);
        }

        //角色选中加载
        function GetCheckBoxSelectedLoad(roles) {
            if (roles.length == 0) {
                $("input[type='checkbox'][name='user_role']").each(function () {
                    $(this).iCheck("uncheck"); //iCheck移除绑定
                });
                return;
            }
            var arrRole = roles.split(',');
            for (var i = 0; i < arrRole.length; i++) {
                if (arrRole[i].toString().length == 0)
                    continue;
                $("input[type='checkbox'][name='user_role']").each(function () {
                    if ($(this).attr('value') == arrRole[i].toString()) {
                        $(this).iCheck("check"); //iCheck绑定
                    }
                });
            }
        }

        //选择角色
        function GetCheckBoxSelected() {
            var checkbox = "";
            $("#hidUserRoles").val("");
            $("input[type='checkbox'][name='user_role']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).attr('value') + ',';
                }
            });

            if (checkbox.length > 0) {
                $("#hidUserRoles").val(checkbox);
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>