<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="Return.aspx.cs"
    Inherits="PorteffAnaly.Web.AdminLTE_Mod.CHK.Return" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            $("#divReturnRole").html('');
            var result = AjaxUtils.getResponseText('?optype=getrtnrole&<%=Request.QueryString %>');
            if (result.length > 0)
                $("#divReturnRole").html(result);

            ValidateUtils.setRequired("#form_return", "OP_NOTES", true, "原因必填");

            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });

            $("#btnSubmit").click(function () {
                if (!BeforeSubmit()) return;

                easyConfirm.locationShow({
                    "type": "warn",
                    "title": "提交",
                    "content": "确定要退回吗？",
                    "callback": ReturnRole
                });
            });
        }

        //选择退回状态
        function GetReturnRole() {
            var rtn_step = "";
            var rtn_post = "";
            $("input[type='radio'][name='POST_CODE']:checked").each(function () {
                if ($(this) != null) {
                    rtn_step = this.id;
                    rtn_post = $(this).attr("value");
                }
            });
            $("#rtn_step").val(rtn_step);
            $("#rtn_post").val(rtn_post);
        }

        function BeforeSubmit() {
            if (!($("#form_return").valid())) {
                return false;
            }
            if ($("input[name='POST_CODE']:checked").val() == undefined) {
                easyAlert.timeShow({
                    "content": "请选择退回状态！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            return true;
        }

        function ReturnRole() {
            GetReturnRole();
            $.post(OptimizeUtils.FormatUrl("?optype=return&<%=Request.QueryString %>"), $("#form_return").serialize(), function (msg) {
                if (msg.length == 0) {
                    OperateSuccessAndClose(msg);
                }
                else {
                    OperateErrorAndClose(msg);
                }
            });
        }

        //操作成功调用方法
        function OperateSuccessAndClose(content) {
            if (content) {
                easyAlert.timeShow({
                    "content": content,
                    "duration": 2,
                    "type": "danger"
                });
                setTimeout(function () {
                    parent.$("#tableModal").modal('hide');
                    parent.$("#returnModal").modal('hide');
                    parent.mainList.reload();
                }, 2000);
            }
            else {
                easyAlert.timeShow({
                    "content": "操作成功！",
                    "duration": 2,
                    "type": "success"
                });
                setTimeout(function () {
                    parent.$("#tableModal").modal('hide');
                    parent.$("#returnModal").modal('hide');
                    parent.mainList.reload();
                }, 2000);
            }
        }

        //操作失败调用方法
        function OperateErrorAndClose(content) {
            var msg = content || "操作失败！";
            easyAlert.timeShow({
                "content": content,
                "duration": 2,
                "type": "danger"
            });
        }
        //表单提交时，如果响应缓慢所弹出的界面消息
        function OnFormCommit() {
            $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("body");
            $("<div class=\"datagrid-mask-msg\"></div>").html("系统正在处理，请稍候。。。").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form action="#" method="post" id="form_return">
        <div class="modal-body">
            <input type="hidden" id="rtn_step" name="rtn_step" />
            <input type="hidden" id="rtn_post" name="rtn_post" />
            <div class="form-group">
                <label class="col-sm-2 control-label">
                    退回状态<span style="color: Red;">*</span></label>
                <div class="col-sm-10">
                    <div id="divReturnRole">
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">原因<span style="color: Red;">*</span></label>
                <div class="col-sm-10">
                    <textarea id="OP_NOTES" name="OP_NOTES" cols="4" rows="2" class="form-control"></textarea>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-primary btn-save" id="btnSubmit">
                提交</button>
        </div>
    </form>
</asp:Content>
