<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Print_11_2.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.Print.Print_11_2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--COUNTRY_B：国家奖学金（本科）先进事迹：表11+2--%>
    <%--SCHOOL_MODEL：三好学生标兵先进事迹：表17+2--%>
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
                <li style="float: left;">
                    <h5>
                        报送学院（部）（公章）：<%=head.XY%>
                    </h5>
                </li>
            </ul>
        </div>
        <table cellpadding="0" cellspacing="0" style="font-size: 12px; width: 100%;" class="form-tb"
            border="1">
            <tr>
                <td style="width: 50%;">
                    姓 名
                </td>
                <td>
                    <%=head.STU_NAME%>
                </td>
            </tr>
            <tr>
                <td>
                    民 族
                </td>
                <td>
                    <%=stu.NATION%>
                </td>
            </tr>
            <tr>
                <td>
                    籍 贯
                </td>
                <td>
                    <%=stu.NATIVEPLACE%>
                </td>
            </tr>
            <tr>
                <td>
                    出生年月
                </td>
                <td>
                    <%=stu.GARDE%>
                </td>
            </tr>
            <tr>
                <td>
                    就读学院
                </td>
                <td>
                    <%=head.XY%>
                </td>
            </tr>
            <tr>
                <td>
                    就读专业
                </td>
                <td>
                    <%=head.ZY%>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; font-weight: bolder; font-size: larger;">
                    大学期间所获重要奖项或重要荣誉
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div id="divReward" runat="server">
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; font-weight: bolder; font-size: larger;">
                    已受资助情况
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div id="divPassPro" runat="server">
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; font-weight: bolder; font-size: larger;">
                    人生格言
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-indent: 2em;">
                    <%=txt.MOTTO%>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; font-weight: bolder; font-size: larger;">
                    师长点评
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-indent: 2em;">
                    <%=txt.TEACHER_INFO%>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; font-weight: bolder; font-size: larger;">
                    事迹正文
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-indent: 2em;">
                    <%=txt.MODEL_INFO%>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; font-weight: bolder; font-size: larger;">
                    个人生活近照（一张，电子版贴于框内）
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 120px;">
                </td>
            </tr>
        </table>
    </div>
</asp:Content>