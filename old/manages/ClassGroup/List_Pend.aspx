<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List_Pend.aspx.cs" Inherits="PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.ClassGroup.List_Pend" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!--待处理查看-->
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
			<h1>待处理查看</h1>
			<ol class="breadcrumb">
				<li><a href="#"><i class="fa fa-dashboard"></i> 主页</a></li>
				<li>系统维护</li>
				<li class="active">待处理查看</li>
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
                    { "data": "XY_NAME", "head": "学院", "type": "td-keep" },
				    { "data": "ZY_NAME", "head": "专业", "type": "td-keep" },
				    { "data": "GRADE_NAME", "head": "年级", "type": "td-keep" },
				    { "data": "CLASSNAME", "head": "班级", "type": "td-keep" },
				    { "data": "GROUP_NUMBER", "head": "班级辅导员工号", "type": "td-keep" },
				    { "data": "GROUP_NAME", "head": "班级辅导员姓名", "type": "td-keep" },
				    { "data": "GROUP_TYPE_NAME", "head": "班级辅导员类型", "type": "td-keep" },
				    { "data": "OP_NAME", "head": "申报人", "type": "td-keep" },
                    { "data": "DECL_TIME", "head": "申请时间", "type": "td-keep" },
                    { "data": "CHK_TIME", "head": "审核时间", "type": "td-keep" },
                    { "data": "DECLARE_TYPE_NAME", "head": "申请类型", "type": "td-keep" },
                    { "data": "RET_CHANNEL", "head": "当前状态", "type": "td-keep" },
                    { "data": "SEQ_NO", "head": "单据编号", "type": "td-keep" }
		    ];

            //配置表格
            tablePackage.createOne({
                //可ajax ing
                hasAjax: {
                    type: "server",
                    url: "List_Pend.aspx?optype=getlist&from_type=pend",
                    method: "POST"
                },
                //表格参数
                attrs: {
                    tableId: "tablelist", //表格id
                    buttonId: "buttonId", //拓展按钮区域id
                    tableTitle: "待处理查看",
                    checkAllId: "checkAll", //全选id
                    tableConfig: {
                        'pageLength': 10, //每页显示个数，默认10条
                        'selectSingle': false, //是否单选，默认为true
                        'lengthChange': true, //用户改变分页
                        "aLengthMenu": [10, 50, 100, 200, 300, 500],
                        'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                            //type有四种，success,primary,warning,danger。
                            var _row = $(nRow);
                            var _status = _row.find('td:eq(12)');
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
                hasBtns: ["reload",
                { type: "userDefined", id: "approve", title: "审核", className: "btn-info", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "pass", title: "批量审核通过", className: "btn-success", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "nopass", title: "批量审核不通过", className: "btn-danger", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "revoke_approve", title: "撤销审核", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} },
                { type: "userDefined", id: "history", title: "审核流程跟踪", className: "btn-primary", attr: { "data-action": "", "data-other": "nothing"} }
                ], //需要的按钮
                hasCtrl: {
                    "buildModal": false
                }
            });
            //学院、专业、年级、班级联动
            SelectUtils.XY_ZY_Grade_ClassCodeChange("search-XY", "search-ZY", "search-GRADE", "search-CLASSCODE");

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
                        var data = tablePackage.selectSingle();
                        if (data) {
                            if (data.OID) {
                                //判断是否有审批权限
                                if (data.DECLARE_TYPE != "R") {
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
                        var data = tablePackage.selectSingle();
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
                                tablePackage.reload();
                            }
                        });
                    }
                }
            });
            //---------撤销审核  结束------------------

            //---------审核  开始------------------
            var approve = approveComPage.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "approveModal"//弹出层的id，不写则默认verifyModal，必填
                },
                control: {
                    "content": "#content", //必填
                    "btnId": "#approve", //触发弹出层的按钮的id，必填
                    "beforeShow": function (btn, form) {//返回btn信息和form信息
                        var data = tablePackage.selectSingle();
                        if (data) {
                            if (data.OID) {
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
                        var data = tablePackage.selectSingle();
                        //提交
                        var approveurl = OptimizeUtils.FormatUrl("/AdminLTE_Mod/CHK/Approve.aspx?optype=submit_approve"
                        + "&doc_type=" + data.DOC_TYPE + "&seq_no=" + data.SEQ_NO + "&decltype=" + data.DECLARE_TYPE
                        + "&msg_accpter=" + data.DECL_NUMBER);
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
                                tablePackage.reload();
                            }
                        });
                    }
                }
            });
            //---------审核  结束------------------

            //------------------审核流程跟踪 开始------------------------------------------
            //【审核流程跟踪】
            var wfklog = WfkLog.createOne({
                modalAttr: {//配置modal的一些属性
                    "id": "wfklogModal"//弹出层的id，不写则默认wfklogModal，必填
                },
                control: {
                    "content": "#content", //必填
                    "btnId": "#history", //触发弹出层的按钮的id，必填
                    "beforeShow": function (btn, form) {//返回btn信息和form信息
                        var data = tablePackage.selectSingle();
                        if (data) {
                            if (data.OID) {
                                return true;
                            }
                        }
                        return false;
                    },
                    "afterShow": function (btn, form) {//返回btn信息和form信息
                        var data = tablePackage.selectSingle();
                        _m_wfklog_list.refresh(OptimizeUtils.FormatUrl("/AdminLTE_Mod/Common/ComPage/WkfLogList.aspx?optype=getlist&seq_no=" + data.SEQ_NO));
                        return true;
                    },
                    "beforeSubmit": function (btn, form) {//返回btn信息和form信息
                    }
                }
            });
            //------------------审核流程跟踪 结束------------------------------------------

            //批量审核通过
            $(document).on("click", "#pass", function () {
                MultiAudit('P');
            });
            //批量审核不通过
            $(document).on("click", "#nopass", function () {
                MultiAudit('N');
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
            var _content = $("#content");
            var _btns = {
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
                //"addAction":  "Edit.aspx?optype=add",//弹出层url
                //"editAction": "Edit.aspx?optype=edit",//弹出层url
                "submitType": "form", //form或者ajax
                "submitBtn": ".btn-save",
                "submitCallback": function (btn) {
                    console.log(btn);

                }, //自定义方法
                "valiConfig": {
                    model: '#tableModal form',
                    validate: [
					],
                    callback: function (form) {
                    }
                },
                "beforeSubmit": function () {
                    return true;
                },
                "beforeShow": function (data) {//编辑页加载前控制，true可编辑，false不可编辑
                    //默认可编辑
                    return true;
                },
                "afterShow": function (data) {//编辑页加载后控制，自定义
                }
            });
        }
    </script>
    <!-- 编辑页数据初始化事件-->
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
    <!-- 编辑页验证事件-->
    <script type="text/javascript">
        function loadModalPageValidate() {
        }
    </script>
    <!-- 编辑页JS 结束-->
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
        //批量审核通过
        function MultiAudit(flag) {
            var datas = tablePackage.selection();
            var strOids = "";
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].OID.length == 0)
                    continue;
                strOids += datas[i].OID + ",";
            }
            var result = AjaxUtils.getResponseText('List_Pend.aspx?optype=multiaudit&flag=' + flag + '&ids=' + strOids);
            if (result.length == 0) {
                easyAlert.timeShow({
                    "content": "批量审批成功！",
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
        }
    </script>
    <!-- 自定义实现JS 结束-->
</asp:Content>