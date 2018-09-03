<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.ClassGroup.List" %>

<%@ Register Assembly="HQ.WebControl" Namespace="HQ.WebControl" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
    	$(function () {
            /*表格要撑满父iframe，需先得到父iframe的高度*/
            if (window.parent) {
                var ph = Math.max(document.documentElement.clientHeight, document.body.clientHeight);
                $("#main").css({ height: ph - $("#searchDiv").height()});
            }
            /*以下为表格属性*/
            //固定的列
            var fCol = [[
            { field: 'RN', title: '序号', width: 60 },
            { field: 'XY',title: '学院', width: 150 },
            { field: 'XSH',title: '系所', width: 150 },
            { field: 'ZY',  title: '专业', width: 120 },
            { field: 'GRADE',  title: '年级', width: 100 },
            { field: 'CLASSNAME',  title: '班级', width: 150 }
            ]];
            //其他显示的列
            var cols = [[
             { field: 'GROUP_NUMBER',title: '班级辅导员工号', width: 120, sortable: true },
             { field: 'GROUP_NAME',title: '班级辅导员姓名', width: 100, sortable: true },
             { field: 'GROUP_TYPE',title: '班级辅导员类型', width: 100, sortable: true },
             { field: 'CHK_STATUS',title: '单据状态', width: 120, sortable: true },
             { field: 'OP_NAME', title: '申报人', width: 120, sortable: true },
             { field: 'DECL_TIME', title: '申报时间', width: 120, sortable: true },
             { field: 'CHK_TIME', title: '审批时间', width: 150, sortable: true },
             { field: 'SEQ_NO', title: '单据编号', width: 150, sortable: true }
             ]];

            /*查询参数，json格式，一般通过查询控件绑定，也可以自定义如: {'code':'001','name':'doublesun'}*/
            var paras = <%= QuerySearch.Params %>;

             //定义表格的工具栏按钮
            var tBar = [{
                text: '刷新',
                iconCls: 'icon-reload',
                handler: function () {
                    DataGridUtils.refreshData("tabList");
                }
            },'-', {
                text: '设置班级辅导员',
                iconCls: 'icon-add',
                handler: function () {
                    var rows = $('#tabList').datagrid('getSelections');
                    if (rows.length == 0)
                    {
                        MsgUtils.info("请选择数据！");
                        return;
                    }
                    if (rows[0].OID.length > 0)
                    {
                        //判断是否可以设置
                        var url = MiscUtils.FormatUrl("List.aspx?optype=chk&id="+rows[0].OID);
                        var result = AjaxUtils.getResponseText(url);
                        if (result.length > 0)
                        {
                            MsgUtils.info(result);
                            return;
                        }
                    }
                    DialogUtils.showDataDialog('editDiv', 'editFrame', '设置班级辅导员', 'SelTeacher.aspx?classcode='+rows[0].CLASSCODE);
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
                var url = MiscUtils.FormatUrl("List.aspx?optype=chk&id="+rowData.OID);
                var result = AjaxUtils.getResponseText(url);
                if (result.length > 0)
                {
                    MsgUtils.info(result);
                    return;
                }
				DialogUtils.showDataDialog('editDiv', 'editFrame', '设置班级辅导员', 'SelTeacher.aspx?classcode='+rowData.CLASSCODE);
			}

			DataGridUtils.createDefaultDataGrid('tabList',getlist_url,paras,fCol,cols,tBar,showViewDialog);
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div id="searchDiv" style="height: 60px;">
        <div style="height: 5px;">
        </div>
        <cc1:QueryField ID="QuerySearch" runat="server" QueryName="Group_Class_Query" TableId="tabList" />
    </div>
    <div id="main" style="width: 100%;">
        <table id="tabList">
        </table>
    </div>
    <div id="editDiv" style="width: 900px; height: 500px; display: none;">
        <iframe id="editFrame" frameborder="0" src="" style="width: 100%; height: 100%;">
        </iframe>
    </div>
</asp:Content>