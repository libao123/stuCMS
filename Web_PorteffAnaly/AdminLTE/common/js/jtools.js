/*
* Author：ZZ
* Version：1.0
* CreatTime：20170810
* Use：提供一些界面工具
*/

/*下拉初始化工具*/
var DropDownUtils = {
    //异步获取下拉选项的值，返回字符串
    getDropDownDataStr: function (ddl_name) {
        var url = '/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=' + ddl_name;
        var data_str = AjaxUtils.getResponseText(url);
        return data_str;
    },
    //将异步获取的下拉值字符串绑定到下拉框
    setDropDownDataStr: function (data_str, ddl_id, value, show_type, first_txt) {
        $("#" + ddl_id).find("option").remove(); //先清空后加载
        var datas = data_str.split(';');
        if (data_str.length > 0 && datas.length > 0) {
            //默认加入一个空值
            if (typeof (first_txt) == "undefined")
                $('#' + ddl_id).prepend("<option value=''>--请选择--</option>");
            else
                $('#' + ddl_id).prepend("<option value=''>--请选择" + first_txt + "--</option>");
            for (var i = 0; i < datas.length; i++) {
                var data = datas[i].split(',');
                if (show_type && show_type == 't') {//显示文本 text
                    $('#' + ddl_id).append("<option value='" + data[0] + "'>" + data[1] + "</option>");
                }
                else {//显示文本 value+text
                    $('#' + ddl_id).append("<option value='" + data[0] + "'>" + data[0] + ' ' + data[1] + "</option>");
                }
            }

            if (value.length > 0)
                $("#" + ddl_id + " option[value=" + value + "]").attr("selected", "selected");
        }
    },
    //初始化下拉框
    initDropDown: function (id, first_txt) {
        //加载下拉控件值
        var ddlname = $("#" + id).attr('ddl_name');
        var show_type = $("#" + id).attr('show_type');
        var d_value = $("#" + id).attr('d_value');
        if (ddlname.length <= 0)
            return true; //跳出本次循环 continue
        DropDownUtils.setDropDownDataStr(DropDownUtils.getDropDownDataStr(ddlname), id, d_value, show_type, first_txt);
    },
    //获得下拉框选中的值
    getDropDownValue: function (id) {
        var result = "";
        if (id) {
            result = $("#" + id).val();
            if (result == null || typeof (result) == "undefined")
                result = "";
        }
        return result;
    },
    //获得下拉框选中的文本
    getDropDownText: function (id) {
        return $("#" + id).find("option:selected").text();
    },
    //给下拉框赋值
    setDropDownValue: function (id, value) {
        $("#" + id).val(value);
    }
}

/*多选以及单选按钮工具*/
/*多选以及单选按钮工具目前使用的是icheck进行封装，所以需要用到这个控件的一些API*/
var ICheckUtils = {
}

/*AJAX工具*/
var AjaxUtils = {
    //获取响应文本（同步）
    getResponseText: function (ajaxUrl) {
        var result = $.ajax({
            url: OptimizeUtils.FormatUrl(ajaxUrl),
            async: false
        }).responseText;
        return result;
    }
}

/*清除工具*/
var ClearUtils = {
    //去除字符串中所有的空格
    ClearStringEmpty: function (str) {
        var strResult = str.replace(/(^\s+)|(\s+$)/g, "");
        strResult = strResult.replace(/\s/g, "");

        return strResult;
    }
}

/*优化工具*/
var OptimizeUtils = {
    //格式化URL，后缀加时间戳,避免浏览器缓存
    FormatUrl: function (url) {
        if (url.indexOf("?") == -1) {
            return url + "?t=" + Math.random();
        }
        else {
            return url + "&t=" + Math.random();
        }
    },
    //格式化URL传的参数，解决乱码问题
    FormatParamter: function (par) {
        return encodeURIComponent(par);
    },
    //Window.open被浏览器拦截的问题
    WindowOpenNewWin: function (url, a_id) {
        var aElement = document.createElement('a');
        aElement.setAttribute('href', url);
        aElement.setAttribute('target', '_blank');
        aElement.setAttribute('id', a_id);
        // 防止反复添加
        if (!document.getElementById(a_id)) {
            document.body.appendChild(aElement);
        }
        aElement.click();
    }
}

