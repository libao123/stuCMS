<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="ResultList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectCheck.ResultList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList;
        var fileList;
        var _form_edit;
        $(function () {
            adaptionHeight();
            //编辑页控制定义
            _form_edit = PageValueControl.init("form_edit");

            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>查询导出</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>保险管理</li>
				<li class="active">查询导出</li>
			</ol>
		</section>
            <section class="content" id="content">
		        <div class="row">
			        <div class="col-xs-12">
				        <div id="div_Per" style=" font-size: x-large; color:Red;"></div>
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
    <div class="modal fade" id="tableModal">
        <div class="modal-dialog modal-dw70">
            <div class="modal-content form-horizontal">
                <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">核对信息<label style="color: Red;">（注：如信息无误，直接点“确认提交”）</label></h4>
                </div>
                <div class="modal-body">
                    <div class="nav-tabs-custom" style="box-shadow: none; margin-bottom: 0px;">
                        <ul class="nav nav-tabs" id="ul_tabs">
                            <li id="li_tab_1" class="active"><a href="#tab_1" data-toggle="tab">参保信息</a></li>
                            <li id="li_tab_2"><a href="#tab_2" data-toggle="tab">附件及说明</a></li>
                        </ul>
                        <div class="tab-content">
                            <!--参保信息 开始-->
                            <div class="tab-pane active" id="tab_1">
                                <div class="box-header with-border">
                                    <h3 class="box-title">查阅参保部分</h3>
                                </div>
                                <div class="box-body">
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            保险名称
                                        </label>
                                        <div class="col-sm-10">
                                            <input name="INSUR_NAME" id="INSUR_NAME" type="text" class="form-control" placeholder="项目名称" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            保险类型</label>
                                        <div class="col-sm-4">
                                            <select class="form-control" name="INSUR_TYPE" id="INSUR_TYPE" d_value='' ddl_name='ddl_insur_type'
                                                show_type='t'>
                                            </select>
                                        </div>

                                        <label class="col-sm-2 control-label">
                                            保险学年</label>
                                        <div class="col-sm-4">
                                            <select class="form-control" name="INSUR_YEAR" id="INSUR_YEAR" d_value='' ddl_name='ddl_year_type'
                                                show_type='t'>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            承保期限</label>
                                        <div class="col-sm-4">
                                            <input name="OLD_INSUR_LIMITDATE" id="OLD_INSUR_LIMITDATE" type="text" class="form-control"
                                                maxlength="50" placeholder="承保期限" />
                                        </div>
                                    </div>
                                    <!--<div class="form-group col-sm-6">
                                    <label class="col-sm-4 control-label">
                                        更正后承保期限</label>
                                    <div class="col-sm-8">
                                        <input name="NEW_INSUR_LIMITDATE" id="NEW_INSUR_LIMITDATE" type="text" class="form-control"
                                            maxlength="50" placeholder="如承保期限无误无须填写" />
                                    </div>
                                    </div>-->
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            学号</label>
                                        <div class="col-sm-4">
                                            <input name="STU_NUMBER" id="STU_NUMBER" type="text" class="form-control" placeholder="学号" />
                                        </div>

                                        <label class="col-sm-2 control-label">
                                            姓名</label>
                                        <div class="col-sm-4">
                                            <input name="STU_NAME" id="STU_NAME" type="text" class="form-control" placeholder="姓名" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            院系</label>
                                        <div class="col-sm-4">
                                            <select class="form-control" name="XY" id="XY" d_value='' ddl_name='ddl_department'
                                                show_type='t'>
                                            </select>
                                        </div>

                                        <label class="col-sm-2 control-label">
                                            专业</label>
                                        <div class="col-sm-4">
                                            <select class="form-control" name="ZY" id="ZY" d_value='' ddl_name='ddl_zy' show_type='t'>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            年级</label>
                                        <div class="col-sm-4">
                                            <select class="form-control" name="GRADE" id="GRADE" d_value='' ddl_name='ddl_grade'
                                                show_type='t'>
                                            </select>
                                        </div>

                                        <label class="col-sm-2 control-label">
                                            班级</label>
                                        <div class="col-sm-4">
                                            <select class="form-control" name="CLASS_CODE" id="CLASS_CODE" d_value='' ddl_name='ddl_class'
                                                show_type='t'>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            入学时间</label>
                                        <div class="col-sm-4">
                                            <input name="STU_ENTERTIME" id="STU_ENTERTIME" type="text" class="form-control" maxlength="50"
                                                placeholder="入学时间" />
                                        </div>
                                    </div>
                                </div>
                                <div class="box-header with-border">
                                    <h3 class="box-title">核对参保部分</h3>
                                </div>
                                <div class="box-body">
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            是否申请弃保</label>
                                        <div class="col-sm-4">
                                            <select class="form-control" name="IS_REFUND" id="IS_REFUND" d_value='' ddl_name='ddl_yes_no'
                                                show_type='t'>
                                            </select>
                                        </div>

                                        <label class="col-sm-2 control-label">
                                            手机号</label>
                                        <div class="col-sm-4">
                                            <input name="STU_PHONE" id="STU_PHONE" type="text" class="form-control" maxlength="20"
                                                placeholder="手机号" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            身份证号</label>
                                        <div class="col-sm-4">
                                            <input name="STU_IDNO" id="STU_IDNO" type="text" class="form-control" maxlength="20"
                                                placeholder="身份证号" />
                                        </div>

                                        <label class="col-sm-2 control-label">
                                            银行卡号</label>
                                        <div class="col-sm-4">
                                            <input name="STU_BANDKCODE" id="STU_BANDKCODE" type="text" class="form-control" maxlength="20"
                                                placeholder="银行卡号" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            缴费金额</label>
                                        <div class="col-sm-4">
                                            <input name="OLD_INSUR_MONEY" id="OLD_INSUR_MONEY" maxlength="15" type="text" class="form-control"
                                                placeholder="缴费金额" />
                                        </div>

                                        <label class="col-sm-2 control-label">
                                            更正后金额</label>
                                        <div class="col-sm-4">
                                            <input name="NEW_INSUR_MONEY" id="NEW_INSUR_MONEY" maxlength="15" type="text" class="form-control"
                                                placeholder="如缴费金额无误无须填写" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">参保人员类别</label>
                                        <div class="col-sm-4" id="dic_APPLY_TYPE">
                                            <select class="form-control" name="APPLY_TYPE" id="APPLY_TYPE" d_value='' ddl_name='ddl_apply_insur_type'
                                                show_type='t'>
                                            </select>
                                        </div>
                                        <!--</div>-->
                                        <div class="form-group col-sm-6" id="dic_APPLY_TYPE_LABEL">
                                            <label class="col-sm-12 control-label" style="text-align: left;">
                                            <label style="color: Red; font-size: 12px;">
                                                注：除普通在校生之外，都需到“附件”栏上传相应附件</label></label>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-2 control-label">
                                            备注</label>
                                        <div class="col-sm-10">
                                            <textarea class="form-control" id="REMARK" name="REMARK" rows="3" placeholder="当学生在信息核对时已经发生学籍异动，请辅导员代核并标注具体原因，如：学生已休学（退学、保留入学资格、保留学籍、转校等），由辅导员XXX代核。"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!--参保信息 结束-->
                            <!--附件及说明 开始-->
                            <div class="tab-pane" id="tab_2">
                              <div class="box box-solid" style="margin: 0; box-shadow: none;">
                                <div class="box-body">
                                  <div class="form-group">
                                      <label style="color: Red;">参保人员类别及缴费标准说明：</label>
                                  </div>
                                  <div class="form-group">
                                      <span style="text-indent: 2em;">&nbsp;&nbsp;&nbsp;&nbsp;在校学生采取财政统筹和个人缴纳相结合的方式，由学生本人按照年度一次性缴纳，2018年度标准为：
                                      </span>
                                  </div>
                                  <div class="form-group">
                                      <table border="1px;" style="text-align: center; vertical-align: middle; width: 95%;
                                          margin-left: 20px;">
                                          <tr style="display: none;">
                                              <td>
                                              </td>
                                              <td>
                                              </td>
                                              <td>
                                              </td>
                                          </tr>
                                          <tr>
                                              <td colspan="2" align="center">
                                                  参保人员类别
                                              </td>
                                              <td align="center">
                                                  个人缴费标准
                                              </td>
                                          </tr>
                                          <tr>
                                              <td rowspan="3">
                                                  在校学生
                                              </td>
                                              <td>
                                                  普通在校生
                                              </td>
                                              <td>
                                                  180元
                                              </td>
                                          </tr>
                                          <tr>
                                              <td>
                                                  低保对象、建档立卡贫困户
                                              </td>
                                              <td>
                                                  72元（政府补助108元）
                                              </td>
                                          </tr>
                                          <tr>
                                              <td>
                                                  重度残疾人、特困人员、农村落实计划生育政策的独生子女户和双女结扎户的在读子女
                                              </td>
                                              <td>
                                                  全额由政府补助缴费
                                              </td>
                                          </tr>
                                      </table>
                                  </div>
                                  <div class="form-group">
                                      <span style="text-indent: 2em;">
                                          <label>低保对象：</label>
                                          指持有《城乡居民最低生活保障救助证》（简称“低保证”）的学生（学生本人必须是低保证上标明的享受低保待遇人员和享受时间内）。未发放《低保证》的地区须出示城区或县以上民政部门的证明材料或低保对象审批表（县以上民政部门的审批表）；
                                      </span>
                                      <br />
                                      <span style="text-indent: 2em;">
                                          <label>建档立卡贫困户：</label>
                                          指持有完整版《广西脱贫攻坚精准帮扶手册》（2017年度）（贫困户保管）或《广西农村建档立卡扶贫对象证明（2017版）》的学生，《帮扶手册》只需提供乡（镇）党委、政府、贫困户承诺书签字页、贫困户家庭基本情况页即可；
                                      </span>
                                      <br />
                                      <span style="text-indent: 2em;">
                                          <label>重残残疾人：</label>
                                          指持有一级等级的《中国人民共和国残疾人证》（其中视力、智力残疾为一级和二级。）的学生，残疾证如未写明残疾级别的，请持证人（必须是学生本人）到残联办理级别认定；
                                      </span>
                                      <br />
                                      <span style="text-indent: 2em;">
                                          <label>特困人员：</label>
                                          指持有镇以上民政部门开具的可证明学生本人属于民政救助的特困人员的有关材料； </span>
                                      <br />
                                      <span style="text-indent: 2em;">
                                          <label>农村落实计划生育政策的独生子女户和双女结扎户的在读子女：</label>
                                          指的是具有农村户口的，持独生子女光荣证或二女结扎证明，证件或证明能显示学生与家长的关系的有关材料。 </span>
                                      <br />
                                      <span>&nbsp;&nbsp;&nbsp;&nbsp;以上符合条件的证明材料均需提供纸质版复印件一式一份，以学院为单位统一整理上报，由学校转报桂林市社保局审核通过后，学生方可按照政策享受相应优惠。
                                      </span>
                                  </div>
                                  <div class="form-group">
                                      <table id="tablelist_file" class="table table-bordered table-striped table-hover">
                                      </table>
                                  </div>
                                </div>
                              </div>
                            </div>
                            <!--附件及说明 开始-->
                        </div>
                    </div>
                </div>
                </form>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 遮罩层 开始-->
    <div class="maskBg">
    </div>
    <!-- 遮罩层 结束-->
    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "INSUR_NAME", "head": "保险名称", "type": "td-keep" },
                    { "data": "INSUR_TYPE_NAME", "head": "保险类型", "type": "td-keep" },
                    { "data": "INSUR_YEAR_NAME", "head": "项目学年", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "申请人姓名", "type": "td-keep" },
                    { "data": "CHECK_STEP_NAME", "head": "核对阶段", "type": "td-keep" },
                    { "data": "S_CHECK_TIME", "head": "学生核对时间", "type": "td-keep" },
                    { "data": "F_CHECK_TIME", "head": "辅导员核对时间", "type": "td-keep" },
                    { "data": "Y_CHECK_TIME", "head": "学院核对时间", "type": "td-keep" },
                    { "data": "CHECK_START", "head": "核对开始时间", "type": "td-keep" },
                    { "data": "CHECK_END", "head": "核对结束时间", "type": "td-keep" },
                    { "data": "OLD_INSUR_LIMITDATE", "head": "承保期限", "type": "td-keep" },
//                    { "data": "NEW_INSUR_LIMITDATE", "head": "核对后承保期限", "type": "td-keep" },
                    { "data": "OLD_INSUR_MONEY", "head": "缴费金额", "type": "td-keep" },
                    { "data": "NEW_INSUR_MONEY", "head": "更正后缴费金额", "type": "td-keep" },
                    { "data": "IS_REFUND_NAME", "head": "是否申请弃保", "type": "td-keep" },
                    { "data": "APPLY_TYPE_NAME", "head": "参保人员类别", "type": "td-keep" },
                    { "data": "XY_NAME", "head": "所属学院", "type": "td-keep" },
                    { "data": "ZY_NAME", "head": "所属专业", "type": "td-keep" },
                    { "data": "GRADE", "head": "所属年级", "type": "td-keep" },
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "CheckList.aspx?optype=getlist&from_page=check_check",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "统计查询导出",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
					    { "data": "INSUR_TYPE", "pre": "保险类型", "col": 2, "type": "select", "ddl_name": "ddl_insur_type" },
					    { "data": "INSUR_YEAR", "pre": "保险学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
                        { "data": "INSUR_SEQ_NO", "pre": "保险名称", "col": 4, "type": "select", "ddl_name": "ddl_insur_project" },
                        { "data": "XY", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 3, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 4, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 5, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 6, "type": "input" },
                        { "data": "CHECK_STEP", "pre": "核对阶段", "col": 4, "type": "select", "ddl_name": "ddl_apply_check_step" },
                        { "data": "IS_REFUND", "pre": "是否申请弃保", "col": 8, "type": "select", "ddl_name": "ddl_yes_no" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                <%if (IsShowBtn){ %>
                { type: "userDefined", id: "export_dif", title: "导出核对差异数据", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }, //20171016 ZZ 增加：新增需求
                {type: "userDefined", id: "download", title: "下载参保导入模板", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                <%} %>
                { type: "userDefined", id: "export", title: "导出核对数据", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //保险类型、学年、保险项目联动
            SelectUtils.Insur_Year_ProjectChange("search-INSUR_TYPE", "search-INSUR_YEAR", "search-INSUR_SEQ_NO", '', '', '');
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASS_CODE");
            //附件列表
            loadFileTableList();
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 附件列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadFileTableList() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "FILE_NAME", "head": "附件名称", "type": "td-keep" },
                    { "data": "FILE_TYPE_NAME", "head": "参保人员类别", "type": "td-keep" }
		    ];

            //配置表格
            fileList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "CheckFileList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_file", //表格id
                    buttonId: "buttonId_file", //拓展按钮区域id
                    tableTitle: "",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100]
                    }
                },
                //查询栏
                hasSearch: {
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: [
                { type: "userDefined", id: "reload_file", title: "刷新", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "view_file", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 附件列表JS 结束-->
    <!-- 按钮事件 开始-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _btns = {
                reload: '.btn-reload',
                search: '.btn-search'
            };
            //-----------主列表按钮---------------
            //【刷新】
            _content.on('click', _btns.search, function () {
                GetPerInfo();
            });
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //弹出核对信息界面
                        _form_edit.setFormData(data);
                        //获得学生基础信息
                        var studata = AjaxUtils.getResponseText("CheckList.aspx?optype=stuinfo&stu_num=" + data.STU_NUMBER);
                        if (studata) {
                            var studata_json = eval("(" + studata + ")");
                            $("#STU_ENTERTIME").val(studata_json.ENTERTIME);
                            $("#STU_PHONE").val(studata_json.MOBILENUM);
                            $("#STU_IDNO").val(studata_json.IDCARDNO);
                            $("#STU_BANDKCODE").val(studata_json.BANKCODE);
                        }
                        //判断保险项目类型，如果是“医保”类型，显示 参保人员类别 基础关联信息，如果不是则不显示
                        if (data.INSUR_TYPE != "A") { //A 医保
                            $('#ul_tabs li:eq(0) a').tab('show');
                            $("#li_tab_2").hide(); //隐藏“附件及说明”标签页
                            $("#dic_APPLY_TYPE").hide(); //隐藏“参保人员类别”栏目
                            $("#dic_APPLY_TYPE_LABEL").hide(); //隐藏“参保人员类别”栏目
                        }
                        else {
                            $('#ul_tabs li:eq(0) a').tab('show');
                            $("#li_tab_2").show();
                            $("#dic_APPLY_TYPE").show();
                            $("#dic_APPLY_TYPE_LABEL").show();
                        }
                        //ZZ 20171213 修改：更正后金额 如果为0，不显示
                        var NEW_INSUR_MONEY = $("#NEW_INSUR_MONEY").val();
                        if (NEW_INSUR_MONEY.length > 0) {
                            var nNEW_INSUR_MONEY = parseInt(NEW_INSUR_MONEY);
                            if (nNEW_INSUR_MONEY == 0)
                                $("#NEW_INSUR_MONEY").val("");
                        }

                        //不可编辑
                        _form_edit.disableAll();

                        fileList.refresh(OptimizeUtils.FormatUrl("CheckFileList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        _tableModal.modal();
                    }
                }
            });

            //【导出数据】
            _content.on('click', "#export", function () {
                //查询条件满足才可以导出
                var INSUR_TYPE = DropDownUtils.getDropDownValue("search-INSUR_TYPE");
                var INSUR_YEAR = DropDownUtils.getDropDownValue("search-INSUR_YEAR");
                var INSUR_SEQ_NO = DropDownUtils.getDropDownValue("search-INSUR_SEQ_NO");
                var XY = DropDownUtils.getDropDownValue("search-XY");
                if ("<%=IsSchool %>" == "true")//校级权限大
                {
                    if (!INSUR_TYPE || !INSUR_YEAR || !INSUR_SEQ_NO) {
                        easyAlert.timeShow({
                            "content": "保险类型、保险学年、保险名称，四者筛选条件不能为空！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
                else {
                    if (!INSUR_TYPE || !INSUR_YEAR || !INSUR_SEQ_NO || !XY) {
                        easyAlert.timeShow({
                            "content": "保险类型、保险学年、保险名称、学院，四者筛选条件不能为空！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
                var strq = GetUrlParam();
                var result = AjaxUtils.getResponseText("ResultList.aspx?optype=iscan_export" + strq);
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=insur_pro_checklist' + strq);
            });
            //【导出核对差异数据】
            _content.on('click', "#export_dif", function () {
                //查询条件满足才可以导出
                var INSUR_TYPE = DropDownUtils.getDropDownValue("search-INSUR_TYPE");
                var INSUR_YEAR = DropDownUtils.getDropDownValue("search-INSUR_YEAR");
                var INSUR_SEQ_NO = DropDownUtils.getDropDownValue("search-INSUR_SEQ_NO");
                var XY = DropDownUtils.getDropDownValue("search-XY");
                if ("<%=IsSchool %>" == "true")//校级权限大
                {
                    if (!INSUR_TYPE || !INSUR_YEAR || !INSUR_SEQ_NO) {
                        easyAlert.timeShow({
                            "content": "保险类型、保险学年、保险名称，四者筛选条件不能为空！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
                else {
                    if (!INSUR_TYPE || !INSUR_YEAR || !INSUR_SEQ_NO || !XY) {
                        easyAlert.timeShow({
                            "content": "保险类型、保险学年、保险名称、学院，四者筛选条件不能为空！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
                var strq = GetUrlParam();
                var result = AjaxUtils.getResponseText("ResultList.aspx?optype=iscan_export" + strq);
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=insur_pro_checklist_dif' + strq);
            });
            //【下载参保导入模板】
            _content.on('click', "#download", function () {
                //查询条件满足才可以导出
                var INSUR_TYPE = DropDownUtils.getDropDownValue("search-INSUR_TYPE");
                var INSUR_YEAR = DropDownUtils.getDropDownValue("search-INSUR_YEAR");
                var INSUR_SEQ_NO = DropDownUtils.getDropDownValue("search-INSUR_SEQ_NO");
                if (!INSUR_TYPE || !INSUR_YEAR || !INSUR_SEQ_NO) {
                    easyAlert.timeShow({
                        "content": "保险类型、保险学年、保险名称，三者筛选条件不能为空！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                var strq = GetUrlParam();
                var result = AjaxUtils.getResponseText("ResultList.aspx?optype=iscan_export" + strq);
                if (result.length > 0) {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=insur_pro_resultlist' + strq);
            });
            //ZZ 20171213 新增：需要上传附件
            //------------附件列表-----------------------
            //【刷新】
            _tableModal.on('click', "#reload_file", function () {
                fileList.reload();
            });
            //【查阅】
            _tableModal.on('click', "#view_file", function () {
                var data = fileList.selectSingle();
                if (data) {
                    if (data.OID) {
                        if (data.FILE_SAVE_NAME.length == 0) {
                            easyAlert.timeShow({
                                "content": "未上传附件！",
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                        var url = AjaxUtils.getResponseText("CheckFileList.aspx?optype=download&id=" + data.OID);
                        window.open(url);
                    }
                }
            });
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            DropDownUtils.initDropDown("INSUR_TYPE");
            DropDownUtils.initDropDown("INSUR_YEAR");
            DropDownUtils.initDropDown("XY");
            DropDownUtils.initDropDown("ZY");
            DropDownUtils.initDropDown("GRADE");
            DropDownUtils.initDropDown("CLASS_CODE");
            //获得百分比显示信息
            GetPerInfo();
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        function GetUrlParam() {
            var INSUR_TYPE = DropDownUtils.getDropDownValue("search-INSUR_TYPE");
            var INSUR_YEAR = DropDownUtils.getDropDownValue("search-INSUR_YEAR");
            var INSUR_SEQ_NO = DropDownUtils.getDropDownValue("search-INSUR_SEQ_NO");
            var XY = DropDownUtils.getDropDownValue("search-XY");
            var ZY = DropDownUtils.getDropDownValue("search-ZY");
            var GRADE = DropDownUtils.getDropDownValue("search-GRADE");
            var CLASS_CODE = DropDownUtils.getDropDownValue("search-CLASS_CODE");
            var STU_NUMBER = $("#search-STU_NUMBER").val();
            var STU_NAME = $("#search-STU_NAME").val();
            var CHECK_STEP = DropDownUtils.getDropDownValue("search-CHECK_STEP");
            var IS_REFUND = DropDownUtils.getDropDownValue("search-IS_REFUND");

            var strq = "";
            if (INSUR_TYPE)
                strq += "&INSUR_TYPE=" + INSUR_TYPE;
            if (INSUR_YEAR)
                strq += "&INSUR_YEAR=" + INSUR_YEAR;
            if (INSUR_SEQ_NO)
                strq += "&INSUR_SEQ_NO=" + INSUR_SEQ_NO;
            if (XY)
                strq += "&XY=" + XY;
            if (ZY)
                strq += "&ZY=" + ZY;
            if (GRADE)
                strq += "&GRADE=" + GRADE;
            if (CLASS_CODE)
                strq += "&CLASS_CODE=" + CLASS_CODE;
            if (STU_NUMBER)
                strq += "&STU_NUMBER=" + OptimizeUtils.FormatParamter(STU_NUMBER);
            if (STU_NAME)
                strq += "&STU_NAME=" + OptimizeUtils.FormatParamter(STU_NAME);
            if (CHECK_STEP)
                strq += "&CHECK_STEP=" + CHECK_STEP;
            if (IS_REFUND)
                strq += "&IS_REFUND=" + IS_REFUND;

            return strq;
        }

        //获得百分比显示信息
        function GetPerInfo() {
            var strq = GetUrlParam();
            var result = AjaxUtils.getResponseText("ResultList.aspx?optype=getper&" + strq);
            if (result.length > 0) {
                $("#div_Per").html(result);
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
