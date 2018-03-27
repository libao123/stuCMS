<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Print_19_2.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.Print.Print_19_2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!--表19+2-->
    <script type="text/javascript" src="/AdminLTE/common/plugins/jqprint/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/jqprint/jquery.jqprint-0.3.js"></script>
    <style type="text/css">
        td
        {
            height: 28px;
            border: #000 solid 1px;
            font-family: "宋体";
            text-align: center;
        }
        table
        {
            border-collapse: collapse;
        }
    </style>
    <script type="text/javascript">
        //打印
        function Print() {
            $("#table_print").jqprint();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <input type="button" onclick="Print();" value="打印" />
    <div id="table_print">
        <div style="width: 100%; margin-bottom: 10px;">
            <ul>
                <li style="float: right;">
                    <h5>
                        <%=strPrintCode%>
                    </h5>
                </li>
            </ul>
        </div>
        <br />
        <div style="width: 100%; margin-bottom: 10px; margin-top: 10px;">
            <ul>
                <li style="text-align: center;">
                    <h1>
                        研究生国家奖学金申请审批表</h1>
                </li>
            </ul>
        </div>
        <table cellpadding="0" cellspacing="0" style="font-size: 10.5px; width: 100%;" class="form-tb"
            border="1">
            <tr>
                <td style="text-align: center; width: 5%; font-weight: bolder;" rowspan="5">
                    基<br />
                    本<br />
                    情<br />
                    况
                </td>
                <td>
                    姓名
                </td>
                <td>
                    <%=stu.NAME%>
                </td>
                <td>
                    性别
                </td>
                <td>
                    <%=stu.SEX%>
                </td>
                <td>
                    出生年月
                </td>
                <td>
                    <%=stu.GARDE%>
                </td>
            </tr>
            <tr>
                <td>
                    政治面貌
                </td>
                <td>
                    <%=stu.POLISTATUS%>
                </td>
                <td>
                    民族
                </td>
                <td>
                    <%=stu.NATION%>
                </td>
                <td>
                    入学时间
                </td>
                <td>
                    <%=stu.ENTERTIME%>
                </td>
            </tr>
            <tr>
                <td>
                    基层单位
                </td>
                <td>
                    <%=head.BASIC_UNIT%>
                </td>
                <td>
                    专业
                </td>
                <td>
                    <%=head.ZY%>
                </td>
                <td>
                    攻读学位
                </td>
                <td>
                    <%=head.HARD_FOR%>
                </td>
            </tr>
            <tr>
                <td>
                    学制
                </td>
                <td>
                    <%=stu.SYSTEM%>
                </td>
                <td>
                    学习阶段
                </td>
                <td>
                    <%=head.STUDY_LEVEL%>
                </td>
                <td>
                    学号
                </td>
                <td>
                    <%=head.STU_NUMBER%>
                </td>
            </tr>
            <tr>
                <td>
                    身份证号
                </td>
                <td colspan="5" style="text-align: left;">
                    <%=stu.IDCARDNO%>
                </td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; font-weight: bolder;">
                    申请<br />
                    理由
                </td>
                <td colspan="6" style="text-align: left; text-indent: 2em;">
                    <%=txt.APPLY_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 100px;">
                            申请人签名(手签)：</label>
                    </div>
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin: 0px 10px 0px 100px;">
                            ___________年______月______日</label>
                    </div>
                </td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; font-weight: bolder;">
                    推荐<br />
                    意见
                </td>
                <td colspan="6" style="text-align: left; text-indent: 2em;">
                    <%=txt.RECOMM_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 100px;">
                            推荐人签名：</label>
                    </div>
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin: 0px 10px 0px 100px;">
                            ___________年______月______日</label>
                    </div>
                </td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; font-weight: bolder;">
                    评审<br />
                    意见
                </td>
                <td colspan="6" style="text-align: left; text-indent: 2em;">
                    <%=txt.COLLEGE_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 100px;">
                            评审委员会主任委员签名：</label>
                    </div>
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin: 0px 10px 0px 100px;">
                            ___________年______月______日</label>
                    </div>
                </td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; font-weight: bolder;">
                    基层<br />
                    单位<br />
                    意见
                </td>
                <td colspan="6" style="text-align: left; text-indent: 2em;">
                    <%=txt.COLLEGE_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 100px;">
                            基层单位主管领导签名：</label>
                    </div>
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 50px;">
                            （基层单位公章）</label>
                    </div>
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin: 0px 10px 0px 100px;">
                            ___________年______月______日</label>
                    </div>
                </td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; font-weight: bolder;">
                    培养<br />
                    单位<br />
                    意见
                </td>
                <td colspan="6" style="text-align: left; text-indent: 2em;">
                    <%=txt.SCHOOL_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 50px;">
                            （培养单位公章）</label>
                    </div>
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin: 0px 10px 0px 100px;">
                            ___________年______月______日</label>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>