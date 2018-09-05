<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Edit.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.ChangRole.Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            adaptionHeight();
            LoadUserRole();
            CheckedUserRole();
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        });

        function LoadUserRole() {
            $("#divUserRole").html('');
            var result = AjaxUtils.getResponseText('Edit.aspx?optype=getuserrole');
            if (result.length > 0)
                $("#divUserRole").html(result);
        }

        function CheckedUserRole() {
            var strRole = "<%=user.User_Role %>";
            var arrRole = strRole.split(',');
            if (arrRole.length > 0)
                $("#" + arrRole[0]).iCheck("check"); //默认选中
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div class="login-box" id="content">
        <div class="login-logo">
            <a href="#">切换角色<b></b></a>
        </div>
        <!-- login-logo -->
        <div class="login-box-body" id="tableModal">
            <form action="#" method="post" id="form_uprole">
            <input type="hidden" id="hidRole" name="hidRole" value="" />
            <div class="form-group has-feedback">
                <%=user.User_Id %>&nbsp;&nbsp;<%=user.User_Name %>
                <span class="glyphicon glyphicon-user form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <div id="divUserRole">
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <button type="button" onclick="upUserRole();" class="btn btn-primary btn-block btn-flat btn-login">
                        确认</button>
                </div>
            </div>
            <div class="row" style="margin-top: 20px;">
                <div class="col-xs-12" style="color: Red;">
                    切换说明：
                </div>
                <div class="col-xs-12" style="color: Red;">
                    切换角色用于审核；
                </div>
                <div class="col-xs-12" style="color: Red;">
                    退出重新登录即可恢复多角色。
                </div>
            </div>
            </form>
        </div>
    </div>
    <script type="text/javascript">
        function GetRadioSelected() {
            var selValue = "";
            $("#hidRole").val("");
            $("input[type='radio'][name='user_role']:checked").each(function () {
                if ($(this) != null) {
                    selValue = $(this).attr("id");
                }
            });
            if (selValue.length > 0) {
                $("#hidRole").val(selValue);
            }
        }
        //切换角色
        function upUserRole() {
            GetRadioSelected();
            $.post(OptimizeUtils.FormatUrl("Edit.aspx?optype=save"), $("#form_uprole").serialize(), function (msg) {
                if (msg.length == 0) {
                    easyAlert.timeShow({
                        "content": "切换角色成功！",
                        "duration": 5,
                        "type": "info"
                    });
                    top.location.reload(); //刷新整个页面
                    return;
                }
                else {
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            });
        }
    </script>
</asp:Content>