<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.ClassGroup.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList;
        var fdyList;
        var yjsList;
        var revoke_com;
        var wfklog;
        $(function () {
            adaptionHeight();
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
			<h1>编班申请</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">编班申请</li>
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
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">
                    编班申请</h4>
            </div>
            <div class="modal-body clearfix">
                <input type="hidden" id="hidOid" name="hidOid" value="" />
                <input type="hidden" id="hidGroupClass" name="hidGroupClass" value="" />
                <div class="col-xs-12">
                    <div class="form-group">
                        <div class=" col-sm-6">
                            <label class="col-sm-4 control-label">
                                班级名称</label>
                            <div class="col-sm-8">
                                <input name="CLASSNAME" id="CLASSNAME" type="text" class="form-control" placeholder="班级名称" />
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <label class="col-sm-4 control-label">
                                年级</label>
                            <div class="col-sm-8">
                                <input name="GRADE" id="GRADE" type="text" class="form-control" placeholder="年级" />
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class=" col-sm-6">
                            <label class="col-sm-4 control-label">
                                学院</label>
                            <div class="col-sm-8">
                                <input name="XY_NAME" id="XY_NAME" type="text" class="form-control" placeholder="学院" />
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <label class="col-sm-4 control-label">
                                专业</label>
                            <div class="col-sm-8">
                                <input name="ZY_NAME" id="ZY_NAME" type="text" class="form-control" placeholder="专业" />
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class=" col-sm-6">
                            <label class="col-sm-4 control-label">
                                辅导员工号</label>
                            <div class="col-sm-8">
                                <input name="GROUP_NUMBER" id="GROUP_NUMBER" type="text" class="form-control" placeholder="请输入辅导员工号或研究生学号"
                                    onblur="GetFDYInfo();" />
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <label class="col-sm-4 control-label">
                                辅导员姓名</label>
                            <div class="col-sm-8">
                                <input name="GROUP_NAME" id="GROUP_NAME" type="text" class="form-control" placeholder="班级辅导员姓名" />
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class=" col-sm-6">
                            <label class="col-sm-4 control-label">
                                辅导员类型</label>
                            <div class="col-sm-8">
                                <select class="form-control" name="GROUP_TYPE" id="GROUP_TYPE" d_value='' ddl_name='ddl_group_type'
                                    show_type='t'>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-selectlist">
                    选择辅导员</button>
                <button type="button" class="btn btn-primary btn-submitdata">
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
        <div class="modal-dialog modal-dw90">
            <div class="modal-content">
                <div class="modal-body">
                    <!-- Custom Tabs -->
                    <div class="nav-tabs-custom" style="box-shadow: none; margin-bottom: 0px;">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tab_1" data-toggle="tab">辅导员</a></li>
                            <li><a href="#tab_2" data-toggle="tab">研究生</a></li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="tab_1">
                                <div class="box box-default" style="border: none; margin-bottom: 0;">
                                    <table id="tablelist_fdy" class="table table-bordered table-striped table-hover">
                                    </table>
                                </div>
                            </div>
                            <div class="tab-pane" id="tab_2">
                                <div class="box box-default" style="border: none; margin-bottom: 0;">
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
    </div>
    <!-- 辅导员列表选择 结束-->
    <!-- 主列表JS 开始-->
    <script type="text/javascript">
        //主列表初始化
        function loadTableList() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "OID",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "XY_NAME", "head": "学院", "type": "td-keep" },
				    { "data": "ZY_NAME", "head": "专业", "type": "td-keep" },
				    { "data": "GRADE_NAME", "head": "年级", "type": "td-keep" },
				    { "data": "CLASSNAME", "head": "班级", "type": "td-keep" },
				    { "data": "GROUP_NUMBER", "head": "班级辅导员工号", "type": "td-keep" },
				    { "data": "GROUP_NAME", "head": "班级辅导员姓名", "type": "td-keep" },
				    { "data": "GROUP_TYPE_NAME", "head": "班级辅导员类型", "type": "td-keep" },
                    { "data": "RET_CHANNEL", "head": "当前状态", "type": "td-keep" },
                    { "data": "DECLARE_TYPE_NAME", "head": "申请类型", "type": "td-keep" },
				    { "data": "OP_NAME", "head": "申报人", "type": "td-keep" },
                    { "data": "DECL_TIME", "head": "申请时间", "type": "td-keep" },
                    { "data": "CHK_TIME", "head": "审核时间", "type": "td-keep" },
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
                    tableTitle: "编班申请",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(8)');
                            if (aData.RET_CHANNEL == "A0000") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "primary",
                                        "msg": "预录入"
                                    });
                            } else if (aData.RET_CHANNEL == "A0010") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "primary",
                                        "msg": "申请中"
                                    });
                            } else if (aData.RET_CHANNEL == "D1000") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "辅导员待审"
                                    });
                            } else if (aData.RET_CHANNEL == "D1010") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "辅导员通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D1020") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "warning",
                                        "msg": "辅导员不通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D2000") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "院级待审"
                                    });
                            } else if (aData.RET_CHANNEL == "D2010") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "院级通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D2020") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "warning",
                                        "msg": "院级不通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D3000") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "校级待审"
                                    });
                            } else if (aData.RET_CHANNEL == "D3010") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "校级通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D3020") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "warning",
                                        "msg": "校级不通过"
                                    });
                            } else if (aData.RET_CHANNEL == "D4000") {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "success",
                                        "msg": "审批通过"
                                    });
                            } else {
                                tablePackage.statusSpan(_status,
                                    {
                                        "type": "danger",
                                        "msg": "未编班"
                                    });
                            }
                        }
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
                        { "data": "RET_CHANNEL", "pre": "当前状态", "col": 8, "type": "select", "ddl_name": "ddl_RET_CHANNEL" },
                        { "data": "DECLARE_TYPE", "pre": "申请类型", "col": 12, "type": "select", "ddl_name": "ddl_DECLARE_TYPE" },
                        { "data": "STU_TYPE", "pre": "班级类型", "col": 13, "type": "select", "ddl_name": "ddl_basic_stu_type" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload", "edit", "del",
                { type: "userDefined", id: "revoke", title: "撤销", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "revoke_apply", title: "撤销申请", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "history", title: "审核流程跟踪", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASSCODE");
            fdyListLoad();
            yjsListLoad();
            //【审核流程跟踪】
            //------------------审核流程跟踪 开始------------------------------------------
            wfklog = WfkLog.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "wfklogModal"//弹出层的id，不写则默认wfklogModal，必填
                },
                control: {
                    "content": "#content", //必填
                    "btnId": "#history", //触发弹出层的按钮的id，必填
                    "beforeShow": function (btn, form) {//返回btn信息和form信息
                        var data = mainList.selectSingle();
                        if (data) {
                            if (data.OID) {
                                return true;
                            }
                        }
                        return false;
                    },
                    "afterShow": function (btn, form) {//返回btn信息和form信息
                        var data = mainList.selectSingle();
                        _m_wfklog_list.refresh(OptimizeUtils.FormatUrl("/AdminLTE_Mod/Common/ComPage/WkfLogList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        return true;
                    },
                    "beforeSubmit": function (btn, form) {//返回btn信息和form信息
                    }
                }
            });
            //------------------审核流程跟踪 结束------------------------------------------
            //【撤销申请】
            //---------撤销申请  开始------------------
            revoke_com = revokeComPage.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "revokeModal"//弹出层的id，不写则默认verifyModal，必填
                },
                control: {
                    "content": "#content", //必填
                    "btnId": "#revoke_apply", //触发弹出层的按钮的id，必填
                    "beforeShow": function (btn, form) {//返回btn信息和form信息
                        var data = mainList.selectSingle();
                        if (data) {
                            if (data.OID) {
                                //判断是否有撤销权限
                                var strUrl = '/AdminLTE_Mod/CHK/Revoke.aspx?optype=chkdecl&doc_type=' + data.DOC_TYPE + '&seq_no=' + data.SEQ_NO;
                                var strResult = AjaxUtils.getResponseText(strUrl);
                                if (strResult.length > 0) {
                                    easyAlert.timeShow({
                                        "content": strResult,
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                    return false;
                                }
                                $("#revokeMsg").val(""); //初始化默认为空
                                return true;
                            }
                        }
                        else {
                            easyAlert.timeShow({
                                "content": "该班级未进行编班申请！",
                                "duration": 2,
                                "type": "danger"
                            });
                        }
                        return false;
                    },
                    "afterShow": function (btn, form) {//返回btn信息和form信息
                        return true;
                    },
                    "beforeSubmit": function (btn, form) {//返回btn信息和form信息
                        return true;
                    },
                    validCallback: function (form) {//验证通过之后的操作
                        var data = mainList.selectSingle();
                        //提交撤销申请
                        var revokeurl = OptimizeUtils.FormatUrl('/AdminLTE_Mod/CHK/Revoke.aspx?optype=submit_revoke&doc_type=' + data.DOC_TYPE
                        + '&seq_no=' + data.SEQ_NO
                        + '&nj=' + escape(data.GRADE)
                        + '&xy=' + escape(data.XY)
                        + '&bj=' + escape(data.CLASSCODE)
                        + '&zy=' + escape(data.ZY));
                        $.post(revokeurl, $("#form_revoke").serialize(), function (msg) {
                            if (msg.length > 0) {
                                easyAlert.timeShow({
                                    "content": msg,
                                    "duration": 2,
                                    "type": "danger"
                                });
                                return false;
                            }
                            else {
                                //保存成功：关闭界面，刷新列表
                                $("#revokeModal").modal("hide");
                                easyAlert.timeShow({
                                    "content": "撤销申请成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                mainList.reload();
                                return true;
                            }
                        });
                    }
                }
            });
            //---------撤销申请  结束------------------
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 辅导员列表JS 开始-->
    <script type="text/javascript">
        //辅导员列表加载
        function fdyListLoad() {
            //配置表格列
            tablePackageMany.filed = [
				    { "data": "ENO",
				        "createdCell": function (nTd, sData, oData, iRow, iCol) {
				            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
				        },
				        "head": "checkbox", "id": "checkAll"
				    },
                    { "data": "ENO", "head": "职工号", "type": "td-keep" },
           			{ "data": "NAME", "head": "姓名", "type": "td-keep" },
                    { "data": "DEPARTMENT", "head": "所在部门名称", "type": "td-keep" }
		    ];

            //配置表格
            fdyList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/Common/ComPage/SelectBasicCoun.aspx?optype=getlist",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_fdy", //表格id
                    buttonId: "buttonId_fdy", //拓展按钮区域id
                    tableTitle: "选择辅导员",
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
                    "boxId": "counBox",
                    "tabId": "tabCoun",
                    "cols": [
                        { "data": "ENO", "pre": "职工号", "col": 1, "type": "input" },
                        { "data": "NAME", "pre": "姓名", "col": 2, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                { type: "enter", modal: null, title: "选择", action: "fdy_select" }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 辅导员列表JS 结束-->
    <!-- 研究生列表JS 开始-->
    <script type="text/javascript">
        //研究生列表加载
        function yjsListLoad() {
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
				    { "data": "CLASS_NAME", "head": "所在班级", "type": "td-keep" }
		    ];

            //配置表格
            yjsList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/Common/ComPage/SelectBasicStu.aspx?optype=getlist&filter=classgroup",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_yjs", //表格id
                    buttonId: "buttonId_yjs", //拓展按钮区域id
                    tableTitle: "选择研究生",
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
                    "boxId": "stuBox",
                    "tabId": "tabStu",
                    "cols": [
                        { "data": "NUMBER", "pre": "学号", "col": 1, "type": "input" },
                        { "data": "NAME", "pre": "姓名", "col": 2, "type": "input" }
				    ]
                },
                hasModal: false, //弹出层参数
                hasBtns: ["reload",
                { type: "enter", modal: null, title: "选择", action: "yjs_select" }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 研究生列表JS 结束-->
    <!-- 编辑页JS 开始-->
    <!-- 按钮事件-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _tableModal = $("#tableModal");
            var _fdyListModal = $("#fdyListModal");
            var _btns = {
                reload: '.btn-reload',
                edit: '.btn-edit',
                del: '.btn-del',
                selectlist: '.btn-selectlist',
                submitdata: '.btn-submitdata'
            };
            //-----------------主列表-----------------
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【编辑】
            //------------------编辑页面 开始------------------------------------------
            _content.on('click', _btns.edit, function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {//
                        var url = "/AdminLTE_Mod/CHK/Declare.aspx?optype=chkdeclare&doc_type=" + data.DOC_TYPE
                                                    + '&seq_no=' + data.SEQ_NO + '&user_role=<%=user.User_Role%>';
                        var result = AjaxUtils.getResponseText(url);
                        if (result.length > 0) {
                            easyAlert.timeShow({
                                "content": result,
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                        //初始化编辑界面
                        $("#tableModal").modal();
                        //隐藏域
                        $("#hidOid").val(data.OID);
                        $("#hidGroupClass").val(data.CLASSCODE);
                        //界面赋值
                        $("#CLASSNAME").val(data.CLASSNAME);
                        $("#GRADE").val(data.GRADE);
                        $("#XY_NAME").val(data.XY_NAME);
                        $("#ZY_NAME").val(data.ZY_NAME);
                        $("#ZY_NAME").val(data.ZY_NAME);
                        $("#GROUP_NAME").val(data.GROUP_NAME);
                        $("#GROUP_NUMBER").val(data.GROUP_NUMBER);
                        DropDownUtils.setDropDownValue("GROUP_TYPE", data.GROUP_TYPE);
                        //设置只读
                        ControlUtils.Input_SetReadOnlyStatus("CLASSNAME", true);
                        ControlUtils.Input_SetReadOnlyStatus("GRADE", true);
                        ControlUtils.Input_SetReadOnlyStatus("XY_NAME", true);
                        ControlUtils.Input_SetReadOnlyStatus("ZY_NAME", true);
                        ControlUtils.Input_SetReadOnlyStatus("GROUP_NAME", true);
                        ControlUtils.Select_SetDisableStatus("GROUP_TYPE", true);
                    }
                    else {
                        //初始化编辑界面
                        $("#tableModal").modal();
                        //隐藏域
                        $("#hidOid").val("");
                        $("#hidGroupClass").val(data.CLASSCODE);
                        //界面赋值
                        $("#CLASSNAME").val(data.CLASSNAME);
                        $("#GRADE").val(data.GRADE);
                        $("#XY_NAME").val(data.XY_NAME);
                        $("#ZY_NAME").val(data.ZY_NAME);
                        $("#GROUP_NAME").val("");
                        $("#GROUP_NUMBER").val("");
                        DropDownUtils.setDropDownValue("GROUP_TYPE", "");
                        //设置只读
                        ControlUtils.Input_SetReadOnlyStatus("CLASSNAME", true);
                        ControlUtils.Input_SetReadOnlyStatus("GRADE", true);
                        ControlUtils.Input_SetReadOnlyStatus("XY_NAME", true);
                        ControlUtils.Input_SetReadOnlyStatus("ZY_NAME", true);
                        ControlUtils.Input_SetReadOnlyStatus("GROUP_NAME", true);
                        ControlUtils.Select_SetDisableStatus("GROUP_TYPE", true);
                    }
                }
            });
            //------------------编辑页面 结束------------------------------------------

            //【删除】
            /*删除控制*/
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
            //【撤销】
            _content.on("click", "#revoke", function () {
                Revoke();
            });

            //-----------------编辑页-----------------
            //【提交】
            _tableModal.on('click', _btns.submitdata, function () {
                //校验必填项
                var GROUP_NUMBER = $("#GROUP_NUMBER").val();
                var GROUP_NAME = $("#GROUP_NAME").val();
                ControlUtils.Select_SetDisableStatus("GROUP_TYPE", false);
                var GROUP_TYPE = DropDownUtils.getDropDownValue("GROUP_TYPE");
                ControlUtils.Select_SetDisableStatus("GROUP_TYPE", true);
                if (GROUP_NUMBER.length == 0) {
                    easyAlert.timeShow({
                        "content": "班级辅导员工号必须填",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                if (GROUP_NAME.length == 0) {
                    easyAlert.timeShow({
                        "content": "班级辅导员姓名必须填",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                if (GROUP_TYPE.length == 0) {
                    easyAlert.timeShow({
                        "content": "班级辅导员类型必须填",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                easyConfirm.locationShow({
                    'type': 'warn',
                    'content': "确认提交该班级的辅导员为所选的人员吗？",
                    'title': '确认提交辅导员',
                    'callback': function (btn) {
                        SaveData();
                    }
                });
            });

            //【选择辅导员】
            _tableModal.on('click', _btns.selectlist, function () {
                $("#fdyListModal").modal();
            });
            //-----------------选择辅导员页-----------------
            //辅导员：【刷新】
            _fdyListModal.on('click', _btns.reload, function () {
                fdyList.reload();
                yjsList.reload();
            });
            //辅导员：【选择】
            _fdyListModal.on('click', "button[data-action='fdy_select']", function () {
                var data = fdyList.selectSingle();
                if (data) {
                    $("#GROUP_NUMBER").val(data.ENO);
                    $("#GROUP_NAME").val(data.NAME);
                    DropDownUtils.setDropDownValue("GROUP_TYPE", "F");
                    $("#fdyListModal").modal('hide');
                }
            });
            //研究生：【选择】
            _fdyListModal.on('click', "button[data-action='yjs_select']", function () {
                var data = yjsList.selectSingle();
                if (data) {
                    $("#GROUP_NUMBER").val(data.NUMBER);
                    $("#GROUP_NAME").val(data.NAME);
                    DropDownUtils.setDropDownValue("GROUP_TYPE", "Y");
                    $("#fdyListModal").modal('hide');
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
            LimitUtils.onlyNumAlpha("GROUP_NUMBER"); //代码限制只能录入数字
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
            var data = mainList.selectSingle();
            if (data) {
                if (!data.OID) {
                    easyAlert.timeShow({
                        "content": "该班级未进行编班申请！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                var result = AjaxUtils.getResponseText('/AdminLTE_Mod/CHK/Revoke.aspx?optype=chk&doc_type=' + data.DOC_TYPE
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
                result = AjaxUtils.getResponseText('/AdminLTE_Mod/CHK/Revoke.aspx?optype=revoke&col_name=DECL_NUMBER&doc_type=' + data.DOC_TYPE
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
        }

        //保存事件
        function SaveData() {
            ControlUtils.Select_SetDisableStatus("GROUP_TYPE", false);
            $.post(OptimizeUtils.FormatUrl("List.aspx?optype=save"), $("#form_edit").serialize(), function (msg) {
                if (msg.length > 0) {
                    $(".Confirm_Div").modal("hide");
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
                    $(".Confirm_Div").modal("hide");
                    easyAlert.timeShow({
                        "content": "提交成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    mainList.reload();
                }
            });
        }

        //删除事件
        function DeleteData() {
            var data = mainList.selectSingle();
            if (data) {
                if (!data.OID) {
                    easyAlert.timeShow({
                        "content": "该班级未进行编班申请！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
                var url = "/AdminLTE_Mod/CHK/Declare.aspx?optype=chkdeclare&doc_type=" + data.DOC_TYPE
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
                var msg = AjaxUtils.getResponseText("List.aspx?optype=delete&id=" + data.OID);
                if (msg.length != 0) {
                    easyAlert.timeShow({
                        "content": msg,
                        "duration": 2,
                        "type": "danger"
                    });
                    $("#delModal").modal("hide");
                    return;
                } else {
                    //保存成功：关闭界面，刷新列表
                    easyAlert.timeShow({
                        "content": "删除成功！",
                        "duration": 2,
                        "type": "success"
                    });
                    $("#delModal").modal("hide");
                    mainList.reload();
                }
            }
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
