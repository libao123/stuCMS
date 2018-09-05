<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List_Pend.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectApprove.List_Pend" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var mainList; //主列表
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
			<h1>待处理奖助</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>奖助管理</li>
				<li class="active">待处理奖助</li>
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
    <div class="modal" id="editModal">
        <div class="modal-dialog">
            <div class="modal-body">

                    <iframe id="editFrame" name="editFrame" frameborder="0" src="" style="width: 100%;">
                    </iframe>

            </div>
        </div>
    </div>
    <!-- 编辑界面 结束-->
    <div class="maskBg">
    </div>
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
                    { "data": "CLASS_CODE_NAME", "head": "所属班级", "type": "td-keep" },
				    { "data": "RET_CHANNEL", "head": "当前状态", "type": "td-keep" },
                    { "data": "DECLARE_TYPE_NAME", "head": "申请类型", "type": "td-keep" },
                    { "data": "DECL_TIME", "head": "申请时间", "type": "td-keep" },
                    { "data": "CHK_TIME", "head": "审核时间", "type": "td-keep"  },
                    { "data": "ZY_NAME", "head": "所属专业", "type": "td-keep" },
                    { "data": "GRADE", "head": "所属年级", "type": "td-keep" },
                    { "data": "SEQ_NO", "head": "单据编号", "type": "td-keep"  }
		    ];

            //配置表格
            mainList = tablePackageMany.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "/AdminLTE_Mod/BDM/ScholarshipAssis/ProjectApply/List.aspx?optype=getlist&page_from=approve_pend",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "待处理奖助",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': false, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(10)');
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
                { type: "userDefined", id: "view", title: "查阅/审核", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                <%if(bIsCanMultiAudit){ %>
                { type: "userDefined", id: "audit_p", title: "批量审核通过", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "audit_n", title: "批量审核不通过", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                <%} %>
                { type: "userDefined", id: "revoke_approve", title: "撤销审核", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
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

            //---------撤销审核  开始------------------
            //【撤销审核】
            var approve = approveComPage.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "approveModal"//弹出层的id，不写则默认verifyModal，必填
                },
                control: {
                    "content": "#content", //必填
                    "btnId": "#revoke_approve", //触发弹出层的按钮的id，必填
                    "beforeShow": function (btn, form) {//返回btn信息和form信息
                        var data = mainList.selectSingle();
                        if (data) {
                            if (data.OID) {
                                //ZZ 20171221 新增：撤销也需要加入 过了项目申请结束时间，学生、辅导员、学院都不能操作，校级可以审批操作
                                var iscanop_result = AjaxUtils.getResponseText("/AdminLTE_Mod/BDM/ScholarshipAssis/ProjectApply/List.aspx?optype=iscanop&project_seq_no=" + data.PROJECT_SEQ_NO);
                                if (iscanop_result.length > 0) {
                                    easyAlert.timeShow({
                                        "content": iscanop_result,
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                    return;
                                }

                                //判断是否有审批权限
                                if (data.DECLARE_TYPE != "R"){
                                    easyAlert.timeShow({
                                        "content": "业务类型不属于撤销申请，无法进行该操作！",
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                    return false;
                                }
                                //判断是否有审批权限
                                var url = "/AdminLTE_Mod/CHK/Approve.aspx?optype=chk"
                                + "&doc_type=" + data.DOC_TYPE + "&seq_no=" + data.SEQ_NO + "&decltype=" + data.DECLARE_TYPE;
                                var result = AjaxUtils.getResponseText(url);
                                if (result.length > 0) {
                                    easyAlert.timeShow({
                                        "content": result,
                                        "duration": 2,
                                        "type": "danger"
                                    });
                                    return false;
                                }
                                //如果是撤销审核，修改界面名词
                                if (data.DECLARE_TYPE == "R") {
                                    $("#lab_approvePass").text("同意");
                                    $("#lab_approveNoPass").text("不同意");
                                }
                                //默认审核信息内容为：同意
                                $("#approvePass").iCheck("check"); //默认选中
                                $("#approveMsg").val("同意");
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
                        //提交
                        var approveurl = OptimizeUtils.FormatUrl("/AdminLTE_Mod/CHK/Approve.aspx?optype=submit_approve"
                        + "&doc_type=" + data.DOC_TYPE + "&seq_no=" + data.SEQ_NO + "&decltype=" + data.DECLARE_TYPE);
                        $.post(approveurl, $("#form_approve").serialize(), function (msg) {
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
                                $("#approveModal").modal("hide");
                                easyAlert.timeShow({
                                    "content": "审核成功！",
                                    "duration": 2,
                                    "type": "success"
                                });
                                mainList.reload();
                            }
                        });
                    }
                }
            });
            //---------撤销审核  结束------------------
        }
    </script>
    <!-- 列表JS 结束-->
    <!-- 按钮事件 开始-->
    <script type="text/javascript">
        //编辑页按钮事件初始化
        function loadModalBtnInit() {
            //列表内容，以及按钮
            var _content = $("#content");
            var _btns = {
                reload: '.btn-reload'
            };
            //-----------主列表按钮---------------
            //【刷新】
            _content.on('click', _btns.reload, function () {
                mainList.reload();
            });
            //【查阅/审核】
            _content.on('click', "#view", function () {
                var data = mainList.selectSingle();
                if (data) {
                    if (data.OID) {
                        //弹出编辑页
                        $("#editFrame").attr("src", OptimizeUtils.FormatUrl("/AdminLTE_Mod/BDM/ScholarshipAssis/ProjectApply/Edit.aspx?optype=view&id=" + data.OID
                        + "&seq_no=" + data.SEQ_NO + "&project_seq_no=" + data.PROJECT_SEQ_NO));
                        $("#editModal").modal();
                        $("#editModal .modal-dialog").css({ "width": "100%", "margin": "0", "padding": "0" });
                        $("#editModal .modal-body").outerHeight($(window).height());
                        $("#editFrame").height($("#editModal .modal-body").height());
                    }
                }
            });
            //【批量审核通过】
            _content.on('click', "#audit_p", function () {
                MultiAudit('P');
            });
            //【批量审核不通过】
            _content.on('click', "#audit_n", function () {
                MultiAudit('N');
            });
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
        }
    </script>
    <!-- 按钮事件 结束-->
    <!-- 编辑页数据初始化事件 开始-->
    <script type="text/javascript">
        //编辑页初始化
        function loadModalPageDataInit() {
            //checkbox、radio触发事件
            $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
                checkboxClass: 'icheckbox_flat-green',
                radioClass: 'iradio_flat-green'
            });
            //设置审批结果选中改变事件
            $("input[type='radio'][name='approveType']").on('ifChanged', function (event) {
                ApproveTypeChange();
            });
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
        //点击审核结果提供不同的效果
        function ApproveTypeChange() {
            $("input[type='radio'][name='approveType']:checked").each(function () {
                if ($(this) != null) {
                    var value = $(this).attr("value");
                    if (value == 'P') {//通过
                        $("#approveMsg").val("同意");
                    }
                    else if (value == 'N') {//不通过
                        $("#approveMsg").val("");
                    }
                    else {//默认
                        $("#approveMsg").val("同意");
                    }
                }
            });
        }
        //------------------主列表按钮事件------------------
        //批量审核通过
        function MultiAudit(flag) {
            //$('.maskBg').show();
            //ZENG.msgbox.show("批量审核中，请稍后...", 6);
            // var layInx = layer.load(2, {
            //   content: "批量审核中，请稍后...",
            //   shade: [0.3,'#000'], //0.1透明度的白色背景
            //   time: 6000
            // });
            PropLoad.loading({
                title: "批量审核中，请稍后...",
                duration: 6
            });
            //列表勾选
            var strOids = "";
            var select_maxnum = 100; //目前放开url传值传100条记录的OID
            var datas = mainList.selection();
            if (datas) {
                if (datas.length <= 100) {
                    select_maxnum = datas.length;
                }
                for (var i = 0; i < select_maxnum; i++) {
                    if (datas[i]) {
                        if (datas[i].OID) {
                            strOids += datas[i].OID + ",";
                        }
                    }
                }
            }
            if ('<%=user.User_Role %>' != 'X') {
                if (strOids.length == 0) {
                    easyAlert.timeShow({
                        "content": "请选择数据项！",
                        "duration": 2,
                        "type": "danger"
                    });
                    return;
                }
            }
            //查询栏
            var urlParam = GetSearchUrlParam();
            var result = AjaxUtils.getResponseText('List_Pend.aspx?optype=multiaudit&flag=' + flag + urlParam + "&ids=" + strOids);
            // if (layInx) {
            //   layer.closeAll();
            // }
            PropLoad.remove();
            if (result.length == 0) {
                //$('.maskBg').hide();
                //ZENG.msgbox.hide();

                easyAlert.timeShow({
                    "content": "批量审批成功！",
                    "duration": 2,
                    "type": "info"
                });
                mainList.reload();
            }
            else {
                //$('.maskBg').hide();
                //ZENG.msgbox.hide();

                easyAlert.timeShow({
                    "content": result,
                    "duration": 2,
                    "type": "danger"
                });
                return;
            }
        }

        //获得查询条件中的参数
        function GetSearchUrlParam() {
            var PROJECT_YEAR = DropDownUtils.getDropDownValue("search-PROJECT_YEAR");
            var PROJECT_CLASS = DropDownUtils.getDropDownValue("search-PROJECT_CLASS");
            var PROJECT_TYPE = DropDownUtils.getDropDownValue("search-PROJECT_TYPE");
            var PROJECT_SEQ_NO = DropDownUtils.getDropDownValue("search-PROJECT_SEQ_NO");
            var XY = DropDownUtils.getDropDownValue("search-XY");
            var ZY = DropDownUtils.getDropDownValue("search-ZY");
            var GRADE = DropDownUtils.getDropDownValue("search-GRADE");
            var CLASS_CODE = DropDownUtils.getDropDownValue("search-CLASS_CODE");
            var STU_NUMBER = $("#search-STU_NUMBER").val();
            var STU_NAME = $("#search-STU_NAME").val();
            var RET_CHANNEL = DropDownUtils.getDropDownValue("search-RET_CHANNEL");
            var DECLARE_TYPE = DropDownUtils.getDropDownValue("search-DECLARE_TYPE");

            var strq = "";
            if (PROJECT_YEAR)
                strq += "&PROJECT_YEAR=" + PROJECT_YEAR;
            if (PROJECT_CLASS)
                strq += "&PROJECT_CLASS=" + PROJECT_CLASS;
            if (PROJECT_TYPE)
                strq += "&PROJECT_TYPE=" + PROJECT_TYPE;
            if (PROJECT_SEQ_NO)
                strq += "&PROJECT_SEQ_NO=" + PROJECT_SEQ_NO;
            if (XY)
                strq += "&XY=" + XY;
            if (ZY)
                strq += "&ZY=" + ZY;
            if (GRADE)
                strq += "&GRADE=" + GRADE;
            if (CLASS_CODE)
                strq += "&CLASS_CODE=" + CLASS_CODE;
            if (STU_NUMBER)
                strq += "&STU_NUMBER=" + OptimizeUtils.FormatParamter(STU_NUMBER);
            if (STU_NAME)
                strq += "&STU_NAME=" + OptimizeUtils.FormatParamter(STU_NAME);
            if (RET_CHANNEL)
                strq += "&RET_CHANNEL=" + RET_CHANNEL;
            if (DECLARE_TYPE)
                strq += "&DECLARE_TYPE=" + DECLARE_TYPE;

            return strq;
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>
