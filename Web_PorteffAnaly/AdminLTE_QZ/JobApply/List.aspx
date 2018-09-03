﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true" CodeBehind="List.aspx.cs" 
    Inherits="PorteffAnaly.Web.AdminLTE_QZ.JobApply.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _form_edit;
        var mainList;
        window.onload = function () {
            adaptionHeight();

            _form_edit = PageValueControl.init("form_edit");
            LimitUtils.onlyNum("FAIL_NUM");
            LimitUtils.onlyNum("TELEPHONE");
            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();

            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-COLLEGE", "search-MAJOR", "", "search-CLASS");

            //时间控件
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });

            $("#IS_FAIL").change(function () {
                if ($(this).val() == "1") {
                    $("#FAIL_NUM").removeAttr("disabled");
                }
                else {
                    $("#FAIL_NUM").val("");
                    $("#FAIL_NUM").attr("disabled", "disabled");
                }
            });

            $("#btnSave").click(function () {
                SaveData();
            });
            $("#btnSubmit").click(function () {
                easyConfirm.locationShow({
                    "type": "warn",
                    "title": "提交",
                    "content": "确定要提交数据？",
                    "callback": SubmitData
                });
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>已申请岗位</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>上岗申请管理</li>
				<li class="active">已申请岗位</li>
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
    <!-- 编辑界面 开始-->
    <div class="modal" id="tableModal">
        <div class="modal-dialog" style="width: 65%;">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
                onsubmit="return false;">
                <input type="hidden" id="OID" name="OID" />
                <input type="hidden" id="SEQ_NO" name="SEQ_NO" />
                <input type="hidden" id="CLASS_CODE" name="CLASS_CODE" />
                <input type="hidden" id="DAY1" name="DAY1" />
                <input type="hidden" id="DAY2" name="DAY2" />
                <input type="hidden" id="DAY3" name="DAY3" />
                <input type="hidden" id="DAY4" name="DAY4" />
                <input type="hidden" id="DAY5" name="DAY5" />
                <input type="hidden" id="DAY6" name="DAY6" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">已申请岗位</h4>
                </div>
                <div class="tab-content row">
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            姓名<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="STU_NAME" id="STU_NAME" class="form-control" placeholder="姓名"
                                disabled />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            学院<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="COLLEGE" id="COLLEGE" class="form-control" ddl_name="ddl_department"
                                d_value="" show_type="t" required disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            年级<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="GRADE" id="GRADE" class="form-control" ddl_name='ddl_grade'
                                d_value='' show_type='t' required disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            性别<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="SEX" id="SEX" class="form-control" ddl_name='ddl_xb'
                                d_value='' show_type='t' required disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            专业<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="MAJOR" id="MAJOR" class="form-control" ddl_name='ddl_zy'
                                d_value='' show_type='t' required disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            寝室</label>
                        <div class="col-sm-8">
                            <input type="text" name="DORMITORY" id="DORMITORY" class="form-control" placeholder="寝室" />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            民族<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="NATION" id="NATION" class="form-control" ddl_name='ddl_mz'
                                d_value='' show_type='t' required disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            学号<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="STU_NUMBER" id="STU_NUMBER" class="form-control" placeholder="学号"
                                disabled />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            手机<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="TELEPHONE" id="TELEPHONE" class="form-control" placeholder="手机" />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            政治面貌<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="POLISTATUS" id="POLISTATUS" class="form-control" ddl_name='ddl_zzmm'
                                d_value='' show_type='t' required disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            英语水平</label>
                        <div class="col-sm-8">
                            <input type="text" name="ENGLISH_LEVEL" id="ENGLISH_LEVEL" class="form-control" placeholder="英语水平" />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            计算机水平</label>
                        <div class="col-sm-8">
                            <input type="text" name="COMPUTER_LEVEL" id="COMPUTER_LEVEL" class="form-control" placeholder="计算机水平" />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            办卡账户<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="BANK_ACCOUNT" id="BANK_ACCOUNT" class="form-control" placeholder="办卡账户" />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            卡号<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="BANK_CARD_NO" id="BANK_CARD_NO" class="form-control" placeholder="卡号" disabled />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            身份证号<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <input type="text" name="IDCARDNO" id="IDCARDNO" class="form-control" placeholder="身份证号" disabled />
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            家庭类别<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="FAMILY_TYPE" id="FAMILY_TYPE" class="form-control" ddl_name='ddl_family_type'
                                d_value='' show_type='t' required>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-8">
                        <label class="col-sm-2 control-label">
                            学习情况<span style="color: Red;">*</span></label>
                        <div class="col-sm-10">
                            <div class="col-sm-4" style="margin: 0; padding: 0;">
                                <select name="IS_FAIL" id="IS_FAIL" class="form-control" ddl_name='ddl_study'
                                    d_value='' show_type='t' required>
                                </select>
                            </div>
                            <div class="col-sm-4" style="margin: 0; padding: 0;">
                                <input type="text" name="FAIL_NUM" id="FAIL_NUM" class="form-control" placeholder="不及格科目数" />
                            </div>
                            <label class="col-sm-2 control-label" 
                                style="text-align: left; margin-left: 10px; padding-left: 0;">门次</label>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            用人单位<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="EMPLOYER" id="EMPLOYER" class="form-control" ddl_name='ddl_all_department'
                                d_value='' show_type='t' required disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            希望从事的岗位<span style="color: Red;">*</span></label>
                        <div class="col-sm-8">
                            <select name="EXPECT_JOB1" id="EXPECT_JOB1" class="form-control" ddl_name='ddl_job_name'
                                d_value='' show_type='t' required disabled>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label" style="width: 120px;">
                            特长</label>
                        <div class="col-sm-10">
                            <input type="text" name="SPECIALITY" id="SPECIALITY" class="form-control" placeholder="特长" />
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label" style="width: 120px;">
                            勤工助学经历</label>
                        <div class="col-sm-10">
                            <input type="text" name="WORK_EXPERIENCE" id="WORK_EXPERIENCE" class="form-control" placeholder="勤工助学经历" />
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label" style="width: 120px;">
                            申请理由<span style="color: Red;">*</span></label>
                        <div class="col-sm-10">
                            <input type="text" name="APPLY_REASON" id="APPLY_REASON" class="form-control" placeholder="申请理由" />
                        </div>
                    </div>
                </div>
                <div class="box-header">
                    <h3 class="box-title">
                        课余时间</h3>
                </div>
                <div class="tab-content row" id="FREE_TIME">
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label">
                            星期一</label>
                        <div class="col-sm-10">
                            <input type="checkbox" name="TIME1" id="Mon1" value="Y"/><label for="Mon1" style="margin-right: 30px;">1、2</label>
                            <input type="checkbox" name="TIME1" id="Mon2" value="Y" /><label for="Mon2" style="margin-right: 30px;">3</label>
                            <input type="checkbox" name="TIME1" id="Mon3" value="Y" /><label for="Mon3" style="margin-right: 30px;">4、5</label>
                            <input type="checkbox" name="TIME1" id="Mon4" value="Y" /><label for="Mon4" style="margin-right: 30px;" >6、7</label>
                            <input type="checkbox" name="TIME1" id="Mon5" value="Y" /><label for="Mon5" style="margin-right: 30px;">8、9</label>
                            <input type="checkbox" name="TIME1" id="Mon6" value="Y" /><label for="Mon6" style="margin-right: 30px;">10～12</label>
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label">
                            星期二</label>
                        <div class="col-sm-10">
                            <input type="checkbox" name="TIME2" id="Tues1" value="Y"/><label for="Tues1" style="margin-right: 30px;">1、2</label>
                            <input type="checkbox" name="TIME2" id="Tues2" value="Y" /><label for="Tues2" style="margin-right: 30px;">3</label>
                            <input type="checkbox" name="TIME2" id="Tues3" value="Y" /><label for="Tues3" style="margin-right: 30px;">4、5</label>
                            <input type="checkbox" name="TIME2" id="Tues4" value="Y" /><label for="Tues4" style="margin-right: 30px;" >6、7</label>
                            <input type="checkbox" name="TIME2" id="Tues5" value="Y" /><label for="Tues5" style="margin-right: 30px;">8、9</label>
                            <input type="checkbox" name="TIME2" id="Tues6" value="Y" /><label for="Tues6" style="margin-right: 30px;">10～12</label>
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label">
                            星期三</label>
                        <div class="col-sm-10">
                            <input type="checkbox" name="TIME3" id="Wed1" value="Y"/><label for="Wed1" style="margin-right: 30px;">1、2</label>
                            <input type="checkbox" name="TIME3" id="Wed2" value="Y" /><label for="Wed2" style="margin-right: 30px;">3</label>
                            <input type="checkbox" name="TIME3" id="Wed3" value="Y" /><label for="Wed3" style="margin-right: 30px;">4、5</label>
                            <input type="checkbox" name="TIME3" id="Wed4" value="Y" /><label for="Wed4" style="margin-right: 30px;" >6、7</label>
                            <input type="checkbox" name="TIME3" id="Wed5" value="Y" /><label for="Wed5" style="margin-right: 30px;">8、9</label>
                            <input type="checkbox" name="TIME3" id="Wed6" value="Y" /><label for="Wed6" style="margin-right: 30px;">10～12</label>
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label">
                            星期四</label>
                        <div class="col-sm-10">
                            <input type="checkbox" name="TIME4" id="Thur1" value="Y"/><label for="Thur1" style="margin-right: 30px;">1、2</label>
                            <input type="checkbox" name="TIME4" id="Thur2" value="Y" /><label for="Thur2" style="margin-right: 30px;">3</label>
                            <input type="checkbox" name="TIME4" id="Thur3" value="Y" /><label for="Thur3" style="margin-right: 30px;">4、5</label>
                            <input type="checkbox" name="TIME4" id="Thur4" value="Y" /><label for="Thur4" style="margin-right: 30px;" >6、7</label>
                            <input type="checkbox" name="TIME4" id="Thur5" value="Y" /><label for="Thur5" style="margin-right: 30px;">8、9</label>
                            <input type="checkbox" name="TIME4" id="Thur6" value="Y" /><label for="Thur6" style="margin-right: 30px;">10～12</label>
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label">
                            星期五</label>
                        <div class="col-sm-10">
                            <input type="checkbox" name="TIME5" id="Fri1" value="Y"/><label for="Fri1" style="margin-right: 30px;">1、2</label>
                            <input type="checkbox" name="TIME5" id="Fri2" value="Y" /><label for="Fri2" style="margin-right: 30px;">3</label>
                            <input type="checkbox" name="TIME5" id="Fri3" value="Y" /><label for="Fri3" style="margin-right: 30px;">4、5</label>
                            <input type="checkbox" name="TIME5" id="Fri4" value="Y" /><label for="Fri4" style="margin-right: 30px;" >6、7</label>
                            <input type="checkbox" name="TIME5" id="Fri5" value="Y" /><label for="Fri5" style="margin-right: 30px;">8、9</label>
                            <input type="checkbox" name="TIME5" id="Fri6" value="Y" /><label for="Fri6" style="margin-right: 30px;">10～12</label>
                        </div>
                    </div>
                    <div class="form-group col-sm-12">
                        <label class="col-sm-2 control-label">
                            星期六</label>
                        <div class="col-sm-10">
                            <input type="checkbox" name="TIME6" id="Sat1" value="Y"/><label for="Sat1" style="margin-right: 30px;">1、2</label>
                            <input type="checkbox" name="TIME6" id="Sat2" value="Y" /><label for="Sat2" style="margin-right: 30px;">3</label>
                            <input type="checkbox" name="TIME6" id="Sat3" value="Y" /><label for="Sat3" style="margin-right: 30px;">4、5</label>
                            <input type="checkbox" name="TIME6" id="Sat4" value="Y" /><label for="Sat4" style="margin-right: 30px;" >6、7</label>
                            <input type="checkbox" name="TIME6" id="Sat5" value="Y" /><label for="Sat5" style="margin-right: 30px;">8、9</label>
                            <input type="checkbox" name="TIME6" id="Sat6" value="Y" /><label for="Sat6" style="margin-right: 30px;">10～12</label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-save" id="btnSave">保存</button>
                    <button type="button" class="btn btn-primary btn-submit" id="btnSubmit">提交</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->

    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "DOC_TYPE",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "STU_NUMBER", "head": "学号", "type": "td-keep" },
				{ "data": "STU_NAME", "head": "姓名", "type": "td-keep" },
                { "data": "GRADE2", "head": "年级", "type": "td-keep" },
				{ "data": "COLLEGE2", "head": "学院", "type": "td-keep" },
				{ "data": "MAJOR2", "head": "专业", "type": "td-keep" },
				{ "data": "EMPLOYER2", "head": "用人单位", "type": "td-keep" },
				{ "data": "JOB_NAME", "head": "申请岗位", "type": "td-keep" },
				{ "data": "RET_CHANNEL", "head": "审核状态", "type": "td-keep" },
				{ "data": "EMPLOY_FLAG2", "head": "是否录用", "type": "td-keep" },
				{ "data": "DECL_TIME", "head": "申请时间", "type": "td-keep" },
				{ "data": "CHK_TIME", "head": "审核时间", "type": "td-keep" },
				{ "data": "SCH_YEAR2", "head": "学年", "type": "td-keep" },
				{ "data": "SCH_TERM2", "head": "学期", "type": "td-keep" }
            ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "List.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "已申请岗位",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        'aLengthMenu': [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(8)');
                            var data = Formatter_RetChannel(aData.RET_CHANNEL, aData.POS_CODE2);
                            tablePackage.statusSpan(_status,
                                {
                                    "type": data.type,
                                    "msg": data.msg
                                }
                            );
                        }
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
						{ "data": "GRADE", "pre": "年级", "col": 1, "type": "select", "ddl_name": "ddl_grade" },
						{ "data": "COLLEGE", "pre": "学院", "col": 2, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "MAJOR", "pre": "专业", "col": 3, "type": "select", "ddl_name": "ddl_zy" },
					    { "data": "STU_NUMBER", "pre": "学号", "col": 3, "type": "input" },
					    { "data": "STU_NAME", "pre": "姓名", "col": 4, "type": "input" }
                    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                    { type: "userDefined", id: "btn-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } },
					<%if (m_strIsShowEditBtn.Equals("true")) { %>"edit", "del",<% } %>
                    { type: "userDefined", id: "btn-down", title: "下载", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } },
                    { type: "userDefined", id: "btn-wflow", title: "流程跟踪", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } }
                ],
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 列表JS 结束-->

    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //下拉初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("SEX");
            DropDownUtils.initDropDown("NATION");
            DropDownUtils.initDropDown("POLISTATUS");
            DropDownUtils.initDropDown("GRADE");
            DropDownUtils.initDropDown("COLLEGE");
            DropDownUtils.initDropDown("MAJOR");
            DropDownUtils.initDropDown("IS_FAIL");
            DropDownUtils.initDropDown("FAMILY_TYPE");
            DropDownUtils.initDropDown("EMPLOYER");
            DropDownUtils.initDropDown("EXPECT_JOB1");

            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        }

        //必填项设置
        function loadModalPageValidate() {
            ValidateUtils.setRequired("#form_edit", "STU_NUMBER", true, "学号必填");
            ValidateUtils.setRequired("#form_edit", "STU_NAME", true, "姓名必填");
            ValidateUtils.setRequired("#form_edit", "SEX", true, "性别必填");
            ValidateUtils.setRequired("#form_edit", "NATION", true, "民族必填");
            ValidateUtils.setRequired("#form_edit", "POLISTATUS", true, "政治面貌必填");
            ValidateUtils.setRequired("#form_edit", "GRADE", true, "年级必填");
            ValidateUtils.setRequired("#form_edit", "COLLEGE", true, "学院必填");
            ValidateUtils.setRequired("#form_edit", "MAJOR", true, "专业必填");
            ValidateUtils.setRequired("#form_edit", "FAMILY_TYPE", true, "家庭类别必填");
            ValidateUtils.setRequired("#form_edit", "IS_FAIL", true, "学习情况必填");
            ValidateUtils.setRequired("#form_edit", "TELEPHONE", true, "手机必填");
            ValidateUtils.setRequired("#form_edit", "BANK_ACCOUNT", true, "办卡账户必填");
            ValidateUtils.setRequired("#form_edit", "BANK_CARD_NO", true, "卡号必填");
            ValidateUtils.setRequired("#form_edit", "IDCARDNO", true, "身份证号必填");
            ValidateUtils.setRequired("#form_edit", "EMPLOYER", true, "用人单位必填");
            ValidateUtils.setRequired("#form_edit", "EXPECT_JOB1", true, "希望从事的岗位必填");
            ValidateUtils.setRequired("#form_edit", "APPLY_REASON", true, "申请理由必填");
        }
    </script>

    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            var _content = $("#content");

            //刷新
            _content.on('click', '.btn-reload', function () {
                mainList.reload();
            });

            //查阅
            _content.on('click', '#btn-view', function () {
                var data = mainList.selectSingle();
                if (data) {
                    $("#tableModal").modal();
                    $("#tableModal input[type='checkbox']").removeAttr('checked');//清除多选框的checked属性
                    var apply_data = AjaxUtils.getResponseText('List.aspx?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                    }
                }
                hideBtn();
            });

            //修改
            _content.on('click', '.btn-edit', function () {
                showBtn();
                var data = mainList.selectSingle();
                if (data) {
                    var result = AjaxUtils.getResponseText('List.aspx?optype=chkmodi&id=' + data.OID);
                    if (result.length > 0) {
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    $("#tableModal").modal();
                    $("#tableModal input[type='checkbox']").removeAttr('checked');//清除多选框的checked属性
                    var apply_data = AjaxUtils.getResponseText('List.aspx?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        _form_edit.setFormData(apply_data_json);
                        if ($("#TELEPHONE").val().length > 0)
                            $("#TELEPHONE").attr("disabled", true);
                        if ($("#BANK_ACCOUNT").val().length > 0)
                            $("#BANK_ACCOUNT").attr("disabled", true);
                        if ($("#BANK_CARD_NO").val().length > 0)
                            $("#BANK_CARD_NO").attr("disabled", true);
                    }
                }
            });

            //删除
            _content.on('click', '.btn-del', function () {
                var data = mainList.selectSingle();
                if (data) {
                    var result = AjaxUtils.getResponseText('List.aspx?optype=chkdel&id=' + data.OID);
                    if (result.length > 0) {
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除所选的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            $.post(OptimizeUtils.FormatUrl("?optype=delete&id=" + data.OID), function (msg) {
                                if (!msg) {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": "删除成功！",
                                        "duration": 2,
                                        "type": "success"
                                    });
                                    mainList.reload();
                                }
                                else {
                                    easyAlert.timeShow({
                                        "content": msg,
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                }
                            });
                        }
                    });
                }
            });

            //下载
            _content.on('click', "#btn-down", function () {
                var data = mainList.selectSingle();
                if (data) {
                    window.open('/Word/ExportWord.aspx?optype=jobapply&id=' + data.OID + '&number=' + data.STU_NUMBER);
                }
            });

            //审核流程跟踪
            wfklog = WfkLog.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "wfklogModal"//弹出层的id，不写则默认wfklogModal，必填
                },
                control: {
                    "content": "#content", //必填
                    "btnId": "#btn-wflow", //触发弹出层的按钮的id，必填
                    "beforeShow": function (btn, form) {//返回btn信息和form信息
                        var data = mainList.selectSingle();
                        if (data) {
                            if (data.OID) {
                                return true;
                            }
                        }
                        return false;
                    },
                    "afterShow": function (btn, form) {//返回btn信息和form信息
                        var data = mainList.selectSingle();
                        _m_wfklog_list.refresh(OptimizeUtils.FormatUrl("/AdminLTE_Mod/Common/ComPage/WkfLogList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        return true;
                    },
                    "beforeSubmit": function (btn, form) {//返回btn信息和form信息
                    }
                }
            });

            var hideBtn = function () {
                $("#btnSave").hide();
                $("#btnSubmit").hide();
            }
            var showBtn = function () {
                $("#btnSave").show();
                $("#btnSubmit").show();
            }
        }

        //保存前校验
        function CheckData() {
            var is_fail = $("#IS_FAIL").val();
            var fail_num = $("#FAIL_NUM").val();
            if (is_fail == "Y" && fail_num <= 0) {
                easyAlert.timeShow({
                    "content": "请填写不及格科目数！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }

            if ($("#FREE_TIME").find("input:checked").length == 0) {
                easyAlert.timeShow({
                    "content": "请勾选课余时间！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }

            GetFreeTime();
            return true;
        }

        function GetFreeTime() {
            for (var n = 1; n <= 6; n++) {
                var str = "";
                var ids = document.getElementsByName("TIME" + n);
                for (var i = 0; i < ids.length; i++) {
                    if (ids[i].checked)
                        str += "Y";
                    else
                        str += "N";
                }
                $("#DAY" + n).val(str);
            }
        }

        //保存
        function SaveData() {
            if (!($("#form_edit").valid())) {
                return;
            }

            if (!CheckData()) return;
            
            $.post(OptimizeUtils.FormatUrl("?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length == 0) {
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                else {
                    $("#OID").val(msg);
                    //保存成功：关闭界面，刷新列表
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload();
                }
            });
        }

        //提交
        function SubmitData() {
            if (!($("#form_edit").valid())) {
                return;
            }

            if (!CheckData()) return;

            $.post(OptimizeUtils.FormatUrl("?optype=submit"), $("#form_edit").serialize(), function (msg) {
                $(".Confirm_Div").modal("hide");
                if (msg.length == 0) {
                    $("#tableModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "提交成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload();
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
        }
    </script>
</asp:Content>