/*计算工具*/
var CalculateUtiles = {
    //字符串转小数（并且可以设置保留小数位数n）
    StringToFloat: function (str, n) {
        var result = parseFloat(str);
        if (isNaN(result)) {
            result = 0;
        }
        if (typeof (n) == "undefined")
            return result;
        else
            return result.toFixed(n);
    },
    //字符串转整数
    StringToInt: function (str) {
        var result = parseInt(str);
        if (isNaN(result)) {
            result = 0;
        }
        return result;
    }
}

/*设置工具*/
var ControlUtils = {
    //input设置是否只读
    Input_SetReadOnlyStatus: function (id, status) {
        $("#" + id).attr('readonly', status);
    },
    //input设置是否不可编辑
    Input_SetDisableStatus: function (id, status) {
        $("#" + id).attr('disabled', status);
    },
    //select设置是否只读
    Select_SetReadOnlyStatus: function (id, status) {
        $("#" + id).attr('readonly', status);
    },
    //select设置是否不可编辑
    Select_SetDisableStatus: function (id, status) {
        $("#" + id).attr('disabled', status);
    }
}

/*限制工具*/
var LimitUtils = {
    // ----------------------------------------------------------------------
    // <summary>
    // 限制只能输入数字和字母
    // </summary>
    // ----------------------------------------------------------------------
    onlyNumAlpha: function (obj) {
        $("#" + obj).keypress(function (event) {
            var eventObj = event || e;
            var keyCode = eventObj.keyCode || eventObj.which;
            if ((keyCode >= 48 && keyCode <= 57)
            || (keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122))
                return true;
            else
                return false;
        }).focus(function () {
            this.style.imeMode = 'disabled';
        }).bind("paste", function () {
            var clipboard = window.clipboardData.getData("Text");
            if (/^(\d|[a-zA-Z])+$/.test(clipboard))
                return true;
            else
                return false;
        });
    },

    // ----------------------------------------------------------------------
    // <summary>
    // 限制只能输入字母
    // </summary>
    // ----------------------------------------------------------------------
    onlyAlpha: function (obj) {
        $("#" + obj).keypress(function (event) {
            var eventObj = event || e;
            var keyCode = eventObj.keyCode || eventObj.which;
            if ((keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122))
                return true;
            else
                return false;
        }).focus(function () {
            this.style.imeMode = 'disabled';
        }).bind("paste", function () {
            var clipboard = window.clipboardData.getData("Text");
            if (/^[a-zA-Z]+$/.test(clipboard))
                return true;
            else
                return false;
        }).blur(function () {
            if (!(/^[a-zA-Z]+$/.test($(this).val()))) {
                $(this).val("");
            }
        });
    },
    // ----------------------------------------------------------------------
    // <summary>
    // 限制只能输入数字
    // </summary>
    // ----------------------------------------------------------------------
    onlyNum: function (obj) {
        $("#" + obj).keypress(function (event) {
            var eventObj = event || e;
            var keyCode = eventObj.keyCode || eventObj.which;
            if ((keyCode >= 48 && keyCode <= 57))
                return true;
            else
                return false;
        }).focus(function () {
            //禁用输入法
            this.style.imeMode = 'disabled';
        }).bind("paste", function () {
            //获取剪切板的内容
            var clipboard = window.clipboardData.getData("Text");
            if (/^\d+$/.test(clipboard))
                return true;
            else
                return false;
        }).blur(function () {
            if (!(/^\d+$/.test($(this).val()))) {
                $(this).val("");
            }
        });
    },
    // ----------------------------------------------------------------------
    // <summary>
    // 限制只能输入数字与小数点
    // </summary>
    // ----------------------------------------------------------------------
    onlyNumAndPoint: function (obj) {
        $("#" + obj).keypress(function (event) {
            var eventObj = event || e;
            var keyCode = eventObj.keyCode || eventObj.which;
            if ((keyCode >= 48 && keyCode <= 57) || keyCode == 46)
                return true;
            else
                return false;
        }).focus(function () {
            //禁用输入法
            this.style.imeMode = 'disabled';
        }).bind("paste", function () {
            //获取剪切板的内容
            var clipboard = window.clipboardData.getData("Text");
            if (/^(-?\d+)(\.\d+)?$/.test(clipboard)) {
                return true;
            }
            else {
                return false;
            }
        }).blur(function () {
            if (!(/^(-?\d+)(\.\d+)?$/.test($(this).val()))) {
                $(this).val("");
            }
        });
    },
    // ----------------------------------------------------------------------
    // <summary>
    // 限制只能输入正确邮箱格式
    // </summary>
    // ----------------------------------------------------------------------
    onlyEmail: function (email) {
        if (!email.match(/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/)) {
            return false;
        }
        return true;
    },
    // ----------------------------------------------------------------------
    // <summary>
    // 限制只能输入特定长度内容
    // </summary>
    // ----------------------------------------------------------------------
    onlyInputTheLength: function (maxlength, showmsg_id, control_id) {
        $("#" + showmsg_id).text("（可以输入" + maxlength + "个字，现在还可以输入" + maxlength + "个字）");
        $("#" + control_id).keyup(function () {
            var len = $(this).val().length;
            if (len > maxlength) {
                $(this).val($(this).val().substring(0, maxlength));
            }
            var num = maxlength - len;
            if (num == 0 || num < 0)
                num = 0;
            $("#" + showmsg_id).text("（可以输入" + maxlength + "个字，现在还可以输入" + num + "个字）");
        });
        //首次加载
        if ($("#" + control_id).val().length > 0) {
            var spare_length = maxlength - $("#" + control_id).val().length;
            if (spare_length < 0)
                $("#" + showmsg_id).text("（可以输入" + maxlength + "个字，现在还可以输入0个字）");
            else
                $("#" + showmsg_id).text("（可以输入" + maxlength + "个字，现在还可以输入" + spare_length + "个字）");
        }
        else {
            $("#" + showmsg_id).text("（可以输入" + maxlength + "个字，现在还可以输入" + maxlength + "个字）");
        }
    },
    // ----------------------------------------------------------------------
    // <summary>
    // 限制只能输入特定范围长度内容
    // </summary>
    // ----------------------------------------------------------------------
    onlyInputRangeLength: function (minlength, maxlength, showmsg_id, control_id) {
        $("#" + showmsg_id).text("（可以输入" + minlength + "-" + maxlength + "个字，现在还可以输入" + minlength + "个字）");
        $("#" + control_id).keyup(function () {
            var len = $(this).val().length;
            if (len < minlength) {
                $("#" + showmsg_id).text("（可以输入" + minlength + "-" + maxlength + "个字，现在还可以输入" + (minlength - len) + "个字）");
            }
            else if (len > maxlength) {
                $(this).val($(this).val().substring(0, maxlength));
                $("#" + showmsg_id).text("（可以输入" + minlength + "-" + maxlength + "个字，现在还可以输入0个字）");
            }
            else {
                $("#" + showmsg_id).text("（可以输入" + minlength + "-" + maxlength + "个字，现在还可以输入" + (maxlength - len) + "个字）");
            }
        });
        //首次加载
        if ($("#" + control_id).val().length > minlength && $("#" + control_id).val().length < maxlength)
            $("#" + showmsg_id).text("（可以输入" + minlength + "-" + maxlength + "个字，现在还可以输入" + (maxlength - $("#" + control_id).val().length) + "个字）");
        else if ($("#" + control_id).val().length < minlength)
            $("#" + showmsg_id).text("（可以输入" + minlength + "-" + maxlength + "个字，现在还可以输入" + (minlength - $("#" + control_id).val().length) + "个字）");
        else
            $("#" + showmsg_id).text("（可以输入" + minlength + "-" + maxlength + "个字，现在还可以输入0个字）");
    }
}
/**
* 验证控件辅助方法
*/
var ValidateUtils = {
    /**
    *设置必填项
    */
    setRequired: function (selector, field, value, message) {
        message = message || "必填项";
        $(selector).validate().settings.rules[field] = { required: value };
        $(selector).validate().settings.messages[field] = { required: message };
    }
}

