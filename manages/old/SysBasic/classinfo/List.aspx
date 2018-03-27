<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.SysBasic.classinfo.List" %>

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
            $("#main").css({ height: ph - $("#content").height() - $("#searchDiv").height() - 220 });
            PageUtils.initComboBox();
            Basic_XY_ZY_CodeChange('XY', 'ZY',$("#XY").combobox("getValue"),$("#ZY").combobox("getValue"));
            MiscUtils.onlyNumAlpha("CLASSCODE"); //代码限制只能录入数字或者字母
            $('#GRADE').combobox({
                onChange: function () {
                    GetClassCode ();
                }
            });
            $('#ZY').combobox({
                onChange: function () {
                    GetClassCode ();
                }
            });
            /*以下为表格属性*/
            //固定的列
            var fCol = [[{ field: 'ck', checkbox: true, width: 80}]];
            //其他显示的列
            var cols = [[
             { field: 'CLASSCODE', title: '班级代码', width: 200, sortable: true },
             { field: 'CLASSNAME', title: '班级名称', width: 200 },
             { field: 'XY_NAME', title: '所属学院', width: 250, sortable: true },
             { field: 'ZY_NAME', title: '所属专业', width: 150, sortable: true },
             { field: 'GRADE_NAME', title: '所属年级', width: 100, sortable: true },
             { field: 'OP_NAME', title: '操作人', width: 100 },
             { field: 'OP_TIME', title: '操作时间', width: 150 }
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
                    DialogUtils.showDeleteDataDialog("tabList", "List.aspx?optype=delete", "是否删除该班级信息数据？", "CLASSCODE");
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

                    $.post(MiscUtils.FormatUrl("List.aspx?optype=save"), $("#form_Param").serialize(), function (msg) {
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

        //获得班级代码组成
        function GetClassCode()
        {
            var ex_class = "";
            var grade = $("#GRADE").combobox("getValue");
            var xy = $("#XY").combobox("getValue");
            var zy = $("#ZY").combobox("getValue");
            ex_class = grade + "_" + xy + "_" + zy + "_";
            $("#EX_CLASSCODE").val(ex_class);
        }

        //清空界面数值
        function ClearValue() {
            $("#EX_CLASSCODE").val('');
            $("#CLASSCODE").val('');
            $("#CLASSNAME").val('');
            $("#XY").combobox("setValue", '');
            $("#ZY").combobox("setValue", '');
            $("#GRADE").combobox("setValue", '');
        }

        //单击
        function SingleSelectClick(rowIndex, rowData) {
            ClearValue();
            if (rowData["CLASSCODE"].toString().length > 0)
            {
                var arr_classcode = rowData["CLASSCODE"].toString().split ('_');
                if (arr_classcode.length  == 4)
                {
                    $("#EX_CLASSCODE").val(arr_classcode[0]+ "_" +arr_classcode[1]+ "_" +arr_classcode[2]+ "_");
                    $("#CLASSCODE").val(arr_classcode[3]);
                }
            }
            $("#CLASSNAME").val(rowData["CLASSNAME"]);
            $("#XY").combobox("setValue", rowData["XY"]);
            $("#ZY").combobox("setValue", rowData["ZY"]);
            $("#GRADE").combobox("setValue", rowData["GRADE"]);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="form_Param">
    <fieldset class="fieldsetclass">
        <legend class="legendclass">编辑班级信息</legend>
        <div id="content" style="width: 100%;">
            <table class="form-tb" style="width: 95%; margin: 10px;">
                <tr>
                    <td class="label-bg" style="width: 80px;">
                        所属年级<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="GRADE" name="GRADE" show_type='t' style="width: 220px;" class="easyui-combobox"
                            ddl_name='ddl_grade' d_value='' title="所属年级" panelheight="120" required="true">
                        </select>
                    </td>
                    <td class="label-bg" style="width: 80px;">
                        所属学院<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="XY" name="XY" show_type='t' style="width: 220px;" class="easyui-combobox"
                            ddl_name='ddl_department' d_value='' title="所属学院" panelheight="300" panelwidth="250"
                            required="true">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="label-bg" style="width: 80px;">
                        所属专业<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="ZY" name="ZY" show_type='t' style="width: 220px;" class="easyui-combobox"
                            ddl_name='ddl_zy' d_value='' title="专业" panelheight="200" panelwidth="250" required="true">
                        </select>
                    </td>
                    <td class="label-bg" style="width: 80px;">
                        班级名称<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <input type="text" id="CLASSNAME" name="CLASSNAME" style="width: 220px;" class="easyui-validatebox input-text"
                            value="" required="true" maxlength="25" />
                    </td>
                </tr>
                <tr>
                    <td class="label-bg" style="width: 80px;">
                        班级代码<span style="color: Red;">*</span>
                    </td>
                    <td colspan="3">
                        <input type="text" id="EX_CLASSCODE" name="EX_CLASSCODE" style="width: 120px;" class="easyui-validatebox input-text-none"
                            value="" /><input type="text" id="CLASSCODE" name="CLASSCODE" style="width: 100px;"
                                class="easyui-validatebox input-text" value="" required="true" maxlength="10" /><span
                                    style="color: Red;"> 班级代码组成说明：年级代码 _ 学院代码 _ 专业代码 _ 自定义的班级代码（如：2016_01_02_03：XX三班）</span>
                    </td>
                </tr>
            </table>
        </div>
    </fieldset>
    <fieldset class="fieldsetclass">
        <legend class="legendclass">班级基础信息</legend>
        <div id="searchDiv" style="height: 30px;">
            <div style="height: 5px;">
            </div>
            <cc1:QueryField ID="QuerySearch" runat="server" QueryName="Class_Query" TableId="tabList" />
        </div>
        <div id="main" style="width: 100%;">
            <table id="tabList">
            </table>
        </div>
    </fieldset>
    </form>
</asp:Content>