using System;
using System.Collections;
using System.Text;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using HQ.WebForm.Kernel;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Statistics
{
    public partial class DstSurvey : Main
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

            strWhere += cod.GetDataFilterString(true, "A.NUMBER", "A.CLASS", "A.COLLEGE");
            strWhere = GetSearchWhere(strWhere);

            sbSql.Append("SELECT ROW_NUMBER() OVER(ORDER BY XY_NAME) RN, *, (TOTAL_NUM - DECL_NUM) UN_DECL_NUM FROM (");
            sbSql.Append("SELECT A.COLLEGE, (CASE WHEN GROUPING(A.COLLEGE) = 1 THEN '全校' ELSE A.COLLEGE END) XY_NAME, ");
            sbSql.Append("COUNT(1) TOTAL_NUM, SUM(CASE WHEN B.RET_CHANNEL = 'A0010' THEN 1 ELSE 0 END) DECL_NUM ");
            sbSql.Append("FROM BASIC_STU_INFO A LEFT JOIN DST_FAMILY_SITUA B ON A.NUMBER = B.NUMBER ");
            sbSql.AppendFormat("WHERE A.STUTYPE = 'B' {0} ", strWhere);
            sbSql.Append("GROUP BY A.COLLEGE WITH ROLLUP) T ");

            ddl.Add("XY_NAME", "ddl_department");

            return tables.GetCmdQueryData(sbSql.ToString(), ddl);
        }

        private string GetSearchWhere(string where)
        {
            if (!string.IsNullOrEmpty(Post("EDULENTH")))
                where += string.Format(" AND A.EDULENTH = '{0}'", Post("EDULENTH"));

            return where;
        }
    }
}