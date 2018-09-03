<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Print_19_20_21.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.Print.Print_19_20_21" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--COUNTRY_YP：国家奖学金（研究生/博士）：表19+1,19+2--%>
    <%--COUNTRY_STUDY：国家学业奖学金：表20--%>
    <%--SCHOOL_NOTCOUNTRY：非国家级奖学金：表21--%>
    <%--SOCIETY_NOCOUNTRY：非国家级奖学金：表21--%>
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
                    <h3>
                        <%=strTitle%></h3>
                </li>
            </ul>
        </div>
        <table cellpadding="0" cellspacing="0" style="font-size: 10.5px; width: 100%;" class="form-tb"
            border="1">
            <tr>
                <td style="text-align: center; width: 5%; font-weight: bolder;" rowspan="6">
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
                    学院
                </td>
                <td>
                    <%=head.XY%>
                </td>
                <td>
                    专业
                </td>
                <td>
                    <%=head.ZY%>
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
                    学制
                </td>
                <td>
                    <%=stu.SYSTEM%>
                </td>
                <td>
                    学习阶段
                </td>
                <td colspan="3">
                    <%=head.STUDY_LEVEL%>
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
                <td>
                    培养方式
                </td>
                <td colspan="5" style="text-align: left;">
                    <%=head.TRAIN_TYPE%>
                </td>
            </tr>
            <tr>
                <td rowspan="<%=nScoreList %>" style="text-align: center; font-weight: bolder;">
                    学习<br />
                    情况<br />
                    （上一<br />
                    学年）
                </td>
                <td colspan="4">
                    课程名称
                </td>
                <td colspan="2">
                    成绩
                </td>
            </tr>
            <div id="divScore" runat="server">
            </div>
            <tr>
                <td colspan="3">
                    学年平均成绩：
                </td>
                <td colspan="3">
                    <%=study.PREYEAR_SCORE%>
                </td>
            </tr>
            <tr>
                <td style="text-align: center; font-weight: bolder;">
                    英语<br />
                    计算<br />
                    机过<br />
                    情况
                </td>
                <td colspan="6" style="text-align: left; text-indent: 2em;">
                    <%=txt.SKILL_INFO%>
                </td>
            </tr>
            <tr>
                <td style="text-align: center; font-weight: bolder;">
                    论文<br />
                    发表<br />
                    获得<br />
                    专利<br />
                    情况
                </td>
                <td colspan="6" style="text-align: left; text-indent: 2em;">
                    <%=txt.PUBLISH_INFO%>
                </td>
            </tr>
            <tr>
                <td style="text-align: center; font-weight: bolder;">
                    大学<br />
                    期间<br />
                    主要<br />
                    获奖<br />
                    情况
                </td>
                <td colspan="6">
                    <div id="divReward" runat="server">
                    </div>
                </td>
            </tr>
            <tbody align="center" id="tBodyRewardList">
            </tbody>
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
                    <%=txt.REVIEW_REASON%>
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
        <div style="width: 100%; margin-bottom: 10px; margin-top: 10px;">
            <ul>
                <li style="text-align: center;">
                    <h4>
                        注：此表一式两份，A4纸打印，签名须全部手写。</h4>
                </li>
            </ul>
        </div>
    </div>
</asp:Content>