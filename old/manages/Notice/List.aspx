<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Notice.List"
    ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="/AdminLTE/common/plugins/ckeditor/ckeditor.js"></script>
    <script type="text/javascript">
        var _form_edit;
        var editorObj;
        $(function () {
            adaptionHeight();
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });
            //编辑页控制定义
            _form_edit = PageValueControl.init("form_edit");
            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
            loadEditor("NOTICE_CONTENT");
        });
        //加载编辑器
        function loadEditor(id) {
            var instance = CKEDITOR.instances[id];
            if (instance) {
                CKEDITOR.remove(instance);
            }
            editorObj = CKEDITOR.replace(id, { customConfig: '/AdminLTE/common/plugins/ckeditor/config.js' });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>公告管理</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">公告管理</li>
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
        <div class="modal-dialog" style="width: 80%;">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
            onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    公告管理</h4>
            </div>
            <div class="modal-body row">
                <input type="hidden" id="hidNOTICE_OID" name="hidNOTICE_OID" value="" />
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        公告分类<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="NOTICE_TYPE" id="NOTICE_TYPE" d_value='' ddl_name='ddl_notice_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        快速进入设置</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="FUNCTION_ID" id="FUNCTION_ID" d_value='' ddl_name='ddl_notice_fast_in'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-2 control-label">
                        标题<span style="color: red">*</span></label>
                    <div class="col-sm-10">
                        <input name="TITLE" id="TITLE" type="text" class="form-control" placeholder="标题" />
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-2 control-label">
                        副标题</label>
                    <div class="col-sm-10">
                        <input name="SUB_TITLE" id="SUB_TITLE" type="text" class="form-control" placeholder="副标题" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        有效时间</label>
                    <div class="col-sm-8" style="position: relative; z-index: 9999">
                        <input name="START_TIME" id="START_TIME" type="text" class="form-control datep" placeholder="有效起始时间" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        至</label>
                    <div class="col-sm-8" style="position: relative; z-index: 9999">
                        <input name="END_TIME" id="END_TIME" type="text" class="form-control datep" placeholder="有效结束时间" />
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-2 control-label">
                        查阅角色</label>
                    <div class="col-sm-10">
                        <div id="divUserRole">
                        </div>
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-2 control-label">
                        发布内容<span style="color: red">*</span></label>
                    <div class="col-sm-10">
                        <textarea name="NOTICE_CONTENT" id="NOTICE_CONTENT" cols="10" rows="5" class="form-control ckEditor"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSave">
                    发布</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            <input type="hidden" id="hidUserRoles" name="hidUserRoles" />
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 查阅预览界面 开始-->
    <div class="modal" id="preModal">
        <div class="modal-dialog" style="width: 90%;">
            <form id="form_pre" name="form_pre" class="modal-content  form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    查阅公告</h4>
            </div>
            <div class="modal-body row">
                <div class="col-sm-12">
                    <iframe id="preFrame" frameborder="0" src="" style="width: 100%;"></iframe>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 查阅预览界面 结束-->
    <!-- 遮罩层 开始-->
    <div class="maskBg">
    </div>
    <!-- 遮罩层 结束-->
    <!-- 列表JS 开始-->
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
				{ "data": "NOTICE_TYPE_NAME", "head": "公告类型", "type": "td-keep" },
				{ "data": 'TITLE', "head": '标题', "type": "td-keep" },
				{ "data": 'START_TIME', "head": '公告有效开始时间', "type": "td-keep" },
				{ "data": 'END_TIME', "head": '公告有效结束时间', "type": "td-keep" },
				{ "data": 'SEND_NAME', "head": '发布人', "type": "td-keep" },
				{ "data": 'SEND_TIME', "head": '发布时间', "type": "td-keep" }
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
                    tableTitle: "公告管理",
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
						{ "data": "NOTICE_TYPE", "pre": "公告类型", "col": 1, "type": "select", "ddl_name": "ddl_notice_type" },
						{ "data": "TITLE", "pre": "标题", "col": 2, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                { type: "userDefined", id: "preview", title: "查阅预览", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                <%if(bFlag){%>
                 "add", "edit", "del"
                 <%} %>
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 按钮初始化事件 开始-->
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
            //【刷新】
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });
            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
            //【新增】
            _content.on('click', _btns.add, function () {
                _form_edit.reset();
                $("#S").iCheck("check"); //iCheck绑定
                $("#F").iCheck("check"); //iCheck绑定
                $("#X").iCheck("check"); //iCheck绑定
                $("#Y").iCheck("check"); //iCheck绑定
                editorObj.setData("");
                _tableModal.modal();
            });
            //【编辑】
            _content.on('click', _btns.edit, function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    if (data.OID) {
                        _form_edit.setFormData(data);
                        $("#hidNOTICE_OID").val(data.OID);
                        $("#S").iCheck("uncheck"); //iCheck绑定
                        $("#F").iCheck("uncheck"); //iCheck绑定
                        $("#X").iCheck("uncheck"); //iCheck绑定
                        $("#Y").iCheck("uncheck"); //iCheck绑定
                        GetCheckBoxSelectedLoad(data.ROLEID);
                        //加载内容
                        var content = AjaxUtils.getResponseText("List.aspx?optype=getcontent&id=" + data.OID);
                        if (content)
                            editorObj.setData(content);
                        _tableModal.modal();
                    }
                }
            });
            //【查阅预览】
            _content.on('click', "#preview", function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    if (data.OID) {
                        $("#preFrame").attr("src", OptimizeUtils.FormatUrl("Show.aspx?optype=view&id=" + data.OID));
                        $("#preModal").modal();
                        $("#preModal .modal-dialog").css({ "width": "100%", "margin": "0", "padding": "0" });
                        $("#preModal .modal-body").outerHeight($(window).height() - 200);
                        $("#preFrame").height($("#preModal .modal-body").height());
                    }
                }
            });
            //【发布】
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });
        }
    </script>
    <!-- 按钮初始化事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            GetUserRoleHtml();
            //下拉初始化
            DropDownUtils.initDropDown("NOTICE_TYPE");
            DropDownUtils.initDropDown("FUNCTION_ID");
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
            //设置选中改变事件
            $("input[type='checkbox'][name='user_role']").on('ifChanged', function (event) {
                GetCheckBoxSelected();
            });
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            ValidateUtils.setRequired("#form_edit", "NOTICE_TYPE", true, "公告分类必填");
            ValidateUtils.setRequired("#form_edit", "TITLE", true, "标题必须填");
            ValidateUtils.setRequired("#form_edit", "NOTICE_CONTENT", true, "发布内容必须填");
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义事件 开始-->
    <script type="text/javascript">
        //获得初始角色HTML
        function GetUserRoleHtml() {
            $("#divUserRole").html('');
            var result = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getuserrole');
            if (result.length > 0)
                $("#divUserRole").html(result);
        }

        //角色选中加载
        function GetCheckBoxSelectedLoad(roles) {
            if (roles.length == 0) {
                $("input[type='checkbox'][name='user_role']").each(function () {
                    $(this).iCheck("uncheck"); //iCheck移除绑定
                });
                return;
            }
            var arrRole = roles.split(',');
            for (var i = 0; i < arrRole.length; i++) {
                if (arrRole[i].toString().length == 0)
                    continue;
                $("input[type='checkbox'][name='user_role']").each(function () {
                    if ($(this).attr('value') == arrRole[i].toString()) {
                        $(this).iCheck("check"); //iCheck绑定
                    }
                });
            }
        }

        //选择角色
        function GetCheckBoxSelected() {
            var checkbox = "";
            $("#hidUserRoles").val("");
            $("input[type='checkbox'][name='user_role']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).val() + ',';
                }
            });
            if (checkbox.length > 0) {
                $("#hidUserRoles").val(checkbox);
            }
        }

        //保存事件
        function SaveData() {
            //校验必填项
            if (!$('#form_edit').valid())
                return;
            //校验发布内容必填
            if (editorObj.getData().length == 0) {
                easyAlert.timeShow({
                    "content": "发布内容必填！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            $('.maskBg').show();
            ZENG.msgbox.show("保存中，请稍后...", 6);
            $("#NOTICE_CONTENT").val(editorObj.getData());
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length == 0) {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal").modal("hide");
                    $('.maskBg').hide();
                    ZENG.msgbox.hide();
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    tablePackage.reload();
                }
                else {
                    $('.maskBg').hide();
                    ZENG.msgbox.hide();
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
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
    </script>
    <!-- 自定义事件 结束-->
</asp:Content>