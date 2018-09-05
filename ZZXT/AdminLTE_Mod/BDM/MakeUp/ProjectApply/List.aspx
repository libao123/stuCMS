<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.MakeUp.ProjectApply.List" %>

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
			<h1>学费补偿贷款代偿信息</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>学费补偿贷款代偿管理</li>
				<li class="active">学费补偿贷款代偿信息</li>
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
    <div class="modal fade" id="downloadExcelModal">
        <div class="modal-dialog">
            <form action="#" method="post" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">下载导入模板</h4>
            </div>
            <div class="modal-body">

                    <a href="/Excel/Model/Makeup/导入模板_学费补偿贷款代偿信息.xls" style="margin-left: 20px;">学费补偿贷款代偿信息导入模板</a>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 下载导入模板界面 结束-->
    <!-- 导入界面 开始-->
    <div class="modal fade" id="importModal">
        <div class="modal-dialog">
            <form id="form_import" name="form_import" class="modal-content form-horizontal form-inline">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">学费补偿贷款代偿信息导入</h4>
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
    <div class="modal fade" id="editModal">
        <div class="modal-dialog modal-dw70">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">学生学费补偿贷款代偿信息</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        项目类型</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="MAKEUP_TYPE" id="MAKEUP_TYPE" d_value='' ddl_name='ddl_makyup_project_type'
                            show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        项目学年</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="MAKEUP_YEAR" id="MAKEUP_YEAR" d_value='' ddl_name='ddl_year_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        项目名称</label>
                    <div class="col-sm-10">
                        <select class="form-control" name="MAKEUP_SEQ_NO" id="MAKEUP_SEQ_NO" d_value='' ddl_name='ddl_makyup_project'
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
                        政治面貌</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="POLISTATUS" id="POLISTATUS" d_value='' ddl_name='ddl_zzmm'
                            show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        民族</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="NATION" id="NATION" d_value='' ddl_name='ddl_mz'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        联系电话</label>
                    <div class="col-sm-4">
                        <input name="MOBILENUM" id="MOBILENUM" type="text" class="form-control" placeholder="联系电话" />
                    </div>

                    <label class="col-sm-2 control-label">
                        申请及获代偿金额/元</label>
                    <div class="col-sm-4">
                        <input name="MAKEUP_MONEY" id="MAKEUP_MONEY" type="text" class="form-control" placeholder="申请及获代偿金额（元）" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        资格类型</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="MAKEUP_QUALIF_TYPE" id="MAKEUP_QUALIF_TYPE" d_value=''
                            ddl_name='ddl_makyup_qualif_type' show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        代偿款项预计发放时间</label>
                    <div class="col-sm-4">
                        <input name="MAKEUP_SEND_DATE" id="MAKEUP_SEND_DATE" type="text" class="form-control"
                            placeholder="代偿款项预计发放时间（次年11月份左右）" />
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
                    { "data": "MAKEUP_TYPE_NAME", "head": "项目类型", "type": "td-keep" },
				    { "data": "MAKEUP_YEAR_NAME", "head": "项目学年", "type": "td-keep" },
				    { "data": "MAKEUP_NAME", "head": "项目名称", "type": "td-keep" },
				    { "data": "STU_NUMBER", "head": "申请人学号", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "申请人姓名", "type": "td-keep" },
                    { "data": "MAKEUP_MONEY", "head": "申请及获代偿金额", "type": "td-keep" },
                    { "data": "MAKEUP_QUALIF_TYPE_NAME", "head": "资格类型", "type": "td-keep" },
                    { "data": "MAKEUP_SEND_DATE", "head": "代偿款项预计发放时间", "type": "td-keep" },
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
                    url: 'List.aspx?optype=getlist&fun_type=<%=Request.QueryString["fun_type"] %>',
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "学费补偿贷款代偿信息",
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
                        { "data": "MAKEUP_YEAR", "pre": "项目学年", "col": 2, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
					    { "data": "MAKEUP_TYPE", "pre": "项目类型", "col": 1, "type": "select", "ddl_name": "ddl_makyup_project_type" },
                        { "data": "MAKEUP_SEQ_NO", "pre": "项目名称", "col": 3, "type": "select", "ddl_name": "ddl_makyup_project" },
                        { "data": "MAKEUP_QUALIF_TYPE", "pre": "资格类型", "col": 3, "type": "select", "ddl_name": "ddl_makyup_qualif_type" },
                        { "data": "XY", "pre": "学院", "col": 4, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 5, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 6, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 7, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 8, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 9, "type": "input" },
                        { "data": "STU_TYPE", "pre": "学生类型", "col": 10, "type": "select", "ddl_name": "ddl_ua_stu_type" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                <%if (bIsShowBtn){ %>
                { type: "userDefined", id: "download", title: "导入模板下载", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "import", title: "导入", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "delete", title: "删除", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                <%} %>
                <%if (bIsShowBtn_Export){ %>
                { type: "userDefined", id: "export", title: "导出", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                <%} %>
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //学费补偿贷款代偿类型、学年、学费补偿贷款代偿项目联动
            SelectUtils.Makeup_Year_ProjectChange("search-MAKEUP_TYPE", "search-MAKEUP_YEAR", "search-MAKEUP_SEQ_NO", '', '<%=sch_info.CURRENT_YEAR %>', '');
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
            //【删除】
            _content.on('click', "#delete", function () {
                DeleteData();
            });
            //【导入模板下载】
            _content.on('click', "#download", function () {
                _downloadExcelModal.modal();
            });
            //【导入学费补偿贷款代偿信息】
            _content.on('click', "#import", function () {
                $("#importFrame").attr("src", '/Excel/ImportExcel/ImportExcel.aspx?model_id=importModal&type=INPUT_MAKEUP_APPLY');
                $("#importModal").modal();
            });
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //赋值
                        _form_edit.setFormData(data);
                        var studata = AjaxUtils.getResponseText('List.aspx?optype=getstudata&stu_num=' + data.STU_NUMBER);
                        if (studata) {
                            var studata_json = eval("(" + studata + ")");
                            DropDownUtils.setDropDownValue("POLISTATUS", studata_json.POLISTATUS);
                            DropDownUtils.setDropDownValue("NATION", studata_json.NATION);
                            $("#MOBILENUM").val(studata_json.MOBILENUM);
                        }
                        //设置不可编辑
                        _form_edit.disableAll();
                        _editModal.modal();
                    }
                }
            });
            //【导出】
            _content.on('click', "#export", function () {
                //校验必选
                var MAKEUP_YEAR = DropDownUtils.getDropDownValue("search-MAKEUP_YEAR");
                var MAKEUP_TYPE = DropDownUtils.getDropDownValue("search-MAKEUP_TYPE");
                var MAKEUP_SEQ_NO = DropDownUtils.getDropDownValue("search-MAKEUP_SEQ_NO");
                var XY = DropDownUtils.getDropDownValue("search-XY");
                var STU_TYPE = DropDownUtils.getDropDownValue("search-STU_TYPE");
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=makeup_apply_list' + GetSearchUrlParam());
            });
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("MAKEUP_SEQ_NO");
            DropDownUtils.initDropDown("MAKEUP_TYPE");
            DropDownUtils.initDropDown("MAKEUP_YEAR");
            DropDownUtils.initDropDown("MAKEUP_QUALIF_TYPE");

            DropDownUtils.initDropDown("XY");
            DropDownUtils.initDropDown("ZY");
            DropDownUtils.initDropDown("CLASS_CODE");
            DropDownUtils.initDropDown("POLISTATUS");
            DropDownUtils.initDropDown("NATION");
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
        //获得查询条件中的参数
        function GetSearchUrlParam() {
            var MAKEUP_YEAR = DropDownUtils.getDropDownValue("search-MAKEUP_YEAR");
            var MAKEUP_TYPE = DropDownUtils.getDropDownValue("search-MAKEUP_TYPE");
            var MAKEUP_SEQ_NO = DropDownUtils.getDropDownValue("search-MAKEUP_SEQ_NO");
            var XY = DropDownUtils.getDropDownValue("search-XY");
            var ZY = DropDownUtils.getDropDownValue("search-ZY");
            var GRADE = DropDownUtils.getDropDownValue("search-GRADE");
            var CLASS_CODE = DropDownUtils.getDropDownValue("search-CLASS_CODE");
            var STU_NUMBER = $("#search-STU_NUMBER").val();
            var STU_NAME = $("#search-STU_NAME").val();
            var STU_TYPE = DropDownUtils.getDropDownValue("search-STU_TYPE");
            var MAKEUP_QUALIF_TYPE = DropDownUtils.getDropDownValue("search-MAKEUP_QUALIF_TYPE");

            var strq = "";
            if (MAKEUP_YEAR)
                strq += "&MAKEUP_YEAR=" + MAKEUP_YEAR;
            if (MAKEUP_TYPE)
                strq += "&MAKEUP_TYPE=" + MAKEUP_TYPE;
            if (MAKEUP_SEQ_NO)
                strq += "&MAKEUP_SEQ_NO=" + MAKEUP_SEQ_NO;
            if (XY)
                strq += "&XY=" + XY;
            if (ZY)
                strq += "&ZY=" + ZY;
            if (GRADE)
                strq += "&GRADE=" + GRADE;
            if (CLASS_CODE)
                strq += "&CLASS_CODE=" + CLASS_CODE;
            if (STU_NUMBER)
                strq += "&STU_NUMBER=" + OptimizeUtils.FormatParamter(STU_NUMBER);
            if (STU_NAME)
                strq += "&STU_NAME=" + OptimizeUtils.FormatParamter(STU_NAME);
            if (STU_TYPE)
                strq += "&STU_TYPE=" + STU_TYPE;
            if (MAKEUP_QUALIF_TYPE)
                strq += "&MAKEUP_QUALIF_TYPE=" + MAKEUP_QUALIF_TYPE;
            return strq;
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
