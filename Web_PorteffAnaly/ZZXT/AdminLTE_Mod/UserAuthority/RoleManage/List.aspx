<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.RoleManage.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="/AdminLTE/common/plugins/treeview/bootstrap-treeview.min.js"></script>
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();

            loadTableList();
            loadModalBtnInit();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
		<section class="content-header">
			<h1>角色管理</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">角色管理</li>
			</ol>
		</section>
            <section class="content" id="content">
		        <div class="row">
			        <div class="col-xs-12">
				        <div id="alertDiv"></div>
				        <div class="box box-default">
					        <table id="tablelist" class="table table-bordered table-striped table-hover">
    				        </table>
				        </div>
			        </div>
		        </div>
	        </section>
        </div>
    </div>
    <!-- 列表界面 结束-->
    <!-- 编辑界面 开始 -->
    <div class="modal fade" id="tableModal">
        <div class="modal-dialog">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">角色管理</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="ROLEID" name="ROLEID" value="" />
                <div class="form-group">
                    <label class="col-sm-3 control-label">角色名称</label>
                    <div class="col-sm-9">
                        <input name="NAME" id="NAME" type="text" class="form-control" placeholder="角色名称" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">角色描述</label>
                    <div class="col-sm-9">
                        <textarea name="DESCRIPTION" id="DESCRIPTION" rows="5" class="form-control" placeholder="角色描述"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSave">保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <div class="modal modal-warning" id="delModal">
        <div class="modal-dialog">
            <form id="form_del" name="form_del" class="modal-content  form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">删除</h4>
            </div>
            <div class="modal-body">
                <p>确定要删除该信息？</p>
                <input type="hidden" name="ROLEID" value="" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-outline btn-delete">确定</button>
            </div>
            </form>
        </div>
    </div>
    <div class="modal fade" id="selectModal">
        <div class="modal-dialog">
            <!--<section class="col-sm-12">-->
				<form class="modal-content form-horizontal">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">×</span></button>
						<h4 class="modal-title">分配权限</h4>
					</div>
					<div class="modal-body">
						<div id="tree"></div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary btn-save" id="btnSet">保存</button>
						<button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
					</div>
				</form>
			     <!--</section>-->
        </div>
    </div>
    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				    { "data": "ROLEID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "NAME", "head": "角色名称", "type": "td-keep" },
				    { "data": "DESCRIPTION", "head": "角色描述", "type": "td-keep" }
		    ];

            //配置表格
            tablePackage.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "List.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "角色管理",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
					    { "data": "NAME", "pre": "角色名称", "col": 1, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                //"add", "edit", "del",//zz 20171208屏蔽：不对外开放这些功能
                {type: "enter", modal: null, title: "分配权限", action: "SetPermission"
                }], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            $(document).on("click", "button[data-action='SetPermission']", function () {
                var data = tablePackage.selectSingle();
                if (!data.ROLEID) {
                    easyAlert.timeShow({
                        "content": "请选中一行数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                LoadTree(data.ROLEID);
                $("#selectModal").modal();
            });
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content"),
    				_btns = {
    				    reload: '.btn-reload'
    				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reDraw();
            });
        }
        $dataModal.controls({
            "content": "content",
            "modal": "tableModal", //弹出层id
            "submitType": "form", //form或者ajax
            "submitBtn": ".btn-save",
            "submitCallback": function (btn) {
                console.log(btn);
            }, //自定义方法
            "valiConfig": {
                model: '#tableModal form',
                validate: [
        				    { 'name': 'NAME', 'tips': '角色必须填' },
        				],
                callback: function (form) {
                    console.log(form);
                    SaveData();
                }
            }
        });
        //保存事件
        function SaveData() {
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length == 0) {
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    tablePackage.reload();
                }
            });
        }
        /*删除控制*/
        $delModal.controls({
            "content": "content",
            "delModal": "delModal", //弹出层id
            "delSubmit": ".btn-delete",
            "submitCallBack": function (btn) {
                DeleteData();
            }
        });
        //删除事件
        function DeleteData() {
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=del"), $("#form_del").serialize(), function (msg) {
                if (msg.length != 0) {
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    $("#delModal").modal("hide");
                    return;
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    easyAlert.timeShow({
                        "content": "删除成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    $("#delModal").modal("hide");
                    tablePackage.reload();
                }
            });
        }
    </script>
    <!--分配权限-->
    <script type="text/javascript">
        $(function () {
            $("#btnSet").click(function () {
                $(this).text("正在保存");
                $(this).attr("disabled", "disabled");
                var checkeds = $('#tree').treeview("getChecked");
                var ids = [];
                for (var i = 0; i < checkeds.length; i++) {
                    ids.push(checkeds[i].id);
                }
                $.post("List.aspx?optype=savepermission&roleid=" + tablePackage.selectSingle().ROLEID, { "ids": ids.join(",") }, function (msg) {
                    $("#btnSet").text("保存");
                    $("#btnSet").removeAttr("disabled");
                    if (msg.length == 0) {
                        $("#selectModal").modal("hide");
                        easyAlert.timeShow({
                            "content": "保存成功！",
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
        })
        function LoadTree(roleid) {
            $.get("List.aspx?optype=getmenu&roleid=" + roleid + "&t=" + Math.random(), function (data) {
                $('#tree').treeview({
                    data: data,
                    color: "#428BCA",
                    showCheckbox: true,
                    onNodeChecked: nodeChecked,
                    onNodeUnchecked: nodeUnchecked
                });
            });
        }
        var nodeCheckedSilent = false;
        function nodeChecked(event, node) {
            if (nodeCheckedSilent) {
                return;
            }
            nodeCheckedSilent = true;
            checkAllParent(node);
            checkAllSon(node);
            nodeCheckedSilent = false;
        }

        var nodeUncheckedSilent = false;
        function nodeUnchecked(event, node) {
            if (nodeUncheckedSilent)
                return;
            nodeUncheckedSilent = true;
            uncheckAllParent(node);
            uncheckAllSon(node);
            nodeUncheckedSilent = false;
        }

        //选中全部父节点
        function checkAllParent(node) {
            $('#tree').treeview('checkNode', node.nodeId, { silent: true });
            var parentNode = $('#tree').treeview('getParent', node.nodeId);
            if (!("nodeId" in parentNode)) {
                return;
            } else {
                checkAllParent(parentNode);
            }
        }
        //取消全部父节点
        function uncheckAllParent(node) {
            $('#tree').treeview('uncheckNode', node.nodeId, { silent: true });
            var siblings = $('#tree').treeview('getSiblings', node.nodeId);
            var parentNode = $('#tree').treeview('getParent', node.nodeId);
            if (!("nodeId" in parentNode)) {
                return;
            }
            var isAllUnchecked = true;  //是否全部没选中
            for (var i in siblings) {
                if (siblings[i].state.checked) {
                    isAllUnchecked = false;
                    break;
                }
            }
            if (isAllUnchecked) {
                uncheckAllParent(parentNode);
            }

        }

        //级联选中所有子节点
        function checkAllSon(node) {
            $('#tree').treeview('checkNode', node.nodeId, { silent: true });
            if (node.nodes != null && node.nodes.length > 0) {
                for (var i in node.nodes) {
                    checkAllSon(node.nodes[i]);
                }
            }
        }
        //级联取消所有子节点
        function uncheckAllSon(node) {
            $('#tree').treeview('uncheckNode', node.nodeId, { silent: true });
            if (node.nodes != null && node.nodes.length > 0) {
                for (var i in node.nodes) {
                    uncheckAllSon(node.nodes[i]);
                }
            }
        }
    </script>
</asp:Content>
