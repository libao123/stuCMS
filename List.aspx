<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.ClassGroup.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            if (window.parent) {//让多重导航条消失的，让iframe的高度自适应
                setTimeout(function () {
                    var _pageH = $("body").height();
                    var _parentIfm = $('#iframe_box', window.parent.document);
                    if (_parentIfm.height() < _pageH) {
                        _parentIfm.css({ 'height': _pageH, 'overflow': 'hidden' });
                    } else {
                    }
                }, 200);
            }

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
            <form action="#" method="post" id="form_edit" name="form_edit" class="modal-content form-horizontal form-inline"
            onsubmit="return false;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    编班申请</h4>
            </div>
            <div class="modal-body row">
                <input type="hidden" id="hidOid" name="hidOid" value="" />
                <input type="hidden" id="hidGroupClass" name="hidGroupClass" value="" />
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        班级名称</label>
                    <div class="col-sm-8">
                        <input name="CLASSNAME" id="CLASSNAME" type="text" class="form-control" placeholder="班级名称" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        年级</label>
                    <div class="col-sm-8">
                        <input name="GRADE" id="GRADE" type="text" class="form-control" placeholder="年级" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        学院</label>
                    <div class="col-sm-8">
                        <input name="XY_NAME" id="XY_NAME" type="text" class="form-control" placeholder="学院" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        专业</label>
                    <div class="col-sm-8">
                        <input name="ZY_NAME" id="ZY_NAME" type="text" class="form-control" placeholder="专业" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        辅导员工号</label>
                    <div class="col-sm-8">
                        <input name="GROUP_NUMBER" id="GROUP_NUMBER" type="text" class="form-control" placeholder="班级辅导员工号"
                            onblur="GetFDYInfo();" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        辅导员姓名</label>
                    <div class="col-sm-8">
                        <input name="GROUP_NAME" id="GROUP_NAME" type="text" class="form-control" placeholder="班级辅导员姓名" />
                    </div>
                </div>
                <div class="form-group col-sm-6">
                    <label class="col-sm-4 control-label">
                        辅导员类型</label>
                    <div class="col-sm-8">
                        <select class="form-control" name="GROUP_TYPE" id="GROUP_TYPE" d_value='' ddl_name='ddl_group_type'
                            show_type='t'>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-select">
                    选择辅导员</button>
                <button type="button" class="btn btn-primary btn-save">
                    提交</button>
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
            </form>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 辅导员列表选择 开始 -->
    <div class="modal fade" id="fdyListModal">
        <div class="modal-dialog">
            <div class="row">
                <div class="col-md-12">
                    <!-- Custom Tabs -->
                    <div class="nav-tabs-custom">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tab_1" data-toggle="tab">辅导员</a></li>
                            <li><a href="#tab_2" data-toggle="tab">研究生</a></li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="tab_1">
                                <table id="tablelist_fdy" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                            <div class="tab-pane" id="tab_2">
                                <table id="tablelist_yjs" class="table table-bordered table-striped table-hover">
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                    关闭</button>
            </div>
        </div>
    </div>
    <!-- 辅导员列表选择 结束-->
    <!-- 删除界面 结束-->
    <div class="modal modal-warning" id="delModal">
        <div class="modal-dialog">
            <form id="form_del" name="form_del" class="modal-content  form-horizontal">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    删除</h4>
            </div>
            <div class="modal-body">
                <p>
                    确定要删除该信息？</p>
                <input type="hidden" name="OID" value="" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">
                    取消</button>
                <button type="button" class="btn btn-outline btn-delete">
                    确定</button>
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
                    { "data": "XY_NAME", "head": "学院" },
				    { "data": "ZY_NAME", "head": "专业" },
				    { "data": "GRADE_NAME", "head": "年级" },
				    { "data": "CLASSNAME", "head": "班级" },
				    { "data": "GROUP_NUMBER", "head": "班级辅导员工号" },
				    { "data": "GROUP_NAME", "head": "班级辅导员姓名" },
				    { "data": "GROUP_TYPE", "head": "班级辅导员类型" },
				    { "data": "OP_NAME", "head": "申报人" },
                    { "data": "DECL_TIME", "head": "申请时间" },
                    { "data": "CHK_TIME", "head": "审核时间" },
                    { "data": "DECLARE_TYPE", "head": "申请类型" },
                    { "data": "RET_CHANNEL", "head": "编班状态" },
                    { "data": "SEQ_NO", "head": "单据编号" }
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
                    tableTitle: "系统维护 >> 编班管理 >> 编班申请",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true//用户改变分页
                        //'ordering':true//是否默认排序，默认为false
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
					    { "data": "XY", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 3, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASSCODE", "pre": "班级", "col": 4, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "GROUP_NUMBER", "pre": "班级辅导员工号", "col": 5, "type": "input" },
                        { "data": "GROUP_NAME", "pre": "班级辅导员名称", "col": 6, "type": "input" },
                        { "data": "GROUP_TYPE", "pre": "班级辅导员类型", "col": 7, "type": "select", "ddl_name": "ddl_group_type" },
                        { "data": "RET_CHANNEL", "pre": "编班状态", "col": 8, "type": "select", "ddl_name": "ddl_RET_CHANNEL" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload", "edit", "del",
                { type: "enter", modal: null, title: "撤销", action: "revoke" },
                { type: "enter", modal: null, title: "撤销申请", action: "revoke_apply" },
                { type: "enter", modal: null, title: "审核流程跟踪", action: "history" }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASSCODE");

            //撤销
            $(document).on("click", "button[data-action='revoke']", function () {
                Revoke();
            });
            //撤销申请
            $(document).on("click", "button[data-action='revoke_apply']", function () {
                RevokeDeclare();
            });
            //审核流程跟踪
            $(document).on("click", "button[data-action='history']", function () {
                MultiAudit('N');
            });
        }

        //辅导员列表加载
        function fdyListLoad() {
            //配置表格列
            tablePackage.filed = [
				    { "data": "ENO",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "ENO", "head": "职工号" },
           			{ "data": "NAME", "head": "姓名" },
                    { "data": "DEPARTMENT", "head": "所在部门名称" }
		    ];

            //配置表格
            tablePackage.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "FdyList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_fdy", //表格id
                    buttonId: "buttonId_fdy", //拓展按钮区域id
                    tableTitle: "系统维护 >> 编班管理 >> 编班申请",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true//用户改变分页
                        //'ordering':true//是否默认排序，默认为false
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
                        { "data": "ENO", "pre": "职工号", "col": 1, "type": "input" },
                        { "data": "NAME", "pre": "姓名", "col": 2, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                { type: "enter", modal: null, title: "选择", action: "history" }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }

        //研究生列表加载
        function yjsListLoad() {
            //配置表格列
            tablePackage.filed = [
				    { "data": "NUMBER",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "NUMBER", "head": "学号" },
				    { "data": "NAME", "head": "姓名" },
				    { "data": "CLASS", "head": "所在班级" }
		    ];

            //配置表格
            tablePackage.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "YjsList.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_yjs", //表格id
                    buttonId: "buttonId_yjs", //拓展按钮区域id
                    tableTitle: "系统维护 >> 编班管理 >> 编班申请",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true//用户改变分页
                        //'ordering':true//是否默认排序，默认为false
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
                        { "data": "NUMBER", "pre": "学号", "col": 1, "type": "input" },
                        { "data": "NAME", "pre": "姓名", "col": 2, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                { type: "enter", modal: null, title: "选择", action: "history" }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
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
                _tableModal = $("#tableModal"),
				_btns = {
				    reload: '.btn-reload',
				    select: '.btn-select'
				};

            //刷新
            _content.on('click', _btns.reload, function () {
                tablePackage.reload();
            });

            //选择辅导员
            _tableModal.on('click', _btns.select, function () {
                $("#fdyListModal").modal();
                fdyListLoad();
                yjsListLoad();
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
						{ 'name': 'GROUP_NUMBER', 'tips': '班级辅导员工号必须填' },
						{ 'name': 'GROUP_NAME', 'tips': '班级辅导员姓名必须填' },
						{ 'name': 'GROUP_TYPE', 'tips': '班级辅导员类型必须填' }
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
                    if (data) {
                        if (!data.OID && data.OID.length != 0)  //校验是否可以编辑
                        {
                            var url = "/CHK/Declare.aspx?optype=chkdeclare&doc_type=" + data.DOC_TYPE
                            + '&seq_no=' + data.SEQ_NO + '&user_role=<%=user.User_Role%>';
                            var result = AjaxUtils.getResponseText(url);
                            if (result.length > 0) {
                                easyAlert.timeShow({
                                    'type': 'warn',
                                    "duration": 2,
                                    'content': result
                                });
                                return false;
                            }
                        }
                    }
                    return true;
                },
                "afterShow": function (data) {//编辑页加载后控制，自定义
                    if (data) {
                        if (!data.OID && data.OID.length != 0) {//新增时
                            $("hidOid").val(data.OID);
                            $("hidGroupClass").val(data.CLASSCODE);
                        }
                        else {//修改时
                            $("hidOid").val("");
                            $("hidGroupClass").val("");
                        }
                        //设置界面不可编辑项
                        ControlUtils.Input_SetReadOnlyStatus("CLASSNAME", true);
                        ControlUtils.Input_SetReadOnlyStatus("GRADE", true);
                        ControlUtils.Input_SetReadOnlyStatus("XY_NAME", true);
                        ControlUtils.Input_SetReadOnlyStatus("ZY_NAME", true);
                        ControlUtils.Input_SetReadOnlyStatus("GROUP_NAME", true);
                        ControlUtils.Select_SetDisableStatus("GROUP_TYPE", true);
                        ControlUtils.Input_SetReadOnlyStatus("OP_NAME", true);
                        ControlUtils.Input_SetReadOnlyStatus("DECL_TIME", true);
                        ControlUtils.Input_SetReadOnlyStatus("CHK_TIME", true);
                    }
                    else {
                        $("hidOid").val("");
                        $("hidGroupClass").val("");
                    }
                }
            });

            /*删除控制*/
            $delModal.controls({
                "content": "content",
                "delModal": "delModal", //弹出层id
                "delSubmit": ".btn-delete",
                "submitCallBack": function (btn) {
                    DeleteData();
                },
                "beforeShow": function (data) {
                    if (data && data.OID.length != 0) {
                        var url = "/CHK/Declare.aspx?optype=chkdeclare&doc_type=" + data.DOC_TYPE
                            + '&seq_no=' + data.SEQ_NO + '&user_role=<%=user.User_Role%>';
                        var result = AjaxUtils.getResponseText(url);
                        if (result.length > 0) {
                            easyAlert.timeShow({
                                'type': 'warn',
                                "duration": 2,
                                'content': result
                            });
                            return false;
                        }
                    }
                    return true;
                }
            });
        }

        //保存前校验
        function onBeforeSave() {
            return true;
        }
        //保存事件
        function SaveData() {
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
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
    </script>
    <!-- 编辑页数据初始化事件-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //下拉初始化
            DropDownUtils.initDropDown("GROUP_TYPE");
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
            LimitUtils.onlyNum("GROUP_NUMBER"); //代码限制只能录入数字
        }
    </script>
    <!-- 编辑页JS 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //通过学工号带出相关信息
        function GetFDYInfo() {
            var num = $("#GROUP_NUMBER").val();
            if (num.length == 0) {
                ClearUserInfo();
                return;
            }

            //判断录入的学号是否为辅导员或者研究生
            var url_chk = "List.aspx?optype=chk&userno=" + num;
            var result_chk = AjaxUtils.getResponseText(url_chk);
            if (result_chk.length > 0) {
                easyAlert.timeShow({
                    "content": result_chk,
                    "duration": 2,
                    "type": "danger"
                });
                ClearUserInfo();
                return;
            }

            //通过学工号获得辅导员基本信息
            var url = "List.aspx?optype=getuserinfo&userno=" + num;
            var result = AjaxUtils.getResponseText(url);
            if (result.length > 0) {
                var jsonResult = eval("(" + result + ")");
                $("#GROUP_NUMBER").val(jsonResult.USERID);
                $("#GROUP_NAME").val(jsonResult.USERNAME);
                DropDownUtils.setDropDownValue("GROUP_TYPE", jsonResult.USERTYPE);
            }
            else {
                easyAlert.timeShow({
                    "content": "不存在该学工号，请确认！",
                    "duration": 2,
                    "type": "danger"
                });
                ClearUserInfo();
                return;
            }
        }

        //清除数据
        function ClearUserInfo() {
            $("#GROUP_NUMBER").val('');
            $("#GROUP_NAME").val('');
            DropDownUtils.setDropDownValue("GROUP_TYPE", '');
        }

        //撤销
        function Revoke() {
            var data = tablePackage.selectSingle();
            if (!data.OID) {
                easyAlert.timeShow({
                    "content": "请选中一行数据/该班级未进行编班申请！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            var result = AjaxUtils.getResponseText('/CHK/Revoke.aspx?optype=chk&doc_type=' + data.DOC_TYPE
            + '&seq_no=' + data.SEQ_NO
            + '&col_name=DECL_NUMBER');
            if (result.length > 0) {
                easyAlert.timeShow({
                    "content": result,
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            result = AjaxUtils.getResponseText('/CHK/Revoke.aspx?optype=revoke&col_name=DECL_NUMBER&doc_type=' + data.DOC_TYPE
                + '&seq_no=' + data.SEQ_NO
                + '&nj=' + escape(data.GRADE)
                + '&xy=' + escape(data.XY)
                + '&bj=' + escape(data.CLASSCODE)
                + '&zy=' + escape(data.ZY));

            if (result.length > 0) {
                easyAlert.timeShow({
                    "content": result,
                    "duration": 2,
                    "type": "danger"
                });
            }
            else {
                easyAlert.timeShow({
                    "content": '撤销成功！',
                    "duration": 2,
                    "type": "info"
                });
            }
        }

        //撤销申请
        function RevokeDeclare() {
            var data = tablePackage.selectSingle();
            if (!data.OID) {
                easyAlert.timeShow({
                    "content": "请选中一行数据/该班级未进行编班申请！",
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }

            var strUrl = '/CHK/Revoke.aspx?optype=chkdecl&doc_type=' + data.DOC_TYPE + '&seq_no=' + data.SEQ_NO;
            var strResult = AjaxUtils.getResponseText(strUrl);
            if (strResult.length > 0) {
                easyAlert.timeShow({
                    "content": strResult,
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
            //申请时传入：tableid：列表id，divid：申请编辑页面id，seq_no：单据编号，doc_type：单据类型
            strUrl = '/CHK/Revoke.aspx?optype=decl&tableid=tabList&divid=auditDiv&doc_type=' + data.DOC_TYPE
            + '&seq_no=' + data.SEQ_NO
            + '&nj=' + escape(data.GRADE)
            + '&xy=' + escape(data.XY)
            + '&bj=' + escape(data.CLASSCODE)
            + '&zy=' + escape(data.ZY);

            //$("#auditFrame").attr("src", OptimizeUtils.FormatUrl(strUrl));
            //$("#auditDiv").show().dialog({ title: '撤销申请', modal: true, draggable: false });
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
