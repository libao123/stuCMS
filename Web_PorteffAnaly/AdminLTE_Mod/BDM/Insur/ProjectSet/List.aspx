<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectSet.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();
            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>保险项目设置</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>保险管理</li>
				<li class="active">保险项目设置</li>
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
    <div class="modal" id="tableModal">
        <div class="modal-dialog" style="width: 50%;">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
            onsubmit="return false;">
            <input type="hidden" id="OID" name="OID" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    保险项目设置</h4>
            </div>
            <div class="modal-body row">
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        保险项目类型<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="INSUR_TYPE" id="INSUR_TYPE" d_value='' ddl_name='ddl_insur_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        保险项目学年<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="INSUR_YEAR" id="INSUR_YEAR" d_value='' ddl_name='ddl_year_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-2 control-label">
                        保险项目名称<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input name="INSUR_NAME" id="INSUR_NAME" type="text" class="form-control" placeholder="保险项目名称" />
                    </div>
                </div>
                <div class="form-group col-sm-6"" >
                    <label class="col-sm-4 control-label">
                        承保期限</label>
                    <div class="col-sm-8">
                        <input name="INSUR_LIMITDATE" id="INSUR_LIMITDATE" type="text" class="form-control"
                            placeholder="承保期限" />
                    </div>
                   </div>
                   <div class="form-group col-sm-6"" >
                    <label class="col-sm-4 control-label">
                        金额</label>
                    <div class="col-sm-8">
                        <input name="INSUR_MONEY" id="INSUR_MONEY" type="text" class="form-control" placeholder="金额" />
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-2 control-label">
                        保险项目说明</label>
                    <div class="col-sm-10">
                        <textarea id="INSUR_INFO" name="INSUR_INFO" class="form-control" rows="3"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSave">
                    保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
                { "data": "INSUR_TYPE_NAME", "head": "保险项目类型", "type": "td-keep" },
                { "data": "INSUR_YEAR_NAME", "head": "保险项目学年", "type": "td-keep" },
				{ "data": "INSUR_NAME", "head": "保险项目名称", "type": "td-keep" },
				{ "data": "INSUR_INFO", "head": "保险项目说明", "type": "td-keep" },
                { "data": "OP_NAME", "head": "设置人", "type": "td-keep" },
                { "data": "OP_TIME", "head": "设置时间", "type": "td-keep" }
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
                    tableTitle: "保险项目设置",
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
                        { "data": "INSUR_TYPE", "pre": "保险项目类型", "col": 1, "type": "select", "ddl_name": "ddl_insur_type" },
                    	{ "data": "INSUR_YEAR", "pre": "保险项目学年", "col": 2, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
						{ "data": "INSUR_NAME", "pre": "保险项目名称", "col": 3, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("INSUR_YEAR");
            DropDownUtils.initDropDown("INSUR_TYPE");
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload',
				    del: '.btn-del'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
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
                        { 'name': 'INSUR_TYPE', 'tips': '保险项目类型必须填' },
                    	{ 'name': 'INSUR_YEAR', 'tips': '保险项目学年必须填' },
						{ 'name': 'INSUR_NAME', 'tips': '保险项目名称必须填' }
					],
                    callback: function (form) {
                        console.log(form);
                        SaveData();
                    }
                },
                "afterShow": function (data) {
                    showBtn();
                }
            });
            var hideBtn = function () {
                $("#btnSave").hide();
            }
            var showBtn = function () {
                $("#btnSave").show();
            }

            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
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
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除所选的数据吗？",
                'title': '删除',
                'callback': function (btn) {
                    var data = tablePackage.selectSingle();
                    if (data) {
                        if (data.OID) {
                            var url = "List.aspx?optype=delete&id=" + data.OID;
                            var result = AjaxUtils.getResponseText(url);
                            if (result.length > 0) {
                                $(".Confirm_Div").modal("hide");
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                tablePackage.reload();
                                return;
                            }
                            else {
                                //保存成功：关闭界面，刷新列表
                                $(".Confirm_Div").modal("hide");
                                easyAlert.timeShow({
                                    "content": "删除成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                tablePackage.reload();
                                return;
                            }
                        }
                    }
                }
            });
        }
    </script>
</asp:Content>