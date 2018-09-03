<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Peer.ProjectManage.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .datepicker
        {
            z-index: 9999;
        }
    </style>
    <script type="text/javascript">
        var mainList;
        var contentList;
        var _form_edit;
        $(function () {
            adaptionHeight();

            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
            //时间控件
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });
            //编辑页form定义
            _form_edit = PageValueControl.init("form_edit");
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>评议信息设置</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>评议信息管理</li>
				<li class="active">评议信息设置</li>
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
                <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal"
                onsubmit="return false;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">
                        评议信息设置</h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="hidOid" name="hidOid" value="" />
                    <input type="hidden" id="hidSeqNo" name="hidSeqNo" value="" />
                    <div class="nav-tabs-custom" style="box-shadow: none; margin-bottom: 0px;">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tab_1" data-toggle="tab">评议信息</a></li>
                            <li><a href="#tab_2" data-toggle="tab">评议内容</a></li>
                        </ul>
                        <div class="tab-content">
                            <!--项目信息 开始-->
                            <div class="tab-pane active" id="tab_1">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">
                                        评议主题<span style="color: red">*</span></label>
                                    <div class="col-sm-4">
                                        <input name="PEER_NAME" id="PEER_NAME" type="text" class="form-control" placeholder="评议主题"
                                            maxlength="50" />
                                    </div>
                                    <label class="col-sm-2 control-label">
                                        评议学年<span style="color: red">*</span></label>
                                    <div class="col-sm-4">
                                        <select class="form-control" name="PEER_YEAR" id="PEER_YEAR" d_value='' ddl_name='ddl_year_type'
                                            show_type='t'>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">
                                        开始时间<span style="color: red">*</span></label>
                                    <div class="col-sm-4" style="position: relative;">
                                        <input name="PEER_START" id="PEER_START" type="text" class="form-control datep" placeholder="开始时间" />
                                    </div>
                                    <label class="col-sm-2 control-label">
                                        结束时间<span style="color: red">*</span></label>
                                    <div class="col-sm-4" style="position: relative;">
                                        <input name="PEER_END" id="PEER_END" type="text" class="form-control datep" placeholder="结束时间" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">
                                        主题简介</label>
                                    <div class="col-sm-10">
                                        <textarea class="form-control" name="PEER_REMARK" id="PEER_REMARK" rows="5" cols=""
                                            maxlength="100"></textarea>
                                    </div>
                                </div>
                            </div>
                            <!--项目信息 结束-->
                            <!--评议内容 开始-->
                            <div class="tab-pane" id="tab_2">
                                <table id="tablelist_content" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                            <!--评议内容 开始-->
                        </div>
                    </div>
                </div>
                </form>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-save" id="btnSave">
                        保存</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 评议内容编辑界面 开始 -->
    <div class="modal fade" id="tableModal_Content">
        <div class="modal-dialog">
            <form action="#" method="post" id="form_content" name="form_content" class="modal-content form-horizontal"
            onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    评议内容设置</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidOid_Content" name="hidOid_Content" value="" />
                <input type="hidden" id="hidSeqNo_Content" name="hidSeqNo_Content" value="" />
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        评议内容<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <input name="PEER_CONTENT" id="PEER_CONTENT" maxlength="50" type="text" class="form-control"
                            placeholder="评议内容" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        排序<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <input name="SEQUEUE" id="SEQUEUE" maxlength="2" type="text" class="form-control"
                            placeholder="排序" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnsave_content">
                    确定</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 评议内容编辑界面 结束-->
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
				    { "data": "PEER_NAME", "head": "评议主题", "type": "td-keep" },
				    { "data": "PEER_YEAR_NAME", "head": "评议学年", "type": "td-keep" },
				    { "data": "PEER_START", "head": "评议开始时间", "type": "td-keep" },
				    { "data": "PEER_END", "head": "评议结束时间", "type": "td-keep" },
				    { "data": "OP_NAME", "head": "最后操作人", "type": "td-keep" },
                    { "data": "OP_TIME", "head": "最后操作时间", "type": "td-keep" },
                    { "data": "SEQ_NO", "head": "单据编号", "type": "td-keep" }
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
                    tableTitle: "项目设置",
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
					    { "data": "PEER_YEAR", "pre": "评议学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
                        { "data": "PEER_NAME", "pre": "评议主题", "col": 4, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //加载表体列表
            loadContentTableList();
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 设置评议内容列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadContentTableList() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "PEER_CONTENT", "head": "评议内容", "type": "td-keep" },
                    { "data": "SEQUEUE", "head": "排序", "type": "td-keep" }
		    ];

            //配置表格
            contentList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "ContentList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_content", //表格id
                    buttonId: "buttonId_notboth", //拓展按钮区域id
                    tableTitle: "评议信息管理 >> 评议信息设置 >> 评议内容设置",
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
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: [
                { type: "userDefined", id: "reload_content", title: "刷新", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "add_content", title: "新增", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del_content", title: "删除", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 设置评议内容列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _tableModal_Content = $("#tableModal_Content");
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
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        FormClearData();
                        //设置各个标签页的隐藏域的SEQ_NO
                        $("#hidOid").val(data.OID);
                        $("#hidSeqNo").val(data.SEQ_NO);
                        $("#hidSeqNo_Content").val(data.SEQ_NO);
                        //设置评议内容加载
                        contentList.refresh(OptimizeUtils.FormatUrl("ContentList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        //设置界面值
                        FormSetData(data);
                        //设置界面不可编辑
                        _form_edit.disableAll();
                        //设置按钮不可见
                        $("#btnSave").hide();
                        $("#add_content").hide();
                        $("#del_content").hide();
                        //初始化编辑界面
                        $("#tableModal").modal();
                    }
                }
            });
            //【新增】
            _content.on('click', _btns.add, function () {
                $("#hidOid").val("");
                $("#hidSeqNo").val("");
                $("#hidSeqNo_Content").val("");
                //设置界面值（清空界面值）
                FormClearData();
                //设置评议内容加载
                contentList.refresh(OptimizeUtils.FormatUrl("ContentList.aspx?optype=getlist&seq_no="));
                //设置界面可编辑
                _form_edit.cancel_disableAll();
                //设置按钮不可见
                $("#btnSave").show();
                $("#add_content").show();
                $("#del_content").show();
                //初始化编辑界面
                $("#tableModal").modal();
            });
            //【编辑】
            _content.on('click', _btns.edit, function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        FormClearData();
                        //设置各个标签页的隐藏域的SEQ_NO
                        $("#hidOid").val(data.OID);
                        $("#hidSeqNo").val(data.SEQ_NO);
                        $("#hidSeqNo_Content").val(data.SEQ_NO);
                        //设置评议内容加载
                        contentList.refresh(OptimizeUtils.FormatUrl("ContentList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        //设置界面值
                        FormSetData(data);
                        //设置界面可编辑
                        _form_edit.cancel_disableAll();
                        //设置按钮不可见
                        $("#btnSave").show();
                        $("#add_content").show();
                        $("#del_content").show();
                        //初始化编辑界面
                        $("#tableModal").modal();
                    }
                    else {
                        $("#hidOid").val("");
                        $("#hidSeqNo").val("");
                        $("#hidSeqNo_Content").val("");
                    }
                }
            });
            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
            //-----------------编辑页-----------------
            //编辑页：【保存】
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });
            //--------------------------------------
            //评议内容设置：【刷新】
            _tableModal.on('click', "#reload_content", function () {
                contentList.reload();
            });
            //评议内容设置：【新增】
            _tableModal.on('click', "#add_content", function () {
                if ($("#hidSeqNo").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "保存“评议信息”之后才可以操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }

                _tableModal_Content.modal();
                $("#PEER_CONTENT").val("");
                //隐藏域赋值
                $("#hidOid_Content").val("");
            });
            //评议内容设置：【删除】
            _tableModal.on('click', "#del_content", function () {
                DeleteData_Content();
            });
            //评议内容设置：【确定】
            _tableModal_Content.on('click', "#btnsave_content", function () {
                SaveData_Content();
            });
        }
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("PEER_YEAR");
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
            //----项目信息页----
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "PEER_NAME", true, "评议主题必填");
            ValidateUtils.setRequired("#form_edit", "PEER_YEAR", true, "评议学年必填");
            ValidateUtils.setRequired("#form_edit", "PEER_START", true, "开始时间必填");
            ValidateUtils.setRequired("#form_edit", "PEER_END", true, "结束时间必填");
            //----评议内容设置页----
            ValidateUtils.setRequired("#form_content", "PEER_CONTENT", true, "评议内容必填");
            ValidateUtils.setRequired("#form_content", "SEQUEUE", true, "排序必填");
            LimitUtils.onlyNum("SEQUEUE");
        }
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //--------主界面---------------
        //保存事件
        function SaveData() {
            //校验必填项
            if (!$('#form_edit').valid())
                return;

            //ZZ 20171019 新增：切换标签页之后，主标签页的必填项就无法进行校验，所以需要二次校验
            var PEER_NAME = $("#PEER_NAME").val();
            var PEER_YEAR = DropDownUtils.getDropDownValue("PEER_YEAR");
            var PEER_START = $("#PEER_START").val();
            var PEER_END = $("#PEER_END").val();
            if (PEER_NAME.length == 0 || PEER_YEAR.length == 0 || PEER_START.length == 0 || PEER_END.length == 0) {
                easyAlert.timeShow({
                    "content": "评议信息页，有必填项未填，请填写完善之后再进行保存！",
                    "duration": 3,
                    "type": "danger"
                });
                return;
            }

            //保存 项目信息 之后 再保存 申请条件
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
                    var msg_json = eval("(" + msg + ")");
                    $("#hidOid").val(msg_json.OID);
                    $("#hidSeqNo").val(msg_json.SEQ_NO);
                    $("#hidSeqNo_Content").val(msg_json.SEQ_NO);

                    //保存成功：关闭界面，刷新列表
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    $("#tableModal").modal("hide");
                    mainList.reload();

                    return;
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
                            //判断是否满足删除条件：申请时间已经开始，已经有人开始申请，就不可以删除该项目
                            var result = AjaxUtils.getResponseText("List.aspx?optype=chkdel&id=" + data.OID);
                            if (result.length > 0) {
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }

                            result = AjaxUtils.getResponseText("List.aspx?optype=delete&id=" + data.OID);
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
        //--------评议内容设置---------------
        //评议内容设置界面：保存事件
        function SaveData_Content() {
            //校验必填项
            if (!$('#form_content').valid())
                return;

            $.post(OptimizeUtils.FormatUrl("ContentList.aspx?optype=save"), $("#form_content").serialize(), function (msg) {
                if (msg.length > 0) {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal_Content").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    contentList.reload();
                    return;
                }
                else {
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            });
        }

        //删除评议内容设置事件
        function DeleteData_Content() {
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除所选的数据吗？",
                'title': '删除评议内容设置',
                'callback': function (btn) {
                    var data = contentList.selectSingle();
                    if (data) {
                        if (data.OID) {
                            var url = "ContentList.aspx?optype=delete&id=" + data.OID;
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
                                contentList.reload();
                            }
                        }
                    }
                }
            });
        }
        //由于标签页切换的时候，另一个标签数据会实现不了清空或者赋值的情况，所以目前修改成手动赋值
        //清空
        function FormClearData() {
            //项目信息
            $("#PEER_NAME").val("");
            $("#PEER_START").val("");
            $("#PEER_END").val("");
            $("#PEER_REMARK").val("");
            DropDownUtils.setDropDownValue("PEER_YEAR", "");
        }
        //赋值
        function FormSetData(data) {
            if (data) {
                //设置界面值
                _form_edit.setFormData(data);
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>