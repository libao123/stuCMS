<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="ResultList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Loan.ProjectCheck.ResultList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList;
        var _form_edit;
        $(function () {
            adaptionHeight();
            //编辑页控制定义
            _form_edit = PageValueControl.init("form_edit");

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
			<h1>查询导出</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>贷款管理</li>
				<li class="active">查询导出</li>
			</ol>
		</section>
            <section class="content" id="content">
		        <div class="row">
			        <div class="col-xs-12">
				        <div id="div_Per" style=" font-size: x-large; color:Red;"></div>
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
    <div class="modal" id="tableModal">
        <div class="modal-dialog modal-dw70">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    核对信息</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="CHECK_OID" name="CHECK_OID" value="" />
                <input type="hidden" id="hidApplySeqNo" name="hidApplySeqNo" value="" />
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        贷款名称
                    </label>
                    <div class="col-sm-10">
                        <input name="LOAN_NAME" id="LOAN_NAME" type="text" class="form-control" placeholder="项目名称" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        贷款类型</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="LOAN_TYPE" id="LOAN_TYPE" d_value='' ddl_name='ddl_insur_type'
                            show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        贷款学年</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="LOAN_YEAR" id="LOAN_YEAR" d_value='' ddl_name='ddl_year_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学号</label>
                    <div class="col-sm-4">
                        <input name="STU_NUMBER" id="STU_NUMBER" type="text" class="form-control" placeholder="学号" />
                    </div>

                    <label class="col-sm-2 control-label">
                        姓名</label>
                    <div class="col-sm-4">
                        <input name="STU_NAME" id="STU_NAME" type="text" class="form-control" placeholder="姓名" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        院系</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="XY" id="XY" d_value='' ddl_name='ddl_department'
                            show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        专业</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="ZY" id="ZY" d_value='' ddl_name='ddl_zy' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        年级</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="GRADE" id="GRADE" d_value='' ddl_name='ddl_grade'
                            show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        班级</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="CLASS_CODE" id="CLASS_CODE" d_value='' ddl_name='ddl_class'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        身份证号</label>
                    <div class="col-sm-4">
                        <input name="STU_IDNO" id="STU_IDNO" type="text" class="form-control" placeholder="身份证号" />
                    </div>

                    <label class="col-sm-2 control-label">
                        手机号</label>
                    <div class="col-sm-4">
                        <input name="STU_PHONE" id="STU_PHONE" type="text" class="form-control" placeholder="手机号" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        入学时间</label>
                    <div class="col-sm-4">
                        <input name="STU_ENTERTIME" id="STU_ENTERTIME" type="text" class="form-control" placeholder="入学时间" />
                    </div>

                    <label class="col-sm-2 control-label">
                        转入高校账户金额</label>
                    <div class="col-sm-4">
                        <input name="TOSCHOOL_ACCOUNT" id="TOSCHOOL_ACCOUNT" type="text" class="form-control"
                            placeholder="转入高校账户金额" />
                    </div>
                </div>
                <!--<div class="form-group">
                    <label class="col-sm-4 control-label">
                        代扣代收费</label>
                    <div class="col-sm-8">
                        <input name="WITHHOLD_WH_ACCOUNT" id="WITHHOLD_WH_ACCOUNT" type="text" class="form-control"
                            placeholder="代扣代收费" />
                    </div>
                </div>-->
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        代扣学费</label>
                    <div class="col-sm-4">
                        <input name="WITHHOLD_SCHOOL_ACCOUNT" id="WITHHOLD_SCHOOL_ACCOUNT" type="text" class="form-control"
                            placeholder="代扣学费" />
                    </div>

                    <label class="col-sm-2 control-label">
                        代扣住宿费</label>
                    <div class="col-sm-4">
                        <input name="WITHHOLD_STAY_ACCOUNT" id="WITHHOLD_STAY_ACCOUNT" type="text" class="form-control"
                            placeholder="代扣代收费" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        代扣体检费</label>
                    <div class="col-sm-4">
                        <input name="WITHHOLD_EXAM_ACCOUNT" id="WITHHOLD_EXAM_ACCOUNT" type="text" class="form-control"
                            placeholder="代扣体检费" />
                    </div>

                    <label class="col-sm-2 control-label">
                        代扣军训服装费</label>
                    <div class="col-sm-4">
                        <input name="WITHHOLD_TRAINCLOTHES_ACCOUNT" id="WITHHOLD_TRAINCLOTHES_ACCOUNT" type="text"
                            class="form-control" placeholder="代扣军训服装费" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        代扣医保费</label>
                    <div class="col-sm-4">
                        <input name="WITHHOLD_HEALTH_ACCOUNT" id="WITHHOLD_HEALTH_ACCOUNT" type="text" class="form-control"
                            placeholder="代扣医保费" />
                    </div>

                    <label class="col-sm-2 control-label">
                        代扣空调费</label>
                    <div class="col-sm-4">
                        <input name="WITHHOLD_AIR_ACCOUNT" id="WITHHOLD_AIR_ACCOUNT" type="text" class="form-control"
                            placeholder="代扣空调费" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        余额</label>
                    <div class="col-sm-4">
                        <input name="WITHHOLD_REMAIN_ACCOUNT" id="WITHHOLD_REMAIN_ACCOUNT" type="text" class="form-control"
                            placeholder="余额" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        核对前银行卡号</label>
                    <div class="col-sm-4">
                        <input name="OLD_BANKCODE" id="OLD_BANKCODE" type="text" class="form-control" maxlength="50"
                            placeholder="核对前银行卡号" />
                    </div>

                    <label class="col-sm-2 control-label">
                        核对后银行卡号</label>
                    <div class="col-sm-4">
                        <input name="NEW_BANKCODE" id="NEW_BANKCODE" type="text" class="form-control" maxlength="50"
                            placeholder="核对后银行卡号" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        备注</label>
                    <div class="col-sm-10">
                        <textarea class="form-control" id="REMARK" name="REMARK" rows="3" placeholder="备注"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
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
				    { "data": "OID",
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
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "CheckList.aspx?optype=getlist&from_page=check_check",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "统计查询导出",
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
					    { "data": "LOAN_TYPE", "pre": "贷款类型", "col": 2, "type": "select", "ddl_name": "ddl_loan_type" },
					    { "data": "LOAN_YEAR", "pre": "贷款学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
                        { "data": "LOAN_SEQ_NO", "pre": "贷款名称", "col": 4, "type": "select", "ddl_name": "ddl_loan_project" },
                        { "data": "XY", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 3, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 4, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 5, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 6, "type": "input" },
                        { "data": "CHECK_STEP", "pre": "核对阶段", "col": 4, "type": "select", "ddl_name": "ddl_apply_check_step" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                <%if (IsShowBtn){ %>
                { type: "userDefined", id: "export_dif", title: "导出核对差异数据", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }, //20171016 ZZ 增加：新增需求
                //{type: "userDefined", id: "download", title: "下载参保导入模板", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                <%} %>
                { type: "userDefined", id: "export", title: "导出核对数据", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
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
            var _tableModal = $("#tableModal");
            var _btns = {
                reload: '.btn-reload',
                search: '.btn-search'
            };
            //-----------主列表按钮---------------
            //【刷新】
            _content.on('click', _btns.search, function () {
                GetPerInfo();
            });
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //弹出核对信息界面
                        _form_edit.setFormData(data);
                        $("#CHECK_OID").val(data.CHECK_OID);
                        //获得学生基础信息
                        var studata = AjaxUtils.getResponseText("/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_stuinfo&stu_num=" + data.STU_NUMBER);
                        if (studata) {
                            var studata_json = eval("(" + studata + ")");
                            $("#STU_ENTERTIME").val(studata_json.ENTERTIME);
                            $("#STU_PHONE").val(studata_json.MOBILENUM);
                            $("#STU_IDNO").val(studata_json.IDCARDNO);
                            //$("#STU_BANDKCODE").val(studata_json.BANKCODE);
                        }
                        //不可编辑
                        _form_edit.disableAll();
                        _tableModal.modal();
                    }
                }
            });
            //【导出数据】
            _content.on('click', "#export", function () {
                //查询条件满足才可以导出
                var LOAN_TYPE = DropDownUtils.getDropDownValue("search-LOAN_TYPE");
                var LOAN_YEAR = DropDownUtils.getDropDownValue("search-LOAN_YEAR");
                var LOAN_SEQ_NO = DropDownUtils.getDropDownValue("search-LOAN_SEQ_NO");
                var XY = DropDownUtils.getDropDownValue("search-XY");
                if ("<%=IsSchool %>" == "true")//校级权限大
                {
                    if (!LOAN_TYPE || !LOAN_YEAR || !LOAN_SEQ_NO) {
                        easyAlert.timeShow({
                            "content": "贷款类型、贷款学年、贷款名称，三者筛选条件不能为空！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
                else {
                    if (!LOAN_TYPE || !LOAN_YEAR || !LOAN_SEQ_NO || !XY) {
                        easyAlert.timeShow({
                            "content": "贷款类型、贷款学年、贷款名称、学院，四者筛选条件不能为空！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
                var strq = GetUrlParam();
                var result = AjaxUtils.getResponseText("ResultList.aspx?optype=iscan_export" + strq);
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=loan_pro_checklist' + strq);
            });
            //【导出核对差异数据】
            _content.on('click', "#export_dif", function () {
                //查询条件满足才可以导出
                var LOAN_TYPE = DropDownUtils.getDropDownValue("search-LOAN_TYPE");
                var LOAN_YEAR = DropDownUtils.getDropDownValue("search-LOAN_YEAR");
                var LOAN_SEQ_NO = DropDownUtils.getDropDownValue("search-LOAN_SEQ_NO");
                var XY = DropDownUtils.getDropDownValue("search-XY");
                if ("<%=IsSchool %>" == "true")//校级权限大
                {
                    if (!LOAN_TYPE || !LOAN_YEAR || !LOAN_SEQ_NO) {
                        easyAlert.timeShow({
                            "content": "贷款类型、贷款学年、贷款名称，三者筛选条件不能为空！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
                else {
                    if (!LOAN_TYPE || !LOAN_YEAR || !LOAN_SEQ_NO || !XY) {
                        easyAlert.timeShow({
                            "content": "贷款类型、贷款学年、贷款名称、学院，四者筛选条件不能为空！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
                var strq = GetUrlParam();
                var result = AjaxUtils.getResponseText("ResultList.aspx?optype=iscan_export" + strq);
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=loan_pro_checklist_dif' + strq);
            });
            //【下载参保导入模板】
            _content.on('click', "#download", function () {
                //查询条件满足才可以导出
                var LOAN_TYPE = DropDownUtils.getDropDownValue("search-LOAN_TYPE");
                var LOAN_YEAR = DropDownUtils.getDropDownValue("search-LOAN_YEAR");
                var LOAN_SEQ_NO = DropDownUtils.getDropDownValue("search-LOAN_SEQ_NO");
                if (!LOAN_TYPE || !LOAN_YEAR || !LOAN_SEQ_NO) {
                    easyAlert.timeShow({
                        "content": "贷款类型、贷款学年、贷款名称，三者筛选条件不能为空！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                var strq = GetUrlParam();
                var result = AjaxUtils.getResponseText("ResultList.aspx?optype=iscan_export" + strq);
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=insur_pro_resultlist' + strq);
            });
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("LOAN_TYPE");
            DropDownUtils.initDropDown("LOAN_YEAR");
            DropDownUtils.initDropDown("XY");
            DropDownUtils.initDropDown("ZY");
            DropDownUtils.initDropDown("GRADE");
            DropDownUtils.initDropDown("CLASS_CODE");
            //获得百分比显示信息
            GetPerInfo();
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
        function GetUrlParam() {
            var LOAN_TYPE = DropDownUtils.getDropDownValue("search-LOAN_TYPE");
            var LOAN_YEAR = DropDownUtils.getDropDownValue("search-LOAN_YEAR");
            var LOAN_SEQ_NO = DropDownUtils.getDropDownValue("search-LOAN_SEQ_NO");
            var XY = DropDownUtils.getDropDownValue("search-XY");
            var ZY = DropDownUtils.getDropDownValue("search-ZY");
            var GRADE = DropDownUtils.getDropDownValue("search-GRADE");
            var CLASS_CODE = DropDownUtils.getDropDownValue("search-CLASS_CODE");
            var STU_NUMBER = $("#search-STU_NUMBER").val();
            var STU_NAME = $("#search-STU_NAME").val();
            var CHECK_STEP = DropDownUtils.getDropDownValue("search-CHECK_STEP");

            var strq = "";
            if (LOAN_TYPE)
                strq += "&LOAN_TYPE=" + LOAN_TYPE;
            if (LOAN_YEAR)
                strq += "&LOAN_YEAR=" + LOAN_YEAR;
            if (LOAN_SEQ_NO)
                strq += "&LOAN_SEQ_NO=" + LOAN_SEQ_NO;
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
            if (CHECK_STEP)
                strq += "&CHECK_STEP=" + CHECK_STEP;
            return strq;
        }

        //获得百分比显示信息
        function GetPerInfo() {
            var strq = GetUrlParam();
            var result = AjaxUtils.getResponseText("ResultList.aspx?optype=getper&" + strq);
            if (result.length > 0) {
                $("#div_Per").html(result);
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
