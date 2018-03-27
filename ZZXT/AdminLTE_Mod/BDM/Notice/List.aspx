<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Notice.List"
    ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .datepicker
        {
            z-index: 9999;
        }
    </style>
    <script type="text/javascript" src="/AdminLTE/common/plugins/ckeditor/ckeditor.js"></script>
    <script type="text/javascript">
        var mainList; //主列表
        var fileList; //附件列表
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
    <div class="modal fade" id="tableModal">
        <div class="modal-dialog modal-dw80">
            <div class="modal-content form-horizontal">
              <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
                <input type="hidden" id="hidNOTICE_OID" name="hidNOTICE_OID" value="" />
                <input type="hidden" id="hidUserRoles" name="hidUserRoles" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">公告管理</h4>
                </div>
                <div class="modal-body">
                    <div id="" class="box box-default" style="border: none; margin: 0;">
                        <div class="nav-tabs-custom" style="box-shadow: none; margin-bottom: 0px;">
                            <ul class="nav nav-tabs">
                                <li id="tab_notice" class="active"><a href="#tab_1" data-toggle="tab">公告内容</a></li>
                                <li id="tab_file"><a href="#tab_2" data-toggle="tab">附件上传</a></li>
                            </ul>
                        </div>
                        <div class="tab-content">
                            <!--公告内容 开始-->
                            <div class="tab-pane active" id="tab_1">
                                <div class="box-body">
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            公告分类<span style="color: red">*</span></label>
                                        <div class="col-sm-4">
                                            <select class="form-control" name="NOTICE_TYPE" id="NOTICE_TYPE" d_value='' ddl_name='ddl_notice_type'
                                                show_type='t'>
                                            </select>
                                        </div>

                                        <label class="col-sm-2 control-label">
                                            快速进入设置</label>
                                        <div class="col-sm-4">
                                            <select class="form-control" name="FUNCTION_ID" id="FUNCTION_ID" d_value='' ddl_name='ddl_notice_fast_in'
                                                show_type='t'>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            标题<span style="color: red">*</span></label>
                                        <div class="col-sm-10">
                                            <input name="TITLE" id="TITLE" type="text" class="form-control" placeholder="标题" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            副标题<span style="color: red">*</span></label>
                                        <div class="col-sm-10">
                                            <input name="SUB_TITLE" id="SUB_TITLE" type="text" class="form-control" placeholder="副标题" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            有效时间</label>
                                        <div class="col-sm-4" style="position: relative; z-index: 9999">
                                            <input name="START_TIME" id="START_TIME" type="text" class="form-control datep" placeholder="有效起始时间" />
                                        </div>

                                        <label class="col-sm-2 control-label">
                                            至</label>
                                        <div class="col-sm-4" style="position: relative; z-index: 9999">
                                            <input name="END_TIME" id="END_TIME" type="text" class="form-control datep" placeholder="有效结束时间" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            查阅角色</label>
                                        <div class="col-sm-10">
                                            <div id="divUserRole">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            发布内容<span style="color: red">*</span></label>
                                        <div class="col-sm-10">
                                            <textarea name="NOTICE_CONTENT" id="NOTICE_CONTENT" cols="10" rows="5" class="form-control ckEditor"></textarea>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <!--附件上传 开始-->
                            <div class="tab-pane" id="tab_2">
                                <table id="tablelist_file" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-save" id="btnSave">发布</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
              </form>
            </div>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 查阅预览界面 开始-->
    <div class="modal fade" id="preModal">
        <div class="modal-dialog modal-dw90">
          <form id="form_pre" name="form_pre" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">查阅公告</h4>
            </div>
            <div class="modal-body">

                    <iframe id="preFrame" frameborder="0" src="" style="width: 100%;"></iframe>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
          </form>
        </div>
    </div>
    <!-- 查阅预览界面 结束-->
    <!-- 附件上传编辑界面 开始 -->
    <div class="modal fade" id="tableModal_File">
        <div class="modal-dialog">
          <form id="form_file" name="form_file" class="modal-content form-horizontal" runat="server">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">附件上传</h4>
            </div>
            <input type="hidden" id="hidOid_File" name="hidOid_File" value="" runat="server" />
            <input type="hidden" id="hidNoticeOid_File" name="hidNoticeOid_File" value="" runat="server" />
            <input type="hidden" id="hidFile_FILE_NAME" name="hidFile_FILE_NAME" value="" runat="server" />
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        选择附件</label>
                    <div class="col-sm-10">
                        <input id="fileUpload" name="fileUpload" type="file" multiple="multiple" runat="server"
                            onchange="CheckFileType (this,'FILE_NAME');" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        附件名称</label>
                    <div class="col-sm-10">
                        <input name="FILE_NAME" id="FILE_NAME" type="text" class="form-control" placeholder="附件名称"
                            maxlength="25" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <asp:LinkButton ID="btnSaveFile" runat="server" class="btn btn-primary btn-save"
                    OnClientClick="return ChkIsUpload();" OnClick="fileUpload_Click">保存</asp:LinkButton>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
          </form>
        </div>
    </div>
    <!-- 附件上传编辑界面 结束-->
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
           mainList = tablePackageMany.createOne({
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
                <%if(IsShowBtn){%>
                 "add", "edit", "del"
                 <%} %>
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //附件列表
            loadTableList_File();
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 附件列表JS 开始-->
    <script type="text/javascript">
        function loadTableList_File() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
				    { "data": "FILE_NAME", "head": "附件名称", "type": "td-keep" }
		    ];

            //配置表格
            fileList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "FileList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_file", //表格id
                    buttonId: "buttonId_file", //拓展按钮区域id
                    tableTitle: "",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true //用户改变分页
                    }
                },
                //查询栏
                hasSearch: {
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: [
                { type: "userDefined", id: "search_file", title: "查看附件", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "reload_file", title: "刷新", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "add_file", title: "新增", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "edit_file", title: "修改", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del_file", title: "删除", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 附件列表JS 结束-->
    <!-- 按钮初始化事件 开始-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _tableModal_File = $("#tableModal_File");
            var _btns = {
                reload: '.btn-reload',
                add: '.btn-add',
                edit: '.btn-edit',
                del: '.btn-del'
            };
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
                _form_edit.reset();
                $("#S").iCheck("check"); //iCheck绑定
                $("#F").iCheck("check"); //iCheck绑定
                $("#X").iCheck("check"); //iCheck绑定
                $("#Y").iCheck("check"); //iCheck绑定
                $("#<%=hidNoticeOid_File.ClientID %>").val("");
                editorObj.setData("");
                fileList.refresh(OptimizeUtils.FormatUrl("FileList.aspx?optype=getlist&notice_id="));
                _tableModal.modal();
            });
            //【编辑】
            _content.on('click', _btns.edit, function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        _form_edit.setFormData(data);
                        $("#hidNOTICE_OID").val(data.OID);
                        $("#<%=hidNoticeOid_File.ClientID %>").val(data.OID);
                        fileList.refresh(OptimizeUtils.FormatUrl("FileList.aspx?optype=getlist&notice_id=" + data.OID));
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
                var data = mainList.selectSingle();
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
            //----------附件上传 按钮事件----------------
            //【查看附件】
            _tableModal.on('click', "#search_file", function () {
                var data = fileList.selectSingle();
                if (data) {
                    if (data.OID) {
                        if (data.FILE_SAVE_NAME.length == 0) {
                            easyAlert.timeShow({
                                "content": "未上传附件！",
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                        var url = AjaxUtils.getResponseText("FileList.aspx?optype=download&id=" + data.OID);
                        window.open(url);
                    }
                }
            });
            //【刷新】
            _tableModal.on('click', "#reload_file", function () {
                fileList.reload();
            });
            //【新增】
            _tableModal.on('click', "#add_file", function () {
                if ($("#hidNOTICE_OID").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "请先保存奖助申请信息再进行添加附件操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                //设置界面值（清空界面值）
                $("#FILE_NAME").val("");
                //隐藏域赋值
                $("#<%=hidOid_File.ClientID %>").val("");
                $("#<%=hidFile_FILE_NAME.ClientID %>").val("");
                _tableModal_File.modal();
            });
            //【修改】
            _tableModal.on('click', "#edit_file", function () {
                Edit_File_Load();
            });
            //【删除】
            _tableModal.on('click', "#del_file", function () {
                DeleteData_File();
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
            //$('.maskBg').show();
            //ZENG.msgbox.show("保存中，请稍后...", 6);
            var layInx = layer.load(2, {
              content: "保存中，请稍后...",
              shade: [0.3,'#000'], //0.1透明度的白色背景
              time: 6000
            });
            $("#NOTICE_CONTENT").val(editorObj.getData());
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    //保存成功：关闭界面，刷新列表
                    //$("#tableModal").modal("hide");
                    //$('.maskBg').hide();
                    //隐藏域赋值
                    $("#hidNOTICE_OID").val(msg);
                    $("#<%=hidNoticeOid_File.ClientID %>").val(msg);
                    fileList.refresh(OptimizeUtils.FormatUrl("FileList.aspx?optype=getlist&notice_id=" + msg));
                    //ZENG.msgbox.hide();
                    layer.close(layInx);
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload();
                }
                else {
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    layer.close(layInx);
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

        //------------------附件上传界面 按钮操作 开始-----------------------------
        //编辑
        function Edit_File_Load() {
            var data = fileList.selectSingle();
            if (data) {
                if (data.OID) {
                    //界面以及隐藏域赋值
                    $("#FILE_NAME").val(data.FILE_NAME);
                    $("#<%=hidOid_File.ClientID %>").val(data.OID);
                    $("#tableModal_File").modal();
                }
                else {
                    //隐藏域赋值
                    $("#<%=hidOid_File.ClientID %>").val("");
                }
            }
        }

        //删除
        function DeleteData_File() {
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除所选的数据吗？",
                'title': '删除上传附件信息',
                'callback': function (btn) {
                    var data = fileList.selectSingle();
                    if (data) {
                        if (data.OID) {
                            var url = "FileList.aspx?optype=delete&id=" + data.OID;
                            var result = AjaxUtils.getResponseText(url);
                            if (result.length > 0) {
                                $(".Confirm_Div").modal("hide");
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
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
                                fileList.reload();
                            }
                        }
                    }
                }
            });
        }

        //判断上传的文件是不是文件
        function CheckFileType(obj, filename_id) {
            //当不符合上传文件类型时，清空上传文件路径名称
            if (obj.value.length == 0) {
                $('#' + filename_id).val('');
                return false;
            }

            var file_name = obj.value;
            var file_ext = file_name.substring(file_name.lastIndexOf(".") + 1).toLowerCase();
            //获取文件名
            var fname = file_name.substring(file_name.lastIndexOf("\\") + 1).toLowerCase();
            fname = fname.substring(0, fname.lastIndexOf("."))
            //判断是否符合允许上传的文件类型
            if (file_ext != "gif" && file_ext != "jpg" && file_ext != "png"
            && file_ext != "doc" && file_ext != "docx"
            && file_ext != "pdf") {
                easyAlert.timeShow({
                    "content": "只允许上传.gif、.jpg、.png、.doc、.docx、.pdf类型文件！",
                    "duration": 2,
                    "type": "danger"
                });
                obj.value = "";
                return false;
            }
            //把上传按钮获得的名称 赋给 文本框
            $('#' + filename_id).val(fname);
            return true;
        }

        //判断是否可以上传
        function ChkIsUpload() {
            //校验必填项
            var FILE_NAME = $('#FILE_NAME').val();
            if (FILE_NAME.length == 0) {
                easyAlert.timeShow({
                    "content": "请选择附件！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            //隐藏域赋值
            $("#<%=hidFile_FILE_NAME.ClientID %>").val(FILE_NAME);
            return true;
        }
        //------------------附件上传界面 按钮操作 结束-----------------------------
    </script>
    <!-- 自定义事件 结束-->
</asp:Content>
