<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.Demo.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        //配置表格各栏参数
        tablePackage.filed = [
				{ "data": "USER_ID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "USER_ID", "head": "用户编码" },
				{ "data": "USER_NAME", "head": "用户名" },
				{ "data": "USER_TYPE_NAME", "head": "用户类型" },
				{ "data": "XY_CODE_NAME", "head": "所属学院" },
				{ "data": "USER_ROLE_NAME", "head": "所属角色" },
				{ "data": "IS_ASSISTANT_NAME", "head": "是否辅导员" },
				{ "data": "CREATE_NAME", "head": "最后操作人" },
                { "data": "CREATE_TIME", "head": "最后操作时间" }
                ];

        var tableModalCols = [//弹出层布局label+form<=12，
			{"data": 'name', 'label': '4', 'form': '8', 'parent': '6' },
			{ "data": 'position', 'label': '4', 'form': '8', 'parent': '6' },
			{ "data": 'extn', 'label': '3', 'form': '9', 'parent': '12', 'type': 'timeSingle' },
			{ "data": 'salary', 'label': '3', 'form': '9', 'parent': '12', 'type': 'textarea', 'pre': "xxxx" },
			{ "data": 'start_date', 'label': '3', 'form': '9', 'parent': '12', 'type': 'checkbox' },
			{ "data": 'office', 'label': '3', 'form': '9', 'parent': '12' }, //type timeRange
		];

        var modalConfigs = {//弹出层配置
            "content": "content",
            "table": "dataTable1",
            "modal": "dataModal", //弹出层id
            "delModal": "delModal", //删除层id
            "title": "新生录入管理", //弹出层标题
            "delCol": ["USER_ID", "USER_ROLE_NAME", ], //删除所需字段
            "delAction": 'List.aspx?optype=delete', //删除url
            "modalAction": '/api/xxx', //弹出层url
            "modalSuccess": function () {//回调事件
                console.log('modal call back');
            },
            "struct": [//构造弹出层
		  	{'tabs': "y1x2", 'columns': tableModalCols }, //有tab则可以切换
            // {'columns': tableModalCols},//没有tab则显示单表格
		  ],
            "eventConfig": {

            }
        };
        //加载界面
        $(function () {
            tablePackage.createOne({
                //数据Ajax的链接
                hasAjax: {
                    url: 'List.aspx?optype=getlist'
                },
                attrs: {//表格参数
                    tableId: "tabList", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "用户管理",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 20, //每页显示个数，默认10条
                        'selectSingle': false
                    }
                },
                hasSearch: {
                    // "searchBtn":	".btn-search",//查询按钮，不写默认
                    //查询栏配置字段：第一个是标识，第二个是预文字，第三是栏目的位置
                    "cols": [{ "data": "USER_ID", "pre": "用户编码", "col": 1 },
					{ "data": "USER_NAME", "pre": "用户名", "col": 2}]
                },
                hasModal: modalConfigs, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del"], //需要的按钮
                hasCtrl: {
                    "buildModal": true
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div class="wrapper">
        <div class="content-wrapper">
            <!-- Content Header -->
            <section class="content-header">
			      	<h1>
			        	系统维护
			      	</h1>
			      	<ol class="breadcrumb">
				        <li><a href="#"><i class="fa fa-dashboard"></i>权限设置</a></li>
				        <li><a href="#">用户管理</a></li>
			      	</ol>
			    </section>
            <!-- Main content -->
            <section class="content" id="content">
			    	<div class="row">
				        <div class="col-xs-12">
				        	<div id="alertDiv"></div>
								<div class="box box-info">
									<table id="tabList" class="table table-bordered table-striped table-hover">
									</table>
								</div>
				        </div>
				    </div>
			    </section>
        </div>
    </div>
</asp:Content>