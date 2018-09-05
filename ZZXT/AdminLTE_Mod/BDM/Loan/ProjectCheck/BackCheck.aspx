<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="BackCheck.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Loan.ProjectCheck.BackCheck" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList;
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
			<h1>确认信息</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>贷款管理</li>
				<li class="active">确认信息</li>
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
    <!-- 遮罩层 开始-->
    <div class="maskBg">
    </div>
    <!-- 遮罩层 结束-->
    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "CHECK_OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "LOAN_NAME", "head": "贷款名称", "type": "td-keep" },
                    { "data": "LOAN_TYPE_NAME", "head": "贷款类型", "type": "td-keep" },
                    { "data": "LOAN_YEAR_NAME", "head": "项目学年", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "申请人姓名", "type": "td-keep" },
                    { "data": "CHECK_STEP_NAME", "head": "核对阶段", "type": "td-keep" },
                    { "data": "S_CHECK_TIME", "head": "学生核对时间", "type": "td-keep" },
                    { "data": "F_CHECK_TIME", "head": "辅导员核对时间", "type": "td-keep" },
                    { "data": "Y_CHECK_TIME", "head": "学院核对时间", "type": "td-keep" },
                    { "data": "CHECK_START", "head": "核对开始时间", "type": "td-keep" },
                    { "data": "CHECK_END", "head": "核对结束时间", "type": "td-keep" },
                    { "data": "OLD_BANKCODE", "head": "核对前银行卡号", "type": "td-keep" },
                    { "data": "NEW_BANKCODE", "head": "核对后银行卡号", "type": "td-keep" },
                    { "data": "XY_NAME", "head": "所属学院", "type": "td-keep" },
                    { "data": "ZY_NAME", "head": "所属专业", "type": "td-keep" },
                    { "data": "GRADE", "head": "所属年级", "type": "td-keep" },
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" },
                    { "data": "BACK_NAME", "head": "退回人", "type": "td-keep" },
                    { "data": "BACK_TIME", "head": "退回时间", "type": "td-keep" }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "CheckList.aspx?optype=getlist&page_from=backcheck",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "退回核对信息",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': false, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(5)');
                            if (aData.CHECK_STEP == "1") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "warning",
                                        "msg": "学生已核对"
                                    });
                            } else if (aData.CHECK_STEP == "2") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "primary",
                                        "msg": "辅导员已核对"
                                    });
                            } else if (aData.CHECK_STEP == "3") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "学院已核对"
                                    });
                            }
                            else {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "未核对"
                                    });
                            }
                        }
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
					    { "data": "LOAN_TYPE", "pre": "贷款类型", "col": 2, "type": "select", "ddl_name": "ddl_loan_type" },
					    { "data": "LOAN_YEAR", "pre": "贷款学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
                        { "data": "LOAN_SEQ_NO", "pre": "贷款名称", "col": 4, "type": "select", "ddl_name": "ddl_loan_project" },
                        { "data": "XY", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 3, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 4, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 5, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 6, "type": "input" },
                        { "data": "BACK_NAME", "pre": "退回人姓名", "col": 7, "type": "input" },
                        { "data": "CHECK_STEP", "pre": "核对阶段", "col": 4, "type": "select", "ddl_name": "ddl_apply_check_step" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "back_N", title: "退回学生未核对", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "back_1", title: "退回学生已核对", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "back_2", title: "退回辅导员已核对", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //贷款类型、学年、贷款项目联动
            SelectUtils.Loan_Year_ProjectChange("search-LOAN_TYPE", "search-LOAN_YEAR", "search-LOAN_SEQ_NO", '', '', '');
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
            //【退回学生未核对】
            _content.on('click', "#back_N", function () {
                if (!IsCanOpBack())
                    return;

                //列表勾选
                var strOids = "";
                var datas = mainList.selection();
                if (datas) {
                    for (var i = 0; i < datas.length; i++) {
                        if (datas[i]) {
                            if (datas[i].CHECK_OID) {
                                strOids += datas[i].CHECK_OID + ",";
                            }
                        }
                    }
                }

                easyConfirm.locationShow({
                    'type': 'warn',
                    'content': "确认退回选中的数据吗？",
                    'title': '退回数据',
                    'callback': function (btn) {
                        var CHECK_STEP = DropDownUtils.getDropDownValue("search-CHECK_STEP");
                        var postData = { "SELECT_OID": strOids };
                        var url = "BackCheck.aspx?optype=multi_back&backtype=N&step=" + CHECK_STEP;
                        $.ajax({
                            cache: false,
                            type: "POST",
                            url: url,
                            async: false,
                            data: postData,
                            success: function (result) {
                                if (result) {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": result,
                                        "duration": 2,
                                        "type": "info"
                                    });
                                    mainList.reload();
                                    return;
                                }
                            }
                        });
                    }
                });
            });
            //【退回学生已核对】
            _content.on('click', "#back_1", function () {
                if (!IsCanOpBack())
                    return;

                //列表勾选
                var strOids = "";
                var datas = mainList.selection();
                if (datas) {
                    for (var i = 0; i < datas.length; i++) {
                        if (datas[i]) {
                            if (datas[i].CHECK_OID) {
                                strOids += datas[i].CHECK_OID + ",";
                            }
                        }
                    }
                }
                easyConfirm.locationShow({
                    'type': 'warn',
                    'content': "确认退回选中的数据吗？",
                    'title': '退回数据',
                    'callback': function (btn) {
                        var CHECK_STEP = DropDownUtils.getDropDownValue("search-CHECK_STEP");
                        var postData = { "SELECT_OID": strOids };
                        var url = "BackCheck.aspx?optype=multi_back&backtype=1&step=" + CHECK_STEP;
                        $.ajax({
                            cache: false,
                            type: "POST",
                            url: url,
                            async: false,
                            data: postData,
                            success: function (result) {
                                if (result) {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": result,
                                        "duration": 2,
                                        "type": "info"
                                    });
                                    mainList.reload();
                                    return;
                                }
                            }
                        });
                    }
                });
            });
            //【退回辅导员已核对】
            _content.on('click', "#back_2", function () {
                if (!IsCanOpBack())
                    return;

                //列表勾选
                var strOids = "";
                var datas = mainList.selection();
                if (datas) {
                    for (var i = 0; i < datas.length; i++) {
                        if (datas[i]) {
                            if (datas[i].CHECK_OID) {
                                strOids += datas[i].CHECK_OID + ",";
                            }
                        }
                    }
                }

                easyConfirm.locationShow({
                    'type': 'warn',
                    'content': "确认退回选中的数据吗？",
                    'title': '退回数据',
                    'callback': function (btn) {
                        var CHECK_STEP = DropDownUtils.getDropDownValue("search-CHECK_STEP");
                        var postData = { "SELECT_OID": strOids };
                        var url = "BackCheck.aspx?optype=multi_back&backtype=2&step=" + CHECK_STEP;
                        $.ajax({
                            cache: false,
                            type: "POST",
                            url: url,
                            async: false,
                            data: postData,
                            success: function (result) {
                                if (result) {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": result,
                                        "duration": 2,
                                        "type": "info"
                                    });
                                    mainList.reload();
                                    return;
                                }
                            }
                        });
                    }
                });
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
        //是否可以操作退回按钮
        function IsCanOpBack() {
            var CHECK_STEP = DropDownUtils.getDropDownValue("search-CHECK_STEP");
            if (!CHECK_STEP) {
                easyAlert.timeShow({
                    "content": "退回操作时，核对阶段必选！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            //院级已核的  辅导员不能退回  院级未核的辅导员可以自行退回，院级退回不搜受限制
            if ("<%=user.User_Role %>" == "F" && CHECK_STEP == "3") {
                easyAlert.timeShow({
                    "content": "院级已核的  辅导员不能退回！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            return true;
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>