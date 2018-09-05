<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Peer.PeerCoun.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList; //主列表
        var projectList; //评议信息项目选择列表
        var _div_PeerInfo;
        var _div_CounInfo;
        var _form_edit;
        $(function () {
            adaptionHeight();

            _div_PeerInfo = PageValueControl.init("div_PeerInfo");
            _div_CounInfo = PageValueControl.init("div_CounInfo");
            //编辑页form定义
            _form_edit = PageValueControl.init("form_edit");

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
			<h1>评议辅导员</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>评议管理</li>
				<li class="active">评议辅导员</li>
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
    <!-- 可提供评议项目列表选择 开始 -->
    <div class="modal" id="projectListModal">
        <div class="modal-dialog modal-dw60">
            <div class="modal-content form-horizontal">
                <div class="modal-body">
                    <table id="tablelist_project" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 可提供申请奖助项目列表选择 结束-->
    <!-- 编辑界面 开始 -->
    <div class="modal fade" id="tableModal">
        <div class="modal-dialog modal-dw90">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal"
            onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    评议结果录入</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidOid" name="hidOid" value="" />
                <input type="hidden" id="hidPeerSeqNo" name="hidPeerSeqNo" value="" />
                <div class="form-group" id="div_PeerInfo">
                    <label class="col-sm-2 control-label">
                        评议学年</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="PEER_YEAR" id="PEER_YEAR" d_value='' ddl_name='ddl_year_type'
                            show_type='t'>
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">
                        评议主题</label>
                    <div class="col-sm-4">
                        <input name="PEER_NAME" id="PEER_NAME" type="text" class="form-control" placeholder="评议主题" />
                    </div>
                </div>
                <div class="form-group" id="div_CounInfo">
                    <label class="col-sm-2 control-label">
                        被评议人</label>
                    <div class="col-sm-4">
                        <input name="COUN_NAME" id="COUN_NAME" type="text" class="form-control" placeholder="被评议人" />
                    </div>
                    <label class="col-sm-2 control-label">
                        评议时间</label>
                    <div class="col-sm-4">
                        <input name="OP_TIME" id="OP_TIME" type="text" class="form-control" placeholder="评议时间" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        评议内容：</label>
                    <label class="col-sm-10 control-label" style="text-align: left; color: Red;">
                        优秀（9.0-10）、良好（8.0-8.9）、中等（7.0-7.9）、差（7.0以下）</label>
                </div>
                <div id="divContent">
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
                    { "data": "PEER_YEAR_NAME", "head": "评议学年", "type": "td-keep" },
				    { "data": "PEER_NAME", "head": "评议主题", "type": "td-keep" },
				    { "data": "COUN_NAME", "head": "被评议人姓名", "type": "td-keep" },
				    { "data": "OP_TIME", "head": "评议时间", "type": "td-keep" },
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
                    tableTitle: "",
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
                        { "data": "PEER_SEQ_NO", "pre": "评议主题", "col": 2, "type": "select", "ddl_name": "ddl_peer_project_name" },
                        { "data": "COUN_NAME", "pre": "被评议人", "col": 3, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "add", title: "选择评议主题", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                 "edit", "del",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //学年、评议主题联动
            SelectUtils.Year_PeerInfoChange("search-PEER_YEAR", "search-PEER_SEQ_NO", "", "", "");
            //加载其他列表
            projectListLoad();
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 可提供申请奖助项目列表JS 开始-->
    <script type="text/javascript">
        function projectListLoad() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
				    { "data": "PEER_NAME", "head": "评议主题", "type": "td-keep" }
		    ];

            //配置表格
            projectList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/BDM/Peer/ProjectManage/List.aspx?optype=getlist&from_page=peer_coun",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_project", //表格id
                    buttonId: "buttonId_project", //拓展按钮区域id
                    tableTitle: "评议主题选择",
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
                hasBtns: [
                { type: "userDefined", id: "reload_project", title: "刷新", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "sel_project", title: "进行评议", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 可提供申请奖助项目列表JS 结束-->
    <!-- 按钮事件 开始-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _projectListModal = $("#projectListModal");
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
            _content.on('click', "#add", function () {
                //判断是否满足评议条件：是学生并且有辅导员
                var result = AjaxUtils.getResponseText("List.aspx?optype=iscan_peer");
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                //弹出可申请奖助信息列表
                $("#projectListModal").modal();
            });
            //【编辑】
            _content.on('click', _btns.edit, function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //ZZ 20171221 新增：删除也需要加入 过了评议结束时间不能操作
                        var iscanop_result = AjaxUtils.getResponseText("List.aspx?optype=iscanop&peer_seq_no=" + data.PEER_SEQ_NO);
                        if (iscanop_result.length > 0) {
                            easyAlert.timeShow({
                                "content": iscanop_result,
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                        //赋值
                        //设置界面值
                        _form_edit.setFormData(data);
                        //设置评分内容项
                        var content = AjaxUtils.getResponseText('List.aspx?optype=content&peer_seq_no=' + data.PEER_SEQ_NO);
                        if (content) {
                            $("#divContent").html(content);
                        }
                        LoadContentScore(data.SEQ_NO);

                        $("#hidOid").val(data.OID);
                        $("#hidPeerSeqNo").val(data.PEER_SEQ_NO);

                        //打开 编辑页
                        //设置界面可编辑
                        _form_edit.cancel_disableAll();
                        //设置按钮可见
                        $("#btnSave").show();

                        _div_PeerInfo.disableAll(); //评议信息不可编辑
                        _div_CounInfo.disableAll(); //辅导员信息不可编辑
                        _tableModal.modal();
                    }
                }
            });
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //赋值
                        //设置界面值
                        _form_edit.setFormData(data);
                        //设置评分内容项
                        var content = AjaxUtils.getResponseText('List.aspx?optype=content&peer_seq_no=' + data.PEER_SEQ_NO);
                        if (content) {
                            $("#divContent").html(content);
                        }
                        LoadContentScore(data.SEQ_NO);
                        //设置界面不可编辑
                        _form_edit.disableAll();
                        //设置按钮不可见
                        $("#btnSave").hide();
                        //打开 编辑页
                        _tableModal.modal();
                    }
                }
            });
            //-----------------编辑页-----------------
            //编辑页：【保存】
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });
            //-----------可评议信息列表 按钮---------------
            //【刷新】
            _projectListModal.on('click', "#reload_project", function () {
                projectList.reload();
            });
            //【评议】
            _projectListModal.on('click', "#sel_project", function () {
                var data = projectList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //关闭 可申请奖助信息列表
                        $("#projectListModal").modal("hide");
                        //赋值
                        $("#hidPeerSeqNo").val(data.SEQ_NO);
                        DropDownUtils.setDropDownValue("PEER_YEAR", data.PEER_YEAR);
                        $("#PEER_NAME").val(data.PEER_NAME);
                        var counname = AjaxUtils.getResponseText('List.aspx?optype=counname');
                        if (counname) {
                            $("#COUN_NAME").val(counname);
                        }
                        var content = AjaxUtils.getResponseText('List.aspx?optype=content&peer_seq_no=' + data.SEQ_NO);
                        if (content) {
                            $("#divContent").html(content);
                        }
                        LoadContent(data.SEQ_NO);
                        //打开 编辑页
                        _div_PeerInfo.disableAll(); //评议信息不可编辑
                        _div_CounInfo.disableAll(); //辅导员信息不可编辑
                        _tableModal.modal();
                    }
                }
            });
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("PEER_YEAR");
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "PEER_NAME", true, "评议主题必填");
            ValidateUtils.setRequired("#form_edit", "PEER_YEAR", true, "评议学年必填");
            ValidateUtils.setRequired("#form_edit", "COUN_NAME", true, "被评议人必填");
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //------------------主列表按钮事件------------------
        //保存事件
        function SaveData() {
            //校验必填项
            if (!$('#form_edit').valid())
                return;

            //判断评分区间0-10
            var content_id = AjaxUtils.getResponseText('List.aspx?optype=content_id&peer_seq_no=' + $("#hidPeerSeqNo").val());
            if (content_id) {
                var arrContent = content_id.split(',');
                for (var i = 0; i < arrContent.length; i++) {
                    if (arrContent[i].toString().length == 0)
                        continue;

                    var score = $("#" + arrContent[i].toString()).val();
                    if (score.length > 0) {
                        var score_parse = parseFloat(score);
                        if (score_parse > 10 || score_parse < 0) {
                            easyAlert.timeShow({
                                "content": "评分区间是0-10，不在范围内的评分请重新录入！",
                                "duration": 3,
                                "type": "danger"
                            });
                            return;
                        }
                    }
                }
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
                    //ZZ 20171221 新增：删除也需要加入 过了评议结束时间不能操作
                    var iscanop_result = AjaxUtils.getResponseText("List.aspx?optype=iscanop&peer_seq_no=" + data.PEER_SEQ_NO);
                    if (iscanop_result.length > 0) {
                        easyAlert.timeShow({
                            "content": iscanop_result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
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

        //设置评分内容必填以及分数属性
        function LoadContent(peer_seq_no) {
            var content_id = AjaxUtils.getResponseText('List.aspx?optype=content_id&peer_seq_no=' + peer_seq_no);
            if (content_id) {
                var arrContent = content_id.split(',');
                for (var i = 0; i < arrContent.length; i++) {
                    if (arrContent[i].toString().length == 0)
                        continue;

                    ValidateUtils.setRequired("#form_edit", arrContent[i].toString(), true, "评分必填");
                    LimitUtils.onlyNumAndPoint(arrContent[i].toString());
                }
            }
        }

        //给评分内容项赋值
        function LoadContentScore(seq_no) {
            var content_score = AjaxUtils.getResponseText('List.aspx?optype=content_score&seq_no=' + seq_no);
            if (content_score) {
                var content_score_json = eval("(" + content_score + ")");
                _form_edit.setFormData(content_score_json);
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>