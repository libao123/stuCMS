<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="List_pend.aspx.cs" 
    Inherits="PorteffAnaly.Web.AdminLTE_QZ.JobReward.List_pend" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _form_edit;
        var mainList;
        var rewardList;
        window.onload = function () {
            adaptionHeight();

            _form_edit = PageValueControl.init("form_edit");
            loadTableList();
            loadRewardList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();

            SelectUtils.TowLevelCodeChange_Sql("search-EMPLOYER", "search-JOB_SEQ_NO", "", "", "ddl_all_department", "ddl_job_name", "EMPLOYER");
            SelectUtils.TowLevelCodeChange_Sql("SELECT_EMPLOYER", "SELECT_JOB", "", "", "ddl_all_department", "ddl_job_name", "EMPLOYER");

            $("#btnDownload").click(function () {
                DownloadData();
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>用人单位签领单审核--待处理</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>勤工助学管理</li>
				<li class="active">用人单位签领单审核--待处理</li>
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
        <div class="modal-dialog modal-dw80">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
                onsubmit="return false;">
                <input type="hidden" id="OID" name="OID" />
                <input type="hidden" id="SEQ_NO" name="SEQ_NO" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">薪酬审核--待处理</h4>
                </div>
                <div class="tab-content row">
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            用人单位：</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="EMPLOYER2">
                                -</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            发放月份：</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="YEAR_MONTH">
                                -</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            合计：</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="TOTAL_REAL_AMOUNT">
                                -</p>
                        </div>
                    </div>
                    <section class="content" id="content_reward">
						<div class="row">
							<div class="col-xs-12">
								<table id="rewardlist" class="table table-bordered table-striped table-hover">
								</table>
							</div>
						</div>
					</section>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="btnAudit">审核</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->

    <%-- 薪酬 开始 --%>
    <div class="modal" id="rewardModal">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="reward_edit" name="reward_edit" class="modal-content form-horizontal" onsubmit="return false;">
                <input type="hidden" name="OID" id="LIST_OID" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">
                        薪酬</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            学号<span style="color: Red;">*</span></label>
                        <div class="col-sm-2">
                            <p class="form-control-static" id="STU_NUMBER">
                                -</p>
                        </div>
                        <label class="col-sm-2 control-label">
                            姓名<span style="color: Red;">*</span></label>
                        <div class="col-sm-2">
                            <p class="form-control-static" id="STU_NAME">
                                -</p>
                        </div>
                        <label class="col-sm-2 control-label">
                            银行卡号<span style="color: Red;">*</span></label>
                        <div class="col-sm-2">
                            <p class="form-control-static" id="BANK_CARD_NO">
                                -</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            学院<span style="color: Red;">*</span></label>
                        <div class="col-sm-2">
                            <p class="form-control-static" id="COLLEGE2">
                                -</p>
                        </div>
                        <label class="col-sm-2 control-label">
                            专业<span style="color: Red;">*</span></label>
                        <div class="col-sm-2">
                            <p class="form-control-static" id="MAJOR2">
                                -</p>
                        </div>
                        <label class="col-sm-2 control-label">
                            身份证号<span style="color: Red;">*</span></label>
                        <div class="col-sm-2">
                            <p class="form-control-static" id="IDCARDNO">
                                -</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            标准<span style="color: Red;">*</span></label>
                        <div class="col-sm-2">
                            <p class="form-control-static" id="REWARD_STD">
                                -</p>
                        </div>
                        <label class="col-sm-2 control-label">
                            数量<span style="color: Red;">*</span></label>
                        <div class="col-sm-2">
                            <p class="form-control-static" id="QUANTITY">
                                -</p>
                        </div>
                        <label class="col-sm-2 control-label">
                            应发金额<span style="color: Red;">*</span></label>
                        <div class="col-sm-2">
                            <p class="form-control-static" id="PAYABLE_AMOUNT">
                                -</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </form>
        </div>
    </div>
    <%-- 薪酬 结束 --%>

    <%-- 下载选择界面 开始 --%>
    <div class="modal" id="downModal">
        <div class="modal-dialog modal-dw40">
            <form action="#" method="post" id="down_edit" name="reward_edit" class="modal-content form-horizontal"
                onsubmit="return false;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">
                        下载签领单</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                    <div class="form-group col-sm-12">
                        <label class="col-sm-4 control-label">
                            发放月份<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="month" name="SELECT_MONTH" id="SELECT_MONTH" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-4 control-label">
                            用人单位</label>
                        <div class="col-sm-8">
                            <select name="SELECT_EMPLOYER" id="SELECT_EMPLOYER" class="form-control"
                                ddl_name='ddl_all_department' d_value='' show_type='t'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-4 control-label">
                            岗位名称</label>
                        <div class="col-sm-8">
                            <select name="SELECT_JOB" id="SELECT_JOB" class="form-control" ddl_name="ddl_job_name"
                                d_value="" show_type="t">
                            </select>
                        </div>
                    </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-submit" id="btnDownload">确认</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </form>
        </div>
    </div>
    <%-- 下载选择界面 结束 --%>

    <!-- 退回界面 -->
    <div class="modal fade" id="returnModal">
        <div class="modal-dialog">
            <form id="form_return" name="form_return" class="modal-content form-horizontal">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">退回</h4>
                </div>
                <div class="modal-body">
                    <iframe id="returnFrame" frameborder="0" src="" style="width: 100%; height: 300px;">
                    </iframe>
                </div>
            </form>
        </div>
    </div>

    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				{
				    "data": "DOC_TYPE",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "SCH_YEAR2", "head": "学年", "type": "td-keep" },
				{ "data": "SCH_TERM2", "head": "学期", "type": "td-keep" },
				{ "data": "EMPLOYER2", "head": "用人单位", "type": "td-keep" },
                { "data": "YEAR_MONTH", "head": "发放月份", "type": "td-keep" },
				{ "data": "RET_CHANNEL", "head": "审核状态", "type": "td-keep" }
            ];

            //配置表格
            mainList = tablePackage.createOne({
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
                    tableTitle: "薪酬审核",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        'aLengthMenu': [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(5)');
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
						{ "data": "SCH_YEAR", "pre": "学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type" },
						{ "data": "SCH_TERM", "pre": "学期", "col": 2, "type": "select", "ddl_name": "ddl_xq" },
					    { "data": "EMPLOYER", "pre": "用人单位", "col": 3, "type": "select", "ddl_name": "ddl_all_department" },
					    { "data": "JOB_SEQ_NO", "pre": "岗位名称", "col": 4, "type": "select", "ddl_name": "ddl_job_name" }
                    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                    { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } },
					{ type: "userDefined", id: "btn-audit", title: "审核", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } },
                    { type: "userDefined", id: "btn-wflow", title: "流程跟踪", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } },
                    { type: "userDefined", id: "btn-down", title: "下载签领单", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } },
                    { type: "userDefined", id: "btn-return", title: "退回", className: "btn-warning", attr: { "data-action": "", "data-other": "nothing" } }
                ],
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 列表JS 结束-->

    <%-- loadRewardList --%>
    <script type="text/javascript">
        function loadRewardList() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "COLLEGE2", "head": "学院" },
				{ "data": "MAJOR2", "head": "专业" },
                { "data": "STU_NUMBER", "head": "学号" },
                { "data": "STU_NAME", "head": "姓名" },
                { "data": "REWARD_STD", "head": "标准" },
                { "data": "QUANTITY", "head": "数量" },
                { "data": "PAYABLE_AMOUNT", "head": "应发金额" },
                { "data": "REAL_AMOUNT", "head": "实发金额" },
                { "data": "BANK_CARD_NO", "head": "银行卡号" },
                { "data": "IDCARDNO", "head": "身份证号" }
            ];

            //配置表格
            rewardList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getrewardlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "rewardlist", //表格id
                    buttonId: "rewardListbuttonId", //拓展按钮区域id
                    tableTitle: "薪酬明细",
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
            var content = $("#content_reward");
            content.on('click', ".btn-reload", function () {
                rewardList.reload();
            });
            content.on('click', ".btn-add", function () {
                if (!($("#SEQ_NO").val())) {
                    easyAlert.timeShow({
                        "content": "请先保存基本信息！",
                        "duration": 2,
                        "type": "danger"
                    });
                    $("#rewardModal").modal("hide");
                }
                $("#rewardModal").modal();
                $("#rewardModal :input").val("");
            });

            content.on('click', ".btn-edit", function () {
                var data = rewardList.selectSingle();
                if (data) {
                    $("#rewardModal").modal();
                    SetMainFormData("rewardModal", "REWARD_", data);
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
                var data = rewardList.selectSingle();
                if (data) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除所选的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            $.post(OptimizeUtils.FormatUrl("?optype=dellist&id=" + data.OID), function (msg) {
                                if (!msg) {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": "删除成功！",
                                        "duration": 2,
                                        "type": "success"
                                    });
                                    rewardList.reload();
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
    <%--  --%>

    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //下拉初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("SELECT_EMPLOYER");
            DropDownUtils.initDropDown("SELECT_JOB");
        }

        //必填项设置
        function loadModalPageValidate() {
            ValidateUtils.setRequired("#down_edit", "SELECT_MONTH", true, "发放月份必填");
        }
    </script>

    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            var _content = $("#content");

            //刷新
            _content.on('click', '.btn-reload', function () {
                tablePackage.reload();
            });

            //查阅
            _content.on('click', '#btn-view', function () {
                hideBtn();
                var data = tablePackage.selectSingle();
                if (data) {
                    $("#tableModal").modal();
                    var apply_data = AjaxUtils.getResponseText('/AdminLTE_QZ/JobReward/List.aspx?optype=getdata&id=' + data.OID + '&seq_no=' + data.SEQ_NO);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                    }
                    rewardList.refresh("?optype=getrewardlist&seq_no=" + data.SEQ_NO);
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });

            //单条审批
            _content.on('click', "#btn-audit", function () {
                hideBtn();
                var data = mainList.selectSingle();
                if (data) {
                    if (data.DECLARE_TYPE != 'D') {
                        easyAlert.timeShow({
                            "content": "该当前状态不允许进行操作！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    $("#btnAudit").show();
                    $("#tableModal").modal();
                    var apply_data = AjaxUtils.getResponseText('/AdminLTE_QZ/JobReward/List.aspx?optype=getdata&id=' + data.OID + '&seq_no=' + data.SEQ_NO);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                    }
                    rewardList.refresh("?optype=getrewardlist&seq_no=" + data.SEQ_NO);
                } else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });

            //下载
            _content.on('click', "#btn-down", function () {
                $("#downModal").modal();
                $("#downModal :input").val("");
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

            //审批按钮
            var approve = approveComPage.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "approveModal"//弹出层的id，不写则默认verifyModal，必填
                },
                control: {
                    "content": "#form_edit", //必填
                    "btnId": "#btnAudit", //触发弹出层的按钮的id，必填
                    "beforeShow": function (btn, form) {//返回btn信息和form信息
                        var data = mainList.selectSingle();
                        if (data) {
                            if (data.OID) {
                                //判断是否有审批权限
                                var url = "/AdminLTE_Mod/CHK/Approve.aspx?optype=chk"
                                + "&doc_type=" + data.DOC_TYPE + "&seq_no=" + data.SEQ_NO + "&decltype=" + data.DECLARE_TYPE;
                                var result = AjaxUtils.getResponseText(url);
                                if (result.length > 0) {
                                    easyAlert.timeShow({
                                        "content": result,
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                    return false;
                                }
                                //如果是撤销审核，修改界面名词
                                if (data.DECLARE_TYPE == "R") {
                                    $("#lab_approvePass").text("同意");
                                    $("#lab_approveNoPass").text("不同意");
                                }
                                //默认审核信息内容为：同意
                                $("#approvePass").iCheck("check"); //默认选中
                                $("#approveMsg").val("同意");
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
                        var data = tablePackage.selectSingle();
                        //提交
                        var approveurl = OptimizeUtils.FormatUrl("/AdminLTE_Mod/CHK/Approve.aspx?optype=submit_approve"
                        + "&doc_type=" + data.DOC_TYPE + "&seq_no=" + data.SEQ_NO + "&decltype=" + data.DECLARE_TYPE
                        + "&msg_accpter=" + data.OP_CODE);
                        $.post(approveurl, $("#form_approve").serialize(), function (msg) {
                            if (msg.length > 0) {
                                easyAlert.timeShow({
                                    "content": msg,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }
                            else {
                                //审核成功：关闭界面，刷新列表
                                $("#approveModal").modal("hide");
                                $("#tableModal").modal("hide");
                                easyAlert.timeShow({
                                    "content": "审核成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                tablePackage.reload();
                            }
                        });
                    }
                }
            });

            //退回
            _content.on('click', '#btn-return', function () {
                var data = mainList.selectSingle();
                if (data) {
                    $("#returnModal").modal();
                    var url = "/AdminLTE_Mod/CHK/Return.aspx?doc_type=" + data.DOC_TYPE + "&seq_no=" + data.SEQ_NO + "&step_no=" + data.STEP_NO;
                    $("#returnFrame").attr("src", url);
                }
            });

            var hideBtn = function () {
                $("#tableModal").find(".box-tools").hide();
                $("#btnAudit").hide();
            }
            var showBtn = function () {
                $("#tableModal").find(".box-tools").show();
                $("#btnAudit").show();
            }
        }

        function DownloadData() {
            if (!($("#down_edit").valid())) {
                return;
            }

            var param = "";
            if ($("#SELECT_MONTH").val())
                param += "&month=" + $("#SELECT_MONTH").val();
            if ($("#SELECT_EMPLOYER").val())
                param += "&employer=" + $("#SELECT_EMPLOYER").val();
            if ($("#SELECT_JOB").val())
                param += "&job=" + $("#SELECT_JOB").val();
            var result = AjaxUtils.getResponseText("List_proc.aspx?optype=ishave" + param);
            if (result.length == 0) {
                easyAlert.timeShow({
                    "content": "无数据可提供下载！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            window.open("/Excel/ExportExcel/ExportExcel.aspx?optype=jobreward" + param);
        }
    </script>
</asp:Content>
