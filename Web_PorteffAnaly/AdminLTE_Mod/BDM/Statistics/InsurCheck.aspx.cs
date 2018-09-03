using System;
using System.Collections;
using System.Text;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using HQ.WebForm.Kernel;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Statistics
{
    public partial class InsurCheck : Main
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
            StringBuilder sbSql = new StringBuilder();
            string strWhere = string.Empty;
            var ddl = new Hashtable();
            ddl.Add("XY_NAME", "ddl_department");

            strWhere += cod.GetDataFilterString(true, "A.STU_NUMBER", "A.CLASS_CODE", "A.XY");
            strWhere = GetSearchWhere(strWhere);

            sbSql.Append("SELECT ROW_NUMBER() OVER(ORDER BY XY_NAME, INSUR_NAME) RN, * ");
            sbSql.Append("FROM (SELECT A.XY, (CASE WHEN GROUPING(A.XY) = 1 THEN '全校' ELSE A.XY END) XY_NAME, A.INSUR_NAME, ");
            sbSql.Append("SUM(CASE WHEN CHECK_STEP = '2' THEN 1 ELSE 0 END) Y_NUM, ");
            sbSql.Append("SUM(CASE WHEN CHECK_STEP = '1' THEN 1 ELSE 0 END) F_NUM, ");
            sbSql.Append("SUM(CASE WHEN (CHECK_STEP = 'N' OR CHECK_STEP = '' OR CHECK_STEP IS NULL) THEN 1 ELSE 0 END) S_NUM, ");
            sbSql.Append("COUNT(1) PASS_NUM, SUM(CASE WHEN CHECK_STEP != '3' THEN 1 ELSE 0 END) REMAIN_NUM ");
            sbSql.Append("FROM INSUR_PROJECT_APPLY A INNER JOIN INSUR_APPLY_CHECK B ON A.SEQ_NO = B.SEQ_NO ");
            sbSql.AppendFormat("WHERE RET_CHANNEL = 'D4000' {0} ", strWhere);
            sbSql.Append("GROUP BY A.XY, A.INSUR_NAME WITH ROLLUP HAVING GROUPING(A.INSUR_NAME) = 0 OR GROUPING(A.XY) = 1) T ");

            return tables.GetCmdQueryData(sbSql.ToString(), ddl);
        }

        private string GetSearchWhere(string where)
        {
            if (!string.IsNullOrEmpty(Post("INSUR_YEAR")))
                where += string.Format(" AND A.INSUR_YEAR = '{0}'", Post("INSUR_YEAR"));
            if (!string.IsNullOrEmpty(Post("INSUR_SEQ_NO")))
                where += string.Format(" AND A.INSUR_SEQ_NO = '{0}'", Post("INSUR_SEQ_NO"));
            if (!string.IsNullOrEmpty(Post("STU_TYPE")))
                where += string.Format(" AND A.STU_TYPE = '{0}'", Post("STU_TYPE"));
            if (!string.IsNullOrEmpty(Post("XY")))
                where += string.Format(" AND A.XY = '{0}'", Post("XY"));

            return where;
        }
    }
}