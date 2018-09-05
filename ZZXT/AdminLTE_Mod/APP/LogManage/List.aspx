<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.APP.LogManage.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .datepicker
        {
            z-index: 9999;
        }
    </style>
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();
            loadTableList();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>操作日志</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">操作日志</li>
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
    <div class="modal" id="delModal">
        <div class="modal-dialog">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">按时间段删除日志</h4>
            </div>
            <div class="modal-body">

                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        起始删除时间</label>
                    <div class="col-sm-8" style="position: relative; z-index: 999;">
                        <input id="Fromdate" name="Fromdate" type="text" class="form-control datep" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        截止删除时间</label>
                    <div class="col-sm-8" style="position: relative; z-index: 999;">
                        <input id="toDATE" name="toDATE" type="text" class="form-control datep" />
                    </div>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-delete" id="btnDel">删除</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
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
				{ "data": "MODEL", "head": "模块名称", "type": "td-keep" },
				{ "data": "ACTION_TYPE", "head": "操作类型", "type": "td-keep" },
				{ "data": 'RECORD_TYPE', "head": '日志记录类型', "type": "td-keep" },
				{ "data": 'LOG_MESSAGE', "head": '日志内容', "type": "td-keep" },
				{ "data": 'IP', "head": 'IP地址', "type": "td-keep" },
				{ "data": 'OP_CODE', "head": '操作人代码', "type": "td-keep" },
                { "data": 'OP_NAME', "head": '操作人', "type": "td-keep" },
				{ "data": 'LOG_DATE', "head": '记录时间', "type": "td-keep" }
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
                    tableTitle: "操作日志",
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
						{ "data": "RECORD_TYPE", "pre": "日志记录类型", "col": 1, "type": "select", "ddl_name": "ddl_log_record_type" },
						{ "data": "ACTION_TYPE", "pre": "操作类型", "col": 2, "type": "select", "ddl_name": "ddl_log_action_type" },
						{ "data": "OP_CODE", "pre": "操作人代码", "col": 3, "type": "input" },
                        { "data": "OP_NAME", "pre": "操作人", "col": 3, "type": "input" },
						{ "data": "LOG_DATE", "pre": "日志记录时间", "col": 4, "type": "timeSingle" },
						{ "data": "LOG_DATE2", "pre": "至", "col": 5, "type": "timeSingle" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "del"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <script type="text/javascript">
        $(function () {
            ValidateUtils.setRequired("#form_edit", "Fromdate", true, "起始删除时间必填");
            ValidateUtils.setRequired("#form_edit", "toDATE", true, "截止删除时间必填");
            /*$(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });*/
            lay('.datep').each(function(inx, element){
              //TODO 实例化 遍历
              laydate.render({
                elem: this,
                trigger: 'click',
              });
            });
            //列表内容，以及按钮
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });

            $(document).on("click", ".btn-del", function () {
                $("#delModal").modal();
            });

            $("#btnDel").click(function () {
                if ($("#form_edit").valid()) {
                    var Fromdate = $("#Fromdate").val();
                    var toDATE = $("#toDATE").val();
                    $.post("?optype=del", { Fromdate: Fromdate, toDATE: toDATE }, function (msg) {
                        if (msg.length != 0) {
                            easyAlert.timeShow({
                                "content": msg,
                                "duration": 2,
                                "type": "danger"
                            });
                            $("#delModal").modal("hide");
                            return;
                        }
                        else {
                            //保存成功：关闭界面，刷新列表
                            easyAlert.timeShow({
                                "content": "删除成功！",
                                "duration": 2,
                                "type": "success"
                            });
                            $("#delModal").modal("hide");
                            tablePackage.reload();
                        }
                    })
                }
            });
        })
    </script>
</asp:Content>
