<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="BasicList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectCheck.BasicList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .datepicker
        {
            z-index: 9999;
        }
    </style>
    <script type="text/javascript" src="/AdminLTE/common/plugins/ckeditor/ckeditor.js"></script>
    <script type="text/javascript">
        var mainList;
        var _form_edit;
        var _form_notice;
        $(function () {
            adaptionHeight();
            //时间控件
            /*$(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });*/
            lay('.datep').each(function(inx, element){
              //TODO 实例化 遍历
              laydate.render({
                elem: this,
                trigger: 'click',
              });
            });
            //编辑页控制定义
            _form_edit = PageValueControl.init("form_edit");
            _form_notice = PageValueControl.init("form_notice");
            //编辑控件
            loadEditor("NOTICE_CONTENT");

            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
        });

        var editorObj;
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
			<h1>基础设置</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>奖助管理</li>
				<li class="active">基础设置</li>
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
                <h4 class="modal-title">信息核对内容设置</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="OID" name="OID" value="" />
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        项目名称
                    </label>
                    <div class="col-sm-10">
                        <input name="PROJECT_NAME" id="PROJECT_NAME" type="text" class="form-control" placeholder="项目名称" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">项目级别</label>
                    <div class="col-sm-4">
                        <input name="PROJECT_CLASS_NAME" id="PROJECT_CLASS_NAME" type="text" class="form-control" placeholder="项目级别" />
                    </div>

                    <label class="col-sm-2 control-label">申请表格类型</label>
                    <div class="col-sm-4">
                        <input name="PROJECT_TYPE_NAME" id="PROJECT_TYPE_NAME" type="text" class="form-control" placeholder="申请表格类型" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        核对有效时间<span style="color: red">*</span></label>
                    <div class="col-sm-4" style="position: relative;">
                        <input name="CHECK_START" id="CHECK_START" type="text" class="form-control datep"
                            placeholder="核对有效起始时间" />
                    </div>

                    <label class="col-sm-2 control-label">至</label>
                    <div class="col-sm-4" style="position: relative; z-index: 9999">
                        <input name="CHECK_END" id="CHECK_END" type="text" class="form-control datep" placeholder="核对有效结束时间" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">核对事项说明<span style="color: red">*</span>
                    </label>
                    <div class="col-sm-10">
                        <textarea name="MSG_CONTENT" id="MSG_CONTENT" cols="10" rows="5" class="form-control"></textarea>
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
    <!-- 发布公告编辑界面 开始 -->
    <div class="modal fade" id="tableModal_Notice">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_notice" name="form_notice" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">公告管理</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidNOTICE_OID" name="hidNOTICE_OID" value="" />
                <input type="hidden" id="hidUserRoles" name="hidUserRoles" />
                <div class="form-group">
                    <label class="col-sm-2 control-label">标题<span style="color: red">*</span>
                    </label>
                    <div class="col-sm-10">
                        <input name="TITLE" id="TITLE" type="text" class="form-control" placeholder="标题" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">副标题</label>
                    <div class="col-sm-10">
                        <input name="SUB_TITLE" id="SUB_TITLE" type="text" class="form-control" placeholder="副标题" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">有效时间</label>
                    <div class="col-sm-4" style="position: relative;">
                        <input name="START_TIME" id="START_TIME" type="text" class="form-control datep" placeholder="有效起始时间" />
                    </div>

                    <label class="col-sm-2 control-label">至</label>
                    <div class="col-sm-4" style="position: relative;">
                        <input name="END_TIME" id="END_TIME" type="text" class="form-control datep" placeholder="有效结束时间" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">查阅角色</label>
                    <div class="col-sm-10">
                        <div id="divUserRole">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">发布内容<span style="color: red">*</span>
                    </label>
                    <div class="col-sm-10">
                        <textarea name="NOTICE_CONTENT" id="NOTICE_CONTENT" cols="10" rows="5" class="form-control ckEditor"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSendNotice">发布</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 发布公告编辑界面 结束-->
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
                    { "data": "PROJECT_CLASS_NAME", "head": "项目级别", "type": "td-keep" },
				    { "data": "PROJECT_TYPE_NAME", "head": "申请表格类型", "type": "td-keep" },
				    { "data": "PROJECT_NAME", "head": "项目名称", "type": "td-keep" },
				    { "data": "PROJECT_MONEY", "head": "项目金额", "type": "td-keep" },
				    { "data": "APPLY_YEAR_NAME", "head": "申请学年", "type": "td-keep" },
				    { "data": "APPLY_START", "head": "申请开始时间", "type": "td-keep" },
				    { "data": "APPLY_END", "head": "申请结束时间", "type": "td-keep" },
                    { "data": "CHECK_START", "head": "信息核对开始时间", "type": "td-keep" },
				    { "data": "CHECK_END", "head": "信息核对结束时间", "type": "td-keep" },
                    { "data": "CHECK_IS_SEND", "head": "发送核对信息标识", "type": "td-keep" },
				    { "data": "CHECK_OP_NAME", "head": "最后操作人", "type": "td-keep" },
                    { "data": "CHECK_OP_TIME", "head": "最后操作时间", "type": "td-keep" }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/BDM/ScholarshipAssis/ProjectManage/List.aspx?optype=getlist&from_page=check_basic",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "基础设置",
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
					    { "data": "APPLY_YEAR", "pre": "项目学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
					    { "data": "PROJECT_CLASS", "pre": "项目级别", "col": 2, "type": "select", "ddl_name": "ddl_jz_project_class" },
                        { "data": "PROJECT_TYPE", "pre": "申请表格类型", "col": 3, "type": "select", "ddl_name": "ddl_jz_project_type" },
                        { "data": "PROJECT_SEQ_NO", "pre": "项目名称", "col": 4, "type": "select", "ddl_name": "ddl_jz_project_name_end" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                { type: "userDefined", id: "sendnotice", title: "发布公告", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "set", title: "设置信息核对", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del", title: "删除信息核对", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //奖助级别、奖助类型 联动
            SelectUtils.JZ_Class_Type_Year_ProjectChange("search-PROJECT_CLASS", "search-PROJECT_TYPE", "search-APPLY_YEAR", "search-PROJECT_SEQ_NO", '', '', '', '', 'end');
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _tableModal_Notice = $("#tableModal_Notice");
            var _btns = {
                reload: '.btn-reload'
            };
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【设置信息核对】
            _content.on('click', "#set", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //信息内容
                        var msg = AjaxUtils.getResponseText("BasicList.aspx?optype=getmsg&msg_id=" + data.CHECK_MSG_ID);
                        if (msg.length > 0) {
                            var msg_json = eval("(" + msg + ")");
                            _form_edit.setFormData(msg_json);
                        }
                        else {
                            $("#MSG_CONTENT").val("");
                        }
                        _form_edit.setFormData(data);
                        $("#OID").val(data.OID);
                        _tableModal.modal();
                    }
                }
            });
            //【删除信息核对】
            _content.on('click', "#del", function () {
                DeleteData();
            });

            //【发布公告】
            _content.on('click', "#sendnotice", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        if (data.CHECK_NOTICE_ID) {
                            //通过公告ID获取公告内容
                            var notice = AjaxUtils.getResponseText("/AdminLTE_Mod/BDM/Notice/List.aspx?optype=getnotice&id=" + data.CHECK_NOTICE_ID);
                            if (notice) {
                                var notice_json = eval("(" + notice + ")");
                                _form_notice.setFormData(notice_json);
                            }
                            //加载内容
                            var content = AjaxUtils.getResponseText("/AdminLTE_Mod/BDM/Notice/List.aspx?optype=getcontent&id=" + data.CHECK_NOTICE_ID);
                            if (content)
                                editorObj.setData(content);

                            $("#hidNOTICE_OID").val(data.CHECK_NOTICE_ID);
                            $("#S").iCheck("uncheck"); //iCheck绑定
                            $("#F").iCheck("uncheck"); //iCheck绑定
                            $("#X").iCheck("uncheck"); //iCheck绑定
                            $("#Y").iCheck("uncheck"); //iCheck绑定
                            GetCheckBoxSelectedLoad(notice_json.ROLEID);
                        }
                        else {
                            //判断是否已经填入了核对信息，如果没有提示不能发公告
                            var result = AjaxUtils.getResponseText("BasicList.aspx?optype=chkcheck&id=" + data.OID);
                            if (result.length > 0) {
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }

                            _form_notice.reset();
                            $("#hidNOTICE_OID").val("");
                            $("#TITLE").val("<" + data.PROJECT_NAME + ">奖助项目开始进行核对");
                            $("#SUB_TITLE").val("核对时间 从 " + data.CHECK_START + " -- " + data.CHECK_END + "结束");
                            $("#START_TIME").val(data.CHECK_START);
                            $("#END_TIME").val(data.CHECK_END);
                            //信息内容
                            var msg = AjaxUtils.getResponseText("BasicList.aspx?optype=getmsg&msg_id=" + data.CHECK_MSG_ID);
                            if (msg.length > 0) {
                                var msg_json = eval("(" + msg + ")");
                                editorObj.setData(msg_json.MSG_CONTENT);
                            }
                            else {
                                editorObj.setData("");
                            }
                            $("#S").iCheck("check"); //iCheck绑定
                            $("#F").iCheck("check"); //iCheck绑定
                            $("#X").iCheck("check"); //iCheck绑定
                            $("#Y").iCheck("check"); //iCheck绑定
                            editorObj.setData("");
                        }
                        _tableModal_Notice.modal();
                    }
                }
            });

            //【保存】
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });

            //【保存发布公告】
            _tableModal_Notice.on('click', "#btnSendNotice", function () {
                SendNoticeData();
            });
        }
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            ControlUtils.Input_SetDisableStatus("PROJECT_NAME", true);
            ControlUtils.Input_SetDisableStatus("PROJECT_CLASS_NAME", true);
            ControlUtils.Input_SetDisableStatus("PROJECT_TYPE_NAME", true);

            //用户角色
            GetUserRoleHtml();
            //角色用户改变时
            $("input[type='checkbox'][name='user_role']").on('ifChanged', function (event) {
                GetUserRoleSelected();
            });
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        }
    </script>
    <!-- 编辑页验证事件-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "CHECK_START", true, "核对有效起始时间必填");
            ValidateUtils.setRequired("#form_edit", "CHECK_END", true, "核对有效结束时间必填");
            ValidateUtils.setRequired("#form_edit", "MSG_CONTENT", true, "核对事项说明必填");
            //----发布公告页----
            ValidateUtils.setRequired("#form_notice", "TITLE", true, "标题必填");
        }
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //保存事件
        function SaveData() {
            //校验必填
            if (!$('#form_edit').valid())
                return;

            $.post(OptimizeUtils.FormatUrl("BasicList.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length == 0) {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload();
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
                            var result = AjaxUtils.getResponseText("BasicList.aspx?optype=delete&id=" + data.OID);
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

        //发布公告事件
        function SendNoticeData() {
            //校验必填项
            if (!$('#form_notice').valid())
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
            var data = mainList.selectSingle();
            if (data) {
                if (data.OID) {
                    $("#NOTICE_CONTENT").val(editorObj.getData());
                    $.post(OptimizeUtils.FormatUrl("/AdminLTE_Mod/BDM/Notice/List.aspx?optype=save&pro_check_oid=" + data.OID), $("#form_notice").serialize(), function (msg) {
                        if (layInx) {
                        layer.close(layInx);
                        }
                        if (msg.length != 0) {
                            //$('.maskBg').hide();
                            //ZENG.msgbox.hide();
                            easyAlert.timeShow({
                                "content": msg,
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                        else {
                            //保存成功：关闭界面，刷新列表
                            //$('.maskBg').hide();
                            //ZENG.msgbox.hide();
                            easyAlert.timeShow({
                                "content": "发布公告成功，请到系统维护>>公告通知>>公告管理 中进行内容的查阅以及完善！",
                                "duration": 2,
                                "type": "success"
                            });
                            $("#tableModal_Notice").modal("hide");
                            mainList.reload();
                        }
                    });
                }
            }
        }

        //获得初始角色HTML
        function GetUserRoleHtml() {
            $("#divUserRole").html('');
            var result = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getuserrole');
            if (result.length > 0)
                $("#divUserRole").html(result);
        }

        //选择角色
        function GetUserRoleSelected() {
            var checkbox = "";
            $("#hidUserRoles").val("");
            $("input[type='checkbox'][name='user_role']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).attr("value") + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidUserRoles").val(checkbox);
            }
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
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
