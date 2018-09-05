<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="CheckFileUpload.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectCheck.CheckFileUpload" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        //初始化
        $(function () {
            var apply_type = '<%=Request.QueryString["apply_type"] %>';
            var seq_no = '<%=Request.QueryString["seq_no"] %>';
            DropDownUtils.initDropDown("APPLY_TYPE_FILE");
            //初始化赋值
            DropDownUtils.setDropDownValue("APPLY_TYPE_FILE", apply_type);
            $("#APPLY_TYPE_FILE").attr("disabled", true);
            $("#<%=hidFile_FILE_TYPE.ClientID %>").val(apply_type);
            $("#<%=hidRelationSeqNo_File.ClientID %>").val(seq_no);

            //设置界面值（清空界面值）
            $("#FILE_NAME").val("");
            //隐藏域赋值
            $("#<%=hidFile_FILE_NAME.ClientID %>").val("");
        });

        //判断是否可以上传
        function ChkIsUpload() {
            //校验必填项
            var FILE_NAME = $('#FILE_NAME').val();
            if (FILE_NAME.length == 0) {
                easyAlert.timeShow({
                    "content": "请选择附件！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            //隐藏域赋值
            $("#<%=hidFile_FILE_NAME.ClientID %>").val(FILE_NAME);
            return true;
        }

        //判断上传的文件是不是文件
        function CheckFileType(obj, filename_id) {
            //当不符合上传文件类型时，清空上传文件路径名称
            if (obj.value.length == 0) {
                $('#' + filename_id).val('');
                return false;
            }

            var file_name = obj.value;
            var file_ext = file_name.substring(file_name.lastIndexOf(".") + 1).toLowerCase();
            //获取文件名
            var fname = file_name.substring(file_name.lastIndexOf("\\") + 1).toLowerCase();
            fname = fname.substring(0, fname.lastIndexOf("."))
            //判断是否符合允许上传的文件类型
            if (file_ext != "gif" && file_ext != "jpg" && file_ext != "png") {
                easyAlert.timeShow({
                    "content": "只允许上传.gif、.jpg、.png类型文件！",
                    "duration": 2,
                    "type": "danger"
                });
                obj.value = "";
                return false;
            }
            //把上传按钮获得的名称 赋给 文本框
            $('#' + filename_id).val(fname);
            return true;
        }

        //导入之后，刷新列表
        function ListRefresh() {
            //导入完成之后，关闭父页面弹出的导入编辑层
            parent.$("#tableModal_File").modal("hide");
            //导入时，调用父界面的刷新方法，所以父界面ImportReload这个方法一定要定义
            parent.UploadReload();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="form_file" name="form_file" class="modal-content form-horizontal" runat="server">
    <input type="hidden" id="hidOid_File" name="hidOid_File" value="" runat="server" />
    <input type="hidden" id="hidRelationSeqNo_File" name="hidRelationSeqNo_File" value=""
        runat="server" />
    <input type="hidden" id="hidFile_FILE_NAME" name="hidFile_FILE_NAME" value="" runat="server" />
    <input type="hidden" id="hidFile_FILE_TYPE" name="hidFile_FILE_TYPE" value="" runat="server" />
    <div class="modal-body">
        <div class="form-group">
            <label class="col-sm-2 control-label">
                参保人员类别</label>
            <div class="col-sm-10">
                <select class="form-control" name="APPLY_TYPE_FILE" id="APPLY_TYPE_FILE" d_value=''
                    ddl_name='ddl_apply_insur_type' show_type='t'>
                </select>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">
                选择图片</label>
            <div class="col-sm-10">
                <input id="fileUpload" name="fileUpload" type="file" multiple="multiple" runat="server"
                    onchange="CheckFileType (this,'FILE_NAME');" />
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">
                图片名称</label>
            <div class="col-sm-10">
                <input name="FILE_NAME" id="FILE_NAME" type="text" class="form-control" placeholder="图片名称"
                    maxlength="25" />
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <asp:LinkButton ID="btnSaveFile" runat="server" class="btn btn-primary btn-save"
            OnClientClick="return ChkIsUpload();" OnClick="fileUpload_Click">保存</asp:LinkButton>
    </div>
    </form>
</asp:Content>
