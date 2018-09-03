<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="List_pend.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_QZ.JobManage.List_pend" %>

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
			<h1>勤工助学岗位审核</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>岗位管理</li>
				<li class="active">勤工助学岗位审核</li>
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
        <div class="modal-dialog" style="width: 60%;">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
                onsubmit="return false;">
                <input type="hidden" id="OID" name="OID" />
                <input type="hidden" id="SEQ_NO" name="SEQ_NO" />
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
                            <select class="form-control" name="STU_TYPE" id="STU_TYPE" d_value='' show_type='t'
                                ddl_name='ddl_ua_stu_type'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            报酬标准<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input name="REWARD_STD" id="REWARD_STD" type="text" class="form-control" placeholder="报酬标准" />
                        </div>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            计算单位<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select class="form-control" name="REWARD_UNIT" id="REWARD_UNIT" d_value='' show_type='t'
                                ddl_name='ddl_reward_unit'>
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
                    <button type="button" class="btn btn-primary" id="btnAudit">审核</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->

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
                    url: "?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "待处理查看",
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
					{ type: "userDefined", id: "btn-audit", title: "审核", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } },
					//{ type: "userDefined", id: "audit_p", title: "批量审核通过", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } },
                //{ type: "userDefined", id: "audit_n", title: "批量审核不通过", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing" } },
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

    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //下拉初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("CAMPUS");
            DropDownUtils.initDropDown("JOB_TYPE");
            DropDownUtils.initDropDown("EMPLOYER");
            DropDownUtils.initDropDown("SCH_YEAR");
            DropDownUtils.initDropDown("SCH_TERM");
            DropDownUtils.initDropDown("REWARD_UNIT");
            DropDownUtils.initDropDown("IS_USE");
            DropDownUtils.initDropDown("IS_MULT");
            DropDownUtils.initDropDown("STU_TYPE");
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
                    var apply_data = AjaxUtils.getResponseText('/AdminLTE_QZ/JobManage/List.aspx?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                    }
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
                    var apply_data = AjaxUtils.getResponseText('/AdminLTE_QZ/JobManage/List.aspx?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                    }
                }
            });

            //批量审核通过
            _content.on('click', "#audit_p", function () {
                MultiAudit('P');
            });

            //批量审核不通过
            _content.on('click', "#audit_n", function () {
                MultiAudit('N');
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
                        var data = mainList.selectSingle();
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
                                mainList.reload();
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

        //获得查询条件中的参数
        function GetSearchUrlParam() {
            var SCH_YEAR = DropDownUtils.getDropDownValue("search-SCH_YEAR");
            var JOB_TYPE = DropDownUtils.getDropDownValue("search-JOB_TYPE");
            var IS_USE = DropDownUtils.getDropDownValue("search-IS_USE");
            var JOB_NAME = $("#search-JOB_NAME").val();

            var strq = "";
            if (SCH_YEAR)
                strq += "&SCH_YEAR=" + SCH_YEAR;
            if (JOB_TYPE)
                strq += "&JOB_TYPE=" + JOB_TYPE;
            if (IS_USE)
                strq += "&IS_USE=" + IS_USE;
            if (JOB_NAME)
                strq += "&JOB_NAME=" + OptimizeUtils.FormatParamter(JOB_NAME);

            return strq;
        }

        function MultiAudit(flag) {
            var layInx = layer.load(2, {
                content: "批量审核中，请稍后...",
                shade: [0.3, '#000'], //0.1透明度的白色背景
                time: 6000
            });
            //列表勾选
            var strOids = "";
            var select_maxnum = 100; //目前放开url传值传100条记录的OID
            var datas = mainList.selection();
            if (datas) {
                if (datas.length <= 100) {
                    select_maxnum = datas.length;
                }
                for (var i = 0; i < select_maxnum; i++) {
                    if (datas[i]) {
                        if (datas[i].OID) {
                            strOids += datas[i].OID + ",";
                        }
                    }
                }
            }
            //查询栏
            var urlParam = GetSearchUrlParam();
            var result = AjaxUtils.getResponseText('List_pend.aspx?optype=multiaudit&flag=' + flag + urlParam + "&ids=" + strOids);
            if (layInx) {
                layer.closeAll();
            }
            if (result.length == 0) {
                easyAlert.timeShow({
                    "content": "批量审批成功！",
                    "duration": 2,
                    "type": "info"
                });
                mainList.reload();
            }
            else {
                easyAlert.timeShow({
                    "content": result,
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
        }
    </script>
</asp:Content>
