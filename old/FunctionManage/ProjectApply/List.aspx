<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectApply.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList; //主列表
        var projectList; //申请项目选择列表
        var revoke_com; //撤销申请
        var wfklog; //审批流程跟踪
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
    <!-- 可提供申请奖助项目列表选择 开始 -->
    <div class="modal" id="projectListModal">
        <div class="modal-dialog" style="width: 70%">
            <div class="modal-content form-horizontal">
                <div class="modal-body">
                    <table id="tablelist_project" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">
                        关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 可提供申请奖助项目列表选择 结束-->
    <!-- 编辑界面 开始 -->
    <div class="modal" id="editModal">
        <div class="modal-dialog">
            <div class="modal-body row">
                <div class="form-group col-sm-12">
                    <iframe id="editFrame" name="editFrame" frameborder="0" src="" style="width: 100%;">
                    </iframe>
                </div>
            </div>
        </div>
    </div>
    <!-- 编辑界面 结束-->
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
				    { "data": "PROJECT_YEAR_NAME", "head": "项目学年", "type": "td-keep" },
				    { "data": "STU_NUMBER", "head": "申请人学号", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "申请人姓名", "type": "td-keep" },
                    { "data": "XY_NAME", "head": "所属学院", "type": "td-keep" },
                    { "data": "ZY_NAME", "head": "所属专业", "type": "td-keep" },
                    { "data": "GRADE", "head": "所属年级", "type": "td-keep" },
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" },
				    { "data": "RET_CHANNEL_NAME", "head": "流程状态", "type": "td-keep" },
                    { "data": "DECLARE_TYPE_NAME", "head": "申请类型", "type": "td-keep" },
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
                    tableTitle: "奖助管理 >> 奖助申请",
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
					    { "data": "PROJECT_YEAR", "pre": "项目学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type" },
					    { "data": "PROJECT_CLASS", "pre": "项目级别", "col": 2, "type": "select", "ddl_name": "ddl_jz_project_class" },
                        { "data": "PROJECT_TYPE", "pre": "申请表格类型", "col": 3, "type": "select", "ddl_name": "ddl_jz_project_type" },
                        { "data": "PROJECT_SEQ_NO", "pre": "项目名称", "col": 4, "type": "select", "ddl_name": "ddl_jz_project_name" },
                        { "data": "XY", "pre": "学院", "col": 1, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 2, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 3, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 4, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 5, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 6, "type": "input" },
                        { "data": "RET_CHANNEL", "pre": "流程状态", "col": 4, "type": "select", "ddl_name": "ddl_RET_CHANNEL" },
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "add", title: "申请奖助", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                 "edit", "del",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "print", title: "打印/预览", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "download", title: "申请表下载", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "revoke", title: "撤销", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "revoke_apply", title: "撤销申请", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "history", title: "审批流程跟踪", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //奖助级别、奖助类型 联动
            SelectUtils.JZ_Class_Type_Year_ProjectChange("search-PROJECT_CLASS", "search-PROJECT_TYPE", "search-PROJECT_YEAR", "search-PROJECT_SEQ_NO", '', '', '', '', '');
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASS_CODE");
            //设置当前查询项目学年
            DropDownUtils.setDropDownValue("search-PROJECT_YEAR", '<%=sch_info.CURRENT_YEAR %>');
            //加载其他列表
            projectListLoad();
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 可提供申请奖助项目列表JS 开始-->
    <script type="text/javascript">
        //辅导员列表加载
        function projectListLoad() {
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
				    { "data": "APPLY_YEAR_NAME", "head": "申请学年", "type": "td-keep" }
		    ];

            //配置表格
            projectList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/BDM/ScholarshipAssis/ProjectManage/List.aspx?optype=getlist&from_page=pro_apply",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist_project", //表格id
                    buttonId: "buttonId_project", //拓展按钮区域id
                    tableTitle: "奖助项目申请选择",
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
                },
                hasModal: false, //弹出层参数
                hasBtns: [
                { type: "userDefined", id: "reload_project", title: "刷新", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "sel_project", title: "申请", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
        }
    </script>
    <!-- 可提供申请奖助项目列表JS 结束-->
    <!-- 按钮事件 开始-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _projectListModal = $("#projectListModal");
            var _btns = {
                reload: '.btn-reload',
                add: '.btn-add',
                edit: '.btn-edit',
                del: '.btn-del'
            };
            //-----------主列表按钮---------------
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【删除】
            _content.on('click', _btns.del, function () {
                DeleteData();
            });
            //【打印/预览】
            _content.on('click', "#print", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        var file = AjaxUtils.getResponseText("RewardInfo.aspx?optype=getprintfile&seq_no=" + data.SEQ_NO);
                        JzCom.ByJzTypeToPrint(data.PROJECT_TYPE, data.OID, file);
                    }
                }
            });
            //【申请表下载】
            _content.on('click', "#download", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        window.open(OptimizeUtils.FormatUrl('/Word/ExportWord.aspx?optype=project&id=' + data.OID));
                    }
                }
            });
            //【撤销】
            _content.on('click', "#revoke", function () {
                Revoke();
            });
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
                                return true;
                            }
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
                        + '&bj=' + escape(data.CLASS_CODE)
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
            //【新增】
            _content.on('click', "#add", function () {
                //弹出可申请奖助信息列表
                $("#projectListModal").modal();
            });
            //【编辑】
            _content.on('click', _btns.edit, function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //校验是否满足修改条件
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
                        //弹出编辑页
                        $("#editFrame").attr("src", OptimizeUtils.FormatUrl("Edit.aspx?optype=modi&id=" + data.OID
                        + "&seq_no=" + data.SEQ_NO + "&project_seq_no=" + data.PROJECT_SEQ_NO));
                        $("#editModal").modal();
                        $("#editModal .modal-dialog").css({ "width": "100%", "margin": "0", "padding": "0" });
                        $("#editModal .modal-body").outerHeight($(window).height());
                        $("#editFrame").height($("#editModal .modal-body").height());
                    }
                }
            });
            //【查阅】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //弹出编辑页
                        $("#editFrame").attr("src", OptimizeUtils.FormatUrl("Edit.aspx?optype=view&id=" + data.OID
                        + "&seq_no=" + data.SEQ_NO + "&project_seq_no=" + data.PROJECT_SEQ_NO));
                        $("#editModal").modal();
                        $("#editModal .modal-dialog").css({ "width": "100%", "margin": "0", "padding": "0" });
                        $("#editModal .modal-body").outerHeight($(window).height());
                        $("#editFrame").height($("#editModal .modal-body").height());
                    }
                }
            });
            //-----------可申请奖助信息列表 按钮---------------
            //【刷新】
            _projectListModal.on('click', "#reload_project", function () {
                projectList.reload();
            });
            //【申请】
            _projectListModal.on('click', "#sel_project", function () {
                var data = projectList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //判断是否满足申请条件
                        var result = AjaxUtils.getResponseText("List.aspx?optype=iscan_apply&project_seq_no=" + data.SEQ_NO);
                        if (result.length > 0) {
                            easyAlert.timeShow({
                                "content": result,
                                "duration": 2,
                                "type": "danger"
                            });
                            return;
                        }
                        //关闭 可申请奖助信息列表
                        $("#projectListModal").modal("hide");
                        //打开 编辑页
                        $("#editFrame").attr("src", OptimizeUtils.FormatUrl("Edit.aspx?optype=add&project_seq_no=" + data.SEQ_NO));
                        $("#editModal").modal();
                        $("#editModal .modal-dialog").css({ "width": "100%", "margin": "0", "padding": "0" });
                        $("#editModal .modal-body").outerHeight($(window).height());
                        $("#editFrame").height($("#editModal .modal-body").height());
                    }
                }
            });
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
        }
    </script>
    <!-- 编辑页数据初始化事件 结束-->
    <!-- 编辑页验证事件 开始-->
    <script type="text/javascript">
        function loadModalPageValidate() {
        }
    </script>
    <!-- 编辑页验证事件 结束-->
    <!-- 自定义实现JS 开始-->
    <script type="text/javascript">
        //------------------主列表按钮事件------------------
        //删除事件
        function DeleteData() {
            var data = mainList.selectSingle();
            if (data) {
                if (data.OID) {
                    //判断是否满足删除条件：申请时间已经开始，已经有人开始申请，就不可以删除该项目
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
                                mainList.reload();
                            }
                        }
                    });
                }
            }
        }

        //撤销
        function Revoke() {
            var data = mainList.selectSingle();
            if (data) {
                if (data.OID) {
                    var result = AjaxUtils.getResponseText('/AdminLTE_Mod/CHK/Revoke.aspx?optype=chk&doc_type=' + data.DOC_TYPE
            + '&seq_no=' + data.SEQ_NO
            + '&col_name=STU_NUMBER');
                    if (result.length > 0) {
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }
                    result = AjaxUtils.getResponseText('/AdminLTE_Mod/CHK/Revoke.aspx?optype=revoke&col_name=STU_NUMBER&doc_type=' + data.DOC_TYPE
                + '&seq_no=' + data.SEQ_NO
                + '&nj=' + escape(data.GRADE)
                + '&xy=' + escape(data.XY)
                + '&bj=' + escape(data.CLASS_CODE)
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
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
