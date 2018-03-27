<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="SelStudent.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.ClassGroup.SelStudent" %>

<%@ Register Assembly="HQ.WebControl" Namespace="HQ.WebControl" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            /*表格要撑满父iframe，需先得到父iframe的高度*/
            if (window.parent) {
                var ph = $("iframe:visible", window.parent.document).eq(0).height();
                $("#main").css({ height: ph - $("#searchDiv").height() - 80});

            }
            /*以下为表格属性*/
            //固定的列
            var fCol = [[
            { field: 'ck', checkbox: true, width: 100 },
            { field: 'NUMBER', title: '学号', width: 150 },
            { field: 'NAME', title: '姓名', width: 100 }
            ]];
            //其他显示的列
            var cols = [[
             { field: 'SEX', title: '性别', width: 50, sortable: true },
             { field: 'IDCARDNO', title: '身份证号', width: 150, sortable: true },
             { field: 'GARDE', title: '出生日期', width: 120, sortable: true },
             { field: 'COLLEGE', title: '学院', width: 150, sortable: true },
             { field: 'MAJOR', title: '专业', width: 150, sortable: true },
             { field: 'NATION', title: '民族', width: 100, sortable: true },
             { field: 'POLISTATUS', title: '政治面貌', width: 150, sortable: true },
             { field: 'CLASS', title: '班级', width: 150, sortable: true }
             ]];

             			/*查询参数，json格式，一般通过查询控件绑定，也可以自定义如: {'code':'001','name':'doublesun'}*/
			var paras = <%= QuerySearchInit.Params %>;

            //定义表格的工具栏按钮
            var tBar = [{
                text: '刷新',
                iconCls: 'icon-reload',
                handler: function () {
                    DataGridUtils.refreshData('tabList');
                }
            }, '-', {
                text: '确认',
                iconCls: 'icon-ok',
                handler: function () {
                    var rows = DataGridUtils.getDataRowsSelected('#tabList'); //取得选中行的键值
                    if (rows.length == 0) {
                        MsgUtils.info("请选择辅导员！");
                        return;
                    }
                    var url = MiscUtils.FormatUrl('SelStudent.aspx?optype=save&classcode=<%=Request.QueryString["classcode"]%>&stu=' + encodeURI(rows[0].NUMBER)+'&name='+encodeURI(rows[0].NAME));
                    if (result.length > 0) {
                        MsgUtils.info(result);
                        return;
                    }
                    parent.$('#editDiv').dialog('close');
                    parent.$('#tabList').datagrid('reload');
                }
            }, '-', {
                text: '返回',
                iconCls: 'icon-back',
                handler: function () {
                    parent.$('#editDiv').dialog('close');
                }
            }];

            //表格构造
            var getlist_url = 'SelStudent.aspx?optype=getlist';
    		DataGridUtils.createDefaultDataGrid('tabList',getlist_url,paras,fCol,cols,tBar,null);
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div id="searchDiv" style="height: 30px;">
        <div style="height: 5px;">
        </div>
        <cc1:QueryFieldInit ID="QuerySearchInit" runat="server" QueryName="Stu_Basic_Info_Query"
            TableId="tabList" />
    </div>
    <div id="main" style="width: 100%;">
        <table id="tabList">
        </table>
    </div>
</asp:Content>