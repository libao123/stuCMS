<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="PersonalList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectResult.PersonalList" %>

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
			<h1>参保信息</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>学生保险管理</li>
                <li>信息查询</li>
				<li class="active">个人信息查询</li>
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
    <div class="modal" id="editModal">
        <div class="modal-dialog" style="width: 60%;">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
            onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    学生参保信息</h4>
            </div>
            <div class="modal-body row">
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        保险项目类型</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="INSUR_TYPE" id="INSUR_TYPE" d_value='' ddl_name='ddl_insur_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        保险项目学年</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="INSUR_YEAR" id="INSUR_YEAR" d_value='' ddl_name='ddl_year_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-12">
                    <label class="col-sm-2 control-label">
                        保险项目名称</label>
                    <div class="col-sm-10">
                        <select class="form-control" name="INSUR_SEQ_NO" id="INSUR_SEQ_NO" d_value='' ddl_name='ddl_insur_project'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        学号</label>
                    <div class="col-sm-8">
                        <input name="STU_NUMBER" id="STU_NUMBER" type="text" class="form-control" placeholder="学号" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        姓名</label>
                    <div class="col-sm-8">
                        <input name="STU_NAME" id="STU_NAME" type="text" class="form-control" placeholder="姓名" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        学院</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="XY" id="XY" d_value='' ddl_name='ddl_department'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        年级</label>
                    <div class="col-sm-8">
                        <input name="GRADE" id="GRADE" type="text" class="form-control" placeholder="年级" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        专业</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="ZY" id="ZY" d_value='' ddl_name='ddl_zy' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        班级</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="CLASS_CODE" id="CLASS_CODE" d_value='' ddl_name='ddl_class'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        承保期限</label>
                    <div class="col-sm-8">
                        <input name="INSUR_LIMITDATE" id="INSUR_LIMITDATE" type="text" class="form-control"
                            placeholder="承保期限" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        金额</label>
                    <div class="col-sm-8">
                        <input name="INSUR_MONEY" id="INSUR_MONEY" type="text" class="form-control" placeholder="金额" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        承保公司</label>
                    <div class="col-sm-8">
                        <input name="INSUR_COMPANY" id="INSUR_COMPANY" type="text" class="form-control" placeholder="承保公司" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        保单号</label>
                    <div class="col-sm-8">
                        <input name="INSUR_NUMBER" id="INSUR_NUMBER" type="text" class="form-control" placeholder="保单号" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        理赔人员</label>
                    <div class="col-sm-8">
                        <input name="INSUR_HANLDMAN" id="INSUR_HANLDMAN" type="text" class="form-control"
                            placeholder="理赔人员" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        联系电话</label>
                    <div class="col-sm-8">
                        <input name="INSUR_HANLDMAN_PHONE" id="INSUR_HANLDMAN_PHONE" type="text" class="form-control"
                            placeholder="联系电话" />
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
                    { "data": "INSUR_TYPE_NAME", "head": "保险类型", "type": "td-keep" },
				    { "data": "INSUR_YEAR_NAME", "head": "保险学年", "type": "td-keep" },
				    { "data": "INSUR_NAME", "head": "保险名称", "type": "td-keep" },
				    { "data": "STU_NUMBER", "head": "申请人学号", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "申请人姓名", "type": "td-keep" },
                    { "data": "INSUR_LIMITDATE", "head": "承保期限", "type": "td-keep" },
                    { "data": "INSUR_MONEY", "head": "金额", "type": "td-keep" },
                    { "data": "STU_PHONE", "head": "手机号", "type": "td-keep" },
                    { "data": "INSUR_COMPANY", "head": "承保公司", "type": "td-keep" },
                    { "data": "INSUR_HANLDMAN", "head": "理赔人员", "type": "td-keep" },
                    { "data": "INSUR_HANLDMAN_PHONE", "head": "联系电话", "type": "td-keep" },
                    { "data": "INSUR_NUMBER", "head": "保单号", "type": "td-keep" },
                    { "data": "XY_NAME", "head": "所属学院", "type": "td-keep" },
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/BDM/Insur/ProjectApply/List.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "个人信息查询",
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
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //保险类型、学年、保险项目联动
            SelectUtils.Insur_Year_ProjectChange("search-INSUR_TYPE", "search-INSUR_YEAR", "search-INSUR_SEQ_NO", '', '', '');
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
            var _editModal = $("#editModal");
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
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>