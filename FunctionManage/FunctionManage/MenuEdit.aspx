<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="MenuEdit.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.FunctionManage.MenuEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            SetCheckBoxSelect();
            PageUtils.initComboBox(); //初始化下拉框
        }
        function SetCheckBoxSelect() {
            $("input:checkbox").each(function () {
                if ($(this).val() == '1') {
                    $(this).attr("checked", "true")
                }
            });
        }
        function SetCheckBoxValue(id) {
            if ($('#' + id).attr("checked") == true) {
                $('#' + id).val("1");
            }
            else {
                $('#' + id).val("0");
            }
        }
        function ExcuParentFunction(val) {
            $.messager.alert('提示', val, 'info', function () {
                if ('<%=Request.QueryString["optype"] %>' == 'modi') {
                    parent.window.EditOK('<%=model.FUNCTIONID %>');
                }
                else {
                    parent.window.AddOK();
                }
            });
        }
        function modiFail(val) {
            $.messager.alert('提示', val, 'info', function () { window.location = window.location; });
            return;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="f1" runat="server" onsubmit="if($('#f1').form('validate')==false){return false;}else{}">
    <div style="height: 30px; line-height: 30px; background: #efefef;" class="toolbar">
        <asp:LinkButton ID="saveBtn" runat="server" class="easyui-linkbutton" plain="true"
            iconCls="icon-save" OnClick="saveBtn_Click">保存</asp:LinkButton>
        <a href="#" class="easyui-linkbutton" plain="true" iconcls="icon-back" onclick="parent.$('#editDiv').dialog('close');">
            返回</a>
    </div>
    <div>
        <table class="form-tb" style="width: 100%;">
            <tr>
                <td class="label-bg">
                    名称<span style="color: Red;">*</span>
                </td>
                <td colspan="5">
                    <input type="text" id="NAME" name="NAME" class="easyui-validatebox input-text" required="true"
                        value="<%=model.NAME %>" style="width: 83%;" />
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    页面地址
                </td>
                <td colspan="5">
                    <input type="text" id="URL" name="URL" class="easyui-validatebox input-text" value="<%=model.URL %>"
                        style="width: 83%;" />
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    功能描述
                </td>
                <td colspan="5">
                    <textarea class="easyui-validatebox input-text" id="DESCRIPTION" name="DESCRIPTION"
                        style="height: 60px; width: 83%;"><%=model.DESCRIPTION%></textarea>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    显示顺序
                </td>
                <td colspan="5">
                    <input type="text" id="SEQUENCE" name="SEQUENCE" class="easyui-numberbox input-text"
                        required="false" value="<%=model.SEQUENCE %>" style="width: 83%;" />
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    显示为菜单
                </td>
                <td style="padding-left: 10px;" colspan="5">
                    <input id="SHOWINMENU" type="checkbox" name="SHOWINMENU" value="<%=model.SHOWINMENU %>"
                        onclick="SetCheckBoxValue('SHOWINMENU')" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</asp:Content>