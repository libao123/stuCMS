<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var wfklog;
        $(function () {
            adaptionHeight();
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-COLLEGE", "search-MAJOR", "", "search-CLASS");
            loadTableList();
            loadModalBtnInit();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
				<h1>修改审核</h1>
				<ol class="breadcrumb">
					<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
					<li>个人中心</li>
					<li class="active">修改审核</li>
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
    <div class="modal fade" id="tableModal">
        <div class="modal-dialog modal-dw60">
          <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <input type="hidden" id="OID" name="OID" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">保险项目设置</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学号<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="NUMBER" id="NUMBER" type="text" class="form-control" placeholder="学号" />
                    </div>

                    <label class="col-sm-2 control-label">
                        姓名<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="NAME" id="NAME" type="text" class="form-control" placeholder="姓名" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        保险项目说明</label>
                    <div class="col-sm-10">
                        <textarea id="INSURINFO" name="INSURINFO" class="form-control" rows="3"></textarea>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        操作人</label>
                    <div class="col-sm-4">
                        <input name="OP_NAME" id="OP_NAME" type="text" class="form-control" placeholder="操作人"
                            readonly />
                    </div>

                    <label class="col-sm-2 control-label">
                        操作时间</label>
                    <div class="col-sm-4">
                        <input name="OP_TIME" id="OP_TIME" type="text" class="form-control" placeholder="操作时间"
                            readonly />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSave">保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
          </form>
        </div>
    </div>
    <div class="modal fade" id="auditModal">
        <div class="modal-dialog">
          <form id="form_audit" name="form_audit" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">查阅/审核学生修改信息</h4>
            </div>
            <div class="modal-body">

                    <iframe id="auditFrame" frameborder="0" src="" style="width: 100%;"></iframe>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
          </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "NUMBER", "head": "学号", "type": "td-keep" },
				{ "data": "NAME", "head": "姓名", "type": "td-keep" },
                { "data": 'RET_CHANNEL', "head": '当前状态', "type": "td-keep" },
				{ "data": "SEX_NAME", "head": "性别", "type": "td-keep" },
				{ "data": 'IDCARDNO', "head": '身份证号', "type": "td-keep" },
				{ "data": 'GARDE', "head": '出生日期', "type": "td-keep" },
				{ "data": 'COLLEGE_NAME', "head": '学院', "type": "td-keep" },
				{ "data": 'MAJOR_NAME', "head": '专业', "type": "td-keep" },
				{ "data": 'NATION_NAME', "head": '民族', "type": "td-keep" },
				{ "data": 'POLISTATUS_NAME', "head": '政治面貌', "type": "td-keep" },
				{ "data": 'CLASS_NAME', "head": '班级', "type": "td-keep" }
			];

            //配置表格
            tablePackage.createOne({
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
                    tableTitle: "修改审核",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': false, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(3)');
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
						{ "data": "COLLEGE", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "MAJOR", "pre": "专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
						{ "data": "CLASS", "pre": "班级", "col": 3, "type": "select", "ddl_name": "ddl_class" },
						{ "data": "NUMBER", "pre": "学号", "col": 4, "type": "input" },
						{ "data": "NAME", "pre": "姓名", "col": 5, "type": "input" },
						{ "data": "IDCARDNO", "pre": "身份证号", "col": 6, "type": "input" },
                        { "data": "RET_CHANNEL", "pre": "当前状态", "col": 7, "type": "select", "ddl_name": "ddl_RET_CHANNEL_StuModi" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                { type: "enter", modal: null, title: "查阅/审核", action: "audit" },
                { type: "userDefined", id: "audit_pass", title: "批量审核通过", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "audit_nopass", title: "批量审核不通过", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "history", title: "审核流程跟踪", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });

            $(document).on("click", "button[data-action='audit']", function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    if (data.OID) {
                        var strUrl = 'List.aspx?optype=iscanaudit&doc_type=' + data.DOC_TYPE + '&seq_no=' + data.SEQ_NO + '&ret_channel=' + data.RET_CHANNEL;
                        var strResult = AjaxUtils.getResponseText(strUrl);
                        var auditurl = '';
                        //有审核权限的，显示对比信息
                        if (strResult == 'true')
                            auditurl = "Audit.aspx?optype=audit&number=" + data.NUMBER + "&id=" + data.OID + "&t=" + Math.random();
                        else
                            auditurl = "Edit.aspx?optype=view&number=" + data.NUMBER + "&id=" + data.OID + "&t=" + Math.random();

                        $("#auditFrame").attr("src", auditurl);
                        $("#auditModal").modal();
                        $("#auditModal .modal-dialog").css({ "width": "100%", "margin": "0", "padding": "0" });
                        $("#auditModal .modal-body").outerHeight($(window).height() - $("#auditModal .modal-header").outerHeight() - $("#auditModal .modal-footer").outerHeight());
                        $("#auditFrame").height($("#auditModal .modal-body").height());
                    }
                }
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
                        var data = tablePackage.selectSingle();
                        if (data) {
                            if (data.OID) {
                                return true;
                            }
                        }
                        return false;
                    },
                    "afterShow": function (btn, form) {//返回btn信息和form信息
                        var data = tablePackage.selectSingle();
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
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });

            //批量审核通过
            _content.on('click', "#audit_pass", function () {
                MultiAudit('P');
            });

            //批量审核不通过
            _content.on('click', "#audit_nopass", function () {
                MultiAudit('N');
            });
        }
    </script>
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //------------------主列表按钮事件------------------
        //批量审核通过
        function MultiAudit(flag) {
            var datas = tablePackage.selection();
            var strOids = "";
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].OID.length == 0)
                    continue;
                strOids += datas[i].OID + ",";
            }
            var result = AjaxUtils.getResponseText('List.aspx?optype=multiaudit&flag=' + flag + '&ids=' + strOids);
            if (result.length == 0) {
                easyAlert.timeShow({
                    "content": "批量审批成功！",
                    "duration": 2,
                    "type": "info"
                });
                tablePackage.reload();
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
    <!-- 自定义实现JS 结束-->
</asp:Content>
