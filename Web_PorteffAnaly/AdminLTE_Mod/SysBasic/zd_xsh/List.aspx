<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.SysBasic.zd_xsh.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();

            loadTableList();
            loadModalBtnInit();

            //初始化下拉
            DropDownUtils.initDropDown("XY");
            //录入控制
            LimitUtils.onlyNumAlpha("DM");
            LimitUtils.onlyNumAlpha("YWMC");
        }
    </script>
    <style type="text/css">

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
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
        <div class="modal-dialog modal-dw80">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
            onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">系所基础信息</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidUserRoles" name="hidUserRoles" value="" />
                <div class="form-group">
                    <label class="col-sm-2 control-label">系所代码<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="DM" id="DM" type="text" class="form-control" placeholder="系所代码" />
                    </div>
                    <!-- **** -->
                    <label class="col-sm-2 control-label">系所名称<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="MC" id="MC" type="text" class="form-control" placeholder="系所名称" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">所属学院<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select class="form-control" name="XY" id="XY" d_value='' ddl_name='ddl_department' show_type='t'>
                        </select>
                    </div>
                    <!-- **** -->
                    <label class="col-sm-2 control-label">英文名称</label>
                    <div class="col-sm-4">
                        <input name="YWMC" id="YWMC" type="text" class="form-control" placeholder="英文名称" />
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
    <!-- 删除界面-->
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
                <input type="hidden" name="DM" value="" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-outline btn-delete">确定</button>
            </div>
            </form>
        </div>
    </div>
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				{
				    "data": "DM",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "DM", "head": "代码", "type": "td-keep" },
				{ "data": "MC", "head": "名称", "type": "td-keep" },
				{ "data": "XY_NAME", "head": "所属学院", "type": "td-keep" }
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
                    tableTitle: "系统维护 >> 公共信息 >> 系所基础信息",
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
						{ "data": "DM", "pre": "代码", "col": 1, "type": "input" },
						{ "data": "MC", "pre": "名称", "col": 2, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }, "add", "edit", "del"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
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

            /*弹出页控制*/
            $dataModal.controls({
                "content": "content",
                "modal": "tableModal", //弹出层id
                "hasTime": true, //时间控件控制
                "hasCheckBox": false, //checkbox控制
                "submitType": "form", //form或者ajax
                "submitBtn": ".btn-save",
                "submitCallback": function (btn) {
                    console.log(btn);

                }, //自定义方法
                "valiConfig": {
                    model: '#tableModal form',
                    validate: [
						{ 'name': 'DM', 'tips': '代码必须填' },
						{ 'name': 'MC', 'tips': '名称必须填' },
						{ 'name': 'XY', 'tips': '所属学院必须填' }
					],
                    callback: function (form) {
                        console.log(form);
                        SaveData();
                    }
                },
                "afterShow": function () {
                    showBtn();
                }
            });

            /*删除控制*/
            $delModal.controls({
                "content": "content",
                "delModal": "delModal", //弹出层id
                "delSubmit": ".btn-delete",
                "submitCallBack": function (btn) {
                    DeleteData();
                }
            });
            _content.on('click', "#btn-view", function () {
                _content.find(".btn-edit").click();
                hideBtn();
            });
            var hideBtn = function () {
                $("#btnSave").hide();
            }
            var showBtn = function () {
                $("#btnSave").show();
            }
        }
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

        //删除事件
        function DeleteData() {
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=delete"), $("#form_del").serialize(), function (msg) {
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
</asp:Content>
