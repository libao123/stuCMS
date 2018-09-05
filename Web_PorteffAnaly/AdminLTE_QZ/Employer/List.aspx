<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="List.aspx.cs" 
    Inherits="PorteffAnaly.Web.AdminLTE_QZ.Employer.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _form_edit;
        var mainList;
        window.onload = function () {
            adaptionHeight();

            _form_edit = PageValueControl.init("form_edit");

            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();

            //时间控件
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });

            $("#btnSave").click(function () {
                SaveData();
            });
            $("#btnSubmit").click(function () {
                easyConfirm.locationShow({
                    "type": "warn",
                    "title": "提交",
                    "content": "确定要提交数据？",
                    "callback": SubmitData
                });
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>用人单位管理</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>用人单位管理</li>
				<li class="active">用人单位管理</li>
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
    <!-- 编辑界面 开始-->
    <div class="modal" id="tableModal">
        <div class="modal-dialog modal-dw70">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
                onsubmit="return false;">
                <input type="hidden" id="OID" name="OID" />
                <input type="hidden" id="SEQ_NO" name="SEQ_NO" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">岗位信息</h4>
                </div>
                <div class="tab-content row">
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            单位名称<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="EMPLOYER" id="EMPLOYER" class="form-control" placeholder="单位名称" />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            单位类别<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="EMPLOYER_TYPE" id="EMPLOYER_TYPE" class="form-control" ddl_name='ddl_employer_type'
                                d_value='' show_type='t' required>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            管理人姓名<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input name="MANAGER_NAME" id="MANAGER_NAME" type="text" class="form-control" placeholder="管理人姓名" />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            联系电话</label>
                        <div class="col-sm-8">
                            <input type="text" name="TELEPHONE" id="TELEPHONE" class="form-control" placeholder="联系电话" />
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label">
                            联系地址</label>
                        <div class="col-sm-10">
                            <input type="text" name="ADDRESS" id="ADDRESS" class="form-control" placeholder="联系地址" />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            是否使用<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select class="form-control" name="IS_USE" id="IS_USE" d_value='' show_type='t'
                                ddl_name='ddl_yes_no'>
                            </select>
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

    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				{
				    "data": "DOC_TYPE",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
                { "data": "EMPLOYER", "head": "单位名称", "type": "td-keep" },
				{ "data": "EMPLOYER_TYPE", "head": "单位类别", "type": "td-keep" },
				{ "data": "IS_USE_NAME", "head": "是否使用", "type": "td-keep" },
				{ "data": "MANAGER_NAME", "head": "管理人姓名", "type": "td-keep" },
				{ "data": "TELEPHONE", "head": "联系电话", "type": "td-keep" },
				{ "data": "ADDRESS", "head": "联系地址", "type": "td-keep" }
            ];

            //配置表格
            mainList = tablePackage.createOne({
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
                    tableTitle: "用人单位管理",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        'aLengthMenu': [10, 50, 100, 200, 300, 500]
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
					    { "data": "EMPLOYER", "pre": "单位名称", "col": 1, "type": "input" },
						{ "data": "EMPLOYER_TYPE", "pre": "单位类别", "col": 2, "type": "select", "ddl_name": "ddl_employer_type" },
						{ "data": "IS_USE", "pre": "是否使用", "col": 3, "type": "select", "ddl_name": "ddl_yes_no" }
                    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } },
					"add", "edit", "del",
                    { type: "userDefined", id: "btn-export", title: "导出", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } }
                ],
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 列表JS 结束-->

    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("EMPLOYER_TYPE");
            DropDownUtils.initDropDown("IS_USE");
        }

        function loadModalPageValidate() {
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "EMPLOYER", true, "单位名称必填");
            ValidateUtils.setRequired("#form_edit", "EMPLOYER_TYPE", true, "单位类别必填");
            ValidateUtils.setRequired("#form_edit", "MANAGER_NAME", true, "管理人姓名必填");
            ValidateUtils.setRequired("#form_edit", "TELEPHONE", true, "联系电话必填");
            ValidateUtils.setRequired("#form_edit", "ADDRESS", true, "联系地址必填");
            ValidateUtils.setRequired("#form_edit", "IS_USE", true, "是否使用必填");

        }
    </script>

    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            var _content = $("#content");

            //刷新
            _content.on('click', '.btn-reload', function () {
                tablePackage.reload();
            });

            //查阅
            _content.on('click', '#btn-view', function () {
                _content.find(".btn-edit").click();
                hideBtn();
            });

            //新增
            _content.on('click', '.btn-add', function () {
                showBtn();
                $("#tableModal").modal();
                $("#tableModal :input").val("");
                $("#tableModal .form-control-static").text("");
            });

            //修改
            _content.on('click', '.btn-edit', function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    $("#tableModal").modal();
                    var apply_data = AjaxUtils.getResponseText('List.aspx?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                    }
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });

            //删除
            _content.on('click', '.btn-del', function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    var result = AjaxUtils.getResponseText('List.aspx?optype=chkdel&id=' + data.OID);
                    if (result.length > 0) {
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除所选的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            $.post(OptimizeUtils.FormatUrl("?optype=delete&id=" + data.OID), function (msg) {
                                if (!msg) {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": "删除成功！",
                                        "duration": 2,
                                        "type": "success"
                                    });
                                    mainList.reload();
                                }
                                else {
                                    easyAlert.timeShow({
                                        "content": msg,
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                }
                            });
                        }
                    });
                } else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });

            var hideBtn = function () {
                $("#btnSave").hide();
            }
            var showBtn = function () {
                $("#btnSave").show();
            }

        }

        function CheckData() {
            var id = $("#OID").val();
            var employer = escape($("#EMPLOYER").val());
            var type = escape($("#EMPLOYER_TYPE").val());
            var result = AjaxUtils.getResponseText("?optype=chksave&id=" + id + "&employer=" + employer + "&type=" + type);
            if (result.length > 0) {
                easyAlert.timeShow({
                    "content": result,
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            return true;
        }

        function SaveData() {
            if (!($("#form_edit").valid())) {
                return;
            }

            if (!CheckData()) return;
            
            $.post(OptimizeUtils.FormatUrl("?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length == 0) {
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                else {
                    $("#OID").val(msg);
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
    </script>
</asp:Content>
