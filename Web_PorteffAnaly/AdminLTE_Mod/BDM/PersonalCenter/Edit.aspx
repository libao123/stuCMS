<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Edit.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter.Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .error
        {
            color: red;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            $("fieldset").find("input,select").each(function () {
                if ($(this).attr("id") != "ID_CONFIRM" && $(this).attr("id") != "BCODE_CONFIRM")
                    ValidateUtils.setRequired("#form_edit", $(this).attr("id"), true, $(this).parent().parent().find("label").text().replace("*", "") + "必须填");
            });
            $("select").each(function () {
                if ($(this).attr("ddl_name")) {
                    DropDownUtils.initDropDown($(this).attr("id"));
                }
            });
            //身份证只允许录入数字与字母
            LimitUtils.onlyNumAlpha("IDCARDNO");
            LimitUtils.onlyNumAlpha("ID_CONFIRM");
            //银行卡只允许录入数字
            LimitUtils.onlyNum("BANKCODE");
            LimitUtils.onlyNum("BCODE_CONFIRM");
            LimitUtils.onlyNum("QQNUM");
            LimitUtils.onlyNum("MOBILENUM");

            $("#btnSave").click(function () {
                if ($("#form_edit").valid() && CheckInput()) {
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
            $("#btnSubmit").click(function () {
                if ($("#form_edit").valid() && CheckInput()) {
                    $.post("?optype=submit&t=" + Math.random(), $("#form_edit").serialize(), function (msg) {
                        if (msg.length != 0) {
                            easyAlert.timeShow({
                                "content": msg,
                                "duration": 2,
                                "type": "danger"
                            });
                        }
                        else {
                            easyAlert.timeShow({
                                "content": "提交成功！",
                                "duration": 2,
                                "type": "success"
                            });
                            $('#btnSave').hide();
                            $('#btnSubmit').hide();
                        }
                    })
                }
            });
            var CheckInput = function () {
                var reg = new RegExp("^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$"); //正则表达式
                var obj = document.getElementById("EMAIL"); //要验证的对象
                if (!reg.test(obj.value)) { //正则验证不通过，格式不对
                    easyAlert.timeShow({
                        "content": "邮箱格式不规范，请重新录入！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return false;
                }
                if ($('#IDCARDNO').val() != '<%=strIDNO %>' && $("#IDCARDNO").val() != $("#ID_CONFIRM").val()) {
                    easyAlert.timeShow({
                        "content": "两次填写的身份证号不一致",
                        "duration": 2,
                        "type": "danger"
                    });
                    return false;
                }
                if ($('#BANKCODE').val() != '<%=strBankCode %>' && $("#BANKCODE").val() != $("#BCODE_CONFIRM").val()) {
                    easyAlert.timeShow({
                        "content": "两次填写的银行卡号不一致",
                        "duration": 2,
                        "type": "danger"
                    });
                    return false;
                }
                //ZZ 20171024 修改：班老师说改成非必填
                //                if ($('#NOTES').val() == '') {
                //                    easyAlert.timeShow({
                //                        "content": "请填写备注",
                //                        "duration": 2,
                //                        "type": "danger"
                //                    });
                //                    return false;
                //                }
                return true;
            }
            SelectUtils.XY_ZY_Grade_ClassCodeChange("COLLEGE", "MAJOR", "EDULENTH", "CLASS", $("#COLLEGE").val(), $("#MAJOR").val(), $("#EDULENTH").val(), $("#CLASS").val());
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });
            SetPageBtn();
            //---------单条审批  开始------------------
            var approve = approveComPage.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "approveModal"//弹出层的id，不写则默认verifyModal，必填
                },
                control: {
                    "content": "#form_edit", //必填
                    "btnId": "#btnAudit", //触发弹出层的按钮的id，必填
                    "beforeShow": function (btn, form) {//返回btn信息和form信息
                        if ('<%=modi.SEQ_NO %>') {
                            //判断是否有审批权限
                            var url = "/AdminLTE_Mod/CHK/Approve.aspx?optype=chk"
                                + "&doc_type=<%=modi.DOC_TYPE %>&seq_no=<%=modi.SEQ_NO %>&decltype=D";
                            var result = AjaxUtils.getResponseText(url);
                            if (result.length > 0) {
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return false;
                            }
                            //默认审核信息内容为：同意
                            $("#approvePass").iCheck("check"); //默认选中
                            $("#approveMsg").val("同意");
                            return true;
                        }

                        return false;
                    },
                    "afterShow": function (btn, form) {//返回btn信息和form信息
                        return true;
                    },
                    "beforeSubmit": function (btn, form) {//返回btn信息和form信息
                        return true;
                    },
                    validCallback: function (form) {//验证通过之后的操作
                        //提交
                        var approveurl = OptimizeUtils.FormatUrl("/AdminLTE_Mod/CHK/Approve.aspx?optype=submit_approve"
                        + "&doc_type=<%=modi.DOC_TYPE %>&seq_no=<%=modi.SEQ_NO %>&decltype=D&msg_accpter=<%=modi.NUMBER %>");
                        $.post(approveurl, $("#form_approve").serialize(), function (msg) {
                            if (msg.length > 0) {
                                easyAlert.timeShow({
                                    "content": msg,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }
                            else {
                                //保存成功：关闭界面，刷新列表
                                $("#approveModal").modal("hide");
                                parent.$("#auditModal").modal("hide");
                                parent.tablePackage.reload();
                                easyAlert.timeShow({
                                    "content": "审核成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                            }
                        });
                    }
                }
            });
            //---------单条审批  结束------------------
            loadModalPageDataInit();
        });
        function SetPageBtn() {
            if ('<%=Request.QueryString["optype"]%>' != 'modi' || '<%=strIsCanModi%>' != 'true') {
                $('#btnSave').hide();
                $('#btnSubmit').hide();
            }
            //只要是不满足审批条件的，都隐藏审批按钮
            if ('<%=m_strIsShowAuditBtn %>' == 'false') {
                $("#btnAudit").hide();
            }

            if ('<%=strIsCanModi%>' == 'true' && '<%=Request.QueryString["optype"] %>' == 'modi') {
                //行政区三级联动
                SelectUtils.RegionCodeChange('N_PROVINCE', 'N_CITY', 'N_COUNTY', "<%=strN_Province %>", "<%=strN_City %>", "<%=strN_County %>");
                SelectUtils.RegionCodeChange('S_PROVINCE', 'S_CITY', 'S_COUNTY', "<%=strS_Province %>", "<%=strS_City %>", "<%=strS_County %>");
                SelectUtils.RegionCodeChange('ADD_PROVINCE', 'ADD_CITY', 'ADD_COUNTY', "<%=strADD_Province %>", "<%=strADD_City %>", "<%=strADD_County %>");
            }

            if ('<%=Request.QueryString["optype"]%>' == 'modi' && '<%=strIsCanModi%>' != 'true') {
                easyAlert.timeShow({
                    "content": "已提交审核，不允许修改",
                    "duration": 2,
                    "type": "danger"
                });
            }
        }
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
            //设置审批结果选中改变事件
            $("input[type='radio'][name='approveType']").on('ifChanged', function (event) {
                ApproveTypeChange();
            });
        }

        //点击审核结果提供不同的效果
        function ApproveTypeChange() {
            $("input[type='radio'][name='approveType']:checked").each(function () {
                if ($(this) != null) {
                    var value = $(this).attr("value");
                    if (value == 'P') {//通过
                        $("#approveMsg").val("同意");
                    }
                    else if (value == 'N') {//不通过
                        $("#approveMsg").val("");
                    }
                    else {//默认
                        $("#approveMsg").val("同意");
                    }
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div class="content-wrapper">
        <section class="content-header">
		<h1>信息维护</h1>
	    <ol class="breadcrumb">
	      	<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
			<li>个人中心</li>
	      	<li class="active">信息维护</li>
	    </ol>
  	</section>
        <div class="content" style="overflow: hidden;">
            <form class="form-horizontal col-sm-12 box box-default" id="form_edit">
            <div id="buttonId" class="box-header">
                <div class="box-tools">
                    <div class="input-group input-group-sm">
                        <div class="input-group-btn" style="display: inline-block">
                            <button type="button" style="margin-right: 10px;" class="btn btn-primary btn-xs"
                                id="btnSave">
                                保存</button>
                            <button type="button" style="margin-right: 10px;" class="btn btn-primary btn-xs"
                                id="btnSubmit">
                                提交</button>
                            <button type="button" style="margin-right: 10px;" class="btn btn-primary btn-xs"
                                id="btnAudit">
                                审批</button>
                        </div>
                    </div>
                </div>
            </div>
            <fieldset>
                <legend>基本信息</legend>
                <div class="form-group col-sm-6">
                    <label for="NUMBER" class="col-sm-2 control-label">
                        学号<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="NUMBER" name="NUMBER" value="<%=bhead ? head.NUMBER : modi.NUMBER %>"
                            placeholder="学号">
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label for="NAME" class="col-sm-2 control-label">
                        姓名<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="NAME" name="NAME" value="<%=bhead ? head.NAME : modi.NAME %>"
                            placeholder="姓名">
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        性别<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <select class="form-control" name="SEX" id="SEX" d_value='<%=bhead ? head.SEX : modi.SEX %>'
                            ddl_name='ddl_xb' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        出生日期<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control datep" id="GARDE" name="GARDE" value="<%=bhead ? head.GARDE : modi.GARDE %>"
                            placeholder="出生日期">
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        年级<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <select class="form-control" name="EDULENTH" id="EDULENTH" d_value='<%=bhead ? head.EDULENTH : modi.EDULENTH %>'
                            ddl_name='ddl_grade' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        班级<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <select class="form-control" name="CLASS" id="CLASS" d_value='<%=bhead ? head.CLASS : modi.CLASS %>'
                            ddl_name='ddl_class' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        学院<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <select class="form-control" name="COLLEGE" id="COLLEGE" d_value='<%=bhead ? head.COLLEGE : modi.COLLEGE %>'
                            ddl_name='ddl_department' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        政治面貌<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <select class="form-control" name="POLISTATUS" id="POLISTATUS" d_value='<%=bhead ? head.POLISTATUS : modi.POLISTATUS %>'
                            ddl_name='ddl_zzmm' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        专业<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <select class="form-control" name="MAJOR" id="MAJOR" d_value='<%=bhead ? head.MAJOR : modi.MAJOR %>'
                            ddl_name='ddl_zy' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        民族<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <select class="form-control" name="NATION" id="NATION" d_value='<%=bhead ? head.NATION : modi.NATION %>'
                            ddl_name='ddl_mz' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        学籍<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <select class="form-control" name="REGISTER" id="REGISTER" d_value='<%=bhead ? head.REGISTER : modi.REGISTER %>'
                            ddl_name='ddl_xjzt' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        入学时间<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control datep" id="ENTERTIME" name="ENTERTIME" value="<%=bhead ? head.ENTERTIME : modi.ENTERTIME %>"
                            placeholder="入学时间">
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        身份证号码<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="IDCARDNO" name="IDCARDNO" value="<%=bhead ? head.IDCARDNO : modi.IDCARDNO %>"
                            onpaste="return false" oncontextmenu="return false" oncopy="return false" oncut="return false"
                            placeholder="身份证号码" maxlength="18">
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        身份证号码确认</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="ID_CONFIRM" name="ID_CONFIRM" value=""
                            onpaste="return false" oncontextmenu="return false" oncopy="return false" oncut="return false"
                            placeholder="身份证号码确认" maxlength="18">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-1 control-label">
                        籍贯<span style="color: Red;">*</span></label>
                    <%if (Request.QueryString["optype"].Equals("modi") && strIsCanModi != "false")
                      { %>
                    <div class="col-sm-3">
                        <select class="form-control" name="N_PROVINCE" id="N_PROVINCE" d_value='<%=strN_Province %>'
                            ddl_name='ddl_province' show_type='t'>
                        </select>
                    </div>
                    <div class="col-sm-3">
                        <select class="form-control" name="N_CITY" id="N_CITY" d_value='<%=strN_City %>'
                            ddl_name='' show_type='t'>
                        </select>
                    </div>
                    <div class="col-sm-3">
                        <select class="form-control" name="N_COUNTY" id="N_COUNTY" d_value='<%=strN_County %>'
                            ddl_name='' show_type='t'>
                        </select>
                    </div>
                    <%}
                      else
                      { %>
                    <div class="col-sm-11">
                        <input type="text" class="form-control" id="N_ADDRESS" name="N_ADDRESS" value="<%=strN_Address %>">
                    </div>
                    <%} %>
                </div>
                <div class="form-group">
                    <label class="col-sm-1 control-label">
                        生源地（高考时户籍所在地）<span style="color: Red;">*</span></label>
                    <%if (Request.QueryString["optype"].Equals("modi") && strIsCanModi != "false")
                      { %>
                    <div class="col-sm-3">
                        <select class="form-control" name="S_PROVINCE" id="S_PROVINCE" d_value='<%=strS_Province %>'
                            ddl_name='ddl_province' show_type='t'>
                        </select>
                    </div>
                    <div class="col-sm-3">
                        <select class="form-control" name="S_CITY" id="S_CITY" d_value='<%=strS_City %>'
                            ddl_name='' show_type='t'>
                        </select>
                    </div>
                    <div class="col-sm-3">
                        <select class="form-control" name="S_COUNTY" id="S_COUNTY" d_value='<%=strS_County %>'
                            ddl_name='' show_type='t'>
                        </select>
                    </div>
                    <%}
                      else
                      { %>
                    <div class="col-sm-11">
                        <input type="text" class="form-control" id="S_ADDRESS" name="S_ADDRESS" value="<%=strS_Address %>">
                    </div>
                    <%} %>
                </div>
            </fieldset>
            <fieldset>
                <legend>联系方式</legend>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        联系电话<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="MOBILENUM" name="MOBILENUM" value="<%=bhead ? head.MOBILENUM : modi.MOBILENUM %>"
                            placeholder="联系电话">
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        电子邮箱<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="EMAIL" name="EMAIL" value="<%=bhead ? head.EMAIL : modi.EMAIL %>"
                            placeholder="电子邮箱">
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        QQ号码<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="QQNUM" name="QQNUM" value="<%=bhead ? head.QQNUM : modi.QQNUM %>"
                            placeholder="QQ号码">
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        家庭电话<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="HOMENUM" name="HOMENUM" value="<%=bhead ? head.HOMENUM : modi.HOMENUM %>"
                            placeholder="家庭电话">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-1 control-label">
                        家庭地址<span style="color: Red;">*</span></label>
                    <%if (Request.QueryString["optype"].Equals("modi") && strIsCanModi != "false")
                      { %>
                    <div class="col-sm-2">
                        <select class="form-control" name="ADD_PROVINCE" id="ADD_PROVINCE" d_value='<%=strADD_Province %>'
                            ddl_name='ddl_province' show_type='t'>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" name="ADD_CITY" id="ADD_CITY" d_value='<%=strADD_City %>'
                            ddl_name='' show_type='t'>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" name="ADD_COUNTY" id="ADD_COUNTY" d_value='<%=strADD_County %>'
                            ddl_name='' show_type='t'>
                        </select>
                    </div>
                    <div class="col-sm-4">
                        <input type="text" class="form-control" id="ADD_STREET" name="ADD_STREET" value="<%=strADD_Street %>"
                            placeholder="家庭地址">
                    </div>
                    <%}
                      else
                      { %>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="ADDRESS" name="ADDRESS" value="<%=strAddress %>">
                    </div>
                    <%} %>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-2 control-label">
                        家庭邮编<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="POSTCODE" name="POSTCODE" value="<%=bhead ? head.POSTCODE : modi.POSTCODE %>"
                            placeholder="家庭邮编" maxlength="6">
                    </div>
                </div>
            </fieldset>
            <fieldset>
                <legend>其他信息</legend>
                <div class="form-group">
                    <label class="col-sm-1 control-label">
                        银行名称<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="BANKNAME" name="BANKNAME" value="<%=strBankName %>"
                            placeholder="银行名称">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-1 control-label">
                        银行卡号<span style="color: Red;">*</span></label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="BANKCODE" name="BANKCODE" value="<%=strBankCode%>"
                            onpaste="return false" oncontextmenu="return false" oncopy="return false" oncut="return false"
                            placeholder="银行卡号" maxlength="25">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-1 control-label">
                        银行卡号确认</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="BCODE_CONFIRM" name="BCODE_CONFIRM" value=""
                            onpaste="return false" oncontextmenu="return false" oncopy="return false" oncut="return false"
                            placeholder="银行卡号确认" maxlength="25">
                    </div>
                </div>
            </fieldset>
            <fieldset>
                <legend>备注</legend>
                <div class="form-group">
                    <label class="col-sm-1 control-label">
                        备注</label>
                    <div class="col-sm-10">
                        <textarea name="NOTES" id="NOTES" rows="3" maxlength="500" class="form-control" placeholder="如有变更请填写变更的内容及原因，如没有变更请填写“无”"><%=modi.NOTES %></textarea>
                    </div>
                </div>
            </fieldset>
            <input type="hidden" id="hidoid" name="hidoid" runat="server" />
            <input type="hidden" id="hidbid" name="hidbid" runat="server" />
            </form>
        </div>
    </div>
</asp:Content>