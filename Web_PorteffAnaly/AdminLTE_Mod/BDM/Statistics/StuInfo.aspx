<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="StuInfo.aspx.cs" 
    Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Statistics.StuInfo" %>

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
			<h1>学生基本信息统计</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i>主页</a></li>
				<li>统计查询</li>
				<li class="active">学生基本信息统计</li>
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
				{ "data": "STUTYPE", "head": "学生类型", "type": "td-keep" },
				{ "data": "NUM1", "head": "<%=grade %>级", "type": "td-keep" },
				{ "data": "NUM2", "head": "<%=grade-1 %>级", "type": "td-keep" },
				{ "data": "NUM3", "head": "<%=grade-2 %>级", "type": "td-keep" },
                { "data": "NUM4", "head": "<%=grade-3 %>级", "type": "td-keep" },
                { "data": "TOTAL_NUM", "head": "总人数", "type": "td-keep" }
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
                        { "data": "EDULENTH", "pre": "年级", "col": 4, "type": "select", "ddl_name": "ddl_grade", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
                        { "data": "COLLEGE", "pre": "学院", "col": 4, "type": "select", "ddl_name": "ddl_department" },
                        { "data": "STUTYPE", "pre": "学生类型", "col": 4, "type": "select", "ddl_name": "ddl_basic_stu_type" }
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
                var datatable = $("#tablelist").dataTable();
                if (datatable) {
                    datatable.fnClearTable();    //清空数据
                    datatable.fnDestroy();         //销毁datatable
                }
                //mainList.reload();
                $('tr:first', $('#tablelist')).wrap('<thead></thead>');
            });

            function ReloadHead() {
                var result = AjaxUtils.getResponseText("?optype=getcols&grade=" + $('#search-EDULENTH').val()).split(';');
                var cols = [];
                for (var i = 0; i < result.length; i++) {
                    var value = result[i].split(',');
                    cols.push({ 'data': value[0], 'head': value[1], 'type': value[2] });
                }
                mainList.reloadhead("tablelist", cols);
            }
        }
    </script>
    <!-- 列表JS 结束-->
</asp:Content>
