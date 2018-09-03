<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.UserManage.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList;
        var xyList; //学院列表
        var _form_edit;
        $(function () {
            adaptionHeight();
            //编辑页form定义
            _form_edit = PageValueControl.init("form_edit");

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
            <section class="content-header">
			<h1>用户管理</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">用户管理</li>
			</ol>
		</section>
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
    <div class="modal fade" id="tableModal">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">用户管理</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidUserRoles" name="hidUserRoles" value="" />
                <input type="hidden" id="hidAllXy" name="hidAllXy" />
                <input type="hidden" id="hidSelDelXy" name="hidSelDelXy" />
                <div class="form-group">
                    <label class="col-sm-3 control-label">用户编码</label>
                    <div class="col-sm-9">
                        <input name="USER_ID" id="USER_ID" type="text" class="form-control" placeholder="用户编码" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">用户名</label>
                    <div class="col-sm-9">
                        <input name="USER_NAME" id="USER_NAME" type="text" class="form-control" placeholder="用户名" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">用户类型</label>
                    <div class="col-sm-9">
                        <select class="form-control" name="USER_TYPE" id="USER_TYPE" d_value='' ddl_name='ddl_user_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">所属学院（可多选）</label>
                    <div class="col-sm-9">
                        <div class="box-body with-border" id="div_xy">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"></label>
                    <div class="col-sm-9">
                        <button type="button" class="btn btn-primary pull-right" id="btnDel_XY">删除所选学院</button>
                        <button type="button" class="btn btn-primary " id="btnAdd_XY">新增学院</button>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">学生类型</label>
                    <div class="col-sm-9">
                        <select class="form-control" name="STU_TYPE" id="STU_TYPE" d_value='' ddl_name='ddl_ua_stu_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">是否辅导员</label>
                    <div class="col-sm-9">
                        <select class="form-control" name="IS_ASSISTANT" id="IS_ASSISTANT" d_value='' ddl_name='ddl_yes_no' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">所属角色</label>
                    <div class="col-sm-9">
                        <div id="divUserRole">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">登录密码</label>
                    <div class="col-sm-9">
                        <input name="LOGIN_PW" id="LOGIN_PW" type="password" class="form-control" placeholder="登录密码" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">确认密码</label>
                    <div class="col-sm-9">
                        <input name="LOGIN_PW_COMIT" id="LOGIN_PW_COMIT" type="password" class="form-control" placeholder="确认密码" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSave">保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 学院选择列表选择 开始 -->
    <div class="modal fade" id="tableModal_XY">
        <div class="modal-dialog modal-dw60">
            <div class="modal-content form-horizontal">
                <div class="modal-body">
                    <table id="tablelist_xy" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 学院选择列表选择 结束-->
    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackageMany.filed = [
    				    { "data": "USER_ID",
    				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
    				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
    				        },
    				        "head": "checkbox", "id": "checkAll"
    				    },
                        { "data": "USER_ID", "head": "用户编码", "type": "td-keep" },
    				    { "data": "USER_NAME", "head": "用户名", "type": "td-keep" },
    				    { "data": "USER_TYPE_NAME", "head": "用户类型", "type": "td-keep" },
    				    { "data": "XY_CODE_NAME", "head": "所属学院", "type": "td-keep" },
    				    { "data": "USER_ROLE_NAME", "head": "所属角色", "type": "td-keep" },
    				    { "data": "IS_ASSISTANT_NAME", "head": "是否辅导员", "type": "td-keep" },
    				    { "data": "CREATE_NAME", "head": "最后操作人", "type": "td-keep" },
    				    { "data": "CREATE_TIME", "head": "最后操作时间", "type": "td-keep" }
    		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "List.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "用户管理",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
        					    { "data": "USER_ID", "pre": "用户编码", "col": 1, "type": "input" },
        					    { "data": "USER_NAME", "pre": "用户名", "col": 2, "type": "input" },
                      { "data": "USER_TYPE", "pre": "用户类型", "col": 3, "type": "select", "ddl_name": "ddl_user_type" },
                      { "data": "STU_TYPE", "pre": "学生类型", "col": 3, "type": "select", "ddl_name": "ddl_ua_stu_type" },
                      { "data": "XY_CODE", "pre": "所属学院", "col": 4, "type": "select", "ddl_name": "ddl_all_department" },
        				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //学院列表加载
            loadXyTableList();
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 专业列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadXyTableList() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "DW",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "DW", "head": "代码", "type": "td-keep" },
				{ "data": "MC", "head": "名称", "type": "td-keep" },
				{ "data": "LX_NAME", "head": "类型", "type": "td-keep" },
				{ "data": "ZT_NAME", "head": "状态", "type": "td-keep" }
		    ];

            //配置表格
            xyList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/SysBasic/department/List.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_xy", //表格id
                    buttonId: "buttonId_xy", //拓展按钮区域id
                    tableTitle: "选择学院",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': false, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                //查询栏
                hasSearch: {
                    "boxId": "xyBox",
                    "tabId": "tabXy",
                    "cols": [
						{ "data": "DW", "pre": "学院代码", "col": 1, "type": "input" },
						{ "data": "MC", "pre": "学院名称", "col": 2, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: [
                { type: "userDefined", id: "reload_xy", title: "刷新", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "sel_xy", title: "选择", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 专业列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _tableModal_XY = $("#tableModal_XY");
            var _btns = {
                reload: '.btn-reload',
                add: '.btn-add',
                edit: '.btn-edit',
                del: '.btn-del'
            };

            //刷新
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });

            //新增
            _content.on('click', _btns.add, function () {
                //设置界面值（清空界面值）
                _form_edit.reset();
                //隐藏域清空
                $("#hidUserRoles").val("");
                $("#hidAllXy").val("");
                $("#hidSelDelXy").val("");

                GetCheckBoxSelectedLoad(""); //角色选中加载
                $("#div_xy").html("");
                //弹出窗口
                _tableModal.modal();
            });

            //编辑
            _content.on('click', _btns.edit, function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.USER_ID) {
                        //设置界面值
                        _form_edit.setFormData(data);
                        //隐藏域清空
                        $("#hidUserRoles").val("");
                        $("#hidAllXy").val("");
                        $("#hidSelDelXy").val("");
                        //个性化赋值
                        ControlUtils.Input_SetReadOnlyStatus("USER_ID", true); //修改时，用户编码不能修改
                        $("#LOGIN_PW_COMIT").val(data.LOGIN_PW); //确认密码默认为登录密码
                        GetCheckBoxSelectedLoad(data.USER_ROLE); //角色选中加载
                        //加载已选择学院
                        $("#div_xy").html("");
                        var result = AjaxUtils.getResponseText("XyList.aspx?optype=getxy_edit&user_id=" + data.USER_ID);
                        if (result.length > 0) {
                            $("#div_xy").html(result);
                        }
                        //弹出窗口
                        _tableModal.modal();
                    }
                }
            });

            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });

            //-----------------编辑页-----------------
            //编辑页：【保存】
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });
            //----------编辑页：学院 多选----------------------
            //【新增学院】
            _tableModal.on('click', "#btnAdd_XY", function () {
                _tableModal_XY.modal();
            });
            //【删除所选学院】
            _tableModal.on('click', "#btnDel_XY", function () {
                DeleteSelectXy();
            });
            //------------学院选择页按钮---------------
            //【刷新】
            _tableModal_XY.on('click', "#reload_xy", function () {
                xyList.reload();
            });
            //【选择】
            _tableModal_XY.on('click', "#sel_xy", function () {
                AddSelectXy();
            });
        }
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("USER_TYPE");
            DropDownUtils.initDropDown("STU_TYPE");
            DropDownUtils.initDropDown("IS_ASSISTANT");
            //用户角色加载
            GetUserRoleHtml();
            //设置申请人选中改变事件
            $("input[type='checkbox'][name='user_role']").on('ifChanged', function (event) {
                GetCheckBoxSelected();
            });
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        }
    </script>
    <!-- 编辑页验证事件-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            LimitUtils.onlyNumAlpha("USER_ID"); //代码限制只能录入数字或者字母
            LimitUtils.onlyNumAlpha("LOGIN_PW"); //代码限制只能录入数字或者字母
            LimitUtils.onlyNumAlpha("LOGIN_PW_COMIT"); //代码限制只能录入数字或者字母
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "USER_ID", true, "用户编码必须填");
            ValidateUtils.setRequired("#form_edit", "USER_NAME", true, "用户名必须填");
            ValidateUtils.setRequired("#form_edit", "USER_TYPE", true, "用户类型必须填");
            ValidateUtils.setRequired("#form_edit", "IS_ASSISTANT", true, "请选择是否为辅导员");
            ValidateUtils.setRequired("#form_edit", "LOGIN_PW", true, "密码必须填");
            ValidateUtils.setRequired("#form_edit", "LOGIN_PW_COMIT", true, "确认密码必须填");
        }
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //获得初始角色HTML
        function GetUserRoleHtml() {
            $("#divUserRole").html('');
            var result = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getuserrole');
            if (result.length > 0)
                $("#divUserRole").html(result);
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
                    checkbox += $(this).attr("id") + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidUserRoles").val(checkbox);
            }
        }

        function onBeforeSave() {
            if ($("#USER_TYPE").val() == "S") {
                //设置学生类型为必填
                ValidateUtils.setRequired("#form_edit", "STU_TYPE", true, "用户类型为学生时此项必填");
            }
            else {
                ValidateUtils.setRequired("#form_edit", "STU_TYPE", false);
            }
            GetCheckBoxSelected(); //获得选中的用户角色
            if ($("#hidUserRoles").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择用户所属角色！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            GetAllSelectXy(); //获得选中的学院
            if ($("#hidAllXy").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择用户所属学院！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }

            var password = $("#LOGIN_PW").val();
            var password_comit = $("#LOGIN_PW_COMIT").val();
            if (password != password_comit) {
                easyAlert.timeShow({
                    "content": "密码与确认密码不一致，请确认！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            return true;
        }

        //保存事件
        function SaveData() {
            if (!onBeforeSave())
                return;
            //校验必填项
            if (!$('#form_edit').valid())
                return;

            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length == 0) {
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload();
                }
            });
        }

        //删除事件
        function DeleteData() {
            var data = mainList.selectSingle();
            if (data) {
                if (data.OID) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除选中的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            var result = AjaxUtils.getResponseText("List.aspx?optype=delete&id=" + data.OID);
                            if (result.length != 0) {
                                $(".Confirm_Div").modal("hide");
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }
                            else {
                                $(".Confirm_Div").modal("hide");
                                //保存成功：关闭界面，刷新列表
                                easyAlert.timeShow({
                                    "content": "删除成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                mainList.reload();
                            }
                        }
                    });
                }
            }
        }

        //获得选中的专业
        function GetCheckBoxSelected_Xy() {
            var checkbox = "";
            $("#hidSelDelXy").val("");
            $("input[type='checkbox'][name='ua_xy']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).val() + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidSelDelXy").val(checkbox);
            }
        }

        //删除学院
        function DeleteSelectXy() {
            GetCheckBoxSelected_Xy();
            if ($("#hidSelDelXy").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择要删除的学院！",
                    "duration": 2,
                    "type": "info"
                });
                return;
            }
            GetAllSelectZy();
            $("#div_xy").html("");
            $.post(OptimizeUtils.FormatUrl("XyList.aspx?optype=getzy_del"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    $("#div_xy").append($(msg));
                    return;
                }
                else {
                    easyAlert.timeShow({
                        "content": "删除失败！",
                        "duration": 2,
                        "type": "info"
                    });
                }
            });
        }

        //添加学院
        function AddSelectXy() {
            GetAllSelectXy();
            var datas = xyList.selection();
            var selectXy = "";
            for (var i = 0; i < datas.length; i++) {
                if (datas[i]) {
                    if (datas[i].DW) {
                        selectXy += datas[i].DW + ",";
                    }
                }
            }
            $("#hidAllXy").val($("#hidAllXy").val() + selectXy);
            $("#div_xy").html("");
            $.post(OptimizeUtils.FormatUrl("XyList.aspx?optype=getxy_add"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    $("#div_xy").append($(msg));
                    //关闭界面
                    $("#tableModal_XY").modal("hide");
                    return;
                }
                else {
                    //关闭界面
                    $("#tableModal_XY").modal("hide");
                    easyAlert.timeShow({
                        "content": "添加失败！",
                        "duration": 2,
                        "type": "info"
                    });
                }
            });
        }

        //获得所选择的学院集合
        function GetAllSelectXy() {
            var checkbox = "";
            $("#hidAllXy").val("");
            $("input[type='checkbox'][name='ua_xy']").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).val() + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidAllXy").val(checkbox);
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
