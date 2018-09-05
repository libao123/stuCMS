<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectApply.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList; //主列表
        var _form_edit;
        $(function () {
            adaptionHeight();
            //编辑页控制定义
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
			<h1>保险申请</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>保险管理</li>
				<li class="active">保险申请</li>
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
    <!-- 下载导入模板界面 开始 -->
    <div class="modal" id="downloadExcelModal">
        <div class="modal-dialog">
            <form action="#" method="post" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">下载导入模板</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <a href="/Excel/Model/Insur/导入模板_城镇居民医疗保险.xls" style="margin-left: 20px;">城镇居民基本医疗保险（医保）</a>
                    <br />
                    <a href="/Excel/Model/Insur/导入模板_学生团体平安保险.xls" style="margin-left: 20px;">学生团体平安保险（学安险）</a>
                    <br />
                    <a href="/Excel/Model/Insur/导入模板_校园方责任保险.xls" style="margin-left: 20px;">校园方责任保险</a>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 下载导入模板界面 结束-->
    <!-- 导入界面 开始-->
    <div class="modal" id="importModal">
        <div class="modal-dialog">
            <form id="form_import" name="form_import" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">保险信息导入</h4>
            </div>
            <div class="modal-body">

                    <iframe id="importFrame" frameborder="0" src="" style="width: 100%; height: 250px;">
                    </iframe>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 导入界面 结束-->
    <!-- 编辑界面 开始 -->
    <div class="modal" id="editModal">
        <div class="modal-dialog modal-dw70">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">学生保险信息</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        保险项目类型</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="INSUR_TYPE" id="INSUR_TYPE" d_value='' ddl_name='ddl_insur_type'
                            show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        保险项目学年</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="INSUR_YEAR" id="INSUR_YEAR" d_value='' ddl_name='ddl_year_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        保险项目名称</label>
                    <div class="col-sm-10">
                        <select class="form-control" name="INSUR_SEQ_NO" id="INSUR_SEQ_NO" d_value='' ddl_name='ddl_insur_project'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学号</label>
                    <div class="col-sm-4">
                        <input name="STU_NUMBER" id="STU_NUMBER" type="text" class="form-control" placeholder="学号" />
                    </div>

                    <label class="col-sm-2 control-label">
                        姓名</label>
                    <div class="col-sm-4">
                        <input name="STU_NAME" id="STU_NAME" type="text" class="form-control" placeholder="姓名" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学院</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="XY" id="XY" d_value='' ddl_name='ddl_department'
                            show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        年级</label>
                    <div class="col-sm-4">
                        <input name="GRADE" id="GRADE" type="text" class="form-control" placeholder="年级" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        专业</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="ZY" id="ZY" d_value='' ddl_name='ddl_zy' show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        班级</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="CLASS_CODE" id="CLASS_CODE" d_value='' ddl_name='ddl_class'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        承保期限</label>
                    <div class="col-sm-4">
                        <input name="INSUR_LIMITDATE" id="INSUR_LIMITDATE" type="text" class="form-control"
                            placeholder="承保期限" />
                    </div>

                    <label class="col-sm-2 control-label">
                        金额</label>
                    <div class="col-sm-4">
                        <input name="INSUR_MONEY" id="INSUR_MONEY" type="text" class="form-control" placeholder="金额" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
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
                    { "data": "INSUR_TYPE_NAME", "head": "保险类型", "type": "td-keep" },
				    { "data": "INSUR_YEAR_NAME", "head": "保险学年", "type": "td-keep" },
				    { "data": "INSUR_NAME", "head": "保险名称", "type": "td-keep" },
				    { "data": "STU_NUMBER", "head": "申请人学号", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "申请人姓名", "type": "td-keep" },
                    { "data": "INSUR_LIMITDATE", "head": "承保期限", "type": "td-keep" },
                    { "data": "INSUR_MONEY", "head": "金额", "type": "td-keep" },
                    { "data": "XY_NAME", "head": "所属学院", "type": "td-keep" },
                    { "data": "ZY_NAME", "head": "所属专业", "type": "td-keep" },
                    { "data": "GRADE", "head": "所属年级", "type": "td-keep" },
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" },
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
                    tableTitle: "保险信息",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': false, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
					    { "data": "INSUR_TYPE", "pre": "保险类型", "col": 1, "type": "select", "ddl_name": "ddl_insur_type" },
					    { "data": "INSUR_YEAR", "pre": "保险学年", "col": 2, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
                        { "data": "INSUR_SEQ_NO", "pre": "保险名称", "col": 4, "type": "select", "ddl_name": "ddl_insur_project" },
                        { "data": "XY", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 3, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 4, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 5, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 6, "type": "input" },
                        { "data": "RET_CHANNEL", "pre": "流程状态", "col": 4, "type": "select", "ddl_name": "ddl_RET_CHANNEL" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing" } },
                { type: "userDefined", id: "auto", title: "自动生成", className: "btn-warning", attr: { "data-action": "", "data-other": "nothing" } },
                { type: "userDefined", id: "download", title: "导入模板下载", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "import", title: "导入保险信息", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "delete", title: "删除", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //保险类型、学年、保险项目联动
            SelectUtils.Insur_Year_ProjectChange("search-INSUR_TYPE", "search-INSUR_YEAR", "search-INSUR_SEQ_NO", '', '<%=sch_info.CURRENT_YEAR %>', '');
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASS_CODE");
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 按钮事件 开始-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _downloadExcelModal = $("#downloadExcelModal");
            var _importModal = $("#importModal");
            var _editModal = $("#editModal");
            var _btns = {
                reload: '.btn-reload'
            };
            //-----------主列表按钮---------------
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【自动生成】
            _content.on('click', "#auto", function () {
                //选择保险类型、学年、保险名称，才可以自动生成
                var INSUR_TYPE = DropDownUtils.getDropDownValue("search-INSUR_TYPE");
                var INSUR_YEAR = DropDownUtils.getDropDownValue("search-INSUR_YEAR");
                var INSUR_SEQ_NO = DropDownUtils.getDropDownValue("search-INSUR_SEQ_NO");
                if (!INSUR_TYPE || !INSUR_YEAR || !INSUR_SEQ_NO) {
                    easyAlert.timeShow({
                        "content": "查询条件：保险类型、学年、保险名称不能为空！",
                        "duration": 3,
                        "type": "info"
                    });
                    return;
                }
                if (INSUR_TYPE == "A" || INSUR_TYPE == "C") {
                    //弹出遮罩层
                    // var layInx = layer.load(1, { shade: [0.8, '#393D49'] });//遮罩层
                    PropLoad.loading();
                    //后台生成数据
                    var postData = { "insur_seq_no": INSUR_SEQ_NO };
                    var url = "List.aspx?optype=auto_data";
                    $.ajax({
                        cache: false,
                        type: "POST",
                        url: url,
                        async: false,
                        data: postData,
                        success: function (result) {
                            if (result) {
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                // layer.close(layInx);
                                PropLoad.remove();
                                return;
                            }
                        }
                    });
                }
                else {
                    easyAlert.timeShow({
                        "content": "保险类型不符合自动生成数据的条件！",
                        "duration": 3,
                        "type": "info"
                    });
                    // layer.close(layInx);
                    PropLoad.remove();
                    return;
                }
            });
            //【删除】
            _content.on('click', "#delete", function () {
                DeleteData();
            });
            //【导入模板下载】
            _content.on('click', "#download", function () {
                _downloadExcelModal.modal();
            });
            //【导入保险信息】
            _content.on('click', "#import", function () {
                $("#importFrame").attr("src", '/Excel/ImportExcel/ImportExcel.aspx?model_id=importModal&type=INPUT_INSUR_APPLY');
                $("#importModal").modal();
            });
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //赋值
                        _form_edit.setFormData(data);
                        //设置不可编辑
                        _form_edit.disableAll();
                        _editModal.modal();
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
            DropDownUtils.initDropDown("INSUR_SEQ_NO");
            DropDownUtils.initDropDown("INSUR_TYPE");
            DropDownUtils.initDropDown("INSUR_YEAR");
            DropDownUtils.initDropDown("XY");
            DropDownUtils.initDropDown("ZY");
            DropDownUtils.initDropDown("CLASS_CODE");
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            LimitUtils.onlyNumAndPoint("INSUR_MONEY"); //金额
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //------------------主列表按钮事件------------------
        //删除事件
        function DeleteData() {
            //列表勾选
            var strOids = "";
            var datas = mainList.selection();
            if (datas) {
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i]) {
                        if (datas[i].OID) {
                            strOids += datas[i].OID + ",";
                        }
                    }
                }
            }
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除选中的数据吗？",
                'title': '删除数据',
                'callback': function (btn) {
                    var postData = { "SELECT_OID": strOids };
                    var url = "List.aspx?optype=delete";
                    $.ajax({
                        cache: false,
                        type: "POST",
                        url: url,
                        async: false,
                        data: postData,
                        success: function (result) {
                            if (result) {
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
            });
        }
        //导入时，调用父界面的刷新方法，所以父界面这个方法一定要定义
        function ImportReload() {
            mainList.reload();
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
