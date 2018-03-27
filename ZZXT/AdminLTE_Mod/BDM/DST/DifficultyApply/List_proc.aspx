<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List_proc.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.DifficultyApply.List_proc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList;
        var grantList;
        var memberList;
        var selectList;
        var _form_edit;
        window.onload = function () {
            _form_edit = PageValueControl.init("form_edit");
            adaptionHeight();
            loadTableList();
            loadGrantList();
            loadMemberList();

            DropDownUtils.initDropDown("GRANT_SCHOOL_YEAR");

            //ValidateUtils.setRequired("#grant_edit", "GRANT_SCHOOL_YEAR", true, "请选择学年");
            //ValidateUtils.setRequired("#grant_edit", "GRANT_ITEM", true, "请填写项目");

            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-COLLEGE", "search-MAJOR", "", "search-CLASS");

        };
        $(function () {
            $('#myTab a').click(function (e) {
                e.preventDefault();
                if ($(this).text() != "基本信息" && !($("#SEQ_NO").val())) {
                    easyAlert.timeShow({
                        "content": "请先保存数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return false;
                }
                return true;
            });
            $("#btnSave").click(function () {
                SaveData();
            });
            $("#btnGrantSave").click(function () {
                SaveGrant();
            });
        });
    </script>
    <%--主列表--%>
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
				{ "data": "NUMBER", "head": "学号" },
				{ "data": "NAME", "head": "姓名" },
				{ "data": "SEX_NAME", "head": "性别" },
				{ "data": "COLLEGE_NAME", "head": "学院" },
				{ "data": "MAJOR_NAME", "head": "专业" },
				{ "data": "CLASS_NAME", "head": "班级" },
				{ "data": "LEVEL_CODE_NAME", "head": "认定档次" },
				{ "data": "SCHYEAR_NAME", "head": "学年" },
				{ "data": "CHK_TIME", "head": "审核时间" },
				{ "data": "DECLARE_TYPE_NAME", "head": "申请类型" },
				{ "data": "RET_CHANNEL", "head": "当前状态" }
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
                    tableTitle: "已处理查看",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(11)');
                            if (aData.RET_CHANNEL == "A0000") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "primary",
                                        "msg": "预录入"
                                    });
                            } else if (aData.RET_CHANNEL == "A0010") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "primary",
                                        "msg": "申请中"
                                    });
                            } else if (aData.RET_CHANNEL == "D1000") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "辅导员待审"
                                    });
                            } else if (aData.RET_CHANNEL == "D1010") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "辅导员通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D1020") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "warning",
                                        "msg": "辅导员不通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D2000") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "院级待审"
                                    });
                            } else if (aData.RET_CHANNEL == "D2010") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "院级通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D2020") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "warning",
                                        "msg": "院级不通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D3000") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "校级待审"
                                    });
                            } else if (aData.RET_CHANNEL == "D3010") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "校级通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D3020") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "warning",
                                        "msg": "校级不通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D4000") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "审批通过"
                                    });
                            } else {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "未申请"
                                    });
                            }
                        }
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
						{ "data": "SCHYEAR", "pre": "学年周期", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
						{ "data": "COLLEGE", "pre": "学院", "col": 2, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "MAJOR", "pre": "专业", "col": 3, "type": "select", "ddl_name": "ddl_zy" },
						{ "data": "CLASS", "pre": "班级", "col": 4, "type": "select", "ddl_name": "ddl_class" },
						{ "data": "LEVEL_CODE", "pre": "认定档次", "col": 5, "type": "select", "ddl_name": "ddl_dst_level" },
                        { "data": "NUMBER", "pre": "学号", "col": 6, "type": "input" },
						{ "data": "NAME", "pre": "姓名", "col": 6, "type": "input" },
                        { "data": "DECLARE_TYPE", "pre": "申请类型", "col": 7, "type": "select", "ddl_name": "ddl_DECLARE_TYPE" },
                        { "data": "RET_CHANNEL", "pre": "当前状态", "col": 8, "type": "select", "ddl_name": "ddl_RET_CHANNEL" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
					{ type: "userDefined", id: "btn-list-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
					{ type: "userDefined", id: "btn-list-unsubmit", title: "撤销", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
					{ type: "userDefined", id: "btn-list-undo", title: "撤销申请", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
					{ type: "userDefined", id: "btn-list-wflow", title: "流程跟踪", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                //, { type: "userDefined", id: "btn-list-export", title: "导出", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } }
				], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });

            var _content = $("#content");
            //刷新
            _content.on('click', ".btn-reload", function () {
                mainList.reload();
            });
            _content.on('click', "#btn-list-view", function () {
                hideBtn();
                var data = mainList.selectSingle();
                if (data) {
                    grantList.refresh("?optype=getgrantlist&seq_no=" + data.SEQ_NO);
                    memberList.refresh("?optype=getmemberlist&number=" + data.NUMBER);
                    $("#tableModal").modal();
                    $("#tabli1").click();
                    //SetMainFormData("tableModal", "", data);
                    var apply_data = AjaxUtils.getResponseText('/AdminLTE_Mod/BDM/DST/DifficultyApply/List.aspx?optype=getdata&id=' + data.OID);
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
            _content.on('click', "#btn-list-unsubmit", function () {
                var data = mainList.selectSingle();
                if (data) {
                    var result = AjaxUtils.getResponseText('/AdminLTE_Mod/CHK/Revoke.aspx?optype=chk&doc_type=' + data.DOC_TYPE + '&seq_no=' + data.SEQ_NO + '&col_name=NUMBER');
                    if (result.length > 0) {
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                    }
                    else {
                        result = AjaxUtils.getResponseText('/AdminLTE_Mod/CHK/Revoke.aspx?optype=revoke&doc_type=' + data.DOC_TYPE + '&seq_no=' + data.SEQ_NO + '&col_name=NUMBER&nj=' + escape(data.GRADE) + '&xy=' + escape(data.COLLEGE) + '&bj=' + escape(data.CLASS) + '&zy=' + escape(data.MAJOR));
                        if (result.length > 0) {
                            easyAlert.timeShow({
                                "content": result,
                                "duration": 2,
                                "type": "danger"
                            });
                        }
                        else {
                            MsgUtils.info('撤销成功！');
                        }
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

            //【撤销申请】
            //---------撤销申请  开始------------------
            revoke_com = revokeComPage.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "revokeModal"//弹出层的id，不写则默认verifyModal，必填
                },
                control: {
                    "content": "#content", //必填
                    "btnId": "#btn-list-undo", //触发弹出层的按钮的id，必填
                    "beforeShow": function (btn, form) {//返回btn信息和form信息
                        var data = mainList.selectSingle();
                        if (data) {
                            if (data.OID) {
                                //判断是否有撤销权限
                                var strUrl = '/AdminLTE_Mod/CHK/Revoke.aspx?optype=chkdecl&doc_type=' + data.DOC_TYPE + '&seq_no=' + data.SEQ_NO;
                                var strResult = AjaxUtils.getResponseText(strUrl);
                                if (strResult.length > 0) {
                                    easyAlert.timeShow({
                                        "content": strResult,
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                    return false;
                                }
                                $("#revokeMsg").val(""); //初始化默认为空
                                return true;
                            }
                        }
                        return false;
                    },
                    "afterShow": function (btn, form) {//返回btn信息和form信息
                        return true;
                    },
                    "beforeSubmit": function (btn, form) {//返回btn信息和form信息
                        return true;
                    },
                    validCallback: function (form) {//验证通过之后的操作
                        var data = mainList.selectSingle();
                        //提交撤销申请
                        var revokeurl = OptimizeUtils.FormatUrl('/AdminLTE_Mod/CHK/Revoke.aspx?optype=submit_revoke&doc_type=' + data.DOC_TYPE + '&seq_no=' + data.SEQ_NO + '&nj=' + escape(data.GRADE) + '&xy=' + escape(data.COLLEGE) + '&bj=' + escape(data.CLASS) + '&zy=' + escape(data.MAJOR));
                        $.post(revokeurl, $("#form_revoke").serialize(), function (msg) {
                            if (msg.length > 0) {
                                easyAlert.timeShow({
                                    "content": msg,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return false;
                            }
                            else {
                                //保存成功：关闭界面，刷新列表
                                $("#revokeModal").modal("hide");
                                easyAlert.timeShow({
                                    "content": "撤销申请成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                mainList.reload();
                                return true;
                            }
                        });
                    }
                }
            });
            //---------撤销申请  结束------------------

            //【审核流程跟踪】
            //------------------审核流程跟踪 开始------------------------------------------
            wfklog = WfkLog.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "wfklogModal"//弹出层的id，不写则默认wfklogModal，必填
                },
                control: {
                    "content": "#content", //必填
                    "btnId": "#btn-list-wflow", //触发弹出层的按钮的id，必填
                    "beforeShow": function (btn, form) {//返回btn信息和form信息
                        var data = mainList.selectSingle();
                        if (data) {
                            if (data.OID) {
                                return true;
                            }
                        }
                        return false;
                    },
                    "afterShow": function (btn, form) {//返回btn信息和form信息
                        var data = mainList.selectSingle();
                        _m_wfklog_list.refresh(OptimizeUtils.FormatUrl("/AdminLTE_Mod/Common/ComPage/WkfLogList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        return true;
                    },
                    "beforeSubmit": function (btn, form) {//返回btn信息和form信息
                    }
                }
            });
            //------------------审核流程跟踪 结束------------------------------------------
            _content.on('click', "#btn-list-export", function () {
                var SCHYEAR = DropDownUtils.getDropDownValue("search-SCHYEAR");
                var COLLEGE = DropDownUtils.getDropDownValue("search-COLLEGE");
                var CLASS = DropDownUtils.getDropDownValue("search-CLASS");
                var MAJOR = DropDownUtils.getDropDownValue("search-MAJOR");
                var LEVEL_CODE = DropDownUtils.getDropDownValue("search-LEVEL_CODE");
                var NAME = $("#search-NAME").val();
                var DECLARE_TYPE = DropDownUtils.getDropDownValue("search-DECLARE_TYPE");
                if (SCHYEAR.length == 0 || COLLEGE.length == 0) {
                    easyAlert.timeShow({
                        "content": "查询条件：学年、学院不能为空！",
                        "duration": 3,
                        "type": "info"
                    });
                    return;
                }
                var para = '&SCHYEAR=' + SCHYEAR + '&COLLEGE=' + COLLEGE + '&CLASS=' + CLASS + '&MAJOR=' + MAJOR + '&LEVEL_CODE=' + LEVEL_CODE + '&NAME=' + NAME + '&DECLARE_TYPE=' + DECLARE_TYPE;
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=dstapply' + para);
            });

            var hideBtn = function () {
                $("#tableModal").find(".box-tools").hide();
                $("#btnSave").hide();
                $("#btnSubmit").hide();
            }
            var showBtn = function () {
                $("#tableModal").find(".box-tools").show();
                $("#btnSave").show();
                $("#btnSubmit").show();
            }
        }
    </script>
    <%--在校期间获何种奖励及资助情况--%>
    <script type="text/javascript">
        //列表初始化
        function loadGrantList() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "SCHOOL_YEAR", "head": "学年" },
				{ "data": "ITEM", "head": "项目" },
				{ "data": "RANK", "head": "等级" }
			];

            //配置表格
            grantList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getgrantlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "grantlist", //表格id
                    buttonId: "grantListbuttonId", //拓展按钮区域id
                    tableTitle: "在校期间获何种奖励及资助情况",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                hasModal: false, //弹出层参数
                hasBtns: [], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            var content = $("#content_grant");
            content.on('click', ".btn-reload", function () {
                grantList.reload();
            });
            content.on('click', ".btn-add", function () {
                if (!($("#SEQ_NO").val())) {
                    easyAlert.timeShow({
                        "content": "请先保存基本信息！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
                $("#grantModal").modal();
                $("#grantModal :input").val("");
            });

            content.on('click', ".btn-edit", function () {
                var data = grantList.selectSingle();
                if (data) {
                    $("#grantModal").modal();
                    SetMainFormData("grantModal", "GRANT_", data);
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
            content.on('click', ".btn-del", function () {
                var data = grantList.selectSingle();
                if (data) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除所选的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            $.post(OptimizeUtils.FormatUrl("?optype=delgrant&id=" + data.OID), function (msg) {
                                if (!msg) {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": "删除成功！",
                                        "duration": 2,
                                        "type": "success"
                                    });
                                    grantList.reload();
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
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
        }
    </script>
    <%--家庭成员情况--%>
    <script type="text/javascript">
        //列表初始化
        function loadMemberList() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "RELATION", "head": "称呼" },
				{ "data": "NAME", "head": "姓名" },
				{ "data": "PROFESSION", "head": "职业" },
				{ "data": "IDCARDNO", "head": "身份证号" },
				{ "data": "WORKPLACE", "head": "工作单位" },
				{ "data": "INCOME_MONTH", "head": "月收入(元)" }
			];

            //配置表格
            memberList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getmemberlist&number=XXX",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "memberlist", //表格id
                    buttonId: "memberListbuttonId", //拓展按钮区域id
                    tableTitle: "",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                hasModal: false, //弹出层参数
                hasBtns: [], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <%--其他方法：设置表单值--%>
    <script type="text/javascript">
        function SetMainFormData(modal, fixed, data) {
            $("input[type='radio']").removeAttr('checked'); //清除单选框的checked属性
            for (var e in data) {
                if (data.hasOwnProperty(e)) {
                    var _s = $("#" + modal).find('[name=' + e + ']');
                    if (_s.length == 0) {
                        _s = $("#" + modal + " #" + fixed + e);
                    }
                    if (_s.length > 0) {
                        var _val = data[e];
                        if (_s.prop("nodeName") != 'TEXTAREA' && _s.prop('nodeName') != "SELECT") {
                            if (_s.attr('type') == "checkbox") {
                                if (parseInt(_val) > 0 && _val != undefined && _val != '') {
                                    _s.prop('checked', true);
                                    try {
                                        _s.iCheck('check');
                                    } catch (e) {

                                    }
                                } else {
                                    _s.prop('checked', false);
                                    try {
                                        _s.iCheck('uncheck');
                                    } catch (e) {

                                    }
                                }
                            } else if (_s.attr('type') == "file") {

                            } else if (_s.attr('type') == "radio") {
                                if (_val)
                                    $("#" + modal).find('[name=' + e + '][value=' + _val + ']').prop("checked", "checked");
                            } else {
                                if (_s[0]["nodeName"] == "P")
                                    _s.text(_val);
                                else
                                    _s.val(_val);
                            }
                        } else if (_s.prop('nodeName') == "SELECT") {
                            _s.val(_val);
                        } else {
                            if (_s.hasClass('ckEditor')) {
                                var editorElement = CKEDITOR.document.getById(_s.attr('id'));
                                editorElement.setHtml(_val);
                            } else {
                                _s.val(_val);
                            }
                        }
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>已处理查看</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>困难生认定</li>
				<li class="active">已处理查看</li>
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
    <!-- 编辑界面 -->
    <div class="modal fade" id="tableModal">
        <div class="modal-dialog modal-dw80">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <input type="hidden" id="OID" name="OID" />
            <input type="hidden" id="SEQ_NO" name="SEQ_NO" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">困难生申请</h4>
            </div>
            <div class="modal-body">
                <div class="nav-tabs-custom" style="box-shadow: none; margin-bottom: 0px;">
                    <ul class="nav nav-tabs" id="myTab">
                        <li class="active"><a href="#tab_1" data-toggle="tab" id="tabli1">基本信息</a></li>
                        <li><a href="#tab_2" data-toggle="tab">家庭成员情况</a></li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab_1">

                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    学号<span style="color: Red;">*</span></label>
                                <div class="col-sm-4">
                                    <input name="NUMBER" id="NUMBER" type="text" class="form-control" placeholder="双击选择"
                                        readonly />
                                </div>

                                <label class="col-sm-2 control-label">
                                    姓名</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="NAME">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    性别</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="SEX">-</p>
                                </div>

                                <label class="col-sm-2 control-label">
                                    出生年月</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="BIRTH_DATE">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    民族</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="NATION">-</p>
                                </div>

                                <label class="col-sm-2 control-label">
                                    身份证号码</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="IDCARDNO">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    政治面貌</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="POLISTATUS">-</p>
                                </div>

                                <label class="col-sm-2 control-label">
                                    院系</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="COLLEGE">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    专业</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="MAJOR">-</p>
                                </div>

                                <label class="col-sm-2 control-label">
                                    班级</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="CLASS">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    在校联系电话</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="TELEPHONE">-</p>
                                </div>

                                <label class="col-sm-2 control-label">
                                    家庭电话</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="HOME_PHONE">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    家庭住址</label>
                                <div class="col-sm-10">
                                    <p class="form-control-static" id="HOME_ADDRESS">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    家庭年总收入</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="ANNUAL_INCOME">-</p>
                                </div>

                                <label class="col-sm-2 control-label">
                                    家庭人均月收入</label>
                                <div class="col-sm-4">
                                    <p class="form-control-static" id="MONTHLY_INCOME">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    申请认定家庭经济困难理由</label>
                                <div class="col-sm-10">
                                    <textarea name="APPLY_REASON" id="APPLY_REASON" rows="3" maxlength="60" class="form-control"
                                        placeholder="对本人的家庭情况、成员伤病情况、收入来源情况、突发意外事件、欠债情况等进行详细描述，字数限制在100-300个字"></textarea>
                                </div>
                            </div>
                            <section class="content" id="content_grant">
                              <div class="row">
                                <div class="col-xs-12">
                                  <table id="grantlist" class="table table-bordered table-striped table-hover">
                                  </table>
                                </div>
                              </div>
                            </section>
                        </div>
                        <div class="tab-pane" id="tab_2">
                            <table id="memberlist" class="table table-bordered table-striped table-hover">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 选择界面-->
    <div class="modal fade" id="selectModal">
        <div class="modal-dialog modal-dw80">

                <div class="modal-content">
                    <div id=""></div>
                    <div class="box box-default">
                        <table id="selectlist" class="table table-bordered table-striped table-hover">
                        </table>
                    </div>
                </div>

        </div>
    </div>
    <%-- 在校期间获何种奖励及资助情况编辑界面 开始 --%>
    <div class="modal fade" id="grantModal">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="grant_edit" name="grant_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">奖励及资助情况</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" name="OID" id="GRANT_OID" />

                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            学年<span style="color: Red;">*</span></label>
                        <div class="col-sm-9">
                            <select class="form-control" name="SCHOOL_YEAR" id="GRANT_SCHOOL_YEAR" d_value=''
                                ddl_name='ddl_year_type' show_type='t' required messages="请选择学年">
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            项目<span style="color: Red;">*</span></label>
                        <div class="col-sm-9">
                            <input name="ITEM" id="GRANT_ITEM" type="text" class="form-control" placeholder="项目"
                                required />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            等级</label>
                        <div class="col-sm-9">
                            <input name="RANK" id="GRANT_RANK" type="text" class="form-control" placeholder="等级" />
                        </div>
                    </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnGrantSave">保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
</asp:Content>
