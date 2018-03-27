<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Print_18.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.Print.Print_18" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--SCHOOL_SINGLE：单项奖学金：表18--%>
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
                        广西师范大学(
                        <%=head.PROJECT_YEAR%>
                        学年)单项奖学金登记表
                    </h1>
                </li>
            </ul>
        </div>
        <table cellpadding="0" cellspacing="0" style="font-size: 12px; width: 100%;" class="form-tb"
            border="1">
            <tr>
                <td style="text-align: center; width: 5%; font-weight: bolder;" rowspan="6">
                    基<br />
                    本<br />
                    情<br />
                    况
                </td>
                <td>
                    学院
                </td>
                <td>
                    <%=head.XY%>
                </td>
                <td>
                    年级
                </td>
                <td>
                    <%=head.GRADE%>
                </td>
                <td>
                    专业
                </td>
                <td>
                    <%=head.ZY%>
                </td>
                <td rowspan="4" style="width: 80px;">
                    一寸免冠照片<br />
                    （JPG格式贴在相应位置黑白打印出来）
                </td>
            </tr>
            <tr>
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
                    民族
                </td>
                <td>
                    <%=stu.NATION%>
                </td>
                <td>
                    政治面貌
                </td>
                <td>
                    <%=stu.POLISTATUS%>
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
                    学号
                </td>
                <td colspan="3">
                    <%=head.STU_NUMBER%>
                </td>
                <td>
                    联系电话
                </td>
                <td>
                    <%=stu.MOBILENUM%>
                </td>
            </tr>
            <tr>
                <td>
                    身份证号
                </td>
                <td colspan="6" style="text-align: left;">
                    <%=stu.IDCARDNO%>
                </td>
            </tr>
            <tr>
                <td>
                    曾/现任职情况
                </td>
                <td colspan="6" style="text-align: left;">
                    <%=head.POST_INFO%>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    拟评何种类型
                </td>
                <td colspan="6" style="text-align: left;">
                    <%=head.REWARD_FLAG%>
                </td>
            </tr>
            <tr>
                <td style="text-align: center; font-weight: bolder;">
                    曾获<br />
                    何种<br />
                    奖励
                </td>
                <td colspan="7">
                    <div id="divReward" runat="server">
                    </div>
                </td>
            </tr>
            <tbody align="center" id="tBodyRewardList">
            </tbody>
            <tr>
                <td style="text-align: center; font-weight: bolder;">
                    个人<br />
                    突出<br />
                    事迹
                </td>
                <td colspan="7" style="text-align: left; text-indent: 2em;">
                    <%=txt.APPLY_REASON%>
                </td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; font-weight: bolder;">
                    班级<br />
                    民主<br />
                    评议<br />
                    小组<br />
                    意见
                </td>
                <td colspan="7" style="text-align: left; text-indent: 2em;">
                    <%=txt.RECOMM_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="7">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 100px;">
                            辅导员签章：</label>
                    </div>
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin: 0px 10px 0px 100px;">
                            ___________年______月______日</label>
                    </div>
                </td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; font-weight: bolder;">
                    院<br />
                    （系）<br />
                    意<br />
                    见
                </td>
                <td colspan="7" style="text-align: left; text-indent: 2em;">
                    <%=txt.COLLEGE_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="7">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 50px;">
                            （院系公章）</label>
                    </div>
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin: 0px 10px 0px 100px;">
                            ___________年______月______日</label>
                    </div>
                </td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; font-weight: bolder;">
                    学<br />
                    校<br />
                    意<br />
                    见
                </td>
                <td colspan="7" style="text-align: left; text-indent: 2em;">
                    <%=txt.SCHOOL_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="7">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 50px;">
                            （学校公章）</label>
                    </div>
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin: 0px 10px 0px 100px;">
                            ___________年______月______日</label>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="8" style="border-style: none; text-align: left;">
                    <div style="margin: 10px 0px 10px 0px;">
                        <h3>
                            备注：本表要求A4纸双面黑白打印，纸质版一式两份，签名处用黑色签字笔填写。</h3>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>