<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Score.RankInfo.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();

            loadTableList();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>排名统计</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>成绩管理</li>
				<li class="active">排名统计</li>
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
    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "YEAR_NAME", "head": "学年", "type": "td-keep" },
				    { "data": "CLASS_CODE_NAME", "head": "班级", "type": "td-keep" },
				    { "data": "STU_NUMBER", "head": "学号", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "姓名", "type": "td-keep" },
				    { "data": "XY_NAME", "head": "学院", "type": "td-keep" },
				    { "data": "ZY_NAME", "head": "专业", "type": "td-keep" },
				    { "data": "GRADE", "head": "年级", "type": "td-keep" },
				    { "data": "SCORE_CONDUCT", "head": "操行综合分", "type": "td-keep" },
                    { "data": "SCORE_COURSE", "head": "课程学习综合分", "type": "td-keep" },
                    { "data": "SCORE_BODYART", "head": "体艺综合分", "type": "td-keep" },
                    { "data": "SCORE_JOBSKILL", "head": "职业技能综合分", "type": "td-keep" },
                    { "data": "SCORE_COM", "head": "综合考评总分", "type": "td-keep" },
                    { "data": "RANK_CLASS_COM", "head": "班级排名", "type": "td-keep" },
                    { "data": "RANK_GRADE_COM", "head": "年级排名", "type": "td-keep" },
                    { "data": "RANK_CLASS_NUM", "head": "班级排名总人数", "type": "td-keep" },
                    { "data": "RANK_GRADE_NUM", "head": "年级排名总人数", "type": "td-keep" },
                    { "data": "RANK_CLASS_PER", "head": "班级百分比", "type": "td-keep" },
                    { "data": "RANK_GRADE_PER", "head": "年级百分比", "type": "td-keep" },
                    { "data": "RANK_GRADE_PER", "head": "综合考评总分%", "type": "td-keep" },
                    { "data": "SCORE_CONDUCT_PER", "head": "操行综合分%", "type": "td-keep" },
                    { "data": "SCORE_COURSE_PER", "head": "课程学习综合分%", "type": "td-keep" },
                    { "data": "SCORE_BODYART_PER", "head": "体艺综合分%", "type": "td-keep" },
                    { "data": "SCORE_JOBSKILL_PER", "head": "职业技能综合分%", "type": "td-keep" },
                    { "data": "OP_NAME", "head": "操作人", "type": "td-keep" },
                    { "data": "OP_TIME", "head": "操作时间", "type": "td-keep" }
		    ];

            //配置表格
            tablePackage.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/BDM/Score/Input/List.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "综合成绩测评管理 >> 排名统计",
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
                        { "data": "YEAR", "pre": "学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=strLastYear %>" },
					    { "data": "XY", "pre": "学院", "col": 2, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 3, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 4, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 5, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "学号", "col": 6, "type": "input" },
                        { "data": "STU_NAME", "pre": "姓名", "col": 7, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload"
                //{ type: "enter", modal: null, title: "查阅", action: "view" }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASS_CODE");
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });
        }
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
    </script>
    <!-- 编辑页验证事件-->
    <script type="text/javascript">
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>