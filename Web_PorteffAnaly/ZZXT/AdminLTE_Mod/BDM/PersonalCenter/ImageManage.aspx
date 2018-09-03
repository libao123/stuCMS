<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="ImageManage.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter.ImageManage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            Showphoto();
        }

        function Showphoto() {
            //获取根目录
            var curWwwPath = window.document.location.href;
            var pathName = window.document.location.pathname;
            var pos = curWwwPath.indexOf(pathName);
            var root = curWwwPath.substring(0, pos);
            //显示图片
            var photosrc = document.getElementById('photo_curr');
            var uploadphoto_root = '<%=m_strUploadPhotoRoot %>';
            if (uploadphoto_root.length == 0)
                uploadphoto_root = "UploadPhoto";
            
            photosrc.src = root + '/' + uploadphoto_root + '/<%=strPhotoPath%>';
        }

        function getPath(obj) {
            if (obj) {
                if (window.navigator.userAgent.indexOf("MSIE") >= 1) {
                    obj.select();
                    return document.selection.createRange().text;
                } else if (window.navigator.userAgent.indexOf("Firefox") >= 1) {
                    if (obj.files) {
                        return obj.files.item(0).getAsDataURL();
                    }
                    return obj.value;
                }
                return obj.value;
            }
        }

        //判断上传的文件是不是图片
        function CheckFileType(obj) {
            var file_name = getPath(obj);//obj.value
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
            $('#textfield').val(obj.value);
            $('#PName').val(pname);
            //预览
            //var photosrc = document.getElementById('photo');
            //photosrc.src = file_name;

            return true;
        }

        function UploadChk() {
            //是否已经选择了上传图片
			if ($('#textfield').val().length == 0) {
				easyAlert.timeShow({
					"content": "请选择图片后再上传！",
					"duration": 2,
					"type": "danger"
				});
                return false;
            }

            return true;
		}

		function uploadSuccess() {
			easyAlert.timeShow({
				"content": "图片上传成功！",
				"duration": 2,
				"type": "success"
			});
		}
		function uploadFault(path) {
			easyAlert.timeShow({
				"content": "图片上传失败！",
				"duration": 2,
				"type": "danger"
			});
		}

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
<div class="content-wrapper">
	<section class="content-header">
		<h1>修改头像</h1>
	    <ol class="breadcrumb">
	      	<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
			<li>个人中心</li>
	      	<li class="active">修改头像</li>
	    </ol>
  	</section>
	<div class="content">
    <form id="f1" runat="server" onsubmit='' class="box box-default">
        <div style="" class="box-body">
			<label>当前头像</label><!--<legend class="comlegend">当前头像</legend>-->
            <fieldset class="comfieldset" style="width: 300px; border: 1px Solid #BFD4EC;">
                <div style="margin-top: 5px; text-align:center;">
                    <img id="photo_curr" alt="" src="" style="width:220px;height:280px;" />
                </div>
            </fieldset>
        </div>
        <div style="" class="box-body">
            <div>
                <input type="text" id="textfield" name="textfield" style="width: 200px; vertical-align: middle;" class="form-control" readonly/>
                <asp:FileUpload ID="photoUpload" runat="server"  onchange="CheckFileType(this);"
                    CssClass="btn" />
            </div>
            <div style="margin-top: 10px; margin-left:10px;">
                <asp:Button ID="UploadBtn" CssClass="btn btn-primary" runat="server" Text="上传" OnClientClick="return UploadChk();" 
                    OnClick="UploadBtn_Click" />
            </div>
        </div>
    </form>
	</div>
</div>
</asp:Content>
