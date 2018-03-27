<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Edit.aspx.cs" Inherits="PorteffAnaly.Web.BDM.Notice.Edit" ValidateRequest="false" %>

<%@ OutputCache Duration="1" VaryByParam="none" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="/Scripts/ckeditor/ckeditor.js"></script>
    <script type="text/javascript">
        $(function () {
            var editorid = "<%=ck_editor.ClientID %>";
            loadEditor(editorid);
            CKEDITOR.on('instanceReady', function (e) {
                PageUtils.initComboBox();
            });
        });

        function loadEditor(id) {
            var instance = CKEDITOR.instances[id];
            if (instance) {
                CKEDITOR.remove(instance);
            }
            CKEDITOR.replace(id, { customConfig: '/Scripts/ckeditor/config.js' });
        }

        function GetCheckBoxSelected() {
            var checkbox = "";
            $("#<%=hidUserRoles.ClientID %>").val("");
            $("input[type='checkbox'][name='user_role']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).attr('value') + ',';
                }
            });
            if (checkbox.length > 0) {
                $("#<%=hidUserRoles.ClientID %>").val(checkbox);
            }
        }

        //提交
        function submitChk() {
            if (FormUtils.validateForm() == false) {
                MsgUtils.info("请输入必填项！");
                return false;
            }

            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="f1" runat="server" onsubmit="">
    <div class="toolbar" style="height: 30px; line-height: 30px; text-align: left;">
        <asp:LinkButton ID="saveBtn" runat="server" class="easyui-linkbutton" plain="true"
            iconCls="icon-save" OnClientClick="return submitChk();" OnClick="saveBtn_Click">暂存</asp:LinkButton>
        <a id="btnBack" href="#" class="easyui-linkbutton" plain="true" iconcls="icon-back"
            onclick="parent.$('#editDiv').dialog('close');">返回</a>
    </div>
    <table class="form-tb" style="width: 98%; margin: 10px;">
        <tr>
            <td class="label-bg" style="width: 100px;">
                信息分类<span style="color: Red;">*</span>
            </td>
            <td colspan="3">
                <select id="NOTICE_TYPE" class="easyui-combobox" name="NOTICE_TYPE" style="width: 300px;"
                    ddl_name='ddl_notice_type' d_value='<%=head.NOTICE_TYPE %>' panelheight='60'
                    title="信息分类" show_type='t' required="true">
                </select>
            </td>
        </tr>
        <tr>
            <td class="label-bg">
                标题<span style="color: Red;">*</span>
            </td>
            <td colspan="3">
                <input type="text" id="TITLE" name="TITLE" style="width: 99%;" class="easyui-validatebox input-text"
                    required="true" value="<%=head.TITLE %>" maxlength="255" />
            </td>
        </tr>
        <tr>
            <td class="label-bg">
                副标题
            </td>
            <td colspan="3">
                <input type="text" id="SUB_TITLE" name="SUB_TITLE" style="width: 99%;" class="easyui-validatebox input-text"
                    value="<%=head.SUB_TITLE %>" maxlength="255" />
            </td>
        </tr>
        <tr>
            <td class="label-bg">
                有效时间
            </td>
            <td>
                <input type="text" id="START_TIME" name="START_TIME" style="width: 99%;" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                    class="easyui-validatebox input-text" value="<%= head.START_TIME %>" />
            </td>
            <td class="label-bg">
                至
            </td>
            <td>
                <input type="text" id="END_TIME" name="END_TIME" style="width: 99%;" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
                    class="easyui-validatebox input-text" value="<%= head.END_TIME %>" />
            </td>
        </tr>
        <tr>
            <td class="label-bg">
                查阅角色
            </td>
            <td colspan="3">
                <div runat="server" id="divUserRole" style="margin-top: 5px;">
                </div>
            </td>
        </tr>
        <tr>
            <td class="label-bg">
                发布内容<span style="color: Red;">*</span>
            </td>
            <td colspan="3">
                <textarea id="ck_editor" name="ck_editor" cols="10" rows="10" runat="server"></textarea>
            </td>
        </tr>
    </table>
    <input type="hidden" id="hidUserRoles" name="hidUserRoles" runat="server" />
    </form>
</asp:Content>