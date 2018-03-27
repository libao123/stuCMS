<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.BDM.Notice.List" %>

<%@ Register Assembly="HQ.WebControl" Namespace="HQ.WebControl" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
		$(function () {
			/*表格要撑满父iframe，需先得到父iframe的高度*/
			if (window.parent) {
				var ph = $("iframe:visible", window.parent.document).eq(0).height();
				$("#main").css({ height: ph - $("#searchDiv").height() -10  });
			}

			/*以下为表格属性*/
			//固定的列
			var fCol = [[{ field: 'ck', checkbox: true, width: 100}]];
			//其他显示的列
			var cols = [[
             { field: 'NOTICE_TYPE', title: '信息类型', width: 100, sortable: true },
             { field: 'TITLE', title: '标题', width: 400, sortable: true },
             { field: 'START_TIME', title: '信息有效开始时间', width: 150, sortable: true },
             { field: 'END_TIME', title: '信息有效结束时间', width: 150, sortable: true },
             { field: 'ROLEID', title: '可查阅角色', width: 200, sortable: true },
             { field: 'SEND_NAME', title: '发布人', width: 100, sortable: true },
             { field: 'SEND_TIME', title: '发布时间', width: 150, sortable: true }
			]];

			/*查询参数，json格式，一般通过查询控件绑定，也可以自定义如: {'code':'001','name':'doublesun'}*/
			var paras = <%= QuerySearch.Params %>;

			//定义表格的工具栏按钮
			var tBar = [{
				text: '刷新',
				iconCls: 'icon-reload',
				handler: function () {
                    DataGridUtils.refreshData("tabList");//刷新列表
				}
			}, '-', {
				text: '查阅预览',
				iconCls: 'icon-search',
				handler: function () {
                    DialogUtils.showEditDataDialog("editDiv","editFrame","tabList","查阅预览",'Show.aspx?optype=view',"OID");
				}
			}, '-', {
                text: '新增',
                iconCls: 'icon-add',
                handler: function () {
                    DialogUtils.showDataDialog("editDiv","editFrame","新增信息",'Edit.aspx?optype=add');
                }
            }, '-', {
                text: '修改',
                iconCls: 'icon-edit',
                handler: function () {
                    DialogUtils.showEditDataDialog("editDiv","editFrame","tabList", "修改信息",  'Edit.aspx?optype=modi', "OID");
                }
            },'-', {
                text: '删除',
                iconCls: 'icon-cancel',
                handler: function () {
                    DialogUtils.showDeleteDataDialog("tabList", "List.aspx?optype=delete", "确定删除该数据吗？", "OID");
                }
            },'-', {
					text: '退出',
					iconCls: 'icon-back',
					handler: function () {
						parent.window.closeCurTab();
					}
				}];

			//表格构造
			var getlist_url='List.aspx?optype=getlist';
			//双击数据行，显示函数
			function showViewDialog(rowIndex,rowData){
				DialogUtils.showEditDataDialog("editDiv","editFrame","tabList", "查阅预览",  'Show.aspx?optype=view', "OID");
			}

			DataGridUtils.createDefaultDataGrid('tabList',getlist_url,paras,fCol,cols,tBar,showViewDialog);
		});
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div id="searchDiv" style="height: 30px;">
        <div style="height: 5px;">
        </div>
        <cc1:QueryField ID="QuerySearch" runat="server" QueryName="NoticeInfo_Query" TableId="tabList" />
    </div>
    <div id="main" style="width: 100%;">
        <table id="tabList">
        </table>
    </div>
    <div id="editDiv" style="width: 1000px; height: 700px; display: none;">
        <iframe id="editFrame" frameborder="0" src="" style="width: 100%; height: 100%;">
        </iframe>
    </div>
</asp:Content>