<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="AccpterList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Msg.AccpterList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            adaptionHeight();
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
			<h1>已接收信息</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>个人中心</li>
				<li class="active">已接收信息</li>
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
                { "data": "MSG_TYPE", "head": "信息类型", "type": "td-keep" },
				{ "data": "MSG_CONTENT", "head": "信息内容", "type": "td-keep" },
                { "data": "IS_READ", "head": "是否已读", "type": "td-keep" },
				{ "data": 'SEND_NAME', "head": '发送人', "type": "td-keep" },
				{ "data": 'SEND_TIME', "head": '发送时间', "type": "td-keep" }
			];

            //配置表格
            tablePackage.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "AccpterList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "已接收信息",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(3)');
                            if (aData.IS_READ == "Y") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "是"
                                    });
                            }
                            else {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "否"
                                    });
                            }
                        }
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
                        { "data": "MSG_TYPE", "pre": "信息类型", "col": 1, "type": "select", "ddl_name": "ddl_msg_type" },
                        { "data": "IS_READ", "pre": "是否已读", "col": 2, "type": "select", "ddl_name": "ddl_yes_no" },
						{ "data": "MSG_CONTENT", "pre": "信息内容", "col": 3, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                { type: "userDefined", id: "mark", title: "已读", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload',
				    del: '.btn-del'
				};

            //【刷新】
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });

            //【已读】
            _content.on('click', "#mark", function () {
                MarkData();
            });
        }

        //标记事件
        function MarkData() {
            var data = tablePackage.selectSingle();
            if (data) {
                if (data.OID) {
                    var result = AjaxUtils.getResponseText("AccpterList.aspx?optype=mark&id=" + data.OID);
                    if (result.length == 0) {
                        easyAlert.timeShow({
                            "content": "标记已读成功！",
                            "duration": 2,
                            "type": "info"
                        });
                        tablePackage.reload();
                        return;
                    }
                    else {
                        easyAlert.timeShow({
                            "content": "标记已读失败！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
            }
        }
    </script>
</asp:Content>