<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="ImportList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectCheck.ImportList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList;
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
			<h1>核对信息导入</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>奖助管理</li>
				<li class="active">核对信息导入</li>
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
        <div class="modal-dialog">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">核对信息</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="CHECK_OID" name="CHECK_OID" value="" />
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
                        <select class="form-control" name="PROJECT_CLASS" id="PROJECT_CLASS" d_value='' ddl_name='ddl_jz_project_class' show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">申请表格类型</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="PROJECT_TYPE" id="PROJECT_TYPE" d_value='' ddl_name='ddl_jz_project_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">项目学年</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="PROJECT_YEAR" id="PROJECT_YEAR" d_value='' ddl_name='ddl_year_type' show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">项目金额</label>
                    <div class="col-sm-4">
                        <input name="PROJECT_MONEY" id="PROJECT_MONEY" type="text" class="form-control" placeholder="项目金额" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">学号</label>
                    <div class="col-sm-4">
                        <input name="STU_NUMBER" id="STU_NUMBER" type="text" class="form-control" placeholder="学号" />
                    </div>

                    <label class="col-sm-2 control-label">姓名</label>
                    <div class="col-sm-4">
                        <input name="STU_NAME" id="STU_NAME" type="text" class="form-control" placeholder="姓名" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">院系</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="XY" id="XY" d_value='' ddl_name='ddl_department'
                            show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">专业</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="ZY" id="ZY" d_value='' ddl_name='ddl_zy' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">年级</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="GRADE" id="GRADE" d_value='' ddl_name='ddl_grade' show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        班级</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="CLASS_CODE" id="CLASS_CODE" d_value='' ddl_name='ddl_class' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">核对前银行卡号</label>
                    <div class="col-sm-4">
                        <input name="OLD_BANKCODE" id="OLD_BANKCODE" type="text" class="form-control" placeholder="核对前银行卡号" />
                    </div>

                    <label class="col-sm-2 control-label">核对后银行卡号</label>
                    <div class="col-sm-4">
                        <input name="NEW_BANKCODE" id="NEW_BANKCODE" type="text" class="form-control" placeholder="核对后银行卡号" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">核对前身份证号</label>
                    <div class="col-sm-4">
                        <input name="OLD_IDCARDNO" id="OLD_IDCARDNO" type="text" class="form-control" placeholder="核对前身份证号" />
                    </div>

                    <label class="col-sm-2 control-label">核对后身份证号</label>
                    <div class="col-sm-4">
                        <input name="NEW_IDCARDNO" id="NEW_IDCARDNO" type="text" class="form-control" placeholder="核对后身份证号" />
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
    <!-- 导入界面 开始-->
    <div class="modal fade" id="importModal">
        <div class="modal-dialog">
          <form id="form_import" name="form_edit" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">线下项目核对信息导入</h4>
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
                    { "data": "PROJECT_CLASS_NAME", "head": "项目级别", "type": "td-keep" },
                    { "data": "PROJECT_NAME", "head": "项目名称", "type": "td-keep" },
                    { "data": "PROJECT_MONEY", "head": "项目金额", "type": "td-keep" },
                    { "data": "PROJECT_YEAR_NAME", "head": "项目学年", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "申请人姓名", "type": "td-keep" },
                    { "data": "CHECK_STEP", "head": "核对阶段", "type": "td-keep" },
                    { "data": "S_CHECK_TIME", "head": "学生核对时间", "type": "td-keep" },
                    { "data": "F_CHECK_TIME", "head": "辅导员核对时间", "type": "td-keep" },
                    { "data": "Y_CHECK_TIME", "head": "学院核对时间", "type": "td-keep" },
                    { "data": "CHECK_START", "head": "核对开始时间", "type": "td-keep" },
                    { "data": "CHECK_END", "head": "核对结束时间", "type": "td-keep" },
                    { "data": "OLD_BANKCODE", "head": "核对前学生银行卡号", "type": "td-keep" },
                    { "data": "NEW_BANKCODE", "head": "核对后学生银行卡号", "type": "td-keep" },
                    { "data": "OLD_IDCARDNO", "head": "核对前学生身份证号", "type": "td-keep" },
                    { "data": "NEW_IDCARDNO", "head": "核对后学生身份证号", "type": "td-keep" },
                    { "data": "XY_NAME", "head": "所属学院", "type": "td-keep" },
                    { "data": "ZY_NAME", "head": "所属专业", "type": "td-keep" },
                    { "data": "GRADE", "head": "所属年级", "type": "td-keep" },
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "CheckList.aspx?optype=getlist&from_page=check_import",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "线下项目核对信息导入",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(6)');
                            if (aData.CHECK_STEP == "1") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "warning",
                                        "msg": "学生已核对"
                                    });
                            } else if (aData.CHECK_STEP == "2") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "primary",
                                        "msg": "辅导员已核对"
                                    });
                            } else if (aData.CHECK_STEP == "3") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "学院已核对"
                                    });
                            }
                            else {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "未核对"
                                    });
                            }
                        }
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
					    { "data": "PROJECT_YEAR", "pre": "项目学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
					    { "data": "PROJECT_CLASS", "pre": "项目级别", "col": 2, "type": "select", "ddl_name": "ddl_jz_project_class" },
                        { "data": "PROJECT_TYPE", "pre": "申请表格类型", "col": 3, "type": "select", "ddl_name": "ddl_jz_project_type" },
                        { "data": "PROJECT_SEQ_NO", "pre": "项目名称", "col": 4, "type": "select", "ddl_name": "ddl_jz_project_name_end" },
                        { "data": "XY", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 3, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 4, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 5, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 6, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "download", title: "核对信息导入模板下载", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "import", title: "核对信息导入", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //奖助级别、奖助类型 联动
            SelectUtils.JZ_Class_Type_Year_ProjectChange("search-PROJECT_CLASS", "search-PROJECT_TYPE", "search-PROJECT_YEAR", "search-PROJECT_SEQ_NO", '', '', '', '', 'end');
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
            var _tableModal = $("#tableModal");
            var _tableModal_Check = $("#tableModal_Check");
            var _btns = {
                reload: '.btn-reload'
            };
            //-----------主列表按钮---------------
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //弹出核对信息界面
                        _form_edit.setFormData(data);
                        $("#CHECK_OID").val(data.CHECK_OID);
                        //不可编辑
                        _form_edit.disableAll();
                        _tableModal.modal();
                    }
                }
            });
            //【核对信息导入模板下载】
            _content.on('click', "#download", function () {
                window.open('/Excel/Model/Project/导入模板_奖助核对信息表.xls');
            });
            //【核对信息导入】
            _content.on('click', "#import", function () {
                $("#importFrame").attr("src", '/Excel/ImportExcel/ImportExcel.aspx?model_id=importModal&type=INPUT_PROJECT_CHECK');
                $("#importModal").modal();
            });
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("PROJECT_CLASS");
            DropDownUtils.initDropDown("PROJECT_TYPE");
            DropDownUtils.initDropDown("PROJECT_YEAR");
            DropDownUtils.initDropDown("XY");
            DropDownUtils.initDropDown("ZY");
            DropDownUtils.initDropDown("GRADE");
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
        //导入时，调用父界面的刷新方法，所以父界面这个方法一定要定义
        function ImportReload() {
            mainList.reload();
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
