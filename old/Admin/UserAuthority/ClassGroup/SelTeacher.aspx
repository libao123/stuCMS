<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="SelTeacher.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.ClassGroup.SelTeacher" %>

<%@ Register Assembly="HQ.WebControl" Namespace="HQ.WebControl" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            /*表格要撑满父iframe，需先得到父iframe的高度*/
			if (window.parent) {
				var ph = Math.max(document.documentElement.clientHeight,document.body.clientHeight);
				$("#main").css({ height: ph - $("#classinfo").height() - $("#searchDiv").height() - 60});
			}

            //标签
            var stu_sign = 0;
            $("#tabDiv").tabs('select', '选择辅导员');
            $("#tabDiv").tabs({
                onSelect: function (title) {
                    if (title == '选择研究生' && stu_sign == 0) {
                        stu_sign = 1;
                        var strUrl = MiscUtils.FormatUrl('SelStudent.aspx');
                        $("#stuFrame").attr("src", strUrl);
                    }
                }
            });

            /*以下为表格属性*/
            //固定的列
            var fCol = [[
            { field: 'ck', checkbox: true, width: 100 },
            { field: 'ENO',title: '职工号', width: 150 },
            { field: 'NAME',  title: '姓名', width: 100 }
            ]];
            //其他显示的列
            var cols = [[
             { field: 'SEX',title: '性别', width: 50, sortable: true },
             { field: 'IDCARDNO',title: '身份证号', width: 150, sortable: true },
             { field: 'GARDE', title: '出生日期', width: 120, sortable: true },
             { field: 'MOBILENUM', title: '联系电话', width: 150, sortable: true },
             { field: 'MAJOR', title: '专业', width: 150, sortable: true },
             { field: 'NATION', title: '民族', width: 100, sortable: true },
             { field: 'POLISTATUS', title: '政治面貌', width: 150, sortable: true },
             { field: 'DEPARTMENT', title: '所在部门名称', width: 150, sortable: true }
             ]];

			/*查询参数，json格式，一般通过查询控件绑定，也可以自定义如: {'code':'001','name':'doublesun'}*/
			var paras = <%= QuerySearchInit.Params %>;

			//定义表格的工具栏按钮
			var tBar = [{
				text: '刷新',
				iconCls: 'icon-reload',
				handler: function () {
                    DataGridUtils.refreshData("tabList");
				}
			},'-', {
				text: '确认',
				iconCls: 'icon-ok',
				handler: function () {
                     var rows = DataGridUtils.getDataRowsSelected('tabList'); //取得选中行的键值
                     if (rows.length == 0)
                     {
                        MsgUtils.info("请选择辅导员！");
                        return;
                     }
                     //加入一个对话框提示（待处理）
                    var url = MiscUtils.FormatUrl('SelTeacher.aspx?optype=save&classcode=<%=Request.QueryString["classcode"]%>&eno='
                    + encodeURI(rows[0].ENO)+'&name='+encodeURI(rows[0].NAME));
                    var result = AjaxUtils.getResponseText(url);
                    if (result.length > 0)
                    {
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
			var getlist_url='SelTeacher.aspx?optype=getlist&classcode=<%=Request.QueryString["classcode"]%>';
			DataGridUtils.createDefaultDataGrid('tabList',getlist_url,paras,fCol,cols,tBar,null);
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div style="width: 95%; margin: 10px;">
        <table class="form-tb" id="classinfo">
            <tr>
                <td class="label-bg" style="width: 80px;">
                    班级代码
                </td>
                <td>
                    <%=head.CLASSCODE%>
                </td>
                <td class="label-bg" style="width: 80px;">
                    班级名称
                </td>
                <td>
                    <%=head.CLASSNAME%>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    学院
                </td>
                <td>
                    <%= cod.GetDDLTextByValue("ddl_department", head.XY)%>
                </td>
                <td class="label-bg">
                    系所
                </td>
                <td>
                    <%= cod.GetDDLTextByValue("ddl_xsh", head.XSH)%>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    专业
                </td>
                <td>
                    <%= cod.GetDDLTextByValue("ddl_zy", head.ZY)%>
                </td>
                <td class="label-bg">
                    年级
                </td>
                <td>
                    <%= cod.GetDDLTextByValue("ddl_grade", head.GRADE)%>
                </td>
            </tr>
        </table>
    </div>
    <div id="tabDiv" class="easyui-tabs" border="false" fit="true">
        <div title="选择辅导员">
            <div id="searchDiv" style="height: 30px;">
                <div style="height: 5px;">
                </div>
                <cc1:QueryFieldInit ID="QuerySearchInit" runat="server" QueryName="Coun_Basic_Info_Query"
                    TableId="tabList" />
            </div>
            <div id="main" style="width: 100%;">
                <table id="tabList">
                </table>
            </div>
        </div>
        <div title="选择研究生">
            <iframe id="stuFrame" scrolling="no" frameborder="0" src="" style="width: 100%; height: 99%;">
            </iframe>
        </div>
    </div>
</asp:Content>