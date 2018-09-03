<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="List.aspx.cs" 
    Inherits="PorteffAnaly.Web.AdminLTE_QZ.JobProof.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _form_edit;
        var mainList;
        var detailList;
        window.onload = function () {
            adaptionHeight();

            _form_edit = PageValueControl.init("form_edit");
            LimitUtils.onlyNum("BANK_CARD_NO");
            LimitUtils.onlyNum("IDCARDNO");
            LimitUtils.onlyNum("TELEPHONE");
            LimitUtils.onlyNumAndPoint("WORK_HOURS");
            loadTableList();
            loadDetailList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();

            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-COLLEGE", "search-MAJOR", "", "search-CLASS");
            SelectUtils.XY_ZY_Grade_ClassCodeChange("COLLEGE", "MAJOR", "GRADE", "");
            
            //时间控件
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });

            $("#btnSave").click(function () {
                SaveData();
            });

            $("#btnSubmit").click(function () {
                easyConfirm.locationShow({
                    "type": "warn",
                    "title": "提交",
                    "content": "确定要提交数据？",
                    "callback": SubmitData
                });
            });

            $("#btnDetailSave").click(function () {
                SaveDetail();
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>劳酬凭据</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>岗位劳酬管理</li>
				<li class="active">劳酬凭据</li>
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

    <!-- 编辑界面 开始-->
    <div class="modal" id="tableModal">
        <div class="modal-dialog" style="width: 70%;">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
                onsubmit="return false;">
                <input type="hidden" id="OID" name="OID" />
                <input type="hidden" id="SEQ_NO" name="SEQ_NO" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">填写劳酬凭据</h4>
                </div>
                <div class="tab-content row">
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            劳动所属单位<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="EMPLOYER" id="EMPLOYER" class="form-control" ddl_name="ddl_all_department"
                                d_value="" show_type="t" required>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            岗位名称<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="JOB_SEQ_NO" id="JOB_SEQ_NO" class="form-control" ddl_name="ddl_job_name"
                                d_value="" show_type="t" required>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            学生所在学院<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="COLLEGE" id="COLLEGE" class="form-control" ddl_name='ddl_department'
                                d_value='' show_type='t' disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            姓名</label>
                        <div class="col-sm-8">
                            <input type="text" name="STU_NAME" id="STU_NAME" class="form-control" placeholder="姓名"
                                readonly />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            性别<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="SEX" id="SEX" class="form-control" ddl_name='ddl_xb'
                                d_value='' show_type='t' disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            手机<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="TELEPHONE" id="TELEPHONE" class="form-control" placeholder="手机" />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            饭卡号<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="RICE_CARD" id="RICE_CARD" class="form-control" placeholder="饭卡号" />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            学号<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="STU_NUMBER" id="STU_NUMBER" class="form-control" placeholder="学号"
                                readonly />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            银行卡号<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="BANK_CARD_NO" id="BANK_CARD_NO" class="form-control" placeholder="银行卡号" />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            身份证号<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="IDCARDNO" id="IDCARDNO" class="form-control" placeholder="身份证号"
                                readonly />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            年级<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="GRADE" id="GRADE" class="form-control" ddl_name='ddl_grade'
                                d_value='' show_type='t' disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            专业<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="MAJOR" id="MAJOR" class="form-control" ddl_name='ddl_zy'
                                d_value='' show_type='t' disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            班级<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="CLASS_CODE" id="CLASS_CODE" class="form-control" ddl_name='ddl_class'
                                d_value='' show_type='t' disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            学生层次<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="STU_TYPE" id="STU_TYPE" class="form-control" ddl_name='ddl_ua_stu_type'
                                d_value='' show_type='t' disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            劳动报酬总计</label>
                        <div class="col-sm-8">
                            <input type="text" name="REWARD" id="REWARD" class="form-control" placeholder="劳动报酬总计"
                                readonly />
                        </div>
                    </div>
                    <section class="content" id="content_detail">
						<div class="row">
							<div class="col-xs-12">
								<table id="detaillist" class="table table-bordered table-striped table-hover">
								</table>
							</div>
						</div>
					</section>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-save" id="btnSave">保存</button>
                    <button type="button" class="btn btn-primary btn-submit" id="btnSubmit">提交</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->

    <%-- 劳动内容 开始 --%>
    <div class="modal" id="detailModal">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="detail_edit" name="detail_edit" class="modal-content form-horizontal" onsubmit="return false;">
                <input type="hidden" name="LIST_OID" id="LIST_OID" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">
                        劳动内容</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            日期<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <input type="text" name="WORK_DATE" id="WORK_DATE" class="form-control datep" placeholder="日期"
                                required />
                        </div>
                        <label class="col-sm-2 control-label">
                            劳动时数</label>
                        <div class="col-sm-4">
                            <input type="text" name="WORK_HOURS" id="WORK_HOURS" class="form-control" placeholder="劳动时数"
                                required />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            劳动内容<span style="color: Red;">*</span></label>
                        <div class="col-sm-10">
                            <input type="text" name="WORK_TASK" id="WORK_TASK" class="form-control" placeholder="劳动内容"
                                maxlength="20" required />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            劳动开始时间<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <input type="time" name="WORK_START_TIME" id="WORK_START_TIME" class="form-control"
                                placeholder="劳动开始时间" onblur="CheckDate(this)" required />
                        </div>
                        <label class="col-sm-2 control-label">
                            劳动结束时间<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <input type="time" name="WORK_END_TIME" id="WORK_END_TIME" class="form-control"
                                placeholder="劳动结束时间" onblur="CheckDate(this)" required />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-save" id="btnDetailSave">保存</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </form>
        </div>
    </div>
    <%-- 劳动内容 结束 --%>

    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "DOC_TYPE",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "STU_NUMBER", "head": "学号", "type": "td-keep" },
				{ "data": "STU_NAME", "head": "姓名", "type": "td-keep" },
                { "data": "GRADE2", "head": "年级", "type": "td-keep" },
				{ "data": "COLLEGE2", "head": "学院", "type": "td-keep" },
				{ "data": "MAJOR2", "head": "专业", "type": "td-keep" },
				{ "data": "CLASS2", "head": "班级", "type": "td-keep" },
				{ "data": "EMPLOYER2", "head": "劳动所属单位", "type": "td-keep" },
				{ "data": "JOB_NAME", "head": "岗位名称", "type": "td-keep" },
				{ "data": "RET_CHANNEL", "head": "审核状态", "type": "td-keep" },
				{ "data": "SCH_YEAR2", "head": "学年", "type": "td-keep" },
				{ "data": "SCH_TERM2", "head": "学期", "type": "td-keep" },
				{ "data": "YEAR_MONTH", "head": "月份", "type": "td-keep" }
            ];

            //配置表格
            mainList = tablePackageMany.createOne({
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
                    tableTitle: "岗位劳酬",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        'aLengthMenu': [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(9)');
                            var data = Formatter_RetChannel(aData.RET_CHANNEL, aData.POS_CODE2);
                            tablePackage.statusSpan(_status,
                                {
                                    "type": data.type,
                                    "msg": data.msg
                                }
                            );
                        }
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
						{ "data": "GRADE", "pre": "年级", "col": 1, "type": "select", "ddl_name": "ddl_grade" },
						{ "data": "COLLEGE", "pre": "学院", "col": 2, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "MAJOR", "pre": "专业", "col": 3, "type": "select", "ddl_name": "ddl_zy" },
					    { "data": "STU_NUMBER", "pre": "学号", "col": 4, "type": "input" },
					    { "data": "STU_NAME", "pre": "姓名", "col": 5, "type": "input" },
						{ "data": "EMPLOYER", "pre": "劳动所属单位", "col": 6, "type": "select", "ddl_name": "ddl_all_department" },
						{ "data": "JOB_SEQ_NO", "pre": "岗位名称", "col": 7, "type": "select", "ddl_name": "ddl_job_name" }
                    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                    { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } },
					"add", "edit", "del",
                    { type: "userDefined", id: "btn-down", title: "下载", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } },
                    { type: "userDefined", id: "btn-wflow", title: "流程跟踪", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } }
                ],
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 列表JS 结束-->

    <%-- loadDetailList --%>
    <script type="text/javascript">
        function loadDetailList() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "WORK_DATE", "head": "日期" },
				{ "data": "WORK_TASK", "head": "劳动内容" },
                { "data": "WORK_START_TIME", "head": "劳动开始时间" },
                { "data": "WORK_END_TIME", "head": "劳动结束时间" },
                { "data": "WORK_HOURS", "head": "劳动时数" }
            ];

            //配置表格
            detailList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getprooflist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "detaillist", //表格id
                    buttonId: "detailListbuttonId", //拓展按钮区域id
                    tableTitle: "劳动情况",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            var content = $("#content_detail");
            content.on('click', ".btn-reload", function () {
                detailList.reload();
            });
            content.on('click', ".btn-add", function () {
                if (!($("#SEQ_NO").val())) {
                    easyAlert.timeShow({
                        "content": "请先保存基本信息！",
                        "duration": 2,
                        "type": "danger"
                    });
                    $("#detailModal").modal("hide");
                    return;
                }
                $("#detailModal").modal();
                $("#detailModal :input").val("");
            });

            content.on('click', ".btn-edit", function () {
                var data = detailList.selectSingle();
                if (data) {
                    $("#detailModal").modal();
                    //SetMainFormData("detailModal", "DETAIL_", data);
                    SetMainFormData("detailModal", "", data);
                    $("#LIST_OID").val(data.OID);
                }
            });
            content.on('click', ".btn-del", function () {
                var data = detailList.selectSingle();
                if (data) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除所选的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            $.post(OptimizeUtils.FormatUrl("?optype=deldetail&id=" + data.OID), function (msg) {
                                if (msg.length == 0) {
                                    easyAlert.timeShow({
                                        "content": "删除失败！",
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                } else {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": "删除成功！",
                                        "duration": 2,
                                        "type": "success"
                                    });
                                    detailList.reload();
                                    $("#REWARD").val(msg);//劳动报酬总计
                                }
                            });
                        }
                    });
                }
            });
        }

        function CheckDate(obj) {
            var id = obj.id;
            var start_time = $("#WORK_START_TIME").val();
            var end_time = $("#WORK_END_TIME").val();
            if (start_time.length > 0 && end_time.length > 0) {
                if (start_time.length > 0 && start_time > end_time) {
                    easyAlert.timeShow({
                        "content": "开始时间必须小于结束时间！",
                        "duration": 2,
                        "type": "danger"
                    });
                    $("#" + id).val("");
                    return;
                }

                start_time = "1900-01-01 " + $("#WORK_START_TIME").val() + ":00";
                end_time = "1900-01-01 " + $("#WORK_END_TIME").val() + ":00";
                var d1 = start_time.replace(/\-/g, "/");
                var d2 = end_time.replace(/\-/g, "/");
                var date1 = new Date(d1);
                var date2 = new Date(d2);
                //计算出小时数
                var hours = Math.round((date2 - date1) / (3600 * 1000));
                $("#WORK_HOURS").val(hours);
            }
        }
    </script>
    <%--  --%>

    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //下拉初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("SEX");
            DropDownUtils.initDropDown("GRADE");
            DropDownUtils.initDropDown("COLLEGE");
            DropDownUtils.initDropDown("MAJOR");
            DropDownUtils.initDropDown("CLASS_CODE");
            DropDownUtils.initDropDown("EMPLOYER");
            DropDownUtils.initDropDown("JOB_SEQ_NO");
            DropDownUtils.initDropDown("STU_TYPE");
        }

        //必填项设置
        function loadModalPageValidate() {
            ValidateUtils.setRequired("#form_edit", "STU_NUMBER", true, "学号必填");
            ValidateUtils.setRequired("#form_edit", "STU_NAME", true, "姓名必填");
            ValidateUtils.setRequired("#form_edit", "SEX", true, "性别必填");
            ValidateUtils.setRequired("#form_edit", "GRADE", true, "年级必填");
            ValidateUtils.setRequired("#form_edit", "COLLEGE", true, "学院必填");
            ValidateUtils.setRequired("#form_edit", "MAJOR", true, "专业必填");
            ValidateUtils.setRequired("#form_edit", "EMPLOYER", true, "劳动所属单位必填");
            ValidateUtils.setRequired("#form_edit", "JOB_SEQ_NO", true, "岗位名称必填");
            ValidateUtils.setRequired("#form_edit", "IDCARDNO", true, "身份证号必填");
            ValidateUtils.setRequired("#form_edit", "BANK_CARD_NO", true, "银行卡号必填");
            ValidateUtils.setRequired("#form_edit", "RICE_CARD", true, "饭卡号必填");
        }
    </script>

    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            var _content = $("#content");

            //刷新
            _content.on('click', '.btn-reload', function () {
                mainList.reload();
            });

            //查阅
            _content.on('click', '#btn-view', function () {
                hideBtn();
                var data = mainList.selectSingle();
                if (data) {
                    $("#tableModal").modal();
                    var apply_data = AjaxUtils.getResponseText('List.aspx?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                        //SelectUtils.HiredEmployer_JobCodeChange("EMPLOYER", "JOB_SEQ_NO", apply_data_json.EMPLOYER, apply_data_json.JOB_SEQ_NO);
                    }
                    detailList.refresh("?optype=getprooflist&seq_no=" + data.SEQ_NO);
                }
            });

            //新增
            _content.on('click', '.btn-add', function () {
                if (!Check()) return;

                showBtn();
                $("#tableModal").modal();
                $("#tableModal :input").val("");
                $("#tableModal .form-control-static").text("");
                var apply_data = AjaxUtils.getResponseText('List.aspx?optype=getdata&id=');
                if (apply_data) {
                    var apply_data_json = eval("(" + apply_data + ")");
                    _form_edit.setFormData(apply_data_json);
                    if ($("#TELEPHONE").val().length > 0)
                        $("#TELEPHONE").attr("disabled", true);
                    if ($("#BANK_CARD_NO").val().length > 0)
                        $("#BANK_CARD_NO").attr("disabled", true);
                    if ($("#RICE_CARD").val().length > 0)
                        $("#RICE_CARD").attr("disabled", true);
                }
                SelectUtils.HiredEmployer_JobCodeChange("EMPLOYER", "JOB_SEQ_NO", "", "");
                detailList.refresh("?optype=getprooflist&seq_no=");
            });

            //修改
            _content.on('click', '.btn-edit', function () {
                if (!Check()) return;

                showBtn();
                var data = mainList.selectSingle();
                if (data) {
                    var result = AjaxUtils.getResponseText('List.aspx?optype=chkmodi&id=' + data.OID);
                    if (result.length > 0) {
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    $("#tableModal").modal();
                    $("#tableModal :input").val("");
                    $("#tableModal .form-control-static").text("");
                    var apply_data = AjaxUtils.getResponseText('List.aspx?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                        SelectUtils.HiredEmployer_JobCodeChange("EMPLOYER", "JOB_SEQ_NO", apply_data_json.EMPLOYER, apply_data_json.JOB_SEQ_NO);
                    }
                    detailList.refresh("?optype=getprooflist&seq_no=" + data.SEQ_NO);
                }
            });

            //删除
            _content.on('click', '.btn-del', function () {
                var data = mainList.selectSingle();
                if (data) {
                    var result = AjaxUtils.getResponseText('List.aspx?optype=chkdel&id=' + data.OID);
                    if (result.length > 0) {
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除所选的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            $.post(OptimizeUtils.FormatUrl("?optype=delete&id=" + data.OID), function (msg) {
                                if (!msg) {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": "删除成功！",
                                        "duration": 2,
                                        "type": "success"
                                    });
                                    mainList.reload();
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
            });

            //下载
            _content.on('click', "#btn-down", function () {
                var data = mainList.selectSingle();
                if (data) {
                    window.open('/Word/ExportWord.aspx?optype=jobproof&id=' + data.OID + '&number=' + data.STU_NUMBER + '&seq_no=' + data.SEQ_NO);
                }
            });

            //审核流程跟踪
            wfklog = WfkLog.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "wfklogModal"//弹出层的id，不写则默认wfklogModal，必填
                },
                control: {
                    "content": "#content", //必填
                    "btnId": "#btn-wflow", //触发弹出层的按钮的id，必填
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

            var hideBtn = function () {
                $("#btnSave").hide();
                $("#btnSubmit").hide();
                $("#tableModal").find(".box-tools").hide();
            }
            var showBtn = function () {
                $("#btnSave").show();
                $("#btnSubmit").show();
                $("#tableModal").find(".box-tools").show();
            }
        }

        //是否可以填写
        function Check() {
            var result = AjaxUtils.getResponseText('List.aspx?optype=chk');
            if (result.length > 0) {
                easyAlert.timeShow({
                    "content": result,
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            return true;
        }

        //保存前校验
        function CheckData() {
            var id = $("#OID").val();
            var job = escape($("#JOB_SEQ_NO").val());
            var result = AjaxUtils.getResponseText("?optype=chksave&id=" + id + "&job=" + job);
            if (result.length > 0) {
                easyAlert.timeShow({
                    "content": result,
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            return true;
        }

        //保存
        function SaveData() {
            if (!($("#form_edit").valid())) {
                return;
            }

            if (!CheckData()) return;

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
                    var arr = msg.split(";");
                    if (arr.length == 2) {
                        $("#OID").val(arr[0]);
                        $("#SEQ_NO").val(arr[1]);
                        detailList.refresh("?optype=getprooflist&seq_no=" + arr[1].toString());
                    }
                    //保存成功：刷新列表
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload();
                }
            });
        }

        //提交
        function SubmitData() {
            if (!($("#form_edit").valid())) {
                return;
            }

            if (!CheckData()) return;

            var result = AjaxUtils.getResponseText('?optype=chksubmit&id=' + $("#OID").val());
            if (result.length > 0) {
                easyAlert.timeShow({
                    "content": result,
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }

            $.post(OptimizeUtils.FormatUrl("?optype=submit"), $("#form_edit").serialize(), function (msg) {
                $(".Confirm_Div").modal("hide");
                if (msg.length == 0) {
                    $("#tableModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "提交成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload();
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
        }

        function SaveDetail() {
            if (!($("#detail_edit").valid())) {
                return;
            }
            var param = $("#detail_edit").serialize() + "&JOB_SEQ_NO=" + $("#JOB_SEQ_NO").val();
            $.post(OptimizeUtils.FormatUrl("?optype=savedetail&seq_no=" + $("#SEQ_NO").val()), param, function (msg) {
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
                    $("#detailModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    detailList.reload();
                    $("#REWARD").val(msg);//劳动报酬总计
                }
            });
        }

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
