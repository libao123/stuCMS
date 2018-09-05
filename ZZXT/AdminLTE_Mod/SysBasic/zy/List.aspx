<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.SysBasic.zy.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _optype;
        var _form_edit;
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
			<h1>专业信息</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">专业信息</li>
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
                <h4 class="modal-title">专业基础信息</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-4 control-label">专业代码<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <input name="ZY" id="ZY" type="text" class="form-control" placeholder="专业代码" maxlength="20" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">专业名称<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <input name="MC" id="MC" type="text" class="form-control" placeholder="专业名称" maxlength="50" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">所属学院<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="XY" id="XY" d_value='' ddl_name='ddl_department'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">可用状态<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="ZT" id="ZT" d_value='' ddl_name='ddl_use_flag' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">英文名称</label>
                    <div class="col-sm-8">
                        <input name="YWMC" id="YWMC" type="text" class="form-control" placeholder="英文名称" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-12">
                        <p style="color: Red;">注意：</p>
                    </div>
                    <div class="col-sm-12">
                        <p style="color: Red;">专业信息为系统基础信息数据，请勿随意删改。</p>
                    </div>
                    <div class="col-sm-12">
                        <p style="color: Red;">新增、修改、删除操作时，请与管理员联系！</p>
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
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				{
				    "data": "ZY",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "ZY", "head": "代码", "type": "td-keep" },
				{ "data": "MC", "head": "名称", "type": "td-keep" },
				{ "data": "XY_NAME", "head": "所属学院", "type": "td-keep" },
				{ "data": "ZT_NAME", "head": "状态", "type": "td-keep" }
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
                    tableTitle: "专业基础信息",
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
						{ "data": "XY", "pre": "所属学院", "col": 2, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "ZY", "pre": "代码", "col": 1, "type": "input" },
						{ "data": "MC", "pre": "名称", "col": 2, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del",
                { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"}}], //需要的按钮
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
                //取消不可编辑
                _form_edit.cancel_disableAll();
                $("#btnSave").show();
                _tableModal.modal();
            });

            //修改
            _content.on('click', _btns.edit, function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    if (data.ZY) {
                        _optype = "edit";
                        _form_edit.setFormData(data);
                        //取消不可编辑
                        _form_edit.cancel_disableAll();
                        //设置代码不可编辑
                        ControlUtils.Input_SetDisableStatus("ZY", true);
                        $("#btnSave").show();
                        _tableModal.modal();
                    }
                }
            });

            //查阅
            _content.on('click', "#btn-view", function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    if (data.ZY) {
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
        }
    </script>
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //初始化下拉
            DropDownUtils.initDropDown("XY");
            DropDownUtils.initDropDown("ZT");
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //录入控制
            LimitUtils.onlyNumAlpha("ZY");
            LimitUtils.onlyNumAlpha("YWMC");
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "ZY", true, "专业代码必须填");
            ValidateUtils.setRequired("#form_edit", "MC", true, "专业名称必须填");
            ValidateUtils.setRequired("#form_edit", "XY", true, "所属学院必须填");
            ValidateUtils.setRequired("#form_edit", "ZT", true, "可用状态必须填");
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //保存事件
        function SaveData() {
            if (_optype == "add") {
                var result = AjaxUtils.getResponseText("List.aspx?optype=chk&zy=" + $("#ZY").val());
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
                ControlUtils.Input_SetDisableStatus("ZY", false);
            }
            //校验必填项
            if (!$('#form_edit').valid()) {
                if (_optype == "edit") {
                    //代码不可编辑
                    ControlUtils.Input_SetDisableStatus("ZY", true);
                }
                return;
            }
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
                if (data.ZY) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除选中的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            var result = AjaxUtils.getResponseText("List.aspx?optype=delete&id=" + data.ZY);
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
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
