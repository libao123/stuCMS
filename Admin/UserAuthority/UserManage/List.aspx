<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.UserAuthority.UserManage.List" %>

<%@ Register Assembly="HQ.WebControl" Namespace="HQ.WebControl" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .fieldsetclass
        {
            margin: 5px;
            border-color: #E2DED6;
            border-width: 1px;
            border-style: Solid;
            width: 98%;
        }
        .legendclass
        {
            font-size: 12px;
            font-family: arial, sans-serif;
            margin-left: 20px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
           var ph = Math.max(document.documentElement.clientHeight, document.body.clientHeight);
            $("#main").css({ height: ph - $("#content").height() - $("#searchDiv").height() - 200 });
            PageUtils.initComboBox();
            MiscUtils.onlyNum("USER_ID"); //代码限制只能录入数字
            MiscUtils.onlyNumAlpha("LOGIN_PW"); //代码限制只能录入数字或者字母
            MiscUtils.onlyNumAlpha("LOGIN_PW_COMIT"); //代码限制只能录入数字或者字母

            /*以下为表格属性*/
            //固定的列
            var fCol = [[{ field: 'ck', checkbox: true, width: 100 }]];
            //其他显示的列
            var cols = [[
             { field: 'USER_ID', title: '用户编码', width: 120, sortable: true },
             { field: 'USER_NAME', title: '用户名', width: 100, sortable: true },
             { field: 'USER_TYPE_NAME', title: '用户类型', width: 100, sortable: true },
			 { field: 'XY_CODE_NAME', title: '所属学院', width: 150, sortable: true },
             { field: 'USER_ROLE_NAME', title: '所属角色', width: 300, sortable: true },
             { field: 'IS_ASSISTANT_NAME', title: '是否辅导员', width: 100, sortable: true },
             { field: 'CREATE_NAME', title: '最后操作人', width: 120, sortable: true },
             { field: 'CREATE_TIME', title: '最后操作时间', width: 150, sortable: true }
             ]];

            /*查询参数，json格式，一般通过查询控件绑定，也可以自定义如: {'code':'001','name':'doublesun'}*/
            var paras = <%= QuerySearch.Params %>;

            //定义表格的工具栏按钮
            var tBar = [{
                text: '刷新',
                iconCls: 'icon-reload',
                handler: function () {
                    DataGridUtils.refreshData("tabList");
                }
            }, '-', {
                text: '新增',
                iconCls: 'icon-add',
                handler: function () {
                    ClearValue();
                }
            }, '-', {
                text: '删除',
                iconCls: 'icon-cancel',
                handler: function () {
                    DialogUtils.showDeleteDataDialog("tabList", "List.aspx?optype=delete", "是否删除该班级信息数据？", "USER_ID");
                    ClearValue();
                }
            }, '-', {
                text: '保存',
                iconCls: 'icon-save',
                handler: function () {
                     if (FormUtils.validateForm() == false) {
                        MsgUtils.info("请输入必填项！");
                        return false;
                    }

                    var userType = $("#USER_TYPE").combobox("getValue");
                    var stuType = $("#STU_TYPE").combobox("getValue");
                    if (userType == "S" && stuType.length == 0) {
                        MsgUtils.info("该用户是学生，请选择学生类型！");
                        return false;
                    }

                    GetCheckBoxSelected();
                    if ($("#UserRoles").val().length == 0) {
                        MsgUtils.info("请选择用户所属角色！");
                        return false;
                    }

                    var password = $("#LOGIN_PW").val();
                    var password_comit = $("#LOGIN_PW_COMIT").val();
                    if (password != password_comit) {
                        MsgUtils.info("密码与确认密码不一致，请确认！");
                        return false;
                    }

                    $.post(MiscUtils.FormatUrl("List.aspx?optype=save"), $("#form_User").serialize(), function (msg) {
                        if (msg.length == 0) {
                            MsgUtils.info("保存失败！");
                            return;
                        }
                        else {
                            //保存成功之后，把编辑部分数据清空，然后再重新加载列表数据
                            ClearValue();
                            DataGridUtils.refreshData("tabList");
                        }
                    });
                }
            }];

            //表格构造
            var getlist_url = 'List.aspx?optype=getlist';
            DataGridUtils.createDefaultDataGrid('tabList', getlist_url, paras, fCol, cols, tBar, SingleSelectClick, SingleSelectClick);
        });

         //清空界面数值
        function ClearValue() {
            $("#USER_ID").val('');
            $("#USER_NAME").val('');
            $("#LOGIN_PW").val('');
            $("#LOGIN_PW_COMIT").val('');
            $("#USER_TYPE").combobox("setValue", '');
            $("#XY_CODE").combobox("setValue", '');
            $("#STU_TYPE").combobox("setValue", '');
            $("#IS_ASSISTANT").combobox("setValue", '');
            $("#UserRoles").val("");
            GetCheckBoxSelectedLoad($("#UserRoles").val());
        }

        //角色选择加载
        function GetCheckBoxSelectedLoad(roles) {
            if (roles.length == 0)
            {
                $("input[type='checkbox'][name='user_role']").each(function () {
                    $(this).prop("checked", false);
                });
                return;
            }
            var arrRole = roles.split(',');
            for (var i = 0; i < arrRole.length; i++) {
                if (arrRole[i].toString().length == 0)
                    continue;
                $("input[type='checkbox'][name='user_role']").each(function () {
                    if ($(this).attr('value') == arrRole[i].toString()) {
                        $(this).prop("checked", true);
                    }
                });
            }
        }

        //单击
        function SingleSelectClick(rowIndex, rowData) {
            ClearValue();
            $("#USER_ID").val(rowData["USER_ID"]);
            $("#USER_NAME").val(rowData["USER_NAME"]);
            $("#LOGIN_PW").val(rowData["LOGIN_PW"]);
            $("#LOGIN_PW_COMIT").val(rowData["LOGIN_PW"]);
            $("#USER_TYPE").combobox("setValue", rowData["USER_TYPE"]);
            $("#XY_CODE").combobox("setValue", rowData["XY_CODE"]);
            $("#STU_TYPE").combobox("setValue", rowData["STU_TYPE"]);
            $("#IS_ASSISTANT").combobox("setValue", rowData["IS_ASSISTANT"]);
            $("#UserRoles").val(rowData["USER_ROLE"]);
            GetCheckBoxSelectedLoad($("#UserRoles").val());
        }

        //选择角色
        function GetCheckBoxSelected() {
            var checkbox = "";
            $("#UserRoles").val("");

            $("input[type='checkbox'][name='user_role']:checked").each(function () {
                if ($(this) != null) {
                    checkbox += $(this).attr('value') + ',';
                }
            });

            if (checkbox.length > 0) {
                $("#UserRoles").val(checkbox);
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="form_User">
    <fieldset class="fieldsetclass">
        <legend class="legendclass">编辑用户信息</legend>
        <input type="hidden" name="UserRoles" id="UserRoles" value="" />
        <div id="content" style="width: 100%;">
            <table class="form-tb" style="width: 95%; margin: 10px;">
                <tr>
                    <td class="label-bg" style="width: 120px;">
                        用户编码<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <input type="text" id="USER_ID" class="easyui-validatebox input-text" name="USER_ID"
                            style="width: 150px;" required="true" value='' maxlength="20" />
                    </td>
                    <td class="label-bg" style="width: 120px;">
                        用户名<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <input type="text" id="USER_NAME" class="easyui-validatebox input-text" name="USER_NAME"
                            style="width: 150px;" required="true" value='' maxlength="20" />
                    </td>
                    <td class="label-bg" style="width: 120px;">
                        用户类型<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="USER_TYPE" class="easyui-combobox" name="USER_TYPE" style="width: 150px;"
                            d_value='' ddl_name='ddl_user_type' show_type='t' title="用户类型" required="true"
                            panelheight="120">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="label-bg">
                        所属学院<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="XY_CODE" class="easyui-combobox" name="XY_CODE" style="width: 150px;"
                            d_value='' ddl_name='ddl_department' show_type='t' title="所属学院" required="true"
                            panelheight="300" panelwidth="250">
                        </select>
                    </td>
                    <td class="label-bg">
                        学生类型
                    </td>
                    <td>
                        <select id="STU_TYPE" class="easyui-combobox" name="STU_TYPE" style="width: 150px;"
                            d_value='' ddl_name='ddl_stu_type' show_type='t' title="学生类型" panelheight="120">
                        </select>
                    </td>
                    <td class="label-bg">
                        是否辅导员<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="IS_ASSISTANT" class="easyui-combobox" name="IS_ASSISTANT" style="width: 150px;"
                            d_value='' ddl_name='ddl_yes_no' show_type='t' title="是否辅导员" required="true"
                            panelheight="120">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="label-bg">
                        所属角色<span style="color: Red;">*</span>
                    </td>
                    <td colspan="5">
                        <div runat="server" id="divUserRole" style="margin-top: 5px;">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="label-bg">
                        登录密码<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <input type="password" id="LOGIN_PW" class="easyui-validatebox input-text" name="LOGIN_PW"
                            style="width: 150px;" required="true" value='' maxlength="20" />
                    </td>
                    <td class="label-bg">
                        确认密码<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <input type="password" id="LOGIN_PW_COMIT" class="easyui-validatebox input-text"
                            name="LOGIN_PW_COMIT" style="width: 150px;" required="true" value='' maxlength="20" />
                    </td>
                </tr>
            </table>
        </div>
    </fieldset>
    <fieldset class="fieldsetclass">
        <legend class="legendclass">用户基础信息</legend>
        <div id="searchDiv" style="height: 30px;">
            <div style="height: 5px;">
            </div>
            <cc1:QueryField ID="QuerySearch" runat="server" QueryName="UA_USER_Query" TableId="tabList" />
        </div>
        <div id="main" style="width: 100%;">
            <table id="tabList">
            </table>
        </div>
    </fieldset>
    </form>
</asp:Content>