<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="BasicInfo.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter.BasicInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            $(".form-control-static").each(function () {
                if ($(this).text() == "")
                    $(this).text("-")
            })
            Showphoto();
            loadTableList();
            $('#tbMember').DataTable();
        }

        function Showphoto() {
            //获取根目录
            var curWwwPath = window.document.location.href;
            var pathName = window.document.location.pathname;
            var pos = curWwwPath.indexOf(pathName);
            var root = curWwwPath.substring(0, pos);
            //显示图片
            var photosrc = document.getElementById('photo');
            var uploadphoto_root = '<%=m_strUploadPhotoRoot %>';
            if (uploadphoto_root.length == 0)
                uploadphoto_root = "UploadPhoto";

            photosrc.src = root + '/' + uploadphoto_root + '/<%=strPhotoPath%>';
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <div id="menuFrame" class="content-wrapper" id="main-container">
        <section class="content-header">
		<h1>基本信息</h1>
	    <ol class="breadcrumb">
	      	<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
	      	<li>个人中心</li>
	      	<li class="active">基本信息</li>
	    </ol>
  	</section>
        <div class="content">
            <form class="box box-default" action="#" method="post" id="personInfo" enctype="multipart/form-data">
            <div class="box-header">
                <h3 class="box-title">
                    基本信息</h3>
            </div>
            <div class="form-horizontal box-body">
                <div class="row">
                    <div class="col-sm-5">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                学号</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=head.NUMBER %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                性别</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=cod.GetDDLTextByValue("ddl_xb", head.SEX) %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                年级</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=head.EDULENTH %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                学院</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=cod.GetDDLTextByValue("ddl_department", head.COLLEGE) %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                专业</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=cod.GetDDLTextByValue("ddl_zy", head.MAJOR) %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                班级</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=cod.GetDDLTextByValue("ddl_class", head.CLASS) %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                入学时间</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=head.ENTERTIME %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                饭卡号</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=ricecard.RICE_CARD %>" />
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                姓名</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=head.NAME %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                出生日期</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=head.GARDE %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                学制</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=cod.GetDDLTextByValue("ddl_edu_system", head.SYSTEM)%>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                政治面貌</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=cod.GetDDLTextByValue("ddl_zzmm", head.POLISTATUS) %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                民族</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=cod.GetDDLTextByValue("ddl_mz", head.NATION) %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                学籍</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=cod.GetDDLTextByValue("ddl_xjzt", head.REGISTER) %>" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                身份证号码</label>
                            <div class="col-sm-9">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=head.IDCARDNO %>" />
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-3">
                        <div class="col-sm-12">
                            <img id="photo" alt="" src="" style="width: 180px;" />
                        </div>
                    </div>
                    <div class="col-sm-12">
                        <div class="form-group">
                            <label class="col-sm-1 control-label">
                                籍贯</label>
                            <div class="col-sm-11">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=head.NATIVEPLACE %>" />
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-12">
                        <div class="form-group">
                            <label class="col-sm-1 control-label">
                                生源地</label>
                            <div class="col-sm-11">
                                <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                    value="<%=head.STUPLACE %>" />
                            </div>
                            <label class="col-sm-12">（高考时户籍所在地）</label>
                        </div>
                    </div>
                </div>
            </div>
            </form>
        </div>
        <div class="content">
            <div class="box box-default" style="border: none; margin: 0;">
                <form class="form-horizontal form-horizontal box-body" role="form">
                <fieldset class="col-sm-12">
                    <legend>辅导员信息</legend>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            姓名</label>
                        <div class="col-sm-4">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=coun.NAME %>" />
                        </div>

                        <label class="col-sm-2 control-label">
                            移动电话</label>
                        <div class="col-sm-4">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=coun.MOBILENUM %>" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            办公电话</label>
                        <div class="col-sm-10">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=coun.OFFICEPHONE %>" />
                        </div>
                    </div>
                </fieldset>
                <fieldset class="col-sm-12">
                    <legend>联系方式</legend>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            联系电话</label>
                        <div class="col-sm-4">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=head.MOBILENUM %>" />
                        </div>

                        <label class="col-sm-2 control-label">
                            电子邮箱</label>
                        <div class="col-sm-4">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=head.EMAIL %>" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            QQ号码</label>
                        <div class="col-sm-4">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=head.QQNUM %>" />
                        </div>

                        <label class="col-sm-2 control-label">
                            家庭电话</label>
                        <div class="col-sm-4">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=head.HOMENUM %>" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            家庭邮编</label>
                        <div class="col-sm-4">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=head.POSTCODE %>" />
                        </div>

                        <label class="col-sm-2 control-label">
                            家庭地址</label>
                        <div class="col-sm-4">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=head.ADDRESS %>" />
                        </div>
                    </div>
                </fieldset>
                <fieldset class="col-sm-12">
                    <legend>家庭成员信息</legend>
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="alertDiv">
                            </div>
                            <div class="box box-default">
                                <table id="tablelist" class="table table-bordered table-striped table-hover dataTable no-footer dtr-inline collapsed">
                                </table>
                            </div>
                        </div>
                    </div>
                </fieldset>
                <fieldset class="col-sm-12">
                    <legend>其他信息</legend>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            银行名称</label>
                        <div class="col-sm-4">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=bank.BANKNAME %>" />
                        </div>

                        <label class="col-sm-2 control-label">
                            银行卡号</label>
                        <div class="col-sm-4">
                            <input class="form-control no-border" placeholder="" type="text" disabled="disabled"
                                value="<%=bank.BANKCODE %>" />
                        </div>
                    </div>
                </fieldset>
                <%if (IsShowScoreOrDst)
                  { %>
                <fieldset class="col-sm-12">
                    <legend>综测成绩</legend>
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="alertDiv1">
                            </div>
                            <div class="box box-default">
                                <table id="tablelist1" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                        </div>
                    </div>
                </fieldset>
                <fieldset class="col-sm-12">
                    <legend>困难生认定</legend>
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="alertDiv2">
                            </div>
                            <div class="box box-default">
                                <table id="tablelist2" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                        </div>
                    </div>
                </fieldset>
                <% } %>
                <fieldset class="col-sm-12">
                    <legend>奖助信息</legend>
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="alertDiv3">
                            </div>
                            <div class="box box-default">
                                <table id="tablelist3" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                        </div>
                    </div>
                </fieldset>
                <fieldset class="col-sm-12">
                    <legend>贷款信息</legend>
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="alertDiv4">
                            </div>
                            <div class="box box-default">
                                <table id="tablelist4" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                        </div>
                    </div>
                </fieldset>
                <fieldset class="col-sm-12">
                    <legend>参保信息</legend>
                    <div class="row">
                        <div class="col-xs-12">
                            <div id="alertDiv5">
                            </div>
                            <div class="box box-default">
                                <table id="tablelist5" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                        </div>
                    </div>
                </fieldset>
                </form>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //=================================家庭成员=================================
            //配置表格列
            tablePackageMany.filed = [
				{ "data": 'NAME', "head": '姓名' },
				{ "data": 'AGE', "head": '年龄' },
				{ "data": 'RELATION', "head": '与学生关系' },
				{ "data": 'WORKPLACE', "head": '工作(学习)单位' },
				{ "data": 'PROFESSION', "head": '职业' },
				{ "data": 'INCOME', "head": '年收入（元）' },
				{ "data": 'HEALTH', "head": '健康状况' }
			];

            //配置表格
            tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getfamilymembers",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId",
                    tableTitle: "",
                    tableConfig: {
                        'pageLength': 50, //每页显示个数，默认10条
                        'lengthChange': false//用户改变分页
                    }
                }
            });
            //=================================综测成绩=================================
            //配置表格列
            tablePackageMany.filed = [
				{ "data": 'YEAR', "head": '学年' },
				{ "data": 'SCORE_CONDUCT', "head": '操行综合分' },
				{ "data": 'SCORE_COURSE', "head": '课程学习综合分' },
				{ "data": 'SCORE_BODYART', "head": '体艺综合分' },
				{ "data": 'SCORE_JOBSKILL', "head": '职业技能综合分' },
				{ "data": 'SCORE_COM', "head": '综合考评总分' },
				{ "data": 'RANK_GRADE_COM', "head": '年级排名' },
				{ "data": 'RANK_CLASS_COM', "head": '班级排名' }
			];

            //配置表格
            tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getscore",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist1", //表格id
                    buttonId: "buttonId1",
                    tableTitle: "",
                    tableConfig: {
                        'pageLength': 50, //每页显示个数，默认10条
                        'lengthChange': false//用户改变分页
                    }
                }
            });
            //=================================困难生认定=================================
            //配置表格列
            tablePackageMany.filed = [
				{ "data": 'SCHYEAR', "head": '学年' },
				{ "data": 'LEVEL_CODE', "head": '认定档次' },
				{ "data": 'CHK_TIME', "head": '认定时间' }
			];

            //配置表格
            tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getdstapply",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist2", //表格id
                    buttonId: "buttonId2",
                    tableTitle: "",
                    tableConfig: {
                        'pageLength': 50, //每页显示个数，默认10条
                        'lengthChange': false//用户改变分页
                    }
                }
            });
            //=================================奖助信息=================================
            //配置表格列
            tablePackageMany.filed = [
				{ "data": 'PROJECT_YEAR', "head": '学年' },
				{ "data": 'PROJECT_NAME', "head": '项目名称' },
				{ "data": 'PROJECT_MONEY', "head": '金额' },
				{ "data": 'DECL_TIME', "head": '申请时间' }
			];

            //配置表格
            tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getscholarship",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist3", //表格id
                    buttonId: "buttonId3",
                    tableTitle: "",
                    tableConfig: {
                        'pageLength': 50, //每页显示个数，默认10条
                        'lengthChange': false//用户改变分页
                    }
                }
            });
            //=================================贷款信息=================================
            //配置表格列
            tablePackageMany.filed = [
				{ "data": 'LOAN_YEAR', "head": '申请学年' },
				{ "data": 'LOAN_NAME', "head": '贷款项目名称' },
				{ "data": 'TOSCHOOL_ACCOUNT', "head": '转入高校账户金额' },
				{ "data": 'WITHHOLD_REMAIN_ACCOUNT', "head": '余额' }
			];

            //配置表格
            tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getloaninfo",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist4", //表格id
                    buttonId: "buttonId4",
                    tableTitle: "",
                    tableConfig: {
                        'pageLength': 50, //每页显示个数，默认10条
                        'lengthChange': false//用户改变分页
                    }
                }
            });
            //=================================参保信息=================================
            //配置表格列
            tablePackageMany.filed = [
				{ "data": 'INSUR_YEAR', "head": '参保学年', "type": "td-keep" },
				{ "data": 'INSUR_NAME', "head": '保险类型', "type": "td-keep" },
				{ "data": 'INSUR_LIMITDATE', "head": '承保期限', "type": "td-keep" },
				{ "data": 'INSUR_MONEY', "head": '保险金额', "type": "td-keep" },
				{ "data": 'INSUR_COMPANY', "head": '承保公司', "type": "td-keep" },
				{ "data": 'INSUR_HANLDMAN', "head": '理赔人员', "type": "td-keep" },
				{ "data": 'INSUR_HANLDMAN_PHONE', "head": '联系电话', "type": "td-keep" },
				{ "data": 'INSUR_NUMBER', "head": '保单号', "type": "td-keep" }
			];

            //配置表格
            tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "?optype=getinsuranceinfo",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist5", //表格id
                    buttonId: "buttonId5",
                    tableTitle: "",
                    tableConfig: {
                        'pageLength': 50, //每页显示个数，默认10条
                        'lengthChange': false//用户改变分页
                    }
                }
            });
        }
    </script>
</asp:Content>
