using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace AdminLTE_Mod.Common.ComPage
{
    /// <summary>
    /// Ajax公共处理界面
    /// </summary>
    public partial class AjaxHandlePage : Main
    {
        #region 初始化

        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        #endregion 初始化

        #region 窗体加载

        private comdata cod = new comdata();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                switch (optype)
                {
                    case "getddl":
                        Response.Write(GetDdlData());
                        break;

                    case "getuserrole":
                        Response.Write(GetUserRoleHtml());
                        break;

                    case "getstutype":
                        Response.Write(GetStuTypeHtml());
                        break;

                    case "getkntype":
                        Response.Write(GetKnTypeHtml());
                        break;

                    case "getnotboth":
                        Response.Write(GetNotBothHtml());
                        break;

                    case "get_outlineproject":
                        Response.Write(GetOutlineProject());
                        break;

                    case "get_checkproject":
                        Response.Write(GetCheckProject());
                        break;

                    case "get_class":
                        Response.Write(Get_Class());
                        break;

                    case "get_insurproject":
                        Response.Write(GetInsurProject());
                        break;

                    case "get_loanproject":
                        Response.Write(GetLoanProject());
                        break;

                    case "check_idnumber":
                        Response.Write(CheckIDNumber());
                        break;

                    //奖助管理：通过项目级别获得项目类型
                    case "get_jz_type":
                        Response.Write(Get_Class_Type());
                        break;

                    //奖助管理：通过项目类型获得项目
                    case "get_pro":
                        Response.Write(Get_Jz_Project());
                        break;

                    //基础信息：通过学院获得所属的专业
                    case "get_zy":
                        Response.Write(Get_Zy());
                        break;

                    //保险管理：通过保险类型获得所属的保险项目
                    case "get_insur_project":
                        Response.Write(Get_Insur_Project());
                        break;

                    //贷款管理：通过贷款类型获得所属的贷款项目
                    case "get_loan_project":
                        Response.Write(Get_Loan_Project());
                        break;

                    case "get_stuinfo":
                        Response.Write(Get_StuInfoJson());
                        break;

                    //学费补偿贷款代偿管理：通过学费补偿贷款代偿类型获得所属的学费补偿贷款代偿项目
                    case "get_makeup_project":
                        Response.Write(Get_Makeup_Project());
                        break;

                    //学费补偿贷款代偿管理：获得该学年设置的学费补偿贷款代偿项目
                    case "get_makeupproject":
                        Response.Write(GetMakeUpProject());
                        break;

                    //评议管理：获得该学年设置的评议主题
                    case "get_peer":
                        Response.Write(GetPeerProject());
                        break;

                    //勤助管理：获得当前学年、学期申报岗位的用人单位
                    case "getcuremployer":
                        Response.Write(GetDeclaredEmployer());
                        break;

                    //勤助管理：获得本人该学年该学期被录用的单位
                    case "getemployer":
                        Response.Write(GetHiredEmployer());
                        break;

                    //勤助管理：获得本人该学年该学期被录用的岗位
                    case "getjob":
                        Response.Write(GetHiredJob());
                        break;
                }
                Response.End();
            }
        }

        #endregion 窗体加载

        #region 获取下拉数据

        private string GetDdlData()
        {
            if (Request.QueryString["where"] != null && Request.QueryString["where"].Length > 0)
            {
                string strOrder = "";
                if (Request.QueryString["order"] != null && Request.QueryString["order"].Length > 0)
                {
                    strOrder = Request.QueryString["order"];
                }

                return cod.GetComboxJsonStr(cod.GetDDlDataTable(Request.QueryString["ddl_name"], Request.QueryString["where"], strOrder));
            }

            return cod.GetComboxJsonStr(cod.GetDDlDataTable(Request.QueryString["ddl_name"]));
        }

        #endregion 获取下拉数据

        #region 获取用户角色checkbox选择界面

        /// <summary>
        /// 获取用户角色checkbox选择界面
        /// </summary>
        /// <returns></returns>
        private string GetUserRoleHtml()
        {
            DataTable dtRole = cod.GetDDlDataTable("ddl_ua_role");
            if (dtRole == null || dtRole.Rows.Count == 0)
                return string.Empty;

            StringBuilder sbHtml = new StringBuilder();
            foreach (DataRow row in dtRole.Rows)
            {
                if (row == null)
                    continue;
                sbHtml.Append("<input name=\"user_role\" id=\"" + row["VALUE"].ToString() + "\"  type=\"checkbox\" value=\"" + row["VALUE"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["VALUE"].ToString() + "\">" + row["TEXT"].ToString() + "</label>&nbsp;&nbsp;");
            }

            return sbHtml.ToString();
        }

        #endregion 获取用户角色checkbox选择界面

        #region 获取学生类型checkbox选择界面

        /// <summary>
        /// 获取学生类型checkbox选择界面
        /// </summary>
        /// <returns></returns>
        private string GetStuTypeHtml()
        {
            DataTable dt = cod.GetDDlDataTable("ddl_ua_stu_type");
            if (dt == null || dt.Rows.Count == 0)
                return string.Empty;

            StringBuilder sbHtml = new StringBuilder();
            foreach (DataRow row in dt.Rows)
            {
                if (row == null)
                    continue;
                sbHtml.Append("<input name=\"stu_type\" id=\"s_" + row["VALUE"].ToString() + "\"  type=\"checkbox\" value=\"" + row["VALUE"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"s_" + row["VALUE"].ToString() + "\">" + row["TEXT"].ToString() + "</label>&nbsp;&nbsp;");
            }

            return sbHtml.ToString();
        }

        #endregion 获取学生类型checkbox选择界面

        #region 获取困难生档次checkbox选择界面

        /// <summary>
        /// 获取困难生档次checkbox选择界面
        /// </summary>
        /// <returns></returns>
        private string GetKnTypeHtml()
        {
            DataTable dt = cod.GetDDlDataTable("ddl_dst_level");
            if (dt == null || dt.Rows.Count == 0)
                return string.Empty;

            StringBuilder sbHtml = new StringBuilder();
            foreach (DataRow row in dt.Rows)
            {
                if (row == null)
                    continue;
                sbHtml.Append("<input name=\"kn_type\" id=\"kn_" + row["VALUE"].ToString() + "\"  type=\"checkbox\" value=\"" + row["VALUE"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"kn_" + row["VALUE"].ToString() + "\">" + row["TEXT"].ToString() + "</label>&nbsp;&nbsp;");
            }

            return sbHtml.ToString();
        }

        #endregion 获取困难生档次checkbox选择界面

        #region 获取不可兼得奖助类型checkbox选择界面

        /// <summary>
        /// 获取不可兼得奖助类型checkbox选择界面
        /// </summary>
        /// <returns></returns>
        private string GetNotBothHtml()
        {
            DataTable dt = cod.GetDDlDataTable("ddl_dst_level");
            if (dt == null || dt.Rows.Count == 0)
                return string.Empty;

            StringBuilder sbHtml = new StringBuilder();
            foreach (DataRow row in dt.Rows)
            {
                if (row == null)
                    continue;
                sbHtml.Append("<input name=\"kn_type\" id=\"kn_" + row["VALUE"].ToString() + "\"  type=\"checkbox\" value=\"" + row["VALUE"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"kn_" + row["VALUE"].ToString() + "\">" + row["TEXT"].ToString() + "</label>&nbsp;&nbsp;");
            }

            return sbHtml.ToString();
        }

        #endregion 获取不可兼得奖助类型checkbox选择界面

        #region 获得线下项目集合

        /// <summary>
        /// 获得线下项目集合
        /// </summary>
        /// <returns></returns>
        private string GetOutlineProject()
        {
            string sql = string.Format("SELECT SEQ_NO AS VALUE,PROJECT_NAME AS TEXT FROM SHOOLAR_PROJECT_HEAD WHERE PROJECT_CLASS = 'OUTLINE' AND PROJECT_TYPE = 'OUTLINE_SET' AND  CONVERT(VARCHAR(10),GETDATE(),120) >= APPLY_END ORDER BY APPLY_END DESC");
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(sql));
        }

        #endregion 获得线下项目集合

        #region 获得导入核对线下项目集合

        /// <summary>
        /// 获得导入核对线下项目集合
        /// </summary>
        /// <returns></returns>
        private string GetCheckProject()
        {
            //string sql = string.Format("SELECT SEQ_NO AS VALUE,PROJECT_NAME AS TEXT FROM SHOOLAR_PROJECT_HEAD WHERE PROJECT_CLASS = 'OUTLINE' AND PROJECT_TYPE = 'OUTLINE_SET' AND  CONVERT(VARCHAR(10),GETDATE(),120) BETWEEN CHECK_START AND CHECK_END ORDER BY APPLY_END DESC");
            string sql = string.Format("SELECT SEQ_NO AS VALUE,PROJECT_NAME AS TEXT FROM SHOOLAR_PROJECT_HEAD WHERE PROJECT_CLASS = 'OUTLINE' AND PROJECT_TYPE = 'OUTLINE_SET' AND  APPLY_END < CONVERT(VARCHAR(10),GETDATE(),120) ORDER BY APPLY_END DESC");
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(sql));
        }

        #endregion 获得导入核对线下项目集合

        #region 通过学院、专业、年级获得所属班级

        /// <summary>
        /// 通过学院、专业、年级获得所属班级
        /// </summary>
        /// <returns></returns>
        private string Get_Class()
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT CLASSCODE AS VALUE,CLASSNAME AS TEXT FROM BASIC_CLASS_INFO ");
            strSql.Append("WHERE 1=1 ");
            //ZZ 20171024 修改：由于研究生与本科生班级规则不同，所有查询有所改变
            if (!string.IsNullOrEmpty(Get("xy_code")))
                strSql.AppendFormat("AND XY = '{0}' ", Get("xy_code"));
            if (!string.IsNullOrEmpty(Get("zy_code")))
                strSql.AppendFormat("AND (ZY = '{0}' OR ZY = '') ", Get("zy_code"));
            if (!string.IsNullOrEmpty(Get("grade_code")))
                strSql.AppendFormat("AND GRADE = '{0}' ", Get("grade_code"));

            if (!user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))
            {
                if (user.User_Role.Equals("F"))
                {
                    string strFClass = ComHandleClass.getInstance().ByFGetClassCode(user.User_Id);
                    if (strFClass.Length > 0)
                        strSql.AppendFormat("AND CLASSCODE IN ({0}) ", ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(strFClass));
                }
            }
            strSql.Append("ORDER BY CLASSCODE ASC ");

            comdata cod = new comdata();
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(strSql.ToString()));
        }

        #endregion 通过学院、专业、年级获得所属班级

        #region 获得导入保险项目集合

        /// <summary>
        /// 获得导入保险项目集合
        /// </summary>
        /// <returns></returns>
        private string GetInsurProject()
        {
            //Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
            //只查询本学年的
            string sql = string.Format("SELECT SEQ_NO AS VALUE,INSUR_NAME AS TEXT FROM INSUR_PROJECT_HEAD WHERE 1=1 AND INSUR_YEAR = '{0}' ORDER BY OP_TIME DESC", sch_info.CURRENT_YEAR);
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(sql));
        }

        #endregion 获得导入保险项目集合

        #region 获得导入贷款项目集合

        /// <summary>
        /// 获得导入贷款项目集合
        /// </summary>
        /// <returns></returns>
        private string GetLoanProject()
        {
            //Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
            //只查询本学年的
            string sql = string.Format("SELECT SEQ_NO AS VALUE,LOAN_NAME AS TEXT FROM LOAN_PROJECT_HEAD WHERE 1=1 AND LOAN_YEAR = '{0}' ORDER BY OP_TIME DESC", sch_info.CURRENT_YEAR);
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(sql));
        }

        #endregion 获得导入贷款项目集合

        #region 校验录入的身份证号是否符合规范

        /// <summary>
        /// 校验录入的身份证号是否符合规范
        /// </summary>
        /// <param name="strIDNumber"></param>
        /// <returns></returns>
        public string CheckIDNumber()
        {
            return ComHandleClass.getInstance().CheckIDNumber(Get("idno"));
        }

        #endregion 校验录入的身份证号是否符合规范

        #region 根据项目类别代码获取相应项目类型代码

        /// <summary>
        /// 根据项目类别代码获取相应项目类型代码
        /// </summary>
        /// <returns></returns>
        private string Get_Class_Type()
        {
            string sql = string.Format("SELECT TYPE_CODE VALUE,TYPE_NAME TEXT FROM SHOOLAR_PROJECT_TYPE  WHERE 1=1 {0}   ORDER BY SEQENCE ASC", Fetch.Get("class_code").Length > 0 ? string.Format("AND CLASS_CODE = '{0}'", Fetch.Get("class_code")) : "");
            comdata cod = new comdata();
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(sql));
        }

        #endregion 根据项目类别代码获取相应项目类型代码

        #region 根据项目类型代码获取项目

        /// <summary>
        /// 根据项目类型代码获取项目
        /// </summary>
        /// <returns></returns>
        private string Get_Jz_Project()
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT SEQ_NO VALUE,PROJECT_NAME TEXT ");
            strSql.Append("FROM SHOOLAR_PROJECT_HEAD  ");
            strSql.Append("WHERE 1=1  ");
            //查询项目种类区分
            if (!string.IsNullOrEmpty(Fetch.Get("pro_flag")))
            {
                if (Fetch.Get("pro_flag").ToLower().Equals("end"))            //查询已经结束的项目
                    strSql.AppendFormat("AND APPLY_END < '{0}'  ", DateTime.Now.ToString("yyyy-MM-dd"));
            }
            //过滤条件
            if (!string.IsNullOrEmpty(Fetch.Get("class_code")))
                strSql.AppendFormat("AND PROJECT_CLASS = '{0}'  ", Fetch.Get("class_code"));

            if (!string.IsNullOrEmpty(Fetch.Get("type_code")))
                strSql.AppendFormat("AND PROJECT_TYPE = '{0}'  ", Fetch.Get("type_code"));

            if (!string.IsNullOrEmpty(Fetch.Get("year_code")))
                strSql.AppendFormat("AND APPLY_YEAR = '{0}'  ", Fetch.Get("year_code"));

            //排序
            strSql.Append("ORDER BY APPLY_END ASC  ");

            comdata cod = new comdata();
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(strSql.ToString()));
        }

        #endregion 根据项目类型代码获取项目

        #region 通过学院获得所属的专业

        /// <summary>
        /// 通过学院获得所属的专业
        /// </summary>
        /// <returns></returns>
        private string Get_Zy()
        {
            string sql = string.Format("SELECT zy VALUE,mc TEXT FROM t_jx_zy  WHERE 1=1 {0}   ORDER BY xy ASC", Fetch.Get("xy_code").Length > 0 ? string.Format("AND xy = '{0}'", Fetch.Get("xy_code")) : "");
            comdata cod = new comdata();
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(sql));
        }

        #endregion 通过学院获得所属的专业

        #region 保险管理：通过保险类型获得所属的保险项目

        /// <summary>
        /// 保险管理：通过保险类型获得所属的保险项目
        /// </summary>
        /// <returns></returns>
        private string Get_Insur_Project()
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT SEQ_NO VALUE,INSUR_NAME TEXT ");
            strSql.Append("FROM INSUR_PROJECT_HEAD  ");
            strSql.Append("WHERE 1=1  ");
            //过滤条件
            if (Fetch.Get("type_code").Length > 0)
                strSql.AppendFormat("AND INSUR_TYPE = '{0}'  ", Fetch.Get("type_code"));
            if (Fetch.Get("year_code").Length > 0)
                strSql.AppendFormat("AND INSUR_YEAR = '{0}'  ", Fetch.Get("year_code"));

            //排序
            strSql.Append("ORDER BY OP_TIME DESC  ");
            comdata cod = new comdata();
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(strSql.ToString()));
        }

        #endregion 保险管理：通过保险类型获得所属的保险项目

        #region 贷款管理：通过贷款类型获得所属的贷款项目

        /// <summary>
        /// 贷款管理：通过贷款类型获得所属的贷款项目
        /// </summary>
        /// <returns></returns>
        private string Get_Loan_Project()
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT SEQ_NO VALUE,LOAN_NAME TEXT ");
            strSql.Append("FROM LOAN_PROJECT_HEAD  ");
            strSql.Append("WHERE 1=1  ");
            //过滤条件
            if (Fetch.Get("type_code").Length > 0)
                strSql.AppendFormat("AND LOAN_TYPE = '{0}'  ", Fetch.Get("type_code"));
            if (Fetch.Get("year_code").Length > 0)
                strSql.AppendFormat("AND LOAN_YEAR = '{0}'  ", Fetch.Get("year_code"));

            //排序
            strSql.Append("ORDER BY OP_TIME DESC  ");
            comdata cod = new comdata();
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(strSql.ToString()));
        }

        #endregion 贷款管理：通过贷款类型获得所属的贷款项目

        #region 学费补偿贷款代偿管理：通过学费补偿贷款代偿类型获得所属的学费补偿贷款代偿项目

        /// <summary>
        /// 学费补偿贷款代偿管理：通过学费补偿贷款代偿类型获得所属的学费补偿贷款代偿项目
        /// </summary>
        /// <returns></returns>
        private string Get_Makeup_Project()
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT SEQ_NO VALUE,MAKEUP_NAME TEXT ");
            strSql.Append("FROM MAKEUP_PROJECT_HEAD  ");
            strSql.Append("WHERE 1=1  ");
            //过滤条件
            if (Fetch.Get("type_code").Length > 0)
                strSql.AppendFormat("AND MAKEUP_TYPE = '{0}'  ", Fetch.Get("type_code"));
            if (Fetch.Get("year_code").Length > 0)
                strSql.AppendFormat("AND MAKEUP_YEAR = '{0}'  ", Fetch.Get("year_code"));

            //排序
            strSql.Append("ORDER BY OP_TIME DESC  ");
            comdata cod = new comdata();
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(strSql.ToString()));
        }

        #endregion 学费补偿贷款代偿管理：通过学费补偿贷款代偿类型获得所属的学费补偿贷款代偿项目

        #region 获得导入学费补偿贷款代偿项目集合

        /// <summary>
        /// 获得导入学费补偿贷款代偿项目集合
        /// </summary>
        /// <returns></returns>
        private string GetMakeUpProject()
        {
            //Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
            //只查询本学年的
            string sql = string.Format("SELECT SEQ_NO AS VALUE,MAKEUP_NAME AS TEXT FROM MAKEUP_PROJECT_HEAD WHERE 1=1 AND MAKEUP_YEAR = '{0}' ORDER BY OP_TIME DESC", sch_info.CURRENT_YEAR);
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(sql));
        }

        #endregion 获得导入学费补偿贷款代偿项目集合

        #region 获得该学年设置的评议主题

        /// <summary>
        /// 获得该学年设置的评议主题
        /// </summary>
        /// <returns></returns>
        private string GetPeerProject()
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("SELECT SEQ_NO VALUE,PEER_NAME TEXT ");
            strSql.Append("FROM PEER_PROJECT_HEAD  ");
            strSql.Append("WHERE 1=1  ");
            //查询项目种类区分
            if (!string.IsNullOrEmpty(Fetch.Get("peer_flag")))
            {
                if (Fetch.Get("peer_flag").ToLower().Equals("end"))            //查询已经结束的项目
                    strSql.AppendFormat("AND PEER_END < '{0}'  ", DateTime.Now.ToString("yyyy-MM-dd"));
            }
            //过滤条件
            if (Fetch.Get("year_code").Length > 0)
                strSql.AppendFormat("AND PEER_YEAR = '{0}'  ", Fetch.Get("year_code"));

            //排序
            strSql.Append("ORDER BY OP_TIME DESC  ");
            comdata cod = new comdata();
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(strSql.ToString()));
        }

        #endregion 获得该学年设置的评议主题

        #region 通过学号获得学生信息

        /// <summary>
        /// 通过学号获得学生信息
        /// </summary>
        /// <returns></returns>
        private string Get_StuInfoJson()
        {
            if (string.IsNullOrEmpty(Fetch.Get("stu_num")))
                return "{}";
            return StuHandleClass.getInstance().GetStuInfoJson(Fetch.Get("stu_num"));
        }

        #endregion 通过学号获得学生信息

        #region 勤助管理：获得当前学年、学期申报岗位的用人单位

        private string GetDeclaredEmployer()
        {
            string strSql = string.Format("SELECT DW VALUE, MC TEXT FROM T_XT_DEPARTMENT WHERE DW IN (SELECT EMPLOYER FROM QZ_JOB_MANAGE WHERE RET_CHANNEL = 'D4000' AND IS_USE = 'Y' AND SCH_YEAR = '{0}' AND SCH_TERM = '{1}' AND STU_TYPE = '{2}')", sch_info.CURRENT_YEAR, sch_info.CURRENT_XQ, user.Stu_Type);
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(strSql));
        }

        #endregion

        #region 勤助管理：获得本人该学年该学期被录用的单位

        private string GetHiredEmployer()
        {
            string strSql_Apply = string.Format("SELECT DISTINCT EMPLOYER FROM QZ_JOB_APPLY_HEAD WHERE EMPLOY_FLAG = 'Y' AND SCH_YEAR = '{0}' AND SCH_TERM = '{1}' AND STU_NUMBER = '{2}'", sch_info.CURRENT_YEAR, sch_info.CURRENT_XQ, user.User_Id);
            string strSql = string.Format("SELECT DW VALUE, MC TEXT FROM T_XT_DEPARTMENT WHERE DW IN ({0})", strSql_Apply);
            strSql += " ORDER BY DW DESC";
            comdata cod = new comdata();
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(strSql));
        }

        #endregion

        #region 勤助管理：获得本人该学年该学期被录用的岗位

        private string GetHiredJob()
        {
            string strSql_Apply = string.Format("SELECT DISTINCT EXPECT_JOB1 FROM QZ_JOB_APPLY_HEAD WHERE EMPLOY_FLAG = 'Y' AND SCH_YEAR = '{0}' AND SCH_TERM = '{1}' AND STU_NUMBER = '{2}'", sch_info.CURRENT_YEAR, sch_info.CURRENT_XQ, user.User_Id);
            if (!string.IsNullOrEmpty(Fetch.Get("employer")))
            {
                strSql_Apply += string.Format(" AND EMPLOYER = '{0}'", Fetch.Get("employer"));
            }
            string strSql = string.Format("SELECT SEQ_NO VALUE, JOB_NAME TEXT FROM QZ_JOB_MANAGE WHERE SEQ_NO IN ({0})", strSql_Apply);
            strSql += " ORDER BY OP_TIME DESC";
            comdata cod = new comdata();
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(strSql));
        }

        #endregion
    }
}