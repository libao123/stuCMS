<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="NoSubmitList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter.NoSubmitList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            adaptionHeight();
            loadTableList();
            loadModalBtnInit();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>学生未修改信息查看</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>个人中心</li>
				<li class="active">学生未修改信息查看</li>
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
				{ "data": 'NUMBER', "head": '学号', "type": "td-keep" },
				{ "data": 'NAME', "head": '姓名', "type": "td-keep" },
				{ "data": 'COLLEGE_NAME', "head": '学院', "type": "td-keep" },
				{ "data": 'MAJOR_NAME', "head": '专业', "type": "td-keep" },
				{ "data": 'EDULENTH', "head": '年级', "type": "td-keep" },
				{ "data": 'SEX_NAME', "head": '性别', "type": "td-keep" },
				{ "data": 'IDCARDNO', "head": '身份证号', "type": "td-keep" },
				{ "data": 'GARDE', "head": '出生日期', "type": "td-keep" },
				{ "data": 'NATION_NAME', "head": '民族', "type": "td-keep" },
				{ "data": 'POLISTATUS_NAME', "head": '政治面貌', "type": "td-keep" },
				{ "data": 'CLASS_NAME', "head": '班级', "type": "td-keep" },
				{ "data": 'STUTYPE_NAME', "head": '学生类型', "type": "td-keep" }
			];

            //配置表格
            tablePackage.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/BDM/STU/List.aspx?optype=getlist&page_from=nosubmit",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "未提交修改学生信息",
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
						{ "data": "NUMBER", "pre": "学号", "col": 1, "type": "input" },
						{ "data": "NAME", "pre": "姓名", "col": 2, "type": "input" },
						{ "data": "IDCARDNO", "pre": "身份证号", "col": 3, "type": "input" },
						{ "data": "COLLEGE", "pre": "学院", "col": 4, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "MAJOR", "pre": "专业", "col": 5, "type": "select", "ddl_name": "ddl_zy" },
						{ "data": "EDULENTH", "pre": "年级", "col": 6, "type": "select", "ddl_name": "ddl_grade" },
						{ "data": "CLASS", "pre": "班级", "col": 7, "type": "select", "ddl_name": "ddl_class" },
						{ "data": "STUTYPE", "pre": "学生类型", "col": 8, "type": "select", "ddl_name": "ddl_basic_stu_type" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-COLLEGE", "search-MAJOR", "search-EDULENTH", "search-CLASS");
        }
    </script>
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _btns = {
                reload: '.btn-reload'
            };

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });
        }
    </script>
</asp:Content>