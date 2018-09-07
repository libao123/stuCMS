<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="ToDo.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter.ToDo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();

            loadTableList();
            loadModalBtnInit();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
		<section class="content-header">
			<h1>代办事项</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>个人中心</li>
				<li class="active">代办事项</li>
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
				{ "data": "DOC_TYPE", "head": "代办事项", "type": "td-keep" }
                <%if (user.User_Role.Equals("S")) { %>
                , { "data": "RET_CHANNEL", "head": "状态", "type": "td-keep" }
                <% } else { %>
                , { "data": "QTY", "head": "待审数量", "type": "td-keep" }
                <% } %>
			];

            //配置表格
            tablePackage.createOne({
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
                    tableTitle: "代办事项",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 100, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload"
                <%if (user.User_Role.Equals("S")) { %>
                , { type: "userDefined", id: "history", title: "审核流程跟踪", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } }
                <% } %>
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
				    reload: '.btn-reload'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });

            //【审核流程跟踪】
            //------------------审核流程跟踪 开始------------------------------------------
            var wfklog = WfkLog.createOne({
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
</asp:Content>