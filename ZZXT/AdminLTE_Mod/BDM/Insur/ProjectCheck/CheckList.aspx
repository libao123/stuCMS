<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="CheckList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectCheck.CheckList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList;
        var fileList;
        var _form_edit;
        var _form_check;
        var _form_refund;
        $(function () {
            adaptionHeight();
            //编辑页控制定义
            _form_edit = PageValueControl.init("form_edit");
            _form_check = PageValueControl.init("form_check");
            _form_refund = PageValueControl.init("form_refund");

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
			<h1>确认信息</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>保险管理</li>
				<li class="active">确认信息</li>
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
    <div class="modal fade" id="tableModal">
        <div class="modal-dialog modal-dw80">
            <div class="modal-content form-horizontal">
                <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">核对信息<label style="color: Red;">（“如学生基本信息有误，需到个人中心栏目进行信息维护，提交辅导员审核通过后更新生效”）</label></h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="CHECK_OID" name="CHECK_OID" value="" />
                    <input type="hidden" id="hidApplySeqNo" name="hidApplySeqNo" value="" />
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
                                    <!--<div class="form-group">
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
                                        <label class="col-sm-2 control-label">
                                            参保人员类别</label>
                                        <div class="col-sm-4" id="dic_APPLY_TYPE">
                                            <select class="form-control" name="APPLY_TYPE" id="APPLY_TYPE" d_value='' ddl_name='ddl_apply_insur_type'
                                                show_type='t'>
                                            </select>
                                        </div>
                                        <!--</div>-->
                                      <div class="col-sm-6" id="dic_APPLY_TYPE_LABEL">
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
                    <!--<button type="button" class="btn btn-primary btn-save" id="btnCheck">如信息有误，点击此按钮</button>-->
                    <button type="button" class="btn btn-primary btn-save" id="btnSave">确认提交</button>
                    <button type="button" class="btn btn-danger btn-refund" id="btnRefund">申请弃保</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 核对编辑界面 开始 -->
    <div class="modal fade" id="tableModal_Check">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_check" name="form_check" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    录入核对后信息<label style="color: Red;">（如学生基本信息有误，需到个人中心--信息维护栏目进行修改）</label></h4>
            </div>
            <div class="modal-body">
                <div class="box-header with-border">
                    <h3 class="box-title">承保期限</h3>
                </div>
                <div class="form-horizontal box-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            新承保期限</label>
                        <div class="col-sm-4">
                            <input name="NEW_INSUR_LIMITDATE_CHECK" id="NEW_INSUR_LIMITDATE_CHECK" type="text"
                                class="form-control" placeholder="新承保期限" maxlength="50" />
                        </div>

                        <label class="col-sm-2 control-label">
                            确认承保期限</label>
                        <div class="col-sm-4">
                            <input name="NEW_INSUR_LIMITDATE_CHECK_2" id="NEW_INSUR_LIMITDATE_CHECK_2" type="text"
                                class="form-control" placeholder="确认承保期限" maxlength="50" />
                        </div>
                    </div>
                </div>
                <div class="box-header with-border">
                    <h3 class="box-title">金额</h3>
                </div>
                <div class="form-horizontal box-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">新金额</label>
                        <div class="col-sm-4">
                            <input name="NEW_INSUR_MONEY_CHECK" id="NEW_INSUR_MONEY_CHECK" type="text" class="form-control"
                                placeholder="新金额" maxlength="18" />
                        </div>

                        <label class="col-sm-2 control-label">确认金额</label>
                        <div class="col-sm-4">
                            <input name="NEW_INSUR_MONEY_CHECK_2" id="NEW_INSUR_MONEY_CHECK_2" type="text" class="form-control"
                                placeholder="确认金额" maxlength="18" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnCheckInfo">确认</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 核对编辑界面 结束-->
    <!-- 附件上传编辑界面 开始 -->
    <div class="modal fade" id="tableModal_File">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_upload" name="form_upload" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">附件上传</h4>
            </div>
            <input type="hidden" id="hidRelationSeqNo_File" name="hidRelationSeqNo_File" value=""
                runat="server" />
            <div class="modal-body">

                    <iframe id="uploadFrame" frameborder="0" src="" style="width: 100%; height: 220px;">
                    </iframe>

            </div>
            </form>
        </div>
    </div>
    <!-- 附件上传编辑界面 结束-->
    <!-- 申请弃保编辑界面 开始 -->
    <div class="modal fade" id="tableModal_Refund">
        <div class="modal-dialog modal-dw80">
            <form action="#" method="post" id="form_refund" name="form_refund" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">申请弃保</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidRefond_Oid" name="hidRefond_Oid" value="" />
                <input type="hidden" id="hidRefond" name="hidRefond" value="" />
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        保险名称
                    </label>
                    <div class="col-sm-10">
                        <input name="INSUR_NAME_REFUND" id="INSUR_NAME_REFUND" type="text" class="form-control"
                            placeholder="项目名称" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        保险类型</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="INSUR_TYPE_REFUND" id="INSUR_TYPE_REFUND" d_value=''
                            ddl_name='ddl_insur_type' show_type='t'>
                        </select>
                    </div>

                    <label class="col-sm-2 control-label">
                        保险学年</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="INSUR_YEAR_REFUND" id="INSUR_YEAR_REFUND" d_value=''
                            ddl_name='ddl_year_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学号</label>
                    <div class="col-sm-4">
                        <input name="STU_NUMBER_REFUND" id="STU_NUMBER_REFUND" type="text" class="form-control"
                            placeholder="学号" />
                    </div>

                    <label class="col-sm-2 control-label">
                        姓名</label>
                    <div class="col-sm-4">
                        <input name="STU_NAME_REFUND" id="STU_NAME_REFUND" type="text" class="form-control"
                            placeholder="姓名" />
                    </div>
                </div>
                <div class="form-group">
                    <hr style="height: 0px; border-top: 1px solid #999; border-right: 0px; border-bottom: 0px;
                        border-left: 0px;"></hr>
                </div>
                <div class="form-group">
                    <label class="col-sm-8 control-label" style="text-align: left; color: Red;">
                        <input name="refond_checkbox" id="refond_1" type="checkbox" value="1" />&nbsp;&nbsp;<label
                            for="refond_1" style="font-weight: lighter;">（1）辅导员是否亲自与学生和家长确认学生本人已购买同类型医疗保险，保险名称为：</label></label>
                    <div class="col-sm-4">
                        <input name="REFUND_INSUR_NAME" id="REFUND_INSUR_NAME" type="text" class="form-control"
                            placeholder="填写保险名称" style="text-align: left;" maxlength="25" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label" style="text-align: left; color: Red;">
                        <input name="refond_checkbox" id="refond_2" type="checkbox" value="2" />&nbsp;&nbsp;<label
                            for="refond_2" style="font-weight: lighter;">（2）辅导员是否已征求家长意见，家长同意学生不在校购买医保；</label>
                    </label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label" style="text-align: left; color: Red;">
                        <input name="refond_checkbox" id="refond_3" type="checkbox" value="3" />&nbsp;&nbsp;<label
                            for="refond_3" style="font-weight: lighter;">（3）辅导员是否要求学生当面签署“放弃投保确认书”</label>
                    </label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSubmitRefund">确认退费</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 申请弃保编辑界面 结束-->
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
                    { "data": "F_CHECK_TIME", "head": "辅导员核对时间", "type": "td-keep"  },
                    { "data": "Y_CHECK_TIME", "head": "学院核对时间", "type": "td-keep"  },
                    { "data": "CHECK_START", "head": "核对开始时间", "type": "td-keep"  },
                    { "data": "CHECK_END", "head": "核对结束时间", "type": "td-keep"  },
                    { "data": "OLD_INSUR_LIMITDATE", "head": "承保期限", "type": "td-keep" },
                    //{ "data": "NEW_INSUR_LIMITDATE", "head": "更正后承保期限", "type": "td-keep" },
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
                    tableTitle: "确认核对信息",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': false, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(5)');
                            if (aData.CHECK_STEP == "1") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "warning",
                                        "msg": "学生已核对"
                                    });
                            }else if (aData.CHECK_STEP == "2") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "primary",
                                        "msg": "辅导员已核对"
                                    });
                            }else if (aData.CHECK_STEP == "3") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "学院已核对"
                                    });
                            }
                            else {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "未核对"
                                    });
                            }
                        }
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
                        { "data": "CHECK_STEP", "pre": "核对阶段", "col": 7, "type": "select", "ddl_name": "ddl_apply_check_step" },
                        { "data": "IS_REFUND", "pre": "是否申请弃保", "col": 8, "type": "select", "ddl_name": "ddl_yes_no" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                <%if(bIsShowBtnCheck) {%>
                { type: "userDefined", id: "check", title: "核对信息", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                <%} %>
                <%if(bIsShowBtnMulitCheck) {%>
                { type: "userDefined", id: "multi_check", title: "批量核对", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                <%} %>
                { type: "userDefined", id: "view", title: "查阅", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} }
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
                { type: "userDefined", id: "view_file", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "add_file", title: "上传附件", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del_file", title: "删除", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
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
            var _tableModal_Check = $("#tableModal_Check");
            var _tableModal_File = $("#tableModal_File");
            var _tableModal_Refund = $("#tableModal_Refund");
            var _btns = {
                reload: '.btn-reload'
            };
            //-----------主列表按钮---------------
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

                        if (data.CHECK_OID)
                            $("#CHECK_OID").val(data.CHECK_OID);
                        else
                            $("#CHECK_OID").val("");
                        $("#hidApplySeqNo").val(data.SEQ_NO);
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

                        //不可编辑
                        _form_edit.disableAll();
                        //隐藏按钮
                        //$("#btnCheck").hide();
                        $("#btnSave").hide();
                        $("#btnRefund").hide();

                        fileList.refresh(OptimizeUtils.FormatUrl("CheckFileList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        //隐藏附件列表按钮
                        $("#add_file").hide();
                        $("#del_file").hide();
                        _tableModal.modal();
                    }
                }
            });
            //【核对信息】
            _content.on('click', "#check", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //判断是否可以进行核对
                        var result = AjaxUtils.getResponseText("CheckList.aspx?optype=iscan_check&id=" + data.OID);
                        if (result.length > 0) {
                            easyAlert.timeShow({
                                "content": result,
                                "duration": 4,
                                "type": "danger"
                            });
                            return;
                        }
                        //弹出核对信息界面
                        //初始赋值
                        _form_edit.setFormData(data);
                        if (data.CHECK_OID)
                            $("#CHECK_OID").val(data.CHECK_OID);
                        else
                            $("#CHECK_OID").val("");
                        $("#hidApplySeqNo").val(data.SEQ_NO);
                        $("#<%=hidRelationSeqNo_File.ClientID %>").val(data.SEQ_NO);
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
                            $("#li_tab_2").hide(); //隐藏“附件及说明”标签页
                            $("#dic_APPLY_TYPE").hide(); //隐藏“参保人员类别”栏目
                            $("#dic_APPLY_TYPE_LABEL").hide(); //隐藏“参保人员类别”栏目
                        }
                        else {
                            $("#li_tab_2").show();
                            $("#dic_APPLY_TYPE").show();
                            $("#dic_APPLY_TYPE_LABEL").show();
                        }
                        //不可编辑
                        _form_edit.disableAll();
                        //3、核对页面不需要二次确认了，所以取消“如信息有误，点击此按钮”按键
                        $("#NEW_INSUR_MONEY").attr("disabled", false);
                        //备注可以编辑
                        //ZZ 20171122 修改：备注只有在辅导员看的时候可以编辑
                        if ("<%=user.User_Role %>" == "F") {
                            $("#REMARK").attr("disabled", false);
                        }
                        //ZZ 20171213 修改：手机号、身份证号、银行卡号、参保人员类别 在学生或者辅导员看的时候 可以编辑
                        if ("<%=user.User_Role %>" == "F" || "<%=user.User_Role %>" == "S") {
                            $("#STU_PHONE").attr("disabled", false);
                            $("#STU_BANDKCODE").attr("disabled", false);
                            $("#STU_IDNO").attr("disabled", false);
                            $("#APPLY_TYPE").attr("disabled", false);
                        }
                        //ZZ 20171213 修改：更正后金额 如果为0，不显示
                        var NEW_INSUR_MONEY = $("#NEW_INSUR_MONEY").val();
                        if (NEW_INSUR_MONEY.length > 0) {
                            var nNEW_INSUR_MONEY = parseInt(NEW_INSUR_MONEY);
                            if (nNEW_INSUR_MONEY == 0)
                                $("#NEW_INSUR_MONEY").val("");
                        }
                        //显示按钮
                        //$("#btnCheck").show();
                        $("#btnSave").show();
                        if ("<%=user.User_Role %>" == "F" && data.INSUR_TYPE == "A") {//辅导员核对，只对医保项目 才有【申请弃保】按钮显示
                            $("#btnRefund").show();
                        }
                        else {
                            $("#btnRefund").hide();
                        }
                        fileList.refresh(OptimizeUtils.FormatUrl("CheckFileList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        //显示附件列表按钮
                        $("#add_file").show();
                        $("#del_file").show();
                        _tableModal.modal();
                    }
                }
            });
            //【批量核对】
            _content.on('click', "#multi_check", function () {
                MultiCheck();
            });
            //-----------编辑界面 按钮---------------
            //【确认核对信息】
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });
            //【如信息有误，点击此按钮】
            _tableModal.on('click', "#btnCheck", function () {
                _form_check.reset();
                if ($("#NEW_INSUR_LIMITDATE").val().length > 0)
                    $("#NEW_INSUR_LIMITDATE_CHECK").val($("#NEW_INSUR_LIMITDATE").val());
                if ($("#NEW_INSUR_MONEY").val().length > 0)
                    $("#NEW_INSUR_MONEY_CHECK").val($("#NEW_INSUR_MONEY").val());
                _tableModal_Check.modal();
            });
            //-----------核对信息编辑界面 按钮---------------
            //【确认】
            _tableModal_Check.on('click', "#btnCheckInfo", function () {
                CheckInfo();
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
            //【上传附件】
            _tableModal.on('click', "#add_file", function () {
                var CHECK_OID = $("#CHECK_OID").val();
                if (CHECK_OID.length == 0) {
                    easyAlert.timeShow({
                        "content": "请先保存参保信息再进行添加附件操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                var APPLY_TYPE = DropDownUtils.getDropDownValue("APPLY_TYPE");
                if (APPLY_TYPE.length == 0) {
                    easyAlert.timeShow({
                        "content": "请先选择参保人员类别再进行添加附件操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                $("#uploadFrame").attr("src", "CheckFileUpload.aspx?seq_no=" + $("#<%=hidRelationSeqNo_File.ClientID %>").val() + "&apply_type=" + APPLY_TYPE);
                _tableModal_File.modal();
            });
            //【删除附件】
            _tableModal.on('click', "#del_file", function () {
                DeleteData_File();
            });
            //ZZ 20171213 新增：申请弃保 功能
            //【申请弃保】
            _tableModal.on('click', "#btnRefund", function () {
                var OID = $("#CHECK_OID").val();
                if (OID.length == 0) {
                    easyAlert.timeShow({
                        "content": "请先保存核对信息！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }

                _form_refund.reset();
                $("#hidRefond_Oid").val(OID);
                if ($("#INSUR_NAME").val().length > 0)
                    $("#INSUR_NAME_REFUND").val($("#INSUR_NAME").val());
                var INSUR_TYPE = DropDownUtils.getDropDownValue("INSUR_TYPE");
                if (INSUR_TYPE) {
                    DropDownUtils.setDropDownValue("INSUR_TYPE_REFUND", INSUR_TYPE);
                }
                var INSUR_YEAR = DropDownUtils.getDropDownValue("INSUR_YEAR");
                if (INSUR_YEAR) {
                    DropDownUtils.setDropDownValue("INSUR_YEAR_REFUND", INSUR_YEAR);
                }
                if ($("#STU_NUMBER").val().length > 0)
                    $("#STU_NUMBER_REFUND").val($("#STU_NUMBER").val());
                if ($("#STU_NAME").val().length > 0)
                    $("#STU_NAME_REFUND").val($("#STU_NAME").val());

                $("#INSUR_NAME_REFUND").attr("disabled", true);
                $("#INSUR_TYPE_REFUND").attr("disabled", true);
                $("#INSUR_YEAR_REFUND").attr("disabled", true);
                $("#STU_NUMBER_REFUND").attr("disabled", true);
                $("#STU_NAME_REFUND").attr("disabled", true);

                $("#refond_1").iCheck("check"); //iCheck绑定
                $("#refond_2").iCheck("check"); //iCheck绑定
                $("#refond_3").iCheck("check"); //iCheck绑定

                _tableModal_Refund.modal();
            });
            //【确认退费】
            _tableModal_Refund.on('click', "#btnSubmitRefund", function () {
                SubmitRefund();
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
            DropDownUtils.initDropDown("APPLY_TYPE");
            DropDownUtils.initDropDown("IS_REFUND");
            //申请弃保 界面
            DropDownUtils.initDropDown("INSUR_TYPE_REFUND");
            DropDownUtils.initDropDown("INSUR_YEAR_REFUND");
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
            //设置选中改变事件
            $("input[type='checkbox'][name='refond_checkbox']").on('ifChanged', function (event) {
                GetCheckBoxSelected();
            });
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //输入校验
            LimitUtils.onlyNumAlpha("STU_IDNO"); //身份证号
            LimitUtils.onlyNum("STU_PHONE"); //手机号
            LimitUtils.onlyNum("STU_BANDKCODE"); //银行卡号

            LimitUtils.onlyNumAndPoint("NEW_INSUR_MONEY");
            LimitUtils.onlyNumAndPoint("NEW_INSUR_MONEY_CHECK"); //代码限制只能录入数字与小数点
            LimitUtils.onlyNumAndPoint("NEW_INSUR_MONEY_CHECK_2"); //代码限制只能录入数字与小数点
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        function CheckInfo() {
            //校验数据
            var NEW_INSUR_LIMITDATE_CHECK = $("#NEW_INSUR_LIMITDATE_CHECK").val();
            var NEW_INSUR_LIMITDATE_CHECK_2 = $("#NEW_INSUR_LIMITDATE_CHECK_2").val();
            var NEW_INSUR_MONEY_CHECK = $("#NEW_INSUR_MONEY_CHECK").val();
            var NEW_INSUR_MONEY_CHECK_2 = $("#NEW_INSUR_MONEY_CHECK_2").val();
            //承保期限
            if (NEW_INSUR_LIMITDATE_CHECK.length > 0) {
                if (NEW_INSUR_LIMITDATE_CHECK_2.length == 0) {
                    easyAlert.timeShow({
                        "content": "确认承保期限必填！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                if (NEW_INSUR_LIMITDATE_CHECK != NEW_INSUR_LIMITDATE_CHECK_2) {
                    easyAlert.timeShow({
                        "content": "输入的两次承保期限必须一致！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            }
            //金额
            if (NEW_INSUR_MONEY_CHECK.length > 0) {
                if (NEW_INSUR_MONEY_CHECK_2.length == 0) {
                    easyAlert.timeShow({
                        "content": "确认金额必填！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                if (NEW_INSUR_MONEY_CHECK != NEW_INSUR_MONEY_CHECK_2) {
                    easyAlert.timeShow({
                        "content": "输入的两次金额必须一致！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            }
            //反填数据
            if (NEW_INSUR_LIMITDATE_CHECK.length > 0)
                $("#NEW_INSUR_LIMITDATE").val(NEW_INSUR_LIMITDATE_CHECK);
            if (NEW_INSUR_MONEY_CHECK.length > 0)
                $("#NEW_INSUR_MONEY").val(NEW_INSUR_MONEY_CHECK);
            $("#tableModal_Check").modal('hide');
        }
        //保存数据
        function SaveData() {
            //校验核对前、核对后的数据，必须要有一个有数据
            //var OLD_INSUR_LIMITDATE = $("#OLD_INSUR_LIMITDATE").val();
            //var NEW_INSUR_LIMITDATE = $("#NEW_INSUR_LIMITDATE").val();
            var OLD_INSUR_MONEY = $("#OLD_INSUR_MONEY").val();
            var NEW_INSUR_MONEY = $("#NEW_INSUR_MONEY").val();
            //            if (OLD_INSUR_LIMITDATE.length == 0 && NEW_INSUR_LIMITDATE.length == 0) {
            //                easyAlert.timeShow({
            //                    "content": "核对前、核对后的承保期限不能都为空！",
            //                    "duration": 2,
            //                    "type": "info"
            //                });
            //                return;
            //            }
            if (OLD_INSUR_MONEY.length == 0 && NEW_INSUR_MONEY.length == 0) {
                easyAlert.timeShow({
                    "content": "核对前、核对后的金额不能都为空！",
                    "duration": 2,
                    "type": "info"
                });
                return;
            }
            //校验身份证号录入是否正确
            var STU_IDNO = $("#STU_IDNO").val();
            if (STU_IDNO) {
                //校验身份证号是否符合规则
                var result_id = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=check_idnumber&idno=' + STU_IDNO);
                if (result_id.length > 0) {
                    easyAlert.timeShow({
                        "content": "身份证格式不正确！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            }
            //判断保险项目类型，如果是“医保”类型，显示 参保人员类别 基础关联信息，如果不是则不显示
            var INSUR_TYPE = DropDownUtils.getDropDownValue("INSUR_TYPE");
            if (INSUR_TYPE == "A") {
                //ZZ 20171213 新增：参保人员类别
                var APPLY_TYPE = DropDownUtils.getDropDownValue("APPLY_TYPE");
                if (APPLY_TYPE.length == 0) {
                    easyAlert.timeShow({
                        "content": "参保人员类别必填！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                //校验是否上传了附件
                if (APPLY_TYPE != "A") {
                    var result = AjaxUtils.getResponseText("CheckFileList.aspx?optype=check&id=" + $("#CHECK_OID").val());
                    if (result.length > 0) {
                        easyAlert.timeShow({
                            "content": "参保人员类别除普通在校生之外，都需到“附件”栏上传相应附件！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                }
            }

            //弹出遮罩层
            //$('.maskBg').show();
            //ZENG.msgbox.show("提交核对信息中，请稍后...", 6);
            var layInx = layer.load(2, {
              content: "提交核对信息中，请稍后...",
              shade: [0.3,'#000'], //0.1透明度的白色背景
              time: 6000
            });
            //取消不可编辑
            _form_edit.cancel_disableAll();
            $.post(OptimizeUtils.FormatUrl("CheckList.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    //表头保存成功之后 保存表体
                    var msg_json = eval("(" + msg + ")");
                    $("#CHECK_OID").val(msg_json.OID);
                    $("#hidApplySeqNo").val(msg_json.SEQ_NO);
                    $("#<%=hidRelationSeqNo_File.ClientID %>").val(msg_json.SEQ_NO);
                    fileList.refresh(OptimizeUtils.FormatUrl("CheckFileList.aspx?optype=getlist&seq_no=" + msg_json.SEQ_NO));

                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    layer.close(layInx);
                    $("#tableModal").modal('hide');
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload(); //刷新列表
                    return;
                }
                else {
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    layer.close(layInx);
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            });
        }
        //批量核对
        function MultiCheck() {
            if ('<%=user.User_Role %>' != 'X') {
                if (strOids.length == 0) {
                    easyAlert.timeShow({
                        "content": "请选择数据项！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            }
            //ZZ 20171220 修改：
            //院级、辅导员“核对阶段”为必选，上一级已核的批量生效。
            //学生未核的辅导员批量核对无效，提示“学生未核对，无法批量核对信息，需辅导员逐个代核”。
            //辅导员未核的，院级批量处理时无效，提示“辅导员未核对，院级无法进行核对。”
            var CHECK_STEP = $("#search-CHECK_STEP").val();
            if (CHECK_STEP.length == 0) {
                easyAlert.timeShow({
                    "content": "请选择确认核对的阶段再进行核对！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            if (('<%=user.User_Role %>' == 'F') && (CHECK_STEP == '')) {
                easyAlert.timeShow({
                    "content": "学生未核对，无法批量核对信息，需辅导员逐个代核！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            if (('<%=user.User_Role %>' == 'Y') && (CHECK_STEP == '1')) {
                easyAlert.timeShow({
                    "content": "辅导员未核对，院级无法进行核对！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            //查询栏
            var urlParam = GetSearchUrlParam();
            //列表勾选
            var strOids = "";
            var datas = mainList.selection();
            if (datas) {
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i]) {
                        if (datas[i].OID) {
                            strOids += datas[i].OID + ",";
                        }
                    }
                }
            }
            var postData = { "SELECT_OID": strOids };
            var url = "CheckList.aspx?optype=multi_check" + urlParam;
            //$('.maskBg').show();
            //ZENG.msgbox.show("批量核对中，请稍后...", 6);
            var layInx = layer.load(2, {
              content: "批量核对中，请稍后...",
              shade: [0.3,'#000'], //0.1透明度的白色背景
              time: 6000
            });
            $.ajax({
                cache: false,
                type: "POST",
                url: url,
                async: false,
                data: postData,
                success: function (result) {
                    if (result) {
                        //$('.maskBg').hide();
                        //ZENG.msgbox.hide();
                        layer.close(layInx);
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "info"
                        });
                        mainList.reload();
                        return;
                    }
                }
            });
        }

        //获得查询条件中的参数
        function GetSearchUrlParam() {
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

            return strq;
        }

        //删除附件
        function DeleteData_File() {
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除所选的数据吗？",
                'title': '删除上传附件信息',
                'callback': function (btn) {
                    var data = fileList.selectSingle();
                    if (data) {
                        if (data.OID) {
                            var url = "CheckFileList.aspx?optype=delete&id=" + data.OID;
                            var result = AjaxUtils.getResponseText(url);
                            if (result.length > 0) {
                                $(".Confirm_Div").modal("hide");
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }
                            else {
                                //保存成功：关闭界面，刷新列表
                                $(".Confirm_Div").modal("hide");
                                easyAlert.timeShow({
                                    "content": "删除成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                fileList.reload();
                            }
                        }
                    }
                }
            });
        }

        //确认退费
        function SubmitRefund() {
            //校验 保险名称 是否填写？
            var REFUND_INSUR_NAME = $("#REFUND_INSUR_NAME").val();
            if (REFUND_INSUR_NAME.length == 0) {
                easyAlert.timeShow({
                    "content": "请填写保险名称！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            GetCheckBoxSelected();
            //校验是否勾选 退费款项
            var hidRefond = $("#hidRefond").val();
            if (hidRefond.length == 0) {
                easyAlert.timeShow({
                    "content": "必须选择勾选项！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            //提交
            //$('.maskBg').show();
            //ZENG.msgbox.show("确认退费中，请稍后...", 6);
            var layInx = layer.load(2, {
              content: "确认退费中，请稍后...",
              shade: [0.3,'#000'], //0.1透明度的白色背景
              time: 6000
            });
            $.post(OptimizeUtils.FormatUrl("CheckList.aspx?optype=save_refund"), $("#form_refund").serialize(), function (msg) {
                if (msg.length == 0) {
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    layer.close(layInx);
                    $("#tableModal_Refund").modal('hide');
                    easyAlert.timeShow({
                        "content": "退费成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload(); //刷新列表
                    //退费成功，给 是否申请弃保 界面字段赋值
                    DropDownUtils.setDropDownValue("IS_REFUND", "Y");
                    return;
                }
                else {
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    layer.close(layInx);
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    //退费失败，给 是否申请弃保 界面字段赋值
                    DropDownUtils.setDropDownValue("IS_REFUND", "N");
                    return;
                }
            });
        }

        //选择 退费款项
        function GetCheckBoxSelected() {
            var checkbox = "";
            $("#hidRefond").val("");
            $("input[type='checkbox'][name='refond_checkbox']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).val() + ',';
                }
            });
            if (checkbox.length > 0) {
                $("#hidRefond").val(checkbox);
            }
        }
        //附件上传时，调用父界面的刷新方法，所以父界面这个方法一定要定义
        function UploadReload() {
            fileList.reload();
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
