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
            <section class="content-header">
			<h1>奖助申请</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>奖助管理</li>
				<li class="active">奖助申请</li>
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
    <!-- 可提供申请奖助项目列表选择 开始 -->
    <div class="modal" id="projectListModal">
        <div class="modal-dialog modal-dw60">
            <div class="modal-content form-horizontal">
                <div class="modal-body">
                    <table id="tablelist_project" class="table table-bordered table-striped table-hover">
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 可提供申请奖助项目列表选择 结束-->
    <!-- 编辑界面 开始 -->
    <div class="modal" id="editModal">
        <div class="modal-dialog">
            <div class="modal-body">

                    <iframe id="editFrame" name="editFrame" frameborder="0" src="" style="width: 100%;">
                    </iframe>

            </div>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <!-- 下载WORD界面 开始 -->
    <div class="modal" id="downloadWordModal">
        <div class="modal-dialog">
            <div class="modal-body">

                    <iframe id="wordFrame" name="wordFrame" frameborder="0" src=""></iframe>

            </div>
        </div>
    </div>
    <div class="modal" id="downloadWordModal_Sub">
        <div class="modal-dialog">
            <div class="modal-body">

                    <iframe id="wordFrame_Sub" name="wordFrame_Sub" frameborder="0" src=""></iframe>

            </div>
        </div>
    </div>
    <!-- 下载WORD界面 结束-->
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
            //{ "data": "PROJECT_TYPE_NAME", "head": "申请表格类型", "type": "td-keep" },//zz 20171025 修改：不显示
				    {"data": "PROJECT_NAME", "head": "项目名称", "type": "td-keep" },
				    { "data": "PROJECT_MONEY", "head": "项目金额", "type": "td-keep" },
				    { "data": "PROJECT_YEAR_NAME", "head": "项目学年", "type": "td-keep" },
				    { "data": "STU_NUMBER", "head": "申请人学号", "type": "td-keep" },
				    { "data": "STU_NAME", "head": "申请人姓名", "type": "td-keep" },
                    { "data": "XY_NAME", "head": "所属学院", "type": "td-keep" },
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" },
				    { "data": "RET_CHANNEL", "head": "当前状态", "type": "td-keep" },
                    { "data": "DECLARE_TYPE_NAME", "head": "申请类型", "type": "td-keep" },
                    { "data": "DECL_TIME", "head": "申请时间", "type": "td-keep" },
                    { "data": "CHK_TIME", "head": "审核时间", "type": "td-keep" },
                    { "data": "ZY_NAME", "head": "所属专业", "type": "td-keep" },
                    { "data": "GRADE", "head": "所属年级", "type": "td-keep" },
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
                    tableTitle: "奖助申请",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': true, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(9)');
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
                                        "msg": "未申请"
                                    });
                            }
                        }
                    }
                },
                //查询栏
                hasSearch: {
                    "cols": [
					    { "data": "PROJECT_YEAR", "pre": "项目学年", "col": 1, "type": "select", "ddl_name": "ddl_year_type", "d_value": "<%=sch_info.CURRENT_YEAR %>" },
					    { "data": "PROJECT_CLASS", "pre": "项目级别", "col": 2, "type": "select", "ddl_name": "ddl_jz_project_class" },
                        { "data": "PROJECT_TYPE", "pre": "申请表格类型", "col": 3, "type": "select", "ddl_name": "ddl_jz_project_type" },
                        { "data": "PROJECT_SEQ_NO", "pre": "项目名称", "col": 4, "type": "select", "ddl_name": "ddl_jz_project_name" },
                        { "data": "XY", "pre": "学院", "col": 5, "type": "select", "ddl_name": "ddl_department" },
					    { "data": "ZY", "pre": "专业", "col": 6, "type": "select", "ddl_name": "ddl_zy" },
                        { "data": "GRADE", "pre": "年级", "col": 7, "type": "select", "ddl_name": "ddl_grade" },
                        { "data": "CLASS_CODE", "pre": "班级", "col": 8, "type": "select", "ddl_name": "ddl_class" },
                        { "data": "STU_NUMBER", "pre": "申请人学号", "col": 9, "type": "input" },
                        { "data": "STU_NAME", "pre": "申请人姓名", "col": 10, "type": "input" },
                        { "data": "RET_CHANNEL", "pre": "当前状态", "col": 11, "type": "select", "ddl_name": "ddl_RET_CHANNEL" },
                        { "data": "DECLARE_TYPE", "pre": "申请类型", "col": 12, "type": "select", "ddl_name": "ddl_DECLARE_TYPE" }
				    ]
                },
                hasModal: false, //弹出层参数
                //info(蓝色)  primary(深蓝)  success(绿色)  danger(红色)
                hasBtns: ["reload",
                { type: "userDefined", id: "add", title: "申请奖助", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                 "edit", "del",
                { type: "userDefined", id: "view", title: "查阅", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                //{ type: "userDefined", id: "print", title: "打印/预览", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                {type: "userDefined", id: "download", title: "申请表下载", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "revoke", title: "撤销", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "revoke_apply", title: "撤销申请", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "history", title: "审批流程跟踪", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} }
                 ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //奖助级别、奖助类型 联动
            SelectUtils.JZ_Class_Type_Year_ProjectChange("search-PROJECT_CLASS", "search-PROJECT_TYPE", "search-PROJECT_YEAR", "search-PROJECT_SEQ_NO", '', '', '', '', '');
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASS_CODE");
            //加载其他列表
            projectListLoad();
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 可提供申请奖助项目列表JS 开始-->
    <script type="text/javascript">
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
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500]
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
                        var file = AjaxUtils.getResponseText("FileList.aspx?optype=getprintfile&seq_no=" + data.SEQ_NO);
                        JzCom.ByJzTypeToPrint(data.PROJECT_TYPE, data.OID, file);
                    }
                }
            });
            //【申请表下载】
            _content.on('click', "#download", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        var url = "/Word/ExportWord.aspx";
                        //COUNTRY_B：国家奖学金（本科）：表11+1,11+2
                        if (data.PROJECT_TYPE == "COUNTRY_B") {
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                            $("#wordFrame_Sub").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project_sub&id=' + data.OID));
                        }
                        //COUNTRY_ENCOUR：国家励志奖学金：表12
                        //AREA_GOV：自治区人民政府奖学金：表15
                        else if (data.PROJECT_TYPE == "COUNTRY_ENCOUR" || data.PROJECT_TYPE == "AREA_GOV") {
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                        }
                        //COUNTRY_FIRST：国家一等助学金：表13
                        //COUNTRY_SECOND：国家二等助学金：表14
                        //SOCIETY_OFFER：社会捐资类奖学金：表16
                        else if (data.PROJECT_TYPE == "COUNTRY_FIRST" || data.PROJECT_TYPE == "COUNTRY_SECOND" || data.PROJECT_TYPE == "SOCIETY_OFFER") {
                            //弹出编辑页
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                        }
                        //SCHOOL_GOOD：三好学生：表17+1
                        //SCHOOL_MODEL：三好学生标兵：表17+1,17+2（与11+2一致）,17+3
                        else if (data.PROJECT_TYPE == "SCHOOL_GOOD" || data.PROJECT_TYPE == "SCHOOL_MODEL") {
                            //弹出编辑页
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                            if (data.PROJECT_TYPE == "SCHOOL_MODEL") {
                                //弹出编辑页
                                $("#wordFrame_Sub").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project_sub&id=' + data.OID));
                            }
                        }
                        //SCHOOL_SINGLE：单项奖学金：表18
                        else if (data.PROJECT_TYPE == "SCHOOL_SINGLE") {
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                        }
                        //COUNTRY_YP：国家奖学金（研究生/博士）：表19+1,19+2
                        else if (data.PROJECT_TYPE == "COUNTRY_YP") {
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                            if (data.PROJECT_TYPE == "COUNTRY_YP") {
                                //弹出编辑页
                                $("#wordFrame_Sub").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project_sub&id=' + data.OID));
                            }
                        }
                        //COUNTRY_STUDY：国家学业奖学金：表20
                        //SCHOOL_NOTCOUNTRY：非国家级奖学金：表21
                        //SOCIETY_NOCOUNTRY：非国家级奖学金：表21
                        else if (data.PROJECT_TYPE == "COUNTRY_STUDY"
                        || data.PROJECT_TYPE == "SCHOOL_NOTCOUNTRY" || data.PROJECT_TYPE == "SOCIETY_NOCOUNTRY") {
                            $("#wordFrame").attr("src", OptimizeUtils.FormatUrl(url + '?optype=project&id=' + data.OID));
                        }
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
                                //ZZ 20171221 新增：删除也需要加入 过了项目申请结束时间，学生、辅导员、学院都不能操作，校级可以审批操作
                                var iscan_result = AjaxUtils.getResponseText("List.aspx?optype=iscanop&project_seq_no=" + data.PROJECT_SEQ_NO);
                                if (iscan_result.length > 0) {
                                    easyAlert.timeShow({
                                        "content": iscan_result,
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                    return;
                                }

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
                                mainList.reload();
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
                    //ZZ 20171221 新增：删除也需要加入 过了项目申请结束时间，学生、辅导员、学院都不能操作，校级可以审批操作
                    var iscanop_result = AjaxUtils.getResponseText("List.aspx?optype=iscanop&project_seq_no=" + data.PROJECT_SEQ_NO);
                    if (iscanop_result.length > 0) {
                        easyAlert.timeShow({
                            "content": iscanop_result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }

                    //判断是否满足删除条件
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
                                mainList.reload();
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
                    //ZZ 20171221 新增：撤销也需要加入 过了项目申请结束时间，学生、辅导员、学院都不能操作，校级可以审批操作
                    var iscanop_result = AjaxUtils.getResponseText("List.aspx?optype=iscanop&project_seq_no=" + data.PROJECT_SEQ_NO);
                    if (iscanop_result.length > 0) {
                        easyAlert.timeShow({
                            "content": iscanop_result,
                            "duration": 2,
                            "type": "danger"
                        });
                        return;
                    }

                    var result = AjaxUtils.getResponseText('/AdminLTE_Mod/CHK/Revoke.aspx?optype=chk&doc_type=' + data.DOC_TYPE
            + '&seq_no=' + data.SEQ_NO
            + '&col_name=STU_NUMBER');
                    if (result.length > 0) {
                        mainList.reload();
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
                        mainList.reload();
                        easyAlert.timeShow({
                            "content": result,
                            "duration": 2,
                            "type": "danger"
                        });
                    }
                    else {
                        mainList.reload();
                        easyAlert.timeShow({
                            "content": '撤销成功！',
                            "duration": 2,
                            "type": "info"
                        });
                    }
                }
            }
        }
        //------------------EDIT界面保存回调加参数事件------------------
        function EditSaveRefresh(oid, seq_no, project_seq_no) {
            $("#editFrame").attr("src", OptimizeUtils.FormatUrl("Edit.aspx?optype=modi&id=" + oid
                        + "&seq_no=" + seq_no + "&project_seq_no=" + project_seq_no));
            mainList.reload();
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
