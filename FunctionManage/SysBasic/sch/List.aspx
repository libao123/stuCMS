<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.SysBasic.sch.List" ValidateRequest="false"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            PageUtils.initComboBox();
        });

        //保存
        function SaveInfo() {
            if (FormUtils.validateForm() == false) {
                MsgUtils.info("请输入必填项！");
                return false;
            }

            $.post(MiscUtils.FormatUrl('List.aspx?optype=save'),
            $("#form_sch").serialize(), function (msg) {
                if (msg.length == 0) {
                    MsgUtils.info("保存失败！");
                    return false;
                }
            });

            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="form_sch">
        <input type="hidden" name="SCHOOL_CODE" id="SCHOOL_CODE" value="<%=head.SCHOOL_CODE %>" />
        <div class="toolbar" style="height: 30px; line-height: 30px; text-align: left;">
            <a id="saveBtn" href="#" class="easyui-linkbutton" plain="true" iconcls="icon-save"
                onclick="return SaveInfo();">保存</a>
        </div>
        <table class="form-tb" style="width: 95%; margin: 10px;">
            <tr>
                <td class="label-bg" style="width: 80px;">
                    学校名称<span style="color: Red;">*</span>
                </td>
                <td>
                    <input type="text" id="SCHOOL_NAME" name="SCHOOL_NAME" style="width: 250px;" class="easyui-validatebox input-text"
                        value="<%=head.SCHOOL_NAME%>" required="true" maxlength="25" />
                </td>
            </tr>
            <tr>
                <td class="label-bg" style="width: 80px;">
                    当前学年<span style="color: Red;">*</span>
                </td>
                <td>
                    <select id="CURRENT_YEAR" name="CURRENT_YEAR" show_type='t' style="width: 250px;"
                        class="easyui-combobox" ddl_name='ddl_year_type' d_value='<%=head.CURRENT_YEAR%>'
                        title="当前学年" panelheight="120" required="true">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="label-bg" style="width: 80px;">
                    当前学期<span style="color: Red;">*</span>
                </td>
                <td>
                    <select id="CURRENT_XQ" name="CURRENT_XQ" style="width: 250px;" class="easyui-combobox"
                        ddl_name='ddl_xq' d_value='<%=head.CURRENT_XQ%>' title="当前学期" panelheight="120"
                       show_type='t'  required="true">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="label-bg" style="width: 80px;">
                    简介
                </td>
                <td>
                    <textarea id="REMARK" name="REMARK" style="width: 95%; margin: 10px;" rows="10"><%=head.REMARK%></textarea>
                </td>
            </tr>
        </table>
    </form>
</asp:Content>