<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Edit.aspx.cs" Inherits="PorteffAnaly.Web.BDM.STU.Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            /*表格要撑满父iframe，需先得到父iframe的高度*/
            if (window.parent) {
                //                var ph = $("iframe:visible", window.parent.document).eq(0).height();
                //                $("#tabDiv").css({ height: ph - 65 });
            }

            PageUtils.initComboBox();
            if ('<%=Request.QueryString["optype"] %>' == 'view') {
                $('#<%=submitBtn.ClientID %>').hide();
                PageUtils.renderViewMode();
            }
            if ('<%=Request.QueryString["optype"] %>' == 'modi') {

                $('#NUMBER').prop("readonly", "readonly");
            }
        }

        //提交前校验
        function submitChk() {
            if (FormUtils.validateForm() == false) {
                MsgUtils.info("请输入必填项！");
                return false;
            }
            var IDCARDNO = $("#IDCARDNO").val();
            var strUrl = MiscUtils.FormatUrl('Edit.aspx?optype=chkid&idno=' + IDCARDNO);
            var strResult = AjaxUtils.getResponseText(strUrl);
            if (strResult.length > 0) {
                MsgUtils.infoAndFocus(strResult, "IDCARDNO");
                return false;
            }
            var EMAIL = $("#EMAIL").val();

            var strUrl = MiscUtils.FormatUrl('Edit.aspx?optype=chkem&idno=' + EMAIL);
            var strResult = AjaxUtils.getResponseText(strUrl);
            if (strResult.length > 0) {
                MsgUtils.infoAndFocus(strResult, "EMAIL");
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="f1" runat="server" onsubmit='OnFormCommit();'>
    <div class="toolbar" style="height: 30px; line-height: 30px; text-align: left;">
        <asp:LinkButton ID="submitBtn" runat="server" class="easyui-linkbutton" plain="true"
            iconCls="icon-ok" OnClientClick="return submitChk ();" OnClick="submitBtn_Click">提交</asp:LinkButton>
        <a id="btnBack" href="#" class="easyui-linkbutton" plain="true" iconcls="icon-back"
            onclick="parent.$('#editDiv').dialog('close');">返回</a>
    </div>
    <div id="tabDiv" class="easyui-tabs" border="false" fit="true">
        <table class="form-tb">
            <tr>
                <td class="label-bg" style="width: 80px;">
                    学号<span style="color: Red;">*</span>
                </td>
                <td>
                    <input type="text" id="NUMBER" name="NUMBER" style="width: 220px;" class="easyui-validatebox input-text"
                        value="<%=head.NUMBER %>" required="true" />
                </td>
                <td class="label-bg" style="width: 80px;">
                    姓名<span style="color: Red;">*</span>
                </td>
                <td>
                    <input type="text" id="NAME" name="NAME" style="width: 220px;" class="easyui-validatebox input-text"
                        value="<%=head.NAME %>" required="true" />
                </td>
            </tr>
            <tr>
                <td class="label-bg" style="width: 80px;">
                    曾用名
                </td>
                <td>
                    <input type="text" id="US_NAME" name="US_NAME" style="width: 220px;" class="easyui-validatebox input-text"
                        value="<%=head.US_NAME %>" />
                </td>
                <td class="label-bg" style="width: 80px;">
                    身高
                </td>
                <td>
                    <input type="text" id="HEIGTH" name="HEIGTH" style="width: 220px;" class="easyui-numberbox input-text"
                        data-options="min:0,precision:3" maxlength="18" value="<%=head.HEIGTH %>" />
                </td>
            </tr>
            <tr>
                <td class="label-bg" style="width: 80px;">
                    体重
                </td>
                <td>
                    <input type="text" id="WEIGTH" name="WEIGTH" style="width: 220px;" class="easyui-numberbox input-text"
                        data-options="min:0,precision:3" maxlength="18" value="<%=head.WEIGTH %>" />
                </td>
                <td class="label-bg" style="width: 80px;">
                    特长
                </td>
                <td>
                    <input type="text" id="GENIUS" name="GENIUS" style="width: 220px;" class="easyui-validatebox input-text"
                        value="<%=head.GENIUS %>" />
                </td>
            </tr>
            <tr>
                <td class="label-bg" style="width: 80px;">
                    健康状况
                </td>
                <td>
                    <input type="text" id="HEALTH" name="HEALTH" style="width: 220px;" class="easyui-validatebox input-text"
                        value="<%=head.HEALTH %>" />
                </td>
                <td class="label-bg" style="width: 80px;">
                    培养层次
                </td>
                <td>
                    <input type="text" id="TRAIN" name="TRAIN" style="width: 220px;" class="easyui-validatebox input-text"
                        value="<%=head.TRAIN %>" />
                </td>
            </tr>
            <tr>
                <td class="label-bg" style="width: 80px;">
                    是否走读
                </td>
                <td>
                    <input type="text" id="STUWORK" name="STUWORK" style="width: 220px;" class="easyui-validatebox input-text"
                        value="<%=head.STUWORK %>" />
                </td>
                <td class="label-bg" style="width: 80px;">
                    学生类别<span style="color: Red;">*</span>
                </td>
                <td>
                    <select id="STUTYPE" class="easyui-combobox" name="STUTYPE" style="width: 220px;"
                        ddl_name='ddl_stu_type' d_value='<%=head.STUTYPE %>' panelheight='100' title="学生类别"
                        required="true" show_type="t">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="label-bg" style="width: 80px;">
                    入学方式<span style="color: Red;">*</span>
                </td>
                <td>
                    <select id="ENROLLING" class="easyui-combobox" name="ENROLLING" style="width: 220px;"
                        ddl_name='ddl_rxfs' d_value='<%=head.ENROLLING %>' panelheight='100' title="入学方式"
                        required="true" show_type="t">
                    </select>
                </td>
                <td class="label-bg" style="width: 80px;">
                    培养方式
                </td>
                <td>
                    <input type="text" id="CULTIVATION" name="CULTIVATION" style="width: 220px;" class="easyui-validatebox input-text"
                        value="<%=head.CULTIVATION %>" />
                </td>
            </tr>
            <tr>
                <td class="label-bg" style="width: 80px;">
                    带班辅导员
                </td>
                <td>
                    <input type="text" id="COUN" name="COUN" style="width: 220px;" class="easyui-validatebox input-text"
                        value="<%=head.COUN %>" />
                </td>
                <td class="label-bg">
                    身份证号<span style="color: Red;">*</span>
                </td>
                <td>
                    <input type="text" id="IDCARDNO" name="IDCARDNO" style="width: 220px" class="easyui-validatebox input-text"
                        value="<%=head.IDCARDNO %>" />
                </td>
            </tr>
            <tr>
                <td class="label-bg" style="width: 80px;">
                    电子邮箱<span style="color: Red;">*</span>
                </td>
                <td>
                    <input type="text" id="EMAIL" name="EMAIL" style="width: 220px;" class="easyui-validatebox input-text"
                        value="<%=head.EMAIL %>" required="true" />
                </td>
                <td class="label-bg" style="width: 80px;">
                    QQ号码<span style="color: Red;">*</span>
                </td>
                <td>
                    <input type="text" id="QQNUM" name="QQNUM" style="width: 220px;" class="easyui-numberbox input-text"
                        data-options="min:0,precision:0" maxlength="18" value="<%=head.QQNUM %>" required="true" />
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    性别<span style="color: Red;">*</span>
                </td>
                <td>
                    <select id="SEX" class="easyui-combobox" name="SEX" style="width: 220px;" ddl_name='ddl_xb'
                        d_value='<%=head.SEX %>' panelheight='100' title="性别" required="true" show_type="t">
                    </select>
                </td>
                <td class="label-bg">
                    出生日期<span style="color: Red;">*</span>
                </td>
                <td>
                    <input type="text" id="GARDE" class="easyui-validatebox input-text" name="GARDE"
                        required="true" style="width: 220px;" value='<%=head.GARDE %>' onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    年级<span style="color: Red;">*</span>
                </td>
                <td>
                    <select id="EDULENTH" class="easyui-combobox" name="EDULENTH" style="width: 220px;"
                        ddl_name='ddl_grade' d_value='<%=head.EDULENTH %>' panelheight='100' title="年级"
                        required="true" show_type="t">
                    </select>
                </td>
                <td class="label-bg">
                    学院<span style="color: Red;">*</span>
                </td>
                <td>
                    <select id="COLLEGE" class="easyui-combobox" name="COLLEGE" style="width: 220px;"
                        ddl_name='ddl_department' d_value='<%=head.COLLEGE %>' panelheight='100' title="学院"
                        required="true" show_type="t">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    政治面貌
                </td>
                <td>
                    <select id="POLISTATUS" class="easyui-combobox" name="POLISTATUS" style="width: 220px;"
                        ddl_name='ddl_zzmm' d_value='<%=head.POLISTATUS %>' panelheight='100' title="政治面貌"
                        show_type="t">
                    </select>
                </td>
                <td class="label-bg">
                    专业<span style="color: Red;">*</span>
                </td>
                <td>
                    <select id="MAJOR" class="easyui-combobox" name="MAJOR" style="width: 220px;" ddl_name='ddl_zy'
                        d_value='<%=head.MAJOR %>' panelheight='100' title="专业" required="true" show_type="t">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    民族<span style="color: Red;">*</span>
                </td>
                <td>
                    <select id="NATION" class="easyui-combobox" name="NATION" style="width: 220px;" ddl_name='ddl_mz'
                        d_value='<%=head.NATION %>' panelheight='100' title="民族" required="true" show_type="t">
                    </select>
                </td>
                <td class="label-bg">
                    班级<span style="color: Red;">*</span>
                </td>
                <td>
                    <select id="CLASS" class="easyui-combobox" name="CLASS" style="width: 220px;" ddl_name='ddl_class'
                        d_value='<%=head.CLASS %>' panelheight='100' title="班级" required="true" show_type="t">
                    </select>
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    家庭所在地
                </td>
                <td>
                    <input type="text" id="ADDRESS" name="ADDRESS" style="width: 220px" class="easyui-validatebox input-text"
                        value="<%=head.ADDRESS %>" />
                </td>
                <td class="label-bg">
                    户口所在地
                </td>
                <td>
                    <input type="text" id="REGISTPLACE" name="REGISTPLACE" style="width: 220px" class="easyui-validatebox input-text"
                        value="<%=head.REGISTPLACE %>" />
                </td>
            </tr>
            <tr>
                <td class="label-bg">
                    考生类别
                </td>
                <td>
                    <input type="text" id="CANDIDATE" name="CANDIDATE" style="width: 220px" class="easyui-validatebox input-text"
                        value="<%=head.CANDIDATE %>" />
                </td>
                <td class="label-bg">
                    学制
                </td>
                <td>
                    <select id="SYSTEM" class="easyui-combobox" name="SYSTEM" style="width: 220px;" ddl_name='ddl_edu_system'
                        d_value='<%=head.SYSTEM %>' panelheight='100' title="学制" required="true" show_type="t">
                    </select>
                </td>
            </tr>
        </table>
    </div>
    </form>
</asp:Content>