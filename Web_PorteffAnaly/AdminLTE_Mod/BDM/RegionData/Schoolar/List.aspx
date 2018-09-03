<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.RegionData.Schoolar.List" %>

<asp:content id="Content1" contentplaceholderid="head" runat="server">
    <script type="text/javascript">
        var mainList; //主列表
        var wfklog; //审批流程跟踪
        $(function () {
            adaptionHeight();
            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
        });
    </script>
</asp:content>
<asp:content id="Content2" contentplaceholderid="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>区资助系统所需信息管理</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>区资助系统所需信息管理</li>
				<li class="active">奖助管理</li>
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
    <div class="modal fade" id="editModal">
        <div class="modal-dialog">
            <div class="modal-body">
                <iframe id="editFrame" name="editFrame" frameborder="0" src="" style="width: 100%;">
                </iframe>
            </div>
        </div>
    </div>
    <!-- 编辑界面 结束-->
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
                    { "data": "PROJECT_CLASS_NAME", "head": "项目级别", "type": "td-keep" },
				    { "data": "PROJECT_TYPE_NAME", "head": "申请表格类型", "type": "td-keep" },
				    { "data": "PROJECT_NAME", "head": "项目名称", "type": "td-keep" },
				    { "data": "PROJECT_MONEY", "head": "项目金额", "type": "td-keep" },
				    { "data": "PROJECT_YEAR_NAME", "head": "项目学年", "type": "td-keep" },
				    { "data": "STU_NUMBER", "head": "申请人学号", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "申请人姓名", "type": "td-keep" },
                    { "data": "XY_NAME", "head": "所属学院", "type": "td-keep" },
                    { "data": "ZY_NAME", "head": "所属专业", "type": "td-keep" },
                    { "data": "GRADE", "head": "所属年级", "type": "td-keep" },
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" },
				    { "data": "RET_CHANNEL", "head": "流程状态", "type": "td-keep" },
                    { "data": "DECLARE_TYPE_NAME", "head": "申请类型", "type": "td-keep" },
                    { "data": "DECL_TIME", "head": "申请时间", "type": "td-keep" },
                    { "data": "CHK_TIME", "head": "审核时间", "type": "td-keep" },
                    { "data": "SEQ_NO", "head": "单据编号", "type": "td-keep" }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/BDM/ScholarshipAssis/ProjectApply/List.aspx?optype=getlist&page_from=nation_schoolar",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "统计查询",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': false, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(12)');
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
                        { "data": "XY", "pre": "学院", "col": 5, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 6, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 7, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 8, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 9, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 10, "type": "input" },
                        { "data": "STU_TYPE", "pre": "学生类型", "col": 11, "type": "select", "ddl_name": "ddl_ua_stu_type" },
                        { "data": "EXPORT_TYPE", "pre": "导出类型", "col": 12, "type": "select", "ddl_name": "ddl_region_jz_export_type" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "history", title: "审批流程跟踪", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "export", title: "导出", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
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
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //弹出编辑页
                        $("#editFrame").attr("src", OptimizeUtils.FormatUrl("/AdminLTE_Mod/BDM/ScholarshipAssis/ProjectApply/Edit.aspx?optype=view&id=" + data.OID
                        + "&seq_no=" + data.SEQ_NO + "&project_seq_no=" + data.PROJECT_SEQ_NO));
                        $("#editModal").modal();
                        $("#editModal .modal-dialog").css({ "width": "100%", "margin": "0", "padding": "0" });
                        $("#editModal .modal-body").outerHeight($(window).height());
                        $("#editFrame").height($("#editModal .modal-body").height());
                    }
                }
            });
            //【导出】
            _content.on('click', "#export", function () {
                //校验必选
                var PROJECT_YEAR = DropDownUtils.getDropDownValue("search-PROJECT_YEAR");
                var STU_TYPE = DropDownUtils.getDropDownValue("search-STU_TYPE");
                var EXPORT_TYPE = DropDownUtils.getDropDownValue("search-EXPORT_TYPE");
                if (PROJECT_YEAR.length == 0 || EXPORT_TYPE.length == 0 || STU_TYPE.length == 0) {
                    easyAlert.timeShow({
                        "content": "查询条件：学年、导出类型、学生类型不能为空！",
                        "duration": 3,
                        "type": "info"
                    });
                    return;
                }
                if (STU_TYPE == "B") {//本科生
                    if (EXPORT_TYPE == "D" || EXPORT_TYPE == "E" || EXPORT_TYPE == "F") {
                        easyAlert.timeShow({
                            "content": "选择的学生类型与导出类型冲突！",
                            "duration": 3,
                            "type": "info"
                        });
                        return;
                    }
                }
                else { //研究生
                    if (EXPORT_TYPE == "A" || EXPORT_TYPE == "B" || EXPORT_TYPE == "C" || EXPORT_TYPE == "G") {
                        easyAlert.timeShow({
                            "content": "选择的学生类型与导出类型冲突！",
                            "duration": 3,
                            "type": "info"
                        });
                        return;
                    }
                }
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=region_schoolarapply' + GetSearchUrlParam());
            });
            //【审核流程跟踪】
            //------------------审核流程跟踪 开始------------------------------------------
            wfklog = WfkLog.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "wfklogModal"//弹出层的id，不写则默认wfklogModal，必填
                },
                control: {
                    "content": "#content", //必填
                    "btnId": "#history", //触发弹出层的按钮的id，必填
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
        //获得查询条件中的参数
        function GetSearchUrlParam() {
            var PROJECT_YEAR = DropDownUtils.getDropDownValue("search-PROJECT_YEAR");
            var XY = DropDownUtils.getDropDownValue("search-XY");
            var ZY = DropDownUtils.getDropDownValue("search-ZY");
            var GRADE = DropDownUtils.getDropDownValue("search-GRADE");
            var CLASS_CODE = DropDownUtils.getDropDownValue("search-CLASS_CODE");
            var STU_NUMBER = $("#search-STU_NUMBER").val();
            var STU_NAME = $("#search-STU_NAME").val();
            var STU_TYPE = DropDownUtils.getDropDownValue("search-STU_TYPE");
            var EXPORT_TYPE = DropDownUtils.getDropDownValue("search-EXPORT_TYPE");

            var strq = "";
            if (PROJECT_YEAR)
                strq += "&PROJECT_YEAR=" + PROJECT_YEAR;
            if (XY)
                strq += "&XY=" + XY;
            if (ZY)
                strq += "&ZY=" + ZY;
            if (GRADE)
                strq += "&GRADE=" + GRADE;
            if (CLASS_CODE)
                strq += "&CLASS_CODE=" + CLASS_CODE;
            if (STU_NUMBER)
                strq += "&STU_NUMBER=" + OptimizeUtils.FormatParamter(STU_NUMBER);
            if (STU_NAME)
                strq += "&STU_NAME=" + OptimizeUtils.FormatParamter(STU_NAME);
            if (STU_TYPE)
                strq += "&STU_TYPE=" + STU_TYPE;
            if (EXPORT_TYPE)
                strq += "&EXPORT_TYPE=" + EXPORT_TYPE;
            return strq;
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:content>