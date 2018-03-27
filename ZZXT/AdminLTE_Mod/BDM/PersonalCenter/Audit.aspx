<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Audit.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter.Audit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .error
        {
            color: red;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            SetPageBtn();
            $("fieldset").find("input").each(function () {
                var id = $(this).attr("id");
                var id1 = id + '1';
                if (id.indexOf('1') < 0 && $('#' + id).val() != $('#' + id1).val()) {
                    $(this).addClass("error");
                }
            });
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
            //只要是不满足审批条件的，都隐藏审批按钮
            if ('<%=m_strIsShowAuditBtn %>' == 'false') {
                $("#btnAudit").hide();
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
    <div class="row">
        <form class="form-horizontal col-sm-12" id="form_edit">
        <div id="buttonId" class="box-header">
            <div class="box-tools">
                <div class="input-group input-group-sm">
                    <div class="input-group-btn" style="display: inline-block">
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
                <label class="col-sm-2 control-label">
                </label>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改后</label>
                </div>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改前</label>
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                </label>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改后</label>
                </div>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改前</label>
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label for="NUMBER" class="col-sm-2 control-label">
                    学号</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="NUMBER" name="NUMBER" value="<%=modi.NUMBER %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="NUMBER1" name="NUMBER1" value="<%=head.NUMBER %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label for="NAME" class="col-sm-2 control-label">
                    姓名</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="NAME" name="NAME" value="<%=modi.NAME %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="NAME1" name="NAME1" value="<%=head.NAME %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    性别</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="SEX" name="SEX" value="<%=cod.GetDDLTextByValue("ddl_xb", modi.SEX) %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="SEX1" name="SEX1" value="<%=cod.GetDDLTextByValue("ddl_xb", head.SEX) %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    出生日期</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control datep" id="GARDE" name="GARDE" value="<%=modi.GARDE %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control datep" id="GARDE1" name="GARDE1" value="<%=head.GARDE %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    年级</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="EDULENTH" name="EDULENTH" value="<%=cod.GetDDLTextByValue("ddl_grade", modi.EDULENTH) %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="EDULENTH1" name="EDULENTH1" value="<%=cod.GetDDLTextByValue("ddl_grade", head.EDULENTH) %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    班级</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="CLASS" name="CLASS" value="<%=cod.GetDDLTextByValue("ddl_class", modi.CLASS) %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="CLASS1" name="CLASS1" value="<%=cod.GetDDLTextByValue("ddl_class", head.CLASS) %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    学院</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="COLLEGE" name="COLLEGE" value="<%=cod.GetDDLTextByValue("ddl_department", modi.COLLEGE) %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="COLLEGE1" name="COLLEGE1" value="<%=cod.GetDDLTextByValue("ddl_department", head.COLLEGE) %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    政治面貌</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="POLISTATUS" name="POLISTATUS" value="<%=cod.GetDDLTextByValue("ddl_zzmm", modi.POLISTATUS) %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="POLISTATUS1" name="POLISTATUS1" value="<%=cod.GetDDLTextByValue("ddl_zzmm", head.POLISTATUS) %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    专业</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="MAJOR" name="MAJOR" value="<%=cod.GetDDLTextByValue("ddl_zy", modi.MAJOR) %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="MAJOR1" name="MAJOR1" value="<%=cod.GetDDLTextByValue("ddl_zy", head.MAJOR) %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    民族</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="NATION" name="NATION" value="<%=cod.GetDDLTextByValue("ddl_mz", modi.NATION) %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="NATION1" name="NATION1" value="<%=cod.GetDDLTextByValue("ddl_mz", head.NATION) %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    学籍</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="REGISTER" name="REGISTER" value="<%=cod.GetDDLTextByValue("ddl_xjzt", modi.REGISTER) %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="REGISTER1" name="REGISTER1" value="<%=cod.GetDDLTextByValue("ddl_xjzt", head.REGISTER) %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    入学时间</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="ENTERTIME" name="ENTERTIME" value="<%=modi.ENTERTIME %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="ENTERTIME1" name="ENTERTIME1" value="<%=head.ENTERTIME %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    身份证号码</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="IDCARDNO" name="IDCARDNO" value="<%=modi.IDCARDNO %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="IDCARDNO1" name="IDCARDNO1" value="<%=head.IDCARDNO %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    籍贯</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="NATIVEPLACE" name="NATIVEPLACE" value="<%=strN_Address %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="NATIVEPLACE1" name="NATIVEPLACE1" disabled="disabled"
                        value="<%=HQ.InterfaceService.ComHandleClass.getInstance().ConvertAddress(head.NATIVEPLACE) %>">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    生源地（高考时户籍所在地）</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="STUPLACE" name="STUPLACE" value="<%=strS_Address %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="STUPLACE1" name="STUPLACE1" disabled="disabled"
                        value="<%=HQ.InterfaceService.ComHandleClass.getInstance().ConvertAddress(head.STUPLACE) %>">
                </div>
            </div>
        </fieldset>
        <fieldset>
            <legend>联系方式</legend>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                </label>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改后</label>
                </div>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改前</label>
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                </label>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改后</label>
                </div>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改前</label>
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    联系电话</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="MOBILENUM" name="MOBILENUM" value="<%=modi.MOBILENUM %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="MOBILENUM1" name="MOBILENUM1" value="<%=head.MOBILENUM %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    电子邮箱</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="EMAIL" name="EMAIL" value="<%=modi.EMAIL %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="EMAIL1" name="EMAIL1" value="<%=head.EMAIL %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    QQ号码</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="QQNUM" name="QQNUM" value="<%=modi.QQNUM %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="QQNUM1" name="QQNUM1" value="<%=head.QQNUM %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    家庭电话</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="HOMENUM" name="HOMENUM" value="<%=modi.HOMENUM %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="HOMENUM1" name="HOMENUM1" value="<%=head.HOMENUM %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    家庭地址</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="ADDRESS" name="ADDRESS" value="<%=strAddress %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="ADDRESS1" name="ADDRESS1" disabled="disabled"
                        value="<%=HQ.InterfaceService.ComHandleClass.getInstance().ConvertAddress(head.ADDRESS) %>">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    家庭邮编</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="POSTCODE" name="POSTCODE" value="<%=modi.POSTCODE %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="POSTCODE1" name="POSTCODE1" value="<%=head.POSTCODE %>"
                        disabled="disabled">
                </div>
            </div>
        </fieldset>
        <fieldset>
            <legend>其他信息</legend>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                </label>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改后</label>
                </div>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改前</label>
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                </label>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改后</label>
                </div>
                <div class="col-sm-5" style="text-align: center;">
                    <label>
                        修改前</label>
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    银行名称</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="BANKNAME" name="BANKNAME" value="<%=modi.BANKNAME %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="BANKNAME1" name="BANKNAME1" value="<%=bank.BANKNAME %>"
                        disabled="disabled">
                </div>
            </div>
            <div class="form-group col-sm-6">
                <label class="col-sm-2 control-label">
                    银行卡号</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="BANKCODE" name="BANKCODE" value="<%=modi.BANKCODE %>"
                        disabled="disabled">
                </div>
                <div class="col-sm-5">
                    <input type="text" class="form-control" id="BANKCODE1" name="BANKCODE1" value="<%=bank.BANKCODE %>"
                        disabled="disabled">
                </div>
            </div>
        </fieldset>
        <fieldset>
            <legend>备注</legend>
            <div class="form-group">
                <label class="col-sm-1 control-label">
                    备注</label>
                <div class="col-sm-10">
                    <textarea name="NOTES" id="NOTES" rows="3" maxlength="500" class="form-control" disabled="disabled"><%=modi.NOTES %></textarea>
                </div>
            </div>
        </fieldset>
        <input type="hidden" id="hidoid" name="hidoid" runat="server" />
        <input type="hidden" id="hidbid" name="hidbid" runat="server" />
        </form>
    </div>
</asp:Content>