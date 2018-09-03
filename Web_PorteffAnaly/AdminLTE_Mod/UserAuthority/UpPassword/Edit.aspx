<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Edit.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.UpPassword.Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div class="login-box" id="content">
        <div class="login-logo">
            <a href="#">修改密码<b></b></a>
        </div>
        <!-- login-logo -->
        <div class="login-box-body" id="tableModal">
            <form action="#" method="post" id="form_uppw">
            <div class="form-group has-feedback">
                <%=user.User_Id %>&nbsp;&nbsp;<%=user.User_Name %>
                <span class="glyphicon glyphicon-user form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input type="password" id="old_pw" name="old_pw" class="form-control" title="旧密码（只能录入数字或者字母）" placeholder="旧密码（只能录入数字或者字母）" />
                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input type="password" id="new_pw" name="new_pw" class="form-control" title="新密码（只能录入数字或者字母，不能与旧密码一致）" placeholder="新密码（只能录入数字或者字母，不能与旧密码一致）" />
                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input type="password" id="new_pw_2" name="new_pw_2" class="form-control" title="确认新密码（与新密码一致）" placeholder="确认新密码（与新密码一致）" />
                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input type="text" class="form-control" title="邮箱地址（新密码将会发送至您的邮箱）" placeholder="邮箱地址（新密码将会发送至您的邮箱）" name="send_email" id="send_email" />
                <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <button type="button" onclick="upPw();" class="btn btn-primary btn-block btn-flat btn-login">确认</button>
                </div>
                <!-- /.col -->
            </div>
            </form>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            LimitUtils.onlyNumAlpha("old_pw"); //代码限制只能录入数字或者字母
            LimitUtils.onlyNumAlpha("new_pw"); //代码限制只能录入数字或者字母
            LimitUtils.onlyNumAlpha("new_pw_2"); //代码限制只能录入数字或者字母
        });

        //更新密码
        function upPw() {
            var old_pw = $('#old_pw').val();
            var new_pw = $('#new_pw').val();
            var new_pw_2 = $('#new_pw_2').val();
            var send_email = $('#send_email').val();
            if (old_pw.length == 0) {
                easyAlert.timeShow({
                    "content": "旧密码必填！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            if (new_pw.length == 0) {
                easyAlert.timeShow({
                    "content": "新密码必填！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            if (new_pw_2.length == 0) {
                easyAlert.timeShow({
                    "content": "确认新密码必填！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            if (send_email.length == 0) {
                easyAlert.timeShow({
                    "content": "邮箱地址必填！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            //判断旧密码是否录入正确
            if (old_pw != "<%=user.Login_Password %>") {
                easyAlert.timeShow({
                    "content": "旧密码不正确！",
                    "duration": 2,
                    "type": "warn"
                });
                return;
            }
            //判断新密码不能与旧密码重复
            if (old_pw == new_pw) {
                easyAlert.timeShow({
                    "content": "新密码不能与旧密码重复！",
                    "duration": 2,
                    "type": "warn"
                });
                return;
            }
            if (new_pw != new_pw_2) {
                easyAlert.timeShow({
                    "content": "确认新密码必须与新密码录入一致！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            //校验邮箱格式
            var send_email = $("#send_email").val();
            if (!LimitUtils.onlyEmail(send_email)) {
                easyAlert.timeShow({
                    "content": "邮箱格式不正确！",
                    "duration": 2,
                    "type": "danger"
                });
                $("#send_email").focus();
                return;
            }

            $.post(OptimizeUtils.FormatUrl("Edit.aspx?optype=save"), $("#form_uppw").serialize(), function (msg) {
                if (msg.length == 0) {
                    easyAlert.timeShow({
                        "content": "新密码已经发送至填写的邮箱中，请查阅。",
                        "duration": 5,
                        "type": "info"
                    });
                }
                else {
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
        }
    </script>
</asp:Content>
