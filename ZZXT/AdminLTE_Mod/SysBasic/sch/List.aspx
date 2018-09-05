<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.SysBasic.sch.List" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<script type="text/javascript">
		$(function () {
			DropDownUtils.initDropDown("CURRENT_YEAR");
			DropDownUtils.initDropDown("CURRENT_XQ");
			ValidateUtils.setRequired("#form_edit", "SCHOOL_NAME", true, "学校名称必填");
			ValidateUtils.setRequired("#form_edit", "CURRENT_YEAR", true, "当前学年必填");
			ValidateUtils.setRequired("#form_edit", "CURRENT_XQ", true, "当前学期必填");
			$("#btnSave").click(function () {
				if ($("#form_edit").valid()) {
					$.post("?optype=save&t=" + Math.random(), $("#form_edit").serialize(), function (msg) {
						if (msg.length != 0) {
							easyAlert.timeShow({
								"content": msg,
								"duration": 2,
								"type": "danger"
							});
						}
						else {
							easyAlert.timeShow({
								"content": "保存成功！",
								"duration": 2,
								"type": "success"
							});
						}
					})
				}
			});
		})
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
<div id="menuFrame" class="content-wrapper" id="main-container">
	<section class="content-header">
		<h1>学年学期设置</h1>
	    <ol class="breadcrumb">
	      	<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
	      	<li>系统维护</li>
	      	<li class="active">学年学期设置</li>
	    </ol>
  	</section>
	<!-- row -->
	<div class="content">
		<form class="form-horizontal box box-default no-shadow" id="form_edit" style="overflow:hidden;">
			<input type="hidden" name="SCHOOL_CODE" id="SCHOOL_CODE" value="<%=head.SCHOOL_CODE %>" />
			<div id="buttonId" class="box-header">
				<h3 class="box-title">当前学年学期设置</h3>
				<div class="box-tools">
					<div class="input-group input-group-sm">
						<div class="input-group-btn" style="display:inline-block">
							<button type="button" style="margin-right:10px;" class="btn btn-primary btn-xs" id="btnSave">保存</button>
						</div>
					</div>
				</div>
			</div>
			<div class="box-body">
			<div class="form-group">
				<label for="SCHOOL_NAME" class="col-sm-2 control-label">学校名称<span style="color: Red;">*</span></label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="SCHOOL_NAME" name="SCHOOL_NAME" value="<%=head.SCHOOL_NAME%>" placeholder="学校名称">
				</div>
			</div>
			<div class="form-group">
				<label for="CURRENT_YEAR" class="col-sm-2 control-label">当前学年<span style="color: Red;">*</span></label>
				<div class="col-sm-10">
					<select class="form-control" name="CURRENT_YEAR" id="CURRENT_YEAR" d_value='<%=head.CURRENT_YEAR%>' ddl_name='ddl_year_type' show_type='t'>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label for="CURRENT_XQ" class="col-sm-2 control-label">当前学期<span style="color: Red;">*</span></label>
				<div class="col-sm-10">
					<select class="form-control" name="CURRENT_XQ" id="CURRENT_XQ" d_value='<%=head.CURRENT_XQ%>' ddl_name='ddl_xq' show_type='t'>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label for="CURRENT_XQ" class="col-sm-2 control-label">简介</label>
				<div class="col-sm-10">
					<textarea id="REMARK" name="REMARK" rows="10" class="form-control"><%=head.REMARK%></textarea>
				</div>
			</div>
			</div>
		</form>
	</div>
</div>
</asp:Content>
