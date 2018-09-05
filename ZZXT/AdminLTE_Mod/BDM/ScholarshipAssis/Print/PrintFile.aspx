<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="PrintFile.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.Print.PrintFile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        <table cellpadding="0" cellspacing="0" style="font-size: 10.5px; width: 100%;" class="form-tb"
            border="0">
            <tr>
                <td colspan="10" style="border-left: none; border-right: none;">
                    <div style="width: 100%; margin-bottom: 10px;">
                        <ul>
                            <li style="float: right;">
                                <h5>
                                    <%=strPrintCode%>
                                </h5>
                            </li>
                        </ul>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="10" style="border-left: none; border-right: none;">
                    <div style="width: 100%; margin-bottom: 10px; margin-top: 10px;">
                        <ul>
                            <li style="float: left;">
                                <h3>
                                    附件名称：<%=head.FILE_NAME%>
                                </h3>
                            </li>
                        </ul>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="width: 650px; height: 500px;">
                    <img src="<%=img_url %>" width="98%" height="98%" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>