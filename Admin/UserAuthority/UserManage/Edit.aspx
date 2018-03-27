<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Edit.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.UserManage.Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            PageUtils.initComboBox();
        });

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

        //暂存
        function Save() {
            if (FormUtils.validateForm() == false) {
                MsgUtils.info("请输入必填项！");
                return false;
            }

            var userType = $("#USER_TYPE").combobox("getValue");
            var stuType = $("#STU_TYPE").combobox("getValue");
            if (userType == "S" && stuType.length == 0) {
                MsgUtils.info("该用户是学生，请选择学生类型！");
                return false;
            }

            GetCheckBoxSelected();
            if ($("#<%=hidUserRoles.ClientID %>").val().length == 0) {
                MsgUtils.info("请选择用户所属角色！");
                return false;
            }

            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="f1" runat="server" onsubmit='OnFormCommit();'>
    <div id="ContentDiv" style="margin: 5px;">
        <div class="toolbar" style="height: 30px; line-height: 30px; text-align: left;">
            <asp:LinkButton ID="saveBtn" runat="server" class="easyui-linkbutton" plain="true"
                iconCls="icon-save" OnClientClick="return Save()" OnClick="btnSave_Click">保存</asp:LinkButton>
            <a id="btnBack" href="#" class="easyui-linkbutton" plain="true" iconcls="icon-back"
                onclick="parent.$('#editDiv').dialog('close');">返回</a>
        </div>
        <div style="width: 95%; margin: 10px;">
            <table class="form-tb">
                <tr>
                    <td class="label-bg" style="width: 100px;">
                        用户编码<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <input type="text" id="USER_ID" class="easyui-validatebox input-text" name="USER_ID"
                            style="width: 150px;" required="true" value='<%=head.USER_ID %>' maxlength="20" />
                    </td>
                    <td class="label-bg" style="width: 100px;">
                        用户名<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <input type="text" id="USER_NAME" class="easyui-validatebox input-text" name="USER_NAME"
                            style="width: 150px;" required="true" value='<%=head.USER_NAME %>' maxlength="20" />
                    </td>
                </tr>
                <tr>
                    <td class="label-bg" style="width: 100px;">
                        用户类型<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="USER_TYPE" class="easyui-combobox" name="USER_TYPE" style="width: 150px;"
                            d_value='<%=head.USER_TYPE %>' ddl_name='ddl_user_type' show_type='t' title="用户类型"
                            required="true" panelheight="60px;">
                        </select>
                    </td>
                    <td class="label-bg" style="width: 100px;">
                        所属学院<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="UNIT_CODE" class="easyui-combobox" name="UNIT_CODE" style="width: 150px;"
                            d_value='<%=head.UNIT_CODE %>' ddl_name='ddl_basic_unit' show_type='t' title="所属学院"
                            required="true" panelheight="60px;">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="label-bg" style="width: 100px;">
                        学生类型
                    </td>
                    <td>
                        <select id="STU_TYPE" class="easyui-combobox" name="STU_TYPE" style="width: 150px;"
                            d_value='<%=head.STU_TYPE %>' ddl_name='ddl_stu_type' show_type='t' title="学生类型"
                            required="true" panelheight="60px;">
                        </select>
                    </td>
                    <td class="label-bg" style="width: 100px;">
                        是否辅导员<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="IS_ASSISTANT" class="easyui-combobox" name="IS_ASSISTANT" style="width: 150px;"
                            d_value='<%=head.IS_ASSISTANT %>' ddl_name='ddl_yes_no' show_type='t' title="是否辅导员"
                            required="true" panelheight="60px;">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="label-bg" style="width: 100px;">
                        所属角色<span style="color: Red;">*</span>
                    </td>
                    <td colspan="3">
                        <div runat="server" id="divUserRole" style="margin-top: 5px;">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="label-bg" style="width: 100px;">
                        登录密码<span style="color: Red;">*</span>
                    </td>
                    <td colspan="3">
                        <input type="password" id="LOGIN_PW" class="easyui-validatebox input-text" name="LOGIN_PW"
                            style="width: 150px;" required="true" value='<%=head.LOGIN_PW %>' maxlength="20" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <input type="hidden" id="hidUserRoles" runat="server" />
    </form>
</asp:Content>