<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Edit.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.UpPassword.Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            MiscUtils.onlyNumAlpha("LOGIN_PW"); //代码限制只能录入数字或者字母
            MiscUtils.onlyNumAlpha("LOGIN_PW_NEW"); //代码限制只能录入数字或者字母
        });

        //保存
        function SaveInfo() {
            if (FormUtils.validateForm() == false) {
                MsgUtils.info("请输入必填项！");
                return false;
            }
            //判断旧密码是否录入正确
            if ($("#LOGIN_PW").val() != "<%=user.Login_Password %>") {
                MsgUtils.info("旧密码不正确！");
                return false;
            }
            //判断新密码不能与旧密码重复
            if ($("#LOGIN_PW").val() == $("#LOGIN_PW_NEW").val()) {
                MsgUtils.info("新密码不能与旧密码重复！");
                return false;
            }
            //邮箱地址是否录入正确
            var email = $("#MAIL_ADDRESS").val();
            if (!email.match(/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/)) {
                MsgUtils.info("邮箱格式不正确，请重新输入！");
                $("#MAIL_ADDRESS").focus();
                return false;
            }

            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="form_password" runat=server>
    <div class="toolbar" style="height: 30px; line-height: 30px; text-align: left;">
        <asp:LinkButton ID="submitBtn" runat="server" class="easyui-linkbutton" plain="true"
            iconCls="icon-ok" OnClientClick="return SaveInfo ();" OnClick="submitBtn_Click">提交</asp:LinkButton>
    </div>
    <table class="form-tb" style="width: 95%; margin: 10px;">
        <tr>
            <td class="label-bg" style="width: 80px;">
                用户代码
            </td>
            <td>
                <%=user.User_Id%>
            </td>
        </tr>
        <tr>
            <td class="label-bg" style="width: 80px;">
                用户名称
            </td>
            <td>
                <%=user.User_Name%>
            </td>
        </tr>
        <tr>
            <td class="label-bg" style="width: 80px;">
                旧密码
            </td>
            <td>
                <input type="password" id="LOGIN_PW" name="LOGIN_PW" style="width: 250px;" class="easyui-validatebox input-text"
                    value="" required="true" maxlength="20" /><span style="color: Red;">*只能录入数字或者字母</span>
            </td>
        </tr>
        <tr>
            <td class="label-bg" style="width: 80px;">
                新密码
            </td>
            <td>
                <input type="password" id="LOGIN_PW_NEW" name="LOGIN_PW_NEW" style="width: 250px;"
                    class="easyui-validatebox input-text" value="" required="true" maxlength="20" /><span
                        style="color: Red;">*只能录入数字或者字母，并且不能与旧密码重复</span>
            </td>
        </tr>
        <tr>
            <td class="label-bg" style="width: 80px;">
                邮箱地址
            </td>
            <td>
                <input type="text" id="MAIL_ADDRESS" name="MAIL_ADDRESS" style="width: 250px;" class="easyui-validatebox input-text"
                    value="" required="true" maxlength="50" /><span style="color: Red;">*填写邮箱地址，新密码将会发送至您的邮箱</span>
            </td>
        </tr>
    </table>
    </form>
</asp:Content>