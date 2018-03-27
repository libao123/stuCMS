<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="Edit.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectApply.Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .datepicker
        {
            z-index: 9999;
        }
    </style>
    <script type="text/javascript">
        var familymemberList;
        var rewardList;
        var studyList;
        var fileList; //附件列表
        var _form_edit;
        var _div_ProjectInfo;
        var _form_familymember;
        var _form_studylist;
        var _form_reward;
        var _user_role = "<%=user.User_Role %>";
        $(function () {
            adaptionHeight();
            //编辑页控制定义
            _form_edit = PageValueControl.init("form_edit");
            _div_ProjectInfo = PageValueControl.init("div_ProjectInfo");
            _div_StudentInfo = PageValueControl.init("div_StudentInfo");
            _form_familymember = PageValueControl.init("form_familymember");
            _form_studylist = PageValueControl.init("form_studylist");
            _form_reward = PageValueControl.init("form_reward");
            //初始化
            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
            //时间控件
            $(".datep").datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                language: "zh-CN"
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 编辑界面 开始  form-inline-->
    <div class="modal in" id="editDiv" style="z-index: 1042; display: block; overflow-y: auto;">
      <div class="modal-dialog modal-dw100" style="margin:0;">
        <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
          <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close" id="btnTopClose"><span aria-hidden="true">×</span></button>
              <h4 class="modal-title">填写奖助申请表格</h4>
          </div>
          <div class="modal-body">

              <div id="" class="box box-default" style="border: none; margin: 0;">
                  <input type="hidden" id="hidOid" name="hidOid" value="" />
                  <input type="hidden" id="hidSeqNo" name="hidSeqNo" value="" />
                  <input type="hidden" id="hidProjectSeqNo" name="hidProjectSeqNo" value="" />
                  <div class="nav-tabs-custom" style="box-shadow: none; margin-bottom: 0px;">
                      <ul class="nav nav-tabs">
                          <li id="tab_head" class="active"><a href="#tab_1" data-toggle="tab">基本信息</a></li>
                          <li id="tab_family"><a href="#tab_2" data-toggle="tab">家庭情况</a></li>
                          <li id="tab_reward"><a href="#tab_3" data-toggle="tab">获奖情况</a></li>
                          <li id="tab_study"><a href="#tab_4" data-toggle="tab">学习情况</a></li>
                          <li id="tab_model"><a href="#tab_5" data-toggle="tab">先进事迹</a></li>
                          <li id="tab_file"><a href="#tab_6" data-toggle="tab">附件上传</a></li>
                          <li id="tab_approveinfo"><a href="#tab_7" data-toggle="tab">评审情况</a></li>
                      </ul>
                      <div class="tab-content">
                          <!--基本信息 开始-->
                          <div class="tab-pane active" id="tab_1">
                              <div class="box-header with-border">
                                  <h3 class="box-title">项目信息</h3>
                              </div>
                              <div class="box-body" id="div_ProjectInfo">
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">
                                          项目级别</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="PROJECT_CLASS" id="PROJECT_CLASS" d_value='' ddl_name='ddl_jz_project_class' show_type='t'>
                                          </select>
                                      </div>
                                      <label class="col-sm-2 control-label">
                                          申请表格类型</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="PROJECT_TYPE" id="PROJECT_TYPE" d_value='' ddl_name='ddl_jz_project_type' show_type='t'>
                                          </select>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">
                                          项目学年</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="PROJECT_YEAR" id="PROJECT_YEAR" d_value='' ddl_name='ddl_year_type' show_type='t'>
                                          </select>
                                      </div>
                                      <label class="col-sm-2 control-label">
                                          项目金额</label>
                                      <div class="col-sm-4">
                                          <input name="PROJECT_MONEY" id="PROJECT_MONEY" type="text" class="form-control" placeholder="项目金额" />
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">
                                          项目名称</label>
                                      <div class="col-sm-10">
                                          <input name="PROJECT_NAME" id="PROJECT_NAME" type="text" class="form-control" placeholder="项目名称" />
                                      </div>
                                  </div>
                              </div>
                              <div class="box-header with-border">
                                  <h3 class="box-title">学生信息</h3>
                              </div>
                              <div class="box-body" id="div_StudentInfo">
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">学号</label>
                                      <div class="col-sm-4">
                                        <input name="STU_NUMBER" id="STU_NUMBER" type="text" class="form-control" placeholder="学号" />
                                      </div>

                                      <label class="col-sm-2 control-label">姓名</label>
                                      <div class="col-sm-4">
                                        <input name="STU_NAME" id="STU_NAME" type="text" class="form-control" placeholder="姓名" />
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">院系</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="XY" id="XY" d_value='' ddl_name='ddl_department' show_type='t'>
                                          </select>
                                      </div>

                                      <label class="col-sm-2 control-label">专业</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="ZY" id="ZY" d_value='' ddl_name='ddl_zy' show_type='t'>
                                          </select>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">年级</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="GRADE" id="GRADE" d_value='' ddl_name='ddl_grade' show_type='t'>
                                          </select>
                                      </div>

                                      <label class="col-sm-2 control-label">班级</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="CLASS_CODE" id="CLASS_CODE" d_value='' ddl_name='ddl_class' show_type='t'>
                                          </select>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">出生年月</label>
                                      <div class="col-sm-4">
                                          <input name="GARDE" id="GARDE" type="text" class="form-control" placeholder="出生年月" />
                                      </div>

                                      <label class="col-sm-2 control-label">入学时间</label>
                                      <div class="col-sm-4">
                                          <input name="ENTERTIME" id="ENTERTIME" type="text" class="form-control" placeholder="入学时间" />
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">民族</label>
                                      <div class="col-sm-4">
                                          <input name="NATION" id="NATION" type="text" class="form-control" placeholder="民族" />
                                      </div>

                                      <label class="col-sm-2 control-label">籍贯</label>
                                      <div class="col-sm-4">
                                          <input name="NATIVEPLACE" id="NATIVEPLACE" type="text" class="form-control" placeholder="籍贯" />
                                      </div>
                                  </div>
                                  <div class="form-group">
                                          <label class="col-sm-2 control-label">政治面貌</label>
                                          <div class="col-sm-4">
                                              <input name="POLISTATUS" id="POLISTATUS" type="text" class="form-control" placeholder="政治面貌" />
                                          </div>

                                          <label class="col-sm-2 control-label">学制</label>
                                          <div class="col-sm-4">
                                              <input name="SYSTEM" id="SYSTEM" type="text" class="form-control" placeholder="学制" />
                                          </div>
                                  </div>
                                  <div class="form-group">
                                          <label class="col-sm-2 control-label">联系电话</label>
                                          <div class="col-sm-4">
                                              <input name="MOBILENUM" id="MOBILENUM" type="text" class="form-control" placeholder="联系电话" />
                                          </div>

                                          <label class="col-sm-2 control-label">身份证号</label>
                                          <div class="col-sm-4">
                                              <input name="IDCARDNO" id="IDCARDNO" type="text" class="form-control" placeholder="身份证号" />
                                          </div>
                                  </div>
                              </div>
                              <div class="box-body" id="div_ProjectApplyInfo">
                                  <div class="form-group" id="div_POST_INFO">
                                          <label class="col-sm-2 control-label">曾/现任职情况</label>
                                          <div class="col-sm-10">
                                              <input name="POST_INFO" id="POST_INFO" type="text" class="form-control" placeholder="曾/现任职情况" />
                                          </div>
                                  </div>
                                  <div class="form-group">
                                      <div class="col-sm-6" id="div_REWARD_FLAG">
                                          <label class="col-sm-4 control-label">
                                              拟评何种类型</label>
                                          <div class="col-sm-8">
                                              <select class="form-control" name="REWARD_FLAG" id="REWARD_FLAG" d_value='' ddl_name='<%=m_RewardFlag %>'
                                                  show_type='t'>
                                              </select>
                                          </div>
                                      </div>
                                      <div class="col-sm-6" id="div_STUDY_LEVEL">
                                          <label class="col-sm-4 control-label">
                                              学习阶段</label>
                                          <div class="col-sm-8">
                                              <select class="form-control" name="STUDY_LEVEL" id="STUDY_LEVEL" d_value='' ddl_name='ddl_apply_study_level'
                                                  show_type='t'>
                                              </select>
                                          </div>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <!-- <div class="col-sm-6" id="div_TRAIN_TYPE"> -->
                                          <label class="col-sm-2 control-label">培养方式</label>
                                          <div class="col-sm-4" id="div_TRAIN_TYPE">
                                              <select class="form-control" name="TRAIN_TYPE" id="TRAIN_TYPE" d_value='' ddl_name='ddl_apply_train_type' show_type='t'>
                                              </select>
                                          </div>
                                      <!-- </div>
                                      <div class="col-sm-6" id="div_HARD_FOR"> -->
                                          <label class="col-sm-2 control-label">攻读学位</label>
                                          <div class="col-sm-4" id="div_HARD_FOR">
                                              <input name="HARD_FOR" id="HARD_FOR" type="text" class="form-control" placeholder="攻读学位" />
                                          </div>
                                      <!-- </div> -->
                                  </div>
                                  <div class="form-group" id="div_BASIC_UNIT">
                                      <!-- <div class="col-sm-12" id="div_BASIC_UNIT"> -->
                                          <label class="col-sm-2 control-label">基层单位</label>
                                          <div class="col-sm-10">
                                              <input name="BASIC_UNIT" id="BASIC_UNIT" type="text" class="form-control" placeholder="基层单位" />
                                          </div>
                                      <!-- </div> -->
                                  </div>
                              </div>
                              <div class="box-header with-border" id="div_title_APPLY_REASON">
                                  <h3 class="box-title"><label id="lab_txt_APPLY_REASON">申请理由</label><label id="lab_showmsg_APPLY_REASON"></label></h3>
                              </div>
                              <div class="box-body" id="div_APPLY_REASON">
                                  <div class="form-group">
                                          <textarea class="form-control" id="APPLY_REASON" name="APPLY_REASON" rows="5" placeholder="申请理由语句要通顺，有条理，无错别字，排版美观。不能排版到第二页。同年级同专业的两个获奖学生申请理由不能照搬。不能用申请书的格式，如出现尊敬的领导，此致敬礼等，也不能简单罗列本人奖励、履职等信息，还有不能将家庭贫困作为主要申请理由，不能只描述个人的家庭经济情况，应该从德、智、体等方面综合表述，如实反映学生成绩优异、社会实践创新能力突出及其他优秀事迹。"></textarea>
                                  </div>
                              </div>
                              <div class="box-header with-border" id="div_title_SKILL_INFO">
                                  <h3 class="box-title"><label>英语、计算机过级情况</label></h3>
                              </div>
                              <div class="box-body" id="div_SKILL_INFO">
                                  <div class="form-group">
                                          <textarea class="form-control" id="SKILL_INFO" name="SKILL_INFO" rows="5" placeholder="英语、计算机过级情况"></textarea>
                                  </div>
                              </div>
                              <div class="box-header with-border" id="div_title_PUBLISH_INFO">
                                  <h3 class="box-title">
                                      <label>
                                          论文发表、获得专利等情况</label></h3>
                              </div>
                              <div class="box-body" id="div_PUBLISH_INFO">
                                  <div class="form-group">
                                      <!-- <div class="col-sm-12"> -->
                                          <textarea class="form-control" id="PUBLISH_INFO" name="PUBLISH_INFO" rows="5" placeholder="论文发表、获得专利等情况"></textarea>
                                      <!-- </div> -->
                                  </div>
                              </div>
                          </div>
                          <!--基本信息 结束-->
                          <!--家庭情况 开始-->
                          <div class="tab-pane" id="tab_2">
                              <div class="box-header with-border">
                                  <h3 class="box-title">家庭基本信息</h3>
                                  <button type="button" class="btn btn-danger" id="update_familymember">同步数据</button>
                              </div>
                              <div class="form-horizontal box-body">
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">家庭户口</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="HK" id="HK" d_value='' ddl_name='ddl_stu_basic_hk'
                                              show_type='t'>
                                          </select>
                                      </div>
                                      <label class="col-sm-2 control-label">收入来源</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="INCOME_SOURCE" id="INCOME_SOURCE" d_value='' ddl_name='ddl_apply_incomsource'
                                              show_type='t'>
                                          </select>
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">
                                          家庭年总收入</label>
                                      <div class="col-sm-4">
                                          <input name="TOTAL_INCOME" id="TOTAL_INCOME" type="text" class="form-control" placeholder="家庭年总收入" />
                                      </div>

                                      <label class="col-sm-2 control-label">
                                          人均月收入</label>
                                      <div class="col-sm-4">
                                          <input name="PREMONTH_INCOME" id="PREMONTH_INCOME" type="text" class="form-control"
                                              placeholder="人均月收入" />
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">
                                          家庭人口数</label>
                                      <div class="col-sm-4">
                                          <input name="FAMILY_NUM" id="FAMILY_NUM" type="text" class="form-control" placeholder="家庭人口数" />
                                      </div>

                                      <label class="col-sm-2 control-label">
                                          邮政编码</label>
                                      <div class="col-sm-4">
                                          <input name="POSTCODE" id="POSTCODE" type="text" class="form-control" placeholder="邮政编码" />
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">
                                          家庭地址</label>
                                      <div class="col-sm-10">
                                          <input name="ADDRESS" id="ADDRESS" type="text" class="form-control" placeholder="家庭地址" />
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">
                                          认定情况</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="COGRIZA_INFO" id="COGRIZA_INFO" d_value='' ddl_name='ddl_dst_level'
                                              show_type='t'>
                                          </select>
                                      </div>

                                      <label class="col-sm-2 control-label">
                                          是否建档立卡</label>
                                      <div class="col-sm-4">
                                          <select class="form-control" name="IS_JDLK" id="IS_JDLK" d_value='' ddl_name='ddl_yes_no'
                                              show_type='t'>
                                          </select>
                                      </div>
                                  </div>
                              </div>
                              <div class="box-header with-border">
                                  <h3 class="box-title">家庭成员信息</h3>
                              </div>
                              <div class="form-horizontal box-body">
                                  <table id="tablelist_familymember" class="table table-bordered table-striped table-hover">
                                  </table>
                              </div>
                          </div>
                          <!--家庭情况 开始-->
                          <!--获奖情况 开始-->
                          <div class="tab-pane" id="tab_3">
                              <table id="tablelist_reward" class="table table-bordered table-striped table-hover">
                              </table>
                          </div>
                          <!--获奖情况 开始-->
                          <!--学习情况 开始-->
                          <div class="tab-pane" id="tab_4">
                              <div class="box-header with-border">
                                  <h3 class="box-title">上学年度综合考评成绩</h3>
                                  <button type="button" class="btn btn-danger" id="update_study">同步数据</button>
                              </div>
                              <div class="form-horizontal box-body">
                                  <div class="form-group" >
                                      <label class="col-sm-2 control-label">
                                          成绩排名：名次</label>
                                      <div class="col-sm-4" id="div_SCORE_RANK">
                                          <input name="SCORE_RANK" id="SCORE_RANK" type="text" class="form-control" placeholder="成绩排名：名次" />
                                      </div>

                                      <label class="col-sm-2 control-label">
                                          总人数</label>
                                      <div class="col-sm-4" id="div_SCORE_TOTAL_NUM">
                                          <input name="SCORE_TOTAL_NUM" id="SCORE_TOTAL_NUM" type="text" class="form-control"
                                              placeholder="成绩排名：总人数" />
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">
                                          是否实行综合考试排名</label>
                                      <div class="col-sm-4" id="div_IS_SCORE_FLAG">
                                          <select class="form-control" name="IS_SCORE_FLAG" id="IS_SCORE_FLAG" d_value='' ddl_name='ddl_yes_no'
                                              show_type='t'>
                                          </select>
                                      </div>

                                      <label class="col-sm-2 control-label">
                                          个人达标综合考评成绩</label>
                                      <div class="col-sm-4" id="div_COM_SCORE">
                                          <input name="COM_SCORE" id="COM_SCORE" type="text" class="form-control" placeholder="个人达标综合考评成绩" />
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">
                                          综合考评排名：名次</label>
                                      <div class="col-sm-4" id="div_COM_SCORE_RANK">
                                          <input name="COM_SCORE_RANK" id="COM_SCORE_RANK" type="text" class="form-control"
                                              placeholder="综合考评排名：名次" />
                                      </div>

                                      <label class="col-sm-2 control-label">
                                          总人数</label>
                                      <div class="col-sm-4" id="div_COM_SCORE_TOTAL_NUM">
                                          <input name="COM_SCORE_TOTAL_NUM" id="COM_SCORE_TOTAL_NUM" type="text" class="form-control"
                                              placeholder="综合考评排名：总人数" />
                                      </div>
                                  </div>
                                  <div class="form-group">
                                      <label class="col-sm-2 control-label">
                                          学年平均成绩</label>
                                      <div class="col-sm-4" id="div_PREYEAR_SCORE">
                                          <input name="PREYEAR_SCORE" id="PREYEAR_SCORE" type="text" class="form-control" placeholder="学年平均成绩" />
                                      </div>

                                      <label class="col-sm-2 control-label">
                                          必修课 / 门</label>
                                      <div class="col-sm-4" id="div_MUST_COURSE_NUM">
                                          <input name="MUST_COURSE_NUM" id="MUST_COURSE_NUM" type="text" class="form-control"
                                              placeholder="必修课 / 门" />
                                      </div>
                                  </div>
                                  <div class="form-group" id="div_PASS_COURSE_NUM">
                                      <label class="col-sm-2 control-label">
                                          其中及格以上 / 门</label>
                                      <div class="col-sm-4">
                                          <input name="PASS_COURSE_NUM" id="PASS_COURSE_NUM" type="text" class="form-control"
                                              placeholder="其中及格以上 / 门" />
                                      </div>
                                  </div>
                              </div>
                              <div class="box-header with-border" id="div_title_tablelist_study">
                                  <h3 class="box-title">上学年度科目成绩</h3>
                              </div>
                              <div class="form-group">
                                  <label class="col-sm-12 control-label" style="text-align: left; color: Red;">
                                      说明：本研学生均须填写4门以上科目成绩，保研、研三等实际无成绩者或不够4门者除外。</label>
                              </div>
                              <div class="form-horizontal box-body" id="list_tablelist_study">
                                  <table id="tablelist_study" class="table table-bordered table-striped table-hover">
                                  </table>
                              </div>
                          </div>
                          <!--学习情况 开始-->
                          <!--先进事迹 开始-->
                          <div class="tab-pane" id="tab_5">
                              <div class="box-header with-border">
                                  <h3 class="box-title">
                                      人生格言<label id="lab_showmsg_MOTTO"></label></h3>
                              </div>
                              <div class="box-body">
                                  <div class="form-group">
                                      <!-- <div class="col-sm-12"> -->
                                          <textarea class="form-control" id="MOTTO" name="MOTTO" rows="5" placeholder="人生格言"></textarea>
                                      <!-- </div> -->
                                  </div>
                              </div>
                              <div class="box-header with-border">
                                  <h3 class="box-title">
                                      师长点评<label id="lab_showmsg_TEACHER_INFO"></label></h3>
                              </div>
                              <div class="box-body">
                                  <div class="form-group">

                                          <textarea class="form-control" id="TEACHER_INFO" name="TEACHER_INFO" rows="5" placeholder="师长点评"></textarea>

                                  </div>
                              </div>
                              <div class="box-header with-border">
                                  <h3 class="box-title">
                                      事迹正文<label id="lab_showmsg_MODEL_INFO"></label></h3>
                              </div>
                              <div class="box-body">
                                  <div class="form-group">

                                          <textarea class="form-control" id="MODEL_INFO" name="MODEL_INFO" rows="10" placeholder="事迹正文"></textarea>

                                  </div>
                              </div>
                          </div>
                          <!--先进事迹 开始-->
                          <!--附件上传 开始-->
                          <div class="tab-pane" id="tab_6">
                              <table id="tablelist_file" class="table table-bordered table-striped table-hover">
                              </table>
                          </div>
                          <!--附件上传 开始-->
                          <!--评审情况 开始-->
                          <div class="tab-pane" id="tab_7">
                              <div class="box-header with-border">
                                  <h3 class="box-title">
                                      <label id="lab_RECOMM_REASON">
                                          推荐理由</label></h3>
                              </div>
                              <div class="box-body">
                                  <div class="form-group">

                                          <textarea class="form-control" id="RECOMM_REASON" name="RECOMM_REASON" rows="5" placeholder="推荐理由"></textarea>

                                  </div>
                              </div>
                              <div class="box-header with-border">
                                  <h3 class="box-title">
                                      <label id="lab_REVIEW_REASON">
                                          班级民主评议小组意见</label></h3>
                              </div>
                              <div class="box-body">
                                  <div class="form-group">

                                          <textarea class="form-control" id="REVIEW_REASON" name="REVIEW_REASON" rows="5" placeholder="班级民主评议小组意见"></textarea>

                                  </div>
                              </div>
                              <div class="box-header with-border">
                                  <h3 class="box-title">
                                      <label id="lab_COLLEGE_REASON">
                                          学院审核意见</label></h3>
                              </div>
                              <div class="box-body">
                                  <div class="form-group">

                                          <textarea class="form-control" id="COLLEGE_REASON" name="COLLEGE_REASON" rows="5"
                                              placeholder="学院审核意见"></textarea>

                                  </div>
                              </div>
                              <div class="box-header with-border">
                                  <h3 class="box-title">
                                      <label id="lab_SCHOOL_REASON">
                                          学校审核意见</label></h3>
                              </div>
                              <div class="box-body">
                                  <div class="form-group">

                                          <textarea class="form-control" id="SCHOOL_REASON" name="SCHOOL_REASON" rows="5" placeholder="学校审核意见"></textarea>

                                  </div>
                              </div>
                          </div>
                          <!--评审情况 开始-->
                      </div>
                  </div>
              </div>

          </div>
          <div class="modal-footer">
              <button type="button" class="btn btn-primary btn-save" id="btnApprove">审批</button>
              <button type="button" class="btn btn-primary btn-save" id="btnSave">保存</button>
              <button type="button" class="btn btn-primary btn-submit" id="btnSubmit">提交</button>
              <button type="button" class="btn btn-default pull-left" id="btnClose">关闭</button>
          </div>
        </form>
      </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 家庭成员编辑界面 开始 -->
    <div class="modal fade" id="tableModal_FamilyMember">
        <div class="modal-dialog">
            <form action="#" method="post" id="form_familymember" name="form_familymember" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">家庭成员</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidOid_FamilyMember" name="hidOid_FamilyMember" value="" />
                <input type="hidden" id="hidSeqNo_FamilyMember" name="hidSeqNo_FamilyMember" value="" />
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        姓名<span style="color: red">*</span></label>
                    <div class="col-sm-4">
                        <input name="MEMBER_NAME" id="MEMBER_NAME" type="text" class="form-control" placeholder="姓名"
                            maxlength="20" />
                    </div>

                    <label class="col-sm-2 control-label">
                        年龄<span style="color: red">*</span></label>
                    <div class="col-sm-4">
                        <input name="MEMBER_AGE" id="MEMBER_AGE" type="text" class="form-control" placeholder="年龄"
                            maxlength="3" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        关系<span style="color: red">*</span></label>
                    <div class="col-sm-4">
                        <input name="MEMBER_RELATION" id="MEMBER_RELATION" type="text" class="form-control"
                            placeholder="关系" maxlength="20" />
                    </div>

                    <label class="col-sm-2 control-label">
                        工作单位</label>
                    <div class="col-sm-4">
                        <input name="MEMBER_UNIT" id="MEMBER_UNIT" type="text" class="form-control" placeholder="工作单位"
                            maxlength="20" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnsave_familymember">保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 家庭成员编辑界面 结束-->
    <!-- 学习情况编辑界面 开始 -->
    <div class="modal fade" id="tableModal_StudyList">
        <div class="modal-dialog">
            <form action="#" method="post" id="form_studylist" name="form_studylist" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">科目成绩</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidOid_StudyList" name="hidOid_StudyList" value="" />
                <input type="hidden" id="hidSeqNo_StudyList" name="hidSeqNo_StudyList" value="" />
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        科目名称<span style="color: red">*</span></label>
                    <div class="col-sm-4">
                        <input name="COURSE_NAME" id="COURSE_NAME" type="text" class="form-control" placeholder="科目名称"
                            maxlength="20" />
                    </div>

                    <label class="col-sm-2 control-label">
                        成绩<span style="color: red">*</span></label>
                    <div class="col-sm-4">
                        <input name="SCORE" id="SCORE" type="text" class="form-control" placeholder="成绩"
                            maxlength="3" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnsave_studylist">保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 学习情况编辑界面 结束-->
    <!-- 获奖情况编辑界面 开始 -->
    <div class="modal fade" id="tableModal_Reward">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_reward" name="form_reward" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">获奖项目</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidOid_Reward" name="hidOid_Reward" value="" />
                <input type="hidden" id="hidSeqNo_Reward" name="hidSeqNo_Reward" value="" />
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        奖项名称<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <input name="REWARD_NAME" id="REWARD_NAME" type="text" class="form-control" placeholder="获奖项目名称"
                            maxlength="50" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        获奖学年<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="REWARD_DATE" id="REWARD_DATE" d_value='' ddl_name='ddl_year_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        颁奖单位<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <input name="AWARD_DEPARTMENT" id="AWARD_DEPARTMENT" type="text" class="form-control"
                            placeholder="颁奖单位" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        奖项类型<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="REWARD_TYPE" id="REWARD_TYPE" d_value='' ddl_name='ddl_apply_reward_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary btn-save" id="btnsave_reward">保存</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 获奖情况编辑界面 结束-->
    <!-- 附件上传编辑界面 开始 -->
    <div class="modal fade" id="tableModal_File">
        <div class="modal-dialog">
          <form id="form_upload" name="form_upload" class="modal-content form-horizontal" runat="server">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">附件上传</h4>
            </div>
            <input type="hidden" id="hidSeqNo_File" name="hidSeqNo_File" value="" runat="server" />
            <div class="modal-body">

                <iframe id="uploadFrame" frameborder="0" src="" style="width: 100%; height: 300px;"></iframe>

            </div>
          </form>
        </div>
    </div>
    <!-- 附件上传编辑界面 结束-->
    <!-- 审核界面 开始 -->
    <div class="modal fade" id="tableModal_Approve">
        <div class="modal-dialog">
          <form action="#" method="post" id="form_approve" name="form_approve" class="modal-content form-horizontal" onsubmit="return false;">
            <input type="hidden" id="hidOid_ForApprove" name="hidOid_ForApprove" value="" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">审核界面</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-4 control-label">审核结果</label>
                    <div class="col-sm-8">
                        <input type="radio" id="approvePass" class="flat-red" value="P" name="approveType"
                            checked />
                        <label for="approvePass" id="lab_approvePass" style="margin-right: 10px;">
                            通过</label><span>&nbsp;&nbsp;</span>
                        <input type="radio" id="approveNoPass" class="flat-red" value="N" name="approveType" />
                        <label for="approveNoPass" id="lab_approveNoPass" style="margin-right: 10px;">
                            不通过</label>
                    </div>
                </div>
                <div class="form-group" id="div_approveMsg">
                    <label class="col-sm-3 control-label" id="lab_approveMsg">
                        审核意见<label id="lab_approveMsg_showmsg"></label></label>
                    <div class="col-sm-9">
                        <textarea class="form-control" id="approveMsg" name="approveMsg" rows="5" cols=""></textarea>
                    </div>
                </div>
                <div class="form-group" id="div_comMsg">
                    <label class="col-sm-3 control-label" id="lab_comMsg">
                        评审意见<label id="lab_comMsg_showmsg"></label></label>
                    <div class="col-sm-9">
                        <textarea class="form-control" id="comMsg" name="comMsg" rows="5" cols=""></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary btn-save" id="btnSubmitApprove">确认</button>
            </div>
          </form>
        </div>
    </div>
    <!-- 审核界面 结束-->
    <!-- 上传附件材料说明 开始 -->
    <div class="modal fade" id="tableModal_RemarkFile">
        <div class="modal-dialog">
            <form action="#" method="post" class="modal-content" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">奖助学金申请者需上传附件材料注释</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-12 control-label">
                        申请本科生国家奖学金、三好学生标兵，研究生国家奖学金的学生需要根据自身实际情况提供相关佐证材料：
                    </label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label">注意：要求拍摄原件，图片格式上传</label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label">1、参评学年课程成绩表（要求加盖教务处或学院公章）；</label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label">2、英语、计算机过级证书；</label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label">3、其他与专业学习相关的资格等级证书；</label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label">4、省（区）级（含）以上与专业学习相关的获奖证书；</label>
                </div>
                <div class="form-group">
                    <label class="col-sm-12 control-label">5、已公开发表的论文刊物或其他相关作品。</label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 上传附件材料说明 结束-->
    <!-- 遮罩层 开始-->
    <div class="maskBg">
    </div>
    <!-- 遮罩层 结束-->
    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            loadTableList_FamilyMember();
            loadTableList_Study();
            loadTableList_Reward();
            loadTableList_File(); //附件列表
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 家庭成员列表JS 开始-->
    <script type="text/javascript">
        function loadTableList_FamilyMember() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "MEMBER_NAME", "head": "姓名", "type": "td-keep" },
				    { "data": "MEMBER_AGE", "head": "年龄", "type": "td-keep" },
				    { "data": "MEMBER_RELATION", "head": "关系", "type": "td-keep" },
				    { "data": "MEMBER_UNIT", "head": "工作单位", "type": "td-keep" }
		    ];

            //配置表格
            familymemberList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "FamilyMember.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_familymember", //表格id
                    buttonId: "buttonId_familymember", //拓展按钮区域id
                    tableTitle: "",
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
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: [
                <%if(!IsView) {%>
                { type: "userDefined", id: "reload_familymember", title: "刷新", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "add_familymember", title: "新增", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "edit_familymember", title: "修改", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del_familymember", title: "删除", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} }
                <%} %>
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 家庭成员列表JS 结束-->
    <!-- 获奖情况列表JS 开始-->
    <script type="text/javascript">
        function loadTableList_Reward() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "REWARD_NAME", "head": "奖项名称", "type": "td-keep" },
				    { "data": "REWARD_DATE_NAME", "head": "获奖学年", "type": "td-keep" },
                    { "data": "AWARD_DEPARTMENT", "head": "颁奖单位", "type": "td-keep" },
				    { "data": "REWARD_TYPE_NAME", "head": "奖项类型", "type": "td-keep" }
		    ];

            //配置表格
            rewardList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "RewardInfo.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_reward", //表格id
                    buttonId: "buttonId_reward", //拓展按钮区域id
                    tableTitle: "",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true //用户改变分页
                    }
                },
                //查询栏
                hasSearch: {
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: [
                <%if(!IsView) {%>
                { type: "userDefined", id: "update_reward", title: "同步数据", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "reload_reward", title: "刷新", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "add_reward", title: "新增", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "edit_reward", title: "修改", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del_reward", title: "删除", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} }
                <%} %>
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 获奖情况列表JS 结束-->
    <!-- 学习情况列表JS 开始-->
    <script type="text/javascript">
        function loadTableList_Study() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "COURSE_NAME", "head": "科目", "type": "td-keep" },
				    { "data": "SCORE", "head": "成绩", "type": "td-keep" }
		    ];

            //配置表格
            studyList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "StudyList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_study", //表格id
                    buttonId: "buttonId_study", //拓展按钮区域id
                    tableTitle: "",
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
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: [
                <%if(!IsView) {%>
                { type: "userDefined", id: "reload_study", title: "刷新", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "add_study", title: "新增", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "edit_study", title: "修改", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del_study", title: "删除", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} }
                <%} %>
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 学习情况列表JS 结束-->
    <!-- 附件列表JS 开始-->
    <script type="text/javascript">
        function loadTableList_File() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "FILE_TYPE_NAME", "head": "附件类型", "type": "td-keep" },
				    { "data": "FILE_NAME", "head": "附件名称", "type": "td-keep" }
		    ];

            //配置表格
            fileList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "FileList.aspx?optype=getlist",
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
                        'lengthChange': true //用户改变分页
                    }
                },
                //查询栏
                hasSearch: {
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: [
                { type: "userDefined", id: "remark_file", title: "上传附件材料说明", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "search_file", title: "查看附件", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                <%if(!IsView) {%>
                { type: "userDefined", id: "reload_file", title: "刷新", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "add_file", title: "新增", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del_file", title: "删除", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} }
                <%} %>
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
            //编辑页定义
            var _editDiv = $("#editDiv");
            var _tableModal_FamilyMember = $("#tableModal_FamilyMember");
            var _tableModal_StudyList = $("#tableModal_StudyList");
            var _tableModal_Reward = $("#tableModal_Reward");
            var _tableModal_Approve = $("#tableModal_Approve");
            var _tableModal_RemarkFile = $("#tableModal_RemarkFile");
            var _tableModal_File = $("#tableModal_File");
            //----------编辑页 按钮事件----------------
            //【关闭】
            _editDiv.on('click', "#btnClose", function () {
                parent.$("#editModal").modal("hide");
            });
            _editDiv.on('click', "#btnTopClose", function () {
                parent.$("#editModal").modal("hide");
            });
            //【保存】
            _editDiv.on('click', "#btnSave", function () {
                SaveData();
            });
            //【提交】
            _editDiv.on('click', "#btnSubmit", function () {
                SubmitData();
            });
            //【审核】
            _editDiv.on('click', "#btnApprove", function () {
                if ($("#hidOid_ForApprove").val().length == 0)
                    return;
                //默认审核意见
                var result = AjaxUtils.getResponseText("Edit.aspx?optype=getapproveinfo&id=" + $("#hidOid_ForApprove").val());
                if (result)
                    $("#approveMsg").val(result);
                _tableModal_Approve.modal();
            });
            //----------审核信息 按钮事件----------------
            //【确定】
            _tableModal_Approve.on('click', "#btnSubmitApprove", function () {
                ApproveData();
            });
            //----------家庭成员 按钮事件----------------
            //【同步数据】
            _editDiv.on('click', "#update_familymember", function () {
                //同步数据之前，需要确保数据已经进行保存操作
                if ($("#hidSeqNo").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "请保存数据之后再进行同步操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }

                easyConfirm.locationShow({
                    'type': 'warn',
                    'content': "同步个人信息中的家庭基本情况以及成员信息，会覆盖当前数据，确定同步吗？",
                    'title': '同步个人信息中的家庭基本情况以及成员信息',
                    'callback': function (btn) {
                        var result = AjaxUtils.getResponseText("FamilyInfo.aspx?optype=synchro&seq_no=" + $("#hidSeqNo").val());
                        if (result.length > 0) {//同步失败
                            $(".Confirm_Div").modal("hide");
                            easyAlert.timeShow({
                                "content": result,
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                        else {//同步成功
                            $(".Confirm_Div").modal("hide");
                            easyAlert.timeShow({
                                "content": "同步成功！",
                                "duration": 2,
                                "type": "success"
                            });
                            //家庭情况
                            var modidata_family = AjaxUtils.getResponseText('Edit.aspx?optype=getmodidata_family&seq_no=' + $("#hidSeqNo").val());
                            if (modidata_family) {
                                var modidata_family_json = eval("(" + modidata_family + ")");
                                _form_edit.setFormData(modidata_family_json);
                            }
                            //刷新家庭成员列表
                            familymemberList.refresh(OptimizeUtils.FormatUrl("FamilyMember.aspx?optype=getlist&seq_no=" + $("#hidSeqNo").val()));
                            return;
                        }
                    }
                });
            });
            //【刷新】
            _editDiv.on('click', "#reload_familymember", function () {
                familymemberList.reload();
            });
            //【新增】
            _editDiv.on('click', "#add_familymember", function () {
                if ($("#hidSeqNo").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "请先保存奖助申请信息再进行添加家庭成员操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                //设置界面值（清空界面值）
                _form_familymember.reset();
                //隐藏域赋值
                $("#hidOid_FamilyMember").val("");
                _tableModal_FamilyMember.modal();
            });
            //【修改】
            _editDiv.on('click', "#edit_familymember", function () {
                Edit_FamilyMember_Load();
            });
            //【删除】
            _editDiv.on('click', "#del_familymember", function () {
                DeleteData_FamilyMember();
            });
            //【保存】
            _tableModal_FamilyMember.on('click', "#btnsave_familymember", function () {
                SaveData_FamilyMember();
            });
            //----------获奖情况 按钮事件----------------
            //【同步数据】
            _editDiv.on('click', "#update_reward", function () {
                //同步数据之前，需要确保数据已经进行保存操作
                if ($("#hidSeqNo").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "请保存基础信息数据之后再进行同步操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }

                easyConfirm.locationShow({
                    'type': 'warn',
                    'content': "同步已审核通过的奖助信息，会覆盖当前数据，确定同步吗？",
                    'title': '同步已审核通过的奖助信息',
                    'callback': function (btn) {
                        var result = AjaxUtils.getResponseText("RewardInfo.aspx?optype=synchro&seq_no=" + $("#hidSeqNo").val());
                        if (result.length > 0) {//同步失败
                            $(".Confirm_Div").modal("hide");
                            easyAlert.timeShow({
                                "content": result,
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                        else {//同步成功
                            $(".Confirm_Div").modal("hide");
                            easyAlert.timeShow({
                                "content": "同步成功！",
                                "duration": 2,
                                "type": "success"
                            });
                            //刷新列表
                            rewardList.refresh(OptimizeUtils.FormatUrl("RewardInfo.aspx?optype=getlist&seq_no=" + $("#hidSeqNo").val()));
                            return;
                        }
                    }
                });
            });
            //【刷新】
            _editDiv.on('click', "#reload_reward", function () {
                rewardList.reload();
            });
            //【新增】
            _editDiv.on('click', "#add_reward", function () {
                if ($("#hidSeqNo").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "请先保存奖助申请信息再进行添加获奖信息操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                //设置界面值（清空界面值）
                _form_reward.reset();
                //隐藏域赋值
                $("#hidOid_Reward").val("");
                _tableModal_Reward.modal();
            });
            //【修改】
            _editDiv.on('click', "#edit_reward", function () {
                Edit_Reward_Load();
            });
            //【删除】
            _editDiv.on('click', "#del_reward", function () {
                DeleteData_Reward();
            });
            //【保存】
            _tableModal_Reward.on('click', "#btnsave_reward", function () {
                SaveData_Reward();
            });

            //----------学习情况 按钮事件----------------
            //【同步数据】
            _editDiv.on('click', "#update_study", function () {
                //同步数据之前，需要确保数据已经进行保存操作
                if ($("#hidSeqNo").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "请保存基本信息数据之后再进行同步操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }

                easyConfirm.locationShow({
                    'type': 'warn',
                    'content': "同步综合成绩测评管理中的成绩信息，会覆盖当前数据，确定同步吗？",
                    'title': '同步综合成绩测评管理中的成绩信息',
                    'callback': function (btn) {
                        var result = AjaxUtils.getResponseText("StudyInfo.aspx?optype=synchro&seq_no=" + $("#hidSeqNo").val());
                        if (result.length > 0) {//同步失败
                            $(".Confirm_Div").modal("hide");
                            easyAlert.timeShow({
                                "content": result,
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                        else {//同步成功
                            $(".Confirm_Div").modal("hide");
                            easyAlert.timeShow({
                                "content": "同步成功！",
                                "duration": 2,
                                "type": "success"
                            });
                            //学习情况
                            var modidata_study = AjaxUtils.getResponseText('Edit.aspx?optype=getmodidata_study&seq_no=' + $("#hidSeqNo").val());
                            if (modidata_study) {
                                var modidata_study_json = eval("(" + modidata_study + ")");
                                _form_edit.setFormData(modidata_study_json);
                            }
                            //刷新成绩列表
                            studyList.refresh(OptimizeUtils.FormatUrl("StudyList.aspx?optype=getlist&seq_no=" + $("#hidSeqNo").val()));
                            return;
                        }
                    }
                });
            });
            //【刷新】
            _editDiv.on('click', "#reload_study", function () {
                studyList.reload();
            });
            //【新增】
            _editDiv.on('click', "#add_study", function () {
                if ($("#hidSeqNo").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "请先保存奖助申请信息再进行添加科目成绩操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }

                //设置界面值（清空界面值）
                _form_studylist.reset();
                //隐藏域赋值
                $("#hidOid_StudyList").val("");
                _tableModal_StudyList.modal();
            });
            //【修改】
            _editDiv.on('click', "#edit_study", function () {
                Edit_StudyList_Load();
            });
            //【删除】
            _editDiv.on('click', "#del_study", function () {
                DeleteData_StudyList();
            });
            //【保存】
            _tableModal_StudyList.on('click', "#btnsave_studylist", function () {
                SaveData_StudyList();
            });
            //----------附件上传 按钮事件----------------
            //上传附件材料说明
            _editDiv.on('click', "#remark_file", function () {
                _tableModal_RemarkFile.modal();
            });
            //【查看附件】
            _editDiv.on('click', "#search_file", function () {
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
                        var url = AjaxUtils.getResponseText("FileList.aspx?optype=download&id=" + data.OID);
                        window.open(url);
                    }
                }
            });
            //【刷新】
            _editDiv.on('click', "#reload_file", function () {
                fileList.reload();
            });
            //【新增】
            _editDiv.on('click', "#add_file", function () {
                if ($("#hidSeqNo").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "请先保存奖助申请信息再进行添加附件操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                $("#uploadFrame").attr("src", "FileUpload.aspx?seq_no=" + $("#<%=hidSeqNo_File.ClientID %>").val());
                _tableModal_File.modal();
            });
            //【删除】
            _editDiv.on('click', "#del_file", function () {
                DeleteData_File();
            });
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            //-------基本信息标签页------------
            DropDownUtils.initDropDown("PROJECT_CLASS");
            DropDownUtils.initDropDown("PROJECT_TYPE");
            DropDownUtils.initDropDown("PROJECT_YEAR");
            DropDownUtils.initDropDown("XY");
            DropDownUtils.initDropDown("ZY");
            DropDownUtils.initDropDown("GRADE");
            DropDownUtils.initDropDown("CLASS_CODE");
            DropDownUtils.initDropDown("REWARD_FLAG");
            DropDownUtils.initDropDown("STUDY_LEVEL");
            DropDownUtils.initDropDown("TRAIN_TYPE");
            //-------家庭情况标签页------------
            DropDownUtils.initDropDown("HK");
            DropDownUtils.initDropDown("INCOME_SOURCE");
            DropDownUtils.initDropDown("COGRIZA_INFO");
            DropDownUtils.initDropDown("IS_JDLK");
            //-------学习情况标签页------------
            DropDownUtils.initDropDown("IS_SCORE_FLAG");
            //-------获奖情况标签页------------
            DropDownUtils.initDropDown("REWARD_DATE");
            DropDownUtils.initDropDown("REWARD_TYPE");

            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
            ByOpTypeLoadEditPageData();
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //-------基本信息标签页------------
            //输入校验
            LimitUtils.onlyNumAndPoint("PROJECT_MONEY"); //代码限制只能录入数字与小数点
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "hidProjectSeqNo", true, "项目信息必填");
            ValidateUtils.setRequired("#form_edit", "STU_NUMBER", true, "学生信息必填");
            //-------家庭情况标签页------------
            //输入校验
            LimitUtils.onlyNumAndPoint("TOTAL_INCOME"); //代码限制只能录入数字与小数点
            LimitUtils.onlyNumAndPoint("PREMONTH_INCOME"); //代码限制只能录入数字与小数点
            LimitUtils.onlyNum("FAMILY_NUM"); //代码限制只能录入数字
            LimitUtils.onlyNum("POSTCODE"); //代码限制只能录入数字
            LimitUtils.onlyNum("MEMBER_AGE"); //代码限制只能录入数字
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "HK", true, "家庭户口必填");
            ValidateUtils.setRequired("#form_edit", "INCOME_SOURCE", true, "收入来源必填");
            ValidateUtils.setRequired("#form_familymember", "MEMBER_NAME", true, "姓名必填");
            ValidateUtils.setRequired("#form_familymember", "MEMBER_AGE", true, "年龄必填");
            ValidateUtils.setRequired("#form_familymember", "MEMBER_RELATION", true, "关系必填");
            //-------学习情况标签页------------
            LimitUtils.onlyNum("SCORE_RANK"); //代码限制只能录入数字
            LimitUtils.onlyNum("SCORE_TOTAL_NUM"); //代码限制只能录入数字
            LimitUtils.onlyNum("MUST_COURSE_NUM"); //代码限制只能录入数字
            LimitUtils.onlyNum("PASS_COURSE_NUM"); //代码限制只能录入数字
            LimitUtils.onlyNumAndPoint("COM_SCORE"); //代码限制只能录入数字与小数点
            LimitUtils.onlyNum("COM_SCORE_RANK"); //代码限制只能录入数字
            LimitUtils.onlyNum("COM_SCORE_TOTAL_NUM"); //代码限制只能录入数字
            LimitUtils.onlyNumAndPoint("PREYEAR_SCORE"); //代码限制只能录入数字与小数点
            LimitUtils.onlyNumAndPoint("SCORE"); //代码限制只能录入数字与小数点
            //必填项设置
            ValidateUtils.setRequired("#form_studylist", "COURSE_NAME", true, "科目名称必填");
            ValidateUtils.setRequired("#form_studylist", "SCORE", true, "成绩必填");

            //是否实行综合考试排名 选择改变事件
            $("#IS_SCORE_FLAG").change(function () {
                var IS_SCORE_FLAG_VALUE = DropDownUtils.getDropDownValue("IS_SCORE_FLAG");
                if (IS_SCORE_FLAG_VALUE.length > 0) {
                    if (IS_SCORE_FLAG_VALUE == "Y") {
                        $("#div_COM_SCORE_RANK").show(); //综合考评排名 / 名次
                        $("#div_COM_SCORE_TOTAL_NUM").show(); //综合考评排名 / 总人数
                    }
                    else {
                        $("#div_COM_SCORE_RANK").hide(); //综合考评排名 / 名次
                        $("#div_COM_SCORE_TOTAL_NUM").hide(); //综合考评排名 / 总人数
                    }
                }
            });
            //-------获奖情况标签页------------
            //必填项设置
            ValidateUtils.setRequired("#form_reward", "REWARD_NAME", true, "奖项名称必填");
            ValidateUtils.setRequired("#form_reward", "REWARD_DATE", true, "获奖学年必填");
            ValidateUtils.setRequired("#form_reward", "AWARD_DEPARTMENT", true, "颁奖单位必填");
            ValidateUtils.setRequired("#form_reward", "REWARD_TYPE", true, "奖项类型必填");
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //表体加载
        function LoadList(flag, seq_no) {
            if (flag == 'add') {
                familymemberList.refresh(OptimizeUtils.FormatUrl("FamilyMember.aspx?optype=getlist&seq_no="));
                studyList.refresh(OptimizeUtils.FormatUrl("StudyList.aspx?optype=getlist&seq_no="));
                rewardList.refresh(OptimizeUtils.FormatUrl("RewardInfo.aspx?optype=getlist&seq_no="));
                fileList.refresh(OptimizeUtils.FormatUrl("FileList.aspx?optype=getlist&seq_no="));
            }
            else {
                familymemberList.refresh(OptimizeUtils.FormatUrl("FamilyMember.aspx?optype=getlist&seq_no=" + seq_no));
                studyList.refresh(OptimizeUtils.FormatUrl("StudyList.aspx?optype=getlist&seq_no=" + seq_no));
                rewardList.refresh(OptimizeUtils.FormatUrl("RewardInfo.aspx?optype=getlist&seq_no=" + seq_no));
                fileList.refresh(OptimizeUtils.FormatUrl("FileList.aspx?optype=getlist&seq_no=" + seq_no));
            }
        }

        //根据新增、修改类型 初始化界面数据
        function ByOpTypeLoadEditPageData() {
            if ('<%=Request.QueryString["optype"] %>' == 'add') {//新增
                $("#hidProjectSeqNo").val('<%=Request.QueryString["project_seq_no"] %>');

                var projectdata = AjaxUtils.getResponseText('Edit.aspx?optype=getprojectdata&project_seq_no=<%=Request.QueryString["project_seq_no"] %>');
                if (projectdata) {
                    var projectdata_json = eval("(" + projectdata + ")");
                    _div_ProjectInfo.setFormData(projectdata_json);
                }
                var studata = AjaxUtils.getResponseText('Edit.aspx?optype=getstudata&stu_num=<%=user.User_Id %>');
                if (studata) {
                    var studata_json = eval("(" + studata + ")");
                    _div_StudentInfo.setFormData(studata_json);
                }
                LoadList('add', '');
            }
            else if ('<%=Request.QueryString["optype"] %>' == 'modi'//修改
            || '<%=Request.QueryString["optype"] %>' == 'view') {//查阅
                $("#hidOid").val('<%=Request.QueryString["id"] %>');
                $("#hidOid_ForApprove").val('<%=Request.QueryString["id"] %>');
                $("#hidSeqNo").val('<%=Request.QueryString["seq_no"] %>');
                $("#hidProjectSeqNo").val('<%=Request.QueryString["project_seq_no"] %>');
                //表体单据编号设置
                $("#hidSeqNo_FamilyMember").val('<%=Request.QueryString["seq_no"] %>');
                $("#hidSeqNo_StudyList").val('<%=Request.QueryString["seq_no"] %>');
                $("#hidSeqNo_Reward").val('<%=Request.QueryString["seq_no"] %>');
                $("#<%=hidSeqNo_File.ClientID %>").val('<%=Request.QueryString["seq_no"] %>');
                //表头
                var modidata_head = AjaxUtils.getResponseText('Edit.aspx?optype=getmodidata_head&id=<%=Request.QueryString["id"] %>');
                if (modidata_head) {
                    var modidata_head_json = eval("(" + modidata_head + ")");
                    _form_edit.setFormData(modidata_head_json);
                }
                var studata = AjaxUtils.getResponseText('Edit.aspx?optype=getstudata&stu_num=' + modidata_head_json.STU_NUMBER);
                if (studata) {
                    var studata_json = eval("(" + studata + ")");
                    _div_StudentInfo.setFormData(studata_json);
                }
                //家庭情况
                var modidata_family = AjaxUtils.getResponseText('Edit.aspx?optype=getmodidata_family&seq_no=<%=Request.QueryString["seq_no"] %>');
                if (modidata_family) {
                    var modidata_family_json = eval("(" + modidata_family + ")");
                    _form_edit.setFormData(modidata_family_json);
                }
                //学习情况
                var modidata_study = AjaxUtils.getResponseText('Edit.aspx?optype=getmodidata_study&seq_no=<%=Request.QueryString["seq_no"] %>');
                if (modidata_study) {
                    var modidata_study_json = eval("(" + modidata_study + ")");
                    _form_edit.setFormData(modidata_study_json);
                }
                if (modidata_study_json.IS_SCORE_FLAG == "Y") {
                    $("#div_COM_SCORE_RANK").show(); //综合考评排名 / 名次
                    $("#div_COM_SCORE_TOTAL_NUM").show(); //综合考评排名 / 总人数
                }
                else {
                    $("#div_COM_SCORE_RANK").hide(); //综合考评排名 / 名次
                    $("#div_COM_SCORE_TOTAL_NUM").hide(); //综合考评排名 / 总人数
                }
                //大文本数据
                var modidata_txt = AjaxUtils.getResponseText('Edit.aspx?optype=getmodidata_txt&seq_no=<%=Request.QueryString["seq_no"] %>');
                if (modidata_txt) {
                    var modidata_txt_json = eval("(" + modidata_txt + ")");
                    _form_edit.setFormData(modidata_txt_json);
                }
                //随后加载学生剩余信息
                var studata = AjaxUtils.getResponseText('Edit.aspx?optype=getstudata');
                if (studata) {
                    var studata_json = eval("(" + studata + ")");
                    _div_StudentInfo.setFormData(studata_json);
                }
                LoadList('modi', $("#hidSeqNo").val());
            }
            LoadPageSet(DropDownUtils.getDropDownValue("PROJECT_TYPE"));
            //设置不可编辑
            SetDisable();
            //查阅状态下  隐藏按钮
            HideBtn('<%=Request.QueryString["optype"] %>');
        }

        //隐藏按钮
        function HideBtn(optype) {
            if (optype == 'view') {
                //编辑页
                //是否显示审核按钮
                if ("<%=m_strIsShowAuditBtn %>" == "true") {
                    $("#btnApprove").show();
                }
                else {
                    $("#btnApprove").hide();
                }
                $("#btnSave").hide();
                $("#btnSubmit").hide();
                //家庭信息
                $("#btnsave_familymember").hide();
                //获奖信息
                $("#btnsave_reward").hide();
                //学习信息
                $("#btnsave_studylist").hide();
                //同步按钮
                $("#update_familymember").hide();
                $("#update_study").hide();
            }
            else {
                //编辑页
                $("#btnApprove").hide();
                $("#btnSave").show();
                $("#btnSubmit").show();
                //家庭信息
                $("#btnsave_familymember").show();
                //获奖信息
                $("#btnsave_reward").show();
                //学习信息
                $("#btnsave_studylist").show();
                //同步按钮
                $("#update_familymember").show();
                $("#update_study").show();
            }
        }

        //设置不可编辑
        function SetDisable() {
            _div_ProjectInfo.disableAll(); //项目信息不可编辑
            _div_StudentInfo.disableAll(); //学生信息不可编辑
            _tab_6 = PageValueControl.init("tab_7");
            _tab_6.disableAll(); //评审信息不可编辑
        }

        //------------------主界面 按钮操作 开始-----------------------------
        //【保存】
        function SaveData() {
            //弹出遮罩层
            //$('.maskBg').show();
            //ZENG.msgbox.show("保存中，请稍后...", 6);
            var layInx = layer.load(2, {
              content: "保存中，请稍后...",
              shade: [0.3,'#000'], //0.1透明度的白色背景
              time: 6000
            });
            //取消不可编辑
            _form_edit.cancel_disableAll();
            //保存 申请信息表头 之后 再保存 表体内容
            $.post(OptimizeUtils.FormatUrl("Edit.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length == 0) {
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    layer.close(layInx);
                    SetDisable();
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                else {
                    //表头保存成功之后 保存表体
                    var msg_json = eval("(" + msg + ")");
                    $("#hidOid").val(msg_json.OID);
                    $("#hidSeqNo").val(msg_json.SEQ_NO);
                    $("#hidProjectSeqNo").val(msg_json.PROJECT_SEQ_NO);
                    //表体单据编号设置
                    $("#hidSeqNo_FamilyMember").val(msg_json.SEQ_NO);
                    $("#hidSeqNo_StudyList").val(msg_json.SEQ_NO);
                    $("#hidSeqNo_Reward").val(msg_json.SEQ_NO);
                    $("#<%=hidSeqNo_File.ClientID %>").val(msg_json.SEQ_NO);
                    LoadList('modi', msg_json.SEQ_NO);
                    //------家庭情况 开始---------
                    $.post(OptimizeUtils.FormatUrl("FamilyInfo.aspx?optype=save&seq_no=" + msg_json.SEQ_NO), $("#form_edit").serialize(), function (msg) {
                        if (msg.length == 0) {
                            //------学习情况 开始---------
                            $.post(OptimizeUtils.FormatUrl("StudyInfo.aspx?optype=save&seq_no=" + msg_json.SEQ_NO), $("#form_edit").serialize(), function (msg) {
                                if (msg.length == 0) {
                                    //------大文本 开始---------
                                    $.post(OptimizeUtils.FormatUrl("TxtInfo.aspx?optype=save&seq_no=" + msg_json.SEQ_NO), $("#form_edit").serialize(), function (msg) {
                                        layer.close(layInx);
                                        if (msg.length == 0) {
                                            //全部保存成功
                                            //$('.maskBg').hide();
                                            //ZENG.msgbox.hide();
                                            SetDisable();
                                            easyAlert.timeShow({
                                                "content": "保存成功！",
                                                "duration": 2,
                                                "type": "success"
                                            });
                                            parent.EditSaveRefresh(msg_json.OID, msg_json.SEQ_NO, '<%=Request.QueryString["project_seq_no"] %>'); //刷新列表
                                            return;
                                        }
                                        else {
                                            //$('.maskBg').hide();
                                            //ZENG.msgbox.hide();
                                            SetDisable();
                                            easyAlert.timeShow({
                                                "content": msg,
                                                "duration": 2,
                                                "type": "danger"
                                            });
                                            return;
                                        }
                                    });
                                    //------大文本 结束---------
                                } else {
                                    //$('.maskBg').hide();
                                    //ZENG.msgbox.hide();
                                    layer.close(layInx);
                                    SetDisable();
                                    easyAlert.timeShow({
                                        "content": msg,
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                    return;
                                }
                            });
                            //------学习情况 结束---------
                        }
                        else {
                            //$('.maskBg').hide();
                            //ZENG.msgbox.hide();
                            layer.close(layInx);
                            SetDisable();
                            easyAlert.timeShow({
                                "content": msg,
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                    });
                    //------家庭情况 结束---------
                }
            });
        }

        //【提交】
        function SubmitData() {
            //校验必填项
            if (!$('#form_edit').valid()) {
                easyAlert.timeShow({
                    "content": "还有必填项未填写，请检查！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "提交之前请先进行保存操作，否则会造成数据丢失，确定提交吗？",
                'title': '提交之前请先进行保存操作',
                'callback': function (btn) {
                    //校验数据是否满足提交条件
                    var result = AjaxUtils.getResponseText("Edit.aspx?optype=iscan_submit&id=" + $("#hidOid").val());
                    if (result.length > 0) {
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 4,
                            "type": "danger"
                        });
                        return;
                    }
                    //弹出遮罩层
                    //$('.maskBg').show();
                    //ZENG.msgbox.show("提交中，请稍后...", 6);
                    var layInx = layer.load(2, {
                      content: "提交中，请稍后...",
                      shade: [0.3,'#000'], //0.1透明度的白色背景
                      time: 6000
                    });
                    //提交奖助申请
                    var result_submit = AjaxUtils.getResponseText("Edit.aspx?optype=submit&id=" + $("#hidOid").val());
                    if (result_submit.length > 0) {//提交失败
                        //$('.maskBg').hide();
                        //ZENG.msgbox.hide();
                        layer.close(layInx);
                        $(".Confirm_Div").modal("hide");
                        easyAlert.timeShow({
                            "content": result_submit,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    else { //提交成功
                        //$('.maskBg').hide();
                        //ZENG.msgbox.hide();
                        layer.close(layInx);
                        $(".Confirm_Div").modal("hide");
                        easyAlert.timeShow({
                            "content": "提交成功！",
                            "duration": 2,
                            "type": "success"
                        });
                        parent.$("#editModal").modal("hide");
                        parent.mainList.reload();
                        return;
                    }
                }
            });
        }
        //------------------主界面 按钮操作 结束-----------------------------

        //------------------家庭情况界面 按钮操作 开始-----------------------------
        //编辑
        function Edit_FamilyMember_Load() {
            var data = familymemberList.selectSingle();
            if (data) {
                if (data.OID) {
                    _form_familymember.setFormData(data);
                    //隐藏域赋值
                    $("#hidOid_FamilyMember").val(data.OID);
                    $("#tableModal_FamilyMember").modal();
                }
                else {
                    //隐藏域赋值
                    $("#hidOid_FamilyMember").val("");
                }
            }
        }

        //保存事件
        function SaveData_FamilyMember() {
            //校验必填项
            if (!$('#form_familymember').valid())
                return;

            //$('.maskBg').show();
            //ZENG.msgbox.show("保存中，请稍后...", 6);
            var layInx = layer.load(2, {
              content: "保存中，请稍后...",
              shade: [0.3,'#000'], //0.1透明度的白色背景
              time: 6000
            });
            $.post(OptimizeUtils.FormatUrl("FamilyMember.aspx?optype=save"), $("#form_familymember").serialize(), function (msg) {
                layer.close(layInx);
                if (msg.length > 0) {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal_FamilyMember").modal("hide");
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    familymemberList.reload();
                    return;
                }
                else {
                    //$('.maskBg').hide();
                    //ZENG.msgbox.hide();
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            });
        }

        //删除
        function DeleteData_FamilyMember() {
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除所选的数据吗？",
                'title': '删除家庭成员',
                'callback': function (btn) {
                    var data = familymemberList.selectSingle();
                    if (data) {
                        if (data.OID) {
                            var url = "FamilyMember.aspx?optype=delete&id=" + data.OID;
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
                                familymemberList.reload();
                            }
                        }
                    }
                }
            });
        }
        //------------------家庭情况界面 按钮操作 结束-----------------------------

        //------------------学习情况界面 按钮操作 开始-----------------------------
        //编辑
        function Edit_StudyList_Load() {
            var data = studyList.selectSingle();
            if (data) {
                if (data.OID) {
                    _form_studylist.setFormData(data);
                    //隐藏域赋值
                    $("#hidOid_StudyList").val(data.OID);
                    $("#tableModal_StudyList").modal();
                }
                else {
                    //隐藏域赋值
                    $("#hidOid_StudyList").val("");
                }
            }
        }

        //保存事件
        function SaveData_StudyList() {
            //校验必填项
            if (!$('#form_studylist').valid())
                return;

            $.post(OptimizeUtils.FormatUrl("StudyList.aspx?optype=save"), $("#form_studylist").serialize(), function (msg) {
                if (msg.length > 0) {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal_StudyList").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    studyList.reload();
                    return;
                }
                else {
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            });
        }

        //删除
        function DeleteData_StudyList() {
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除所选的数据吗？",
                'title': '删除家庭成员',
                'callback': function (btn) {
                    var data = studyList.selectSingle();
                    if (data) {
                        if (data.OID) {
                            var url = "StudyList.aspx?optype=delete&id=" + data.OID;
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
                                studyList.reload();
                            }
                        }
                    }
                }
            });
        }
        //------------------学习情况界面 按钮操作 结束-----------------------------

        //------------------获奖情况界面 按钮操作 开始-----------------------------
        //编辑
        function Edit_Reward_Load() {
            var data = rewardList.selectSingle();
            if (data) {
                if (data.OID) {
                    _form_reward.setFormData(data);
                    //隐藏域赋值
                    $("#hidOid_Reward").val(data.OID);
                    $("#tableModal_Reward").modal();
                }
                else {
                    //隐藏域赋值
                    $("#hidOid_Reward").val("");
                }
            }
        }

        //保存事件
        function SaveData_Reward() {
            //校验必填项
            if (!$('#form_reward').valid())
                return;

            $.post(OptimizeUtils.FormatUrl("RewardInfo.aspx?optype=save"), $("#form_reward").serialize(), function (msg) {
                if (msg.length > 0) {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal_Reward").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    rewardList.reload();
                    return;
                }
                else {
                    easyAlert.timeShow({
                        "content": "保存失败！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            });
        }

        //删除
        function DeleteData_Reward() {
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除所选的数据吗？",
                'title': '删除获奖信息以及上传对应获奖附件',
                'callback': function (btn) {
                    var data = rewardList.selectSingle();
                    if (data) {
                        if (data.OID) {
                            var url = "RewardInfo.aspx?optype=delete&id=" + data.OID;
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
                                rewardList.reload();
                            }
                        }
                    }
                }
            });
        }
        //------------------获奖情况界面 按钮操作 结束-----------------------------

        //------------------审核界面 按钮操作 开始-----------------------------
        //确定
        function ApproveData() {
            //提交审核信息
            $.post(OptimizeUtils.FormatUrl("Edit.aspx?optype=submit_approve"), $("#form_approve").serialize(), function (msg) {
                if (msg.length == 0) {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal_Approve").modal("hide");
                    parent.$("#editModal").modal("hide");
                    parent.mainList.reload();
                    easyAlert.timeShow({
                        "content": "审核成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    return;
                }
                else {
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            });
        }
        //------------------审核界面 按钮操作 结束-----------------------------

        //------------------附件上传界面 按钮操作 开始-----------------------------
        //删除
        function DeleteData_File() {
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除所选的数据吗？",
                'title': '删除上传附件信息',
                'callback': function (btn) {
                    var data = fileList.selectSingle();
                    if (data) {
                        if (data.OID) {
                            var url = "FileList.aspx?optype=delete&id=" + data.OID;
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
        //------------------附件上传界面 按钮操作 结束-----------------------------
    </script>
    <%--根据项目类型实现界面的显示隐藏：开始--%>
    <script type="text/javascript">
        function LoadPageSet(projectType) {
            //标签显示初始化
            $("#tab_head").show();
            $("#tab_family").show();
            $("#tab_reward").show();
            $("#tab_study").show();
            $("#tab_model").show();
            $("#tab_approveinfo").show();
            $("#tab_file").show();
            //校验初始化
            ValidateUtils.setRequired("#form_edit", "POST_INFO", false, "");
            ValidateUtils.setRequired("#form_edit", "REWARD_FLAG", false, "");
            //根据项目类型实现界面的显示隐藏
            LoadPageSet_11(projectType);
            LoadPageSet_12_15(projectType);
            LoadPageSet_13_14_16(projectType);
            LoadPageSet_17(projectType);
            LoadPageSet_18(projectType);
            LoadPageSet_19(projectType);
            LoadPageSet_20_21(projectType);
            LoadPageSet_outline(projectType);
            //******控制录入文字长度*********************
            LoadPageSet_TxtInputNum(projectType);
        }
    </script>
    <%--COUNTRY_B：国家奖学金（本科）：表11+1,11+2--%>
    <script type="text/javascript">
        function LoadPageSet_11(projectType) {
            if (projectType == "COUNTRY_B") {
                //******界面******************
                //--------基本信息 界面-------
                $("#div_POST_INFO").hide(); //曾/现任职情况
                $("#div_REWARD_FLAG").hide(); //拟评何种类型
                $("#div_STUDY_LEVEL").hide(); //学习阶段
                $("#div_TRAIN_TYPE").hide(); //培养方式
                $("#div_HARD_FOR").hide(); //攻读学位
                $("#div_BASIC_UNIT").hide(); //基层单位
                //英语、计算机过级情况
                $("#div_title_SKILL_INFO").hide();
                $("#div_SKILL_INFO").hide();
                //论文发表、获得专利等情况
                $("#div_title_PUBLISH_INFO").hide();
                $("#div_PUBLISH_INFO").hide();
                $("#lab_txt_APPLY_REASON").text("申请理由");
                //--------学习信息 界面-------
                $("#div_COM_SCORE").hide(); //个人达标综合考评成绩
                $("#div_PREYEAR_SCORE").hide(); //学年平均成绩
                $("#div_COM_SCORE_RANK").hide(); //综合考评排名 / 名次
                $("#div_COM_SCORE_TOTAL_NUM").hide(); //综合考评排名 / 总人数
                //科目成绩列表
                $("#div_title_tablelist_study").hide();
                $("#list_tablelist_study").hide();
                //******标签页*******************
                //家庭情况
                $("#tab_family").hide();
                //******校验*******************
                ValidateUtils.setRequired("#form_edit", "POST_INFO", false, "");
                ValidateUtils.setRequired("#form_edit", "REWARD_FLAG", false, "");
                //******审核界面*******************
                $("#div_comMsg").hide(); //评审意见
                //通过角色显示不同的字面意思
                if (_user_role == "F")//辅导员
                {
                    $("#lab_approveMsg").text("推荐理由");
                    //控制文字
                    LimitUtils.onlyInputTheLength(100, "lab_approveMsg_showmsg", "approveMsg"); //审核信息(100字)
                }
                else if (_user_role == "Y")//学院
                {
                    $("#lab_approveMsg").text("学院审核意见");
                }
                else if (_user_role == "X")//学校
                {
                    $("#lab_approveMsg").text("学校审核意见");
                }
            }
        }
    </script>
    <%--COUNTRY_ENCOUR：国家励志奖学金：表12--%>
    <%--AREA_GOV：自治区人民政府奖学金：表15--%>
    <script type="text/javascript">
        function LoadPageSet_12_15(projectType) {
            if (projectType == "COUNTRY_ENCOUR"
            || projectType == "AREA_GOV") {
                //******界面******************
                //--------基本信息 界面-------
                $("#div_REWARD_FLAG").hide(); //拟评何种类型
                $("#div_STUDY_LEVEL").hide(); //学习阶段
                $("#div_TRAIN_TYPE").hide(); //培养方式
                $("#div_HARD_FOR").hide(); //攻读学位
                $("#div_BASIC_UNIT").hide(); //基层单位
                //英语、计算机过级情况
                $("#div_title_SKILL_INFO").hide();
                $("#div_SKILL_INFO").hide();
                //论文发表、获得专利等情况
                $("#div_title_PUBLISH_INFO").hide();
                $("#div_PUBLISH_INFO").hide();
                $("#lab_txt_APPLY_REASON").text("申请理由");
                //--------学习信息 界面-------
                $("#div_IS_SCORE_FLAG").show(); //是否实行综合考试排名
                DropDownUtils.setDropDownValue("IS_SCORE_FLAG", "Y"); //默认值：是
                if (DropDownUtils.getDropDownValue("IS_SCORE_FLAG") == "Y") {
                    $("#div_COM_SCORE_RANK").show(); //综合考评排名 / 名次
                    $("#div_COM_SCORE_TOTAL_NUM").show(); //综合考评排名 / 总人数
                }
                else {
                    $("#div_COM_SCORE_RANK").hide(); //综合考评排名 / 名次
                    $("#div_COM_SCORE_TOTAL_NUM").hide(); //综合考评排名 / 总人数
                }
                $("#div_PREYEAR_SCORE").hide(); //学年平均成绩
                //******标签页*******************
                //先进事迹
                $("#tab_model").hide();
                //******校验*******************
                ValidateUtils.setRequired("#form_edit", "POST_INFO", false, "");
                ValidateUtils.setRequired("#form_edit", "REWARD_FLAG", false, "");
                //******审核界面*******************
                $("#div_comMsg").hide(); //评审意见
                //通过角色显示不同的字面意思
                if (_user_role == "F")//辅导员
                {
                    $("#lab_approveMsg").text("班级民主评议小组意见");
                    //控制文字
                    LimitUtils.onlyInputRangeLength(90, 150, "lab_approveMsg_showmsg", "approveMsg"); //班级民主评议小组意见(90-150字)
                }
                else if (_user_role == "Y")//学院
                {
                    $("#lab_approveMsg").text("学院审核意见");
                }
                else if (_user_role == "X")//学校
                {
                    $("#lab_approveMsg").text("学校审核意见");
                }
            }
        }
    </script>
    <%--COUNTRY_FIRST：国家一等助学金：表13--%>
    <%--COUNTRY_SECOND：国家二等助学金：表14--%>
    <%--SOCIETY_OFFER：社会捐资类奖学金：表16--%>
    <script type="text/javascript">
        function LoadPageSet_13_14_16(projectType) {
            if (projectType == "COUNTRY_FIRST"
            || projectType == "COUNTRY_SECOND"
            || projectType == "SOCIETY_OFFER") {
                //******界面******************
                //--------基本信息 界面-------
                $("#div_REWARD_FLAG").hide(); //拟评何种类型
                $("#div_STUDY_LEVEL").hide(); //学习阶段
                $("#div_TRAIN_TYPE").hide(); //培养方式
                $("#div_HARD_FOR").hide(); //攻读学位
                $("#div_BASIC_UNIT").hide(); //基层单位
                //英语、计算机过级情况
                $("#div_title_SKILL_INFO").hide();
                $("#div_SKILL_INFO").hide();
                //论文发表、获得专利等情况
                $("#div_title_PUBLISH_INFO").hide();
                $("#div_PUBLISH_INFO").hide();
                $("#lab_txt_APPLY_REASON").text("申请理由");
                //--------学习信息 界面-------
                $("#div_IS_SCORE_FLAG").hide(); //是否实行综合考试排名
                $("#div_PREYEAR_SCORE").hide(); //学年平均成绩
                //******标签页*******************
                if (projectType != "SOCIETY_OFFER") {
                    //学习情况
                    $("#tab_study").hide();
                }
                //先进事迹
                $("#tab_model").hide();
                //******校验*******************
                ValidateUtils.setRequired("#form_edit", "POST_INFO", true, "曾/现任职情况必填");
                ValidateUtils.setRequired("#form_edit", "REWARD_FLAG", false, "");
                //******审核界面*******************
                $("#div_comMsg").hide(); //评审意见
                //通过角色显示不同的字面意思
                if (_user_role == "F")//辅导员
                {
                    $("#lab_approveMsg").text("班级民主评议小组意见");
                    //控制文字
                    LimitUtils.onlyInputRangeLength(90, 150, "lab_approveMsg_showmsg", "approveMsg"); //班级民主评议小组意见(90-150字)
                }
                else if (_user_role == "Y")//学院
                {
                    $("#lab_approveMsg").text("学院审核意见");
                }
                else if (_user_role == "X")//学校
                {
                    $("#lab_approveMsg").text("学校审核意见");
                }
            }
        }
    </script>
    <%--SCHOOL_GOOD：三好学生：表17+1--%>
    <%--SCHOOL_MODEL：三好学生标兵：表17+1,17+2,17+3--%>
    <script type="text/javascript">
        function LoadPageSet_17(projectType) {
            if (projectType == "SCHOOL_GOOD"
            || projectType == "SCHOOL_MODEL") {
                //******界面******************
                //--------基本信息 界面-------
                $("#div_STUDY_LEVEL").hide(); //学习阶段
                $("#div_TRAIN_TYPE").hide(); //培养方式
                $("#div_HARD_FOR").hide(); //攻读学位
                $("#div_BASIC_UNIT").hide(); //基层单位
                //英语、计算机过级情况
                $("#div_title_SKILL_INFO").hide();
                $("#div_SKILL_INFO").hide();
                //论文发表、获得专利等情况
                $("#div_title_PUBLISH_INFO").hide();
                $("#div_PUBLISH_INFO").hide();
                $("#lab_txt_APPLY_REASON").text("政治思想、纪律、体育锻炼表现");
                //--------学习信息 界面-------
                $("#div_IS_SCORE_FLAG").hide(); //是否实行综合考试排名
                $("#div_PREYEAR_SCORE").hide(); //学年平均成绩
                //******标签页*******************
                //家庭情况
                $("#tab_family").hide();
                if (projectType == "SCHOOL_GOOD") {
                    //先进事迹
                    $("#tab_model").hide();
                }
                //******校验*******************
                ValidateUtils.setRequired("#form_edit", "POST_INFO", true, "曾/现任职情况必填");
                ValidateUtils.setRequired("#form_edit", "REWARD_FLAG", true, "拟评何种类型必填");
                //******审核界面*******************
                $("#div_comMsg").hide(); //评审意见
                //通过角色显示不同的字面意思
                if (_user_role == "F")//辅导员
                {
                    $("#lab_approveMsg").text("班级民主评议小组意见");
                    //控制文字
                    LimitUtils.onlyInputRangeLength(90, 150, "lab_approveMsg_showmsg", "approveMsg"); //班级民主评议小组意见(90-150字)
                }
                else if (_user_role == "Y")//学院
                {
                    $("#lab_approveMsg").text("学院审核意见");
                }
                else if (_user_role == "X")//学校
                {
                    $("#lab_approveMsg").text("学校审核意见");
                }
            }
        }
    </script>
    <%--SCHOOL_SINGLE：单项奖学金：表18--%>
    <script type="text/javascript">
        function LoadPageSet_18(projectType) {
            if (projectType == "SCHOOL_SINGLE") {
                //******界面******************
                //--------基本信息 界面-------
                $("#div_STUDY_LEVEL").hide(); //学习阶段
                $("#div_TRAIN_TYPE").hide(); //培养方式
                $("#div_HARD_FOR").hide(); //攻读学位
                $("#div_BASIC_UNIT").hide(); //基层单位
                //英语、计算机过级情况
                $("#div_title_SKILL_INFO").hide();
                $("#div_SKILL_INFO").hide();
                //论文发表、获得专利等情况
                $("#div_title_PUBLISH_INFO").hide();
                $("#div_PUBLISH_INFO").hide();
                $("#lab_txt_APPLY_REASON").text("个人突出事迹");
                //******标签页*******************
                //家庭情况
                $("#tab_family").hide();
                //学习情况
                $("#tab_study").hide();
                //先进事迹
                $("#tab_model").hide();
                //******校验*******************
                ValidateUtils.setRequired("#form_edit", "POST_INFO", true, "曾/现任职情况必填");
                ValidateUtils.setRequired("#form_edit", "REWARD_FLAG", true, "拟评何种类型必填");
                //******审核界面*******************
                $("#div_comMsg").hide(); //评审意见
                //通过角色显示不同的字面意思
                if (_user_role == "F")//辅导员
                {
                    $("#lab_approveMsg").text("班级民主评议小组意见");
                    //控制文字
                    LimitUtils.onlyInputRangeLength(90, 150, "lab_approveMsg_showmsg", "approveMsg"); //班级民主评议小组意见(90-150字)
                }
                else if (_user_role == "Y")//学院
                {
                    $("#lab_approveMsg").text("学院审核意见");
                }
                else if (_user_role == "X")//学校
                {
                    $("#lab_approveMsg").text("学校审核意见");
                }
            }
        }
    </script>
    <%--COUNTRY_YP：国家奖学金（研究生/博士）：表19+1,19+2--%>
    <script type="text/javascript">
        function LoadPageSet_19(projectType) {
            if (projectType == "COUNTRY_YP") {
                //******界面******************
                //--------基本信息 界面-------
                $("#div_POST_INFO").hide(); //曾/现任职情况
                $("#div_REWARD_FLAG").hide(); //拟评何种类型
                if (projectType != "COUNTRY_YP") {
                    $("#div_HARD_FOR").hide(); //攻读学位
                    $("#div_BASIC_UNIT").hide(); //基层单位
                } else {
                    $("#div_HARD_FOR").show(); //攻读学位
                    $("#div_BASIC_UNIT").show(); //基层单位
                }
                $("#lab_txt_APPLY_REASON").text("申请理由");
                //--------学习信息 界面-------
                $("#div_SCORE_RANK").hide(); //成绩排名 / 名次
                $("#div_SCORE_TOTAL_NUM").hide(); //成绩排名 / 总人数
                $("#div_MUST_COURSE_NUM").hide(); //必修课 / 门
                $("#div_PASS_COURSE_NUM").hide(); //其中及格以上 / 门
                $("#div_IS_SCORE_FLAG").hide(); //是否实行综合考试排名
                $("#div_COM_SCORE").hide(); //个人达标综合考评成绩
                $("#div_COM_SCORE_RANK").hide(); //综合考评排名 / 名次
                $("#div_COM_SCORE_TOTAL_NUM").hide(); //综合考评排名 / 总人数
                //--------评审情况 界面-------
                $("#lab_RECOMM_REASON").text("推荐意见");
                $("#lab_REVIEW_REASON").text("评审意见");
                $("#lab_COLLEGE_REASON").text("基层单位意见");
                $("#lab_SCHOOL_REASON").text("培养单位意见");
                //******标签页*******************
                $("#tab_family").hide(); //家庭情况
                $("#tab_model").hide(); //先进事迹
                //******校验*******************
                ValidateUtils.setRequired("#form_edit", "POST_INFO", false, "");
                ValidateUtils.setRequired("#form_edit", "REWARD_FLAG", false, "");
                //******审核界面*******************
                //通过角色显示不同的字面意思
                if (_user_role == "F")//辅导员
                {
                    $("#div_comMsg").show(); //评审意见
                    $("#lab_approveMsg").text("推荐意见");
                    //控制文字
                    LimitUtils.onlyInputRangeLength(90, 150, "lab_approveMsg_showmsg", "approveMsg"); //推荐意见(90-150字)
                }
                else if (_user_role == "Y")//学院
                {
                    $("#div_comMsg").hide(); //评审意见
                    $("#lab_approveMsg").text("基层单位意见");
                }
                else if (_user_role == "X")//学校
                {
                    $("#div_comMsg").hide(); //评审意见
                    $("#lab_approveMsg").text("培养单位意见");
                }
            }
        }
    </script>
    <%--COUNTRY_STUDY：国家学业奖学金：表20--%>
    <%--SCHOOL_NOTCOUNTRY：非国家级奖学金：表21--%>
    <%--SOCIETY_NOCOUNTRY：非国家级奖学金：表21--%>
    <script type="text/javascript">
        function LoadPageSet_20_21(projectType) {
            if (projectType == "COUNTRY_STUDY"
            || projectType == "SCHOOL_NOTCOUNTRY"
            || projectType == "SOCIETY_NOCOUNTRY") {
                //******界面******************
                //--------基本信息 界面-------
                $("#div_POST_INFO").hide(); //曾/现任职情况
                $("#div_REWARD_FLAG").hide(); //拟评何种类型
                if (projectType != "COUNTRY_YP") {
                    $("#div_HARD_FOR").hide(); //攻读学位
                    $("#div_BASIC_UNIT").hide(); //基层单位
                } else {
                    $("#div_HARD_FOR").show(); //攻读学位
                    $("#div_BASIC_UNIT").show(); //基层单位
                }
                $("#lab_txt_APPLY_REASON").text("申请理由");
                //--------学习信息 界面-------
                $("#div_SCORE_RANK").hide(); //成绩排名 / 名次
                $("#div_SCORE_TOTAL_NUM").hide(); //成绩排名 / 总人数
                $("#div_MUST_COURSE_NUM").hide(); //必修课 / 门
                $("#div_PASS_COURSE_NUM").hide(); //其中及格以上 / 门
                $("#div_IS_SCORE_FLAG").hide(); //是否实行综合考试排名
                $("#div_COM_SCORE").hide(); //个人达标综合考评成绩
                $("#div_COM_SCORE_RANK").hide(); //综合考评排名 / 名次
                $("#div_COM_SCORE_TOTAL_NUM").hide(); //综合考评排名 / 总人数
                //--------评审情况 界面-------
                $("#div_comMsg").hide(); //评审意见
                $("#lab_RECOMM_REASON").text("推荐意见");
                $("#lab_COLLEGE_REASON").text("基层单位意见");
                $("#lab_SCHOOL_REASON").text("培养单位意见");
                //******标签页*******************
                $("#tab_family").hide(); //家庭情况
                $("#tab_model").hide(); //先进事迹
                //******校验*******************
                ValidateUtils.setRequired("#form_edit", "POST_INFO", false, "");
                ValidateUtils.setRequired("#form_edit", "REWARD_FLAG", false, "");
                //******审核界面*******************
                //通过角色显示不同的字面意思
                if (_user_role == "F")//辅导员
                {
                    $("#div_comMsg").show(); //评审意见
                    $("#lab_approveMsg").text("推荐意见");
                    //控制文字
                    LimitUtils.onlyInputRangeLength(90, 150, "lab_approveMsg_showmsg", "approveMsg"); //推荐意见(90-150字)
                }
                else if (_user_role == "Y")//学院
                {
                    $("#div_comMsg").hide(); //评审意见
                    $("#lab_approveMsg").text("基层单位意见");
                }
                else if (_user_role == "X")//学校
                {
                    $("#div_comMsg").hide(); //评审意见
                    $("#lab_approveMsg").text("培养单位意见");
                }
            }
        }
    </script>
    <%--OUTLINE_SET：线下奖学金：无对应模板，数据导入形式--%>
    <script type="text/javascript">
        function LoadPageSet_outline(projectType) {
            if (projectType == "OUTLINE_SET") {
                //******界面******************
                //--------基本信息 界面-------
                $("#div_REWARD_FLAG").hide(); //拟评何种类型
                $("#div_STUDY_LEVEL").hide(); //学习阶段
                $("#div_TRAIN_TYPE").hide(); //培养方式
                $("#div_HARD_FOR").hide(); //攻读学位
                $("#div_BASIC_UNIT").hide(); //基层单位
                //申请理由
                $("#div_title_APPLY_REASON").hide();
                $("#div_APPLY_REASON").hide();
                //英语、计算机过级情况
                $("#div_title_SKILL_INFO").hide();
                $("#div_SKILL_INFO").hide();
                //论文发表、获得专利等情况
                $("#div_title_PUBLISH_INFO").hide();
                $("#div_PUBLISH_INFO").hide();
                //******标签页*******************
                $("#tab_family").hide();
                $("#tab_reward").hide();
                $("#tab_study").hide();
                $("#tab_model").hide();
                $("#tab_approveinfo").hide();
            }
        }
    </script>
    <%--根据项目类型实现界面的显示隐藏：结束--%>
    <%--控制录入文字长度（通过类型区分）--%>
    <script type="text/javascript">
        function LoadPageSet_TxtInputNum(projectType) {
            if (projectType == "COUNTRY_B") {
                LimitUtils.onlyInputTheLength(200, "lab_showmsg_APPLY_REASON", "APPLY_REASON"); //申请理由(200字)
                LimitUtils.onlyInputTheLength(50, "lab_showmsg_MOTTO", "MOTTO"); //人生格言(50字)
                LimitUtils.onlyInputTheLength(100, "lab_showmsg_TEACHER_INFO", "TEACHER_INFO"); //师长点评(100字)
                LimitUtils.onlyInputRangeLength(1000, 2000, "lab_showmsg_MODEL_INFO", "MODEL_INFO"); //事迹正文(1000-2000)
            }
            else if (projectType == "SCHOOL_MODEL") {
                LimitUtils.onlyInputTheLength(50, "lab_showmsg_MOTTO", "MOTTO"); //人生格言(50字)
                LimitUtils.onlyInputTheLength(100, "lab_showmsg_TEACHER_INFO", "TEACHER_INFO"); //师长点评(100字)
                LimitUtils.onlyInputRangeLength(1000, 2000, "lab_showmsg_MODEL_INFO", "MODEL_INFO"); //事迹正文(1000-2000)
            }
            else if (projectType == "SCHOOL_SINGLE") {
                LimitUtils.onlyInputRangeLength(150, 200, "lab_showmsg_APPLY_REASON", "APPLY_REASON"); //申请理由(150-200字)
            }
            else {
                LimitUtils.onlyInputRangeLength(200, 500, "lab_showmsg_APPLY_REASON", "APPLY_REASON"); //申请理由(200-500字)
            }
        }
        //附件上传时，调用父界面的刷新方法，所以父界面这个方法一定要定义
        function UploadReload() {
            fileList.reload();
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
