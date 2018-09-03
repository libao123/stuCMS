<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.APP.DataBaseControl.SqlCommand.List" %>

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
            <a href="#">SQL命令控制<b></b></a>
        </div>
        <!-- login-logo -->
        <div class="login-box-body" id="tableModal">
            <form action="#" method="post" id="form_sql">
            <div class="form-group has-feedback">
                <textarea class="form-control" id="sql_txt" name="sql_txt" rows="10" title="SQL命令"
                    placeholder="SQL命令"></textarea>
            </div>
            <div class="form-group has-feedback">
                <input type="password" id="yzm" name="yzm" class="form-control" title="验证码" placeholder="验证码" />
                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <button type="button" onclick="ExeSql();" class="btn btn-primary btn-block btn-flat btn-login">
                        执行</button>
                </div>
            </div>
            </form>
        </div>
    </div>
    <script type="text/javascript">
        //执行SQL
        function ExeSql() {
            var sql_txt = $('#sql_txt').val();
            var yzm = $('#yzm').val();
            if (sql_txt.length == 0) {
                easyAlert.timeShow({
                    "content": "SQL命令必填！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            if (yzm.length == 0) {
                easyAlert.timeShow({
                    "content": "验证码必填！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            //校验验证码
            var result = AjaxUtils.getResponseText("List.aspx?optype=check&yzm=" + yzm);
            if (result.length > 0) {
                easyAlert.timeShow({
                    "content": result,
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            //执行SQL
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_sql").serialize(), function (msg) {
                easyAlert.timeShow({
                    "content": msg,
                    "duration": 4,
                    "type": "warn"
                });
            });
        }
    </script>
</asp:Content>