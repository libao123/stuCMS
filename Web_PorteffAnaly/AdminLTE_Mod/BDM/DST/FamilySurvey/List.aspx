﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.FamilySurvey.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .error
        {
            color: red;
        }
    </style>
    <script type="text/javascript">
        var mainList;
        var memberList;
        var fileList;
        var _form_edit;
        var chk_R = false, chk_U = false, chk_G = false, chk_O = false;
        window.onload = function () {
            adaptionHeight();
            _form_edit = PageValueControl.init("form_edit");
            loadTableList();
            memberTableInit();
            fileTableInit();
            recordTableInit();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
            LimitUtils.onlyNum("FAMILY_SIZE");
            LimitUtils.onlyNum("TELEPHONE");
            LimitUtils.onlyNum("POSTCODE");
            LimitUtils.onlyNum("MEMBER_AGE");
            LimitUtils.onlyNum("SUPPORT_NUM");
            LimitUtils.onlyNumAndPoint("MEMBER_INCOME");
            LimitUtils.onlyNumAndPoint("OUT_FUND_MONEY");
            LimitUtils.onlyNumAndPoint("TOTAL_COST");
            LimitUtils.onlyNumAndPoint("LIVING_EXP");
            LimitUtils.onlyNumAlpha("MEMBER_IDCARDNO");
            
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-COLLEGE", "search-MAJOR", "", "search-CLASS");

            $("#OUT_FUND").change(function () {
                if ($(this).val() == "3") {
                    $("#OUT_FUND_PROJECT").removeAttr("disabled");
                }
                else {
                    $("#OUT_FUND_PROJECT").val("");
                    $("#OUT_FUND_PROJECT").attr("disabled", "disabled");
                }
            });
            $("#HEALTH_TYPE").change(function () {
                if ($(this).val() != "03") {
                    $("#DISA_DEGREE").removeAttr("disabled");
                }
                else {
                    $("#DISA_DEGREE").val("");
                    $("#DISA_DEGREE").attr("disabled", "disabled");
                }
            });
            $("#FAMILY_STATUS").change(function () {
                if ($(this).val() == "3") {
                    $("#SUPPORT_TYPE").removeAttr("disabled");
                    $("#SUPPORT_NUM").removeAttr("disabled");
                }
                else {
                    $("#SUPPORT_TYPE").val("");
                    $("#SUPPORT_TYPE").attr("disabled", "disabled");
                    $("#SUPPORT_NUM").val("");
                    $("#SUPPORT_NUM").attr("disabled", "disabled");
                }
            });

            //时间控件
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });
        }

        function setEditValidate(field, msg) {
            ValidateUtils.setRequired("#form_edit", field, true, msg);
        }

        //下拉初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("MEMBER_RELATION");
            DropDownUtils.initDropDown("MEMBER_PROFESSION");
            DropDownUtils.initDropDown("MEMBER_HEALTH");
            DropDownUtils.initDropDown("HUKOU_ZONE");
            DropDownUtils.initDropDown("HEALTH_TYPE");
            DropDownUtils.initDropDown("DISA_DEGREE");
            DropDownUtils.initDropDown("IS_LOAN");
            DropDownUtils.initDropDown("OUT_FUND");
            DropDownUtils.initDropDown("FAMILY_STATUS");
            DropDownUtils.initDropDown("SUPPORT_TYPE");
            DropDownUtils.initDropDown("MEMBER_EDU_LEVEL");
            DropDownUtils.initDropDown("MEMBER_DISA_DEGREE");
        }

        //必填项设置
        function loadModalPageValidate() {
            ValidateUtils.setRequired("#form_edit", "NUMBER", true, "学号");
            ValidateUtils.setRequired("#form_edit", "FAMILY_SIZE", true, "家庭人口数");
            ValidateUtils.setRequired("#form_edit", "GRADUATE_SCHOOL", true, "毕业学校");
            ValidateUtils.setRequired("#form_edit", "PROVINCE", true, "通讯地址");
            ValidateUtils.setRequired("#form_edit", "CITY", true, "通讯地址");
            ValidateUtils.setRequired("#form_edit", "COUNTY", true, "通讯地址");
            ValidateUtils.setRequired("#form_edit", "ADD_STREET", true, "通讯地址");
            ValidateUtils.setRequired("#form_edit", "POSTCODE", true, "邮政编码");
            ValidateUtils.setRequired("#form_edit", "TELEPHONE", true, "联系电话");
            ValidateUtils.setRequired("#form_edit", "HUKOU_ZONE", true, "户口所在区域");
            ValidateUtils.setRequired("#form_edit", "HEALTH_TYPE", true, "本人健康状况");
            ValidateUtils.setRequired("#form_edit", "IS_LOAN", true, "是否申请国家助学贷款");
            ValidateUtils.setRequired("#form_edit", "FAMILY_STATUS", true, "家庭状况");

            //setEditValidate("NUMBER", "请选择学号");
            //setEditValidate("FAMILY_SIZE", "请填写家庭人口数");
            //setEditValidate("GRADUATE_SCHOOL", "请填写毕业学校");
            //setEditValidate("PROVINCE", "请选择通讯地址");
            //setEditValidate("CITY", "请选择通讯地址");
            //setEditValidate("COUNTY", "请选择通讯地址");
            //setEditValidate("ADD_STREET", "请填写详细通讯地址");
            //setEditValidate("POSTCODE", "请填写邮政编码");
            //setEditValidate("TELEPHONE", "请填写联系电话");
            //setEditValidate("HUKOU_ZONE", "请选择户口所在区域");
            //setEditValidate("HEALTH_TYPE", "请选择本人健康状况");
            //setEditValidate("IS_LOAN", "请选择是否申请国家助学贷款");
            //setEditValidate("FAMILY_STATUS", "请选择家庭状况");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>家庭经济调查</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>困难生认定</li>
				<li class="active">家庭经济调查</li>
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
    <!-- 编辑界面 开始 -->
    <div class="modal fade" id="tableModal" style="height: 95%;">
        <div class="modal-dialog modal-dw80">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <input type="hidden" id="OID" name="OID" />
            <input type="hidden" id="SEQ_NO" name="SEQ_NO" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">家庭经济调查<label style="color: red;">（请如实完整填写，没有则填“无”）</label></h4>
            </div>
            <div class="modal-body">
                <div class="nav-tabs-custom" style="box-shadow: none; margin-bottom: 0px;">
                    <ul class="nav nav-tabs" id="myTab">
                        <li class="active"><a href="#tab_1" data-toggle="tab" id="tabli1">基本信息</a></li>
                        <li><a href="#tab_2" data-toggle="tab">家庭成员情况</a></li>
                        <li><a href="#tab_3" data-toggle="tab">家庭有关信息</a></li>
                        <li><a href="#tab_4" data-toggle="tab">附件</a></li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab_1">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    学号<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <input name="NUMBER" id="NUMBER" type="text" class="form-control" placeholder="" readonly />
                                </div>
                                <label class="col-sm-2 control-label">
                                    姓名<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <p class="form-control-static" id="NAME">-</p>
                                </div>
                                <label class="col-sm-2 control-label">
                                    性别<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <p class="form-control-static" id="SEX">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    年级<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <p class="form-control-static" id="GRADE">-</p>
                                </div>
                                <label class="col-sm-2 control-label">
                                    院（系）<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <p class="form-control-static" id="COLLEGE">-</p>
                                </div>
                            
                                <label class="col-sm-2 control-label">
                                    专业<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <p class="form-control-static" id="MAJOR">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    出生年月<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <p class="form-control-static" id="BIRTH_DATE">-</p>
                                </div>
                                <label class="col-sm-2 control-label">
                                    身份证号码<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <p class="form-control-static" id="IDCARDNO">-</p>
                                </div>
                                <label class="col-sm-2 control-label">
                                    民族<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <p class="form-control-static" id="NATION">-</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    政治面貌<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <p class="form-control-static" id="POLISTATUS">-</p>
                                </div>
                                <label class="col-sm-2 control-label">
                                    家庭人口数<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <input name="FAMILY_SIZE" id="FAMILY_SIZE" type="text" class="form-control" placeholder="家庭人口数" />
                                </div>
                                <label class="col-sm-2 control-label">
                                    是否申请国家助学贷款<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <select name="IS_LOAN" id="IS_LOAN" class="form-control" ddl_name='ddl_yes_no'
                                        d_value='' show_type='t' required>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    校外获资助情况</label>
                                <div class="col-sm-2">
                                    <select name="OUT_FUND" id="OUT_FUND" class="form-control" ddl_name='ddl_out_fund'
                                        d_value='' show_type='t'>
                                    </select>
                                </div>
                                <label class="col-sm-2 control-label">
                                    资助金额</label>
                                <div class="col-sm-2">
                                    <input name="OUT_FUND_MONEY" id="OUT_FUND_MONEY" type="text" class="form-control"
                                        placeholder="资助金额" />
                                </div>
                                <label class="col-sm-2 control-label">
                                    资助项目名称</label>
                                <div class="col-sm-2">
                                    <input name="OUT_FUND_PROJECT" id="OUT_FUND_PROJECT" type="text" class="form-control"
                                        placeholder="资助项目名称" maxlength="20" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    本人健康状况<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <select name="HEALTH_TYPE" id="HEALTH_TYPE" class="form-control" ddl_name='ddl_health'
                                        d_value='' show_type='t' required>
                                    </select>
                                </div>
                                <label class="col-sm-2 control-label">
                                    丧失劳动力程度</label>
                                <div class="col-sm-2">
                                    <select name="DISA_DEGREE" id="DISA_DEGREE" class="form-control" ddl_name='ddl_disability'
                                        d_value='' show_type='t'>
                                    </select>
                                </div>
                                <label class="col-sm-2 control-label">
                                    联系电话<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <input name="TELEPHONE" id="Text2" type="text" class="form-control" placeholder="联系电话" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    邮政编码<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <input name="POSTCODE" id="Text1" type="text" class="form-control" placeholder="邮政编码" />
                                </div>
                                <label class="col-sm-2 control-label">
                                    毕业学校<span style="color: Red;">*</span></label>
                                <div class="col-sm-6">
                                    <input name="GRADUATE_SCHOOL" id="GRADUATE_SCHOOL" type="text" class="form-control"
                                        placeholder="就读高中或中职大专" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    详细通讯地址<span style="color: Red;">*</span></label>
                                <%if (Request.QueryString["optype"].Equals("view"))
                                  { %>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="ADDRESS" name="ADDRESS">
                                </div>
                                <%}
                                  else
                                  { %>
                                <div class="col-sm-2">
                                    <select class="form-control" name="PROVINCE" id="PROVINCE" d_value='' ddl_name='ddl_province'
                                        show_type='t'>
                                    </select>
                                </div>
                                <div class="col-sm-2">
                                    <select class="form-control" name="CITY" id="CITY" d_value='' ddl_name='' show_type='t'>
                                    </select>
                                </div>
                                <div class="col-sm-2">
                                    <select class="form-control" name="COUNTY" id="COUNTY" d_value='' ddl_name='' show_type='t'>
                                    </select>
                                </div>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="ADD_STREET" name="ADD_STREET" value=""
                                        placeholder="详细通讯地址">
                                </div>
                                <%} %>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    入学前户口<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <select name="HUKOU_ZONE" id="HUKOU_ZONE" class="form-control" ddl_name='ddl_hk_zone'
                                        d_value='' show_type='t' required>
                                    </select>
                                </div>
                                <div class="col-sm-4">
                                    <div class="radio">
                                        <label for="URBAN" style="margin-left: 15px;">
                                            <input type="radio" name="HUKOU_BEFORE" id="URBAN" value="URBAN" />城镇
                                        </label>
                                        <label for="RURAL" style="margin-left: 15px;">
                                            <input type="radio" name="HUKOU_BEFORE" id="RURAL" value="RURAL" />农村
                                        </label>
                                        <label for="POVERTY" style="margin-left: 15px;">
                                            <input type="radio" name="HUKOU_BEFORE" id="POVERTY" value="POVERTY" />国家级贫困县
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    家庭类型<span style="color: Red;">*</span></label>
                                <div class="col-sm-10">
                                    <div id="family-type">
                                        <div>
                                            <label for="IS_ORPHAN">1、
                                                <input type="checkbox" name="IS_ORPHAN" id="IS_ORPHAN" value="on"
                                                    onclick="CheckClick_Orphan(this);" />孤儿 （
                                            </label>
                                            <label for="RadO1">
                                                <input type="radio" name="ORPHAN_DETAIL" id="RadO1" value="1"
                                                    onclick="RadioClick_Orphan(this);" />无经济来源，无社会福利机构收养
                                            </label>
                                            <label for="RadO2" style="margin-left: 15px;">
                                                <input type="radio" name="ORPHAN_DETAIL" id="RadO2" value="2"
                                                    onclick="RadioClick_Orphan(this);" />有固定亲友经济资助，但不足以解决日常费用
                                            </label>
                                            <label for="RadO3" style="margin-left: 15px;">
                                                <input type="radio" name="ORPHAN_DETAIL" id="RadO3" value="3"
                                                    onclick="RadioClick_Orphan(this);" />有固定亲友经济资助，基本解决日常费用）
                                            </label>
                                        </div>
                                        
                                        <label for="IS_SINGLE">2、
                                            <input type="checkbox" name="IS_SINGLE" id="IS_SINGLE" value="on"
                                                onclick="CheckClick_Single(this);" />单亲（
                                        </label>
                                        <label for="RadS1">
                                            <input type="radio" name="SINGLE_DETAIL" id="RadS1" value="1"
                                                onclick="RadioClick_Single(this);" />父母一方身故
                                        </label>
                                        <label for="RadS2" style="margin-left: 15px;">
                                            <input type="radio" name="SINGLE_DETAIL" id="RadS2" value="2"
                                                onclick="RadioClick_Single(this);" />父母一方离家
                                        </label>
                                        <label for="RadS3" style="margin-left: 15px;">
                                            <input type="radio" name="SINGLE_DETAIL" id="RadS3" value="3"
                                                onclick="RadioClick_Single(this);" />离异家庭）
                                        </label>

                                        <label for="IS_DISABLED" style="margin-left: 20px;">3、
                                            <input type="checkbox" name="IS_DISABLED" id="IS_DISABLED" value="on" />残疾
                                        </label>

                                        <label for="IS_MARTYRS" style="margin-left: 15px;" >4、
                                          <input type="checkbox" name="IS_MARTYRS" id="IS_MARTYRS" value="on" />
                                          烈士或优抚对象子女
                                        </label>

                                        <label for="IS_DESTITUTE" style="margin-left: 15px;">5、
                                          <input type="checkbox" name="IS_DESTITUTE" id="IS_DESTITUTE" value="on" />
                                          农村特困救助供养学生
                                        </label>

                                        <label for="IS_OTHER" style="margin-left: 15px;">6、
                                          <input type="checkbox" name="IS_OTHER" id="IS_OTHER" value="on" />
                                          其他</label>
                                    </div>
                                    <div>
                                        <label>7、</label>
                                        <input type="radio" name="IS_MINIMUM" id="NC" value="R" onclick="RadioClick_R(this);" /><label
                                            for="NC">农村低保</label>
                                        <input type="radio" name="IS_MINIMUM" id="CZ" value="U" onclick="RadioClick_U(this);"
                                            style="margin-left: 20px" /><label for="CZ">城镇低保</label>
                                        <label style="margin-left: 80px">8、</label>
                                        <input type="radio" name="IS_POOR" id="GX" value="G" onclick="RadioClick_G(this);"
                                             /><label for="GX">广西农村建档立卡</label>
                                        <input type="radio" name="IS_POOR" id="QW" value="O" onclick="RadioClick_O(this);"
                                            style="margin-left: 20px" /><label for="QW">区外建档立卡</label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                备注：<br />
                                <div class="col-sm-6">
                                1、东部地区包括：辽宁、北京、天津、河北、上海、江苏、浙江、福建、山东、广东、海南<br />
                                2、中部地区包括：吉林、黑龙江、山西、安徽、江西、河南、湖北、湖南<br />
                                3、西部地区包括：内蒙、广西、重庆、四川、贵州、云南、西藏、陕西、甘肃、青海、宁夏、新疆
                                </div>
                                <div class="col-sm-6">
                                4、国家级贫困县以国务院扶贫开发领导小组办公室公布名单为准<br />
                                5、家庭类型中，1～6可多选（1、2括号中为单选），7～8为单选
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="tab_2">
                            <label>说明：家庭主要成员指的是直系三代以内、共同生活或实际监护者的亲属成员，已婚已独立生活的亲属不在此列。</label>
                            <table id="memberlist" class="table table-bordered table-striped table-hover">
                            </table>
                        </div>
                        <div class="tab-pane" id="tab_3">

                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    本学年已获资助情况<span style="color: Red;">*</span></label>
                                <div class="col-sm-10">
                                    <textarea name="FUND_SITUA" id="FUND_SITUA" rows="3" maxlength="60" class="form-control"
                                        placeholder="在校生指的是暑假所在学年已获资助情况，新生指的是高中或原就读学校期间获资助情况"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    家庭遭受突发意外事件<span style="color: Red;">*</span></label>
                                <div class="col-sm-10">
                                    <textarea name="ACCIDENT_SITUA" id="ACCIDENT_SITUA" rows="3" maxlength="60" class="form-control"
                                        placeholder="此处简略描写，附材料证明意外类型、家庭成员伤亡、相关医疗赔偿等情况"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    家庭成员失业情况<span style="color: Red;">*</span></label>
                                <div class="col-sm-10">
                                    <textarea name="WORK_SITUA" id="WORK_SITUA" rows="3" maxlength="60" class="form-control"
                                        placeholder="含无固定收入来源、下岗无再就业、非农无正规就业等"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    家庭欠债情况及原因<span style="color: Red;">*</span></label>
                                <div class="col-sm-10">
                                    <textarea name="DEBT_SITUA" id="DEBT_SITUA" rows="3" maxlength="60" class="form-control"
                                        placeholder="写明欠债原因、金额、偿还情况等"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    其他情况<span style="color: Red;">*</span></label>
                                <div class="col-sm-10">
                                    <textarea name="OTHER_SITUA" id="OTHER_SITUA" rows="3" maxlength="60" class="form-control"
                                        placeholder="影响家庭经济的其他情况，如遭受自然灾害、经济变故，家庭成员残疾、年迈、丧失劳动能力，身患重大恶性疾病、多子女读书、农副产业发展受阻等"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    家庭状况<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <select name="FAMILY_STATUS" id="FAMILY_STATUS" class="form-control" ddl_name='ddl_family_status'
                                        d_value='' show_type='t' required>
                                    </select>
                                </div>
                                <label class="col-sm-2 control-label">
                                    赡养方式</label>
                                <div class="col-sm-2">
                                    <select name="SUPPORT_TYPE" id="SUPPORT_TYPE" class="form-control" ddl_name='ddl_support_type'
                                        d_value='' show_type='t'>
                                    </select>
                                </div>
                                <label class="col-sm-2 control-label">
                                    赡养人数</label>
                                <div class="col-sm-2">
                                    <input name="SUPPORT_NUM" id="SUPPORT_NUM" type="text" class="form-control" placeholder="赡养人数" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">
                                    家庭每月约可提供学生生活费<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <input name="LIVING_EXP" id="LIVING_EXP" type="text" class="form-control"
                                        placeholder="单位：元" />
                                </div>
                                <label class="col-sm-3 control-label">
                                    家庭每学年约可提供学生学费、住宿费<span style="color: Red;">*</span></label>
                                <div class="col-sm-2">
                                    <input name="TOTAL_COST" id="TOTAL_COST" type="text" class="form-control"
                                        placeholder="单位：元" />
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="tab_4">
                            <table id="filelist" class="table table-bordered table-striped table-hover">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSave">
                    保存</button>
                <button type="button" class="btn btn-primary btn-submit" id="btnSubmit">
                    提交</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 开始 -->
    <div class="modal fade" id="memberModal">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="member_edit" name="member_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <input type="hidden" id="MEMBER_OID" name="OID" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">家庭成员情况</h4>
            </div>
            <div class="modal-body">
                
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            姓名<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <input name="NAME" id="MEMBER_NAME" type="text" class="form-control" placeholder="姓名" />
                        </div>
                        <label class="col-sm-2 control-label">
                            身份证号码<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <input name="IDCARDNO" id="MEMBER_IDCARDNO" type="text" class="form-control"
                                placeholder="身份证号码" maxlength="18" onblur="GetAgeByIDNO();" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            年收入(元)<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <input name="INCOME" id="MEMBER_INCOME" type="text" class="form-control" placeholder="年收入（元）" />
                        </div>
                        <label class="col-sm-2 control-label">
                            年龄<span style="color: Red;">*</span></label>
                        <div class="col-sm-4">
                            <input name="AGE" id="MEMBER_AGE" type="text" class="form-control" placeholder="年龄" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            与学生关系<span style="color: Red;">*</span></label>
                        <div class="col-sm-10">
                            <div class="col-sm-6" style="margin: 0; padding: 0;">
                                <select class="form-control" name="RELATION" id="MEMBER_RELATION" d_value='' ddl_name='ddl_relation'
                                    show_type='t' required>
                                </select>
                            </div>
                            <div class="col-sm-6" style="margin: 0; padding: 0;">
                                <input name="MEMBER_RELATION_TEXT" id="MEMBER_RELATION_TEXT" type="text" class="form-control"
                                    placeholder="与学生关系" />
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            工作(学习)单位<span style="color: Red;">*</span></label>
                        <div class="col-sm-10">
                            <input name="WORKPLACE" id="MEMBER_WORKPLACE" type="text" class="form-control" placeholder="如无则填写家庭地址" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            职业<span style="color: Red;">*</span></label>
                        <div class="col-sm-2">
                            <select class="form-control" name="PROFESSION" id="MEMBER_PROFESSION" d_value=''
                                ddl_name='ddl_profession' show_type='t' required>
                            </select>
                        </div>
                        <div class="col-sm-2" style="margin: 0; padding: 0;">
                            <input name="MEMBER_PROFESSION_TEXT" id="MEMBER_PROFESSION_TEXT" type="text" class="form-control"
                                placeholder="职业" />
                        </div>
                        <label class="col-sm-2 control-label">
                            在读教育程度</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="MEMBER_EDU_LEVEL" id="MEMBER_EDU_LEVEL" d_value=''
                                ddl_name='ddl_education' show_type='t'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            健康状况<span style="color: Red;">*</span></label>
                        <%--<div class="col-sm-10">--%>
                            <div class="col-sm-4">
                                <select class="form-control" name="HEALTH" id="MEMBER_HEALTH" d_value='' ddl_name='ddl_health'
                                    show_type='t' required>
                                </select>
                            </div>
                            <%--<div class="col-sm-4" style="margin: 0; padding: 0;">
                                <input name="MEMBER_HEALTH_TEXT" id="MEMBER_HEALTH_TEXT" type="text" class="form-control"
                                    placeholder="健康状况" />
                            </div>--%>
                        <%--</div>--%>
                        <label class="col-sm-2 control-label">
                            丧失劳动能力程度</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="MEMBER_DISA_DEGREE" id="MEMBER_DISA_DEGREE" d_value='' ddl_name='ddl_disability'
                                show_type='t'>
                            </select>
                        </div>
                    </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnMemberSave">保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 上传界面 -->
    <div class="modal fade" id="uploadModal">
        <div class="modal-dialog">
            <form id="form_upload" name="form_edit" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">附件上传</h4>
            </div>
            <div class="modal-body">
                
                    <iframe id="uploadFrame" frameborder="0" src="" style="width: 100%; height: 220px;">
                    </iframe>
                
            </div>
            </form>
        </div>
    </div>
    <!-- 删除界面-->
    <div class="modal fade modal-warning" id="delModal">
        <div class="modal-dialog">
            <form id="form_del" name="form_del" class="modal-content  form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">删除</h4>
            </div>
            <div class="modal-body">
                <p>确定要删除该信息？</p>
                <input type="hidden" name="OID" value="" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-outline btn-delete">确定</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 附件上传说明界面 -->
    <div class="modal fade" id="infoModal">
        <div class="modal-dialog modal-dw60">
            <form id="form_info" name="form_info" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    附件上传说明</h4>
            </div>
            <div class="modal-body">
                <iframe id="infoFrame" frameborder="0" src="" style="width: 100%; height: 600px;">
                </iframe>
            </div>
            </form>
        </div>
    </div>
    <!-- 调查记录界面-->
    <div class="modal fade" id="recordModal">
        <div class="modal-dialog modal-dw50">
            <form action="#" method="post" name="form" class="modal-content" onsubmit="">
            <div class="modal-body">
                <table id="recordlist" class="table table-bordered table-striped table-hover">
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>\
            </div>
            </form>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $('#myTab a').click(function (e) {
                e.preventDefault();
                if ($(this).text() != "基本信息" && !($("#SEQ_NO").val())) {
                    easyAlert.timeShow({
                        "content": "请先保存数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return false;
                }
                return true;
            })
        });
    </script>
    <!--mainList-->
    <script type="text/javascript">
		//列表初始化
		function loadTableList() {
			//配置表格列
			tablePackageMany.filed = [
				{
					"data": "OID",
					"createdCell": function (nTd, sData, oData, iRow, iCol) {
						$(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
					},
					"head": "checkbox", "id": "checkAll"
				},
				{ "data": "NUMBER", "head": "学号" },
				{ "data": "NAME", "head": "姓名" },
				{ "data": "SEX_NAME", "head": "性别" },
				{ "data": "COLLEGE_NAME", "head": "学院" },
				{ "data": "MAJOR_NAME", "head": "专业" },
				{ "data": "CLASS_NAME", "head": "班级" },
				{ "data": "DECL_TIME", "head": "调查时间" }
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
					tableId: "tablelist",//表格id
					buttonId: "buttonId",//拓展按钮区域id
					tableTitle: "家庭经济调查",
					checkAllId: "checkAll",//全选id
					tableConfig: {
						'pageLength': 10,//每页显示个数，默认10条
						'selectSingle': true,//是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
					}
				},
				//查询栏
				hasSearch: {
					"cols": [
						{ "data": "COLLEGE", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "MAJOR", "pre": "专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
						{ "data": "CLASS", "pre": "班级", "col": 2, "type": "select", "ddl_name": "ddl_class" },
						{ "data": "NUMBER", "pre": "学号", "col": 2, "type": "input" },
						{ "data": "NAME", "pre": "姓名", "col": 2, "type": "input" },
						{ "data": "IDCARDNO", "pre": "身份证号码", "col": 2, "type": "input" }
					]
				},
				hasModal: false,//弹出层参数
				hasBtns: ["reload",
					{ type: "userDefined", id: "btn-list-view", title: "查阅", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } },
					<%if (m_strIsShowEditBtn.Equals("true")) { %> "add", "edit", "del",
					{ type: "userDefined", id: "btn-list-submit", title: "提交", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } },<% } %>
					{ type: "userDefined", id: "btn-list-down", title: "下载", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } },
					//{ type: "userDefined", id: "btn-list-print", title: "打印", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } },//ZZ 20171117 屏蔽：打印格式与WORD下载格式有差距 学校那边要屏蔽打印功能
					//{ type: "userDefined", id: "btn-list-export", title: "导出", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing" } },
                    { type: "userDefined", id: "btn-list-record", title: "调查记录", className: "btn-success", attr: { "data-action": "", "data-other": "nothing" } }
				],//需要的按钮
				hasCtrl: {
					"buildModal": false
				}
			});

		}
    </script>
    <!--memberList-->
    <script type="text/javascript">
        function memberTableInit() {
            tablePackageMany.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "NAME", "head": "姓名" },
				{ "data": "IDCARDNO", "head": "身份证号码" },
				{ "data": "AGE", "head": "年龄" },
				{ "data": "RELATION_NAME", "head": "与学生关系" },
				{ "data": "WORKPLACE", "head": "工作(学习)单位" },
				{ "data": "PROFESSION_NAME", "head": "职业" },
				{ "data": "EDU_LEVEL_NAME", "head": "在读教育程度" },
				{ "data": "INCOME", "head": "年收入（元）" },
				{ "data": "HEALTH_NAME", "head": "健康状况" }
			];
            //配置表格
            memberList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "List.aspx?optype=getmember",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "memberlist", //表格id
                    buttonId: "memberbuttonId", //拓展按钮区域id
                    tableTitle: "",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 20, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                hasModal: false, //弹出层参数
                hasBtns: ["add", "edit", "del"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            var tab = $("#tab_2");
            tab.on('click', ".btn-add", function () {
                var result = AjaxUtils.getResponseText('?optype=checkaddmember&seq_no=' + $("#SEQ_NO").val() + '&t=' + Math.random());
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                $("#memberModal").modal();
                $("#memberModal :input").val("");
            });
            tab.on('click', ".btn-edit", function () {
                var data = memberList.selectSingle();
                if (data) {
                    $("#memberModal").modal();
                    SetMainFormData("memberModal", "MEMBER", data);
                    setMemberControl(data);
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
            tab.on('click', ".btn-del", function () {
                var data = memberList.selectSingle();
                if (data) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除所选的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            $.post(OptimizeUtils.FormatUrl("?optype=delmember&oid=" + data.OID), function (msg) {
                                if (!msg) {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": "删除成功！",
                                        "duration": 2,
                                        "type": "success"
                                    });
                                    memberList.reload();
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
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
            $("#btnMemberSave").click(function () {
                if ($("#MEMBER_RELATION").val() == "11" && $("#MEMBER_RELATION_TEXT").val() == "") {
                    easyAlert.timeShow({
                        "content": "与学生关系选择[其他]时，请手动填写！",
                        "duration": 3,
                        "type": "danger"
                    });
                    return;
                }
                if ($("#MEMBER_PROFESSION").val() == "07" && $("#MEMBER_PROFESSION_TEXT").val() == "") {
                    easyAlert.timeShow({
                        "content": "职业选择[其他]时，请手动填写！",
                        "duration": 3,
                        "type": "danger"
                    });
                    return;
                }
                if ($("#MEMBER_PROFESSION").val() == "06" && $("#MEMBER_EDU_LEVEL").val() == "") {
                    easyAlert.timeShow({
                        "content": "职业选择[学生]时，请选择在读教育程度！",
                        "duration": 3,
                        "type": "danger"
                    });
                    return;
                }
                //if ($("#MEMBER_HEALTH").val() == "04" && $("#MEMBER_HEALTH_TEXT").val() == "") {
                //    easyAlert.timeShow({
                //        "content": "健康状况选择[其他]时，请手动填写！",
                //        "duration": 3,
                //        "type": "danger"
                //    });
                //    return;
                //}
                if ($("#MEMBER_HEALTH").val() != "03" && $("#MEMBER_DISA_DEGREE").val() == "") {
                    easyAlert.timeShow({
                        "content": "健康状况不是[良好]时，请选择丧失劳动能力程度！",
                        "duration": 3,
                        "type": "danger"
                    });
                    return;
                }
                if ($("#MEMBER_RELATION").val() == "" || $("#MEMBER_PROFESSION").val() == "" || $("#MEMBER_HEALTH").val() == "" || $("#MEMBER_NAME").val() == "" || $("#MEMBER_AGE").val() == "" || $("#MEMBER_WORKPLACE").val() == "" || $("#MEMBER_INCOME").val() == "") {
                    easyAlert.timeShow({
                        "content": "请填写完必填项！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                $.post(OptimizeUtils.FormatUrl("?optype=savemember&seq_no=" + $("#SEQ_NO").val()), $("#member_edit").serialize(), function (msg) {
                    if (msg.length == 0) {
                        easyAlert.timeShow({
                            "content": "保存失败！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    else {
                        //保存成功：关闭界面，刷新列表
                        $("#memberModal").modal("hide");
                        easyAlert.timeShow({
                            "content": "保存成功！",
                            "duration": 2,
                            "type": "success"
                        });
                        memberList.reload();
                    }
                });
            });

            function setMemberControl(data) {
                if (data.RELATION_NAME == data.RELATION) {
                    $("#MEMBER_RELATION").val("11");
                    $("#MEMBER_RELATION_TEXT").val(data.RELATION);
                    $("#MEMBER_RELATION_TEXT").removeAttr("disabled");
                }
                else {
                    $("#MEMBER_RELATION_TEXT").val("");
                    $("#MEMBER_RELATION_TEXT").attr("disabled", "disabled");
                }
                if (data.PROFESSION == "06") {
                    $("#MEMBER_EDU_LEVEL").val(data.EDU_LEVEL);
                    $("#MEMBER_EDU_LEVEL").removeAttr("disabled");
                }
                else {
                    $("#MEMBER_EDU_LEVEL").val("");
                    $("#MEMBER_EDU_LEVEL").attr("disabled", "disabled");
                }
                if (data.PROFESSION_NAME == data.PROFESSION) {
                    $("#MEMBER_PROFESSION").val("07");
                    $("#MEMBER_PROFESSION_TEXT").val(data.PROFESSION);
                    $("#MEMBER_PROFESSION_TEXT").removeAttr("disabled");
                }
                else {
                    $("#MEMBER_PROFESSION_TEXT").val("");
                    $("#MEMBER_PROFESSION_TEXT").attr("disabled", "disabled");
                }
                //if (data.HEALTH_NAME == data.HEALTH) {
                //    $("#MEMBER_HEALTH").val("04");
                //    $("#MEMBER_HEALTH_TEXT").val(data.HEALTH);
                //    $("#MEMBER_HEALTH_TEXT").removeAttr("disabled");
                //}
                //else {
                //    $("#MEMBER_HEALTH_TEXT").val("");
                //    $("#MEMBER_HEALTH_TEXT").attr("disabled", "disabled");
                //}
                if (data.HEALTH != "03") {
                    $("#MEMBER_DISA_DEGREE").val(data.DISA_DEGREE);
                    $("#MEMBER_DISA_DEGREE").removeAttr("disabled");
                }
                else {
                    $("#MEMBER_DISA_DEGREE").val("");
                    $("#MEMBER_DISA_DEGREE").attr("disabled", "disabled");
                }
            }
            $("#MEMBER_RELATION").change(function () {
                if ($(this).val() == "11") {
                    $("#MEMBER_RELATION_TEXT").removeAttr("disabled");
                }
                else {
                    $("#MEMBER_RELATION_TEXT").val("");
                    $("#MEMBER_RELATION_TEXT").attr("disabled", "disabled");
                }
            });
            $("#MEMBER_PROFESSION").change(function () {
                if ($(this).val() == "06") {
                    $("#MEMBER_EDU_LEVEL").removeAttr("disabled");
                }
                else {
                    $("#MEMBER_EDU_LEVEL").val("");
                    $("#MEMBER_EDU_LEVEL").attr("disabled", "disabled");
                }
            });
            $("#MEMBER_PROFESSION").change(function () {
                if ($(this).val() == "07") {
                    $("#MEMBER_PROFESSION_TEXT").removeAttr("disabled");
                }
                else {
                    $("#MEMBER_PROFESSION_TEXT").val("");
                    $("#MEMBER_PROFESSION_TEXT").attr("disabled", "disabled");
                }
            });
            //$("#MEMBER_HEALTH").change(function () {
            //    if ($(this).val() == "04") {
            //        $("#MEMBER_HEALTH_TEXT").removeAttr("disabled");
            //    }
            //    else {
            //        $("#MEMBER_HEALTH_TEXT").val("");
            //        $("#MEMBER_HEALTH_TEXT").attr("disabled", "disabled");
            //    }
            //});
            $("#MEMBER_HEALTH").change(function () {
                if ($(this).val() != "03") {
                    $("#MEMBER_DISA_DEGREE").removeAttr("disabled");
                }
                else {
                    $("#MEMBER_DISA_DEGREE").val("");
                    $("#MEMBER_DISA_DEGREE").attr("disabled", "disabled");
                }
            });
        }

        function GetAgeByIDNO() {
            var idno = $("#MEMBER_IDCARDNO").val();//取得身份证号
            if (idno.length != 18) return;
            var year = idno.substring(6, 10);//截取身份证上的年
            var months = idno.substring(10, 12);//截取身份证上的月
            var days = idno.substring(12, 14);//截取身份证上的日
            var myDate = new Date();
            var month = myDate.getMonth() + 1;
            var day = myDate.getDate();
            var age = myDate.getFullYear() - year - 1;
            if (months < month || months == month && days <= day) {
                age++;
            }
            $("#MEMBER_AGE").val(age);
        }
    </script>
    <!--fileList-->
    <script type="text/javascript">
        function fileTableInit() {
            tablePackageMany.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "SHOW_NAME", "head": "附件名称" },
				{ "data": "NOTE", "head": "说明" }
			];
            //配置表格
            fileList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "List.aspx?optype=getfile",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "filelist", //表格id
                    buttonId: "filebuttonId", //拓展按钮区域id
                    tableTitle: "",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 20, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                hasModal: false, //弹出层参数
                hasBtns: [{ type: "userDefined", id: "btn-view-pic", title: "查阅", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
					{ type: "userDefined", id: "btn-upload", title: "上传", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                    { type: "userDefined", id: "btn-view-info", title: "附件上传说明", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
					"del"], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            var tab = $("#tab_4");

            $(document).on("click", "#btn-view-pic", function () {
                var data = fileList.selectSingle();
                if (data) {
                    var photoname = data.ARCHIVE_DIRECTORY + '/' + data.PHOTO_NAME;
                    //获取根目录
                    var curWwwPath = window.document.location.href;
                    var pathName = window.document.location.pathname;
                    var pos = curWwwPath.indexOf(pathName);
                    var root = curWwwPath.substring(0, pos);
                    //弹出层
                    var light = document.getElementById('light');
                    var fade = document.getElementById('fade');
                    //var photosrc = document.getElementById('photo');
                    var uploadphoto_root = '<%=m_strUploadPhotoRoot %>';
                    if (uploadphoto_root.length == 0)
                        uploadphoto_root = "UploadPhoto";

                    window.open(root + '/' + uploadphoto_root + '/' + photoname);
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });

            $(document).on("click", "#btn-upload", function () {
                $("#uploadFrame").attr("src", "PhotoUpload.aspx?seq_no=" + $("#SEQ_NO").val());
                $("#uploadModal").modal();
            });

            $(document).on("click", "#btn-view-info", function () {
                $("#infoFrame").attr("src", "UploadInfo.aspx");
                $("#infoModal").modal();
            });

            tab.on('click', ".btn-del", function () {
                var data = fileList.selectSingle();
                if (data) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除所选的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            $.post(OptimizeUtils.FormatUrl("?optype=delphoto&id=" + data.OID), function (msg) {
                                if (!msg) {
                                    $(".Confirm_Div").modal("hide");
                                    easyAlert.timeShow({
                                        "content": "删除成功！",
                                        "duration": 2,
                                        "type": "success"
                                    });
                                    fileList.reload();
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
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
        }

    </script>
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload',
				    add: '.btn-add',
				    edit: '.btn-edit',
				    del: '.btn-del'
				};
            //刷新
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            _content.on('click', _btns.add, function () {
                showBtn();
                if ('<%=user.User_Id %>' == '') {
                    easyAlert.timeShow({
                        "content": "学号为空！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }

                $("#tableModal").modal();
                $("#tabli1").click();
                //GetRadioBtnStatus(data);
                $("input[type='radio']").removeAttr('checked'); //清除单选框的checked属性
                var result = AjaxUtils.getResponseText("List.aspx?optype=createnewdata&number=<%=user.User_Id %>");
                if (result) {
                    //if (r == "") {
                    //    easyAlert.timeShow({
                    //        "content": "该学生已经存在！",
                    //        "duration": 2,
                    //        "type": "danger"
                    //    });
                    //    return;
                    //}
                    if (result.indexOf('失败') >= 0) {
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    var result_json = eval("(" + result + ")");
                    SelectUtils.RegionCodeChange('PROVINCE', 'CITY', 'COUNTY', result_json.PROVINCE, result_json.CITY, result_json.COUNTY);
                    _form_edit.setFormData(result_json);
                }
            });

            _content.on('click', _btns.edit, function () {
                showBtn();
                var data = mainList.selectSingle();
                if (data) {
                    memberList.refresh("?optype=getmember&seq_no=" + data.SEQ_NO);
                    fileList.refresh("?optype=getfile&seq_no=" + data.SEQ_NO);
                    $("#tableModal").modal();
                    $("#tabli1").click();
                    //SetMainFormData("tableModal", "", data);
                    GetRadioBtnStatus(data);
                    $("input[type='radio']").removeAttr('checked'); //清除单选框的checked属性
                    var apply_data = AjaxUtils.getResponseText('List.aspx?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        SelectUtils.RegionCodeChange('PROVINCE', 'CITY', 'COUNTY', apply_data_json.PROVINCE, apply_data_json.CITY, apply_data_json.COUNTY);
                        _form_edit.setFormData(apply_data_json);
                    }
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });

            _content.on('click', ".btn-del", function () {
                var data = mainList.selectSingle();
                if (data) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除所选的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            $.post(OptimizeUtils.FormatUrl("?optype=delete&oid=" + data.OID), function (msg) {
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
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });

            _content.on("click", "#btn-list-submit", function () {
                _content.find(".btn-edit").click();
                return;
            });
            _content.on('click', "#btn-list-down", function () {
                var data = mainList.selectSingle();
                if (data) {
                    window.open('/Word/ExportWord.aspx?optype=survey&id=' + data.OID + '&number=' + data.NUMBER);
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
            _content.on('click', "#btn-list-print", function () {
                var data = mainList.selectSingle();
                if (data) {
                    window.open('Print.aspx?optype=print&id=' + data.OID);
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
            _content.on('click', "#btn-list-export", function () {
                var COLLEGE = DropDownUtils.getDropDownValue("search-COLLEGE");
                var CLASS = DropDownUtils.getDropDownValue("search-CLASS");
                var MAJOR = DropDownUtils.getDropDownValue("search-MAJOR");
                var NAME = $("#search-NAME").val();
                var NUMBER = $("#search-NUMBER").val();
                var IDCARDNO = $("#search-IDCARDNO").val();
                if (COLLEGE.length == 0) {
                    easyAlert.timeShow({
                        "content": "查询条件：学院不能为空！",
                        "duration": 3,
                        "type": "info"
                    });
                    return;
                }
                var para = '&COLLEGE=' + COLLEGE + '&CLASS=' + CLASS + '&MAJOR=' + MAJOR + '&NAME=' + NAME + '&NUMBER=' + NUMBER + '&IDCARDNO=' + IDCARDNO;
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=dstapply' + para);
            });
            _content.on('click', "#btn-list-view", function () {
                hideBtn();
                var data = mainList.selectSingle();
                if (data) {
                    memberList.refresh("?optype=getmember&seq_no=" + data.SEQ_NO);
                    fileList.refresh("?optype=getfile&seq_no=" + data.SEQ_NO);
                    $("#tableModal").modal();
                    $("#tabli1").click();
                    //SetMainFormData("tableModal", "", data);
                    GetRadioBtnStatus(data);
                    $("input[type='radio']").removeAttr('checked'); //清除单选框的checked属性
                    var apply_data = AjaxUtils.getResponseText('List.aspx?optype=getdata&id=' + data.OID);
                    if (apply_data) {
                        var apply_data_json = eval("(" + apply_data + ")");
                        SelectUtils.RegionCodeChange('PROVINCE', 'CITY', 'COUNTY', apply_data_json.PROVINCE, apply_data_json.CITY, apply_data_json.COUNTY);
                        _form_edit.setFormData(apply_data_json);
                    }
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });

            //【调查记录】
            _content.on('click', "#btn-list-record", function () {
                var data = mainList.selectSingle();
                if (data) {
                    recordList.refresh("?optype=getrecord&number=" + data.NUMBER);
                    $("#recordModal").modal();
                }
                else {
                    easyAlert.timeShow({
                        "content": "请选择一条数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                }
            });
        }
        var hideBtn = function () {
            $("#tableModal").find(".box-tools").find("button").hide();
            $("#btnSave").hide();
            $("#btnSubmit").hide();
            $("#btn-view-pic").show();
        }
        var showBtn = function () {
            $("#tableModal").find(".box-tools").find("button").show();
            $("#btnSave").show();
            $("#btnSubmit").show();
        }
        function SetMainFormData(modal, fixed, data) {
            $("input[type='radio']").removeAttr('checked'); //清除单选框的checked属性
            for (var e in data) {
                if (data.hasOwnProperty(e)) {
                    var _s = $("#" + modal).find('[name=' + e + ']');
                    if (_s.length == 0) {
                        _s = $("#" + modal + " #" + fixed + e);
                    }
                    if (_s.length > 0) {
                        var _val = data[e];
                        if (_s.prop("nodeName") != 'TEXTAREA' && _s.prop('nodeName') != "SELECT") {
                            if (_s.attr('type') == "checkbox") {
                                if (parseInt(_val) > 0 && _val != undefined && _val != '') {
                                    _s.prop('checked', true);
                                    try {
                                        _s.iCheck('check');
                                    } catch (e) {

                                    }
                                } else {
                                    _s.prop('checked', false);
                                    try {
                                        _s.iCheck('uncheck');
                                    } catch (e) {

                                    }
                                }
                            } else if (_s.attr('type') == "file") {

                            } else if (_s.attr('type') == "radio") {
                                if (_val)
                                    $("#" + modal).find('[name=' + e + '][value=' + _val + ']').prop("checked", "checked");
                            } else {
                                if (_s[0]["nodeName"] == "P")
                                    _s.text(_val);
                                else
                                    _s.val(_val);
                            }
                        } else if (_s.prop('nodeName') == "SELECT") {
                            _s.val(_val);
                        } else {
                            if (_s.hasClass('ckEditor')) {
                                var editorElement = CKEDITOR.document.getById(_s.attr('id'));
                                editorElement.setHtml(_val);
                            } else {
                                _s.val(_val);
                            }
                        }
                    }
                }
            }
        }

        //保存前校验
        function CheckBefore() {
            if ($("input[name='HUKOU_BEFORE']:checked").val() == undefined) {
                easyAlert.timeShow({
                    "content": "请选择入学前户口！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            if ($("#family-type").find("input:checked").length == 0 && ($("input[name='IS_MINIMUM']:checked").val() == undefined) &&
				($("input[name='IS_POOR']:checked").val() == undefined)) {
                easyAlert.timeShow({
                    "content": "请选择家庭类型！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            if ($("#OUT_FUND").val().length > 0 && parseFloat($("#OUT_FUND_MONEY")) <= 0) {
                easyAlert.timeShow({
                    "content": "请填写获资助项目名称！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            if ($("#OUT_FUND").val() == "3" && $("#OUT_FUND_PROJECT").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请填写获资助金额！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            if ($("#FAMILY_STATUS").val() == "3" &&
                ($("#SUPPORT_TYPE").val().length == 0 || parseFloat($("#SUPPORT_NUM").val()) <= 0)) {
                easyAlert.timeShow({
                    "content": "请填写赡养方式、赡养人数！",
                    "duration": 2,
                    "type": "danger"
                });
                return false;
            }
            return true;
        }

        //保存事件
        $("#btnSave").click(function () {
            SaveData();
        });
        function SaveData() {
            if (!($("#form_edit").valid())) {
                return;
            }
            if (!CheckBefore()) return;

            var data = $("#form_edit").serialize();
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length == 0) {
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                else {
                    var arr = msg.split(";");
                    if (arr.length == 2) {
                        $("#OID").val(arr[0]);
                        $("#SEQ_NO").val(arr[1]);
                        //ZZ修改：保存之后要刷新表体，这样才会重新加载表体数据
                        memberList.refresh("?optype=getmember&seq_no=" + arr[1].toString());
                        fileList.refresh("?optype=getfile&seq_no=" + arr[1].toString());
                    }
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

        $("#btnSubmit").click(function () {
            if (!($("#form_edit").valid())) {
                return;
            }
            if (!CheckBefore()) return;

            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认提交数据吗？",
                'title': '提交数据',
                'callback': function (btn) {
                    var result = AjaxUtils.getResponseText('?optype=checkdecl&id=' + $("#OID").val() + '&seq_no=' + $("#SEQ_NO").val() + '&t=' + Math.random());
                    if (result.length > 0) {
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return false;
                    }

                    $.post(OptimizeUtils.FormatUrl('List.aspx?optype=decl'), $("#form_edit").serialize(), function (msg) {
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
                            easyAlert.timeShow({
                                "content": msg,
                                "duration": 2,
                                "type": "danger"
                            });
                        }
                    });
                }
            });
        });

        //删除事件
        function DeleteData() {
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=delete"), $("#form_del").serialize(), function (msg) {
                if (msg.length != 0) {
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    $("#delModal").modal("hide");
                    return;
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    easyAlert.timeShow({
                        "content": "删除成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    $("#delModal").modal("hide");
                    tablePackage.reload();
                }
            });
        }

        //获取单选按钮的初始状态
        function GetRadioBtnStatus(data) {
            if (data.IS_MINIMUM == 'R')
                chk_R = true;
            if (data.IS_MINIMUM == 'U')
                chk_U = true;

            if (data.IS_POOR == 'G')
                chk_G = true;
            if (data.IS_POOR == 'O')
                chk_O = true;
        }

        //单选按钮单击事件
        function RadioClick_R(obj) {
            obj.checked = !chk_R;
            chk_R = !chk_R;
            chk_U = false;
            if (chk_U) chk_R = false;
        }
        function RadioClick_U(obj) {
            obj.checked = !chk_U;
            chk_U = !chk_U;
            chk_R = false;
            if (chk_R) chk_U = false;
        }
        function RadioClick_G(obj) {
            obj.checked = !chk_G;
            chk_G = !chk_G;
            if (chk_G) chk_O = false;
        }
        function RadioClick_O(obj) {
            obj.checked = !chk_O;
            chk_O = !chk_O;
            if (chk_O) chk_G = false;
        }
        function RadioClick_Orphan(obj) {
            $("#IS_ORPHAN").prop("checked", true);
        }
        function RadioClick_Single(obj) {
            $("#IS_SINGLE").prop("checked", true);
        }
        function CheckClick_Orphan(obj) {
            if (obj.checked == false) {
                $("input[name='ORPHAN_DETAIL']").attr("checked", false);
            }
        }
        function CheckClick_Single(obj) {
            if (obj.checked == false) {
                $("input[name='SINGLE_DETAIL']").attr("checked", false);
            }
        }
    </script>
    <!--recordList-->
    <script type="text/javascript">
        var recordList;
        function recordTableInit() {
            tablePackageMany.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "OP_TIME", "head": "调查时间", "type": "td-keep" },
				{ "data": "OP_USER_NAME", "head": "操作人", "type": "td-keep" }
            ];
            //配置表格
            recordList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "List.aspx?optype=getrecord",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "recordlist", //表格id
                    buttonId: "selectbuttonId", //拓展按钮区域id
                    tableTitle: "",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                hasSearch: {},
                hasModal: false, //弹出层参数
                hasBtns: [], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
</asp:Content>