<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="Approve.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.DifficultyApply.Approve" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var m_strSeq_No = '<%=Request.QueryString["seq_no"] %>'; //审批用到的单据编号
        var role = '<%=Request.QueryString["role"]%>';
        var level = '<%=Request.QueryString["level"]%>';
        //页面加载
		window.onload = function () {
			DropDownUtils.initDropDown("LEVEL_CODE");
			DropDownUtils.initDropDown("LEVEL_CODE2");
			DropDownUtils.initDropDown("LEVEL_CODE3");

            $("#<%=hidstep.ClientID%>").val('1');

            $('#LEVEL_CODE').on("change",function(){
                var result = AjaxUtils.getResponseText('Approve.aspx?optype=getopinion&level=' + $('#LEVEL_CODE').val());
                document.getElementById('OPINION').value = result;
            });
			$('#LEVEL_CODE2').on("change", function () {
                var result = AjaxUtils.getResponseText('Approve.aspx?optype=getopinion&level=' + $('#LEVEL_CODE2').val());
                document.getElementById('OPINION').value = result;
            });
			$('#LEVEL_CODE3').on("change", function () {
                var result = AjaxUtils.getResponseText('Approve.aspx?optype=getopinion&level=' + $('#LEVEL_CODE3').val());
                document.getElementById('OPINION').value = result;
            });

			if ('<%=user.User_Role%>' == 'F') {
                $('#agree2').hide();
                $('#n_agree2').hide();
                $('#agree3').hide();
                $('#n_agree3').hide();
                $('#LEVEL_CODE').val(level);
            }
			else if ('<%=user.User_Role%>' == 'Y') {
                $('#step1').hide();
                $('#agree3').hide();
                $('#n_agree3').hide();
                $("#agree_2").attr("checked", "checked");
                $('#LEVEL_CODE2').val(level);
            }
			else if ('<%=user.User_Role%>' == 'X') {
			    $('#step1').hide();
			    $('#agree2').hide();
			    $('#n_agree2').hide();
			    $("#agree_3").attr("checked", "checked");
			    $('#LEVEL_CODE3').val(level);
			}
			else {
			    $('#step1').hide();
			    $('#agree2').hide();
			    $('#n_agree2').hide();
			    $('#agree3').hide();
			    $('#n_agree3').hide();
			    $('#<%=ConfirmBtn.ClientID %>').hide();
			}
            if (level.length > 0) {
                var result = AjaxUtils.getResponseText('Approve.aspx?optype=getopinion&level=' + level);
                document.getElementById('OPINION').value = result;
			}
			parent.$("#auditFrame").height($(document).height());
			$(":radio").iCheck({
				checkboxClass: 'icheckbox_flat-green',
				radioClass: 'iradio_flat-green'
			});
        }


        //确认
        function ConfirmChk() {
			if (m_strSeq_No.length == 0 && '<%=Request.QueryString["optype"]%>' != 'multi') {
				easyAlert.timeShow({
					"content": "单据编号为空，无法进行审批！",
					"duration": 2,
					"type": "danger"
				});
                return false;
			}
			if ($('#OPINION').val() == "") {
				easyAlert.timeShow({
					"content": "请填写审核意见！",
					"duration": 2,
					"type": "danger"
				});
				return false;
			}

            if ($('#agree_2').get(0).checked) {
                $('#<%=hidstep.ClientID%>').val("2");
                $('#<%=hidresult.ClientID%>').val("Y");
            }
			if ($('#n_agree_2').get(0).checked) {
                $('#<%=hidstep.ClientID%>').val("2");
				$('#<%=hidresult.ClientID%>').val("N");
				if ($('#LEVEL_CODE2').val() == "") {
					easyAlert.timeShow({
						"content": "请选择意见！",
						"duration": 2,
						"type": "danger"
					});
					return false;
				}
                $('#<%=hidlevel.ClientID%>').val($('#LEVEL_CODE2').val());
            }
			if ($('#n_agree_3').get(0).checked) {
                $('#<%=hidstep.ClientID%>').val("3");
				$('#<%=hidresult.ClientID%>').val("N");
				if ($('#LEVEL_CODE3').val() == "") {
					easyAlert.timeShow({
						"content": "请选择意见！",
						"duration": 2,
						"type": "danger"
					});
					return false;
				}
                $('#<%=hidlevel.ClientID%>').val($('#LEVEL_CODE3').val());
            }
			if ($('#agree_3').get(0).checked) {
                $('#<%=hidstep.ClientID%>').val("3");
                $('#<%=hidresult.ClientID%>').val("Y");
            }

            return true;
        }

        //审批成功调用方法
        function ApplySuccessAndClose(divid, parentdiv, idGrid, content) {
			if (content) {
				easyAlert.timeShow({
					"content": content,
					"duration": 2,
					"type": "danger"
				});
				setTimeout(function () {
					parent.$("#tableModal").modal('hide');
					parent.$("#auditModal").modal('hide');
					parent.mainList.reload();
				}, 2000);
            }
            else {
				easyAlert.timeShow({
					"content": "审批成功！",
					"duration": 2,
					"type": "success"
				});
				setTimeout(function () {
					parent.$("#tableModal").modal('hide');
					parent.$("#auditModal").modal('hide');
					parent.mainList.reload();
				}, 2000);
            }
        }

        //审批失败调用方法
		function ApplyErrorAndClose(divid, content) {
			var msg = content || "审批失败！";
			easyAlert.timeShow({
				"content": content,
				"duration": 2,
				"type": "danger"
			});
		}
		//表单提交时，如果响应缓慢所弹出的界面消息
		function OnFormCommit() {
			$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(window).height() }).appendTo("body");
			$("<div class=\"datagrid-mask-msg\"></div>").html("系统正在处理，请稍候。。。").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });
		}
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
  <form id="f1" runat="server" onsubmit='OnFormCommit();' class="modal-content form-horizontal">
      <div class="toolbar">
          <asp:LinkButton ID="ConfirmBtn" runat="server" class="btn btn-success" OnClientClick="return ConfirmChk();" OnClick="Confirm_Click">提交</asp:LinkButton>
      </div>
      <div id="Div1" class="box box-solid" style="margin: 0; box-shadow: none;">
        <div class="box-body">

          <div class="form-group" id="step1">
            <label class="col-sm-3 control-label">推荐档次<span style="color: Red;">*</span></label>
            <div class="col-sm-9">
              <select id="LEVEL_CODE" name="LEVEL_CODE" class="form-control" ddl_name='ddl_dst_level' d_value='' title="推荐档次" show_type='t'></select>
            </div>
          </div>
          <div class="form-group" id="agree2">
            <div class="col-sm-12">
              <input type="radio" name="BtnApprove" id="agree_2"/><label for="agree_2" >同意评议小组意见</label>
            </div>
          </div>
          <div class="form-group" id="n_agree2">
            <div class="col-sm-3">
              <input type="radio" name="BtnApprove" id="n_agree_2" /><label for="n_agree_2">不同意评议小组意见。调整为：</label>
            </div>
            <div class="col-sm-9">
              <select id="LEVEL_CODE2" name="LEVEL_CODE2" class="form-control" ddl_name='ddl_dst_level' d_value='' show_type='t'>
              </select>
            </div>
          </div>
          <div class="form-group" id="agree3">
            <div class="col-sm-12">
              <input type="radio" name="BtnApprove" id="agree_3" /><label for="agree_3" >同意工作组和评议小组意见</label>
            </div>
          </div>
          <div class="form-group" id="n_agree3">
            <div class="col-sm-3">
              <input type="radio" name="BtnApprove" id="n_agree_3" /><label for="n_agree_3">不同意评议小组意见。调整为：</label>
            </div>
            <div class="col-sm-9">
              <select id="LEVEL_CODE3" name="LEVEL_CODE3" class="form-control" ddl_name='ddl_dst_level' d_value='' show_type='t'>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-3 control-label">审核意见<span style="color: Red;">*</span></label>
            <div class="col-sm-9">
              <textarea id="OPINION" name="OPINION" cols="4" rows="4" class="form-control"></textarea>
            </div>
          </div>

        </div>
      </div>
      <input type="hidden" id="hidresult" runat="server" />
      <input type="hidden" id="hidlevel" runat="server" />
      <input type="hidden" id="hidstep" runat="server" />
  </form>
</asp:Content>
