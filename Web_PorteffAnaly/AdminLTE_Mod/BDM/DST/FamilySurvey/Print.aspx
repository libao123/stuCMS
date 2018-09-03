<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="Print.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.FamilySurvey.Print" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="/AdminLTE/common/plugins/jqprint/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/jqprint/jquery.jqprint-0.3.js"></script>
    <style type="text/css">
        td
        {
            height: 28px;
            border: #000 solid 1px;
            font-family: "宋体";
        }
        table
        {
            border-collapse: collapse;
        }
        .AutoNewline
        {
            word-break: break-all; /*必须*/
        }
		ul,ol,dl,p,h1,h2,h3,form,table,th,td,li{
			padding: 0px;
			margin: 0px;
		}
		li{
			list-style:none;
		}
		h3{
			font-size: 1.17em;
		}
    </style>
    <script type="text/javascript">
        function Print() {
            $("#table_print").jqprint();
            $("#table_info").jqprint();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <input type="button" onclick="Print();" value="打印" />
    <div style="width: 680px;" id="table_print">
        <table cellpadding="0" cellspacing="0" style="width: 100%;" class="form-tb" border="0">
            <tr>
                <td colspan="10" style="border:none;">
                    <div style="width: 100%; margin-bottom: 5px; text-align: right;">
                        <h5><%=head.SERIAL_NO %></h5>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="10" style="border:none;">
                    <div style="width: 100%; margin-bottom:10px; margin-top:10px;text-align: center;">
                        <h2>高等学校学生及家庭情况调查表</h2>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="10" style="border-left:none;border-right:none;border-top:none;font-size:11px;">
                    <div style="width: 100%; margin-bottom: 5px;">
                        学校：<label style="text-decoration: underline;">广西师范大学</label>&nbsp;&nbsp;
                        <%if (head.COLLEGE.Length > 0)
                            { %>
                        院（系）：<label style="text-decoration: underline;"><%=cod.GetDDLTextByValue("ddl_department", head.COLLEGE) %></label>&nbsp;&nbsp;
                        专业：<label style="text-decoration: underline;"><%=cod.GetDDLTextByValue("ddl_zy", head.MAJOR) %></label>&nbsp;&nbsp;
                        年级：<label style="text-decoration: underline;"><%=cod.GetDDLTextByValue("ddl_grade", head.GRADE) %></label>
                        <%}
                            else { %>
                        院（系）：_________________ 专业：_________________ 年级：_________________
                        <%} %>
                    </div>
                </td>
            </tr>
        </table>
        <table cellpadding="0" cellspacing="0" style="font-size: 12px; width: 100%;" class="form-tb" border="1">
            <tr style="text-align:center;">
                <td style="text-align:center; width:5%; font-weight:bolder;" rowspan="6">
                    学<br />
                    生<br />
                    基<br />
                    本<br />
                    情<br />
                    况
                </td>
                <td style="width:12%;">姓名</td>
                <td style="width:20%;" colspan="2"><%=head.NAME %></td>
                <td style="width:10%;">性别</td>
                <td style="width:10%;"><%=cod.GetDDLTextByValue("ddl_xb", head.SEX) %></td>
                <td style="width:10%;">出生年月</td>
                <td style="width:12%;"><%=head.BIRTH_DATE %></td>
                <td style="width:10%;">民族</td>
                <td style="width:10%;"><%=cod.GetDDLTextByValue("ddl_mz", head.NATION) %></td>
            </tr>
            <tr style="text-align:center;">
                <td>
                    身份证<br />
                    号码
                </td>
                <td colspan="2"><%=head.IDCARDNO %></td>
                <td>政治面貌</td>
                <td colspan="2"><%=cod.GetDDLTextByValue("ddl_zzmm", head.POLISTATUS) %></td>
                <td>入学前<br />户口</td>
                <td colspan="2" style="text-align:center;">
                    <%=strHUKOU_U %>城镇&nbsp;&nbsp;<%=strHUKOU_R %>农村
                </td>
            </tr>
            <tr style="text-align:center;">
                <td>
                    毕业<br />
                    学校
                </td>
                <td colspan="5"><%=head.GRADUATE_SCHOOL %></td>
                <td>
                    家庭<br />
                    人口数
                </td>
                <td colspan="2"><%=head.FAMILY_SIZE %></td>
            </tr>
            <tr>
                <td style="text-align:center;">
                    家庭<br />
                    类型
                </td>
                <td colspan="8">
                    &nbsp;&nbsp;<%=strOrphan %>孤儿&nbsp;&nbsp;
                    <%=strSingle %>单亲&nbsp;&nbsp;
                    <%=strDisabled %>残疾&nbsp;&nbsp;
                    <%=strMartyrs %>烈士或优抚对象子女&nbsp;&nbsp;
                    <%=strMinimum %>低保家庭&nbsp;&nbsp;
                    <%=strPoor %>建档立卡贫困户&nbsp;&nbsp;<br />
                    &nbsp;&nbsp;<%=strOther %>其他&nbsp;&nbsp;
                </td>
            </tr>
            <tr style="text-align:center;">
                <td>家庭通讯地址</td>
                <td colspan="8"><%=strAddress %></td>
            </tr>
            <tr style="text-align:center;">
                <td>
                    邮政<br />
                    编码
                </td>
                <td colspan="3"><%=head.POSTCODE %></td>
                <td colspan="2">联系电话</td>
                <td colspan="3"><%=head.TELEPHONE %></td>
            </tr>
            <tr style="text-align:center;">
                <td style="text-align:center;font-weight:bolder;" rowspan="<%=row+1 %>">
                    家<br />
                    庭<br />
                    成<br />
                    员<br />
                    情<br />
                    况
                </td>
                <td>姓名</td>
                <td style="width: 8%;">年龄</td>
                <td>与学生关系</td>
                <td colspan="3">工作(学习)单位</td>
                <td>职业</td>
                <td>年收入（元）</td>
                <td>健康状况</td>
            </tr>
            <%if (!IsHaveMember) { %>
            <tr>
                <td style="text-align:center;"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;" colspan="3"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;"></td>
            </tr>
            <tr>
                <td style="text-align:center;"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;" colspan="3"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;"></td>
            </tr>
            <% } else { %>
            <asp:Repeater ID="repMember" runat="server">
                <ItemTemplate>
                    <tr>
                        <td style="text-align:center;"><%#Eval("NAME") %></td>
                        <td style="text-align:center;"><%#Eval("AGE") %></td>
                        <td style="text-align:center;"><%#Eval("RELATION") %></td>
                        <td style="text-align:center;" colspan="3"><%#Eval("WORKPLACE") %></td>
                        <td style="text-align:center;"><%#Eval("PROFESSION") %></td>
                        <td style="text-align:center;"><%#Eval("INCOME") %></td>
                        <td style="text-align:center;"><%#Eval("HEALTH") %></td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
            <% } %>
            <tr>
                <td style="text-align:center;font-weight:bolder;">
                    家<br />
                    庭<br />
                    有<br />
                    关<br />
                    信<br />
                    息
                </td>
                <td colspan="9">
                    <div style="margin-top:8px;margin-bottom:8px;">家庭年收入 <%=Math.Round(head.INCOME_TOTAL, 2) %> 元。</div>
                    <div style="margin-bottom:8px;">学生本学年已获资助情况：<%=head.FUND_SITUA %></div>
                    <div style="margin-bottom:8px;">家庭遭受突发意外事件：<%=head.ACCIDENT_SITUA %></div>
                    <div style="margin-bottom:8px;">家庭成员失业情况：<%=head.WORK_SITUA %></div>
                    <div style="margin-bottom:8px;">家庭欠债情况及原因：<%=head.DEBT_SITUA %></div>
                    <div style="margin-bottom:8px;">其他情况：<%=head.OTHER_SITUA %></div>
                </td>
            </tr>
            <tr>
                <td colspan="10">
                    <div style="margin:5px 0px 20px 0px; font-size:12px;font-weight:bolder;">&nbsp;&nbsp;&nbsp;&nbsp;本人承诺以上所填内容真实无误，并予以认可，如不真实，本人愿意承担相应后果。</div>
                    <div style="margin-bottom:5px;text-align:right;">
                        <label>学生本人签名：</label>
                        <label style="margin-left:100px;">学生家长或监护人签名：</label>
                        <label style="margin:0px 10px 0px 100px;">___________年______月______日</label>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="text-align:center;font-weight:bolder;" colspan="2">
                    学生家庭所在地<br />
                    乡镇或街道<br />
                    民政部门<br />
                </td>
                <td colspan="8">
                    <div style="margin-top:10px;">
                        <label>经办人签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单位名称：</label>
                    </div>
                    <div style="margin:10px 200px 10px 5px; text-align:right;"><label>（加盖公章）</label></div>
                    <div><label>联系电话：</label></div>
                    <div style="margin:10px 10px 5px 5px; text-align:right;"><label>___________年______月______日</label></div>
                </td>
            </tr>
        </table>
        <div style="margin:10px 0px 10px 0px;">
            <label style="font-size: 12px;">注：本表供学生申请家庭经济困难认定和申请国家助学贷款用。可复印。请如实填写，到家庭所在地的乡（镇）或街道民政部门核实、盖章后，交到学校。如乡（镇）或街道民政部门无专用公章，可由政府代章。</label>
        </div>
    </div>
    <div style="width: 680px;" id="table_info">
        <div style="margin:10px 0px 10px 0px;">
            <label style="font-size: 16px;">填表说明：</label>
            <label style="font-size: 16px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;《高校学生及家庭情况调查表》是学生在申请家庭经济困难认定和申请校园地国家助学贷款或生源地信用助学贷款时必须提交的证明材料。请学生如实填写该表，到家庭所在地的乡（镇）或街道民政部门核实、盖章。如乡（镇）或街道民政部门无专用公章，可由政府代章。申报家庭经济困难时，向学校提交一张盖章的《调查表》原件；申请校园地国家助学贷款或生源地信用助学贷款时，向学校或经办银行提交另一张盖章的《调查表》原件。</label>
            <label style="font-size: 16px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本表可复印使用，也可登录全国学生资助管理中心网站（http://www.xszz.cee.edu.cn）下载。
</label>
        </div>
    </div>
</asp:Content>

