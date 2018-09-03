using System;
using System.Collections;
using System.Text;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using HQ.WebForm.Kernel;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Statistics
{
    public partial class SchoolarApprove : Main
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
            string strDeclType = string.Empty;
            var ddl = new Hashtable();

            strWhere += cod.GetDataFilterString(true, "A.STU_NUMBER", "A.CLASS_CODE", "A.XY");
            strWhere = GetSearchWhere(strWhere);

            if (!string.IsNullOrEmpty(Post("DECLARE_TYPE")))
                strDeclType = string.Format("AND A.DECLARE_TYPE = '{0}'", Post("DECLARE_TYPE"));

            sbSql.Append("SELECT ROW_NUMBER() OVER(ORDER BY XY_NAME, PROJECT_NAME) RN, *, (F_NUM + Y_NUM + X_NUM) PEND_NUM, ");
            sbSql.Append("(CASE WHEN APPLY_NUM = '不限定' THEN APPLY_NUM ELSE CAST((APPLY_NUM - PASS_NUM) AS varchar(10)) END) REMAIN_NUM ");
            sbSql.Append("FROM (SELECT A.XY, (CASE WHEN GROUPING(A.XY) = 1 THEN '全校' ELSE A.XY END) XY_NAME, A.PROJECT_NAME, ");
            sbSql.AppendFormat("COUNT(CASE WHEN A.POS_CODE = 'F' {0} THEN A.STU_NUMBER ELSE NULL END) F_NUM, ", strDeclType);
            sbSql.AppendFormat("COUNT(CASE WHEN A.POS_CODE = 'Y' {0} THEN A.STU_NUMBER ELSE NULL END) Y_NUM, ", strDeclType);
            sbSql.AppendFormat("COUNT(CASE WHEN A.POS_CODE = 'X' {0} THEN A.STU_NUMBER ELSE NULL END) X_NUM, ", strDeclType);
            sbSql.Append("COUNT(CASE WHEN A.RET_CHANNEL = 'D4000' THEN A.STU_NUMBER ELSE NULL END) PASS_NUM, ");
            sbSql.Append("(CASE WHEN C.APPLY_NUM IS NULL THEN '不限定' ELSE CAST(C.APPLY_NUM AS varchar(10)) END) APPLY_NUM, ");
            sbSql.Append("COUNT(DISTINCT D.NUMBER) DST_NUM ");
            sbSql.Append("FROM SHOOLAR_APPLY_HEAD A LEFT JOIN SHOOLAR_PROJECT_HEAD B ON A.PROJECT_SEQ_NO = B.SEQ_NO ");
            sbSql.Append("LEFT JOIN SHOOLAR_PROJECT_NUM C ON A.XY = C.XY AND B.SEQ_NO = C.SEQ_NO ");
            sbSql.Append("LEFT JOIN (SELECT * FROM DST_STU_APPLY WHERE RET_CHANNEL = 'D4000' AND LEVEL_CODE IN ('A', 'B', 'C')) D ON D.NUMBER = A.STU_NUMBER  AND D.SCHYEAR = A.PROJECT_YEAR ");
            sbSql.AppendFormat("WHERE 1 = 1 {0} ", strWhere);
            sbSql.Append("GROUP BY A.XY, A.PROJECT_NAME, C.APPLY_NUM ");
            sbSql.Append("WITH ROLLUP HAVING GROUPING(C.APPLY_NUM) = 0 OR GROUPING(A.XY) = 1) T ");

            ddl.Add("XY_NAME", "ddl_department");

            return tables.GetCmdQueryData(sbSql.ToString(), ddl);
        }

        private string GetSearchWhere(string where)
        {
            if (!string.IsNullOrEmpty(Post("PROJECT_YEAR")))
                where += string.Format(" AND A.PROJECT_YEAR = '{0}'", Post("PROJECT_YEAR"));
            if (!string.IsNullOrEmpty(Post("PROJECT_SEQ_NO")))
                where += string.Format(" AND A.PROJECT_SEQ_NO = '{0}'", Post("PROJECT_SEQ_NO"));
            if (!string.IsNullOrEmpty(Post("PROJECT_CLASS")))
                where += string.Format(" AND A.PROJECT_CLASS = '{0}'", Post("PROJECT_CLASS"));
            if (!string.IsNullOrEmpty(Post("PROJECT_TYPE")))
                where += string.Format(" AND A.PROJECT_TYPE = '{0}'", Post("PROJECT_TYPE"));
            if (!string.IsNullOrEmpty(Post("XY")))
                where += string.Format(" AND A.XY = '{0}'", Post("XY"));

            return where;
        }
    }
}