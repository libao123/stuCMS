<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="List_proc.aspx.cs" 
    Inherits="PorteffAnaly.Web.AdminLTE_QZ.JobProof.List_proc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _form_edit;
        var mainList;
        var detailList;
        window.onload = function () {
            adaptionHeight();

            _form_edit = PageValueControl.init("form_edit");
            loadTableList();
            loadDetailList();
            loadModalBtnInit();
            loadModalPageDataInit();

            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-COLLEGE", "search-MAJOR", "", "search-CLASS");

            //时间控件
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>劳酬审核--已处理</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>岗位劳酬管理</li>
				<li class="active">劳酬审核--已处理</li>
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
                    <h4 class="modal-title">劳酬审核--已处理</h4>
                </div>
                <div class="tab-content row">
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            劳动所属单位</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="EMPLOYER">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            岗位名称</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="JOB_SEQ_NO">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            学生所在学院</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="COLLEGE">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            姓名</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="STU_NAME">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            性别</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="SEX">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            手机</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="TELEPHONE">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            饭卡号</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="RICE_CARD">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            学号</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="STU_NUMBER">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            银行卡号</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="BANK_CARD_NO">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            身份证号</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="IDCARDNO">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            年级</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="GRADE">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            专业</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="MAJOR">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            学生层次</label>
                        <div class="col-sm-8">
                            <p class="form-control-static" id="STU_TYPE">-</p>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            劳动报酬总计</label>
                        <div class="col-sm-8">
                            <input type="text" name="REWARD" id="REWARD" class="form-control" placeholder="劳动报酬总计" />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            劳动完成情况<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <select name="CMPL_STS" id="CMPL_STS" class="form-control" ddl_name='ddl_cmpl_status'
                                d_value='' show_type='t'>
                            </select>
                        </div>
                        <div class="col-sm-4" style="margin: 0; padding: 0;">
                            <input type="text" name="CMPL_STS_TEXT" id="CMPL_STS_TEXT" class="form-control"
                                placeholder="劳动完成情况" maxlength="10" />
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
                <input type="hidden" name="OID" id="LIST_OID" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">
                        劳动情况</h4>
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
                                required />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            劳动开始时间<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <input type="time" name="WORK_START_TIME" id="WORK_START_TIME" class="form-control"
                                placeholder="劳动开始时间" required />
                        </div>
                        <label class="col-sm-2 control-label">
                            劳动结束时间<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <input type="time" name="WORK_END_TIME" id="WORK_END_TIME" class="form-control"
                                placeholder="劳动结束时间" required />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-save" id="btnDetailSave">
                        保存</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        关闭</button>
                </div>
            </form>
        </div>
    </div>
    <%-- 劳动内容 结束 --%>

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
				{ "data": "SCH_TERM2", "head": "学期", "type": "td-keep" }
            ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "List_proc.aspx?optype=getlist",
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
                    { type: "userDefined", id: "btn-down", title: "下载", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } },
                    { type: "userDefined", id: "btn-wflow", title: "流程跟踪", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } },
                    { type: "userDefined", id: "btn-return", title: "退回", className: "btn-warning", attr: { "data-action": "", "data-other": "nothing" } }
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
                hasBtns: ["reload"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            var content = $("#content_detail");
            content.on('click', ".btn-reload", function () {
                detailList.reload();
            });
        }
    </script>
    <%--  --%>

    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //下拉初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("CMPL_STS");
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
                    var apply_data = AjaxUtils.getResponseText('?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                        if (apply_data_json.CMPL_STS == apply_data_json.CMPL_STS_TEXT) {
                            $("#CMPL_STS").val("O");
                            $("#CMPL_STS_TEXT").val(apply_data_json.CMPL_STS_TEXT);
                            $("#CMPL_STS_TEXT").removeAttr("disabled");
                        }
                        else {
                            $("#CMPL_STS_TEXT").val("");
                            $("#CMPL_STS_TEXT").attr("disabled", "disabled");
                        }
                    }
                    detailList.refresh("?optype=getprooflist&seq_no=" + data.SEQ_NO);
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
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
