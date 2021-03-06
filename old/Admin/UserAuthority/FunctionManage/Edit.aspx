﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Edit.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.FunctionManage.Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            var ph = $("iframe:visible", window.parent.document).eq(0).height();
            var pw = $("iframe:visible", window.parent.document).eq(0).width();

            SetCheckBoxSelect();
        }
        function SetCheckBoxSelect() {
            $("input:checkbox").each(function () {
                if ($(this).val() == '1') {
                    $(this).attr("checked", "true")
                }
            });
        }

        function ShowDiv(optype) {
            parent.$("#editFrame").attr("src", 'MenuEdit.aspx?optype=' + optype + '&id=<%=model.FUNCTIONID %>');
            parent.$("#editDiv").show().dialog({ title: '功能菜单', modal: true, draggable: false });
        }
        function Delete() {
            var result = AjaxText("List.aspx?optype=del&id=<%= model.FUNCTIONID %>");
            $.messager.alert('提示', result, 'info', function () {
                if (result.indexOf('成功') > 0) {
                    parent.$("#tt").tree("reload");
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="f1" runat="server">
    <div style="height: 30px; line-height: 30px; background: #efefef;" class="toolbar">
        <a href="javascript:ShowDiv('add')" class="easyui-linkbutton" plain="true" iconcls="icon-add">
            录入子菜单</a> <a href="javascript:ShowDiv('modi')" class="easyui-linkbutton" plain="true"
                iconcls="icon-edit">修改</a><a href="javascript:Delete()" class="easyui-linkbutton"
                    plain="true" iconcls="icon-decl">删除</a>
    </div>
    <div>
        <table class="form-tb" width="100%">
            <tr>
                <td class="label-bg">
                    名称
                </td>
                <td>
                    <%= model.NAME%>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    功能描述
                </td>
                <td>
                    <%= model.DESCRIPTION%>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    页面地址
                </td>
                <td>
                    <%= model.URL%>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    排序
                </td>
                <td>
                    <%= model.SEQUENCE%>
                </td>
            </tr>
        </table>
        <table style="margin: 10px 0px 10px 0px;">
            <tr>
                <td style="padding-top: 3px; padding-left: 15px;">
                    显示为菜单
                </td>
                <td style="padding-left: 10px;">
                    <input id="SHOWINMENU" type="checkbox" name="SHOWINMENU" value="<%=model.SHOWINMENU %>"
                        onclick="return  false">
                </td>
            </tr>
        </table>
        <table class="form-tb" width="100%">
            <tr>
                <td class="label-bg" width="100">
                    已分配岗位
                </td>
                <td>
                    <%=getRole4FunId(model.FUNCTIONID)%>
                </td>
            </tr>
        </table>
    </div>
    <div style="padding: 5px; color: Red;">
        说明：<br />
        1.菜单管理是最高级别，不能修改和删除!
        <br />
        2.菜单存在子菜单则不能删除!
    </div>
    </form>
</asp:Content>