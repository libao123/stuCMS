<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.APP.DataBaseControl.SqlSearch.List" %>

<%@ OutputCache Duration="1" VaryByParam="none" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            adaptionHeight();
        });

        function SqlSearch() {
            //校验是否是有效SQL
            var strq = $("#form_sqlsearch").serialize();
            var result = AjaxUtils.getResponseText("List.aspx?optype=check&" + strq);
            if (result.length > 0) {
                easyAlert.timeShow({
                    "content": result,
                    "duration": 3,
                    "type": "warn"
                });
                return;
            }
            //查询SQL

            //配置表格列
            var column = AjaxUtils.getResponseText("List.aspx?optype=column&" + strq);
            tablePackage.filed = eval("(" + column + ")");
            //配置表格
            var data = AjaxUtils.getResponseText("List.aspx?optype=search&" + strq);

            tablePackage.createOne({
                //可ajax ing
                hasAjax: {
                    type: "client",
                    url: OptimizeUtils.FormatUrl("List.aspx?optype=search&" + strq),
                    method: "GET"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    tableConfig: {
                        'pageLength': 25, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                }
            });
        }

        function Reload() {
            window.location.reload(true);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
<div id="menuFrame" class="content-wrapper" id="main-container">
	<section class="content-header">
		<h1>数据库查询</h1>
	    <ol class="breadcrumb">
	      	<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
	      	<li>个人中心</li>
	      	<li class="active">数据库查询</li>
	    </ol>
  	</section>
		<div class="content">
            <div class="box box-default" id="SQLSearch">
                <div class="box-body">
                    <form class="form-horizontal col-sm-12" id="form_sqlsearch">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            数据库查询语句：</label>
                        <div class="col-sm-8">
                            <textarea class="form-control" name="sql_txt" id="sql_txt" rows="5" cols=""></textarea>
                        </div>
                        <div class="col-sm-2">
                            <button type="button" onclick="SqlSearch();" class="btn btn-block btn-primary btn-sm btn-SQL">
                                查询</button>
                            <button type="button" onclick="Reload();" class="btn btn-block btn-primary btn-sm btn-SQL">
                                清除</button>
                        </div>
                    </div>
                    </form>
                </div>
            </div>
            <div class="box box-default" style="border-top: none;">
                <table id="tablelist" class="table table-bordered table-striped table-hover">
                </table>
            </div>
        </div>	
</div>
</asp:Content>