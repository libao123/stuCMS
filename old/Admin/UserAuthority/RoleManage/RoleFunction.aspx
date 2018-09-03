<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="RoleFunction.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.RoleManage.RoleFunction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            $('#tt').tree({
                url: 'RoleFunction.aspx?optype=getmenu&roleid=<%=Request.QueryString["id"] %>&t' + Math.random(),
                onClick: function (node) {
                    if (!$(this).tree("isLeaf", node.target))
                        $(this).tree('expand', node.target);
                },
                onLoadSuccess: function (node, data) {
                    var root = $("#tt").tree('getRoot');
                    if (root != null) {
                        $("#nodeUrl").attr("src", "Edit.aspx?menuid=" + root.id);
                    }
                    if ('<%=Request.QueryString["optype"] %>' == 'view') {
                        expandAll();
                    }
                }
            });
        });
        function getselect() {
            var nodesParent = []; //子菜单没有完全选中的父节点(实心父节点,即子节点有勾选但是父节点没有勾选的项)
            var ids = [];
            $("#tt").find('.tree-checkbox2').each(function () {
                var node = $(this).parent();
                nodesParent.push($.extend({}, $.data(node[0], 'tree-node'), {
                    target: node[0],
                    checked: node.find('.tree-checkbox').hasClass('tree-checkbox2')
                }));
            });
            for (var i = 0; i < nodesParent.length; i++) {
                ids.push(nodesParent[i].attributes.code); //传code
            }
            var nodes = $('#tt').tree('getChecked');
            for (var j = 0; j < nodes.length; j++) {
                ids.push(nodes[j].attributes.code); //传code
            }
            $('#Description').val(ids.join(','));
            return true;
        }
        function collapseAll() {
            $('#tt').tree('collapseAll');
        }
        function expandAll() {
            $('#tt').tree('expandAll');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="f1" runat="server">
    <div style="height: 30px; line-height: 30px; background: #efefef;" class="datagrid-toolbar">
        <asp:LinkButton ID="saveBtn" runat="server" class="easyui-linkbutton" plain="true"
            iconCls="icon-save" OnClientClick="return getselect();" OnClick="saveBtn_Click">保存</asp:LinkButton><a
                href="javascript:expandAll()" class="easyui-linkbutton" plain="true" iconcls="icon-add">展开所有节点</a>
        <a href="javascript:collapseAll()" class="easyui-linkbutton" plain="true" iconcls="icon-remove">
            收起所有节点</a> <a href="#" class="easyui-linkbutton" plain="true" iconcls="icon-back"
                onclick="parent.$('#funDiv').dialog('close');">返回</a>
    </div>
    <input type="text" class="easyui-validatebox input-text" id="Description" name="Description"
        style="width: 80%; display: none;"></input>
    <div>
        <ul id="tt" checkbox="true">
        </ul>
    </div>
    </form>
</asp:Content>