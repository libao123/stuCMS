<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Print_17.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.Print.Print_17" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--SCHOOL_GOOD：三好学生：表17+1--%>
    <%--SCHOOL_MODEL：三好学生标兵：表17+1,17+2,17+3--%>
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
                <td style="text-align: center; font-weight: bolder;" rowspan="<%=nRewardList %>">
                    曾获<br />
                    何种<br />
                    已获<br />
                    奖励
                </td>
                <td>
                    学年
                </td>
                <td colspan="4">
                    项目
                </td>
                <td colspan="2">
                    等级
                </td>
            </tr>
            <div runat="server" id="divReward">
            </div>
            <tr>
                <td style="text-align: center; font-weight: bolder;">
                    <%if (!head.PROJECT_TYPE.Equals("SCHOOL_GOODD"))
                      { %>
                    政治<br />
                    思想<br />
                    纪律<br />
                    体育<br />
                    锻炼<br />
                    表现
                    <%}
                      else
                      { %>
                    个人<br />
                    突出<br />
                    事迹
                    <%} %>
                </td>
                <td colspan="7" style="text-align: left; text-indent: 2em;">
                    <%=txt.APPLY_REASON%>
                </td>
            </tr>
            <%if (!head.PROJECT_TYPE.Equals("SCHOOL_GOODD"))
              { %>
            <tr>
                <td style="text-align: center; font-weight: bolder;" rowspan="<%=nScoreList %>">
                    上学<br />
                    年度<br />
                    综合<br />
                    考评<br />
                    成绩<br />
                    及专<br />
                    业课<br />
                    成绩
                </td>
                <td colspan="4">
                    成绩排名：<%=study.SCORE_RANK%>
                    /
                    <%=study.SCORE_TOTAL_NUM%>（名次/总人数）
                </td>
                <td colspan="3">
                    个人达标综合考评成绩：<%=study.COM_SCORE%>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    必修课
                    <%=study.MUST_COURSE_NUM%>门，其中及格以上<%=study.PASS_COURSE_NUM%>
                    门
                </td>
                <td colspan="3">
                    综合考评排名：
                    <%=study.COM_SCORE_RANK%>
                    /
                    <%=study.COM_SCORE_TOTAL_NUM%>（名次/总人数）
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    科目名称
                </td>
                <td colspan="3">
                    成绩
                </td>
            </tr>
            <div id="divScore" runat="server">
            </div>
            <%} %>
            <tr>
                <td rowspan="2" style="text-align: center; font-weight: bolder;">
                    班级<br />
                    民主<br />
                    评议<br />
                    小组<br />
                    意见
                </td>
                <td colspan="7" style="text-align: left; text-indent: 2em;">
                    <%=txt.REVIEW_REASON%>
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
                    学院<br />
                    审核<br />
                    意见
                </td>
                <td colspan="7" style="text-align: left; text-indent: 2em;">
                    <%=txt.COLLEGE_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="7">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 50px;">
                            （公章）</label>
                    </div>
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin: 0px 10px 0px 100px;">
                            ___________年______月______日</label>
                    </div>
                </td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; font-weight: bolder;">
                    学校<br />
                    审核<br />
                    意见
                </td>
                <td colspan="7" style="text-align: left; text-indent: 2em;">
                    <%=txt.SCHOOL_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="7">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 50px;">
                            （公章）</label>
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
                        备注：本表要求A4纸双面黑白打印，纸质版一式两份，签名处用黑色签字笔填写。</h4>
                </li>
            </ul>
        </div>
    </div>
</asp:Content>