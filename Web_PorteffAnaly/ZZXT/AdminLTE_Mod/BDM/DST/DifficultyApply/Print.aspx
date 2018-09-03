<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="Print.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.DifficultyApply.Print" %>
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
                        <h2>广西师范大学家庭困难学生认定申请表</h2>
                    </div>
                </td>
            </tr>
        </table>
        <table cellpadding="0" cellspacing="0" style="font-size: 12px; width: 100%;" class="form-tb" border="1">
            <tr>
                <td style="text-align:center;width:13%;" colspan="2">姓名</td>
                <td style="width:16%;" colspan="2"><%=head.NAME %></td>
                <td style="text-align:center;width:10%;">性别</td>
                <td style="width:10%;"><%=cod.GetDDLTextByValue("ddl_xb", head.SEX) %></td>
                <td style="text-align:center;width:10%;">出生年月</td>
                <td style="width:10%;"><%=head.BIRTH_DATE %></td>
                <td style="text-align:center;width:10%;">民族</td>
                <td style="width:12%;"><%=cod.GetDDLTextByValue("ddl_mz", head.NATION) %></td>
            </tr>
            <tr>
                <td style="text-align:center;" colspan="2">身份证号码</td>
                <td colspan="3"><%=head.IDCARDNO %></td>
                <td style="text-align:center;" colspan="2">政治面貌</td>
                <td colspan="3"><%=cod.GetDDLTextByValue("ddl_zzmm", head.POLISTATUS) %></td>
            </tr>
            <tr>
                <td style="text-align:center;" colspan="2">院系</td>
                <td colspan="2"><%=cod.GetDDLTextByValue("ddl_department", head.COLLEGE) %></td>
                <td style="text-align:center;">专业</td>
                <td colspan="2"><%=cod.GetDDLTextByValue("ddl_zy", head.MAJOR) %></td>
                <td style="text-align:center;">班级</td>
                <td colspan="2"><%=cod.GetDDLTextByValue("ddl_class", head.CLASS) %></td>
            </tr>
            <tr>
                <td style="text-align:center;" colspan="2">学号</td>
                <td colspan="3"><%=head.NUMBER %></td>
                <td style="text-align:center;" colspan="2">在校联系电话</td>
                <td colspan="3"><%=head.TELEPHONE %></td>
            </tr>
            <tr>
                <td style="text-align:center;" colspan="2">家庭住址</td>
                <td colspan="3"><%=comHandle.ConvertAddress(head.HOME_ADDRESS) %></td>
                <td style="text-align:center;" colspan="2">家庭电话</td>
                <td colspan="3"><%=head.HOME_PHONE %></td>
            </tr>
            <tr>
                <td style="text-align:center;" colspan="2">家庭年总收入</td>
                <td colspan="3"><%=head.ANNUAL_INCOME %></td>
                <td style="text-align:center;" colspan="2">家庭人均月收入</td>
                <td colspan="3"><%=head.MONTHLY_INCOME %></td>
            </tr>
            <tr>
                <td style="text-align:center;" colspan="2">称呼</td>
                <td style="text-align:center; width:8%;">姓名</td>
                <td style="text-align:center; width:8%;">职业</td>
                <td style="text-align:center;" colspan="2">身份证号</td>
                <td style="text-align:center;" colspan="3">工作单位</td>
                <td style="text-align:center;">月收入</td>
            </tr>
            <%if (!IsHaveMember) { %>
            <tr>
                <td style="text-align:center;" colspan="2"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;" colspan="2"></td>
                <td style="text-align:center;" colspan="3"></td>
                <td style="text-align:center;"></td>
            </tr>
            <tr>
                <td style="text-align:center;" colspan="2"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;"></td>
                <td style="text-align:center;" colspan="2"></td>
                <td style="text-align:center;" colspan="3"></td>
                <td style="text-align:center;"></td>
            </tr>
            <% } else { %>
            <asp:Repeater ID="repMember" runat="server">
                <ItemTemplate>
                    <tr>
                        <td style="text-align:center;" colspan="2"><%#Eval("RELATION") %></td>
                        <td style="text-align:center;"><%#Eval("NAME") %></td>
                        <td style="text-align:center;"><%#Eval("PROFESSION") %></td>
                        <td style="text-align:center;" colspan="2"><%#Eval("IDCARDNO") %></td>
                        <td style="text-align:center;" colspan="3"><%#Eval("WORKPLACE") %></td>
                        <td style="text-align:center;"><%#Eval("INCOME_MON") %></td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
            <% } %>
            <tr>
                <td style="text-align:center;font-weight:bolder;" colspan="2">
                    申请认定家庭<br />
                    经济困难理由
                </td>
                <td colspan="8">
                    <div style="margin-bottom:8px; height:80px;"><%=head.APPLY_REASON %></div>
                    <div style="margin-bottom:8px; text-align:right;">学生签字：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日</div>
                </td>
            </tr>
            <tr>
                <td style="text-align:center;font-weight:bolder;" colspan="2">
                    在校期间<br />
                    获奖情况
                </td>
                <td colspan="8">
                    <div style="margin-bottom:8px; height:100px;"><%=strGrant %></div>
                </td>
            </tr>
            <tr>
                <td style="text-align:center;font-weight:bolder; width:5%;" rowspan="4">
                    推<br />
                    荐<br />
                    档<br />
                    次
                </td>
                <td colspan="5"><%=strLevel1 %>&nbsp;A.家庭经济特别困难（下面需勾选一项）<br /><%=strNCJDLK %>农村建档立卡&nbsp;&nbsp;&nbsp;<%=strDBJT %>低保家庭<br /><%=strguer %>孤儿&nbsp;&nbsp;<%=strcanji %>残疾&nbsp;&nbsp;<%=strqita %>其他</td>
                <td style="text-align:center;font-weight:bolder;" rowspan="4">
                    陈<br />
                    述<br />
                    理<br />
                    由
                </td>
                <td rowspan="2" colspan="3" style="border-bottom:none;"><%=head.OPINION1 %></td>
            </tr>
            <tr>
                <td colspan="5"><%=strLevel2 %>&nbsp;B.家庭经济困难</td>
            </tr>
            <tr>
                <td colspan="5"><%=strLevel3 %>&nbsp;C.家庭经济突然事件特殊困难</td>
                <td colspan="3" style="border-top:none;border-bottom:none;">评议小组组长签字：</td>
            </tr>
            <tr>
                <td colspan="5"><%=strLevel4 %>&nbsp;D.不困难</td>
                <td colspan="3" style="border-top:none; text-align:right;">年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日</td>
            </tr>
            <tr>
                <td style="text-align:center;font-weight:bolder;" rowspan="6">
                    院<br />
                    （系）<br />
                    意<br />
                    见
                </td>
                <td colspan="4" style="border-bottom:none;border-top:none;">经评议小组推荐、本院（系）认真审核后，</td>
                <td style="text-align:center;font-weight:bolder;" rowspan="6">
                    学校<br />
                    学生<br />
                    资助<br />
                    管理<br />
                    机构<br />
                    意见
                </td>
                <td colspan="4" style="border-bottom:none;border-top:none;">经学生所在院（系）提请，本机构认真核实，</td>
            </tr>
            <tr>
                <td colspan="4" style="border-bottom:none;border-top:none;"><%=strAgree2 %> 同意评议小组意见。</td>
                <td colspan="4" style="border-bottom:none;border-top:none;"><%=strAgree3 %> 同意工作组和评议小组意见。</td>
            </tr>
            <tr>
                <td colspan="4" style="border-bottom:none;border-top:none;"><%=strNAgree2 %> 不同意评议小组意见。调整为<label style="text-decoration: underline;">&nbsp;<%=strOpinion2 %>&nbsp;</label>。</td>
                <td colspan="4" style="border-bottom:none;border-top:none;"><%=strNAgree3 %> 不同意工作组和评议小组意见。调整为<label style="text-decoration: underline;">&nbsp;<%=strOpinion3 %>&nbsp;</label>。</td>
            </tr>
            <tr>
                <td colspan="4" style="border-bottom:none;border-top:none;">工作组组长签字：</td>
                <td colspan="4" style="border-bottom:none;border-top:none;">负责人签字：</td>
            </tr>
            <tr>
                <td colspan="4" style="border-bottom:none;border-top:none;">（加盖公章）</td>
                <td colspan="4" style="border-bottom:none;border-top:none;">（加盖公章）</td>
            </tr>
            <tr>
                <td colspan="4" style="border-top:none; text-align:right;">年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日</td>
                <td colspan="4" style="border-top:none; text-align:right;">年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日</td>
            </tr>
            <%--<tr>
                <td colspan="10" style="border-style:none;">
                    <div style="margin:10px 0px 10px 0px;">
                        <h3>注：此表一式两份，做为学校家庭经济困难学生认定档案，由学校及各学院（系）分别保存。盖章材料请自行保存复印件。</h3>
                    </div>
                </td>
            </tr>--%>
        </table>
    </div>
</asp:Content>

