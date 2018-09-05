<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.APP.Question.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList; //主列表
        var _form_edit;
        var page_from = '<%=Request.QueryString["page_from"] %>';
        $(function () {
            adaptionHeight();
            //编辑页控制定义
            _form_edit = PageValueControl.init("form_edit");
            $("#hidPageFrom").val(page_from);
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
			<h1>问题反馈</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">问题反馈</li>
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
        <div class="modal-dialog">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">成绩录入</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidOid" name="hidOid" value="" />
                <input type="hidden" id="hidPageFrom" name="hidPageFrom" value="" />
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        问题类型</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="QUESTION_TYPE" id="QUESTION_TYPE" d_value='' ddl_name='ddl_question_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        问题反馈</label>
                    <div class="col-sm-8">
                        <textarea class="form-control" id="QUESTION_NOTE" name="QUESTION_NOTE" rows="5" placeholder="问题反馈"
                            maxlength="500"></textarea>
                    </div>
                </div>
                <div class="form-group" id="divHANDLE_NOTE">
                    <label class="col-sm-4 control-label">
                        处理回答</label>
                    <div class="col-sm-8">
                        <textarea class="form-control" id="HANDLE_NOTE" name="HANDLE_NOTE" rows="5" placeholder="处理回答"
                            maxlength="500"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSave">提交</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 遮罩层 开始-->
    <div class="maskBg">
    </div>
    <!-- 遮罩层 结束-->
    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "QUESTION_TYPE_NAME", "head": "问题类型", "type": "td-keep" },
                    { "data": "QUESTION_NOTE", "head": "问题内容", "type": "td-keep" },
				    { "data": "CREATE_CODE", "head": "反馈人学号", "type": "td-keep" },
				    { "data": "CREATE_NAME", "head": "反馈人姓名", "type": "td-keep" },
				    { "data": "CREATE_TIME", "head": "反馈时间", "type": "td-keep" },
				    { "data": "HANDLE_NOTE", "head": "处理回答", "type": "td-keep" },
				    { "data": "HANDLE_CODE", "head": "处理人工号", "type": "td-keep" },
                    { "data": "HANDLE_NAME", "head": "处理人姓名", "type": "td-keep" },
                    { "data": "HANDLE_TIME", "head": "处理时间", "type": "td-keep" },
				    { "data": "HANDLE_FLAG_NAME", "head": "处理状态", "type": "td-keep" }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: 'List.aspx?optype=getlist&page_from=' + page_from,
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "问题反馈",
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
                        { "data": "QUESTION_TYPE", "pre": "问题类型", "col": 12, "type": "select", "ddl_name": "ddl_question_type" },
                        { "data": "QUESTION_NOTE", "pre": "问题内容", "col": 11, "type": "input" },
                        { "data": "CREATE_CODE", "pre": "反馈人学号", "col": 9, "type": "input" },
                        { "data": "CREATE_NAME", "pre": "反馈人姓名", "col": 10, "type": "input" },
                        { "data": "HANDLE_FLAG", "pre": "处理标识", "col": 12, "type": "select", "ddl_name": "ddl_yes_no" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                <%if(!bIsManage){ %>
                "add",
                <%} %>
                "edit",
                <%if(bIsManage){ %>
                "del",
                <%} %>
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 按钮事件 开始-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _btns = {
                reload: '.btn-reload',
                add: '.btn-add',
                edit: '.btn-edit',
                del: '.btn-del'
            };
            //-----------主列表按钮---------------
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
            //【新增】
            _content.on('click', _btns.add, function () {
                //取消不可编辑
                _form_edit.cancel_disableAll();
                $("#btnSave").show();
                $("#hidOid").val("");
                //设置界面值（清空界面值）
                _form_edit.reset();
                //固定设置
                $("#divHANDLE_NOTE").hide();
                _tableModal.modal();
            });
            //【编辑】
            _content.on('click', _btns.edit, function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //取消不可编辑
                        _form_edit.cancel_disableAll();

                        $("#btnSave").show();
                        //根据页面类型来判断显示可编辑部分
                        if (page_from == "submit") { // 提交问题
                            //如果已经处理了，不可以再编辑
                            var result = AjaxUtils.getResponseText("List.aspx?optype=check&id=" + data.OID);
                            if (result.length > 0) {
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }
                            $("#hidOid").val(data.OID);
                            //固定设置
                            ControlUtils.Select_SetDisableStatus("QUESTION_TYPE", false);
                            ControlUtils.Select_SetDisableStatus("QUESTION_NOTE", false);
                            $("#divHANDLE_NOTE").hide();
                            //界面赋值
                            DropDownUtils.setDropDownValue("QUESTION_TYPE", data.QUESTION_TYPE);
                            var note = AjaxUtils.getResponseText("List.aspx?optype=getnote&id=" + data.OID);
                            if (note.length > 0) {
                                var note_json = eval("(" + note + ")");
                                _form_edit.setFormData(note_json);
                            }
                            _tableModal.modal();
                        }
                        else if (page_from == "manage") { // 问题管理
                            $("#hidOid").val(data.OID);
                            //固定设置
                            ControlUtils.Select_SetDisableStatus("QUESTION_TYPE", true);
                            ControlUtils.Select_SetDisableStatus("QUESTION_NOTE", true);
                            $("#divHANDLE_NOTE").show();
                            DropDownUtils.setDropDownValue("QUESTION_TYPE", data.QUESTION_TYPE);
                            var note = AjaxUtils.getResponseText("List.aspx?optype=getnote&id=" + data.OID);
                            if (note.length > 0) {
                                var note_json = eval("(" + note + ")");
                                _form_edit.setFormData(note_json);
                            }
                            _tableModal.modal();
                        }
                        else {
                            return;
                        }
                    }
                }
            });
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        $("#btnSave").hide();
                        _form_edit.disableAll();
                        _tableModal.modal();
                    }
                }
            });
            //【提交】
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("QUESTION_TYPE");
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "QUESTION_TYPE", true, "问题类型必须填");
            ValidateUtils.setRequired("#form_edit", "QUESTION_NOTE", true, "问题内容必须填");
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //【提交】
        function SaveData() {
            //校验必填项
            if (!$('#form_edit').valid()) {
                easyAlert.timeShow({
                    "content": "还有必填项未填写，请检查！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            //弹出遮罩层
            //$('.maskBg').show();
            //ZENG.msgbox.show("保存中，请稍后...", 6);
            // var layInx = layer.load(2, {
            //   content: "保存中，请稍后...",
            //   shade: [0.3,'#000'], //0.1透明度的白色背景
            //   time: 6000
            // });
            PropLoad.loading({
                title: "保存中，请稍后...",
                duration: 6
            });
            //取消不可编辑
            _form_edit.cancel_disableAll();
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal").modal("hide");
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    // layer.close(layInx);
                    PropLoad.remove();
                    easyAlert.timeShow({
                        "content": "提交成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload();
                    return;
                }
                else {
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    // layer.close(layInx);
                    PropLoad.remove();
                    easyAlert.timeShow({
                        "content": "提交失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            });
        }
        //------------------主列表按钮事件------------------
        //删除事件
        function DeleteData() {
            var data = mainList.selectSingle();
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
                                mainList.reload();
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
                                mainList.reload();
                            }
                        }
                    });
                }
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>