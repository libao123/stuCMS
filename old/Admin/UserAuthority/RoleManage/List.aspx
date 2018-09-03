<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.RoleManage.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            /*表格要撑满父iframe，需先得到父iframe的高度*/
            if (window.parent) {
                var ph = $("iframe:visible", window.parent.document).eq(0).height();
                var pw = $("iframe:visible", window.parent.document).eq(0).width();
                $("#main").css({ height: ph - $("#searchDiv").height() });
                $("#funDiv").css({ height: ph - 10 });
            }

            /*以下为表格属性*/
            //固定的列
            var fCol = [[{ field: 'ck', checkbox: true, width: 100}]];
            //其他显示的列
            var cols = [[
             { field: 'NAME', title: '名称', width: 200 },
             { field: 'DESCRIPTION', title: '描述', width: 500}]];

            //定义表格的工具栏按钮
            var tBar = [{
                text: '刷新',
                iconCls: 'icon-reload',
                handler: function () {
                    $('#tabList').datagrid('reload'); //列表刷新
                }
            }, '-', {
                text: '分配权限',
                iconCls: 'icon-audit_ok',
                handler: function () {
                    var rows = $('#tabList').datagrid('getSelections');
                    if (rows.length > 1) {
                        $.messager.alert('提示', '至多选择一条记录');
                        return;
                    }
                    if (rows.length == 0) {
                        $.messager.alert('提示', '请选择记录');
                        return;
                    }

                    $("#funFrame").attr("src", "RoleFunction.aspx?optype=modi&type=R&id=" + rows[0].ROLEID);
                    $("#funDiv").show().dialog({ title: "权限管理", modal: true, draggable: false });
                }
            }, '-', {
                text: '退出',
                iconCls: 'icon-back',
                handler: function () {
                    parent.window.closeCurTab();
                }
            }];
            $("#tabList").datagrid({
                width: 500,
                height: 400,
                fit: true, //撑满父容器
                striped: true, //行交替条纹
                nowrap: true, //换行
                pagination: true, //分页栏
                singleSelect: true, //是否单选
                pageSize: 20, //每页行数
                pageList: [5, 10, 20, 30, 40], //页面行数下拉列表
                url: 'List.aspx?optype=getlist',
                remoteSort: false,
                queryParams: null, //查询参数
                frozenColumns: fCol, //固定的列
                columns: cols, //显示的列
                toolbar: tBar, //工具栏
                rownumbers: true, //序号
                onDblClickRow: function () {
                    DialogUtils.showEditDataDialog('funDiv', 'funFrame', 'tabList', '分配权限', 'RoleFunction.aspx?type=R&optype=modi', 'ROLEID');
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div id="main" style="width: 100%; height: 300px;">
        <table id="tabList">
        </table>
    </div>
    <div id="funDiv" style="width: 600px; height: 480px; display: none;">
        <iframe id="funFrame" frameborder="0" src="" style="width: 100%; height: 100%;">
        </iframe>
    </div>
</asp:Content>