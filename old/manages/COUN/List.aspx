<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.COUN.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var _form_edit;
        $(function () {
            adaptionHeight();

            loadTableList();
            loadModalBtnInit();
            $("select").each(function () {
                if ($(this).attr("ddl_name"))
                    DropDownUtils.initDropDown($(this).attr("id"));
            });
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
			<h1>辅导员信息录入</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">辅导员信息录入</li>
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
    <div class="modal" id="tableModal">
        <div class="modal-dialog" style="width: 700px;">
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
            onsubmit="return false;">
            <input type="hidden" id="OID" name="OID" />
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">辅导员基本信息录入</h4>
            </div>
            <div class="modal-body">
            <div id="" class="row">
            
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        职工号<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <input name="ENO" id="ENO" type="text" class="form-control" placeholder="职工号" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        姓名<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <input name="NAME" id="NAME" type="text" class="form-control" placeholder="姓名" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        性别<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <select id="SEX" name="SEX" class="form-control" ddl_name='ddl_xb' d_value='' title="性别"
                            show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        身份证号<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <input name="IDCARDNO" id="IDCARDNO" type="text" class="form-control" placeholder="身份证号" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        政治面貌</label>
                    <div class="col-sm-8">
                        <select id="POLISTATUS" name="POLISTATUS" class="form-control" ddl_name='ddl_zzmm'
                            d_value='' title="政治面貌" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        出生日期</label>
                    <div class="col-sm-8" style="position: relative; z-index: 9999">
                        <input name="GARDE" id="GARDE" type="text" class="form-control timeSingle" placeholder="出生日期" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label" style="padding-left: 5px; padding-right: 5px">
                        入校工作时间</label>
                    <div class="col-sm-8" style="position: relative; z-index: 9999">
                        <input name="ENTERTIME" id="ENTERTIME" type="text" class="form-control timeSingle"
                            placeholder="入校工作时间" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        家庭住址</label>
                    <div class="col-sm-8">
                        <input name="ADDRESS" id="ADDRESS" type="text" class="form-control" placeholder="家庭住址" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        移动电话</label>
                    <div class="col-sm-8">
                        <input name="MOBILENUM" id="MOBILENUM" type="text" class="form-control" placeholder="移动电话" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        电子邮箱</label>
                    <div class="col-sm-8">
                        <input name="EMAIL" id="EMAIL" type="text" class="form-control" placeholder="电子邮箱" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        毕业院校</label>
                    <div class="col-sm-8">
                        <input name="UNIVE" id="UNIVE" type="text" class="form-control" placeholder="毕业院校" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        所学专业</label>
                    <div class="col-sm-8">
                        <select id="MAJOR" name="MAJOR" class="form-control" ddl_name='ddl_zy' d_value=''
                            title="所学专业" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        民族</label>
                    <div class="col-sm-8">
                        <select id="NATION" name="NATION" class="form-control" ddl_name='ddl_mz' d_value=''
                            title="民族" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label" style="padding-left: 5px; padding-right: 5px">
                        所在部门名称<span style="color: Red;">*</span></label>
                    <div class="col-sm-8">
                        <select id="DEPARTMENT" name="DEPARTMENT" class="form-control" ddl_name='ddl_all_department'
                            d_value='' title="所在部门名称" show_type="t">
                        </select>
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        办公电话</label>
                    <div class="col-sm-8">
                        <input name="OFFICEPHONE" id="OFFICEPHONE" type="text" class="form-control" placeholder="办公电话" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        传真</label>
                    <div class="col-sm-8">
                        <input name="FAX" id="FAX" type="text" class="form-control" placeholder="传真" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        籍贯县市</label>
                    <div class="col-sm-8">
                        <input name="NATIVEPLACE" id="NATIVEPLACE" type="text" class="form-control" placeholder="籍贯县市" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        家庭电话</label>
                    <div class="col-sm-8">
                        <input name="HOMENUM" id="HOMENUM" type="text" class="form-control" placeholder="家庭电话" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        固定电话</label>
                    <div class="col-sm-8">
                        <input name="FIXHPONE" id="FIXHPONE" type="text" class="form-control" placeholder="固定电话" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        专兼职</label>
                    <div class="col-sm-8">
                        <input name="PORJOB" id="PORJOB" type="text" class="form-control" placeholder="专兼职" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        通讯地址</label>
                    <div class="col-sm-8">
                        <input name="POSTADDRESS" id="POSTADDRESS" type="text" class="form-control" placeholder="通讯地址" />
                    </div>
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
    <div class="modal" id="importModal">
        <div class="modal-dialog">
            <form id="form_import" name="form_edit" class="modal-content form-horizontal form-inline">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    辅导员基本信息批量导入</h4>
            </div>
            <div class="modal-body">
            <div class="row">
                <div class="form-group col-sm-12">
                    <iframe id="importFrame" frameborder="0" src="" style="width: 100%; height: 250px;">
                    </iframe>
                </div>
            </div>
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
				{ "data": "ENO", "head": "职工号", "type": "td-keep" },
				{ "data": "NAME", "head": "姓名", "type": "td-keep" },
				{ "data": 'SEX_NAME', "head": '性别', "type": "td-keep" },
				{ "data": 'IDCARDNO', "head": '身份证号', "type": "td-keep" },
               	{ "data": 'FIXHPONE', "head": '固定电话', "type": "td-keep" },
				{ "data": 'GARDE', "head": '出生日期', "type": "td-keep" },
				{ "data": 'MOBILENUM', "head": '联系电话', "type": "td-keep" },
				{ "data": 'MAJOR_NAME', "head": '专业', "type": "td-keep" },
				{ "data": 'NATION_NAME', "head": '民族', "type": "td-keep" },
				{ "data": 'POLISTATUS_NAME', "head": '政治面貌', "type": "td-keep" },
				{ "data": 'DEPARTMENT_NAME', "head": '所在部门名称', "type": "td-keep" },
				{ "data": 'UNIVE', "head": '毕业院校', "type": "td-keep" }
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
                    tableTitle: "辅导员基本信息导入",
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
						{ "data": "ENO", "pre": "职工号", "col": 1, "type": "input" },
						{ "data": "NAME", "pre": "姓名", "col": 2, "type": "input" },
						{ "data": "IDCARDNO", "pre": "身份证号", "col": 3, "type": "input" },
                           { "data": "DEPARTMENT", "pre": "所在部门", "col": 4, "type": "select", "ddl_name": "ddl_all_department" }
					]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload","edit", "del",
                    <%if (IsShowBtn){ %>
                    "add",
					{ type: "enter", modal: null, title: "辅导员导入模板下载", action: "download" },
					{ type: "enter", modal: null, title: "批量导入", action: "import" },
                    <%} %>
                    { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
				], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            $(document).on("click", "button[data-action='download']", function () {
                window.open('/Excel/Model/Coun/辅导员基本信息.xls');
            });
            $(document).on("click", "button[data-action='import']", function () {
                $("#importFrame").attr("src", '/Excel/ImportExcel/ImportExcel.aspx?type=INPUT_COUN');
                $("#importModal").modal();
            });
        }
    </script>
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _btns = {
                reload: '.btn-reload',
                del: '.btn-del'
            };

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reDraw();
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
						{ 'name': 'ENO', 'tips': '职工号必须填' },
						{ 'name': 'NAME', 'tips': '姓名必须填' },
						{ 'name': 'SEX', 'tips': '性别必须填' },
						{ 'name': 'IDCARDNO', 'tips': '身份证号必须填' },
                    //						{ 'name': 'POLISTATUS', 'tips': '政治面貌必须填' },
                    //						{ 'name': 'GARDE', 'tips': '出生日期必须填' },
                    //						{ 'name': 'ENTERTIME', 'tips': '入校工作时间必须填' },
                    //						{ 'name': 'MOBILENUM', 'tips': '移动电话必须填' },
                    //						{ 'name': 'EMAIL', 'tips': '电子邮箱必须填' },
                    //						{ 'name': 'UNIVE', 'tips': '毕业院校必须填' },
                    //						{ 'name': 'NATION', 'tips': '民族必须填' },
						{'name': 'DEPARTMENT', 'tips': '所在部门名称必须填' }

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
                        $("#ENO").attr("readonly", "readonly");
                    }
                    else {
                        $("#ENO").removeAttr("readonly");
                    }
                },
                "beforeSubmit": function () {
                    var IDCARDNO = $("#IDCARDNO").val();
                    var strUrl = OptimizeUtils.FormatUrl('?optype=chkid&idno=' + IDCARDNO);
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
                    if (EMAIL.length > 0) {
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
    </script>
</asp:Content>