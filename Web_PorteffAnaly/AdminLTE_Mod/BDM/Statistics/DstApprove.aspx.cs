using System;
using System.Collections;
using System.Text;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using HQ.WebForm.Kernel;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Statistics
{
    public partial class DstApprove : Main
    {
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        private comdata cod = new comdata();
        private datatables tables = new datatables();

        protected void Page_Load(object sender, EventArgs e)
        {
            string optype = Request.QueryString["optype"];
            if (!string.IsNullOrEmpty(optype))
            {
                switch (optype.ToLower().Trim())
                {
                    case "getlist":
                        Response.Write(GetList());
                        Response.End();
                        break;
                }
            }
        }

        private string GetList()
        {
            var ddl = new Hashtable();
            StringBuilder sbSql = new StringBuilder();
            string strWhere = string.Empty;
            string strDstSql = string.Empty;
            string strSchSql = string.Empty;
            string strFilter = cod.GetDataFilterString(true, "A.NUMBER", "A.CLASS", "A.COLLEGE");
            strFilter = GetFilterWhere(strFilter);

            strDstSql = string.Format("SELECT DISTINCT SCHYEAR,NUMBER,DECLARE_TYPE,LEVEL_CODE,RET_CHANNEL FROM DST_STU_APPLY WHERE 1 = 1 {0}", GetSearchWhere());
            strSchSql = string.Format("SELECT * FROM SHOOLAR_APPLY_HEAD WHERE RET_CHANNEL = 'D4000'");

            sbSql.Append("SELECT ROW_NUMBER() OVER(ORDER BY XY_NAME) RN, *, ");
            sbSql.Append("(TOTAL_NUM - DECL_NUM) UN_DECL_NUM, (A_NUM + B_NUM + C_NUM) PASS_NUM, ");
            sbSql.Append("(DECL_NUM - A_NUM - B_NUM - C_NUM - D_NUM) NOT_PASS_NUM ");
            sbSql.Append("FROM (SELECT A.COLLEGE, (CASE WHEN GROUPING(A.COLLEGE) = 1 THEN '全校' ELSE A.COLLEGE END) XY_NAME, ");
            sbSql.Append("COUNT(A.NUMBER) TOTAL_NUM, COUNT(DISTINCT C.STU_NUMBER) FUND_NUM, ");
            sbSql.Append("COUNT(CASE WHEN (B.RET_CHANNEL IS NOT NULL AND B.RET_CHANNEL != '' AND B.RET_CHANNEL != 'A0000') THEN B.NUMBER ELSE NULL END) DECL_NUM, ");
            sbSql.Append("COUNT(CASE WHEN B.LEVEL_CODE = 'A' AND B.DECLARE_TYPE = 'D' THEN B.NUMBER ELSE NULL END) A_NUM, ");
            sbSql.Append("COUNT(CASE WHEN B.LEVEL_CODE = 'B' AND B.DECLARE_TYPE = 'D' THEN B.NUMBER ELSE NULL END) B_NUM, ");
            sbSql.Append("COUNT(CASE WHEN B.LEVEL_CODE = 'C' AND B.DECLARE_TYPE = 'D' THEN B.NUMBER ELSE NULL END) C_NUM, ");
            sbSql.Append("COUNT(CASE WHEN B.LEVEL_CODE = 'D' AND B.DECLARE_TYPE = 'D' THEN B.NUMBER ELSE NULL END) D_NUM ");
            sbSql.AppendFormat("FROM BASIC_STU_INFO A LEFT JOIN ({0}) B ON A.NUMBER = B.NUMBER ", strDstSql);
            sbSql.AppendFormat("LEFT JOIN ({0}) C ON B.NUMBER = C.STU_NUMBER AND B.SCHYEAR = C.PROJECT_YEAR ", strSchSql);
            sbSql.AppendFormat("WHERE A.STUTYPE = 'B' {0} ", strFilter);
            sbSql.Append("GROUP BY A.COLLEGE WITH ROLLUP) T ");

            ddl.Add("XY_NAME", "ddl_department");

            return tables.GetCmdQueryData(sbSql.ToString(), ddl);
        }

        private string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("SCHYEAR")))
                where += string.Format(" AND SCHYEAR = '{0}'", Post("SCHYEAR"));

            return where;
        }

        private string GetFilterWhere(string where)
        {
            if (!string.IsNullOrEmpty(Post("COLLEGE")))
                where += string.Format(" AND A.COLLEGE = '{0}'", Post("COLLEGE"));

            return where;
        }
    }
}