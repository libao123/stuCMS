<%@ Page Title="" Language="C#" MasterPageFile="~/Site2.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.FunctionManage.List" %>

<%@ OutputCache Duration="1" VaryByParam="none" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            if (window.parent) {
                var ph = $("iframe:visible", parent.document).eq(0).height();
                var pw = $("iframe:visible", window.parent.document).eq(0).width();
                //$("#menuFrame").css({ height: ph }).layout();
				console.log($(window).height());
				var wh = $(window).height();
				$(".iframe-right").css({height:wh});
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
			
			/*
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
			*/
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
	<style type="text/css">
		.iframe-right{
			position:relative;
			min-height:300px;
		}
		.iframe-right iframe{
			position:absolute;
			width:100%;
			height:100%;
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="Server">
    <div id="menuFrame" class="main-container" id="main-container">
	<div class="main-content">
	
        <div id="dTi" region="west" split="true" class="col-md-3">
            <ul id="tt">
            </ul>
			<div class="box box-solid">
				<div class="box-header with-border">
				  <h3 class="box-title">Labels</h3>

				  <div class="box-tools">
					<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
					</button>
				  </div>
				</div>
				<div class="box-body no-padding" style="display: block;">
				  <ul class="nav nav-pills nav-stacked">
					<li><a href="#"><i class="fa fa-circle-o text-red"></i> Important</a></li>
					<li><a href="#"><i class="fa fa-circle-o text-yellow"></i> Promotions</a></li>
					<li><a href="#"><i class="fa fa-circle-o text-light-blue"></i> Social</a></li>
				  </ul>
				</div>
			</div>
        </div>
        <div region="center" class="col-md-9 iframe-right">
			<iframe id="nodeUrl" name="nodeUrl" frameborder="0" src="Edit.aspx?menuid=1"></iframe>
        </div>
	
	</div>
    </div>
    <!--
	<div id="editDiv" style="width: 400px; height: 400px; display: none;">
        <iframe id="editFrame" frameborder="0" src="" style="width: 100%; height: 100%;">
        </iframe>
    </div>
	-->
</asp:Content>