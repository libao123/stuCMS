using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Loan.ProjectCheck
{
    public partial class ResultList : Main
    {
        #region 界面加载

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public bool IsShowBtn = false;//ZZ 20171026 新增：是否显示按钮：校级角色显示
        public string IsSchool = "false";//ZZ 20171026 新增：是否显示按钮：校级角色显示

        protected void Page_Load(object sender, EventArgs e)
        {
            string optype = Request.QueryString["optype"];
            if (!string.IsNullOrEmpty(optype))
            {
                switch (optype.ToLower().Trim())
                {
                    case "getper":
                        Response.Write(GetPerInfo());
                        Response.End();
                        break;

                    case "iscan_export":
                        Response.Write(IsCanExport());
                        Response.End();
                        break;
                }
            }
            if (user.User_Role.Equals("X") || user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))
            {
                IsShowBtn = true;
                IsSchool = "true";
            }
        }

        #endregion 界面加载

        #region 获得进度信息

        /// <summary>
        /// 获得进度信息
        /// </summary>
        /// <param name="where"></param>
        /// <param name="hs"></param>
        /// <returns></returns>
        private string GetPerInfo()
        {
            string strPer = string.Empty;

            #region 查询条件

            #region 查询条件

            string strWhere = string.Empty;
            strWhere = GetSearchWhere(strWhere);

            #endregion 查询条件

            #endregion 查询条件

            int FenmuCount = GetTotalCount(string.Empty, strWhere);
            int FenziCount = GetTotalCount("step", strWhere);
            if (FenmuCount == 0)
            {
                strPer = string.Format("目前进度：0     百分比：0%");
            }
            else
            {
                decimal dFenziCount = Math.Round(cod.ChangeDecimal(FenziCount.ToString()), 4);
                decimal dFenmuCount = Math.Round(cod.ChangeDecimal(FenmuCount.ToString()), 4);
                decimal dPer = Math.Round(dFenziCount / dFenmuCount, 4);
                decimal per = Math.Round(dPer * 100, 2);
                strPer = string.Format("目前进度：{0}/{1}     百分比：{2}%", FenziCount, FenmuCount, per.ToString());
            }
            return strPer;
        }

        #endregion 获得进度信息

        #region 判断是否满足导出核对数据条件

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public string GetSearchWhere(string where)
        {
            if (!string.IsNullOrEmpty(Get("LOAN_TYPE")))
                where += string.Format(" AND LOAN_TYPE = '{0}' ", Get("LOAN_TYPE"));
            if (!string.IsNullOrEmpty(Get("LOAN_YEAR")))
                where += string.Format(" AND LOAN_YEAR = '{0}' ", Get("LOAN_YEAR"));
            if (!string.IsNullOrEmpty(Get("LOAN_SEQ_NO")))
                where += string.Format(" AND LOAN_SEQ_NO = '{0}' ", Get("LOAN_SEQ_NO"));
            if (!string.IsNullOrEmpty(Get("XY")))
                where += string.Format(" AND XY = '{0}' ", Get("XY"));
            if (!string.IsNullOrEmpty(Get("ZY")))
                where += string.Format(" AND ZY = '{0}' ", Get("ZY"));
            if (!string.IsNullOrEmpty(Get("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Get("GRADE"));
            if (!string.IsNullOrEmpty(Get("CLASS_CODE")))
                where += string.Format(" AND CLASS_CODE = '{0}' ", Get("CLASS_CODE"));
            if (!string.IsNullOrEmpty(Get("STU_NUMBER")))
                where += string.Format(" AND STU_NUMBER LIKE '%{0}%' ", Get("STU_NUMBER"));
            if (!string.IsNullOrEmpty(Get("STU_NAME")))
                where += string.Format(" AND STU_NAME LIKE '%{0}%' ", Get("STU_NAME"));
            if (!string.IsNullOrEmpty(Get("CHECK_STEP")))
            {
                if (Get("CHECK_STEP").Equals("N"))//ZZ 20171106 新增：新增了一个状态“学生未核对”
                {
                    where += string.Format(" AND CHECK_STEP = '' ", string.Empty);
                }
                else
                {
                    where += string.Format(" AND CHECK_STEP = '{0}' ", Get("CHECK_STEP"));
                }
            }
            return where;
        }

        /// <summary>
        /// 判断是否满足导出核对数据条件
        /// </summary>
        /// <returns></returns>
        private string IsCanExport()
        {
            if (user.User_Role.Equals("X") || user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))//校级不需要满足导出条件
                return string.Empty;

            #region 查询条件

            string strWhere = string.Empty;
            strWhere = GetSearchWhere(strWhere);

            #endregion 查询条件

            int FenmuCount = GetTotalCount(string.Empty, strWhere);
            int FenziCount = GetTotalCount("step_3", strWhere);
            if (FenmuCount != FenziCount)
                return "进度未达到100%，不符合导出条件！";
            return string.Empty;
        }

        #endregion 判断是否满足导出核对数据条件

        #region 通过条件查询总数

        /// <summary>
        /// 通过条件查询总数
        /// </summary>
        /// <param name="strFlag"></param>
        /// <param name="strWhere"></param>
        /// <returns></returns>
        private int GetTotalCount(string strFlag, string strWhere)
        {
            StringBuilder strSQL = new StringBuilder();
            strSQL.Append("SELECT COUNT(1) AS TOTAL_COUNT FROM ( ");
            strSQL.Append("SELECT T.*,ROW_NUMBER() OVER(ORDER BY T.CHK_TIME DESC) RN ");
            strSQL.Append("FROM( ");
            strSQL.Append("SELECT A.*, ");
            strSQL.Append("B.CHECK_STEP ");
            strSQL.Append("FROM LOAN_PROJECT_APPLY A LEFT JOIN LOAN_APPLY_CHECK B ");
            strSQL.Append("ON A.SEQ_NO = B.SEQ_NO ");
            strSQL.Append(") T WHERE 1=1 ");
            strSQL.Append("AND T.RET_CHANNEL = 'D4000' ");//审批通过
            if (strFlag.Length > 0)
                strSQL.Append("AND T.CHECK_STEP = '3' ");//学院已核对完毕
            strSQL.Append(strWhere);//查询条件
            //用户过滤
            strSQL.Append(cod.GetDataFilterString(true, "STU_NUMBER", "CLASS_CODE", "XY"));
            strSQL.Append(") TT");
            int nCount = cod.ChangeInt(ds.ExecuteTxtScalar(strSQL.ToString()).ToString());
            return nCount;
        }

        #endregion 通过条件查询总数
    }
}