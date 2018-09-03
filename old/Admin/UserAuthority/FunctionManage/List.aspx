<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.FunctionManage.List" %>

<%@ OutputCache Duration="1" VaryByParam="none" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            if (window.parent) {
                var ph = $("iframe:visible", parent.document).eq(0).height();
                var pw = $("iframe:visible", window.parent.document).eq(0).width();
                $("#menuFrame").css({ height: ph }).layout();
                if (ph - 50 > 350) {
                    $("#editDiv").css({ height: 400 });
                }
                else
                    $("#editDiv").css({ height: ph - 50 });
                if (pw * 0.8 > 470) {
                    $("#editDiv").css({ width: 470 });
                }
                else
                    $("#editDiv").css({ width: pw * 0.8 });
            }

            $('#tt').tree({
                url: 'List.aspx?optype=getlist&t' + Math.random(),
                onClick: function (node) {
                    $("#nodeUrl").attr("src", "Edit.aspx?menuid=" + node.id);
                    if (!$(this).tree("isLeaf", node.target))
                        $(this).tree('expand', node.target);
                },
                onLoadSuccess: function (node, data) {
                    var root = $("#tt").tree('getRoot');
                    if (root != null) {
                        $("#nodeUrl").attr("src", "Edit.aspx?menuid=" + root.id);
                    }
                }
            });
        });
        function EditOK(id) {
            $("#nodeUrl").attr("src", "Edit.aspx?menuid=" + id);
            $('#editDiv').dialog('close');
        }
        function AddOK() {
            $('#editDiv').dialog('close');
            $("#tt").tree("reload");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="Server">
    <div id="menuFrame" class="easyui-layout">
        <div id="dTi" region="west" split="true" style="width: 250px; overflow: auto;">
            <ul id="tt">
            </ul>
        </div>
        <div region="center" style="overflow: auto;">
            <iframe id="nodeUrl" name="nodeUrl" frameborder="0" style="width: 100%; height: 99%;"
                src=""></iframe>
        </div>
    </div>
    <div id="editDiv" style="width: 400px; height: 400px; display: none;">
        <iframe id="editFrame" frameborder="0" src="" style="width: 100%; height: 100%;">
        </iframe>
    </div>
</asp:Content>