/**
* 下拉控件辅助方法
*/
var SelectUtils = {
    LoadEditCombox: function (data_str, combox_id, value, show_type) {
        var data_json = [];
        var datas = data_str.split(';');
        if (data_str.length > 0 && datas.length > 0) {
            for (var i = 0; i < datas.length; i++) {
                var data = datas[i].split(',');
                if (show_type && show_type == 't') {//显示文本 text
                    data_json.push('<option value="' + data[0] + '">' + data[1] + '</option>');
                }
                else//显示文本 value+text
                    data_json.push('<option value="' + data[0] + '">' + data[0] + ' ' + data[1] + '</option>');
            }
            $('#' + combox_id).empty();
            $('#' + combox_id).append($(data_json.join("")));
            $('#' + combox_id).val(value);
        }
        else {
            $('#' + combox_id).empty();
            $('#' + combox_id).append($(data_json.join("")));
            $('#' + combox_id).val("");
        }
    },
    /**
    学院与专业、年级、班级联动
    */
    XY_ZY_Grade_ClassCodeChange: function (XyID, ZyID, GradeID, ClassID, value_Xy, value_Zy, value_Grade, value_Class) {
        var grade_code = "";
        $(document).on("change", "#" + XyID, function () {
            var ddl_Zy_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_zy&xy_code=' + $('#' + XyID).val() + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Zy_str, ZyID, value_Zy || '', $('#' + ZyID).attr('show_type'));
            if (ClassID)
                SelectUtils.LoadEditCombox('', ClassID, '', $('#' + ClassID).attr('show_type'));
        });
        $(document).on("change", "#" + ZyID, function () {
            if (ClassID) {
                if (GradeID)
                    grade_code = $('#' + GradeID).val();
                else
                    grade_code = "";
                var ddl_Grade_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_class&grade_code=' + grade_code + '&zy_code=' + $('#' + ZyID).val() + '&xy_code=' + $('#' + XyID).val() + '&t=' + Math.random());
                SelectUtils.LoadEditCombox(ddl_Grade_str, ClassID, value_Class || '', $('#' + ClassID).attr('show_type'));
            }
        });
        if (GradeID) {
            $(document).on("change", "#" + GradeID, function () {
                if (ClassID && ZyID) {
                    var ddl_Class_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_class&zy_code=' + $('#' + ZyID).val() + '&grade_code=' + $('#' + GradeID).val() + '&xy_code=' + $('#' + XyID).val() + '&t=' + Math.random());
                    SelectUtils.LoadEditCombox(ddl_Class_str, ClassID, value_Class || '', $('#' + ClassID).attr('show_type'));
                }
            });
        }
        if ($('#' + XyID).val()) {
            var ddl_Zy_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_zy&xy_code=' + $('#' + XyID).val() + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Zy_str, ZyID, value_Zy || '', $('#' + ZyID).attr('show_type'));
        }
        if ($('#' + ZyID).val() && ClassID) {
            if (GradeID)
                grade_code = $('#' + GradeID).val();
            else
                grade_code = "";
            var ddl_Class_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_class&zy_code=' + $('#' + ZyID).val() + '&grade_code=' + grade_code + '&xy_code=' + $('#' + XyID).val() + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Class_str, ClassID, value_Class || '', $('#' + ClassID).attr('show_type'));
        }
    },
    /**
    年级、班级联动
    */
    Grade_ClassCodeChange: function (GradeID, ClassID, value_Grade, value_Class) {
        var grade_code = "";
        if (GradeID) {
            $(document).on("change", "#" + GradeID, function () {
                if (ClassID) {
                    var ddl_Class_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_class&grade_code=' + $('#' + GradeID).val() + '&t=' + Math.random());
                    SelectUtils.LoadEditCombox(ddl_Class_str, ClassID, value_Class || '', $('#' + ClassID).attr('show_type'));
                }
            });
        }
        if (ClassID) {
            if (GradeID)
                grade_code = $('#' + GradeID).val();
            else
                grade_code = "";
            var ddl_Class_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_class&grade_code=' + grade_code + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Class_str, ClassID, value_Class || '', $('#' + ClassID).attr('show_type'));
        }
    },
    /**
    奖助级别、奖助类型 联动
    */
    JZ_ClassTypeCodeChange: function (ClassID, TypeID, value_class, value_type) {
        var class_code = "";
        if (ClassID) {
            $(document).on("change", "#" + ClassID, function () {
                if (TypeID) {
                    var ddl_type_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_jz_type&class_code=' + $('#' + ClassID).val() + '&t=' + Math.random());
                    SelectUtils.LoadEditCombox(ddl_type_str, TypeID, value_type || '', $('#' + TypeID).attr('show_type'));
                }
            });
        }
        if (TypeID) {
            if (ClassID)
                class_code = $('#' + ClassID).val();
            else
                class_code = "";
            var ddl_type_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_jz_type&class_code=' + class_code + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_type_str, TypeID, value_type || '', $('#' + TypeID).attr('show_type'));
        }
    },
    /**
    奖助级别、奖助类型、学年、项目联动
    */
    JZ_Class_Type_Year_ProjectChange: function (ClassID, TypeID, YearID, ProjectID, value_Class, value_Type, value_Year, value_Project, Project_Flag) {
        var year_code = "";
        var class_code = "";
        var type_code = "";
        //学年 下拉改变时
        $(document).on("change", "#" + YearID, function () {
            if (YearID) {
                if ($('#' + YearID).val())
                    year_code = $('#' + YearID).val();
            }
            if (ClassID) {
                if ($('#' + ClassID).val())
                    class_code = $('#' + ClassID).val();
            }
            if (TypeID) {
                if ($('#' + TypeID).val())
                    type_code = $('#' + TypeID).val();
            }
            var ddl_Pro_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_pro&year_code=' + year_code
            + '&class_code=' + class_code + '&type_code=' + type_code
            + '&pro_flag=' + Project_Flag);
            SelectUtils.LoadEditCombox(ddl_Pro_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        });
        //奖助级别 下拉改变时
        $(document).on("change", "#" + ClassID, function () {
            if (YearID) {
                if ($('#' + YearID).val())
                    year_code = $('#' + YearID).val();
            }
            if (ClassID) {
                if ($('#' + ClassID).val())
                    class_code = $('#' + ClassID).val();
            }
            if (TypeID) {
                if ($('#' + TypeID).val())
                    type_code = $('#' + TypeID).val();
            }
            //联动出 奖助类型
            var ddl_Type_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_jz_type&class_code=' + class_code);
            SelectUtils.LoadEditCombox(ddl_Type_str, TypeID, value_Type || '', $('#' + TypeID).attr('show_type'));
            //联动出 奖助项目
            var ddl_Pro_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_pro&year_code=' + year_code
            + '&class_code=' + class_code + '&type_code=' + type_code
            + '&pro_flag=' + Project_Flag);
            SelectUtils.LoadEditCombox(ddl_Pro_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        });
        //奖助类型 下拉改变时
        $(document).on("change", "#" + TypeID, function () {
            if (YearID) {
                if ($('#' + YearID).val())
                    year_code = $('#' + YearID).val();
            }
            if (ClassID) {
                if ($('#' + ClassID).val())
                    class_code = $('#' + ClassID).val();
            }
            if (TypeID) {
                if ($('#' + TypeID).val())
                    type_code = $('#' + TypeID).val();
            }
            //联动出 奖助项目
            var ddl_Pro_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_pro&year_code=' + year_code
            + '&class_code=' + class_code + '&type_code=' + type_code
            + '&pro_flag=' + Project_Flag);
            SelectUtils.LoadEditCombox(ddl_Pro_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        });
        //当 学年 有值时
        if (YearID && $('#' + YearID).val()) {
            if (YearID) {
                if ($('#' + YearID).val())
                    year_code = $('#' + YearID).val();
            }
            if (ClassID) {
                if ($('#' + ClassID).val())
                    class_code = $('#' + ClassID).val();
            }
            if (TypeID) {
                if ($('#' + TypeID).val())
                    type_code = $('#' + TypeID).val();
            }
            //加载 奖助项目
            var ddl_Pro_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_pro&year_code=' + year_code
            + '&class_code=' + class_code + '&type_code=' + type_code
            + '&pro_flag=' + Project_Flag);
            SelectUtils.LoadEditCombox(ddl_Pro_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        }
        //当 奖助级别 有值时
        if (ClassID && $('#' + ClassID).val()) {
            if (YearID) {
                if ($('#' + YearID).val())
                    year_code = $('#' + YearID).val();
            }
            if (ClassID) {
                if ($('#' + ClassID).val())
                    class_code = $('#' + ClassID).val();
            }
            if (TypeID) {
                if ($('#' + TypeID).val())
                    type_code = $('#' + TypeID).val();
            }
            //加载 奖助类型
            var ddl_Type_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_jz_type&class_code=' + class_code);
            SelectUtils.LoadEditCombox(ddl_Type_str, TypeID, value_Type || '', $('#' + TypeID).attr('show_type'));
            //加载 奖助项目
            var ddl_Pro_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_pro&year_code=' + year_code
            + '&class_code=' + class_code + '&type_code=' + type_code
            + '&pro_flag=' + Project_Flag);
            SelectUtils.LoadEditCombox(ddl_Pro_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        }
        //当 奖助类型 有值时
        if (TypeID && $('#' + TypeID).val()) {
            if (YearID) {
                if ($('#' + YearID).val())
                    year_code = $('#' + YearID).val();
            }
            if (ClassID) {
                if ($('#' + ClassID).val())
                    class_code = $('#' + ClassID).val();
            }
            if (TypeID) {
                if ($('#' + TypeID).val())
                    type_code = $('#' + TypeID).val();
            }
            //加载 奖助项目
            var ddl_Pro_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_pro&year_code=' + year_code
            + '&class_code=' + class_code + '&type_code=' + type_code
            + '&pro_flag=' + Project_Flag);
            SelectUtils.LoadEditCombox(ddl_Pro_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        }
    },
    /**
    省、市、地区三级联动
    */
    RegionCodeChange: function (PROVINCE, CITY, COUNTY, value_province, value_city, value_county) {
        var where, ddl_region_str;
        var order = "REGION_CODE";
        $(document).on("change", "#" + PROVINCE, function () {
            where = " AND PARENT_CODE='" + $('#' + PROVINCE).val() + "'";
            ddl_region_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=ddl_region&where=' + where + '&order=' + order + '&t=' + Math.random());
            $('#' + COUNTY).val('');
            SelectUtils.LoadEditCombox(ddl_region_str, CITY, value_city || '', $('#' + CITY).attr('show_type'));
            SelectUtils.LoadEditCombox('', COUNTY, '', $('#' + COUNTY).attr('show_type'));
        });

        $(document).on("change", "#" + CITY, function () {
            where = " AND PARENT_CODE='" + $('#' + CITY).val() + "'";
            ddl_region_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=ddl_region&where=' + where + '&order=' + order + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_region_str, COUNTY, value_county || '', $('#' + COUNTY).attr('show_type'));
        });

        ddl_region_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=ddl_province&t=' + Math.random());
        SelectUtils.LoadEditCombox(ddl_region_str, PROVINCE, value_province, $('#' + PROVINCE).attr('show_type'));

        if (value_city && value_city.length > 0) {
            where = " AND PARENT_CODE='" + $('#' + PROVINCE).val() + "'";
            ddl_region_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=ddl_region&where=' + where + '&order=' + order + '&t=' + Math.random());
            where_city = " AND PARENT_CODE='" + value_city + "'";
            ddl_county_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=ddl_region&where=' + where_city + '&order=' + order + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_region_str, CITY, value_city, $('#' + CITY).attr('show_type'));
            SelectUtils.LoadEditCombox(ddl_county_str, COUNTY, '', $('#' + COUNTY).attr('show_type'));
        }
        if (value_county && value_county.length > 0) {
            where = " AND PARENT_CODE='" + $('#' + CITY).val() + "'";
            ddl_region_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=ddl_region&where=' + where + '&order=' + order + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_region_str, COUNTY, value_county, $('#' + COUNTY).attr('show_type'));
        }
    },
    /**
    保险类型、学年、保险项目联动
    */
    Insur_Year_ProjectChange: function (TypeID, YearID, ProjectID, value_Type, value_Year, value_Project) {
        var year_code = "";
        $(document).on("change", "#" + TypeID, function () {
            if (ProjectID) {
                if (YearID)
                    year_code = $('#' + YearID).val();
                else
                    year_code = "";
                var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_insur_project&type_code=' + $('#' + TypeID).val()
                + '&year_code=' + year_code
                + '&t=' + Math.random());
                SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
            }
        });
        $(document).on("change", "#" + YearID, function () {
            if (ProjectID) {
                if (YearID)
                    year_code = $('#' + YearID).val();
                else
                    year_code = "";
                var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_insur_project&year_code=' + year_code + '&type_code='
                + $('#' + TypeID).val() + '&t=' + Math.random());
                SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
            }
        });
        if ($('#' + TypeID).val()) {
            var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_insur_project&type_code=' + $('#' + TypeID).val() + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        }
        if ($('#' + YearID).val() && ProjectID) {
            if (YearID)
                year_code = $('#' + YearID).val();
            else
                year_code = "";
            var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_insur_project&type_code=' + $('#' + TypeID).val()
            + '&year_code=' + year_code + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        }
    },
    /**
    贷款类型、学年、贷款项目联动
    */
    Loan_Year_ProjectChange: function (TypeID, YearID, ProjectID, value_Type, value_Year, value_Project) {
        var year_code = "";
        $(document).on("change", "#" + TypeID, function () {
            if (ProjectID) {
                if (YearID)
                    year_code = $('#' + YearID).val();
                else
                    year_code = "";
                var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_loan_project&type_code=' + $('#' + TypeID).val()
                + '&year_code=' + year_code
                + '&t=' + Math.random());
                SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
            }
        });
        $(document).on("change", "#" + YearID, function () {
            if (ProjectID) {
                if (YearID)
                    year_code = $('#' + YearID).val();
                else
                    year_code = "";
                var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_loan_project&year_code=' + year_code + '&type_code='
                + $('#' + TypeID).val() + '&t=' + Math.random());
                SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
            }
        });
        if ($('#' + TypeID).val()) {
            var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_loan_project&type_code=' + $('#' + TypeID).val() + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        }
        if ($('#' + YearID).val() && ProjectID) {
            if (YearID)
                year_code = $('#' + YearID).val();
            else
                year_code = "";
            var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_loan_project&type_code=' + $('#' + TypeID).val()
            + '&year_code=' + year_code + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        }
    },
    /**
    学费补偿学费补偿类型、学年、学费补偿学费补偿项目联动
    */
    Makeup_Year_ProjectChange: function (TypeID, YearID, ProjectID, value_Type, value_Year, value_Project) {
        var year_code = "";
        $(document).on("change", "#" + TypeID, function () {
            if (ProjectID) {
                if (YearID)
                    year_code = $('#' + YearID).val();
                else
                    year_code = "";
                var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_makeup_project&type_code=' + $('#' + TypeID).val()
                + '&year_code=' + year_code
                + '&t=' + Math.random());
                SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
            }
        });
        $(document).on("change", "#" + YearID, function () {
            if (ProjectID) {
                if (YearID)
                    year_code = $('#' + YearID).val();
                else
                    year_code = "";
                var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_makeup_project&year_code=' + year_code + '&type_code='
                + $('#' + TypeID).val() + '&t=' + Math.random());
                SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
            }
        });
        if ($('#' + TypeID).val()) {
            var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_makeup_project&type_code=' + $('#' + TypeID).val() + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        }
        if ($('#' + YearID).val() && ProjectID) {
            if (YearID)
                year_code = $('#' + YearID).val();
            else
                year_code = "";
            var ddl_Project_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_makeup_project&type_code=' + $('#' + TypeID).val()
            + '&year_code=' + year_code + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Project_str, ProjectID, value_Project || '', $('#' + ProjectID).attr('show_type'));
        }
    },
    /**
    学年、评议主题联动
    */
    Year_PeerInfoChange: function (YearID, PeerID, value_Year, value_Peer, PeerFlag) {
        var year_code = "";
        if (YearID) {
            $(document).on("change", "#" + YearID, function () {
                if (PeerID) {
                    var ddl_Peer_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_peer&year_code=' + $('#' + YearID).val() + '&peer_flag=' + PeerFlag + '&t=' + Math.random());
                    SelectUtils.LoadEditCombox(ddl_Peer_str, PeerID, value_Peer || '', $('#' + PeerID).attr('show_type'));
                }
            });
        }
        if (PeerID) {
            if (YearID)
                year_code = $('#' + YearID).val();
            else
                year_code = "";
            var ddl_Peer_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=get_peer&year_code=' + year_code + '&peer_flag=' + PeerFlag + '&t=' + Math.random());
            SelectUtils.LoadEditCombox(ddl_Peer_str, PeerID, value_Peer || '', $('#' + PeerID).attr('show_type'));
        }
    },
    //二级联动
    TowLevelCodeChange_Sql: function (ID1, ID2, value1, value2, ddl1, ddl2, Col1) {
        var where = '';
        var order = '';

        $(document).on("change", "#" + ID1, function () {
            where = "AND " + Col1 + "='" + $('#' + ID1).val() + "'";
            ddl_second_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=' + ddl2 + '&where=' + where + '&order=' + order);
            SelectUtils.LoadEditCombox(ddl_second_str, ID2, '', 't');
        });

        var data_first_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=' + ddl1);
        SelectUtils.LoadEditCombox(data_first_str, ID1, value1, 't');

        if (value2.length > 0) {
            where = "AND " + Col1 + "='" + $('#' + ID1).val() + "'";
            var ddl_second_str = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=' + ddl2 + '&where=' + where + '&order=' + order);
            SelectUtils.LoadEditCombox(ddl_second_str, ID2, value2, 't');
        }
    },
    //当前学年、学期的用人单位与岗位联动
    CurrentEmployer_JobCodeChange: function (EmployerID, JobID, value_Employer, value_Job) {
        var employer = "";
        var ddl_str1 = "";
        var ddl_str2 = "";
        var where = "";

        if (EmployerID) {
            $(document).on("change", "#" + EmployerID, function () {
                if (JobID) {
                    where = "AND EMPLOYER='" + $('#' + EmployerID).val() + "'";
                    ddl_str2 = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=ddl_job_name&where=' + where);
                    SelectUtils.LoadEditCombox(ddl_str2, JobID, value_Job || '', $('#' + JobID).attr('show_type'));
                }
            });
        }

        ddl_str1 = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getcuremployer');
        SelectUtils.LoadEditCombox(ddl_str1, EmployerID, value_Employer || '', $('#' + EmployerID).attr('show_type'));

        if (JobID) {
            if (EmployerID)
                employer = $('#' + EmployerID).val();
            else
                employer = "";
            where = "AND EMPLOYER='" + employer + "'";
            ddl_str2 = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getddl&ddl_name=ddl_job_name&where=' + where);
            SelectUtils.LoadEditCombox(ddl_str2, JobID, value_Job || '', $('#' + JobID).attr('show_type'));
        }
    },
    //被录用的单位、岗位联动
    HiredEmployer_JobCodeChange: function (EmployerID, JobID, value_Employer, value_Job) {
        var employer = "";
        var ddl_str1 = "";
        var ddl_str2 = "";

        if (EmployerID) {
            $(document).on("change", "#" + EmployerID, function () {
                if (JobID) {
                    ddl_str2 = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getjob&employer=' + $('#' + EmployerID).val());
                    SelectUtils.LoadEditCombox(ddl_str2, JobID, value_Job || '', $('#' + JobID).attr('show_type'));
                }
            });
        }

        ddl_str1 = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getemployer');
        SelectUtils.LoadEditCombox(ddl_str1, EmployerID, value_Employer || '', $('#' + EmployerID).attr('show_type'));

        if (JobID) {
            if (EmployerID)
                employer = $('#' + EmployerID).val();
            else
                employer = "";
            ddl_str2 = AjaxUtils.getResponseText('/AdminLTE_Mod/Common/ComPage/AjaxHandlePage.aspx?optype=getjob&employer=' + employer);
            SelectUtils.LoadEditCombox(ddl_str2, JobID, value_Job || '', $('#' + JobID).attr('show_type'));
        }
    }
}