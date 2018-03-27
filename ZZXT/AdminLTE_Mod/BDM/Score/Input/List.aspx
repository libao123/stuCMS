<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Score.Input.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList;
        var stuList;
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
			<h1>成绩录入</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>成绩管理</li>
				<li class="active">成绩录入</li>
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
        <div class="modal-dialog">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">成绩录入</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidOid" name="hidOid" value="" />
                <div class="form-group">
                    <label class="col-sm-4 control-label">学号</label>
                    <div class="col-sm-8">
                        <input name="STU_NUMBER" id="STU_NUMBER" type="text" class="form-control" placeholder="学号" onblur="GetStuInfo();" maxlength="20" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">学年</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="YEAR" id="YEAR" d_value='' ddl_name='ddl_year_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">姓名</label>
                    <div class="col-sm-8">
                        <input name="STU_NAME" id="STU_NAME" type="text" class="form-control" placeholder="姓名" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">所属班级</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="CLASS_CODE" id="CLASS_CODE" d_value='' ddl_name='ddl_class' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">所属学院</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="XY" id="XY" d_value='' ddl_name='ddl_department' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">所属专业</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="ZY" id="ZY" d_value='' ddl_name='ddl_zy' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">
                        所属年级</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="GRADE" id="GRADE" d_value='' ddl_name='ddl_grade' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">综合考评总分</label>
                    <div class="col-sm-8">
                        <input name="SCORE_COM" id="SCORE_COM" type="text" class="form-control" placeholder="综合考评总分" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">操行综合分</label>
                    <div class="col-sm-8">
                        <input name="SCORE_CONDUCT" id="SCORE_CONDUCT" type="text" class="form-control" placeholder="操行综合分" onblur="GetScoreCom();" maxlength="6" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">课程学习综合分</label>
                    <div class="col-sm-8">
                        <input name="SCORE_COURSE" id="SCORE_COURSE" type="text" class="form-control" placeholder="课程学习综合分" onblur="GetScoreCom();" maxlength="6" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">体艺综合分</label>
                    <div class="col-sm-8">
                        <input name="SCORE_BODYART" id="SCORE_BODYART" type="text" class="form-control" placeholder="体艺综合分" onblur="GetScoreCom();" maxlength="5" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">职业技能综合分</label>
                    <div class="col-sm-8">
                        <input name="SCORE_JOBSKILL" id="SCORE_JOBSKILL" type="text" class="form-control" placeholder="职业技能综合分" onblur="GetScoreCom();" maxlength="6" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">备注</label>
                    <div class="col-sm-8">
                        <input name="REMARK" id="REMARK" type="text" class="form-control" placeholder="备注" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-select" id="btnStuSel">选择学生</button>
                <button type="button" class="btn btn-primary btn-save" id="btnSave">保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 辅导员列表选择 开始 -->
    <div class="modal fade" id="stuListModal">
        <div class="modal-dialog modal-50">
            <div class="modal-content form-horizontal">
                <div class="modal-body">
                    <table id="tablelist_stu" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 辅导员列表选择 结束-->
    <!-- 下载导入模板：选择所带班级 开始 -->
    <div class="modal fade" id="tableModal_selectClass">
        <div class="modal-dialog">
          <form action="#" method="post" id="form_selectClass" name="form_edit" class="modal-content form-horizontal" onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">选择导入模板所带出班级</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="hidSelectClass" name="hidSelectClass" value="" />
                <div id="div_fdyclass">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-download" id="btnExport">确认</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
          </form>
        </div>
    </div>
    <!-- 下载导入模板：选择所带班级 结束-->
    <!-- 导入界面 开始-->
    <div class="modal fade" id="importModal">
        <div class="modal-dialog">
          <form id="form_import" name="form_edit" class="modal-content form-horizontal form-inline">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">成绩导入</h4>
            </div>
            <div class="modal-body">

                    <iframe id="importFrame" frameborder="0" src=""style="width: 100%; height: 250px; display:block;">
                    </iframe>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
          </form>
        </div>
    </div>
    <!-- 导入界面 结束-->
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
                    { "data": "YEAR_NAME", "head": "学年", "type": "td-keep" },
				    { "data": "CLASS_CODE_NAME", "head": "班级", "type": "td-keep" },
				    { "data": "STU_NUMBER", "head": "学号", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "姓名", "type": "td-keep" },
				    { "data": "XY_NAME", "head": "学院", "type": "td-keep" },
				    { "data": "ZY_NAME", "head": "专业", "type": "td-keep" },
				    { "data": "GRADE", "head": "年级", "type": "td-keep" },
				    { "data": "SCORE_CONDUCT", "head": "操行综合分", "type": "td-keep" },
                    { "data": "SCORE_COURSE", "head": "课程学习综合分", "type": "td-keep" },
                    { "data": "SCORE_BODYART", "head": "体艺综合分", "type": "td-keep" },
                    { "data": "SCORE_JOBSKILL", "head": "职业技能综合分", "type": "td-keep" },
                    { "data": "SCORE_COM", "head": "综合考评总分", "type": "td-keep" },
                    { "data": "RANK_CLASS_COM", "head": "班级排名", "type": "td-keep" },
                    { "data": "RANK_GRADE_COM", "head": "年级排名", "type": "td-keep" },
                    { "data": "RANK_CLASS_NUM", "head": "班级排名总人数", "type": "td-keep" },
                    { "data": "RANK_GRADE_NUM", "head": "年级排名总人数", "type": "td-keep" },
                    { "data": "OP_NAME", "head": "操作人", "type": "td-keep" },
                    { "data": "OP_TIME", "head": "操作时间", "type": "td-keep" }
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
                    tableTitle: "成绩录入",
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
                        { "data": "YEAR", "pre": "学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=strLastYear %>" },
					    { "data": "XY", "pre": "学院", "col": 2, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 3, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 4, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 5, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "学号", "col": 6, "type": "input" },
                        { "data": "STU_NAME", "pre": "姓名", "col": 7, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload", "add", "edit", "del",
                { type: "userDefined", id: "export", title: "导出学生成绩", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "import", title: "导入学生成绩", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "download", title: "下载导入模板", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASS_CODE");
            //学生列表
            stuListLoad();
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 学生列表JS 开始-->
    <script type="text/javascript">
        //研究生列表加载
        function stuListLoad() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "NUMBER",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "NUMBER", "head": "学号", "type": "td-keep" },
				    { "data": "NAME", "head": "姓名", "type": "td-keep" },
				    { "data": "COLLEGE_NAME", "head": "学院", "type": "td-keep" },
                    { "data": "MAJOR_NAME", "head": "专业", "type": "td-keep" },
                    { "data": "EDULENTH", "head": "年级", "type": "td-keep" },
                    { "data": "CLASS_NAME", "head": "所在班级", "type": "td-keep" }
		    ];

            //配置表格
            stuList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/Common/ComPage/SelectBasicStu.aspx?optype=getlist&filter=scoreinput",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_stu", //表格id
                    buttonId: "buttonId_stu", //拓展按钮区域id
                    tableTitle: "选择学生",
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
                    "boxId": "StuBox",
                    "tabId": "tabStu",
                    "cols": [
                        { "data": "NUMBER", "pre": "学号", "col": 1, "type": "input" },
                        { "data": "NAME", "pre": "姓名", "col": 2, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                { type: "userDefined", id: "stu_select", title: "选择", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 学生列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _tableModal_selectClass = $("#tableModal_selectClass");
            var _stuListModal = $("#stuListModal");
            _btns = {
                reload: '.btn-reload',
                add: '.btn-add',
                edit: '.btn-edit',
                del: '.btn-del'
            };
            //----------主列表--------------
            //刷新
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //删除
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
            //新增
            _content.on("click", _btns.add, function () {
                $("#hidOid").val("");
                //设置界面值（清空界面值）
                _form_edit.reset();
                ControlUtils.Input_SetReadOnlyStatus("STU_NUMBER", false);
                //【选择学生】按钮显示
                $("#btnStuSel").show();
                //固定设置
                ControlUtils.Input_SetReadOnlyStatus("STU_NAME", true);
                ControlUtils.Select_SetDisableStatus("XY", true);
                ControlUtils.Select_SetDisableStatus("ZY", true);
                ControlUtils.Select_SetDisableStatus("GRADE", true);
                ControlUtils.Select_SetDisableStatus("CLASS_CODE", true);
                ControlUtils.Input_SetReadOnlyStatus("SCORE_COM", true);
                _tableModal.modal();
            });
            //修改
            _content.on("click", _btns.edit, function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        $("#hidOid").val(data.OID);
                        _form_edit.setFormData(data);
                        ControlUtils.Input_SetReadOnlyStatus("STU_NUMBER", true);
                        //【选择学生】按钮隐藏
                        $("#btnStuSel").hide();
                        //固定设置
                        ControlUtils.Input_SetReadOnlyStatus("STU_NAME", true);
                        ControlUtils.Select_SetDisableStatus("XY", true);
                        ControlUtils.Select_SetDisableStatus("ZY", true);
                        ControlUtils.Select_SetDisableStatus("GRADE", true);
                        ControlUtils.Select_SetDisableStatus("CLASS_CODE", true);
                        ControlUtils.Input_SetReadOnlyStatus("SCORE_COM", true);
                        _tableModal.modal();
                    }
                }
            });
            //导出学生成绩
            _content.on("click", "#export", function () {
                //必须选择学年
                if ($('#search-YEAR').val().length == 0) {
                    easyAlert.timeShow({
                        "content": "请选择需要导出的学年成绩！",
                        "duration": 2,
                        "type": "warn"
                    });
                    return;
                }
                //导出
                var strq = "";
                if ($('#search-STU_NUMBER').val())
                    strq += "&STU_NUMBER=" + OptimizeUtils.FormatParamter($('#search-STU_NUMBER').val());
                if ($('#search-STU_NAME').val())
                    strq += "&STU_NAME=" + OptimizeUtils.FormatParamter($('#search-STU_NAME').val());
                if ($('#search-YEAR').val())
                    strq += "&YEAR=" + $('#search-YEAR').val();
                if ($('#search-XY').val())
                    strq += "&XY=" + $('#search-XY').val();
                if ($('#search-ZY').val())
                    strq += "&ZY=" + $('#search-ZY').val();
                if ($('#search-GRADE').val())
                    strq += "&GRADE=" + $('#search-GRADE').val();
                if ($('#search-CLASS_CODE').val())
                    strq += "&CLASS_CODE=" + $('#search-CLASS_CODE').val();
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=scorelist' + strq);
            });
            //导入学生成绩
            _content.on("click", "#import", function () {
                $("#importFrame").attr("src", '/Excel/ImportExcel/ImportExcel.aspx?model_id=importModal&type=INPUT_SCORE');
                $("#importModal").modal();
            });
            //下载导入模板
            _content.on("click", "#download", function () {
                _tableModal_selectClass.modal();
            });
            //----------编辑页--------------
            //保存
            _tableModal.on('click', "#btnSave", function () {
                SaveData();
            });
            //选择学生
            _tableModal.on('click', "#btnStuSel", function () {
                _stuListModal.modal();
            });
            //----------学生列表页--------------
            //学生列表：【选择】
            _stuListModal.on('click', "#stu_select", function () {
                var data = stuList.selectSingle();
                if (data) {
                    //判断该学生是否为辅导员所带班级学生
                    var url_chk = "List.aspx?optype=chkstuinfo&stuno=" + data.NUMBER;
                    var result_chk = AjaxUtils.getResponseText(url_chk);
                    if (result_chk.length > 0) {
                        easyAlert.timeShow({
                            "content": result_chk,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }

                    $("#STU_NUMBER").val(data.NUMBER);
                    $("#STU_NAME").val(data.NAME);
                    DropDownUtils.setDropDownValue("XY", data.COLLEGE);
                    DropDownUtils.setDropDownValue("ZY", data.MAJOR);
                    DropDownUtils.setDropDownValue("GRADE", data.EDULENTH);
                    DropDownUtils.setDropDownValue("CLASS_CODE", data.CLASS);
                    $("#stuListModal").modal('hide');
                }
            });
            //----------下载导入模板 选择班级 页--------------
            //下载导入模板
            _tableModal_selectClass.on('click', "#btnExport", function () {
                if ($("#hidSelectClass").val().length > 0)
                    window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=scorelist_input&classcode=' + $("#hidSelectClass").val());
                else
                    window.open('/Excel/Model/Score/导入模板_学生综合成绩信息.xls');
            });
        }
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("YEAR");
            DropDownUtils.initDropDown("CLASS_CODE");
            DropDownUtils.initDropDown("XY");
            DropDownUtils.initDropDown("ZY");
            DropDownUtils.initDropDown("GRADE");
            //获得初始辅导员所带班级HTML
            GetFdyClassHtml();
            //设置辅导员所带班级选中改变事件
            $("input[type='checkbox'][name='fdy_class']").on('ifChanged', function (event) {
                GetCheckBoxSelected();
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
            //录入限制
            LimitUtils.onlyNumAndPoint("SCORE_CONDUCT"); //代码限制只能录入数字与小数点
            LimitUtils.onlyNumAndPoint("SCORE_COURSE"); //代码限制只能录入数字与小数点
            LimitUtils.onlyNumAndPoint("SCORE_BODYART"); //代码限制只能录入数字与小数点
            LimitUtils.onlyNumAndPoint("SCORE_JOBSKILL"); //代码限制只能录入数字与小数点
            //必填项设置
            ValidateUtils.setRequired("#form_edit", "STU_NUMBER", true, "学号必须填");
            ValidateUtils.setRequired("#form_edit", "YEAR", true, "学年必须填");
            ValidateUtils.setRequired("#form_edit", "SCORE_COM", true, "综合考评总分必须填");
            ValidateUtils.setRequired("#form_edit", "SCORE_CONDUCT", true, "操行综合分必须填");
            ValidateUtils.setRequired("#form_edit", "SCORE_COURSE", true, "课程学习综合分必须填");
            ValidateUtils.setRequired("#form_edit", "SCORE_BODYART", true, "体艺综合分必须填");
            ValidateUtils.setRequired("#form_edit", "SCORE_JOBSKILL", true, "职业技能综合分必须填");
        }
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //获得初始辅导员所带班级HTML
        function GetFdyClassHtml() {
            $("#div_fdyclass").html('');
            var result = AjaxUtils.getResponseText('List.aspx?optype=getfdyclass');
            if (result.length > 0)
                $("#div_fdyclass").html(result);
        }

        //计算综合考评总分
        function GetScoreCom() {
            var SCORE_CONDUCT = CalculateUtiles.StringToFloat($("#SCORE_CONDUCT").val());
            var SCORE_COURSE = CalculateUtiles.StringToFloat($("#SCORE_COURSE").val());
            var SCORE_BODYART = CalculateUtiles.StringToFloat($("#SCORE_BODYART").val());
            var SCORE_JOBSKILL = CalculateUtiles.StringToFloat($("#SCORE_JOBSKILL").val());
            //本科学生个人达标综合考评总分=（操行综合分×15%）+（课程学习综合分×60%）+（体艺综合分×10%）+（职业技能综合分×15%）
            var SCORE_COM = SCORE_CONDUCT * 0.15
            + SCORE_COURSE * 0.6
            + SCORE_BODYART * 0.1
            + SCORE_JOBSKILL * 0.15;
            $("#SCORE_COM").val(CalculateUtiles.StringToFloat(SCORE_COM.toString(), 1)); //保留一位小数
        }

        //通过学生工号带出相关信息
        function GetStuInfo() {
            if ($("#STU_NUMBER").val().length == 0) {
                ClearStuInfo();
                return;
            }

            //判断录入的学号是否为所带班级学生
            var url_chk = "List.aspx?optype=chkstuinfo&stuno=" + $("#STU_NUMBER").val();
            var result_chk = AjaxUtils.getResponseText(url_chk);
            if (result_chk.length > 0) {
                easyAlert.timeShow({
                    "content": result_chk,
                    "duration": 2,
                    "type": "danger"
                });
                ClearStuInfo();
                return;
            }

            //通过学号获得学生基本信息
            var url = "List.aspx?optype=getstuinfo&stuno=" + $("#STU_NUMBER").val();
            var result = AjaxUtils.getResponseText(url);
            if (result.length > 0) {
                var jsonResult = $.parseJSON(result);
                $("#STU_NAME").val(jsonResult.NAME);
                DropDownUtils.setDropDownValue("XY", jsonResult.COLLEGE);
                DropDownUtils.setDropDownValue("ZY", jsonResult.MAJOR);
                DropDownUtils.setDropDownValue("GRADE", jsonResult.EDULENTH);
                DropDownUtils.setDropDownValue("CLASS_CODE", jsonResult.CLASS);
            }
            else {
                easyAlert.timeShow({
                    "content": "不存在该学号，请确认！",
                    "duration": 2,
                    "type": "danger"
                });
                ClearStuInfo();
                return;
            }
        }

        //清除数据
        function ClearStuInfo() {
            $("#STU_NUMBER").val('');
            $("#STU_NAME").val('');
            $("#XY").val('');
            $("#ZY").val('');
            $("#CLASS_CODE").val('');
            $("#EDULENTH").val('');
            $("#STU_NUMBER").focus();
        }

        //选择角色
        function GetCheckBoxSelected() {
            var checkbox = "";
            $("#hidSelectClass").val("");
            $("input[type='checkbox'][name='fdy_class']:checked").each(function () {
                if ($(this) != null) {
                    if ($(this).attr("id").length > 0)
                        checkbox += $(this).attr("id") + ",";
                }
            });
            if (checkbox.length > 0) {
                $("#hidSelectClass").val(checkbox);
            }
        }

        //保存事件
        function SaveData() {
            //校验必填项
            if (!$('#form_edit').valid())
                return;
            //保存的时候，解开设置
            ControlUtils.Select_SetDisableStatus("XY", false);
            ControlUtils.Select_SetDisableStatus("ZY", false);
            ControlUtils.Select_SetDisableStatus("GRADE", false);
            ControlUtils.Select_SetDisableStatus("CLASS_CODE", false);
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    //保存完毕的时候，初始设置
                    ControlUtils.Select_SetDisableStatus("XY", true);
                    ControlUtils.Select_SetDisableStatus("ZY", true);
                    ControlUtils.Select_SetDisableStatus("GRADE", true);
                    ControlUtils.Select_SetDisableStatus("CLASS_CODE", true);
                    return;
                }
                else {
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    //保存完毕的时候，初始设置
                    ControlUtils.Select_SetDisableStatus("XY", true);
                    ControlUtils.Select_SetDisableStatus("ZY", true);
                    ControlUtils.Select_SetDisableStatus("GRADE", true);
                    ControlUtils.Select_SetDisableStatus("CLASS_CODE", true);
                    mainList.reload();
                }
            });
        }

        //删除事件
        function DeleteData() {
            var datas = mainList.selection();
            var strOids = "";
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].OID.length == 0)
                    continue;
                strOids += datas[i].OID + ",";
            }
            if (datas) {
                easyConfirm.locationShow({
                    'type': 'warn',
                    'content': "确认删除选中的数据吗？",
                    'title': '删除数据',
                    'callback': function (btn) {
                        var result = AjaxUtils.getResponseText("List.aspx?optype=delete&ids=" + strOids);
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
        //导入时，调用父界面的刷新方法，所以父界面这个方法一定要定义
        function ImportReload() {
            mainList.reload();
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
