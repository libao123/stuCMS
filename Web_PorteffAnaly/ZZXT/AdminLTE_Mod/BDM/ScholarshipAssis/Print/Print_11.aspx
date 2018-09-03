<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Print_11.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.Print.Print_11" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--COUNTRY_B：国家奖学金（本科）：表11+1,11+2--%>
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
                        （<%=head.PROJECT_YEAR%>
                        学年）国家奖学金申请表</h3>
                </li>
            </ul>
        </div>
        <div style="width: 100%; margin-bottom: 10px;">
            <ul>
                <li style="float: left;">
                    <h5>
                        学校：广西师范大学&nbsp; &nbsp;&nbsp; &nbsp;院（系）：<%=head.XY%>
                        &nbsp; &nbsp;学号：<%=head.STU_NUMBER%>
                    </h5>
                </li>
            </ul>
        </div>
        <table cellpadding="0" cellspacing="0" style="font-size: 12px; width: 100%;" class="form-tb"
            border="1">
            <tr>
                <td style="text-align: center; width: 5%; font-weight: bolder;" rowspan="4">
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
                    专业
                </td>
                <td>
                    <%=head.ZY%>
                </td>
                <td>
                    学制
                </td>
                <td>
                    <%=stu.SYSTEM%>
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
                <td colspan="5" style="text-align: left;">
                    <%=stu.IDCARDNO%>
                </td>
            </tr>
            <tr>
                <td style="text-align: center; font-weight: bolder;" rowspan="2">
                    学习<br />
                    情况
                </td>
                <td colspan="3">
                    成绩排名：<%=study.SCORE_RANK%>
                    /
                    <%=study.SCORE_TOTAL_NUM%>（名次/总人数）
                </td>
                <td colspan="3">
                    实行综合考试排名：<%=study.IS_SCORE_FLAG %>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    必修课
                    <%=study.MUST_COURSE_NUM%>门，其中及格以上<%=study.PASS_COURSE_NUM%>
                    门
                </td>
                <td colspan="3">
                    如是，排名：
                    <%=study.COM_SCORE_RANK%>
                    /
                    <%=study.COM_SCORE_TOTAL_NUM%>（名次/总人数）
                </td>
            </tr>
            <tr>
                <td style="text-align: center; font-weight: bolder;" rowspan="<%=nRewardList %>">
                    大学<br />
                    期间<br />
                    主要<br />
                    获奖<br />
                    情况
                </td>
                <td>
                    日期
                </td>
                <td colspan="3">
                    奖项名称
                </td>
                <td colspan="2">
                    颁奖单位
                </td>
            </tr>
            <div runat="server" id="divReward">
            </div>
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
                    理由
                </td>
                <td colspan="6" style="text-align: left; text-indent: 2em;">
                    <%=txt.RECOMM_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 100px;">
                            推荐人（辅导员或班主任）签名：</label>
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
                <td colspan="6" style="text-align: left; text-indent: 2em;">
                    <%=txt.COLLEGE_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 100px;">
                            院系主管学生工作领导签名：</label>
                    </div>
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
                <td colspan="6" style="text-align: left; text-indent: 2em;">
                    <%=txt.SCHOOL_REASON%>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div style="margin-bottom: 5px; text-align: right;">
                        <label style="margin-right: 50px;">
                            （学校公章）：</label>
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
                    <h5>
                        注：基本情况、学习情况、大学期间主要获奖情况、申请理由部分必须打印出来，不得手写，签名除外。</h5>
                </li>
            </ul>
        </div>
    </div>
</asp:Content>