<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Bank.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();

            loadTableList();
            loadModalBtnInit();
            $("select").each(function () {
                if ($(this).attr("ddl_name"))
                    DropDownUtils.initDropDown($(this).attr("id"));
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>银行卡信息录入</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">银行卡信息录入</li>
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
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <input type="hidden" id="OID" name="OID" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">学生银行卡信息录入</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学号<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="NUMBER" id="NUMBER" type="text" class="form-control" placeholder="学号" />
                    </div>
                
                    <label class="col-sm-2 control-label">
                        姓名<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="NAME" id="NAME" type="text" class="form-control" placeholder="姓名" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学院<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="COLLEGE" name="COLLEGE" class="form-control" ddl_name='ddl_department'
                            d_value='' title="学院" show_type="t">
                        </select>
                    </div>
                
                    <label class="col-sm-2 control-label">
                        年级<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="EDULENTH" name="EDULENTH" class="form-control" ddl_name='ddl_grade' d_value=''
                            title="年级" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        班级<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="CLASS" name="CLASS" class="form-control" ddl_name='ddl_class' d_value=''
                            title="班级" show_type="t">
                        </select>
                    </div>
                
                    <label class="col-sm-2 control-label">
                        学生类型<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="STUTYPE" name="STUTYPE" class="form-control" ddl_name='ddl_ua_stu_type'
                            d_value='' title="学生类别" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        账号类型<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="BANKTYPE" id="BANKTYPE" type="text" class="form-control" placeholder="账号类型" />
                    </div>
                
                    <label class="col-sm-2 control-label">
                        银行名称<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="BANKNAME" id="BANKNAME" type="text" class="form-control" placeholder="银行名称" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        银行卡号<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="BANKCODE" id="BANKCODE" type="text" class="form-control" placeholder="银行卡号" />
                    </div>
                
                    <label class="col-sm-2 control-label">
                        开户名<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="BANKUSERNAME" id="BANKUSERNAME" type="text" class="form-control" placeholder="开户名" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        操作人</label>
                    <div class="col-sm-4">
                        <input name="OPER" id="OPER" type="text" class="form-control" placeholder="操作人" readonly />
                    </div>
                
                    <label class="col-sm-2 control-label">
                        操作时间</label>
                    <div class="col-sm-4">
                        <input name="OPTIME" id="OPTIME" type="text" class="form-control" placeholder="操作时间"
                            readonly />
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

    <div class="modal fade" id="importModal">
        <div class="modal-dialog">
            <form id="form_import" name="form_edit" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">学生银行卡信息批量导入</h4>
            </div>
            <div class="modal-body">
                <div class="col-sm-12">
                    <iframe id="importFrame" frameborder="0" src="" style="width: 100%; height: 250px;">
                    </iframe>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
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
				{ "data": "NUMBER", "head": "学号", "type": "td-keep" },
				{ "data": "NAME", "head": "学生姓名", "type": "td-keep" },
				{ "data": "COLLEGE_NAME", "head": "学院", "type": "td-keep" },
				{ "data": 'EDULENTH_NAME', "head": '年级', "type": "td-keep" },
				{ "data": 'CLASS_NAME', "head": '班级', "type": "td-keep" },
				{ "data": 'STUTYPE_NAME', "head": '学生类型', "type": "td-keep" },
				{ "data": 'BANKTYPE', "head": '账号类型', "type": "td-keep" },
				{ "data": 'BANKNAME', "head": '银行名称', "type": "td-keep" },
				{ "data": 'BANKCODE', "head": '银行卡号', "type": "td-keep" },
				{ "data": 'BANKUSERNAME', "head": '开户名', "type": "td-keep" }
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
                    tableTitle: "学生银行卡信息导入",
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
						{ "data": "NUMBER", "pre": "学号", "col": 1, "type": "input" },
						{ "data": "NAME", "pre": "学生姓名", "col": 2, "type": "input" },
						{ "data": "COLLEGE", "pre": "学院", "col": 3, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "CLASS", "pre": "班级", "col": 4, "type": "select", "ddl_name": "ddl_class" },
						{ "data": "BANKNAME", "pre": "银行名称", "col": 5, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del",
                    <%if (IsShowBtn){ %>
					{ type: "enter", modal: null, title: "学生银行卡信息导入模板下载", action: "download" },
					{ type: "enter", modal: null, title: "学生银行卡信息批量导入", action: "import" },
                    <%} %>
                    { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                    { type: "userDefined", id: "btn-export", title: "导出", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
				], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            $(document).on("click", "button[data-action='download']", function () {
                window.open('/Excel/Model/Student/学生银行卡基本信息.xls');
            });
            $(document).on("click", "button[data-action='import']", function () {
                $("#importFrame").attr("src", '/Excel/ImportExcel/ImportExcel.aspx?model_id=importModal&type=INPUT_YHK');
                $("#importModal").modal();
            });
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
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=stubank_list' + GetSearchUrlParam());
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
						{ 'name': 'NUMBER', 'tips': '学号必须填' },
						{ 'name': 'NAME', 'tips': '姓名必须填' },
						{ 'name': 'COLLEGE', 'tips': '学院必须填' },
						{ 'name': 'EDULENTH', 'tips': '年级必须填' },
						{ 'name': 'CLASS', 'tips': '班级必须填' },
						{ 'name': 'STUTYPE', 'tips': '学生类型必须填' },
						{ 'name': 'BANKNAME', 'tips': '银行名称必须填' },
						{ 'name': 'BANKCODE', 'tips': '银行卡号必须填' }
					],
                    callback: function (form) {
                        console.log(form);
                        SaveData();
                    }
                },
                "afterShow": function (data) {
                    if (!data) {
                        $("#OPER").val('<%=user.User_Name%>');
                        $("#OPTIME").val('<%=DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")%>');
                    }
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
            var NUMBER = DropDownUtils.getDropDownValue("search-NUMBER");
            var NAME = DropDownUtils.getDropDownValue("search-NAME");
            var COLLEGE = DropDownUtils.getDropDownValue("search-COLLEGE");
            var CLASS = DropDownUtils.getDropDownValue("search-CLASS");
            var BANKNAME = DropDownUtils.getDropDownValue("search-BANKNAME");

            var strq = "";
            if (NUMBER)
                strq += "&NUMBER=" + OptimizeUtils.FormatParamter(NUMBER);
            if (NAME)
                strq += "&NAME=" + OptimizeUtils.FormatParamter(NAME);
            if (COLLEGE)
                strq += "&COLLEGE=" + COLLEGE;
            if (CLASS)
                strq += "&CLASS=" + CLASS;
            if (BANKNAME)
                strq += "&BANKNAME=" + OptimizeUtils.FormatParamter(BANKNAME);
            return strq;
        }
        //导入时，调用父界面的刷新方法，所以父界面这个方法一定要定义
        function ImportReload() {
            tablePackage.reload();
        }
    </script>
</asp:Content>