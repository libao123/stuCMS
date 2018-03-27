<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.SysBasic.classinfo.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _form_edit;
        var _form_edit_chai;
        var _optype;
        $(function () {
            adaptionHeight();
            //编辑页控制定义
            _form_edit = PageValueControl.init("form_edit");
            _form_edit_chai = PageValueControl.init("form_edit_chai");
            _optype = "";

            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>班级基础信息</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">班级基础信息</li>
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
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">班级基础信息</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <input type="hidden" id="hidClassCode" name="hidClassCode" value="" />
                    <label class="col-sm-4 control-label">班级类型</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="STU_TYPE" id="STU_TYPE" d_value='' ddl_name='ddl_basic_stu_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">所属年级</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="GRADE" id="GRADE" d_value='' ddl_name='ddl_grade' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        所属学院</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="XY" id="XY" d_value='' ddl_name='ddl_department' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">所属专业</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="ZY" id="ZY" d_value='' ddl_name='ddl_zy' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">班级名称</label>
                    <div class="col-sm-8">
                        <input name="CLASSNAME" id="CLASSNAME" type="text" class="form-control" placeholder="班级名称" readonly />
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-12">
                        <p style="color: Red;">
                            注意：</p>
                    </div>
                    <div class="col-sm-12">
                        <p style="color: Red;">
                            班级信息为系统基础信息数据，请勿随意删改。</p>
                    </div>
                    <div class="col-sm-12">
                        <p style="color: Red;">
                            新增、修改、删除操作时，请与管理员联系！</p>
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
    <!-- 拆班编辑界面 开始 -->
    <div class="modal fade" id="tableModal_Chai">
        <div class="modal-dialog modal-dw50">
            <form action="#" method="post" id="form_edit_chai" name="form_edit_chai" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">拆班</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <input type="hidden" id="hidClassCode_Chai" name="hidClassCode_Chai" value="" />
                    <label class="col-sm-4 control-label">拆成几个班</label>
                    <div class="col-sm-8">
                        <input name="CHAI_NUM" id="CHAI_NUM" type="text" class="form-control" placeholder="拆成几个班" maxlength="2" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-12">
                        <p style="color: Red;">
                            操作说明：</p>
                    </div>
                    <div class="col-sm-12">
                        <p style="color: Red;">
                            录入“拆成几个班”数据记录之后，系统会根据录入的数据拆分才相应的小班。</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnChai">保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 拆班编辑界面 结束-->
    <!-- 列表JS加载 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				{
				    "data": "CLASSCODE",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "CLASSCODE", "head": "班级代码", "type": "td-keep" },
				{ "data": 'CLASSNAME', "head": '班级名称', "type": "td-keep" },
				{ "data": 'XY_NAME', "head": '所属学院', "type": "td-keep" },
				{ "data": 'ZY_NAME', "head": '所属专业', "type": "td-keep" },
				{ "data": 'GRADE_NAME', "head": '所属年级', "type": "td-keep" },
                { "data": "STU_TYPE_NAME", "head": "班级类型", "type": "td-keep" },
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
                    tableTitle: "班级基础信息",
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
						{ "data": "XY", "pre": "所属学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "ZY", "pre": "所属专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
						{ "data": "GRADE", "pre": "年级", "col": 3, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "STU_TYPE", "pre": "班级类型", "col": 4, "type": "select", "ddl_name": "ddl_basic_stu_type" },
						{ "data": "CLASSCODE", "pre": "班级代码", "col": 5, "type": "input" },
						{ "data": "CLASSNAME", "pre": "班级名称", "col": 6, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del",
                { type: "userDefined", id: "btn-chai", title: "拆班", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"}}], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //下拉联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE");
        }
    </script>
    <!-- 列表JS加载 结束-->
    <!-- 按钮事件 开始-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _tableModal_Chai = $("#tableModal_Chai");
            var _btns = {
                reload: '.btn-reload',
                add: '.btn-add',
                edit: '.btn-edit',
                del: '.btn-del'
            };

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });

            //新增
            _content.on('click', _btns.add, function () {
                _optype = "add";
                $("#hidClassCode").val("");
                //设置界面值（清空界面值）
                _form_edit.reset();
                _tableModal.modal();
            });

            //编辑
            _content.on('click', _btns.edit, function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    if (data.CLASSCODE) {
                        _optype = "edit";
                        $("#hidClassCode").val(data.CLASSCODE);
                        _form_edit.setFormData(data);
                        //小班不能编辑
                        if (data.PARENT_CLASSCODE.length > 0) {
                            _form_edit.disableAll(); // 设置不可编辑
                            $("#btnSave").hide();
                        }
                        else {
                            _form_edit.cancel_disableAll(); //取消不可编辑
                            $("#btnSave").show();
                        }
                        _tableModal.modal();
                    }
                }
            });

            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });

            //【拆班】
            _content.on('click', "#btn-chai", function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    if (data.CLASSCODE) {
                        //判断是否为小班，小班无法再拆班
                        var result_check = AjaxUtils.getResponseText("List.aspx?optype=check&classcode=" + data.CLASSCODE);
                        if (result_check.length > 0) {
                            easyAlert.timeShow({
                                "content": result_check,
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }

                        $("#hidClassCode_Chai").val(data.CLASSCODE);
                        //设置界面值（清空界面值）
                        _form_edit_chai.reset();
                        _tableModal_Chai.modal();
                    }
                }
            });

            //保存
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });

            //拆班：保存
            _tableModal_Chai.on('click', "#btnChai", function () {
                SaveData_Chai();
            });
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 页面初始化加载 开始-->
    <script type="text/javascript">
        function loadModalPageDataInit() {
            //初始化下拉
            DropDownUtils.initDropDown("STU_TYPE");
            DropDownUtils.initDropDown("GRADE");
            DropDownUtils.initDropDown("XY");
            DropDownUtils.initDropDown("ZY");
            //下拉改变事件
            $('#STU_TYPE,#GRADE,#ZY,#XY').change(function () {
                GetClassName();
            });
            //下拉联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("XY", "ZY", "GRADE");
        }
    </script>
    <!-- 页面初始化加载 结束-->
    <!-- 页面校验加载 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //录入控制
            LimitUtils.onlyNumAlpha("CLASSCODE");
            LimitUtils.onlyNum("CHAI_NUM");
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "STU_TYPE", true, "班级类型必须填");
            ValidateUtils.setRequired("#form_edit", "CLASSCODE", true, "班级代码必须填");
            ValidateUtils.setRequired("#form_edit", "CLASSNAME", true, "班级名称必须填");
            ValidateUtils.setRequired("#form_edit", "GRADE", true, "所属年级必须填");
            ValidateUtils.setRequired("#form_edit", "XY", true, "所属学院必须填");
            //必填项设置
            ValidateUtils.setRequired("#form_edit_chai", "CHAI_NUM", true, "拆成几个班必须填");
        }
    </script>
    <!-- 页面校验加载 结束-->
    <!-- 自定义JS 开始-->
    <script type="text/javascript">
        //获得班级名称
        function GetClassName() {
            var classname = "";
            var stu_type = $("#STU_TYPE").val();
            var grade = $("#GRADE").val();
            var xy = DropDownUtils.getDropDownText("XY");
            var zy = DropDownUtils.getDropDownText("ZY");
            var stu_type_txt = DropDownUtils.getDropDownText("STU_TYPE");
            if (stu_type == "B") {
                //ZZ 20171211 修改：本科生班级后增加（本科）字样：避免研究生在信息维护时候选错
                classname = grade + zy + "（本科）";
            } else {
                classname = grade + xy + stu_type_txt;
            }
            $("#CLASSNAME").val(classname);
        }

        //保存事件
        function SaveData() {
            //保存前校验
            var stu_type = $("#STU_TYPE").val();
            var zy = DropDownUtils.getDropDownValue("ZY");
            if (stu_type == "B") {
                if (zy.length == 0) {
                    easyAlert.timeShow({
                        "content": "班级类型为本科生时，专业必填！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            }
            //校验必填项
            if (!$('#form_edit').valid()) {
                return;
            }
            if (_optype == "edit") {
                //编辑条件下，如果该班级含有小班，不能保存，提示需要把小班删完才可以编辑
                var result = AjaxUtils.getResponseText("List.aspx?optype=chkxiaoban&classcode=" + $("#hidClassCode").val());
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            }
            //保存
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
                if (data.CLASSCODE) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除选中的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            var result = AjaxUtils.getResponseText("List.aspx?optype=delete&id=" + data.CLASSCODE);
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

        //保存拆班信息
        function SaveData_Chai() {
            //校验必填项
            if (!$('#form_edit_chai').valid()) {
                return;
            }
            var CHAI_NUM = CalculateUtiles.StringToInt($("#CHAI_NUM").val());
            if (CHAI_NUM < 0) {
                easyAlert.timeShow({
                    "content": "拆班个数不能小于0！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }

            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认进行拆班操作吗？",
                'title': '拆班操作',
                'callback': function (btn) {
                    var result = AjaxUtils.getResponseText("List.aspx?optype=chai&classcode=" + $("#hidClassCode_Chai").val()
                    + "&chai_num=" + $("#CHAI_NUM").val());
                    if (result.length != 0) {
                        $("#tableModal_Chai").modal("hide");
                        $(".Confirm_Div").modal("hide");
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    else {
                        $("#tableModal_Chai").modal("hide");
                        $(".Confirm_Div").modal("hide");
                        //保存成功：关闭界面，刷新列表
                        easyAlert.timeShow({
                            "content": "拆班成功！",
                            "duration": 2,
                            "type": "success"
                        });
                        tablePackage.reload();
                    }
                }
            });
        }
    </script>
    <!-- 自定义JS 结束-->
</asp:Content>
