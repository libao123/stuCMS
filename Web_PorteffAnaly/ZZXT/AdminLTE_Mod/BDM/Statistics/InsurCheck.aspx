<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="InsurCheck.aspx.cs" 
    Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Statistics.InsurCheck" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList; //主列表
        $(function () {
            adaptionHeight();
            loadTableList();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>保险信息核对统计</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i>主页</a></li>
				<li>统计查询</li>
				<li class="active">保险信息核对统计</li>
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
            tablePackageMany.filed = [
                { "data": "XY_NAME", "head": "学院", "type": "td-keep" },
				{ "data": "INSUR_NAME", "head": "保险名称", "type": "td-keep" },
				{ "data": "Y_NUM", "head": "学院级未核人数", "type": "td-keep" },
				{ "data": "F_NUM", "head": "辅导员未核人数", "type": "td-keep" },
				{ "data": "S_NUM", "head": "学生未核人数", "type": "td-keep" },
                { "data": "PASS_NUM", "head": "应核人数", "type": "td-keep" },
                { "data": "REMAIN_NUM", "head": "剩余人数", "type": "td-keep" }
            ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "统计查询",
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
					    { "data": "INSUR_YEAR", "pre": "保险学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
                        { "data": "STU_TYPE", "pre": "学生类型", "col": 1, "type": "select", "ddl_name": "ddl_basic_stu_type" },
                        { "data": "INSUR_SEQ_NO", "pre": "保险名称", "col": 4, "type": "select", "ddl_name": "ddl_insur_project" },
                        { "data": "XY", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" }
                    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });

            var _content = $("#content");
            //刷新
            _content.on('click', ".btn-reload", function () {
                mainList.reload();
            });
        }
    </script>
    <!-- 列表JS 结束-->
</asp:Content>
