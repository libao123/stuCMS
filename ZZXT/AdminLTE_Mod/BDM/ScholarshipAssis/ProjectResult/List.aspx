<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectResult.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>统计查询</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>奖助管理</li>
				<li class="active">统计查询</li>
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
                <iframe id="editFrame" name="editFrame" frameborder="0" src="" style="width: 100%; min-height: 250px; display:block;"></iframe>
            </div>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 下载WORD界面 开始 -->
    <div class="modal fade" id="downloadWordModal">
        <div class="modal-dialog">
            <div class="modal-body">
                <iframe id="wordFrame" name="wordFrame" frameborder="0" src="" style="width: 100%; min-height: 250px; display:block;"></iframe>
            </div>
        </div>
    </div>
    <div class="modal fade" id="downloadWordModal_Sub">
        <div class="modal-dialog">
            <div class="modal-body">

                    <iframe id="wordFrame_Sub" name="wordFrame_Sub" frameborder="0" src=""style="width: 100%; min-height: 250px; display:block;"></iframe>

            </div>
        </div>
    </div>
    <!-- 下载WORD界面 结束-->
    <!-- 上报文下载界面 开始 -->
    <div class="modal fade" id="report_downloadModal">
        <div class="modal-dialog">
            <form action="#" method="post" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">上报文下载</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <a id="aQ" onclick="ReportDownLoad('aQ');" style="margin-left: 20px;" href="#">区级上报文</a>
                    <br />
                    <br />
                    <a id="xG" onclick="ReportDownLoad('xG');" style="margin-left: 20px;" href="#">校级公示文</a>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 上报文下载界面 结束-->
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
                    url: "/AdminLTE_Mod/BDM/ScholarshipAssis/ProjectApply/List.aspx?optype=getlist&page_from=result",
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
					    { "data": "PROJECT_CLASS", "pre": "项目级别", "col": 2, "type": "select", "ddl_name": "ddl_jz_project_class" },
                        { "data": "PROJECT_TYPE", "pre": "申请表格类型", "col": 3, "type": "select", "ddl_name": "ddl_jz_project_type" },
                        { "data": "PROJECT_SEQ_NO", "pre": "项目名称", "col": 4, "type": "select", "ddl_name": "ddl_jz_project_name_end" },
                         { "data": "XY", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 3, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 4, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 5, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 6, "type": "input" },
                        { "data": "STU_TYPE", "pre": "学生类型", "col": 4, "type": "select", "ddl_name": "ddl_ua_stu_type" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                //                { type: "userDefined", id: "print", title: "打印/预览", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                {type: "userDefined", id: "download", title: "申请表下载", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "report_download", title: "上报文下载", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "export", title: "导出奖助数据", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "export_good", title: "导出三好学生标兵推荐数据", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "history", title: "审批流程跟踪", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
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
            var _report_downloadModal = $("#report_downloadModal");
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
            //【打印/预览】
            _content.on('click', "#print", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        var file = AjaxUtils.getResponseText("FileList.aspx?optype=getprintfile&seq_no=" + data.SEQ_NO);
                        JzCom.ByJzTypeToPrint(data.PROJECT_TYPE, data.OID, file);
                    }
                }
            });
            //【申请表下载】
            _content.on('click', "#download", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        var url = "/Word/ExportWord.aspx";
                        //COUNTRY_B：国家奖学金（本科）：表11+1,11+2
                        if (data.PROJECT_TYPE == "COUNTRY_B") {
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                            $("#wordFrame_Sub").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project_sub&id=' + data.OID));
                        }
                        //COUNTRY_ENCOUR：国家励志奖学金：表12
                        //AREA_GOV：自治区人民政府奖学金：表15
                        else if (data.PROJECT_TYPE == "COUNTRY_ENCOUR" || data.PROJECT_TYPE == "AREA_GOV") {
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                        }
                        //COUNTRY_FIRST：国家一等助学金：表13
                        //COUNTRY_SECOND：国家二等助学金：表14
                        //SOCIETY_OFFER：社会捐资类奖学金：表16
                        else if (data.PROJECT_TYPE == "COUNTRY_FIRST" || data.PROJECT_TYPE == "COUNTRY_SECOND" || data.PROJECT_TYPE == "SOCIETY_OFFER") {
                            //弹出编辑页
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                        }
                        //SCHOOL_GOOD：三好学生：表17+1
                        //SCHOOL_MODEL：三好学生标兵：表17+1,17+2（与11+2一致）,17+3
                        else if (data.PROJECT_TYPE == "SCHOOL_GOOD" || data.PROJECT_TYPE == "SCHOOL_MODEL") {
                            //弹出编辑页
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                            if (data.PROJECT_TYPE == "SCHOOL_MODEL") {
                                //弹出编辑页
                                $("#wordFrame_Sub").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project_sub&id=' + data.OID));
                            }
                        }
                        //SCHOOL_SINGLE：单项奖学金：表18
                        else if (data.PROJECT_TYPE == "SCHOOL_SINGLE") {
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                        }
                        //COUNTRY_YP：国家奖学金（研究生/博士）：表19+1,19+2
                        else if (data.PROJECT_TYPE == "COUNTRY_YP") {
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                            if (data.PROJECT_TYPE == "COUNTRY_YP") {
                                //弹出编辑页
                                $("#wordFrame_Sub").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project_sub&id=' + data.OID));
                            }
                        }
                        //COUNTRY_STUDY：国家学业奖学金：表20
                        //SCHOOL_NOTCOUNTRY：非国家级奖学金：表21
                        //SOCIETY_NOCOUNTRY：非国家级奖学金：表21
                        else if (data.PROJECT_TYPE == "COUNTRY_STUDY"
                        || data.PROJECT_TYPE == "SCHOOL_NOTCOUNTRY" || data.PROJECT_TYPE == "SOCIETY_NOCOUNTRY") {
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                        }
                    }
                }
            });
            //【上报文下载】
            _content.on('click', "#report_download", function () {
                //校验必选（学年、项目名称）
                var PROJECT_YEAR = DropDownUtils.getDropDownValue("search-PROJECT_YEAR");
                var PROJECT_SEQ_NO = DropDownUtils.getDropDownValue("search-PROJECT_SEQ_NO");
                if (PROJECT_YEAR.length == 0 || PROJECT_SEQ_NO.length == 0) {
                    easyAlert.timeShow({
                        "content": "查询条件：学年、项目名称不能为空！",
                        "duration": 3,
                        "type": "info"
                    });
                    return;
                }
                _report_downloadModal.modal();
            });
            //【导出奖助数据】
            _content.on('click', "#export", function () {
                //校验必选（学年、项目名称、学院、学生类型）
                var PROJECT_YEAR = DropDownUtils.getDropDownValue("search-PROJECT_YEAR");
                var PROJECT_SEQ_NO = DropDownUtils.getDropDownValue("search-PROJECT_SEQ_NO");
                var PROJECT_TYPE = DropDownUtils.getDropDownValue("search-PROJECT_TYPE");
                var XY = DropDownUtils.getDropDownValue("search-XY");
                var STU_TYPE = DropDownUtils.getDropDownValue("search-STU_TYPE");
                if ("<%=IsSchool %>" == "true") {//校级开放权限
                    if (PROJECT_YEAR.length == 0 || STU_TYPE.length == 0) {
                        easyAlert.timeShow({
                            "content": "查询条件：学年、学生类型不能为空！",
                            "duration": 3,
                            "type": "info"
                        });
                        return;
                    }
                } else if ("<%=IsXueYuan %>" == "true") {//学院限制：学年、学院、申请表格类型、学生类型
                    if (PROJECT_YEAR.length == 0 || XY.length == 0 || STU_TYPE.length == 0 || PROJECT_TYPE.length == 0) {
                        easyAlert.timeShow({
                            "content": "查询条件：学年、申请表格类型、学院、学生类型不能为空！",
                            "duration": 3,
                            "type": "info"
                        });
                        return;
                    }
                } else {
                    if (PROJECT_YEAR.length == 0 || PROJECT_SEQ_NO.length == 0 || XY.length == 0 || STU_TYPE.length == 0) {
                        easyAlert.timeShow({
                            "content": "查询条件：学年、项目名称、学院、学生类型不能为空！",
                            "duration": 3,
                            "type": "info"
                        });
                        return;
                    }
                }
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=projectlist' + GetSearchUrlParam(""));
            });
            //【导出三好学生标兵推荐数据】
            _content.on('click', "#export_good", function () {
                //校验必选（学年、项目名称、学院、学生类型）
                var PROJECT_YEAR = DropDownUtils.getDropDownValue("search-PROJECT_YEAR");
                var PROJECT_SEQ_NO = DropDownUtils.getDropDownValue("search-PROJECT_SEQ_NO");
                var XY = DropDownUtils.getDropDownValue("search-XY");
                if ("<%=IsSchool %>" == "true") {//校级开放权限
                    if (PROJECT_YEAR.length == 0 || PROJECT_SEQ_NO.length == 0) {
                        easyAlert.timeShow({
                            "content": "查询条件：学年、项目名称不能为空！",
                            "duration": 3,
                            "type": "info"
                        });
                        return;
                    }
                }
                else {
                    if (PROJECT_YEAR.length == 0 || PROJECT_SEQ_NO.length == 0 || XY.length == 0) {
                        easyAlert.timeShow({
                            "content": "查询条件：学年、项目名称、学院不能为空！",
                            "duration": 3,
                            "type": "info"
                        });
                        return;
                    }
                }
                //判断查询项是否符合 三好学生标兵 项目标准
                var result = AjaxUtils.getResponseText("List.aspx?optype=chkquery&PROJECT_SEQ_NO=" + PROJECT_SEQ_NO);
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": "您选择的项目名称不属于三好学生标兵，请确认！",
                        "duration": 3,
                        "type": "info"
                    });
                    return;
                }
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=projectlist_goodmodel' + GetSearchUrlParam("projectlist_goodmodel"));
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
        function GetSearchUrlParam(optype) {
            var PROJECT_YEAR = DropDownUtils.getDropDownValue("search-PROJECT_YEAR");
            var PROJECT_CLASS = DropDownUtils.getDropDownValue("search-PROJECT_CLASS");
            var PROJECT_TYPE = DropDownUtils.getDropDownValue("search-PROJECT_TYPE");
            var PROJECT_SEQ_NO = DropDownUtils.getDropDownValue("search-PROJECT_SEQ_NO");
            var XY = DropDownUtils.getDropDownValue("search-XY");
            var ZY = DropDownUtils.getDropDownValue("search-ZY");
            var GRADE = DropDownUtils.getDropDownValue("search-GRADE");
            var CLASS_CODE = DropDownUtils.getDropDownValue("search-CLASS_CODE");
            var STU_NUMBER = $("#search-STU_NUMBER").val();
            var STU_NAME = $("#search-STU_NAME").val();
            var STU_TYPE = DropDownUtils.getDropDownValue("search-STU_TYPE");

            var strq = "";
            if (PROJECT_YEAR)
                strq += "&PROJECT_YEAR=" + PROJECT_YEAR;
            if (optype == "projectlist_goodmodel") {
                //ZZ 20171026 修改：去掉界面的限制条件，在后台直接加限制。导出三好学生标兵推荐数据 申请表格类型必选选择为“三好学生标兵”
                strq += "&PROJECT_TYPE=SCHOOL_MODEL";
            }
            else {
                if (PROJECT_CLASS)
                    strq += "&PROJECT_CLASS=" + PROJECT_CLASS;
                if (PROJECT_TYPE)
                    strq += "&PROJECT_TYPE=" + PROJECT_TYPE;
            }

            if (PROJECT_SEQ_NO)
                strq += "&PROJECT_SEQ_NO=" + PROJECT_SEQ_NO;
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
            return strq;
        }

        function ReportDownLoad(flag) {
            if (flag == 'aQ') { //区级上报文：只有校级管理员可以操作
                if ("<%=user.User_Role %>" == "X") {
                    window.open('/Word/ExportWord.aspx?optype=project_passlist' + GetSearchUrlParam(""));
                }
                else {
                    easyAlert.timeShow({
                        "content": "您没有权限操作！",
                        "duration": 3,
                        "type": "info"
                    });
                    return;
                }
            }
            if (flag == 'xG') { //校级公示文：院级校级都可以操作
                if ("<%=user.User_Role %>" == "X" || "<%=user.User_Role %>" == "Y") {
                    window.open('/Word/ExportWord.aspx?optype=project_passlist_new' + GetSearchUrlParam(""));
                }
                else {
                    easyAlert.timeShow({
                        "content": "您没有权限操作！",
                        "duration": 3,
                        "type": "info"
                    });
                    return;
                }
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
