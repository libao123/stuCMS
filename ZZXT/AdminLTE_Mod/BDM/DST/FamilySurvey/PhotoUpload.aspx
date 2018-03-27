<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="PhotoUpload.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.FamilySurvey.PhotoUpload" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style type="text/css">
		.control-label{
			text-align:right;
		}
	</style>
	<script type="text/javascript">
		$(function () {
			DropDownUtils.initDropDown("NOTE");
		});
		//判断上传的文件是不是图片
		function CheckFileType(obj) {
			var file_name = obj.value;
			var file_ext = file_name.substring(file_name.lastIndexOf(".") + 1).toLowerCase();
			//获取文件名
			var pname = file_name.substring(file_name.lastIndexOf("\\") + 1).toLowerCase();
			pname = pname.substring(0, pname.lastIndexOf("."))
			//判断是否符合允许上传的三种图片类型
			if (file_ext != "jpg" && file_ext != "gif" && file_ext != "png") {
				easyAlert.timeShow({
					"content": "只允许上传.jpg、png和.gif类型图片文件！",
					"duration": 2,
					"type": "danger"
				});
				return false;
			}
			//把上传按钮获得的图片地址 赋给 文本框
			//$('#textfield').val(obj.value);
			$('#PName').val(pname);

			return true;
		}
		function UploadChk() {
			//是否已经选择了上传图片
			if ($('#Main_photoUpload').val().length == 0) {
				easyAlert.timeShow({
					"content": "请选择图片后再上传",
					"duration": 2,
					"type": "danger"
				});
				return false;
			}

			if ($('#NOTE').val().length == 0) {
				easyAlert.timeShow({
				    "content": "请选择相应的附件上传类型",
					"duration": 2,
					"type": "danger"
				});
				return false;
			}

			return true;
		}
		function modiDataExcel(tabCtrId) {
			easyAlert.timeShow({
				"content": "图片上传成功！",
				"duration": 2,
				"type": "success"
			});
			setTimeout(function () { parent.$("#uploadModal").modal("hide"); parent.fileList.reload(); }, 2000);
		}
		function modiFailExcel(val) {
			easyAlert.timeShow({
				"content": val,
				"duration": 2,
				"type": "danger"
			});
		}
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
	<form method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" runat="server">
		
			<div class="form-group">
				<label class="col-xs-3 control-label">图片地址<span style="color: Red;">*</span></label>
				<div class="col-xs-9">
					<asp:FileUpload ID="photoUpload" runat="server" onchange="CheckFileType(this);" CssClass="btn" />
				</div>
			</div>
			<div class="form-group">
				<label class="col-xs-3 control-label">图片名称<span style="color: Red;">*</span></label>
				<div class="col-xs-9">
					<input name="PName" id="PName" type="text" class="form-control" placeholder="图片名称"/>
				</div>
			</div>
			<div class="form-group">
                <label class="col-xs-3 control-label">附件上传类型<span style="color: Red;">*</span></label>
                <div class="col-xs-9">
					<select name="NOTE" id="NOTE" ddl_name="ddl_material_notes" class="form-control" show_type='t' d_value=''></select>
                </div>
            </div>
			<div class="form-group">
                <div class="col-xs-9 col-xs-offset-3">
					<asp:Button ID="UploadBtn" runat="server" Text="上传" OnClientClick="return UploadChk();" OnClick="UploadBtn_Click" />
                </div>
            </div>
		
	</form>
</asp:Content>
