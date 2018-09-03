<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.FunctionManage.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="/AdminLTE/common/plugins/treeview/bootstrap-treeview.min.js"></script>
    <script type="text/javascript">
        $(function () {
            LoadTree();
            $("#btnAdd").click(function () {
                if (window.treeData && window.treeData.FUNCTIONID) {
                    $("#form_edit").find("input").val("");
                    $("#SHOWINMENU").val("Y");
                    $("#NOTICE_FLAG").val("N");
                    $("#QUICK_FLAG").val("N");
                    $("#YJS_FLAG").val("N");
                    $("#tableModal").modal();
                } else {
                    easyAlert.timeShow({
                        "content": "请选中一个菜单！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
            $("#btnEdit").click(function () {
                if (window.treeData && window.treeData.FUNCTIONID) {
                    var data = window.treeData;
                    $("#NAME").val(data.NAME);
                    $("#DESCRIPTION").val(data.DESCRIPTION);
                    $("#URL").val(data.URL);
                    $("#SEQUENCE").val(data.SEQUENCE);
                    $("#ICON").val(data.ICON);
                    $("#SHOWINMENU").val(data.SHOWINMENU);
                    $("#QUICK_FLAG").val(data.QUICK_FLAG);
                    $("#NOTICE_FLAG").val(data.NOTICE_FLAG);
                    $("#YJS_FLAG").val(data.YJS_FLAG);
                    $("#FUNCTIONID").val(data.FUNCTIONID);
                    $("#tableModal").modal();
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选中一个菜单！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
            $("#btnSave").click(function () {
                SaveData();
            });
            $("#btnDelete").click(function () {
                if (window.treeData && window.treeData.FUNCTIONID) {
                    $("#delModal").modal();
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选中一个菜单！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
            $("#btnConfirmDelete").click(function () {
                $.get("List.aspx?optype=del&id=" + window.treeData.FUNCTIONID, function (msg) {
                    if (msg == "删除成功") {
                        //删除成功：关闭界面，刷新列表
                        window.treeData = null;
                        window.selectNode = null;
                        $(".form-control-static").text("");
                        $("#delModal").modal("hide");
                        LoadTree();
                        easyAlert.timeShow({
                            "content": "删除成功！",
                            "duration": 2,
                            "type": "success"
                        });
                    }
                    else {
                        easyAlert.timeShow({
                            "content": msg,
                            "duration": 2,
                            "type": "danger"
                        });
                    }
                });
            });
            DropDownUtils.initDropDown("SHOWINMENU");
            DropDownUtils.initDropDown("QUICK_FLAG");
            DropDownUtils.initDropDown("NOTICE_FLAG");
            DropDownUtils.initDropDown("YJS_FLAG");
        })
        function LoadTree() {
            $.get("List.aspx?optype=getlist&t=" + Math.random(), function (data) {
                $('#tree').treeview({
                    data: data,
                    color: "#428BCA"
                });
                if (window.selectNode) {
                    getNodeData(window.selectNode);
                    var parentNode = $('#tree').treeview('getParent', window.selectNode);
                    if (parentNode.nodeId)
                        $('#tree').treeview('expandNode', [parentNode, { silent: true}]);
                }
                $(document).on('nodeSelected', '#tree', function (event, node) {
                    getNodeData(node);
                });
            });
        }
        function getNodeData(node) {
            window.selectNode = node;
            var url = "List.aspx?optype=getnode&id=" + node.id + "&t=" + Math.random();
            $.get(url, function (data) {
                $("#lb-name p").text(data.NAME);
                $("#lb-description p").text(data.DESCRIPTION);
                $("#lb-url p").text(data.URL);
                $("#lb-sequence p").text(data.SEQUENCE);
                $("#lb-icon p").text(data.ICON);
                $("#lb-showinmenu p").text(data.SHOWINMENU == "Y" ? "是" : (data.SHOWINMENU == "N" ? "否" : ""));
                $("#lb-quick_flag p").text(data.QUICK_FLAG == "Y" ? "是" : (data.QUICK_FLAG == "N" ? "否" : ""));
                $("#lb-notice_flag p").text(data.NOTICE_FLAG == "Y" ? "是" : (data.NOTICE_FLAG == "N" ? "否" : ""));
                $("#lb-yjs_flag p").text(data.YJS_FLAG == "Y" ? "是" : (data.YJS_FLAG == "N" ? "否" : ""));
                $("#lb-functionid p").text(data.HASROLE);
                window.treeData = data;
            })
        }
        function SaveData() {
            if (!$("#NAME").val()) {
                easyAlert.timeShow({
                    "content": "名称不能为空",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            var optype = "save";
            if (!$("#FUNCTIONID").val()) {
                optype = "add";
            }
            var id = window.treeData.FUNCTIONID;
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=" + optype + "&id=" + id), $("#form_edit").serialize(), function (msg) {
                if (msg == "保存成功") {
                    LoadTree();
                    $("#tableModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                }
                else {
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div id="menuFrame" class="content-wrapper" id="main-container">
        <section class="content-header">
		<h1>功能管理</h1>
	    <ol class="breadcrumb">
	      	<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
	      	<li>系统维护</li>
	      	<li class="active">功能管理</li>
	    </ol>
  	</section>
        <div class="content">
            <div class="box box-default" style="overflow: hidden;">
                <div id="buttonId" class="box-header">
                    <h3 class="box-title">
                        功能管理</h3>
                    <div class="box-tools">
                        <div class="input-group input-group-sm">
                            <div class="input-group-btn" style="display: inline-block">
                                <button type="button" class="btn btn-primary btn-xs" id="btnAdd">
                                    录入子菜单</button>
                                <button style="margin-left: 6px;" type="button" class="btn btn-primary btn-xs" id="btnEdit">
                                    修改</button>
                                <button style="margin-left: 6px;" type="button" class="btn btn-warning btn-xs" id="btnDelete">
                                    删除</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box-body">
                    <aside class="content-sidebar col-sm-4">
		<div class="col-sm-12">
			<div id="tree"></div>
		</div>
	</aside>
                    <section class="content-sidebar col-sm-8">
		<div class="col-sm-12 panel panel-default">
			<div class="panel-body">
				<form action="#" method="post" id="form_view" name="form_view" class="modal-content form-horizontal">
					<div class="">
						<div class="form-group col-sm-12">
							<label class="col-md-3 control-label">名称</label>
							<div class="col-md-9 col-sm-12" id="lb-name">
								<p class="form-control-static">-</p>
							</div>
						</div>
						<div class="form-group col-sm-12">
							<label class="col-md-3 control-label">功能描述</label>
							<div class="col-md-9 col-sm-12" id="lb-description">
								<p class="form-control-static">-</p>
							</div>
						</div>
						<div class="form-group col-sm-12">
							<label class="col-md-3 control-label">页面地址</label>
							<div class="col-md-9 col-sm-12" id="lb-url">
								<p class="form-control-static">-</p>
							</div>
						</div>
						<div class="form-group col-sm-12">
							<label class="col-md-3 control-label">排序</label>
							<div class="col-md-9 col-sm-12" id="lb-sequence">
								<p class="form-control-static">-</p>
							</div>
						</div>
						<div class="form-group col-sm-12">
							<label class="col-md-3 control-label">功能图标</label>
							<div class="col-md-9 col-sm-12" id="lb-icon">
								<p class="form-control-static">-</p>
							</div>
						</div>
						<div class="form-group col-sm-12">
							<label class="col-md-3 control-label">显示为菜单</label>
							<div class="col-md-9 col-sm-12" id="lb-showinmenu">
								<p class="form-control-static">-</p>
							</div>
						</div>
                        <div class="form-group col-sm-12">
							<label class="col-md-3 control-label">是否设置为快速指引</label>
							<div class="col-md-9 col-sm-12" id="lb-quick_flag">
								<p class="form-control-static">-</p>
							</div>
						</div>
						<div class="form-group col-sm-12">
							<label class="col-md-3 control-label">是否为公告快速进入功能</label>
							<div class="col-md-9 col-sm-12" id="lb-notice_flag">
								<p class="form-control-static">-</p>
							</div>
						</div>
                        <div class="form-group col-sm-12">
							<label class="col-md-3 control-label">研究生是否屏蔽</label>
							<div class="col-md-9 col-sm-12" id="lb-yjs_flag">
								<p class="form-control-static">-</p>
							</div>
						</div>
						<div class="form-group col-sm-12">
							<label class="col-md-3 control-label">已分配岗位</label>
							<div class="col-md-9 col-sm-12" id="lb-functionid">
								<p class="form-control-static">-</p>
							</div>
						</div>
						<div class="form-group col-sm-12" style="color: Red; display:none;">
							说明：<br />
							1.菜单管理是最高级别，不能修改和删除!
							<br />
							2.菜单存在子菜单则不能删除!
						</div>
					</div>
				</form>
			</div>
		</div>
	</section>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="tableModal">
        <div class="modal-dialog">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal">
            <input type="hidden" id="FUNCTIONID" name="FUNCTIONID" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    功能管理</h4>
            </div>
            <div class="modal-body row">
                <div class="form-group col-sm-12">
                    <label class="col-sm-4 col-xs-12 control-label">
                        名称</label>
                    <div class="col-sm-8 col-xs-12">
                        <input id="NAME" name="NAME" type="text" class="form-control" />
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-4 control-label">
                        功能描述</label>
                    <div class="col-sm-8">
                        <input id="DESCRIPTION" name="DESCRIPTION" type="text" class="form-control" />
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-4 control-label">
                        页面地址</label>
                    <div class="col-sm-8">
                        <input id="URL" name="URL" type="text" class="form-control" />
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-4 control-label">
                        排序</label>
                    <div class="col-sm-8">
                        <input id="SEQUENCE" name="SEQUENCE" type="text" class="form-control" />
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-4 control-label">
                        功能图标</label>
                    <div class="col-sm-8">
                        <input id="ICON" name="ICON" type="text" class="form-control" />
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-4 control-label">
                        显示为菜单</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="SHOWINMENU" id="SHOWINMENU" ddl_name='ddl_yes_no'
                            show_type='t' d_value="">
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-4 control-label">
                        是否设置为快速指引</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="QUICK_FLAG" id="QUICK_FLAG" ddl_name='ddl_yes_no'
                            show_type='t' d_value="">
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-4 control-label">
                        是否为公告快速进入功能</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="NOTICE_FLAG" id="NOTICE_FLAG" ddl_name='ddl_yes_no'
                            show_type='t' d_value="">
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-4 control-label">
                        研究生是否屏蔽</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="YJS_FLAG" id="YJS_FLAG" ddl_name='ddl_yes_no'
                            show_type='t' d_value="">
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-save" id="btnSave">
                        保存</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        关闭</button>
                </div>
            </div>
            </form>
        </div>
    </div>
    <!-- 删除界面 结束-->
    <div class="modal modal-warning" id="delModal">
        <div class="modal-dialog">
            <form id="form_del" name="form_del" class="modal-content  form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    删除</h4>
            </div>
            <div class="modal-body">
                <p>
                    确定要删除该菜单？</p>
                <input type="hidden" name="USER_ID" value="" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">
                    取消</button>
                <button type="button" class="btn btn-outline btn-delete" id="btnConfirmDelete">
                    确定</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 删除界面 结束-->
</asp:Content>
