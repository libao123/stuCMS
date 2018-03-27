<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ApproveEdit.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.ClassGroup.ApproveEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            /*表格要撑满父iframe，需先得到父iframe的高度*/
            if (window.parent) {
                PageUtils.initComboBox();
                //只要是不满足审批条件的，都隐藏审批按钮
                if ('<%=m_strIsShowAuditBtn %>' == 'false') {
                    $("#Audit").hide();
                }
                else {
                    $("#Audit").show();
                }
            }
        });

        //审批
        function ApproveInfo() {
            var strUrl = MiscUtils.FormatUrl('../../CHK/Approve.aspx?optype=chk&seq_no=<%=head.SEQ_NO %>&doc_type=UA01');
            var strResult = AjaxUtils.getResponseText(strUrl);

            if (strResult.length > 0) {
                MsgUtils.info(strResult);
                return;
            }

            //审批时传入：tableid：列表id，parentdiv：编辑页面id，divid：审批编辑页面id， seq_no：单据编号，doc_type：单据类型
            $("#approveFrame").attr("src", MiscUtils.FormatUrl('../../CHK/Approve.aspx?tableid=tabList&parentdiv=editDiv&divid=approveDiv&seq_no=<%=head.SEQ_NO %>&doc_type=UA01'));
            $("#approveDiv").show().dialog({ title: '审批', modal: true, draggable: false });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="f1" runat="server">
    <div class="toolbar" style="height: 30px; line-height: 30px; text-align: left;">
        <a id="Audit" href="#" class="easyui-linkbutton" plain="true" iconcls="icon-decl"
            onclick="ApproveInfo();">审批</a> <a id="btnBack" href="#" class="easyui-linkbutton"
                plain="true" iconcls="icon-back" onclick="parent.$('#editDiv').dialog('close');">
                返回</a>
    </div>
    <div title="表头">
        <table class="form-tb" style="width: 95%; margin: 10px;">
            <tr>
                <td class="label-bg" style="width: 80px;">
                    班级代码
                </td>
                <td>
                    <%=b_class.CLASSCODE%>
                </td>
                <td class="label-bg" style="width: 80px;">
                    班级名称
                </td>
                <td>
                    <%=b_class.CLASSNAME%>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    学院
                </td>
                <td>
                    <%= cod.GetDDLTextByValue("ddl_department", b_class.XY)%>
                </td>
                <td class="label-bg">
                    系所
                </td>
                <td>
                    <%= cod.GetDDLTextByValue("ddl_xsh", b_class.XSH)%>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    专业
                </td>
                <td>
                    <%= cod.GetDDLTextByValue("ddl_zy", b_class.ZY)%>
                </td>
                <td class="label-bg">
                    年级
                </td>
                <td>
                    <%= cod.GetDDLTextByValue("ddl_grade", b_class.GRADE)%>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    班级辅导员工号
                </td>
                <td>
                    <%=head.GROUP_NUMBER%>
                </td>
                <td class="label-bg">
                    班级辅导员姓名
                </td>
                <td>
                    <%=head.GROUP_NAME%>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    班级辅导员类型
                </td>
                <td>
                    <%= cod.GetDDLTextByValue("ddl_group_type", head.GROUP_TYPE)%>
                </td>
                <td class="label-bg">
                    审批时间
                </td>
                <td>
                    <%=head.CHK_TIME%>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    申报人
                </td>
                <td>
                    <%=head.OP_NAME%>
                </td>
                <td class="label-bg">
                    申报时间
                </td>
                <td>
                    <%=head.DECL_TIME%>
                </td>
            </tr>
        </table>
    </div>
    <div id="approveDiv" style="width: 700px; height: 250px; display: none;">
        <iframe id="approveFrame" frameborder="0" src="" style="width: 100%; height: 100%;">
        </iframe>
    </div>
    </form>
</asp:Content>