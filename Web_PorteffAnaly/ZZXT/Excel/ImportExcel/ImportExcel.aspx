<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="ImportExcel.aspx.cs" Inherits="PorteffAnaly.Web.Excel.ImportExcel.ImportExcel" %>

<%@ OutputCache Duration="1" VaryByParam="none" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            $("#hidModelId").val('<%=Request.QueryString["model_id"] %>');
            //初始化
            $("#div_YEAR_CODE").hide();
            $("#div_CheckProject").hide();
            $("#div_Project").hide();
            //导入成绩
            if ('<%=Request.QueryString["type"] %>' == 'INPUT_SCORE') {
                DropDownUtils.initDropDown("YEAR_CODE");
                $("#div_YEAR_CODE").show();
            }
            //导入奖助申请项目（针对线下）
            if ('<%=Request.QueryString["type"] %>' == 'INPUT_PROJECT_APPLY') {
                var ddl_outlineproject_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_outlineproject');
                DropDownUtils.setDropDownDataStr(ddl_outlineproject_str, 'PROJECT_NAME', '', 't');
                $("#div_CheckProject").show();
                $("#div_Project").show();
            }
            //导入奖助核对信息（针对线下）
            if ('<%=Request.QueryString["type"] %>' == 'INPUT_PROJECT_CHECK') {
                var ddl_checkproject_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_checkproject');
                DropDownUtils.setDropDownDataStr(ddl_checkproject_str, 'PROJECT_NAME', '', 't');
                $("#div_CheckProject").show();
                $("#div_Project").show();
            }
            //导入保险申请信息
            if ('<%=Request.QueryString["type"] %>' == 'INPUT_INSUR_APPLY') {
                var ddl_insur_apply_project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_insurproject');
                DropDownUtils.setDropDownDataStr(ddl_insur_apply_project_str, 'PROJECT_NAME', '', 't');
                $("#div_CheckProject").show();
            }
            //导入保险参保信息
            if ('<%=Request.QueryString["type"] %>' == 'INPUT_INSUR_RESULT') {
                var ddl_insur_check_project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_insurproject');
                DropDownUtils.setDropDownDataStr(ddl_insur_check_project_str, 'PROJECT_NAME', '', 't');
                $("#div_CheckProject").show();
            }
            //导入贷款申请信息
            if ('<%=Request.QueryString["type"] %>' == 'INPUT_LOAN_APPLY') {
                var ddl_loan_apply_project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_loanproject');
                DropDownUtils.setDropDownDataStr(ddl_loan_apply_project_str, 'PROJECT_NAME', '', 't');
                $("#div_CheckProject").show();
            }
            //导入学费补偿贷款代偿申请信息
            if ('<%=Request.QueryString["type"] %>' == 'INPUT_MAKEUP_APPLY') {
                var ddl_makeup_apply_project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_makeupproject');
                DropDownUtils.setDropDownDataStr(ddl_makeup_apply_project_str, 'PROJECT_NAME', '', 't');
                $("#div_CheckProject").show();
            }
        }

        //提交校验
        function check() {
            //判断必填项
            if ('<%=Request.QueryString["type"] %>' == 'INPUT_SCORE') {
                var year = DropDownUtils.getDropDownValue("YEAR_CODE");
                if (year.length == 0) {
                    easyAlert.timeShow({
                        "content": "请选择学年！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return false;
                }
            }
            //导入奖助申请项目（针对线下）
            //导入奖助核对信息（针对线下）
            //导入保险信息
            //导入保险参保信息
            if ('<%=Request.QueryString["type"] %>' == 'INPUT_PROJECT_APPLY'
            || '<%=Request.QueryString["type"] %>' == 'INPUT_PROJECT_CHECK'
            || '<%=Request.QueryString["type"] %>' == 'INPUT_INSUR_APPLY'
            || '<%=Request.QueryString["type"] %>' == 'INPUT_INSUR_RESULT'
            || '<%=Request.QueryString["type"] %>' == 'INPUT_LOAN_APPLY'
            || '<%=Request.QueryString["type"] %>' == 'INPUT_MAKEUP_APPLY') {
                var pro_name = DropDownUtils.getDropDownValue("PROJECT_NAME");
                if (pro_name.length == 0) {
                    easyAlert.timeShow({
                        "content": "请选择相应项目！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return false;
                }
            }
            //选择的Excel文件
            if ($('#<%=userfile.ClientID %>').val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择要导入的EXCEL文件！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            //$('.maskBg').show();
            //ZENG.msgbox.show("导入处理中，请稍后...", 6);
            var layInx = layer.load(2, {
              content: "导入处理中，请稍后...",
              shade: [0.3,'#000'], //0.1透明度的白色背景
              time: 6000
            });
            return true;
        }

        //导入之后，刷新列表
        function ListRefresh() {
            var importModal = $("#hidModelId").val();
            if (importModal.length == 0)
                importModal = "importModal"; //默认值
            //导入完成之后，关闭父页面弹出的导入编辑层
            parent.$("#" + importModal).modal("hide");
            //导入时，调用父界面的刷新方法，所以父界面ImportReload这个方法一定要定义
            parent.ImportReload();
            //parent.window.location.reload(true);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form runat="server">
    <input type="hidden" id="hidModelId" name="hidModelId" value="" />
    <div class="modal-body">
        <div class="form-group" id="div_YEAR_CODE">
            <label for="YEAR_CODE">
                选择学年</label>
            <select id="YEAR_CODE" name="YEAR_CODE" d_value='' ddl_name='ddl_year_type' show_type='t'
                title="学年">
            </select>
        </div>
        <div class="form-group" id="div_CheckProject">
            <label for="PROJECT_NAME">
                选择相应项目</label>
            <select id="PROJECT_NAME" name="PROJECT_NAME" d_value='' ddl_name='' show_type='t'
                title="选择相应项目">
            </select>
        </div>
        <div class="form-group">
            <label for="userfile">
                选择文件</label>
            <input id="userfile" name="userfile" type="file" multiple="multiple" runat="server" />
            <br />
            <p class="help-block">
                上传excel文件；文件版本为：Excel97-2003；</p>
            <p class="help-block">
                excel文件导入行数最好不要超过5千行；超过时请分多个Excel文件导入。</p>
        </div>
        <div class="form-group">
            <asp:LinkButton ID="fileimport" runat="server" OnClientClick="return check();" OnClick="btnImport_Click"
                class="btn btn-primary btn-download pull-right">导入</asp:LinkButton>
        </div>
        <div class="form-group" id="div_Project">
            <label style="color: Red;">
                奖助结果导入说明：此导入只支持线下奖助项目。</label>
        </div>
    </div>
    <div class="maskBg">
    </div>
    </form>
</asp:Content>
