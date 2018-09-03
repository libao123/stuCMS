<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="SendList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Msg.SendList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        #div_accpter ul
        {
            list-style: none;
        }
        #div_accpter li
        {
            margin: 0;
            padding: 0;
            float: left;
        }
        #div_accpter label{
        	margin-right: 10px;
        }
    </style>
    <script type="text/javascript">
        var mainList; //主列表
        var userList; //用户列表
        var _form_edit;
        $(function () {
            adaptionHeight();
            //编辑页控制定义
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
        <div class="modal-dialog" style="width: 60%">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal"
            onsubmit="return false;">
            <input type="hidden" id="OID" name="OID" value="" />
            <input type="hidden" id="hidAllUser" name="hidAllUser" />
            <input type="hidden" id="hidSelDelUser" name="hidSelDelUser" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <h4 class="modal-title">信息管理</h4>
            </div>
            <div class="modal-body">
            	<div id="" class="box box-default" style="border: none; margin-bottom: 0;">
	                <div class="box-header with-border">
	                    <h3 class="box-title">接收人</h3>
	                </div>
            		<div class="box-body with-border" id="div_accpter">
            			
            		</div>
            		<div class="box-header with-border">
	                    <h3 class="box-title">信息内容</h3>
	                </div>
	                <div class="box-body with-border">
            			<div class="form-group">
		                    <label class="col-sm-2 control-label">信息类型</label>
		                    <div class="col-sm-10">
		                        <select class="form-control" name="MSG_TYPE" id="MSG_TYPE" d_value='' ddl_name='ddl_msg_type' show_type='t' style="margin: 0;">
		                        </select>
		                    </div>
		                </div>
		                <div class="form-group">
		                    <div class="col-sm-12">
		                        <textarea name="MSG_CONTENT" id="MSG_CONTENT" cols="10" rows="5" class="form-control" style="margin: 0;"></textarea>
		                    </div>
		                </div>
            		</div>
            	</div>
                
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnDel">删除接收人</button>
                <button type="button" class="btn btn-primary btn-save" id="btnAdd">新增接收人</button>
                <button type="button" class="btn btn-primary btn-save" id="btnSave">发布</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 接收人选择列表选择 开始 -->
    <div class="modal" id="userListModal">
        <div class="modal-dialog" style="width: 50%">
            <div class="modal-content form-horizontal">
                <div class="modal-body">
                    <table id="tablelist_user" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 接收人选择列表选择 结束-->
    <!-- 主列表初始化JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
                { "data": "MSG_TYPE_NAME", "head": "信息类型", "type": "td-keep" },
				{ "data": "MSG_CONTENT", "head": "信息内容", "type": "td-keep" },
				{ "data": 'SEND_NAME', "head": '发送人', "type": "td-keep" },
				{ "data": 'SEND_TIME', "head": '发送时间', "type": "td-keep" }
			];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "SendList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "个人中心 >> 信息管理 >> 已发送信息",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true//用户改变分页
                        //'ordering':true//是否默认排序，默认为false
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
                        { "data": "MSG_TYPE", "pre": "信息类型", "col": 1, "type": "select", "ddl_name": "ddl_msg_type" },
						{ "data": "MSG_CONTENT", "pre": "信息内容", "col": 1, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });

            loadTableList_User();
        }
    </script>
    <!-- 主列表初始化JS 结束-->
    <!-- 接收人选择列表选择初始化JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList_User() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
                { "data": "USER_ID", "head": "用户编码", "type": "td-keep" },
				{ "data": "USER_NAME", "head": "用户名", "type": "td-keep" },
				{ "data": 'USER_TYPE_NAME', "head": '用户类型', "type": "td-keep" },
				{ "data": 'XY_CODE_NAME', "head": '所属学院', "type": "td-keep" }
			];

            //配置表格
            userList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/Common/ComPage/SelectUser.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_user", //表格id
                    buttonId: "buttonId_user", //拓展按钮区域id
                    tableTitle: "选择信息接收人",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': false, //是否单选，默认为true
                        'lengthChange': true//用户改变分页
                        //'ordering':true//是否默认排序，默认为false
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
                        { "data": "USER_ID", "pre": "用户编码", "col": 1, "type": "input" },
						{ "data": "USER_NAME", "pre": "用户名", "col": 2, "type": "input" },
                        { "data": "USER_TYPE", "pre": "用户类型", "col": 3, "type": "select", "ddl_name": "ddl_user_type" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: [{ type: "userDefined", id: "reload", title: "刷新", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                 { type: "userDefined", id: "select", title: "选择", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 接收人选择列表选择初始化JS 结束-->
    <!-- 按钮事件JS 开始-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _userListModal = $("#userListModal");
            var _btns = {
                reload: '.btn-reload',
                add: '.btn-add',
                edit: '.btn-edit',
                del: '.btn-del'
            };
            //------------列表按钮---------------
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
            //【新增】
            _content.on('click', _btns.add, function () {
                $("#OID").val("");
                $("#div_accpter").html("");
                $("#MSG_CONTENT").val("");
                DropDownUtils.setDropDownValue("MSG_TYPE", "");
                _tableModal.modal();
            });
            //【修改】
            _content.on('click', _btns.edit, function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        _form_edit.setFormData(data);
                        //加载已选择接收人
                        $("#div_accpter").html("");
                        var result = AjaxUtils.getResponseText("SendList.aspx?optype=getaccpter_edit&id=" + data.OID);
                        console.log(result);
                        if (result.length > 0)
                            $("#div_accpter").html(result);
                        _tableModal.modal();
                    }
                }
            });
            //------------编辑页按钮---------------
            //【删除接收人】
            _tableModal.on('click', "#btnDel", function () {
                DeleteSelectUser();
            });
            //【新增接收人】
            _tableModal.on('click', "#btnAdd", function () {
                _userListModal.modal();
            });
            //【发布信息】
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });
            //------------接收人选择页按钮---------------
            //【刷新】
            _userListModal.on('click', "#reload", function () {
                userList.reload();
            });
            //【选择】
            _userListModal.on('click', "#select", function () {
                AddSelectUser();
            });
        }
    </script>
    <!-- 按钮事件JS 结束-->
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("MSG_TYPE");
            //设置申请人选中改变事件
            $("input[type='checkbox'][name='accpter_user']").on('ifChanged', function (event) {
                GetCheckBoxSelected();
            });
        }
    </script>
    <!-- 编辑页验证事件-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "MSG_TYPE", true, "信息类型必填");
            ValidateUtils.setRequired("#form_edit", "MSG_CONTENT", true, "信息内容必填");
        }
    </script>
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //获得选中的接收人
        function GetCheckBoxSelected() {
            var checkbox = "";
            $("#hidSelDelUser").val("");
            $("input[type='checkbox'][name='accpter_user']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).val() + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidSelDelUser").val(checkbox);
            }
        }

        //获得所选择的用户集合
        function GetAllSelectUser() {
            var checkbox = "";
            $("#hidAllUser").val("");
            $("input[type='checkbox'][name='accpter_user']").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).val() + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidAllUser").val(checkbox);
            }
        }

        //添加接收人
        function AddSelectUser() {
            GetAllSelectUser();
            var datas = userList.selection();
            var selectUser = "";
            for (var i = 0; i < datas.length; i++) {
                if (datas[i]) {
                    if (datas[i].USER_ID) {
                        selectUser += datas[i].USER_ID + ",";
                    }
                }
            }
            $("#hidAllUser").val($("#hidAllUser").val() + selectUser);
            $("#div_accpter").html("");
            $.post(OptimizeUtils.FormatUrl("SendList.aspx?optype=getaccpter_add"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    //$("#div_accpter").html(msg);
                    $("#div_accpter").append($(msg));
                    //关闭界面
                    $("#userListModal").modal("hide");
                    return;
                }
                else {
                    easyAlert.timeShow({
                        "content": "添加失败！",
                        "duration": 2,
                        "type": "info"
                    });
                }
            });
        }

        //删除接收人
        function DeleteSelectUser() {
            if ($("#hidSelDelUser").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择要删除的接收人！",
                    "duration": 2,
                    "type": "info"
                });
                return;
            }
            GetAllSelectUser();
            $("#div_accpter").html("");
            $.post(OptimizeUtils.FormatUrl("SendList.aspx?optype=getaccpter_del"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    $("#div_accpter").html(msg);
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

        //保存事件
        function SaveData() {
            //校验必填项
            if (!$('#form_edit').valid())
                return;
            GetAllSelectUser();
            if ($("#hidAllUser").val().length == 0) {
                easyAlert.timeShow({
                    "content": "接收人必选！",
                    "duration": 2,
                    "type": "info"
                });
                return;
            }
            //保存
            $.post(OptimizeUtils.FormatUrl("SendList.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "提交成功！",
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
                            var result = AjaxUtils.getResponseText("SendList.aspx?optype=delete&id=" + data.OID);
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
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>