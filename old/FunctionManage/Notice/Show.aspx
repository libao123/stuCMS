<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Show.aspx.cs" Inherits="PorteffAnaly.Web.BDM.Notice.Show" %>

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
        }
        .line
        {
            border-bottom: #bfbfbf solid 1px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            if ('<%=Request.QueryString["optype"] %>' == 'view_home') {
                $('#btnBack').hide();
            }
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div class="toolbar" style="height: 30px; line-height: 30px; text-align: left;">
        <a id="btnBack" href="#" class="easyui-linkbutton" plain="true" iconcls="icon-back"
            onclick="parent.$('#editDiv').dialog('close');">返回</a>
    </div>
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