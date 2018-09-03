<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.APP.WkfManage.WkfQueue.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();

            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>审核队列</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">审核队列</li>
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
    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "DOC_TYPE", "head": "业务单据", "type": "td-keep" },
				    { "data": "DOC_NO", "head": "单据编号", "type": "td-keep" },
				    { "data": "DECLARE_TYPE", "head": "申报类型", "type": "td-keep" },
				    { "data": "STEP_NO", "head": "步骤类型", "type": "td-keep" },
				    { "data": "RET_CHANNEL", "head": "单据状态", "type": "td-keep" },
				    { "data": "OP_USER_NAME", "head": "操作人", "type": "td-keep" },
				    { "data": "OP_TIME", "head": "操作时间", "type": "td-keep" },
				    { "data": "HANDLE_STATUS", "head": "处理标识", "type": "td-keep" },
                    { "data": "HANDLE_TIME", "head": "处理时间", "type": "td-keep" },
                    { "data": "HANDLE_MSG", "head": "异常原因", "type": "td-keep" }
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
                    tableTitle: "审批流转队列",
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
					    { "data": "DOC_TYPE", "pre": "业务单据", "col": 1, "type": "select", "ddl_name": "ddl_doc_type_needflow" },
					    { "data": "DOC_NO", "pre": "单据编号", "col": 2, "type": "input" },
                        { "data": "DECLARE_TYPE", "pre": "申报类型", "col": 3, "type": "select", "ddl_name": "ddl_DECLARE_TYPE" },
                        { "data": "HANDLE_STATUS", "pre": "处理标识", "col": 4, "type": "select", "ddl_name": "ddl_queue_status" },
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "del",
                { type: "enter", modal: null, title: "重新处理", action: "update" },
                { type: "enter", modal: null, title: "解除锁单", action: "remove"}], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //重新处理 按钮事件
            $(document).on("click", "button[data-action='update']", function () {
                var data = tablePackage.selectSingle();
                if (!data.OID) {
                    easyAlert.timeShow({
                        "content": "请选中一行数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                var result = AjaxUtils.getResponseText("List.aspx?optype=update&id=" + data.OID);
                if (result.length == 0) {
                    easyAlert.timeShow({
                        "content": "重新处理成功！",
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
            });
            //解除锁单 按钮事件
            $(document).on("click", "button[data-action='remove']", function () {
                var data = tablePackage.selectSingle();
                if (!data.OID) {
                    easyAlert.timeShow({
                        "content": "请选中一行数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                var result = AjaxUtils.getResponseText("List.aspx?optype=remove&id=" + data.OID);
                if (result.length == 0) {
                    easyAlert.timeShow({
                        "content": "解除锁单处理成功！",
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
            });
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload',
				    del: '.btn-del'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });

            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
        }

        //删除事件
        function DeleteData() {
            var data = tablePackage.selectSingle();
            if (data) {
                if (data.OID) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除选中的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            var result = AjaxUtils.getResponseText("List.aspx?optype=delete&id=" + data.OID);
                            if (result.length != 0) {
                                $(".Confirm_Div").modal("hide");
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }
                            else {
                                $(".Confirm_Div").modal("hide");
                                //保存成功：关闭界面，刷新列表
                                easyAlert.timeShow({
                                    "content": "删除成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                tablePackage.reload();
                            }
                        }
                    });
                }
            }
        }
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        }
    </script>
    <!-- 编辑页验证事件-->
    <script type="text/javascript">
        function loadModalPageValidate() {
        }
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>