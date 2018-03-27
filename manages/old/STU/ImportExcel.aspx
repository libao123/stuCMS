<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ImportExcel.aspx.cs" Inherits="PorteffAnaly.Web.BDM.STU.ImportExcel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="Form1" runat="server">
    <div style="font-size: 14px; padding: 20px;">
        <table style="padding-top: 20px; text-align: center; width: 100%;">
            <tr>
                <td>
                    选择Excel文件：<input id="userfile" name="userfile" type="file" runat="server" />
                </td>
            </tr>
        </table>
        <table style="padding-top: 20px; width: 100%;">
            <tr>
                <td style="width: 50%; text-align: right; padding-right: 20px;">
                    <asp:LinkButton ID="saveBtn" runat="server" class="easyui-linkbutton" iconCls="icon-ok"
                        OnClientClick="return check();" OnClick="saveBtn_Click">导入</asp:LinkButton>
                </td>
                <td style="width: 50%; text-align: left; padding-left: 20px;">
                    <a href="#" class="easyui-linkbutton" iconcls="icon-back" onclick="parent.$('#divImportExcel').dialog('close');">
                        取消</a>
                </td>
            </tr>
        </table>
    </div>
    <script type="text/javascript">
        function check() {
            if (!($('#<%=userfile.ClientID %>').val().length > 0)) {
                $.messager.alert('提示', '请选择要导入的EXCEL文件', 'error');
                return false;
            }
        }
        function modiDataExcel(tabCtrId) {
            $.messager.alert('提示', '导入成功', 'info', function () { parent.$("#excelDiv").dialog('close'); parent.$('#' + tabCtrId).datagrid("reload"); });
        }
        function modiFailExcel(val, tabCtrId) {
            $.messager.alert('提示', val, 'error', function () { window.location = window.location; parent.$('#' + tabCtrId).datagrid("reload"); });
        }
    </script>
    </form>
</asp:Content>