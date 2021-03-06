﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.SysBasic.zy.List" %>

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
            $("#main").css({ height: ph - $("#content").height() - $("#searchDiv").height() - 350 });
            PageUtils.initComboBox();
            MiscUtils.onlyNumAlpha("ZY"); //代码限制只能录入数字或者字母
            MiscUtils.onlyNumAlpha("YWMC"); //代码限制只能录入数字或者字母
            /*以下为表格属性*/
            //固定的列
            var fCol = [[{ field: 'ck', checkbox: true, width: 80}]];
            //其他显示的列
            var cols = [[
             { field: 'ZY', title: '代码', width: 100, sortable: true },
             { field: 'MC', title: '名称', width: 120 },
             { field: 'XY_NAME', title: '所属学院', width: 250, sortable: true },
             { field: 'ZT_NAME', title: '状态', width: 80, sortable: true }
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
                    ClearValue('add');
                }
            }, '-', {
                text: '删除',
                iconCls: 'icon-cancel',
                handler: function () {
                    DialogUtils.showDeleteDataDialog("tabList", "List.aspx?optype=delete", "是否删除该专业信息数据？", "ZY");
                    ClearValue('del');
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
                            ClearValue('del');
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
        function ClearValue(type) {
            $("#ZY").val('');
            $("#MC").val('');
            $("#YWMC").val('');
            $("#XY").combobox("setValue", '');
            if (type = 'add')
                $("#ZT").combobox("setValue",'1');//默认可用
            else
                $("#ZT").combobox("setValue",'');
        }

        //单击
        function SingleSelectClick(rowIndex, rowData) {
            ClearValue();
            $("#ZY").val(rowData["ZY"]);
            $("#MC").val(rowData["MC"]);
            $("#YWMC").val(rowData["YWMC"]);
            $("#XY").combobox("setValue", rowData["XY"]);
            $("#ZT").combobox("setValue", rowData["ZT"]);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <form id="form_Param">
    <fieldset class="fieldsetclass">
        <legend class="legendclass">编辑专业信息</legend>
        <div id="content" style="width: 100%;">
            <table class="form-tb" style="width: 95%; margin: 10px;">
                <tr>
                    <td class="label-bg" style="width: 80px;">
                        专业代码<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <input type="text" id="ZY" name="ZY" style="width: 220px;" class="easyui-validatebox input-text"
                            value="" required="true" maxlength="7" />
                    </td>
                    <td class="label-bg" style="width: 80px;">
                        专业名称<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <input type="text" id="MC" name="MC" style="width: 220px;" class="easyui-validatebox input-text"
                            value="" required="true" maxlength="25" />
                    </td>
                </tr>
                <tr>
                    <td class="label-bg" style="width: 80px;">
                        所属学院<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="XY" name="XY" show_type='t' style="width: 220px;" class="easyui-combobox"
                            ddl_name='ddl_department' d_value='' title="所属学院" panelheight="300" panelwidth="250"
                            required="true">
                        </select>
                    </td>
                    <td class="label-bg" style="width: 80px;">
                        状态<span style="color: Red;">*</span>
                    </td>
                    <td>
                        <select id="ZT" name="ZT" show_type='t' style="width: 220px;" class="easyui-combobox"
                            ddl_name='ddl_use_flag' d_value='' title="状态" panelheight="80" required="true">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="label-bg" style="width: 80px;">
                        英文名称
                    </td>
                    <td>
                        <input type="text" id="YWMC" name="YWMC" style="width: 220px;" class="easyui-validatebox input-text"
                            value="" maxlength="64" />
                    </td>
                </tr>
            </table>
        </div>
    </fieldset>
    <fieldset class="fieldsetclass">
        <legend class="legendclass">字典专业信息</legend>
        <div id="searchDiv" style="height: 30px;">
            <div style="height: 5px;">
            </div>
            <cc1:QueryField ID="QuerySearch" runat="server" QueryName="ZD_Com_Query" TableId="tabList" />
        </div>
        <div id="main" style="width: 100%;">
            <table id="tabList">
            </table>
        </div>
    </fieldset>
    </form>
</asp:Content>