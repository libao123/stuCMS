<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.APP.WkfManage.WkfRules.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();

            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
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
        <div class="modal-dialog modal-dw50">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">审批流程设置</h4>
            </div>
            <input type="hidden" id="hiddeclare_man" name="hiddeclare_man" value="" />
            <input type="hidden" id="hidaudit_type" name="hidaudit_type" value="" />
            <input type="hidden" id="hidrevoke_type" name="hidrevoke_type" value="" />
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        业务单据</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="DOC_TYPE_2" id="DOC_TYPE_2" d_value='' ddl_name='ddl_doc_type_needflow'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        申请人</label>
                    <div class="col-sm-8">
                        <%--<label for="Declare_S">学生</label>--%>
                        <input type="radio" id="Declare_S" name="declare_man" class="flat-red" /><label for="Declare_S">学生</label>
                        <input type="radio" id="Declare_F" name="declare_man" class="flat-red" /><label for="Declare_F">辅导员</label>
                        <input type="radio" id="Declare_Y" name="declare_man" class="flat-red" /><label for="Declare_Y">学院</label>
                        <input type="radio" id="Declare_D" name="declare_man" class="flat-red" /><label for="Declare_D">用工单位</label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        业务申请审批类型</label>
                    <div class="col-sm-8">
                        <input type="radio" id="Ctype1" name="audit_type" class="flat-red" /><label id='labF'
                            for="Ctype1">辅导员审批</label>
                        <input type="radio" id="Ctype2" name="audit_type" class="flat-red" /><label id="labY"
                            for="Ctype2">院级审批</label>
                        <input type="radio" id="Ctype3" name="audit_type" class="flat-red" /><label id="labX"
                            for="Ctype3">校级审批</label>
                        <input type="radio" id="Ctype_Q" name="audit_type" class="flat-red" /><label id="labQ"
                            for="Ctype_Q">勤助中心审批</label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        撤销申请审批类型</label>
                    <div class="col-sm-8">
                        <input type="radio" id="Revoke1" name="revoke_type" class="flat-red" /><label id='labF_R'
                            for="Revoke1">辅导员审批</label>
                        <input type="radio" id="Revoke2" name="revoke_type" class="flat-red" /><label id="labY_R"
                            for="Revoke2">院级审批</label>
                        <input type="radio" id="Revoke3" name="revoke_type" class="flat-red" /><label id="labX_R"
                            for="Revoke3">校级审批</label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label" style="text-align: left; color: Red;">
                        审批流程设置说明：</label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label" style="text-align: left;">
                        1、辅导员审批：辅导员审批；</label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label" style="text-align: left;">
                        2、院级审批：辅导员审批--->学院审批；</label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label" style="text-align: left;">
                        3、校级审批：辅导员审批--->学院审批--->学校审批；</label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label" style="text-align: left;">
                        4、不提供修改按钮，新增即覆盖已经设置的审批流程。</label>
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
                    url: "List.aspx?optype=getlist",
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
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });

            /*弹出页控制*/
            $dataModal.controls({
                "content": "content",
                "modal": "tableModal", //弹出层id
                "hasTime": true, //时间控件控制
                "hasCheckBox": false, //checkbox控制
                //"addAction":  "Edit.aspx?optype=add",//弹出层url
                //"editAction": "Edit.aspx?optype=edit",//弹出层url
                "submitType": "form", //form或者ajax
                "submitBtn": ".btn-save",
                "submitCallback": function (btn) {
                    console.log(btn);

                }, //自定义方法
                "valiConfig": {
                    model: '#tableModal form',
                    validate: [
						{ 'name': 'DOC_TYPE_2', 'tips': '业务类型必须填' }
					],
                    callback: function (form) {
                        console.log(form);
                        SaveData();
                    }
                },
                "beforeSubmit": function () {
                    return onBeforeSave();
                },
                "beforeShow": function (data) {//编辑页加载前控制，true可编辑，false不可编辑
                    if (data) {
                        //默认可编辑
                        //新增时，把界面内容清空
                        if (data.DOC_TYPE.length == 0) {
                            DropDownUtils.setDropDownValue("DOC_TYPE_2", "");
                            //默认radio选中项
                            $("#Declare_S").iCheck("check"); //iCheck绑定
                            $("#Ctype1").iCheck("check"); //iCheck绑定
                            $("#hiddeclare_man").val("");
                            $("#hidaudit_type").val("");
                            $("#hidrevoke_type").val("");
                        }
                    }
                    else {

                    }
                    return true;
                },
                "afterShow": function (data) {//编辑页加载后控制，自定义
                    if (data) {
                        //新增时，把界面内容清空
                        if (data.DOC_TYPE.length == 0) {
                            DropDownUtils.setDropDownValue("DOC_TYPE_2", "");
                            //默认radio选中项
                            $("#Declare_S").iCheck("check"); //iCheck绑定
                            $("#Ctype1").iCheck("check"); //iCheck绑定
                            $("#hiddeclare_man").val("");
                            $("#hidaudit_type").val("");
                            $("#hidrevoke_type").val("");
                        }
                        else {
                        }
                    }
                }
            });

            /*删除控制*/
            $delModal.controls({
                "content": "content",
                "delModal": "delModal", //弹出层id
                "delSubmit": ".btn-delete",
                "submitCallBack": function (btn) {
                    DeleteData();
                }
            });
        }

        function onBeforeSave() {
            //赋值给隐藏域
            GetRadioSelected();
            if ($("#hiddeclare_man").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择申请人！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            if ($("#hidaudit_type").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择申请审批类型！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            if ($("#hidrevoke_type").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择撤销审批类型！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }

            return true;
        }

        //保存事件
        function SaveData() {
            //已存在该单据的业务流转规则，是否重新添加?
            var strDType = DropDownUtils.getDropDownValue("DOC_TYPE_2");
            var result = AjaxUtils.getResponseText("List.aspx?optype=check&dctype=" + strDType);
            if (result.length > 0) {
                easyConfirm.locationShow({
                    'type': 'warn',
                    'content': result,
                    'title': '是否重新添加业务流转规则',
                    'callback': function (btn) {
                        $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
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
                $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
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
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=delete"), $("#form_del").serialize(), function (msg) {
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
    <!-- 编辑页数据初始化事件-->
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
            //设置申请人选中改变事件
            $("input[type='radio'][name='declare_man']").on('ifChanged', function (event) {
                OnDeclare_ManChange();
            });
            //设置申请审批类型选中改变事件
            $("input[type='radio'][name='audit_type']").on('ifChanged', function (event) {
                OnAudit_TypeChange();
            });
            //默认radio选中项
            $("#Declare_S").iCheck("check"); //iCheck绑定
            $("#Ctype1").iCheck("check"); //iCheck绑定
            //$("#Revoke1").iCheck("check"); //iCheck绑定
        }
    </script>
    <!-- 编辑页验证事件-->
    <script type="text/javascript">
        function loadModalPageValidate() {
        }
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //选择申请人、审批类型
        function GetRadioSelected() {
            var declare_man = "";
            var audit_type = "";
            var revoke_type = "";
            $("#hiddeclare_man").val("");
            $("#hidaudit_type").val("");
            $("#hidrevoke_type").val("");
            $("input[type='radio'][name='declare_man']:checked").each(function () {
                if ($(this) != null) {
                    declare_man = $(this).attr("id");
                }
            });
            $("input[type='radio'][name='audit_type']:checked").each(function () {
                if ($(this) != null) {
                    audit_type = $(this).attr("id");
                }
            });
            $("input[type='radio'][name='revoke_type']:checked").each(function () {
                if ($(this) != null) {
                    revoke_type = $(this).attr("id");
                }
            });
            if (declare_man.length > 0) {
                $("#hiddeclare_man").val(declare_man);
            }
            if (audit_type.length > 0) {
                $("#hidaudit_type").val(audit_type);
            }
            if (revoke_type.length > 0) {
                $("#hidrevoke_type").val(revoke_type);
            }
        }

        //申请人改变 之后
        function OnDeclare_ManChange() {
            $("input[type='radio'][name='declare_man']:checked").each(function () {
                if ($(this) != null) {
                    var radio_id = $(this).attr("id");
                    $("#RevokeDiv").show();
                    $("#Ctype1").iCheck("enable"); //移除 disabled 状态
                    $("#Ctype2").iCheck("enable"); //移除 disabled 状态
                    $("#Ctype3").iCheck("enable"); //移除 disabled 状态
                    $("#Ctype_Q").iCheck("disable");
                    if (radio_id == 'Declare_F') {
                        $("#Ctype1").iCheck("disable"); //将输入框的状态设置为 disabled
                        $("#Ctype2").iCheck("enable"); //移除 disabled 状态
                        $("#Ctype2").iCheck("check"); //默认选中
                        //$("#Revoke1").iCheck("disable"); //将输入框的状态设置为 disabled
                        $("#Revoke2").iCheck("check"); //默认选中
                    }
                    else if (radio_id == 'Declare_Y') {
                        $("#Ctype1").iCheck("disable"); //将输入框的状态设置为 disabled
                        $("#Ctype2").iCheck("disable"); //将输入框的状态设置为 disabled
                        $("#Ctype3").iCheck("check"); //默认选中
                        //$("#Revoke1").iCheck("disable"); //将输入框的状态设置为 disabled
                        $("#Revoke2").iCheck("check"); //默认选中
                    }
                    else if (radio_id == 'Declare_S') {
                        $("#Ctype1").iCheck("enable"); //移除 disabled 状态
                        $("#Ctype2").iCheck("enable"); //移除 disabled 状态
                        $("#Ctype1").iCheck("check"); //默认选中
                        $("#Revoke1").iCheck("enable"); //移除 disabled 状态
                        $("#Revoke1").iCheck("check"); //默认选中
                    }
                    else if (radio_id == 'Declare_D') {
                        $("#Ctype1").iCheck("disable"); //将输入框的状态设置为 disabled
                        $("#Ctype2").iCheck("disable"); //将输入框的状态设置为 disabled
                        $("#Ctype3").iCheck("disable"); //将输入框的状态设置为 disabled
                        $("#Ctype_Q").iCheck("enable"); //移除 disabled 状态
                        $("#Ctype_Q").iCheck("check"); //默认选中
                        $("#RevokeDiv").hide();
                    }
                }
            });
        }

        //申请审批类型改变 之后
        function OnAudit_TypeChange() {
            $("input[type='radio'][name='audit_type']:checked").each(function () {
                if ($(this) != null) {
                    var radio_id = $(this).attr("id");
                    if (radio_id == 'Ctype2') {
                        //$("#Revoke1").iCheck("disable"); //将输入框的状态设置为 disabled
                        $("#Revoke2").iCheck("enable"); //移除 disabled 状态
                        $("#Revoke2").iCheck("check"); //默认选中
                    }
                    else if (radio_id == 'Ctype3') {
                        //$("#Revoke1").iCheck("disable"); //将输入框的状态设置为 disabled
                        $("#Revoke2").iCheck("enable"); //移除 disabled 状态
                        $("#Revoke2").iCheck("check"); //默认选中
                    }
                    else {
                        $("#Revoke1").iCheck("enable"); //移除 disabled 状态
                        $("#Revoke1").iCheck("check"); //默认选中
                    }
                }
            });
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>