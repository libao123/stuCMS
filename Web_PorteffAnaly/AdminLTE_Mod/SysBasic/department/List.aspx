﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.SysBasic.department.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _optype;
        var _form_edit;
        var mgrList; //管理员列表
        $(function () {
            adaptionHeight();
            //编辑页控制定义
            _form_edit = PageValueControl.init("form_edit");
            _optype = "";
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
			    <h1>单位基础信息</h1>
			    <ol class="breadcrumb">
				    <li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				    <li>系统维护</li>
				    <li class="active">单位基础信息</li>
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
                <h4 class="modal-title">单位基础信息</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidAllMGR" name="hidAllMGR" />
                <input type="hidden" id="hidSelDelMGR" name="hidSelDelMGR" />
                <div class="form-group">
                    <label class="col-sm-2 control-label">单位代码<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input name="DW" id="DW" type="text" class="form-control" placeholder="单位代码" maxlength="10" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">单位名称<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input name="MC" id="MC" type="text" class="form-control" placeholder="单位名称" maxlength="50" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">单位类型<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <select class="form-control" name="LX" id="LX" d_value='' ddl_name='ddl_department_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">可用状态<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <select class="form-control" name="ZT" id="ZT" d_value='' ddl_name='ddl_use_flag' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">排序</label>
                    <div class="col-sm-10">
                        <input name="SEQUENCE" id="SEQUENCE" type="text" class="form-control" placeholder="排序" />
                    </div>
                </div>
                <div class="form-group ">
                    <label class="col-sm-2 control-label">英文名称</label>
                    <div class="col-sm-10">
                        <input name="YWMC" id="YWMC" type="text" class="form-control" placeholder="英文名称" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">备注</label>
                    <div class="col-sm-10">
                        <input name="BZ" id="BZ" type="text" class="form-control" placeholder="备注" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">管理员（可多选）</label>
                    <div class="col-sm-10">
                        <div class="box-body with-border" id="DivMGR">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label"></label>
                    <div class="col-sm-10">
                        <button type="button" class="btn btn-primary pull-right" id="btnDel_MGR">删除所选管理员</button>
                        <button type="button" class="btn btn-primary " id="btnAdd_MGR">新增管理员</button>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">联系地址</label>
                    <div class="col-sm-10">
                        <input name="ADDRESS" id="ADDRESS" type="text" class="form-control" placeholder="联系地址" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-12">
                        <p style="color: Red;">
                            注意：</p>
                    </div>
                    <div class="col-sm-12">
                        <p style="color: Red;">
                            单位信息为系统基础信息数据，请勿随意删改。</p>
                    </div>
                    <div class="col-sm-12">
                        <p style="color: Red;">
                            新增、修改、删除操作时，请与管理员联系！</p>
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
    <!-- 管理员选择列表选择 开始 -->
    <div class="modal fade" id="tableModal_MGR">
        <div class="modal-dialog modal-dw50">
            <div class="modal-content form-horizontal">
                <div class="modal-body">
                    <table id="tbl_MGR" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 管理员选择列表选择 结束-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
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
				{ "data": "ZT_NAME", "head": "状态", "type": "td-keep" },
                { "data": "SEQUENCE", "head": "排序", "type": "td-keep" },
                { "data": "MANAGER_NAME", "head": "管理员", "type": "td-keep" },
                { "data": "ADDRESS", "head": "联系地址", "type": "td-keep" }
			];

            //配置表格
            tablePackage.createOne({
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
                    tableTitle: "单位基础信息",
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
						{ "data": "DW", "pre": "单位代码", "col": 1, "type": "input" },
						{ "data": "MC", "pre": "单位名称", "col": 2, "type": "input" },
                        { "data": "LX", "pre": "单位类型", "col": 3, "type": "select", "ddl_name": "ddl_department_type" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del",
                { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"}}], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //管理员列表加载
            loadManagerTableList();
        }

        //管理员列表
        function loadManagerTableList() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "USER_ID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "USER_ID", "head": "编码", "type": "td-keep" },
    			{ "data": "USER_NAME", "head": "姓名", "type": "td-keep" },
    			{ "data": "USER_TYPE_NAME", "head": "类型", "type": "td-keep" }
            ];

            //配置表格
            mgrList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/UserAuthority/UserManage/List.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tbl_MGR", //表格id
                    buttonId: "buttonId_MGR", //拓展按钮区域id
                    tableTitle: "选择管理员",
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
                    "boxId": "mgrBox",
                    "tabId": "tabmgr",
                    "cols": [
						{ "data": "USER_ID", "pre": "用户编码", "col": 1, "type": "input" },
        				{ "data": "USER_NAME", "pre": "用户名", "col": 2, "type": "input" }
                    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: [
                { type: "userDefined", id: "reload_MGR", title: "刷新", className: "btn-info", attr: { "data-action": "", "data-other": "nothing" } },
                { type: "userDefined", id: "sel_MGR", title: "选择", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing" } }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _tableModal_MGR = $("#tableModal_MGR");
            var _btns = {
                reload: '.btn-reload',
                add: '.btn-add',
                edit: '.btn-edit',
                del: '.btn-del'
            };

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });

            //新增
            _content.on('click', _btns.add, function () {
                _optype = "add";
                //设置界面值（清空界面值）
                _form_edit.reset();
                //隐藏域清空
                $("#hidAllMGR").val("");
                $("#hidSelDelMGR").val("");
                //取消不可编辑
                _form_edit.cancel_disableAll();
                $("#btnSave").show();
                _tableModal.modal();
            });

            //修改
            _content.on('click', _btns.edit, function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    if (data.DW) {
                        _optype = "edit";
                        _form_edit.setFormData(data);
                        //隐藏域清空
                        $("#hidAllMGR").val("");
                        $("#hidSelDelMGR").val("");
                        //取消不可编辑
                        _form_edit.cancel_disableAll();
                        //设置代码不可编辑
                        ControlUtils.Input_SetDisableStatus("DW", true);
                        $("#btnSave").show();
                        //加载已选择的管理员
                        $("#DivMGR").html("");
                        var result = AjaxUtils.getResponseText("List.aspx?optype=getmgr&dw=" + data.DW);
                        if (result.length > 0) {
                            $("#DivMGR").html(result);
                        }
                        _tableModal.modal();
                    }
                }
            });

            //查阅
            _content.on('click', "#btn-view", function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    if (data.DW) {
                        _optype = "view";
                        _form_edit.setFormData(data);
                        _form_edit.disableAll(); //设置不可编辑
                        $("#btnSave").hide();
                        _tableModal.modal();
                    }
                }
            });

            //删除
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
            //----------编辑页--------------
            //保存
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });

            //----------编辑页：管理员 多选----------------------
            //【新增管理员】
            _tableModal.on('click', "#btnAdd_MGR", function () {
                _tableModal_MGR.modal();
            });
            //【删除所选管理员】
            _tableModal.on('click', "#btnDel_MGR", function () {
                DeleteManager();
            });
            //------------管理员选择页按钮---------------
            //【刷新】
            _tableModal_MGR.on('click', "#reload_MGR", function () {
                mgrList.reload();
            });
            //【选择】
            _tableModal_MGR.on('click', "#sel_MGR", function () {
                AddManager();
            });
        }
    </script>
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //初始化下拉
            DropDownUtils.initDropDown("LX");
            DropDownUtils.initDropDown("ZT");
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //录入控制
            LimitUtils.onlyNumAlpha("DW");
            LimitUtils.onlyNumAlpha("YWMC");
            LimitUtils.onlyNum("SEQUENCE");

            //必填项设置
            ValidateUtils.setRequired("#form_edit", "DW", true, "单位代码必须填");
            ValidateUtils.setRequired("#form_edit", "MC", true, "单位名称必须填");
            ValidateUtils.setRequired("#form_edit", "LX", true, "单位类型必须填");
            ValidateUtils.setRequired("#form_edit", "ZT", true, "可用状态必须填");
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //保存事件
        function SaveData() {
            if (_optype == "add") {
                var result = AjaxUtils.getResponseText("List.aspx?optype=chk&dw=" + $("#DW").val());
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            }
            if (_optype == "edit") {
                //取消代码不可编辑
                ControlUtils.Input_SetDisableStatus("DW", false);
            }
            //校验必填项
            if (!$('#form_edit').valid()) {
                if (_optype == "edit") {
                    //代码不可编辑
                    ControlUtils.Input_SetDisableStatus("DW", true);
                }
                return;
            }
            GetAllSelectedMGR();
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
                    tablePackage.reload();
                }
            });
        }

        //删除事件
        function DeleteData() {
            var data = tablePackage.selectSingle();
            if (data) {
                if (data.DW) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除选中的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            var result = AjaxUtils.getResponseText("List.aspx?optype=delete&id=" + data.DW);
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
                                tablePackage.reload();
                            }
                        }
                    });
                }
            }
        }

        //获得编辑页面选中的管理员
        function GetCheckBoxSelectedMGR() {
            var checkbox = "";
            $("#hidSelDelMGR").val("");
            $("input[type='checkbox'][name='MANAGER']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).val() + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidSelDelMGR").val(checkbox);
            }
        }

        //删除管理员
        function DeleteManager() {
            GetAllSelectedMGR();
            GetCheckBoxSelectedMGR();
            if ($("#hidSelDelMGR").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择要删除的管理员！",
                    "duration": 2,
                    "type": "info"
                });
                return;
            }
            $("#DivMGR").html("");
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=delmgr"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    $("#DivMGR").append($(msg));
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

        //添加选择的管理员
        function AddManager() {
            GetAllSelectedMGR();
            var datas = mgrList.selection();
            var sel = "";
            for (var i = 0; i < datas.length; i++) {
                if (datas[i]) {
                    if (datas[i].USER_ID) {
                        sel += datas[i].USER_ID + ",";
                    }
                }
            }
            $("#hidAllMGR").val($("#hidAllMGR").val() + sel);
            $("#DivMGR").html("");
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=addmgr"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    $("#DivMGR").append($(msg));
                    //关闭界面
                    $("#tableModal_MGR").modal("hide");
                    return;
                }
                else {
                    //关闭界面
                    $("#tableModal_MGR").modal("hide");
                    easyAlert.timeShow({
                        "content": "添加失败！",
                        "duration": 2,
                        "type": "info"
                    });
                }
            });
        }

        //获得已选择的管理员集合
        function GetAllSelectedMGR() {
            var checkbox = "";
            $("#hidAllMGR").val("");
            $("input[type='checkbox'][name='MANAGER']").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).val() + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidAllMGR").val(checkbox);
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
