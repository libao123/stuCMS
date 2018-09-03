<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectManage.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .datepicker
        {
            z-index: 9999;
        }
    </style>
    <script type="text/javascript" src="/AdminLTE/common/plugins/ckeditor/ckeditor.js"></script>
    <script type="text/javascript">
        var mainList;
        var numList;
        var notbothList;
        var zyList; //专业列表
        var _form_edit;
        var _form_notice;
        $(function () {
            adaptionHeight();

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
            //编辑页form定义
            _form_edit = PageValueControl.init("form_edit");
            _form_notice = PageValueControl.init("form_notice");
            //编辑控件
            loadEditor("NOTICE_CONTENT");
        });

        var editorObj;
        function loadEditor(id) {
            var instance = CKEDITOR.instances[id];
            if (instance) {
                CKEDITOR.remove(instance);
            }
            editorObj = CKEDITOR.replace(id, { customConfig: '/AdminLTE/common/plugins/ckeditor/config.js' });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>项目设置</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>奖助管理</li>
				<li class="active">项目设置</li>
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
                <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal"
                onsubmit="return false;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">
                        奖助项目设置</h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="hidOid" name="hidOid" value="" />
                    <input type="hidden" id="hidSeqNo" name="hidSeqNo" value="" />
                    <input type="hidden" id="hidStudentType" name="hidStudentType" value="" />
                    <input type="hidden" id="hidKN" name="hidKN" value="" />
                    <input type="hidden" id="hidAllZy" name="hidAllZy" />
                    <input type="hidden" id="hidSelDelZy" name="hidSelDelZy" />
                    <div class="nav-tabs-custom" style="box-shadow: none; margin-bottom: 0px;">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tab_1" data-toggle="tab">项目信息</a></li>
                            <li><a href="#tab_2" data-toggle="tab">申请条件</a></li>
                            <li><a href="#tab_3" data-toggle="tab">不可兼得</a></li>
                            <li><a href="#tab_4" data-toggle="tab">人数设置</a></li>
                        </ul>
                        <div class="tab-content">
                            <!--项目信息 开始-->
                            <div class="tab-pane active" id="tab_1">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">
                                        项目级别<span style="color: red">*</span></label>
                                    <div class="col-sm-4">
                                        <select class="form-control" name="PROJECT_CLASS" id="PROJECT_CLASS" d_value='' ddl_name='ddl_jz_project_class'
                                            show_type='t'>
                                        </select>
                                    </div>
                                    <label class="col-sm-2 control-label">
                                        申请表格类型<span style="color: red">*</span></label>
                                    <div class="col-sm-4">
                                        <select class="form-control" name="PROJECT_TYPE" id="PROJECT_TYPE" d_value='' ddl_name='ddl_jz_project_type'
                                            show_type='t'>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">
                                        项目名称<span style="color: red">*</span></label>
                                    <div class="col-sm-10">
                                        <input name="PROJECT_NAME" id="PROJECT_NAME" type="text" class="form-control" placeholder="项目名称" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">
                                        项目金额<span style="color: red">*</span></label>
                                    <div class="col-sm-4">
                                        <input name="PROJECT_MONEY" id="PROJECT_MONEY" type="text" class="form-control" placeholder="项目金额" />
                                    </div>
                                    <label class="col-sm-2 control-label">
                                        项目学年<span style="color: red">*</span></label>
                                    <div class="col-sm-4">
                                        <select class="form-control" name="APPLY_YEAR" id="APPLY_YEAR" d_value='' ddl_name='ddl_year_type'
                                            show_type='t'>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">
                                        开始时间<span style="color: red">*</span></label>
                                    <div class="col-sm-4" style="position: relative;">
                                        <input name="APPLY_START" id="APPLY_START" type="text" class="form-control datep"
                                            placeholder="开始时间" />
                                    </div>
                                    <label class="col-sm-2 control-label">
                                        结束时间<span style="color: red">*</span></label>
                                    <div class="col-sm-4" style="position: relative;">
                                        <input name="APPLY_END" id="APPLY_END" type="text" class="form-control datep" placeholder="结束时间" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">
                                        成绩涉及学年<span style="color: red">*</span></label>
                                    <div class="col-sm-4">
                                        <select class="form-control" name="SCORE_YEAR" id="SCORE_YEAR" d_value='' ddl_name='ddl_year_type'
                                            show_type='t'>
                                        </select>
                                    </div>
                                    <label class="col-sm-2 control-label">
                                        设立单位</label>
                                    <div class="col-sm-4">
                                        <input name="PROJECT_DEPARTMENT" id="PROJECT_DEPARTMENT" type="text" class="form-control"
                                            placeholder="设立单位" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">
                                        项目简介</label>
                                    <div class="col-sm-10">
                                        <textarea class="form-control" name="PROJECT_REMARK" id="PROJECT_REMARK" rows="5"
                                            cols=""></textarea>
                                    </div>
                                </div>
                            </div>
                            <!--项目信息 结束-->
                            <!--申请条件 开始-->
                            <div class="tab-pane" id="tab_2">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">
                                        综合考评总分排名：位于前</label>
                                    <div class="col-sm-7">
                                        <input name="Limit_ComRank_Value" id="Limit_ComRank_Value" type="text" class="form-control"
                                            placeholder="综合考评总分排名" maxlength="8" />
                                    </div>
                                    <label class="col-sm-1 control-label" style="text-align: left;">
                                        名</label>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">
                                        综合考评总分：位于前</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_ComScore_RankPer" id="Limit_ComScore_RankPer" type="text" class="form-control"
                                            placeholder="综合考评总分" maxlength="5" />
                                    </div>
                                    <!-- </div><div class="form-group col-sm-6"> -->
                                    <label class="col-sm-3 control-label">
                                        % / 分数大于</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_ComScore_Score" id="Limit_ComScore_Score" type="text" class="form-control"
                                            placeholder="分数大于" maxlength="5" />
                                    </div>
                                    <label class="col-sm-1 control-label" style="text-align: left;">
                                        分</label>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">
                                        操行能单项综合分：位于前</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_Conduct_RankPer" id="Limit_Conduct_RankPer" type="text" class="form-control"
                                            placeholder="操行能单项综合分" maxlength="5" />
                                    </div>
                                    <label class="col-sm-3 control-label">
                                        % / 分数大于</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_Conduct_Score" id="Limit_Conduct_Score" type="text" class="form-control"
                                            placeholder="分数大于" maxlength="5" />
                                    </div>
                                    <label class="col-sm-1 control-label" style="text-align: left;">
                                        分</label>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">
                                        课程能单项综合分：位于前</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_Course_RankPer" id="Limit_Course_RankPer" type="text" class="form-control"
                                            placeholder="课程能单项综合分" maxlength="5" />
                                    </div>
                                    <label class="col-sm-3 control-label">
                                        % / 分数大于</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_Course_Score" id="Limit_Course_Score" type="text" class="form-control"
                                            placeholder="分数大于" maxlength="5" />
                                    </div>
                                    <label class="col-sm-1 control-label" style="text-align: left;">
                                        分</label>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">
                                        体艺能单项综合分：位于前</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_BodyArt_RankPer" id="Limit_BodyArt_RankPer" type="text" class="form-control"
                                            placeholder="体艺能单项综合分" maxlength="5" />
                                    </div>
                                    <label class="col-sm-3 control-label">
                                        % / 分数大于</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_BodyArt_Score" id="Limit_BodyArt_Score" type="text" class="form-control"
                                            placeholder="分数大于" maxlength="5" />
                                    </div>
                                    <label class="col-sm-1 control-label" style="text-align: left;">
                                        分</label>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">
                                        职业技能单项综合分：位于前</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_JobSkill_RankPer" id="Limit_JobSkill_RankPer" type="text" class="form-control"
                                            placeholder="职业技能单项综合分" maxlength="5" />
                                    </div>
                                    <label class="col-sm-3 control-label">
                                        % / 分数大于</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_JobSkill_Score" id="Limit_JobSkill_Score" type="text" class="form-control"
                                            placeholder="分数大于" maxlength="5" />
                                    </div>
                                    <label class="col-sm-1 control-label" style="text-align: left;">
                                        分</label>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-9 control-label">
                                        操行、课程、体艺、职业技能四个单项 综合分任一个在评选范围内位于前：</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_Total_RankPer" id="Limit_Total_RankPer" type="text" class="form-control"
                                            placeholder="四个单项" maxlength="5" />
                                    </div>
                                    <label class="col-sm-1 control-label" style="text-align: left;">
                                        %</label>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">
                                        操行、课程、体艺、职业技能分项任三个前：</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_Three_RankPer" id="Limit_Three_RankPer" type="text" class="form-control"
                                            placeholder="任三个" maxlength="5" />
                                    </div>
                                    <label class="col-sm-3 control-label">
                                        %，另一个可放宽至</label>
                                    <div class="col-sm-2">
                                        <input name="Limit_One_RankPer" id="Limit_One_RankPer" type="text" class="form-control"
                                            placeholder="另一个可放宽至" maxlength="5" />
                                    </div>
                                    <label class="col-sm-1 control-label" style="text-align: left;">
                                        %</label>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">
                                        年级：</label>
                                    <div class="col-sm-6">
                                        <select class="form-control" name="Limit_Grade_Value" id="Limit_Grade_Value" d_value=''
                                            ddl_name='ddl_grade' show_type='t'>
                                        </select>
                                    </div>
                                    <label class="col-sm-3 control-label">
                                        （含）以上</label>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">
                                        专业（可多选）：</label>
                                    <div class="col-sm-9">
                                        <div class="box-body with-border" id="div_zy">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">
                                    </label>
                                    <div class="col-sm-9">
                                        <!-- style="margin-bottom: 10px;" -->
                                        <button type="button" class="btn btn-primary pull-right" id="btnDel_Zy">
                                            删除所选专业</button>
                                        <button type="button" class="btn btn-primary " id="btnAdd_Zy">
                                            新增专业</button>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">
                                        学生类型（可多选）：</label>
                                    <div class="col-sm-9">
                                        <div id="divStuType">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">
                                        困难生档次（多选）：</label>
                                    <div class="col-sm-9">
                                        <div id="divKnType">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!--申请条件 开始-->
                            <!--不可兼得 开始-->
                            <div class="tab-pane" id="tab_3">
                                <table id="tablelist_notboth" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                            <!--不可兼得 开始-->
                            <!--人数设置 开始-->
                            <div class="tab-pane" id="tab_4">
                                <table id="tablelist_num" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                            <!--人数设置 开始-->
                        </div>
                    </div>
                </div>
                </form>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-save" id="btnSave">
                        保存</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 发布公告编辑界面 开始 -->
    <div class="modal fade" id="tableModal_Notice">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_notice" name="form_notice" class="modal-content form-horizontal"
            onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    公告管理</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidNOTICE_OID" name="hidNOTICE_OID" value="" />
                <input type="hidden" id="hidUserRoles" name="hidUserRoles" />
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        标题<span style="color: red">*</span>
                    </label>
                    <div class="col-sm-10">
                        <input name="TITLE" id="TITLE" type="text" class="form-control" placeholder="标题" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        副标题</label>
                    <div class="col-sm-10">
                        <input name="SUB_TITLE" id="SUB_TITLE" type="text" class="form-control" placeholder="副标题" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        有效时间</label>
                    <div class="col-sm-4" style="position: relative;">
                        <input name="START_TIME" id="START_TIME" type="text" class="form-control datep" placeholder="有效起始时间" />
                    </div>
                    <label class="col-sm-2 control-label">
                        至</label>
                    <div class="col-sm-4" style="position: relative;">
                        <input name="END_TIME" id="END_TIME" type="text" class="form-control datep" placeholder="有效结束时间" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        查阅角色</label>
                    <div class="col-sm-10">
                        <div id="divUserRole">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        发布内容<span style="color: red">*</span>
                    </label>
                    <div class="col-sm-10">
                        <textarea name="NOTICE_CONTENT" id="NOTICE_CONTENT" cols="10" rows="5" class="form-control ckEditor"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSendNotice">
                    发布</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 发布公告编辑界面 结束-->
    <!-- 人数设置编辑界面 开始 -->
    <div class="modal fade" id="tableModal_Num">
        <div class="modal-dialog modal-dw60">
            <form action="#" method="post" id="form_num" name="form_num" class="modal-content form-horizontal"
            onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    可通过学院审核的人数设置</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidSeqNo_Num" name="hidSeqNo_Num" value="" />
                <div id="div_Num">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnsave_num">
                    确定</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 人数设置编辑界面 结束-->
    <!-- 不可兼得设置编辑界面 开始 -->
    <div class="modal fade" id="tableModal_Notboth">
        <div class="modal-dialog">
            <form action="#" method="post" id="form_notboth" name="form_notboth" class="modal-content form-horizontal"
            onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    不可兼得设置</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidOid_Notboth" name="hidOid_Notboth" value="" />
                <input type="hidden" id="hidSeqNo_Notboth" name="hidSeqNo_Notboth" value="" />
                <input type="hidden" id="hidProName_Notboth" name="hidProName_Notboth" value="" />
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        学年<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="PROJECT_YEAR_NOTBOTH" id="PROJECT_YEAR_NOTBOTH"
                            d_value='' ddl_name='ddl_year_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        项目级别<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="PROJECT_CLASS_NOTBOTH" id="PROJECT_CLASS_NOTBOTH"
                            d_value='' ddl_name='ddl_jz_project_class' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        申请表格类型<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="PROJECT_TYPE_NOTBOTH" id="PROJECT_TYPE_NOTBOTH"
                            d_value='' ddl_name='ddl_jz_project_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        不可兼得项目<span style="color: red">*</span></label>
                    <div class="col-sm-8">
                        <select class="form-control" name="PROJECT_SEQ_NO" id="PROJECT_SEQ_NO" d_value=''
                            ddl_name='' show_type='t'>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnsave_notboth">
                    确定</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 不可兼得设置编辑界面 结束-->
    <!-- 专业选择列表选择 开始 -->
    <div class="modal fade" id="tableModal_Zy">
        <div class="modal-dialog modal-dw60">
            <div class="modal-content form-horizontal">
                <div class="modal-body">
                    <table id="tablelist_zy" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 专业选择列表选择 结束-->
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
                    { "data": "PROJECT_CLASS_NAME", "head": "项目级别", "type": "td-keep" },
				    { "data": "PROJECT_TYPE_NAME", "head": "申请表格类型", "type": "td-keep" },
				    { "data": "PROJECT_NAME", "head": "项目名称", "type": "td-keep" },
				    { "data": "PROJECT_MONEY", "head": "项目金额", "type": "td-keep" },
				    { "data": "APPLY_YEAR_NAME", "head": "申请学年", "type": "td-keep" },
				    { "data": "APPLY_START", "head": "申请开始时间", "type": "td-keep" },
				    { "data": "APPLY_END", "head": "申请结束时间", "type": "td-keep" },
				    { "data": "OP_NAME", "head": "最后操作人", "type": "td-keep" },
                    { "data": "OP_TIME", "head": "最后操作时间", "type": "td-keep" },
                    { "data": "SEQ_NO", "head": "单据编号", "type": "td-keep" }
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
                    tableTitle: "项目设置",
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
					    { "data": "APPLY_YEAR", "pre": "项目学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
					    { "data": "PROJECT_CLASS", "pre": "项目级别", "col": 2, "type": "select", "ddl_name": "ddl_jz_project_class" },
                        { "data": "PROJECT_TYPE", "pre": "申请表格类型", "col": 3, "type": "select", "ddl_name": "ddl_jz_project_type" },
                        { "data": "PROJECT_NAME", "pre": "项目名称", "col": 4, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "sendnotice", title: "发布公告", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //奖助级别、奖助类型 联动
            SelectUtils.JZ_ClassTypeCodeChange("search-PROJECT_CLASS", "search-PROJECT_TYPE");
            //加载表体列表
            loadNumTableList();
            loadNotBothTableList();
            loadZyTableList();
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 设置学院申请人数列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadNumTableList() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "XY_NAME", "head": "学院", "type": "td-keep" },
				    { "data": "APPLY_NUM", "head": "可通过学院审核的人数", "type": "td-keep" }
		    ];

            //配置表格
            numList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "NumList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_num", //表格id
                    buttonId: "buttonId_num", //拓展按钮区域id
                    tableTitle: "奖助管理 >> 项目设置 >> 人数设置",
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
                { type: "userDefined", id: "reload_num", title: "刷新", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "add_num", title: "新增", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "edit_num", title: "修改", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del_num", title: "删除", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 设置学院申请人数列表JS 结束-->
    <!-- 设置不可兼得列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadNotBothTableList() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "PROJECT_NAME", "head": "不可兼得项目名称", "type": "td-keep" },
                    { "data": "PROJECT_YEAR_NAME", "head": "项目学年", "type": "td-keep" },
                    { "data": "PROJECT_CLASS_NAME", "head": "项目级别", "type": "td-keep" },
				    { "data": "PROJECT_TYPE_NAME", "head": "项目类型", "type": "td-keep" }
		    ];

            //配置表格
            notbothList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "NotbothList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_notboth", //表格id
                    buttonId: "buttonId_notboth", //拓展按钮区域id
                    tableTitle: "奖助管理 >> 项目设置 >> 不可兼得设置",
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
                { type: "userDefined", id: "reload_notboth", title: "刷新", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "add_notboth", title: "新增", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del_notboth", title: "删除", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 设置不可兼得列表JS 结束-->
    <!-- 专业列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadZyTableList() {
            //配置表格列
            tablePackageMany.filed = [
				{
				    "data": "ZY",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": "ZY", "head": "代码", "type": "td-keep" },
				{ "data": "MC", "head": "名称", "type": "td-keep" },
				{ "data": "XY_NAME", "head": "所属学院", "type": "td-keep" }
		    ];

            //配置表格
            zyList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/SysBasic/zy/List.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_zy", //表格id
                    buttonId: "buttonId_zy", //拓展按钮区域id
                    tableTitle: "选择专业",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': false, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
						{ "data": "XY", "pre": "所属学院", "col": 2, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "ZY", "pre": "专业代码", "col": 1, "type": "input" },
						{ "data": "MC", "pre": "专业名称", "col": 2, "type": "input" }
					]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: [
                { type: "userDefined", id: "reload_zy", title: "刷新", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "sel_zy", title: "选择", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 专业列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _tableModal_Notice = $("#tableModal_Notice");
            var _tableModal_Num = $("#tableModal_Num");
            var _tableModal_Notboth = $("#tableModal_Notboth");
            var _tableModal_Zy = $("#tableModal_Zy");
            var _btns = {
                reload: '.btn-reload',
                add: '.btn-add',
                edit: '.btn-edit',
                del: '.btn-del'
            };

            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        FormClearData();
                        //设置各个标签页的隐藏域的SEQ_NO
                        $("#hidOid").val(data.OID);
                        $("#hidSeqNo").val(data.SEQ_NO);
                        $("#hidSeqNo_Num").val(data.SEQ_NO);
                        $("#hidSeqNo_Notboth").val(data.SEQ_NO);
                        //设置人数加载
                        numList.refresh(OptimizeUtils.FormatUrl("NumList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        //设置不可兼得加载
                        notbothList.refresh(OptimizeUtils.FormatUrl("NotbothList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        //设置界面值
                        FormSetData(data);
                        //设置界面不可编辑
                        _form_edit.disableAll();
                        //设置按钮不可见
                        $("#btnSave").hide();
                        $("#add_num").hide();
                        $("#edit_num").hide();
                        $("#del_num").hide();
                        $("#add_notboth").hide();
                        $("#del_notboth").hide();
                        $("#btnDel_Zy").hide();
                        $("#btnAdd_Zy").hide();
                        //初始化编辑界面
                        $("#tableModal").modal();
                    }
                }
            });

            //【新增】
            _content.on('click', _btns.add, function () {
                $("#hidOid").val("");
                $("#hidSeqNo").val("");
                $("#hidSeqNo_Num").val("");
                $("#hidSeqNo_Notboth").val("");
                //设置界面值（清空界面值）
                FormClearData();
                //设置人数加载
                numList.refresh(OptimizeUtils.FormatUrl("NumList.aspx?optype=getlist&seq_no="));
                //设置不可兼得加载
                notbothList.refresh(OptimizeUtils.FormatUrl("NotbothList.aspx?optype=getlist&seq_no="));
                //设置界面可编辑
                _form_edit.cancel_disableAll();
                //设置按钮不可见
                $("#btnSave").show();
                $("#add_num").show();
                $("#edit_num").show();
                $("#del_num").show();
                $("#add_notboth").show();
                $("#del_notboth").show();
                $("#btnDel_Zy").show();
                $("#btnAdd_Zy").show();
                //初始化编辑界面
                $("#tableModal").modal();
            });
            //【编辑】
            _content.on('click', _btns.edit, function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        FormClearData();
                        //设置各个标签页的隐藏域的SEQ_NO
                        $("#hidOid").val(data.OID);
                        $("#hidSeqNo").val(data.SEQ_NO);
                        $("#hidSeqNo_Num").val(data.SEQ_NO);
                        $("#hidSeqNo_Notboth").val(data.SEQ_NO);
                        //设置人数加载
                        numList.refresh(OptimizeUtils.FormatUrl("NumList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        //设置不可兼得加载
                        notbothList.refresh(OptimizeUtils.FormatUrl("NotbothList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        //设置界面值
                        FormSetData(data);
                        //设置界面可编辑
                        _form_edit.cancel_disableAll();
                        //设置按钮不可见
                        $("#btnSave").show();
                        $("#add_num").show();
                        $("#edit_num").show();
                        $("#del_num").show();
                        $("#add_notboth").show();
                        $("#del_notboth").show();
                        $("#btnDel_Zy").show();
                        $("#btnAdd_Zy").show();
                        //初始化编辑界面
                        $("#tableModal").modal();
                    }
                    else {
                        $("#hidOid").val("");
                        $("#hidSeqNo").val("");

                        $("#hidSeqNo_Num").val("");
                        $("#hidSeqNo_Notboth").val("");
                    }
                }
            });
            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
            //【发布公告】
            _content.on('click', "#sendnotice", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        if (data.NOTICE_ID) {
                            //通过公告ID获取公告内容
                            var notice = AjaxUtils.getResponseText("List.aspx?optype=getnotice&id=" + data.NOTICE_ID);
                            if (notice) {
                                var notice_json = eval("(" + notice + ")");
                                _form_notice.setFormData(notice_json);
                            }
                            //加载内容
                            var content = AjaxUtils.getResponseText("/AdminLTE_Mod/BDM/Notice/List.aspx?optype=getcontent&id=" + data.NOTICE_ID);
                            if (content)
                                editorObj.setData(content);

                            $("#hidNOTICE_OID").val(data.NOTICE_ID);
                            $("#S").iCheck("uncheck"); //iCheck绑定
                            $("#F").iCheck("uncheck"); //iCheck绑定
                            $("#X").iCheck("uncheck"); //iCheck绑定
                            $("#Y").iCheck("uncheck"); //iCheck绑定
                            GetCheckBoxSelectedLoad(notice_json.ROLEID);
                        }
                        else {
                            _form_notice.reset();
                            $("#hidNOTICE_OID").val("");
                            $("#TITLE").val("<" + data.PROJECT_NAME + ">奖助项目开始进行申请");
                            $("#SUB_TITLE").val("申请时间 从 " + data.APPLY_START + " -- " + data.APPLY_END + "结束");
                            $("#START_TIME").val(data.APPLY_START);
                            $("#END_TIME").val(data.APPLY_END);
                            $("#S").iCheck("check"); //iCheck绑定
                            $("#F").iCheck("check"); //iCheck绑定
                            $("#X").iCheck("check"); //iCheck绑定
                            $("#Y").iCheck("check"); //iCheck绑定
                            editorObj.setData("");
                        }
                        _tableModal_Notice.modal();
                    }
                }
            });
            _tableModal_Notice.on('click', "#btnSendNotice", function () {
                SendNoticeData();
            });
            //-----------------编辑页-----------------
            //编辑页：【保存】
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });
            //-----------------------------------
            //人数设置：【刷新】
            _tableModal.on('click', "#reload_num", function () {
                numList.reload();
            });
            //人数设置：【新增】
            _tableModal.on('click', "#add_num", function () {
                if ($("#hidSeqNo").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "保存“项目信息”之后才可以操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                var numHtml = AjaxUtils.getResponseText("NumList.aspx?optype=add_numhtml");
                if (numHtml) {
                    $("#div_Num").html(numHtml);

                    //----人数设置页----
                    var result = AjaxUtils.getResponseText("NumList.aspx?optype=getxy");
                    if (result) {
                        var xy = result.split(',');
                        for (var i = 0; i < xy.length; i++) {
                            if (xy[i])
                                LimitUtils.onlyNum("APPLY_NUM_" + xy[i].toString());
                        }
                    }
                }
                else
                    $("#div_Num").html("");
                _tableModal_Num.modal();
            });
            //人数设置：【修改】
            _tableModal.on('click', "#edit_num", function () {
                var numHtml = AjaxUtils.getResponseText("NumList.aspx?optype=edit_numhtml&seq_no=" + $("#hidSeqNo_Num").val());
                if (numHtml) {
                    $("#div_Num").html(numHtml);

                    //----人数设置页----
                    var result = AjaxUtils.getResponseText("NumList.aspx?optype=getxy");
                    if (result) {
                        var xy = result.split(',');
                        for (var i = 0; i < xy.length; i++) {
                            if (xy[i])
                                LimitUtils.onlyNum("APPLY_NUM_" + xy[i].toString());
                        }
                    }
                }
                else
                    $("#div_Num").html("");
                _tableModal_Num.modal();
            });
            //人数设置：【删除】
            _tableModal.on('click', "#del_num", function () {
                DeleteData_Num();
            });
            //人数设置：【确定】
            _tableModal_Num.on('click', "#btnsave_num", function () {
                SaveData_Num();
            });
            //--------------------------------------
            //不可兼得设置：【刷新】
            _tableModal.on('click', "#reload_notboth", function () {
                notbothList.reload();
            });
            //不可兼得设置：【新增】
            _tableModal.on('click', "#add_notboth", function () {
                if ($("#hidSeqNo").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "保存“项目信息”之后才可以操作！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }

                _tableModal_Notboth.modal();
                //隐藏域赋值
                $("#hidOid_Notboth").val("");
                $("#hidProName_Notboth").val("");
                DropDownUtils.setDropDownValue("PROJECT_YEAR_NOTBOTH", "");
                DropDownUtils.setDropDownValue("PROJECT_CLASS_NOTBOTH", "");
                DropDownUtils.setDropDownValue("PROJECT_TYPE_NOTBOTH", "");
                DropDownUtils.setDropDownValue("PROJECT_SEQ_NO", "");
            });
            //不可兼得设置：【删除】
            _tableModal.on('click', "#del_notboth", function () {
                DeleteData_Notboth();
            });
            //不可兼得设置：【确定】
            _tableModal_Notboth.on('click', "#btnsave_notboth", function () {
                $("#hidProName_Notboth").val(DropDownUtils.getDropDownText("PROJECT_SEQ_NO"));
                SaveData_Notboth();
            });
            //----------编辑页：申请条件：专业----------------------
            //【新增专业】
            _tableModal.on('click', "#btnAdd_Zy", function () {
                _tableModal_Zy.modal();
            });
            //【删除所选专业】
            _tableModal.on('click', "#btnDel_Zy", function () {
                DeleteSelectZy();
            });
            //------------专业选择页按钮---------------
            //【刷新】
            _tableModal_Zy.on('click', "#reload_zy", function () {
                zyList.reload();
            });
            //【选择】
            _tableModal_Zy.on('click', "#sel_zy", function () {
                AddSelectZy();
            });
        }
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("PROJECT_CLASS");
            DropDownUtils.initDropDown("PROJECT_TYPE");
            DropDownUtils.initDropDown("APPLY_YEAR");
            DropDownUtils.initDropDown("SCORE_YEAR");
            DropDownUtils.initDropDown("Limit_Grade_Value");
            //奖助级别、奖助类型 联动
            SelectUtils.JZ_ClassTypeCodeChange("PROJECT_CLASS", "PROJECT_TYPE");
            DropDownUtils.initDropDown("PROJECT_YEAR_NOTBOTH");
            DropDownUtils.initDropDown("PROJECT_CLASS_NOTBOTH");
            DropDownUtils.initDropDown("PROJECT_TYPE_NOTBOTH");
            //学年、奖助级别、奖助类型、奖助项目 联动
            SelectUtils.JZ_Class_Type_Year_ProjectChange("PROJECT_CLASS_NOTBOTH", "PROJECT_TYPE_NOTBOTH", "PROJECT_YEAR_NOTBOTH", "PROJECT_SEQ_NO", '', '', '', '', '');
            //用户角色
            GetUserRoleHtml();
            //学生类型、困难生类型加载
            GetStuTypeHtml();
            GetKnTypeHtml();
            //设置checkbox选中改变事件
            $("input[type='checkbox'][name='stu_type']").on('ifChanged', function (event) {
                GetStuTypeSelected();
            });
            $("input[type='checkbox'][name='kn_type']").on('ifChanged', function (event) {
                GetKnTypeSelected();
            });
            $("input[type='checkbox'][name='user_role']").on('ifChanged', function (event) {
                GetUserRoleSelected();
            });
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
        }
    </script>
    <!-- 编辑页验证事件-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            //----项目信息页----
            LimitUtils.onlyNumAndPoint("PROJECT_MONEY"); //项目金额
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "PROJECT_CLASS", true, "项目级别必填");
            ValidateUtils.setRequired("#form_edit", "PROJECT_TYPE", true, "申请表格类型必填");
            ValidateUtils.setRequired("#form_edit", "PROJECT_NAME", true, "项目名称必填");
            ValidateUtils.setRequired("#form_edit", "PROJECT_MONEY", true, "项目金额必填");
            ValidateUtils.setRequired("#form_edit", "APPLY_YEAR", true, "项目学年必填");
            ValidateUtils.setRequired("#form_edit", "APPLY_START", true, "开始时间必填");
            ValidateUtils.setRequired("#form_edit", "APPLY_END", true, "结束时间必填");
            ValidateUtils.setRequired("#form_edit", "SCORE_YEAR", true, "成绩涉及学年必填");
            //----条件限制页----
            LimitUtils.onlyNum("Limit_ComRank_Value"); //综合考评总分排名
            LimitUtils.onlyNumAndPoint("Limit_ComScore_RankPer"); //综合考评总分：位于前XX%
            LimitUtils.onlyNumAndPoint("Limit_ComScore_Score"); //综合考评总分：分数大于XX分
            LimitUtils.onlyNumAndPoint("Limit_Conduct_RankPer"); //操行能单项综合分：位于前XX%
            LimitUtils.onlyNumAndPoint("Limit_Conduct_Score"); //操行能单项综合分：分数大于XX分
            LimitUtils.onlyNumAndPoint("Limit_Course_RankPer"); //课程能单项综合分：位于前XX%
            LimitUtils.onlyNumAndPoint("Limit_Course_Score"); //课程能单项综合分：分数大于XX分
            LimitUtils.onlyNumAndPoint("Limit_BodyArt_RankPer"); //体艺能单项综合分：位于前XX%
            LimitUtils.onlyNumAndPoint("Limit_BodyArt_Score"); //体艺能单项综合分：分数大于XX分
            LimitUtils.onlyNumAndPoint("Limit_JobSkill_RankPer"); //职业技能单项综合分：位于前XX%
            LimitUtils.onlyNumAndPoint("Limit_JobSkill_Score"); //职业技能单项综合分：分数大于XX分
            LimitUtils.onlyNumAndPoint("Limit_Total_RankPer"); //操行、课程、体艺、职业技能四个单项 综合分任一个：位于前XX%
            LimitUtils.onlyNumAndPoint("Limit_Three_RankPer"); //操行、课程、体艺、职业技能分项任三个前XX%
            LimitUtils.onlyNumAndPoint("Limit_One_RankPer"); //另一个可放宽至XX%
            //----不可兼得设置页----
            ValidateUtils.setRequired("#form_notboth", "PROJECT_YEAR_NOTBOTH", true, "学年必填");
            ValidateUtils.setRequired("#form_notboth", "PROJECT_CLASS_NOTBOTH", true, "项目级别必填");
            ValidateUtils.setRequired("#form_notboth", "PROJECT_TYPE_NOTBOTH", true, "申请表格类型必填");
            ValidateUtils.setRequired("#form_notboth", "PROJECT_SEQ_NO", true, "不可兼得项目必填");
            //----发布公告页----
            ValidateUtils.setRequired("#form_notice", "TITLE", true, "标题必填");
        }
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //获得初始角色HTML
        function GetUserRoleHtml() {
            $("#divUserRole").html('');
            var result = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getuserrole');
            if (result.length > 0)
                $("#divUserRole").html(result);
        }

        //获得学生类型HTML
        function GetStuTypeHtml() {
            $("#divStuType").html('');
            var result = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getstutype');
            if (result.length > 0)
                $("#divStuType").html(result);
        }

        //获得困难生类型HTML
        function GetKnTypeHtml() {
            $("#divKnType").html('');
            var result = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getkntype');
            if (result.length > 0)
                $("#divKnType").html(result);
        }

        //获得不可兼得奖助类型HTML
        function GetNoBothHtml() {
            $("#divNotBoth").html('');
            var result = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getnotboth');
            if (result.length > 0)
                $("#divNotBoth").html(result);
        }

        //角色选中加载
        function GetCheckBoxSelectedLoad(roles) {
            if (roles.length == 0) {
                $("input[type='checkbox'][name='user_role']").each(function () {
                    $(this).iCheck("uncheck"); //iCheck移除绑定
                });
                return;
            }
            var arrRole = roles.split(',');
            for (var i = 0; i < arrRole.length; i++) {
                if (arrRole[i].toString().length == 0)
                    continue;
                $("input[type='checkbox'][name='user_role']").each(function () {
                    if ($(this).attr('value') == arrRole[i].toString()) {
                        $(this).iCheck("check"); //iCheck绑定
                    }
                });
            }
        }

        //选择角色
        function GetUserRoleSelected() {
            var checkbox = "";
            $("#hidUserRoles").val("");
            $("input[type='checkbox'][name='user_role']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).attr("value") + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidUserRoles").val(checkbox);
            }
        }

        //学生类型选中加载
        function GetStuTypeSelectedLoad(str) {
            if (str.length == 0) {
                $("input[type='checkbox'][name='stu_type']").each(function () {
                    $(this).iCheck("uncheck"); //iCheck移除绑定
                });
                return;
            }
            var arrStr = str.split(',');
            for (var i = 0; i < arrStr.length; i++) {
                if (arrStr[i].toString().length == 0)
                    continue;
                $("input[type='checkbox'][name='stu_type']").each(function () {
                    if ($(this).attr('value') == arrStr[i].toString()) {
                        $(this).iCheck("check"); //iCheck绑定
                    }
                });
            }
        }

        //困难生类型选中加载
        function GetKnTypeSelectedLoad(str) {
            if (str.length == 0) {
                $("input[type='checkbox'][name='kn_type']").each(function () {
                    $(this).iCheck("uncheck"); //iCheck移除绑定
                });
                return;
            }
            var arrStr = str.split(',');
            for (var i = 0; i < arrStr.length; i++) {
                if (arrStr[i].toString().length == 0)
                    continue;
                $("input[type='checkbox'][name='kn_type']").each(function () {
                    if ($(this).attr('value') == arrStr[i].toString()) {
                        $(this).iCheck("check"); //iCheck绑定
                    }
                });
            }
        }

        //选择学生类型
        function GetStuTypeSelected() {
            var checkbox = "";
            $("#hidStudentType").val("");
            $("input[type='checkbox'][name='stu_type']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).attr("value") + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidStudentType").val(checkbox);
            }
        }

        //选择困难生类型
        function GetKnTypeSelected() {
            var checkbox = "";
            $("#hidKN").val("");
            $("input[type='checkbox'][name='kn_type']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).attr("value") + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidKN").val(checkbox);
            }
        }

        //--------主界面---------------
        //保存事件
        function SaveData() {
            //校验必填项
            if (!$('#form_edit').valid())
                return;

            //ZZ 20171019 新增：切换标签页之后，主标签页的必填项就无法进行校验，所以需要二次校验
            var PROJECT_CLASS = DropDownUtils.getDropDownValue("PROJECT_CLASS");
            var PROJECT_TYPE = DropDownUtils.getDropDownValue("PROJECT_TYPE");
            var PROJECT_NAME = $("#PROJECT_NAME").val();
            var PROJECT_MONEY = $("#PROJECT_MONEY").val();
            var APPLY_YEAR = DropDownUtils.getDropDownValue("APPLY_YEAR");
            var APPLY_START = $("#APPLY_START").val();
            var APPLY_END = $("#APPLY_END").val();
            if (PROJECT_CLASS.length == 0 || PROJECT_TYPE.length == 0 || PROJECT_NAME.length == 0 || PROJECT_MONEY.length == 0
            || APPLY_YEAR.length == 0 || APPLY_START.length == 0 || APPLY_END.length == 0) {
                easyAlert.timeShow({
                    "content": "项目信息页，有必填项未填，请填写完善之后再进行保存！",
                    "duration": 3,
                    "type": "danger"
                });
                return;
            }

            //生活补贴类，需要校验是否保存了学生类型
            if (PROJECT_CLASS == "LIFE") {
                var stuType = $("#hidStudentType").val();
                if (!stuType) {
                    easyAlert.timeShow({
                        "content": "项目类型为“生活补贴类”时，需要选择申请学生类型！",
                        "duration": 3,
                        "type": "danger"
                    });
                    return;
                }
            }
            if (PROJECT_CLASS == "LIFE") {
                var layInx = layer.load(2, {
                    content: "保存中，请稍后...",
                    shade: [0.3, '#000'], //0.1透明度的白色背景
                    time: 100000
                });
            }
            //保存 项目信息 之后 再保存 申请条件
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
                    $.post(OptimizeUtils.FormatUrl("LimitList.aspx?optype=save&seq_no=" + msg), $("#form_edit").serialize(), function (msg) {
                        if (msg.length == 0) {
                            //保存成功：关闭界面，刷新列表
                            easyAlert.timeShow({
                                "content": "保存成功！",
                                "duration": 2,
                                "type": "success"
                            });
                            $("#tableModal").modal("hide");
                            mainList.reload();
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
            });
        }

        //删除事件
        function DeleteData() {
            var data = mainList.selectSingle();
            if (data) {
                if (data.OID) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除选中的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            //判断是否满足删除条件：申请时间已经开始，已经有人开始申请，就不可以删除该项目
                            var result = AjaxUtils.getResponseText("List.aspx?optype=chkdel&id=" + data.OID);
                            if (result.length > 0) {
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }

                            result = AjaxUtils.getResponseText("List.aspx?optype=delete&id=" + data.OID);
                            if (result.length != 0) {
                                $(".Confirm_Div").modal("hide");
                                easyAlert.timeShow({
                                    "content": result,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return;
                            }
                            else {
                                $(".Confirm_Div").modal("hide");
                                //保存成功：关闭界面，刷新列表
                                easyAlert.timeShow({
                                    "content": "删除成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                mainList.reload();
                            }
                        }
                    });
                }
            }
        }

        //发布公告事件
        function SendNoticeData() {
            //校验必填项
            if (!$('#form_notice').valid())
                return;
            //校验发布内容必填
            if (editorObj.getData().length == 0) {
                easyAlert.timeShow({
                    "content": "发布内容必填！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            //$('.maskBg').show();
            //ZENG.msgbox.show("保存中，请稍后...", 6);
            var data = mainList.selectSingle();
            var layInx = layer.load(2, {
                content: "保存中，请稍后...",
                shade: [0.3, '#000'], //0.1透明度的白色背景
                time: 6000
            });
            if (data) {
                if (data.OID) {
                    $("#NOTICE_CONTENT").val(editorObj.getData());
                    $.post(OptimizeUtils.FormatUrl("/AdminLTE_Mod/BDM/Notice/List.aspx?optype=save&pro_oid=" + data.OID), $("#form_notice").serialize(), function (msg) {
                        if (msg.length != 0) {
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
                        else {
                            //保存成功：关闭界面，刷新列表
                            //$('.maskBg').hide();
                            //ZENG.msgbox.hide();
                            layer.close(layInx);
                            easyAlert.timeShow({
                                "content": "发布公告成功，请到系统维护>>公告通知>>公告管理 中进行内容的查阅以及完善！",
                                "duration": 2,
                                "type": "success"
                            });
                            $("#tableModal_Notice").modal("hide");
                            mainList.reload();
                        }
                    });
                }
            }
        }
        //--------人数设置---------------
        //删除人数事件
        function DeleteData_Num() {
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除所选的数据吗？",
                'title': '删除人数设置',
                'callback': function (btn) {
                    var data = numList.selectSingle();
                    if (data) {
                        if (data.OID) {
                            var url = "NumList.aspx?optype=delete&id=" + data.OID;
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
                                numList.reload();
                            }
                        }
                    }
                }
            });
        }

        //人数设置界面：保存事件
        function SaveData_Num() {
            //校验必填项
            if (!$('#form_num').valid())
                return;

            $.post(OptimizeUtils.FormatUrl("NumList.aspx?optype=save"), $("#form_num").serialize(), function (msg) {
                if (msg.length > 0) {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal_Num").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    numList.reload();
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
        //--------不可兼得设置---------------
        //删除不可兼得设置事件
        function DeleteData_Notboth() {
            easyConfirm.locationShow({
                'type': 'warn',
                'content': "确认删除所选的数据吗？",
                'title': '删除不可兼得设置',
                'callback': function (btn) {
                    var data = notbothList.selectSingle();
                    if (data) {
                        if (data.OID) {
                            var url = "NotbothList.aspx?optype=delete&id=" + data.OID;
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
                                notbothList.reload();
                            }
                        }
                    }
                }
            });
        }

        //人数设置界面：保存事件
        function SaveData_Notboth() {
            //校验必填项
            if (!$('#form_notboth').valid())
                return;

            $.post(OptimizeUtils.FormatUrl("NotbothList.aspx?optype=save"), $("#form_notboth").serialize(), function (msg) {
                if (msg.length > 0) {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal_Notboth").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    notbothList.reload();
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
        //--------------专业多选 自定义方法---------------------------------
        //获得选中的专业
        function GetCheckBoxSelected_Zy() {
            var checkbox = "";
            $("#hidSelDelZy").val("");
            $("input[type='checkbox'][name='limit_zy']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).val() + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidSelDelZy").val(checkbox);
            }
        }

        //获得所选择的专业集合
        function GetAllSelectZy() {
            var checkbox = "";
            $("#hidAllZy").val("");
            $("input[type='checkbox'][name='limit_zy']").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).val() + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidAllZy").val(checkbox);
            }
        }

        //添加专业
        function AddSelectZy() {
            GetAllSelectZy();
            var datas = zyList.selection();
            var selectUser = "";
            for (var i = 0; i < datas.length; i++) {
                if (datas[i]) {
                    if (datas[i].ZY) {
                        selectUser += datas[i].ZY + ",";
                    }
                }
            }
            $("#hidAllZy").val($("#hidAllZy").val() + selectUser);
            $("#div_zy").html("");
            $.post(OptimizeUtils.FormatUrl("LimitZyList.aspx?optype=getzy_add"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    $("#div_zy").append($(msg));
                    //关闭界面
                    $("#tableModal_Zy").modal("hide");
                    return;
                }
                else {
                    //关闭界面
                    $("#tableModal_Zy").modal("hide");
                    easyAlert.timeShow({
                        "content": "添加失败！",
                        "duration": 2,
                        "type": "info"
                    });
                }
            });
        }

        //删除专业
        function DeleteSelectZy() {
            GetCheckBoxSelected_Zy();
            if ($("#hidSelDelZy").val().length == 0) {
                easyAlert.timeShow({
                    "content": "请选择要删除的专业！",
                    "duration": 2,
                    "type": "info"
                });
                return;
            }
            GetAllSelectZy();
            $("#div_zy").html("");
            $.post(OptimizeUtils.FormatUrl("LimitZyList.aspx?optype=getzy_del"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    $("#div_zy").append($(msg));
                    return;
                }
                else {
                    easyAlert.timeShow({
                        "content": "删除失败！",
                        "duration": 2,
                        "type": "info"
                    });
                }
            });
        }

        //由于标签页切换的时候，另一个标签数据会实现不了清空或者赋值的情况，所以目前修改成手动赋值
        //清空
        function FormClearData() {
            //项目信息
            DropDownUtils.setDropDownValue("PROJECT_CLASS", "");
            DropDownUtils.setDropDownValue("PROJECT_TYPE", "");
            $("#PROJECT_NAME").val("");
            $("#PROJECT_MONEY").val("");
            DropDownUtils.setDropDownValue("APPLY_YEAR", "");
            DropDownUtils.setDropDownValue("SCORE_YEAR", "");
            $("#APPLY_START").val("");
            $("#APPLY_END").val("");
            $("#PROJECT_DEPARTMENT").val("");
            $("#PROJECT_REMARK").val("");
            //条件设置
            $("#Limit_ComRank_Value").val("");
            $("#Limit_ComScore_RankPer").val("");
            $("#Limit_ComScore_Score").val("");
            $("#Limit_Conduct_RankPer").val("");
            $("#Limit_Conduct_Score").val("");
            $("#Limit_Course_RankPer").val("");
            $("#Limit_Course_Score").val("");
            $("#Limit_BodyArt_RankPer").val("");
            $("#Limit_BodyArt_Score").val("");
            $("#Limit_JobSkill_RankPer").val("");
            $("#Limit_JobSkill_Score").val("");
            $("#Limit_Total_RankPer").val("");
            $("#Limit_Three_RankPer").val("");
            $("#Limit_One_RankPer").val("");
            DropDownUtils.setDropDownValue("Limit_Grade_Value", "");
            $("#div_zy").html("");
            $("input[type='checkbox'][name='stu_type']").each(function () {
                $(this).iCheck("uncheck"); //iCheck移除绑定
            });
            $("input[type='checkbox'][name='kn_type']").each(function () {
                $(this).iCheck("uncheck"); //iCheck移除绑定
            });
        }
        //赋值
        function FormSetData(data) {
            if (data) {
                //设置界面值
                _form_edit.setFormData(data);
                var limitdata = AjaxUtils.getResponseText("LimitList.aspx?optype=getlimitdata&seq_no=" + data.SEQ_NO);
                if (limitdata) {
                    var limitdata_json = eval("(" + limitdata + ")");
                    _form_edit.setFormData(limitdata_json);
                    if (limitdata_json.Limit_Student_Value)
                        GetStuTypeSelectedLoad(limitdata_json.Limit_Student_Value);
                    else
                        GetStuTypeSelectedLoad("");
                    if (limitdata_json.Limit_KN_Value)
                        GetKnTypeSelectedLoad(limitdata_json.Limit_KN_Value);
                    else
                        GetKnTypeSelectedLoad("");
                }
                //加载已选择专业
                $("#div_zy").html("");
                var result = AjaxUtils.getResponseText("LimitZyList.aspx?optype=getzy_edit&seq_no=" + data.SEQ_NO);
                if (result.length > 0)
                    $("#div_zy").html(result);
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>