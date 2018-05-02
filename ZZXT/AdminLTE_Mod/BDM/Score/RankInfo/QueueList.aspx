<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="QueueQueueList.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.Score.RankInfo.QueueList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            adaptionHeight();

            loadTableList();
            loadModalBtnInit();
            loadModalPageDataInit();
            loadModalPageValidate();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!-- 列表界面 开始-->
    <div class="wrapper">
        <div class="content-wrapper" id="main-container">
            <section class="content-header">
			<h1>成绩排名</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>成绩管理</li>
				<li class="active">成绩排名</li>
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
                    <label class="col-sm-4 control-label">计算排名学生类型</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="STU_TYPE" id="STU_TYPE" d_value='' ddl_name='ddl_basic_stu_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">计算排名学年</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="YEAR" id="YEAR" d_value='' ddl_name='ddl_year_type' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">计算排名年级</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="GRADE" id="GRADE" d_value='' ddl_name='ddl_grade' show_type='t'>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">计算排名班级</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="CLASSCODE" id="CLASSCODE" d_value='' ddl_name='ddl_class' show_type='t'>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-save">确认</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 删除界面 结束-->
    <div class="modal fade" id="delModal">
        <div class="modal-dialog">
            <form action="#" method="post" id="form_del" name="form_del" class="modal-content form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">按时间段删除操作</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label class="col-sm-4 control-label">起始删除时间</label>
                    <div class="col-sm-8">
                        <input id="Fromdate" name="Fromdate" type="text" class="form-control datep" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">截止删除时间</label>
                    <div class="col-sm-8">
                        <input id="toDATE" name="toDATE" type="text" class="form-control datep" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-delete" id="btnDel">删除</button>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </div>
            </form>
        </div>
    </div>
    <!-- 删除界面 结束-->
    <!-- 列表JS 开始-->
    <script type="text/javascript">
        //列表初始化
        function loadTableList() {
            //配置表格列
            tablePackage.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "YEAR_NAME", "head": "学年", "type": "td-keep" },
				    { "data": "GRADE", "head": "年级", "type": "td-keep" },
				    { "data": "CLASSCODE_NAME", "head": "班级", "type": "td-keep" },
                    { "data": "STU_TYPE_NAME", "head": "学生类型", "type": "td-keep" },
				    { "data": "CREATE_USER", "head": "创建人", "type": "td-keep" },
				    { "data": "CREATE_TIME", "head": "创建时间", "type": "td-keep" },
				    { "data": "HANDLE_STATUS", "head": "处理标识", "type": "td-keep" },
                    { "data": "HANDLE_TIME", "head": "处理时间", "type": "td-keep" },
                    { "data": "HANDLE_MSG", "head": "异常原因", "type": "td-keep" }
		    ];

            //配置表格
            tablePackage.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "QueueList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "计算排名",
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
                        { "data": "YEAR", "pre": "学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=strLastYear %>" },
                        { "data": "GRADE", "pre": "年级", "col": 2, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASSCODE", "pre": "班级", "col": 3, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_TYPE", "pre": "学生类型", "col": 3, "type": "select", "ddl_name": "ddl_basic_stu_type" },
                        { "data": "HANDLE_STATUS", "pre": "处理标识", "col": 4, "type": "select", "ddl_name": "ddl_queue_status" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "add",
                { type: "userDefined", id: "update_rank", title: "重新计算排名", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "del_queue", title: "删除", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //年级、班级联动
            SelectUtils.Grade_ClassCodeChange("search-GRADE", "search-CLASSCODE");

            //重新计算排名 按钮事件
            $(document).on("click", "#update_rank", function () {
                var data = tablePackage.selectSingle();
                if (!data.OID) {
                    easyAlert.timeShow({
                        "content": "请选中一行数据！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                var result = AjaxUtils.getResponseText("QueueList.aspx?optype=update&id=" + data.OID);
                if (result.length == 0) {
                    easyAlert.timeShow({
                        "content": "重新计算排名处理成功！",
                        "duration": 2,
                        "type": "info"
                    });
                    tablePackage.reload();
                }
                else {
                    easyAlert.timeShow({
                        "content": result,
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            });
            //删除
            $(document).on("click", "#del_queue", function () {
                $("#delModal").modal();
            });
            $("#btnDel").click(function () {
                if ($("#form_del").valid()) {
                    var Fromdate = $("#Fromdate").val();
                    var toDATE = $("#toDATE").val();
                    $.post("?optype=del", { Fromdate: Fromdate, toDATE: toDATE }, function (msg) {
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
                    })
                }
            });
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content"),
				_btns = {
				    reload: '.btn-reload'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
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
                        { 'name': 'STU_TYPE', 'tips': '学生类型必须填' },
						{ 'name': 'YEAR', 'tips': '学年必须填' },
						{ 'name': 'GRADE', 'tips': '年级必须填' }
					],
                    callback: function (form) {
                        SaveData();
                    }
                },
                "beforeSubmit": function () {
                    return onBeforeSave();
                },
                "beforeShow": function (data) {//编辑页加载前控制，true可编辑，false不可编辑
                    //默认可编辑
                    return true;
                },
                "afterShow": function (data) {//编辑页加载后控制，自定义
                    if (data) {
                        //修改时，学号不能修改
                        if (data.OID && data.OID.length != 0) { //校验是否可以编辑
                            $("#hidOid").val(data.OID);
                        }
                        else {
                            $("#hidOid").val("");
                            //年级、班级联动
                            SelectUtils.Grade_ClassCodeChange("GRADE", "CLASSCODE");
                            //设置学年
                            DropDownUtils.setDropDownValue("YEAR", '<%=sch_info.CURRENT_YEAR %>');
                        }
                    }
                    else {
                        $("#hidOid").val("");
                        //年级、班级联动
                        SelectUtils.Grade_ClassCodeChange("GRADE", "CLASSCODE");
                        //设置学年
                        DropDownUtils.setDropDownValue("YEAR", '<%=sch_info.CURRENT_YEAR %>');
                    }
                }
            });
        }

        function onBeforeSave() {
            return true;
        }
        //保存事件
        function SaveData() {
            $.post(OptimizeUtils.FormatUrl("QueueList.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
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
                    $("#tableModal").modal("hide");
                    easyAlert.timeShow({
                        "content": "新增计算排名成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    tablePackage.reload();
                }
            });
        }
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("STU_TYPE");
            DropDownUtils.initDropDown("YEAR");
            DropDownUtils.initDropDown("CLASSCODE");
            DropDownUtils.initDropDown("GRADE");
        }
    </script>
    <!-- 编辑页验证事件-->
    <script type="text/javascript">
        function loadModalPageValidate() {
            ValidateUtils.setRequired("#form_del", "Fromdate", true, "起始删除时间必填");
            ValidateUtils.setRequired("#form_del", "toDATE", true, "截止删除时间必填");
            //$(".datep").datepicker({
            //    format: 'yyyy-mm-dd',
            //    autoclose: true,
            //    language: "zh-CN"
            //});
            lay('.datep').each(function(inx, element){
              //TODO 实例化 遍历
              laydate.render({
                elem: this,
                trigger: 'click',
              });
            });
        }
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">

    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
