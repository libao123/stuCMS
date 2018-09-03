<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Peer.PeerResult.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList; //主列表
        var _form_edit;
        $(function () {
            adaptionHeight();
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
			<h1>评议信息查阅</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>评议管理</li>
				<li class="active">评议信息查阅</li>
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
    <!-- 编辑界面 开始 -->
    <div class="modal fade" id="tableModal">
        <div class="modal-dialog" style="width: 80%;">
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
                <div class="form-group">
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
                <div class="form-group">
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
                        评议人</label>
                    <div class="col-sm-4">
                        <input name="STU_NAME" id="STU_NAME" type="text" class="form-control" placeholder="评议人" />
                    </div>
                    <label class="col-sm-2 control-label">
                        所属班级</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="CLASS_CODE" id="CLASS_CODE" d_value='' ddl_name='ddl_class'
                            show_type='t'>
                        </select>
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
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        总评</label>
                    <div class="col-sm-4">
                        <input name="PEER_RESULT" id="PEER_RESULT" type="text" class="form-control" placeholder="总评" />
                    </div>
                    <label class="col-sm-2 control-label">
                        总分</label>
                    <div class="col-sm-4">
                        <input name="PEER_SCORE" id="PEER_SCORE" type="text" class="form-control" placeholder="总分" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
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
                    { "data": "PEER_RESULT", "head": "总评", "type": "td-keep" },
                    { "data": "PEER_SCORE", "head": "总分", "type": "td-keep" },
                    { "data": "STU_NAME", "head": "评议人", "type": "td-keep" },
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" },
                    { "data": "SEQ_NO", "head": "单据编号", "type": "td-keep" }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/BDM/Peer/PeerCoun/List.aspx?optype=getlist&page_from=result",
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
                        { "data": "PEER_SEQ_NO", "pre": "评议主题", "col": 2, "type": "select", "ddl_name": "ddl_peer_project_name_end" },
                        { "data": "COUN_NAME", "pre": "被评议人", "col": 3, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "download", title: "下载", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "export", title: "导出", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //学年、评议主题联动
            SelectUtils.Year_PeerInfoChange("search-PEER_YEAR", "search-PEER_SEQ_NO", "", "", "end");
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
                reload: '.btn-reload'
            };
            //-----------主列表按钮---------------
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【下载】
            _content.on('click', "#download", function () {
                var data = mainList.selectSingle();
                if (data) {
                    window.open('/Word/ExportWord.aspx?optype=peer&id=' + data.OID + '&seq_no=' + data.SEQ_NO
                    + '&peer_seq_no=' + data.PEER_SEQ_NO + '&counid=' + data.COUN_ID);
                }
            });
            //【导出】
            _content.on('click', "#export", function () {
                //必选
                var PEER_YEAR = DropDownUtils.getDropDownValue("search-PEER_YEAR");
                var PEER_SEQ_NO = DropDownUtils.getDropDownValue("search-PEER_SEQ_NO");

                if (PEER_YEAR.length == 0 || PEER_SEQ_NO.length == 0) {
                    easyAlert.timeShow({
                        "content": "查询条件：学年、评议主题不能为空！",
                        "duration": 3,
                        "type": "info"
                    });
                    return;
                }

                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=peerlist' + GetSearchUrlParam());
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
                        var content = AjaxUtils.getResponseText('/AdminLTE_Mod/BDM/Peer/PeerCoun/List.aspx?optype=content&peer_seq_no=' + data.PEER_SEQ_NO);
                        if (content) {
                            $("#divContent").html(content);
                        }
                        LoadContentScore(data.SEQ_NO);
                        //设置界面不可编辑
                        _form_edit.disableAll();
                        //打开 编辑页
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
            DropDownUtils.initDropDown("CLASS_CODE");
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //------------------主列表按钮事件------------------
        //给评分内容项赋值
        function LoadContentScore(seq_no) {
            var content_score = AjaxUtils.getResponseText('/AdminLTE_Mod/BDM/Peer/PeerCoun/List.aspx?optype=content_score&seq_no=' + seq_no);
            if (content_score) {
                var content_score_json = eval("(" + content_score + ")");
                _form_edit.setFormData(content_score_json);
            }
        }

        //获得查询条件中的参数
        function GetSearchUrlParam() {
            var PEER_YEAR = DropDownUtils.getDropDownValue("search-PEER_YEAR");
            var PEER_SEQ_NO = DropDownUtils.getDropDownValue("search-PEER_SEQ_NO");
            var COUN_NAME = $("#search-COUN_NAME").val();

            var strq = "";
            if (PEER_YEAR)
                strq += "&PEER_YEAR=" + PEER_YEAR;
            if (PEER_SEQ_NO)
                strq += "&PEER_SEQ_NO=" + PEER_SEQ_NO;
            if (COUN_NAME)
                strq += "&COUN_NAME=" + OptimizeUtils.FormatParamter(COUN_NAME);

            return strq;
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>