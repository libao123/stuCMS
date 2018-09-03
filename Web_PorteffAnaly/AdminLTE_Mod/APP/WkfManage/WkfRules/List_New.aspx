<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List_New.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.APP.WkfManage.WkfRules.List_New" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();

            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();

            $("#btnSave").click(function () {
                SaveData();
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>审核流程设置</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">审核流程设置</li>
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
        <div class="modal-dialog" style="width: 40%;">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">审批流程设置</h4>
            </div>
            <input type="hidden" id="DOC_TYPE" name="DOC_TYPE" value="" />
            <input type="hidden" id="hidDeclare_role" name="hidDeclare_role" value="" />
            <input type="hidden" id="hidAudit_type" name="hidAudit_type" value="" />
            <input type="hidden" id="hidRevoke_type" name="hidRevoke_type" value="" />
            <div class="modal-body">
                <div class="nav-tabs-custom" style="box-shadow: none; margin-bottom: 0px;">
                    <ul class="nav nav-tabs" id="myTab">
                        <li class="active"><a href="#tab_1" data-toggle="tab" id="tabli1">业务审批流程设置</a></li>
                        <li><a href="#tab_2" data-toggle="tab">撤销审批流程设置</a></li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab_1">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">
                                    业务单据</label>
                                <div class="col-sm-8">
                                    <select class="form-control" name="DOC_TYPE_2" id="DOC_TYPE_2" d_value=''
                                        ddl_name='ddl_doc_type_needflow' show_type='t'>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">
                                    申请角色</label>
                                <div class="col-sm-8">
                                    <select class="form-control" name="DECLARE_ROLE" id="DECLARE_ROLE" d_value=''
                                        ddl_name='ddl_ua_role' show_type='t'>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">
                                    业务申请审批类型</label>
                                <div class="col-sm-8">
                                    <input type="radio" id="Ctype1" name="audit_type" class="flat-red"
                                        onclick="ClickApply(this)" /><label id='lab1' for="Ctype1">一级审批</label>
                                    <input type="radio" id="Ctype2" name="audit_type" class="flat-red"
                                        onclick="ClickApply(this)" /><label id="lab2" for="Ctype2">二级审批</label>
                                    <input type="radio" id="Ctype3" name="audit_type" class="flat-red"
                                        onclick="ClickApply(this)" /><label id="lab3" for="Ctype3">三级审批</label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">
                                    一级审批角色</label>
                                <div class="col-sm-8">
                                    <select class="form-control" name="NEXT_POST_CODE1" id="NEXT_POST_CODE1" d_value=''
                                        ddl_name='ddl_ua_role' show_type='t'>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">
                                    二级审批角色</label>
                                <div class="col-sm-8">
                                    <select class="form-control" name="NEXT_POST_CODE2" id="NEXT_POST_CODE2" d_value=''
                                        ddl_name='ddl_ua_role' show_type='t'>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">
                                    三级审批角色</label>
                                <div class="col-sm-8">
                                    <select class="form-control" name="NEXT_POST_CODE3" id="NEXT_POST_CODE3" d_value=''
                                        ddl_name='ddl_ua_role' show_type='t'>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-12 control-label" style="text-align: left; color: Red;">
                                    审批流程设置说明：</label>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-12 control-label" style="text-align: left;">
                                    1、一级审批：一级审批角色；</label>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-12 control-label" style="text-align: left;">
                                    2、二级审批：一级审批角色--->二级审批角色；</label>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-12 control-label" style="text-align: left;">
                                    3、三级审批：一级审批角色--->二级审批角色--->三级审批角色；</label>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-12 control-label" style="text-align: left;">
                                    4、不提供修改按钮，新增即覆盖已经设置的审批流程。</label>
                            </div>
                        </div>
                        <div class="tab-pane" id="tab_2">

                        </div>
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
    <!-- 删除界面 结束-->
    <div class="modal modal-warning" id="delModal">
        <div class="modal-dialog">
            <form id="form_del" name="form_del" class="modal-content  form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">删除</h4>
            </div>
            <div class="modal-body">
                <p>确定要删除该信息？</p>
                <input type="hidden" name="DOC_TYPE" value="" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-outline btn-delete">确定</button>
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
				    { "data": "DOC_TYPE",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "DOC_TYPE_NAME", "head": "申报类型", "type": "td-keep" },
				    { "data": "APPROVE_TYPE", "head": "业务审批类型", "type": "td-keep" },
				    { "data": "POST_NOTE", "head": "业务审批流程", "type": "td-keep" },
				    { "data": "REVOKE_APPROVE_TYPE", "head": "撤销审批类型", "type": "td-keep" },
				    { "data": "REVOKE_POST_NOTE", "head": "撤销审批流程", "type": "td-keep" },
				    { "data": "CREATE_USER", "head": "操作人", "type": "td-keep" },
				    { "data": "CREATE_TIME", "head": "操作时间", "type": "td-keep" }
		    ];

            //配置表格
            tablePackage.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "List_New.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "审批流程设置",
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
					    { "data": "DOC_TYPE", "pre": "业务单据", "col": 1, "type": "select", "ddl_name": "ddl_doc_type" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "del"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("DOC_TYPE_2");
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        }

        //编辑页验证事件
        function loadModalPageValidate() {
            ValidateUtils.setRequired("#form_edit", "DOC_TYPE_2", true, "业务类型必填");
            ValidateUtils.setRequired("#form_edit", "NEXT_POST_CODE1", true, "一级审批角色必填");
            if ($("#hidAudit_type").val().indexOf('2') > 0) {
                if ($("#NEXT_POST_CODE2").val().length == 0)
                    ValidateUtils.setRequired("#form_edit", "NEXT_POST_CODE2", true, "二级审批角色必填");
            }
            if ($("#hidAudit_type").val().indexOf('3') > 0) {
                if ($("#NEXT_POST_CODE2").val().length == 0)
                    ValidateUtils.setRequired("#form_edit", "NEXT_POST_CODE2", true, "二级审批角色必填");
                if ($("#NEXT_POST_CODE3").val().length == 0)
                    ValidateUtils.setRequired("#form_edit", "NEXT_POST_CODE3", true, "三级审批角色必填");
            }
        }

        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");

            //刷新
            _content.on('click', '.btn-reload', function () {
                tablePackage.reload();
            });

            //新增
            _content.on('click', '.btn-add', function () {
                DropDownUtils.setDropDownValue("DOC_TYPE_2", "");
                $("input[type='radio']").removeAttr('checked');//清除单选框的checked属性
                $("#hidDeclare_role").val("");
                $("#hidAudit_type").val("");
                $("#hidRevoke_type").val("");
            });

            //删除
            _content.on('click', '.btn-del', function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    //var result = AjaxUtils.getResponseText('List.aspx?optype=chkdel&id=' + data.OID);
                    //if (result.length > 0) {
                    //    easyAlert.timeShow({
                    //        "content": result,
                    //        "duration": 2,
                    //        "type": "danger"
                    //    });
                    //    return;
                    //}
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除所选的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            DeleteData();
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
        }

        function onBeforeSave() {
            if ($("#DECLARE_ROLE").combobox("getValue").length == 0) {
                easyAlert.timeShow({
                    "content": "请选择申请角色！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            if ($("#hidAudit_type").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择申请审批类型！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            //if ($("#hidRevoke_type").val().length == 0) {
            //    easyAlert.timeShow({
            //        "content": "请选择撤销审批类型！",
            //        "duration": 2,
            //        "type": "danger"
            //    });
            //    return false;
            //}

            return true;
        }

        //保存事件
        function SaveData() {
            if (!onBeforeSave()) return;

            //已存在该单据的业务流转规则，是否重新添加?
            var strDType = DropDownUtils.getDropDownValue("DOC_TYPE_2");
            var result = AjaxUtils.getResponseText("List_New.aspx?optype=check&dctype=" + strDType);
            if (result.length > 0) {
                easyConfirm.locationShow({
                    'type': 'warn',
                    'content': result,
                    'title': '是否重新添加业务流转规则',
                    'callback': function (btn) {
                        $.post(OptimizeUtils.FormatUrl("List_New.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                            if (msg.length > 0) {
                                $(".Confirm_Div").modal("hide");
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
                                $(".Confirm_Div").modal("hide");

                                easyAlert.timeShow({
                                    "content": "保存成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                tablePackage.reload();
                            }
                        });
                    }
                });
            }
            else {
                $.post(OptimizeUtils.FormatUrl("List_New.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                    if (msg.length > 0) {
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
        }

        //删除事件
        function DeleteData() {
            $.post(OptimizeUtils.FormatUrl("List_New.aspx?optype=delete"), $("#form_del").serialize(), function (msg) {
                if (msg.length != 0) {
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    $("#delModal").modal("hide");
                    return;
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    easyAlert.timeShow({
                        "content": "删除成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    $("#delModal").modal("hide");
                    tablePackage.reload();
                }
            });
        }
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        function ClickApply(obj) {
            if (obj == null)
                return;

            var audit_type = obj.id;
            $("#hidAudit_type").val(audit_type);
            if (audit_type.indexOf('1') > 0) {
                $("#NEXT_POST_CODE1").combobox({ required: true });
                $("#NEXT_POST_CODE2").combobox({ required: false });
                $("#NEXT_POST_CODE3").combobox({ required: false });
            }
            else if (audit_type.indexOf('2') > 0) {
                $("#NEXT_POST_CODE1").combobox({ required: true });
                $("#NEXT_POST_CODE2").combobox({ required: true });
                $("#NEXT_POST_CODE3").combobox({ required: false });
            }
            else if (audit_type.indexOf('3') > 0) {
                $("#NEXT_POST_CODE1").combobox({ required: true });
                $("#NEXT_POST_CODE2").combobox({ required: true });
                $("#NEXT_POST_CODE3").combobox({ required: true });
            }
            else {
                $("#NEXT_POST_CODE1").combobox({ required: false });
                $("#NEXT_POST_CODE2").combobox({ required: false });
                $("#NEXT_POST_CODE3").combobox({ required: false });
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>