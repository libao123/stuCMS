<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Show.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Notice.Show" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .title
        {
            font-size: 22px;
            text-align: center;
            font-family: "微软雅黑" , "黑体" , "宋体";
        }
        .subtitle
        {
            font-size: 16px;
            text-align: center;
            font-family: "微软雅黑" , "黑体" , "宋体";
            padding: 5px;
        }
        .info
        {
            font-size: 12px;
            color: #999;
            text-align: center;
            padding: 5px;
        }
        .line
        {
            border-bottom: #bfbfbf solid 1px;
        }
    </style>
    <script type="text/javascript">
      window.onload = function(){
        try {
          adaptionHeight();
        } catch (e) {
            console.log(e);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <table style="width: 100%;">
        <tr align="center">
            <td class="title">
                <%=head.TITLE %>
            </td>
        </tr>
        <tr align="center">
            <td class="subtitle">
                <%=head.SUB_TITLE %>
            </td>
        </tr>
        <tr align="center">
            <td class="info">
                <label>
                    发布人：</label>
                <%=head.SEND_NAME%>
                <label style="margin-left: 20px;">
                    发布时间：</label><%=head.SEND_TIME%>
            </td>
        </tr>
        <%if (head.FUNCTION_ID.Length > 0)
          {%>
        <tr align="center">
            <td class="info">
                <a data-title="<%=fun.NAME %>" href="<%=fun.URL %>">从此快速进入</a>
            </td>
        </tr>
        <%} %>
        <tr align="center">
            <td class="line">
            </td>
        </tr>
    </table>
    <div style="height: 10px;">
    </div>
    <div id="content" style="margin: 10px;">
        <%=head.NOTICE_CONTENT%>
    </div>
</asp:Content>
