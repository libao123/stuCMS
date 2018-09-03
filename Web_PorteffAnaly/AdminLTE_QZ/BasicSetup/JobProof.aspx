<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="JobProof.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_QZ.BasicSetup.JobProof" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .datepicker
        {
            z-index: 9999;
        }
    </style>
    <script type="text/javascript" src="/AdminLTE/common/plugins/ckeditor/ckeditor.js"></script>
    <script type="text/javascript">
        var _form_edit;
        var _form_notice;
        var editorObj;
        var mainList;
        window.onload = function () {
            //编辑页form定义
            _form_edit = PageValueControl.init("form_edit");
            _form_notice = PageValueControl.init("form_notice");

            adaptionHeight();
            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
            //----发布公告页----
            ValidateUtils.setRequired("#form_notice", "TITLE", true, "标题必填");
            //时间控件
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });
            $(".dateym").datepicker({
                format: 'yyyy-mm',
                autoclose: true,
                language: "zh-CN"
            });
            //编辑控件
            loadEditor("NOTICE_CONTENT");

            //保存
            $("#btnSave").click(function () {
                SaveData();
            });
        }

        function loadEditor(id) {
            var instance = CKEDITOR.instances[id];
            if (instance) {
                CKEDITOR.remove(instance);
            }
            editorObj = CKEDITOR.replace(id, { customConfig: '/AdminLTE/common/plugins/ckeditor/config.js' });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>填写劳酬凭据基本设置</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>基本设置</li>
				<li class="active">填写劳酬凭据基本设置</li>
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

    <div class="modal fade" id="tableModal">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal"
                onsubmit="return false;">
                <input type="hidden" id="OID" name="OID" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">填写劳酬凭据基本设置</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            学年<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <select name="SCH_YEAR" id="SCH_YEAR" class="form-control" ddl_name="ddl_year_type"
                                d_value="" show_type="t" required>
                            </select>
                        </div>
                        <label class="col-sm-2 control-label">
                            学期<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <select name="SCH_TERM" id="SCH_TERM" class="form-control" ddl_name="ddl_xq"
                                d_value="" show_type="t" required>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            发放月份<span style="color: Red;">*</span></label>
                        <div class="col-sm-4" style="position: relative;">
                            <input type="month" name="YEAR_MONTH" id="YEAR_MONTH" class="form-control" />
                        </div>
                        <label class="col-sm-2 control-label">
                            是否启用<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <select name="IS_ENABLE" id="IS_ENABLE" class="form-control" ddl_name="ddl_yes_no"
                                d_value="" show_type="t" required>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            填写时间<span style="color: Red;">*</span></label>
                        <div class="col-sm-4" style="position: relative;">
                            <input type="text" name="DECLARE_START_TIME" id="DECLARE_START_TIME" class="form-control datep" />
                        </div>
                        <label class="col-sm-2 control-label">
                            至</label>
                        <div class="col-sm-4" style="position: relative;">
                            <input type="text" name="DECLARE_END_TIME" id="DECLARE_END_TIME" class="form-control datep" />
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
    <!-- 发布公告编辑界面 开始 -->
    <div class="modal fade" id="tableModal_Notice">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_notice" name="form_notice" class="modal-content form-horizontal"
                onsubmit="return false;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">公告管理</h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="hidNOTICE_OID" name="hidNOTICE_OID" value="" />
                    <input type="hidden" id="hidUserRoles" name="hidUserRoles" />
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            标题<span style="color: red">*</span>
                        </label>
                        <div class="col-sm-10">
                            <input name="TITLE" id="TITLE" type="text" class="form-control" placeholder="标题" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            副标题</label>
                        <div class="col-sm-10">
                            <input name="SUB_TITLE" id="SUB_TITLE" type="text" class="form-control" placeholder="副标题" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            有效时间</label>
                        <div class="col-sm-4" style="position: relative; z-index: 9999">
                            <input name="START_TIME" id="START_TIME" type="text" class="form-control datep" placeholder="有效起始时间" />
                        </div>
                
                        <label class="col-sm-2 control-label">
                            至</label>
                        <div class="col-sm-4" style="position: relative; z-index: 9999">
                            <input name="END_TIME" id="END_TIME" type="text" class="form-control datep" placeholder="有效结束时间" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            查阅角色</label>
                        <div class="col-sm-10">
                            <div id="divUserRole">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            发布内容<span style="color: red">*</span>
                        </label>
                        <div class="col-sm-10">
                            <textarea name="NOTICE_CONTENT" id="NOTICE_CONTENT" cols="10" rows="5" class="form-control ckEditor"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-save" id="btnSendNotice">发布</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </form>
        </div>
    </div>
    <!-- 发布公告编辑界面 结束-->
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
				{ "data": "SCH_YEAR2", "head": "学年", "type": "td-keep" },
				{ "data": "SCH_TERM2", "head": "学期", "type": "td-keep" },
				{ "data": "YEAR_MONTH", "head": "发放月份", "type": "td-keep" },
				{ "data": "DECLARE_TIME", "head": "填写时间范围", "type": "td-keep" },
				{ "data": "IS_ENABLE2", "head": "是否启用", "type": "td-keep" },
				{ "data": "OP_NAME", "head": "操作人", "type": "td-keep" },
				{ "data": "OP_TIME", "head": "操作时间", "type": "td-keep" }
            ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "基本设置",
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
						{ "data": "SCH_YEAR", "pre": "学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
                        { "data": "SCH_TERM", "pre": "学期", "col": 2, "type": "select", "ddl_name": "ddl_xq" }
                    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } },
					"add", "edit", "del",
                { type: "userDefined", id: "btn-notice", title: "发布公告", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("SCH_YEAR");
            DropDownUtils.initDropDown("SCH_TERM");
            DropDownUtils.initDropDown("IS_ENABLE");
            //用户角色
            GetUserRoleHtml();
            //设置checkbox选中改变事件
            $("input[type='checkbox'][name='user_role']").on('ifChanged', function (event) {
                GetUserRoleSelected();
            });
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        }

        //必填项设置
        function loadModalPageValidate() {
            ValidateUtils.setRequired("#form_edit", "SCH_YEAR", true, "学年必填");
            ValidateUtils.setRequired("#form_edit", "SCH_TERM", true, "学期必填");
            ValidateUtils.setRequired("#form_edit", "IS_ENABLE", true, "是否启用必填");
            ValidateUtils.setRequired("#form_edit", "DECLARE_START_TIME", true, "开始时间必填");
            ValidateUtils.setRequired("#form_edit", "DECLARE_END_TIME", true, "结束时间必填");
            ValidateUtils.setRequired("#form_edit", "YEAR_MONTH", true, "发放月份必填");
        }
    </script>
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _tableModal_Notice = $("#tableModal_Notice");
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload',
				    del: '.btn-del',
				    edit: '.btn-edit'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });

            //新增
            _content.on('click', '.btn-add', function () {
                showBtn();
                $("#tableModal").modal();
                $("#tableModal :input").val("");
                $("#tableModal .form-control-static").text("");
                $("#tableModal input[type='checkbox']").removeAttr('checked');//清除多选框的checked属性
                $("input[type='radio']").removeAttr('checked'); //清除单选框的checked属性
            });

            _content.on('click', _btns.edit, function () {
                showBtn();
                var data = mainList.selectSingle();
                if (data) {
                    $("#tableModal").modal();
                    _form_edit.setFormData(data);
                }
            });

            _content.on('click', "#btn-view", function () {
                _content.find(".btn-edit").click();
                hideBtn();
            });

            //删除
            _content.on('click', _btns.del, function () {
                DeleteData();
            });

            //【发布公告】
            _content.on('click', "#btn-notice", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        if (data.NOTICE_ID) {
                            //通过公告ID获取公告内容
                            var notice = AjaxUtils.getResponseText("?optype=getnotice&id=" + data.NOTICE_ID);
                            if (notice) {
                                var notice_json = eval("(" + notice + ")");
                                _form_notice.setFormData(notice_json);
                            }
                            //加载内容
                            var content = AjaxUtils.getResponseText("/AdminLTE_Mod/BDM/Notice/List.aspx?optype=getcontent&id=" + data.NOTICE_ID);
                            if (content)
                                editorObj.setData(content);

                            $("#hidNOTICE_OID").val(data.NOTICE_ID);
                            $("#S").iCheck("uncheck"); //iCheck移除绑定
                            $("#F").iCheck("uncheck"); //iCheck移除绑定
                            $("#X").iCheck("uncheck"); //iCheck移除绑定
                            $("#Y").iCheck("uncheck"); //iCheck移除绑定
                            $("#D").iCheck("uncheck"); //iCheck移除绑定
                            $("#Q").iCheck("uncheck"); //iCheck移除绑定
                            GetCheckBoxSelectedLoad(notice_json.ROLEID);
                        }
                        else {
                            _form_notice.reset();
                            $("#hidNOTICE_OID").val("");
                            $("#TITLE").val("勤工助学劳酬凭据开始填写");
                            $("#SUB_TITLE").val("填写时间 从 " + data.DECLARE_START_TIME + " -- " + data.DECLARE_END_TIME + "结束");
                            $("#START_TIME").val(data.DECLARE_START_TIME);
                            $("#END_TIME").val(data.DECLARE_END_TIME);
                            $("#S").iCheck("check"); //iCheck绑定
                            $("#D").iCheck("check"); //iCheck绑定
                            $("#Q").iCheck("check"); //iCheck绑定
                            editorObj.setData("");
                        }
                        _tableModal_Notice.modal();
                    }
                }
            });

            _tableModal_Notice.on('click', "#btnSendNotice", function () {
                SendNoticeData();
            });

            var hideBtn = function () {
                $("#btnSave").hide();
            }
            var showBtn = function () {
                $("#btnSave").show();
            }
        }

        //保存事件
        function SaveData() {
            if (!($("#form_edit").valid())) {
                return;
            }

            var result = AjaxUtils.getResponseText("?optype=check&oid=" + $("#OID").val() + "&year=" + $("#SCH_YEAR").val() + "&term=" + $("#SCH_TERM").val() + "&month=" + $("#YEAR_MONTH").val());
            if (result.length > 0) {
                easyAlert.timeShow({
                    "content": result,
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            var data = $("#form_edit").serialize();
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
                            var result = AjaxUtils.getResponseText("?optype=delete&id=" + data.OID);
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

        //发布公告事件
        function SendNoticeData() {
            //校验必填项
            if (!$('#form_notice').valid())
                return;
            //校验发布内容必填
            if (editorObj.getData().length == 0) {
                easyAlert.timeShow({
                    "content": "发布内容必填！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            $('.maskBg').show();
            ZENG.msgbox.show("保存中，请稍后...", 6);
            var data = mainList.selectSingle();
            if (data) {
                if (data.OID) {
                    $("#NOTICE_CONTENT").val(editorObj.getData());
                    $.post(OptimizeUtils.FormatUrl("/AdminLTE_Mod/BDM/Notice/List.aspx?optype=save&proof_oid=" + data.OID), $("#form_notice").serialize(), function (msg) {
                        if (msg.length != 0) {
                            $('.maskBg').hide();
                            ZENG.msgbox.hide();
                            easyAlert.timeShow({
                                "content": msg,
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                        else {
                            //保存成功：关闭界面，刷新列表
                            $('.maskBg').hide();
                            ZENG.msgbox.hide();
                            easyAlert.timeShow({
                                "content": "发布公告成功，请到系统维护>>公告通知>>公告管理 中进行内容的查阅以及完善！",
                                "duration": 2,
                                "type": "success"
                            });
                            $("#tableModal_Notice").modal("hide");
                            mainList.reload();
                        }
                    });
                }
            }
        }

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
        function GetUserRoleSelected() {
            var checkbox = "";
            $("#hidUserRoles").val("");
            $("input[type='checkbox'][name='user_role']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).attr("value") + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidUserRoles").val(checkbox);
            }
        }
    </script>
</asp:Content>
