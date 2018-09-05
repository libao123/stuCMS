<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="List.aspx.cs" 
    Inherits="PorteffAnaly.Web.AdminLTE_QZ.JobManage.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _form_edit;
        var mainList;
        window.onload = function () {
            adaptionHeight();

            _form_edit = PageValueControl.init("form_edit");

            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();

            //时间控件
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });

            $("#STU_TYPE").change(function () {
                var stu_type = $("#STU_TYPE").val();
                var result = AjaxUtils.getResponseText("?optype=getreward&stu_type=" + stu_type);
                if (result.length > 0) {
                    var arr = result.split(",");
                    if (arr.length == 2) {
                        $("#REWARD_STD").val(arr[0]);
                        $("#REWARD_UNIT").val(arr[1]);
                    }
                } else {
                    easyAlert.timeShow({
                        "content": "获取薪酬标准失败",
                        "duration": 2,
                        "type": "danger"
                    });
                    $("#REWARD_STD").val("");
                    $("#REWARD_UNIT").val("");
                }
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
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>勤工助学岗位申报</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>岗位管理</li>
				<li class="active">勤工助学岗位申报</li>
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
        <div class="modal-dialog modal-dw70">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
                onsubmit="return false;">
                <input type="hidden" id="OID" name="OID" />
                <input type="hidden" id="SEQ_NO" name="SEQ_NO" />
                <input type="hidden" id="hidStuType" name="hidStuType" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">岗位信息</h4>
                </div>
                <div class="tab-content row">
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            校区<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="CAMPUS" id="CAMPUS" class="form-control" ddl_name="ddl_campus"
                                d_value="" show_type="t" required>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            岗位类型<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="JOB_TYPE" id="JOB_TYPE" class="form-control" ddl_name='ddl_job_type'
                                d_value='' show_type='t' required>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            用人单位<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="EMPLOYER" id="EMPLOYER" class="form-control" ddl_name='ddl_all_department'
                                d_value='' show_type='t' required>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            岗位名称<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input name="JOB_NAME" id="JOB_NAME" type="text" class="form-control" placeholder="岗位名称" />
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label">
                            岗位描述</label>
                        <div class="col-sm-10">
                            <input type="text" name="JOB_DESCR" id="JOB_DESCR" class="form-control" placeholder="岗位描述" />
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label">
                            岗位要求</label>
                        <div class="col-sm-10">
                            <input type="text" name="JOB_RQMT" id="JOB_RQMT" class="form-control" placeholder="岗位要求" />
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label">
                            工作地点</label>
                        <div class="col-sm-10">
                            <input type="text" name="WORK_PLACE" id="WORK_PLACE" class="form-control" placeholder="工作地点" />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            需求人数<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="REQ_NUM" id="REQ_NUM" class="form-control" placeholder="需求人数" />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            学生类型<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <%--<input type="checkbox" name="STU_TYPE" id="STU_TYPE_B" value="B" /><label for="STU_TYPE_B" style="margin-right: 30px;">本科生</label>
                            <input type="checkbox" name="STU_TYPE" id="STU_TYPE_Y" value="Y" /><label for="STU_TYPE_Y">研究生</label>--%>
                            <select class="form-control" name="STU_TYPE" id="STU_TYPE" d_value='' show_type='t'
                                ddl_name='ddl_ua_stu_type'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            报酬标准<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input name="REWARD_STD" id="REWARD_STD" type="text" class="form-control" placeholder="报酬标准"
                                readonly />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            计算单位<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select class="form-control" name="REWARD_UNIT" id="REWARD_UNIT" d_value='' show_type='t'
                                ddl_name='ddl_reward_unit' readonly>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            学年<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select class="form-control" name="SCH_YEAR" id="SCH_YEAR" d_value='' show_type='t'
                                ddl_name='ddl_year_type'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            学期<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select class="form-control" name="SCH_TERM" id="SCH_TERM" d_value='' show_type='t'
                                ddl_name='ddl_xq'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            申请时间<span style="color: Red;">*</span></label>
                        <div class="col-sm-8" style="position: relative; z-index: 9999">
                            <input type="text" name="DECL_START_TIME" id="DECL_START_TIME" class="form-control datep"
                                placeholder="申请开始时间" />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            至</label>
                        <div class="col-sm-8" style="position: relative; z-index: 9999">
                            <input type="text" name="DECL_END_TIME" id="DECL_END_TIME" class="form-control datep"
                                placeholder="申请结束时间" />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            工作时间<span style="color: Red;">*</span></label>
                        <div class="col-sm-8" style="position: relative; z-index: 9999">
                            <input type="text" name="WORK_START_TIME" id="WORK_START_TIME" class="form-control datep"
                                placeholder="工作开始时间" />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            至</label>
                        <div class="col-sm-8" style="position: relative; z-index: 9999">
                            <input type="text" name="WORK_END_TIME" id="WORK_END_TIME" class="form-control datep"
                                placeholder="工作结束时间" />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            是否允许一人多岗<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select class="form-control" name="IS_MULT" id="IS_MULT" d_value='' show_type='t'
                                ddl_name='ddl_yes_no'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            是否使用<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select class="form-control" name="IS_USE" id="IS_USE" d_value='' show_type='t'
                                ddl_name='ddl_yes_no'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            排序</label>
                        <div class="col-sm-8">
                            <input name="ORDER_NUM" id="ORDER_NUM" type="text" class="form-control" placeholder="排序" />
                        </div>
                    </div>
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
                { "data": "EMPLOYER2", "head": "用人单位", "type": "td-keep" },
				{ "data": "JOB_NAME", "head": "岗位名称", "type": "td-keep" },
				{ "data": "JOB_TYPE2", "head": "岗位类型", "type": "td-keep" },
				{ "data": "REQ_NUM", "head": "需求人数", "type": "td-keep" },
				{ "data": "SCH_YEAR2", "head": "学年", "type": "td-keep" },
				{ "data": "SCH_TERM2", "head": "学期", "type": "td-keep" },
				{ "data": "RET_CHANNEL", "head": "审核状态", "type": "td-keep" },
				{ "data": "IS_USE2", "head": "是否使用", "type": "td-keep" },
				{ "data": "IS_MULT2", "head": "是否允许一人多岗", "type": "td-keep" },
				{ "data": "STU_TYPE2", "head": "学生类型", "type": "td-keep" }
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
                    tableTitle: "勤工助学岗位申报",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        'aLengthMenu': [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(7)');
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
						{ "data": "SCH_YEAR", "pre": "学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
						{ "data": "JOB_TYPE", "pre": "岗位类型", "col": 2, "type": "select", "ddl_name": "ddl_job_type" },
					    { "data": "JOB_NAME", "pre": "岗位名称", "col": 3, "type": "input" },
						{ "data": "IS_USE", "pre": "是否使用", "col": 4, "type": "select", "ddl_name": "ddl_yes_no" }
                    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                    { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } },
					"add", "edit", "del",
                    { type: "userDefined", id: "btn-wflow", title: "流程跟踪", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } }
                ],
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 列表JS 结束-->

    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //下拉初始化
        function loadModalPageDataInit() {
            LimitUtils.onlyNum("ORDER_NUM");
            DropDownUtils.initDropDown("CAMPUS");
            DropDownUtils.initDropDown("JOB_TYPE");
            DropDownUtils.initDropDown("SCH_YEAR");
            DropDownUtils.initDropDown("SCH_TERM");
            DropDownUtils.initDropDown("REWARD_UNIT");
            DropDownUtils.initDropDown("IS_USE");
            DropDownUtils.initDropDown("IS_MULT");
            DropDownUtils.initDropDown("STU_TYPE");
            if ("<%=user.User_Role%>" == "D") {
                var ddl_dw_str = AjaxUtils.getResponseText("?optype=getdept");
                SelectUtils.LoadEditCombox(ddl_dw_str, "EMPLOYER", "", 't');
            } else {
                DropDownUtils.initDropDown("EMPLOYER");
            }

            //设置checkbox选中改变事件
            $("input[type='checkbox'][name='STU_TYPE']").on('ifChanged', function (event) {
                GetStuType();
            });
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        }

        //必填项设置
        function loadModalPageValidate() {
            ValidateUtils.setRequired("#form_edit", "CAMPUS", true, "校区必填");
            ValidateUtils.setRequired("#form_edit", "EMPLOYER", true, "用人单位必填");
            ValidateUtils.setRequired("#form_edit", "JOB_NAME", true, "岗位名称必填");
            ValidateUtils.setRequired("#form_edit", "JOB_TYPE", true, "岗位类型必填");
            ValidateUtils.setRequired("#form_edit", "REQ_NUM", true, "需求人数必填");
            ValidateUtils.setRequired("#form_edit", "REWARD_STD", true, "报酬标准必填");
            ValidateUtils.setRequired("#form_edit", "REWARD_UNIT", true, "计算单位必填");
            ValidateUtils.setRequired("#form_edit", "IS_USE", true, "是否使用必填");
            ValidateUtils.setRequired("#form_edit", "IS_MULT", true, "是否允许一人多岗必填");
            ValidateUtils.setRequired("#form_edit", "SCH_YEAR", true, "学年必填");
            ValidateUtils.setRequired("#form_edit", "SCH_TERM", true, "学期必填");
            ValidateUtils.setRequired("#form_edit", "DECL_START_TIME", true, "申请开始时间必填");
            ValidateUtils.setRequired("#form_edit", "DECL_END_TIME", true, "申请结束时间必填");
            ValidateUtils.setRequired("#form_edit", "WORK_START_TIME", true, "工作开始时间必填");
            ValidateUtils.setRequired("#form_edit", "WORK_END_TIME", true, "工作结束时间必填");
            ValidateUtils.setRequired("#form_edit", "STU_TYPE", true, "学生类型必填");

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
                    }
                }
            });

            //新增
            _content.on('click', '.btn-add', function () {
                showBtn();
                $("#tableModal").modal();
                $("#tableModal :input").val("");
                $("#tableModal .form-control-static").text("");
                var apply_data = AjaxUtils.getResponseText('List.aspx?optype=getdata&id=');
                if (apply_data) {
                    var apply_data_json = eval("(" + apply_data + ")");
                    _form_edit.setFormData(apply_data_json);
                }
            });

            //修改
            _content.on('click', '.btn-edit', function () {
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
                    var apply_data = AjaxUtils.getResponseText('List.aspx?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                    }
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
            }
            var showBtn = function () {
                $("#btnSave").show();
                $("#btnSubmit").show();
            }
        }

        //是否可以申报
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
        function BeforeSave() {
            var id = $("#OID").val();
            var job_type = $("#JOB_TYPE").val();
            var employer = escape($("#EMPLOYER").val());
            var job_name = escape($("#JOB_NAME").val());
            var result = AjaxUtils.getResponseText("?optype=chksave&id=" + id + "&job_type=" + job_type + "&employer=" + employer + "&job_name=" + job_name);
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

            if (!BeforeSave()) return;
            
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
                    $("#OID").val(msg);
                    //保存成功：关闭界面，刷新列表
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

            if (!BeforeSave()) return;

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

        //选择学生类型
        function GetStuType() {
            var checkbox = "";
            $("#hidStuType").val("");
            $("input[type='checkbox'][name='STU_TYPE']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).attr("value") + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidStuType").val(checkbox);
            }
        }
    </script>
</asp:Content>
