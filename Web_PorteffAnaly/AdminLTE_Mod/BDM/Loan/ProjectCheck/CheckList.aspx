<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="CheckList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Loan.ProjectCheck.CheckList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList;
        var _form_edit;
        var _form_check;
        $(function () {
            adaptionHeight();
            //编辑页控制定义
            _form_edit = PageValueControl.init("form_edit");
            _form_check = PageValueControl.init("form_check");

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
    <!-- 编辑界面 开始 -->
    <div class="modal" id="tableModal">
        <div class="modal-dialog modal-dw70">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    核对信息<label style="color: Red;">（注：如信息无误，直接点“确认提交”）</label></h4>
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
                        <select class="form-control" name="LOAN_TYPE" id="LOAN_TYPE" d_value='' ddl_name='ddl_loan_type'
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
                <%--<div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        代扣代收费</label>
                    <div class="col-sm-8">
                        <input name="WITHHOLD_WH_ACCOUNT" id="WITHHOLD_WH_ACCOUNT" type="text" class="form-control"
                            placeholder="代扣代收费" />
                    </div>
                </div>--%>
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
                            placeholder="如核对前信息无误无须填写" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">备注</label>
                    <div class="col-sm-10">
                        <textarea class="form-control" id="REMARK" name="REMARK" rows="3" placeholder="如有学生在放款前后发生学籍异动，请辅导员代核并写明异动具体情况，如休学、退学、保留学籍等"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnCheck">如信息有误，点击此按钮</button>
                <button type="button" class="btn btn-primary btn-save" id="btnSave">确认提交</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 核对编辑界面 开始 -->
    <div class="modal" id="tableModal_Check">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_check" name="form_check" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    录入核对后信息<label style="color: Red; font-size: 12px;">（如学生基本信息有误，需到个人中心--信息维护栏目进行修改）</label></h4>
            </div>
            <div class="modal-body">

                <div class="box-header with-border">
                    <h3 class="box-title">银行卡号</h3>
                </div>
                <div class="form-horizontal box-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            新银行卡号</label>
                        <div class="col-sm-4">
                            <input name="NEW_BANKCODE_CHECK" id="NEW_BANKCODE_CHECK" type="text" class="form-control"
                                placeholder="新银行卡号" maxlength="50" />
                        </div>

                        <label class="col-sm-2 control-label">
                            确认银行卡号</label>
                        <div class="col-sm-4">
                            <input name="NEW_BANKCODE_CHECK_2" id="NEW_BANKCODE_CHECK_2" type="text" class="form-control"
                                placeholder="确认银行卡号" maxlength="50" />
                        </div>
                    </div>
                </div>
              
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnCheckInfo">确认</button>
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
                    { "data": "F_CHECK_TIME", "head": "辅导员核对时间", "type": "td-keep"  },
                    { "data": "Y_CHECK_TIME", "head": "学院核对时间", "type": "td-keep"  },
                    { "data": "CHECK_START", "head": "核对开始时间", "type": "td-keep"  },
                    { "data": "CHECK_END", "head": "核对结束时间", "type": "td-keep"  },
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
                    tableTitle: "确认核对信息",
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
                            }else if (aData.CHECK_STEP == "2") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "primary",
                                        "msg": "辅导员已核对"
                                    });
                            }else if (aData.CHECK_STEP == "3") {
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
                        { "data": "CHECK_STEP", "pre": "核对阶段", "col": 4, "type": "select", "ddl_name": "ddl_apply_check_step" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                <%if(bIsShowBtnCheck) {%>
                { type: "userDefined", id: "check", title: "核对信息", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                <%} %>
                <%if(bIsShowBtnMulitCheck) {%>
                { type: "userDefined", id: "multi_check", title: "批量核对", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                <%} %>
                { type: "userDefined", id: "view", title: "查阅", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} }
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
            var _tableModal_Check = $("#tableModal_Check");
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
                        //弹出核对信息界面
                        _form_edit.setFormData(data);
                        if (data.CHECK_OID)
                            $("#CHECK_OID").val(data.CHECK_OID);
                        else
                            $("#CHECK_OID").val("");
                        $("#hidApplySeqNo").val(data.SEQ_NO);
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
                        //隐藏按钮
                        $("#btnCheck").hide();
                        $("#btnSave").hide();
                        _tableModal.modal();
                    }
                }
            });
            //【核对信息】
            _content.on('click', "#check", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //判断是否可以进行核对
                        var result = AjaxUtils.getResponseText("CheckList.aspx?optype=iscan_check&id=" + data.OID);
                        if (result.length > 0) {
                            easyAlert.timeShow({
                                "content": result,
                                "duration": 4,
                                "type": "danger"
                            });
                            return;
                        }
                        //弹出核对信息界面
                        _form_edit.setFormData(data);
                        if (data.CHECK_OID)
                            $("#CHECK_OID").val(data.CHECK_OID);
                        else
                            $("#CHECK_OID").val("");
                        $("#hidApplySeqNo").val(data.SEQ_NO);
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
                        //备注可以编辑
                        //ZZ 20171122 修改：备注只有在辅导员看的时候可以编辑
                        if ("<%=user.User_Role %>" == "F") {
                            $("#REMARK").attr("disabled", false);
                        }
                        //ZZ 20171213 修改：手机号、身份证号、银行卡号 在学生或者辅导员看的时候 可以编辑
                        if ("<%=user.User_Role %>" == "F" || "<%=user.User_Role %>" == "S") {
                            $("#STU_PHONE").attr("disabled", false);
                            //$("#STU_BANDKCODE").attr("disabled", false);
                            $("#STU_IDNO").attr("disabled", false);
                        }
                        //显示按钮
                        $("#btnCheck").show();
                        $("#btnSave").show();
                        _tableModal.modal();
                    }
                }
            });
            //【批量核对】
            _content.on('click', "#multi_check", function () {
                MultiCheck();
            });
            //-----------编辑界面 按钮---------------
            //【确认核对信息】
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });
            //【如信息有误，点击此按钮】
            _tableModal.on('click', "#btnCheck", function () {
                _form_check.reset();
                if ($("#NEW_BANKCODE").val().length > 0)
                    $("#NEW_BANKCODE_CHECK").val($("#NEW_BANKCODE").val());
                _tableModal_Check.modal();
            });
            //-----------核对信息编辑界面 按钮---------------
            //【确认】
            _tableModal_Check.on('click', "#btnCheckInfo", function () {
                CheckInfo();
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
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //输入校验
            LimitUtils.onlyNumAlpha("STU_IDNO"); //身份证号
            LimitUtils.onlyNum("STU_PHONE"); //手机号
            //LimitUtils.onlyNum("STU_BANDKCODE"); //银行卡号

            //输入校验
            LimitUtils.onlyNum("NEW_BANKCODE_CHECK"); //代码限制只能录入数字
            LimitUtils.onlyNum("NEW_BANKCODE_CHECK_2"); //代码限制只能录入数字
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        function CheckInfo() {
            //校验数据
            var NEW_BANKCODE_CHECK = $("#NEW_BANKCODE_CHECK").val();
            var NEW_BANKCODE_CHECK_2 = $("#NEW_BANKCODE_CHECK_2").val();
            //银行卡号
            if (NEW_BANKCODE_CHECK.length > 0) {
                if (NEW_BANKCODE_CHECK_2.length == 0) {
                    easyAlert.timeShow({
                        "content": "确认银行卡号必填！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                if (NEW_BANKCODE_CHECK != NEW_BANKCODE_CHECK_2) {
                    easyAlert.timeShow({
                        "content": "输入的两次银行卡号必须一致！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            }
            //反填数据
            if (NEW_BANKCODE_CHECK.length > 0)
                $("#NEW_BANKCODE").val(NEW_BANKCODE_CHECK);
            $("#tableModal_Check").modal('hide');
        }
        //保存数据
        function SaveData() {
            //校验核对前、核对后的数据，必须要有一个有数据
            var OLD_BANKCODE = $("#OLD_BANKCODE").val();
            var NEW_BANKCODE = $("#NEW_BANKCODE").val();
            if (OLD_BANKCODE.length == 0 && NEW_BANKCODE.length == 0) {
                easyAlert.timeShow({
                    "content": "核对前、核对后的银行卡号不能都为空！",
                    "duration": 2,
                    "type": "info"
                });
                return;
            }
            //弹出遮罩层
            //$('.maskBg').show();
            //ZENG.msgbox.show("提交核对信息中，请稍后...", 6);
            var layInx = layer.load(2, {
              content: "提交核对信息中，请稍后...",
              shade: [0.3,'#000'], //0.1透明度的白色背景
              time: 6000
            });
            //取消不可编辑
            _form_edit.cancel_disableAll();
            $.post(OptimizeUtils.FormatUrl("CheckList.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length == 0) {
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    layer.close(layInx);
                    $("#tableModal").modal('hide');
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload(); //刷新列表
                    return;
                }
                else {
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    layer.close(layInx);
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            });
        }
        //批量核对
        function MultiCheck() {
            if ('<%=user.User_Role %>' != 'X') {
                if (strOids.length == 0) {
                    easyAlert.timeShow({
                        "content": "请选择数据项！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                if ('<%=user.User_Role %>' == 'F')//辅导员需要选择核对阶段
                {
                    var CHECK_STEP = $("#search-CHECK_STEP").val();
                    if (CHECK_STEP.length == 0) {
                        easyAlert.timeShow({
                            "content": "请选择确认核对的阶段再进行核对！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
            }
            //查询栏
            var urlParam = GetSearchUrlParam();
            //列表勾选
            var strOids = "";
            var datas = mainList.selection();
            if (datas) {
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i]) {
                        if (datas[i].OID) {
                            strOids += datas[i].OID + ",";
                        }
                    }
                }
            }
            var postData = { "SELECT_OID": strOids };
            var url = "CheckList.aspx?optype=multi_check" + urlParam;
            //$('.maskBg').show();
            //ZENG.msgbox.show("批量核对中，请稍后...", 6);
            var layInx = layer.load(2, {
              content: "批量核对中，请稍后...",
              shade: [0.3,'#000'], //0.1透明度的白色背景
              time: 6000
            });
            $.ajax({
                cache: false,
                type: "POST",
                url: url,
                async: false,
                data: postData,
                success: function (result) {
                    if (result) {
                        //$('.maskBg').hide();
                        //ZENG.msgbox.hide();
                        layer.close(layInx);
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

        //获得查询条件中的参数
        function GetSearchUrlParam() {
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
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
