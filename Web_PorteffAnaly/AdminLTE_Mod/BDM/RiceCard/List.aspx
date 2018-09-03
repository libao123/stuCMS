<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.RiceCard.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();

            loadTableList();
            loadModalPageDataInit();
            loadModalBtnInit();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>学生饭卡管理</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">学生饭卡管理</li>
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
        <div class="modal-dialog modal-dw70">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal"
            onsubmit="return false;">
            <input type="hidden" id="OID" name="OID" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    学生饭卡管理</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学号<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="STU_NUMBER" id="STU_NUMBER" type="text" class="form-control" placeholder="学号"
                            onblur="GetStuInfo();" maxlength="20" />
                    </div>
                    <label class="col-sm-2 control-label">
                        姓名</label>
                    <div class="col-sm-4">
                        <input name="STU_NAME" id="STU_NAME" type="text" class="form-control" placeholder="姓名"
                            readonly="true" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学院</label>
                    <div class="col-sm-4">
                        <select id="XY" name="XY" class="form-control" ddl_name='ddl_department' d_value=''
                            title="学院" show_type="t" readonly="true">
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">
                        专业</label>
                    <div class="col-sm-4">
                        <select id="ZY" name="ZY" class="form-control" ddl_name='ddl_zy' d_value='' title="专业"
                            show_type="t" readonly="true">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        年级</label>
                    <div class="col-sm-4">
                        <select id="GRADE" name="GRADE" class="form-control" ddl_name='ddl_grade' d_value=''
                            title="年级" show_type="t" readonly="true">
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">
                        班级</label>
                    <div class="col-sm-4">
                        <select id="CLASS_CODE" name="CLASS_CODE" class="form-control" ddl_name='ddl_class'
                            d_value='' title="班级" show_type="t" readonly="true">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        饭卡号<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="RICE_CARD" id="RICE_CARD" type="text" class="form-control" placeholder="饭卡号"
                            maxlength="25" />
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
    <!-- 导入界面 开始-->
    <div class="modal fade" id="importModal">
        <div class="modal-dialog">
            <form id="form_import" name="form_edit" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    学生饭卡信息批量导入</h4>
            </div>
            <div class="modal-body">
                <div class="col-sm-12">
                    <iframe id="importFrame" frameborder="0" src="" style="width: 100%; height: 250px;">
                    </iframe>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 导入界面 结束-->
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
				{ "data": "STU_NUMBER", "head": "学号", "type": "td-keep" },
				{ "data": "STU_NAME", "head": "学生姓名", "type": "td-keep" },
				{ "data": "XY_NAME", "head": "学院", "type": "td-keep" },
                { "data": "ZY_NAME", "head": "专业", "type": "td-keep" },
				{ "data": 'GRADE_NAME', "head": '年级', "type": "td-keep" },
				{ "data": 'CLASS_NAME', "head": '班级', "type": "td-keep" },
				{ "data": 'RICE_CARD', "head": '饭卡号', "type": "td-keep" },
				{ "data": 'OP_NAME', "head": '操作人', "type": "td-keep" },
				{ "data": 'OP_TIME', "head": '操作时间', "type": "td-keep" }
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
                    tableTitle: "学生饭卡管理",
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
						{ "data": "STU_NUMBER", "pre": "学号", "col": 1, "type": "input" },
						{ "data": "STU_NAME", "pre": "学生姓名", "col": 2, "type": "input" },
						 { "data": "XY", "pre": "学院", "col": 5, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 6, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 7, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 8, "type": "select", "ddl_name": "ddl_class" },
						{ "data": "RICE_CARD", "pre": "饭卡号", "col": 5, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del",
                    <%if (IsShowBtn){ %>
					{ type: "enter", modal: null, title: "学生饭卡信息导入模板下载", action: "download" },
					{ type: "enter", modal: null, title: "学生饭卡信息批量导入", action: "import" },
                    <%} %>
                    { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                    { type: "userDefined", id: "btn-export", title: "导出", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
				], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASS_CODE");

            $(document).on("click", "button[data-action='download']", function () {
                window.open('/Excel/Model/Rice/导入模板_学生饭卡信息.xls');
            });
            $(document).on("click", "button[data-action='import']", function () {
                $("#importFrame").attr("src", '/Excel/ImportExcel/ImportExcel.aspx?model_id=importModal&type=INPUT_RICECARD');
                $("#importModal").modal();
            });
        }
    </script>
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("XY");
            DropDownUtils.initDropDown("ZY");
            DropDownUtils.initDropDown("GRADE");
            DropDownUtils.initDropDown("CLASS_CODE");
        }
    </script>
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
            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
            //【导出】
            _content.on('click', "#btn-export", function () {
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=sturice_list' + GetSearchUrlParam());
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
						{ 'name': 'STU_NUMBER', 'tips': '学号必须填' },
						{ 'name': 'BANKCODE', 'tips': '银行卡号必须填' }
					],
                    callback: function (form) {
                        SaveData();
                    }
                },
                "afterShow": function (data) {
                    showBtn();
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
            var data = tablePackage.selectSingle();
            if (data) {
                if (data.OID) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除选中的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            var result = AjaxUtils.getResponseText("List.aspx?optype=delete&id=" + data.OID);
                            if (result.length != 0) {
                                $(".Confirm_Div").modal("hide");
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }
                            else {
                                $(".Confirm_Div").modal("hide");
                                //保存成功：关闭界面，刷新列表
                                easyAlert.timeShow({
                                    "content": "删除成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                tablePackage.reload();
                            }
                        }
                    });
                }
            }
        }
        //获得查询条件中的参数
        function GetSearchUrlParam() {
            var STU_NUMBER = DropDownUtils.getDropDownValue("search-STU_NUMBER");
            var STU_NAME = DropDownUtils.getDropDownValue("search-STU_NAME");
            var XY = DropDownUtils.getDropDownValue("search-XY");
            var CLASS_CODE = DropDownUtils.getDropDownValue("search-CLASS_CODE");
            var RICE_CARD = DropDownUtils.getDropDownValue("search-RICE_CARD");

            var strq = "";
            if (STU_NUMBER)
                strq += "&STU_NUMBER=" + OptimizeUtils.FormatParamter(STU_NUMBER);
            if (STU_NAME)
                strq += "&STU_NAME=" + OptimizeUtils.FormatParamter(STU_NAME);
            if (XY)
                strq += "&XY=" + XY;
            if (CLASS_CODE)
                strq += "&CLASS_CODE=" + CLASS_CODE;
            if (RICE_CARD)
                strq += "&RICE_CARD=" + OptimizeUtils.FormatParamter(RICE_CARD);
            return strq;
        }

        //导入时，调用父界面的刷新方法，所以父界面这个方法一定要定义
        function ImportReload() {
            tablePackage.reload();
        }

        //通过学生工号带出相关信息
        function GetStuInfo() {
            if ($("#STU_NUMBER").val().length == 0) {
                ClearStuInfo();
                return;
            }

            //通过学号获得学生基本信息
            var url = "List.aspx?optype=getstuinfo&stuno=" + $("#STU_NUMBER").val();
            var result = AjaxUtils.getResponseText(url);
            if (result.length > 0) {
                var jsonResult = $.parseJSON(result);
                $("#STU_NAME").val(jsonResult.NAME);
                DropDownUtils.setDropDownValue("XY", jsonResult.COLLEGE);
                DropDownUtils.setDropDownValue("ZY", jsonResult.MAJOR);
                DropDownUtils.setDropDownValue("GRADE", jsonResult.EDULENTH);
                DropDownUtils.setDropDownValue("CLASS_CODE", jsonResult.CLASS);
            }
            else {
                easyAlert.timeShow({
                    "content": "不存在该学号，请确认！",
                    "duration": 2,
                    "type": "danger"
                });
                ClearStuInfo();
                return;
            }
        }

        //清除数据
        function ClearStuInfo() {
            $("#STU_NUMBER").val('');
            $("#STU_NAME").val('');
            $("#XY").val('');
            $("#ZY").val('');
            $("#CLASS_CODE").val('');
            $("#GRADE").val('');
            $("#RICE_CARD").val('');
            $("#STU_NUMBER").focus();
        }
    </script>
</asp:Content>