<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.STU.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _form_edit;
        $(function () {
            adaptionHeight();
            loadTableList();
            loadModalBtnInit();

            DropDownUtils.initDropDown("STUTYPE");
            DropDownUtils.initDropDown("ENROLLING");
            DropDownUtils.initDropDown("SEX");
            DropDownUtils.initDropDown("EDULENTH");
            DropDownUtils.initDropDown("COLLEGE");
            DropDownUtils.initDropDown("MAJOR");
            DropDownUtils.initDropDown("CLASS");
            DropDownUtils.initDropDown("POLISTATUS");
            DropDownUtils.initDropDown("NATION");
            DropDownUtils.initDropDown("SYSTEM");
            DropDownUtils.initDropDown("REGISTER");
            DropDownUtils.initDropDown("ADD_PROVINCE");

            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-COLLEGE", "search-MAJOR", "search-EDULENTH", "search-CLASS");
            //编辑页form定义
            _form_edit = PageValueControl.init("form_edit");
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>基本信息录入</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">基本信息录入</li>
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
        <div class="modal-dialog modal-dw70">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal"
            onsubmit="return false;">
            <input type="hidden" id="OID" name="OID" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    学生基本信息录入</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学号<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="NUMBER" id="NUMBER" type="text" class="form-control" placeholder="学号" />
                    </div>
                    <label class="col-sm-2 control-label">
                        姓名<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="NAME" id="NAME" type="text" class="form-control" placeholder="姓名" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        曾用名</label>
                    <div class="col-sm-4">
                        <input name="US_NAME" id="US_NAME" type="text" class="form-control" placeholder="曾用名" />
                    </div>
                    <label class="col-sm-2 control-label">
                        身高</label>
                    <div class="col-sm-4">
                        <input name="HEIGTH" id="HEIGTH" type="text" class="form-control" placeholder="身高" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        体重</label>
                    <div class="col-sm-4">
                        <input name="WEIGTH" id="WEIGTH" type="text" class="form-control" placeholder="体重" />
                    </div>
                    <label class="col-sm-2 control-label">
                        特长</label>
                    <div class="col-sm-4">
                        <input name="GENIUS" id="GENIUS" type="text" class="form-control" placeholder="特长" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        健康状况</label>
                    <div class="col-sm-4">
                        <input name="HEALTH" id="HEALTH" type="text" class="form-control" placeholder="健康状况" />
                    </div>
                    <label class="col-sm-2 control-label">
                        培养层次</label>
                    <div class="col-sm-4">
                        <input name="TRAIN" id="TRAIN" type="text" class="form-control" placeholder="培养层次" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        是否走读</label>
                    <div class="col-sm-4">
                        <input name="STUWORK" id="STUWORK" type="text" class="form-control" placeholder="是否走读" />
                    </div>
                    <label class="col-sm-2 control-label">
                        学生类别<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="STUTYPE" name="STUTYPE" class="form-control" ddl_name='ddl_basic_stu_type'
                            d_value='' title="学生类别" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        入学方式<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="ENROLLING" name="ENROLLING" class="form-control" ddl_name='ddl_rxfs'
                            d_value='' title="入学方式" show_type="t">
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">
                        培养方式</label>
                    <div class="col-sm-4">
                        <input name="CULTIVATION" id="CULTIVATION" type="text" class="form-control" placeholder="培养方式" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        带班辅导员</label>
                    <div class="col-sm-4">
                        <input name="COUN" id="COUN" type="text" class="form-control" placeholder="带班辅导员" />
                    </div>
                    <label class="col-sm-2 control-label">
                        身份证号<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="IDCARDNO" id="IDCARDNO" type="text" class="form-control" placeholder="身份证号" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        电子邮箱<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="EMAIL" id="EMAIL" type="text" class="form-control" placeholder="电子邮箱" />
                    </div>
                    <label class="col-sm-2 control-label">
                        QQ号码<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <input name="QQNUM" id="QQNUM" type="text" class="form-control" placeholder="QQ号码" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        性别<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="SEX" name="SEX" class="form-control" ddl_name='ddl_xb' d_value='' title="性别"
                            show_type="t">
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">
                        出生日期<span style="color: Red;">*</span></label>
                    <div class="col-sm-4" style="position: relative; z-index: 9999">
                        <input name="GARDE" id="GARDE" type="text" class="form-control timeSingle" placeholder="出生日期" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        年级<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="EDULENTH" name="EDULENTH" class="form-control" ddl_name='ddl_grade' d_value=''
                            title="年级" show_type="t">
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">
                        学院<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="COLLEGE" name="COLLEGE" class="form-control" ddl_name='ddl_department'
                            d_value='' title="学院" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        政治面貌</label>
                    <div class="col-sm-4">
                        <select id="POLISTATUS" name="POLISTATUS" class="form-control" ddl_name='ddl_zzmm'
                            d_value='' title="政治面貌" show_type="t">
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">
                        专业<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="MAJOR" name="MAJOR" class="form-control" ddl_name='ddl_zy' d_value=''
                            title="专业" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        民族<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="NATION" name="NATION" class="form-control" ddl_name='ddl_mz' d_value=''
                            title="民族" show_type="t">
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">
                        班级<span style="color: Red;">*</span></label>
                    <div class="col-sm-4">
                        <select id="CLASS" name="CLASS" class="form-control" ddl_name='ddl_class' d_value=''
                            title="班级" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        学籍状态</label>
                    <div class="col-sm-4">
                        <select id="REGISTER" name="REGISTER" class="form-control" ddl_name='ddl_xjzt' d_value=''
                            title="学籍状态" show_type="t">
                        </select>
                    </div>
                    <label class="col-sm-2 control-label">
                        异动时间</label>
                    <div class="col-sm-4" style="position: relative; z-index: 9999">
                        <input name="DIFFDATE" id="DIFFDATE" type="text" class="form-control timeSingle"
                            placeholder="异动时间" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        考生类别</label>
                    <div class="col-sm-4">
                        <input name="CANDIDATE" id="CANDIDATE" type="text" class="form-control" placeholder="考生类别" />
                    </div>
                    <label class="col-sm-2 control-label">
                        学制</label>
                    <div class="col-sm-4">
                        <select id="SYSTEM" name="SYSTEM" class="form-control" ddl_name='ddl_edu_system'
                            d_value='' title="学制" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        联系电话</label>
                    <div class="col-sm-4">
                        <input name="MOBILENUM" id="MOBILENUM" type="text" class="form-control" placeholder="联系电话" />
                    </div>
                    <label class="col-sm-2 control-label">
                        饭卡号</label>
                    <div class="col-sm-4">
                        <input name="RICE_CARD" id="RICE_CARD" type="text" class="form-control" placeholder="饭卡号" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">
                        家庭所在地</label>
                    <div class="col-sm-2">
                        <select class="form-control" name="ADD_PROVINCE" id="ADD_PROVINCE" d_value='' ddl_name='ddl_province'
                            show_type='t'>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" name="ADD_CITY" id="ADD_CITY" d_value='' ddl_name=''
                            show_type='t'>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" name="ADD_COUNTY" id="ADD_COUNTY" d_value='' ddl_name=''
                            show_type='t'>
                        </select>
                    </div>
                    <div class="col-sm-4">
                        <input type="text" class="form-control" id="ADD_STREET" name="ADD_STREET" value=''
                            placeholder="家庭地址">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save" id="btnSave">
                    保存</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <div class="modal fade" id="importModal">
        <div class="modal-dialog">
            <form id="form_import" name="form_edit" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    学生基本信息批量导入</h4>
            </div>
            <div class="modal-body">
                <iframe id="importFrame" frameborder="0" src="" style="width: 100%; height: 250px;
                    display: block;"></iframe>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				{
				    "data": "OID",
				    "createdCell": function (nTd, sData, oData, iRow, iCol) {
				        $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				    },
				    "head": "checkbox", "id": "checkAll"
				},
				{ "data": 'NUMBER', "head": '学号', "type": "td-keep" },
				{ "data": 'NAME', "head": '姓名', "type": "td-keep" },
				{ "data": 'COLLEGE_NAME', "head": '学院', "type": "td-keep" },
				{ "data": 'MAJOR_NAME', "head": '专业', "type": "td-keep" },
				{ "data": 'EDULENTH', "head": '年级', "type": "td-keep" },
				{ "data": 'SEX_NAME', "head": '性别', "type": "td-keep" },
				{ "data": 'IDCARDNO', "head": '身份证号', "type": "td-keep" },
				{ "data": 'GARDE', "head": '出生日期', "type": "td-keep" },
				{ "data": 'NATION_NAME', "head": '民族', "type": "td-keep" },
				{ "data": 'POLISTATUS_NAME', "head": '政治面貌', "type": "td-keep" },
                { "data": 'REGISTER_NAME', "head": '学籍状态', "type": "td-keep" },
                { "data": 'DIFFDATE', "head": '异动时间', "type": "td-keep" },
				{ "data": 'CLASS_NAME', "head": '班级', "type": "td-keep" },
				{ "data": 'STUTYPE_NAME', "head": '学生类型', "type": "td-keep" },
				{ "data": 'EMAIL', "head": 'EMAIL', "type": "td-keep" },
				{ "data": 'QQNUM', "head": 'QQ号码', "type": "td-keep" }
			];

            //配置表格
            tablePackage.createOne({
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
                    tableTitle: "学生基本信息录入",
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
						{ "data": "NUMBER", "pre": "学号", "col": 1, "type": "input" },
						{ "data": "NAME", "pre": "姓名", "col": 2, "type": "input" },
						{ "data": "IDCARDNO", "pre": "身份证号", "col": 3, "type": "input" },
						{ "data": "COLLEGE", "pre": "学院", "col": 4, "type": "select", "ddl_name": "ddl_department" },
						{ "data": "MAJOR", "pre": "专业", "col": 5, "type": "select", "ddl_name": "ddl_zy" },
						{ "data": "EDULENTH", "pre": "年级", "col": 6, "type": "select", "ddl_name": "ddl_grade" },
						{ "data": "CLASS", "pre": "班级", "col": 7, "type": "select", "ddl_name": "ddl_class" },
						{ "data": "STUTYPE", "pre": "学生类型", "col": 8, "type": "select", "ddl_name": "ddl_basic_stu_type" },
                        { "data": "REGISTER", "pre": "学籍状态", "col": 8, "type": "select", "ddl_name": "ddl_xjzt" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add", "edit", "del",
                    { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                    <%if (IsShowBtn){ %>
					{ type: "enter", modal: null, title: "本科生导入模板下载", action: "download1" },
					{ type: "enter", modal: null, title: "研究生导入模板下载", action: "download2" },
					{ type: "enter", modal: null, title: "本科生批量导入", action: "import1" },
					{ type: "enter", modal: null, title: "研究生批量导入", action: "import2" },
                    <%} %>
                    { type: "enter", modal: null, title: "学生信息导出", action: "download3" }
				], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            $(document).on("click", "button[data-action='download1']", function () {
                window.open('/Excel/Model/Student/本科学生基本信息.xls');
            });
            $(document).on("click", "button[data-action='download2']", function () {
                window.open('/Excel/Model/Student/研究生基本信息.xls');
            });
            $(document).on("click", "button[data-action='download3']", function () {
                //要选择学生类型，否则提示
                if ($("#search-STUTYPE").val().length == 0) {
                    easyAlert.timeShow({
                        "content": "请选择学生类型，再进行导出数据操作！",
                        "duration": 3,
                        "type": "info"
                    });
                    return;
                }
                //导出
                var strq = "";
                if ($('#search-NUMBER').val())
                    strq += "&NUMBER=" + OptimizeUtils.FormatParamter($('#search-NUMBER').val());
                if ($('#search-NAME').val())
                    strq += "&NAME=" + OptimizeUtils.FormatParamter($('#search-NAME').val());
                if ($('#search-IDCARDNO').val())
                    strq += "&IDCARDNO=" + $('#search-IDCARDNO').val();
                if ($('#search-MAJOR').val())
                    strq += "&MAJOR=" + $('#search-MAJOR').val();
                if ($('#search-EDULENTH').val())
                    strq += "&EDULENTH=" + $('#search-EDULENTH').val();
                if ($('#search-CLASS').val())
                    strq += "&CLASS=" + $('#search-CLASS').val();
                if ($('#search-STUTYPE').val())
                    strq += "&STUTYPE=" + $('#search-STUTYPE').val();
                window.open('/Excel/ExportExcel/ExportExcel.aspx?optype=stulist_input' + strq);
            });
            $(document).on("click", "button[data-action='import1']", function () {
                $("#importFrame").attr("src", '/Excel/ImportExcel/ImportExcel.aspx?model_id=importModal&type=INPUT_STU_BK');
                $("#importModal").modal();
            });
            $(document).on("click", "button[data-action='import2']", function () {
                $("#importFrame").attr("src", '/Excel/ImportExcel/ImportExcel.aspx?model_id=importModal&type=INPUT_STU_YJS');
                $("#importModal").modal();
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
				    del: '.btn-del'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });

            //【查阅】
            _content.on('click', "#view", function () {
                var data = tablePackage.selectSingle();
                if (data) {
                    if (data.OID) {
                        //设置各个标签页的隐藏域的SEQ_NO
                        $("#OID").val(data.OID);
                        //设置界面值
                        _form_edit.setFormData(data);
                        //设置界面不可编辑
                        _form_edit.disableAll();
                        //设置按钮不可见
                        $("#btnSave").hide();
                        //初始化编辑界面
                        $("#tableModal").modal();
                    }
                }
            });

            /*弹出页控制*/
            $dataModal.controls({
                "content": "content",
                "modal": "tableModal", //弹出层id
                "hasTime": true, //时间控件控制
                "hasCheckBox": false, //checkbox控制
                "submitType": "form", //form或者ajax
                "submitBtn": ".btn-save",
                "submitCallback": function (btn) {
                    console.log(btn);

                }, //自定义方法
                "valiConfig": {
                    model: '#tableModal form',
                    validate: [
						{ 'name': 'NUMBER', 'tips': '学号必须填' },
						{ 'name': 'NAME', 'tips': '姓名必须填' },
						{ 'name': 'STUTYPE', 'tips': '学生类别必须填' },
						{ 'name': 'ENROLLING', 'tips': '入学方式必须填' },
						{ 'name': 'EMAIL', 'tips': '电子邮箱必须填' },
						{ 'name': 'QQNUM', 'tips': 'QQ号码必须填' },
						{ 'name': 'SEX', 'tips': '性别必须填' },
						{ 'name': 'GARDE', 'tips': '出生日期必须填' },
						{ 'name': 'EDULENTH', 'tips': '年级必须填' },
						{ 'name': 'COLLEGE', 'tips': '学院必须填' },
						{ 'name': 'MAJOR', 'tips': '专业必须填' },
						{ 'name': 'NATION', 'tips': '民族必须填' },
						{ 'name': 'CLASS', 'tips': '班级必须填' },
						{ 'name': 'SYSTEM', 'tips': '学制必须填' },
                        { 'name': 'REGISTER', 'tips': '学籍状态必须填' }
					],
                    callback: function (form) {
                        console.log(form);
                        SaveData();
                    }
                },
                "afterShow": function (data) {
                    //设置界面可编辑
                    _form_edit.cancel_disableAll();
                    //设置按钮不可见
                    $("#btnSave").show();
                    if (data) {
                        $("#NUMBER").attr("readonly", "readonly");
                        SelectUtils.XY_ZY_Grade_ClassCodeChange("COLLEGE", "MAJOR", "EDULENTH", "CLASS", data.COLLEGE, data.MAJOR, data.EDULENTH, data.CLASS);
                        //家庭地址
                        var address = data.ADDRESS;
                        var arrAddress = address.split('|');
                        var province = arrAddress[0];
                        var city = arrAddress[1];
                        var county = arrAddress[2];
                        var strAddress = arrAddress[3];
                        SelectUtils.RegionCodeChange('ADD_PROVINCE', 'ADD_CITY', 'ADD_COUNTY', province, city, county);
                        $("#ADD_STREET").val(strAddress);
                    } else {
                        $("#NUMBER").removeAttr("readonly");
                        SelectUtils.XY_ZY_Grade_ClassCodeChange("COLLEGE", "MAJOR", "EDULENTH", "CLASS");
                    }
                },
                "beforeSubmit": function () {
                    var IDCARDNO = $("#IDCARDNO").val();
                    var strUrl = OptimizeUtils.FormatUrl('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=check_idnumber&idno=' + IDCARDNO);
                    var strResult = AjaxUtils.getResponseText(strUrl);
                    if (strResult.length > 0) {
                        easyAlert.timeShow({
                            "content": "身份证格式不正确！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return false;
                    }

                    var EMAIL = $("#EMAIL").val();
                    var strUrl = OptimizeUtils.FormatUrl('?optype=chkem&idno=' + EMAIL);
                    var strResult = AjaxUtils.getResponseText(strUrl);
                    if (strResult.length > 0) {
                        easyAlert.timeShow({
                            "content": "Email格式不正确！",
                            "duration": 2,
                            "type": "danger"
                        });
                        return false;
                    }
                    return true;
                }
            });

            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
        }
        //保存事件
        function SaveData() {
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
                    //保存成功：关闭界面，刷新列表
                    $("#tableModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "保存成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    tablePackage.reload();
                }
            });
        }

        //删除事件
        function DeleteData() {
            var data = tablePackage.selectSingle();
            if (data) {
                if (data.OID) {
                    easyConfirm.locationShow({
                        'type': 'warn',
                        'content': "确认删除选中的数据吗？",
                        'title': '删除数据',
                        'callback': function (btn) {
                            var result = AjaxUtils.getResponseText("List.aspx?optype=delete&id=" + data.OID);
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
                                tablePackage.reload();
                            }
                        }
                    });
                }
            }
        }
        //导入时，调用父界面的刷新方法，所以父界面这个方法一定要定义
        function ImportReload() {
            tablePackage.reload();
        }
    </script>
</asp:Content>