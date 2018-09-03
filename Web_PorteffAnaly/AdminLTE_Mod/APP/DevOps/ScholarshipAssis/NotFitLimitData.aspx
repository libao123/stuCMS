<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="NotFitLimitData.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.APP.DevOps.ScholarshipAssis.NotFitLimitData" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList; //主列表
        var projectList; //申请项目选择列表
        var revoke_com; //撤销申请
        var wfklog; //审批流程跟踪
        $(function () {
            adaptionHeight();

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
			<h1>不符合奖助申请条件学生名单</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统运维</li>
				<li class="active">不符合奖助申请条件学生名单</li>
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
    <!-- 可提供申请奖助项目列表选择 开始 -->
    <div class="modal" id="projectListModal">
        <div class="modal-dialog modal-dw60">
            <div class="modal-content form-horizontal">
                <div class="modal-body">
                    <table id="tablelist_project" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 可提供申请奖助项目列表选择 结束-->
    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "IS_FIT_LIMIT_NAME", "head": "是否符合申请条件", "type": "td-keep" },
                    { "data": "NOT_FIT_LIMIT_REMARK", "head": "不符合的原因", "type": "td-keep" },
                    { "data": "RET_CHANNEL", "head": "当前状态", "type": "td-keep" },
                    { "data": "DECLARE_TYPE_NAME", "head": "申请类型", "type": "td-keep" },
                    { "data": "PROJECT_CLASS_NAME", "head": "项目级别", "type": "td-keep" },
                    { "data": "PROJECT_TYPE_NAME", "head": "申请表格类型", "type": "td-keep" },
				    { "data": "PROJECT_NAME", "head": "项目名称", "type": "td-keep" },
				    { "data": "PROJECT_MONEY", "head": "项目金额", "type": "td-keep" },
				    { "data": "PROJECT_YEAR_NAME", "head": "项目学年", "type": "td-keep" },
				    { "data": "STU_NUMBER", "head": "申请人学号", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "申请人姓名", "type": "td-keep" },
                    { "data": "XY_NAME", "head": "所属学院", "type": "td-keep" },
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" },
                    { "data": "DECL_TIME", "head": "申请时间", "type": "td-keep" },
                    { "data": "CHK_TIME", "head": "审核时间", "type": "td-keep" },
                    { "data": "ZY_NAME", "head": "所属专业", "type": "td-keep" },
                    { "data": "GRADE", "head": "所属年级", "type": "td-keep" },
                    { "data": "SEQ_NO", "head": "单据编号", "type": "td-keep" }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "NotFitLimitData.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "奖助申请",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(3)');
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
					    { "data": "PROJECT_YEAR", "pre": "项目学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
					    { "data": "PROJECT_CLASS", "pre": "项目级别", "col": 2, "type": "select", "ddl_name": "ddl_jz_project_class" },
                        { "data": "PROJECT_TYPE", "pre": "申请表格类型", "col": 3, "type": "select", "ddl_name": "ddl_jz_project_type" },
                        { "data": "PROJECT_SEQ_NO", "pre": "项目名称", "col": 4, "type": "select", "ddl_name": "ddl_jz_project_name" },
                        { "data": "XY", "pre": "学院", "col": 5, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 6, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 7, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 8, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 9, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 10, "type": "input" },
                        { "data": "RET_CHANNEL", "pre": "当前状态", "col": 11, "type": "select", "ddl_name": "ddl_RET_CHANNEL" },
                        { "data": "DECLARE_TYPE", "pre": "申请类型", "col": 12, "type": "select", "ddl_name": "ddl_DECLARE_TYPE" },
                        { "data": "IS_FIT", "pre": "是否符合", "col": 13, "type": "select", "ddl_name": "ddl_yes_no" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "delete", title: "删除并发消息告知", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "back_s", title: "退回预录入", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "back_y", title: "退回学院待审", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                //{ type: "userDefined", id: "export", title: "导出名单", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //奖助级别、奖助类型 联动
            SelectUtils.JZ_Class_Type_Year_ProjectChange("search-PROJECT_CLASS", "search-PROJECT_TYPE", "search-PROJECT_YEAR", "search-PROJECT_SEQ_NO", '', '', '', '', '');
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASS_CODE");
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 按钮事件 开始-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _btns = {
                reload: '.btn-reload'
            };
            //-----------主列表按钮---------------
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【删除并发消息告知】
            _content.on('click', "#delete", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        easyConfirm.locationShow({
                            'type': 'warn',
                            'content': "确认删除选中的数据吗？",
                            'title': '此删除按钮慎重使用',
                            'callback': function (btn) {
                                var result = AjaxUtils.getResponseText("NotFitLimitData.aspx?optype=delete&id=" + data.OID);
                                if (result.length == 0) {
                                    easyAlert.timeShow({
                                        "content": "删除成功！",
                                        "duration": 2,
                                        "type": "success"
                                    });
                                    mainList.reload();
                                    return;
                                }
                                else {
                                    easyAlert.timeShow({
                                        "content": result,
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                    mainList.reload();
                                    return;
                                }
                            }
                        });
                    }
                }
            });
            //【退回预录入】
            _content.on('click', "#back_s", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        var result = AjaxUtils.getResponseText("NotFitLimitData.aspx?optype=back_s&id=" + data.OID);
                        if (result.length == 0) {
                            easyAlert.timeShow({
                                "content": "退回预录入成功！",
                                "duration": 2,
                                "type": "success"
                            });
                            mainList.reload();
                            return;
                        }
                        else {
                            easyAlert.timeShow({
                                "content": result,
                                "duration": 2,
                                "type": "danger"
                            });
                            mainList.reload();
                            return;
                        }
                    }
                }
            });
            //【退回学院待审】
            _content.on('click', "#back_y", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        var result = AjaxUtils.getResponseText("NotFitLimitData.aspx?optype=back_y&id=" + data.OID);
                        if (result.length == 0) {
                            easyAlert.timeShow({
                                "content": "退回学院待审成功！",
                                "duration": 2,
                                "type": "success"
                            });
                            mainList.reload();
                            return;
                        }
                        else {
                            easyAlert.timeShow({
                                "content": result,
                                "duration": 2,
                                "type": "danger"
                            });
                            mainList.reload();
                            return;
                        }
                    }
                }
            });
            //【导出】
            _content.on('click', "#export", function () {

            });
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>