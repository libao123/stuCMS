using System;
using System.Collections;
using System.Text;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using HQ.WebForm.Kernel;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Statistics
{
    public partial class StuInfo : Main
    {
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public int grade = 0;
        private comdata cod = new comdata();
        private datatables tables = new datatables();
        private ComTranClass comTran = new ComTranClass();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Post("EDULENTH")))
                grade = comTran.ToInt(Post("EDULENTH"));
            else
                grade = comTran.ToInt(sch_info.CURRENT_YEAR);

            string optype = Request.QueryString["optype"];
            if (!string.IsNullOrEmpty(optype))
            {
                switch (optype.ToLower().Trim())
                {
                    case "getlist":
                        Response.Write(GetList());
                        Response.End();
                        break;

                    case "getcols":
                        Response.Write(GetDataColumns());
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
            ddl.Add("STUTYPE", "ddl_basic_stu_type");

            strWhere += cod.GetDataFilterString(true, "NUMBER", "CLASS", "COLLEGE");
            strWhere = GetSearchWhere(strWhere);

            sbSql.Append("SELECT ROW_NUMBER() OVER(ORDER BY XY_NAME, STUTYPE) RN, *, (NUM1 + NUM2 + NUM3 + NUM4) TOTAL_NUM ");
            sbSql.Append("FROM (SELECT COLLEGE, (CASE WHEN GROUPING(COLLEGE) = 1 THEN '全校' ELSE COLLEGE END) XY_NAME, STUTYPE, ");
            sbSql.AppendFormat("SUM(CASE WHEN EDULENTH = '{0}' THEN 1 ELSE 0 END) NUM1, ", grade);
            sbSql.AppendFormat("SUM(CASE WHEN EDULENTH = '{0}' THEN 1 ELSE 0 END) NUM2, ", grade - 1);
            sbSql.AppendFormat("SUM(CASE WHEN EDULENTH = '{0}' THEN 1 ELSE 0 END) NUM3, ", grade - 2);
            sbSql.AppendFormat("SUM(CASE WHEN EDULENTH = '{0}' THEN 1 ELSE 0 END) NUM4 ", grade - 3);
            sbSql.Append("FROM BASIC_STU_INFO ");
            sbSql.AppendFormat("WHERE 1 = 1 {0} ", strWhere);
            sbSql.Append("GROUP BY COLLEGE, STUTYPE WITH ROLLUP HAVING GROUPING(STUTYPE) = 0 OR GROUPING(COLLEGE) = 1) T ");

            return tables.GetCmdQueryData(sbSql.ToString(), ddl);
        }

        private string GetSearchWhere(string where)
        {
            if (!string.IsNullOrEmpty(Post("COLLEGE")))
                where += string.Format(" AND COLLEGE = '{0}'", Post("COLLEGE"));
            if (!string.IsNullOrEmpty(Post("STUTYPE")))
                where += string.Format(" AND STUTYPE = '{0}'", Post("STUTYPE"));

            return where;
        }

        private string GetDataColumns()
        {
            grade = comTran.ToInt(Get("grade"));
            string columns = string.Empty;
            columns += "XY_NAME,学院,td-keep;";
            columns += "STUTYPE,学生类型,td-keep;";
            columns += string.Format("NUM1,{0}级,td-keep;", grade);
            columns += string.Format("NUM1,{0}级,td-keep;", grade - 1);
            columns += string.Format("NUM1,{0}级,td-keep;", grade - 2);
            columns += string.Format("NUM1,{0}级,td-keep;", grade - 3);
            columns += "TOTAL_NUM,总人数,td-keep";

            return columns;
        }

        public string GetGrade(int i)
        {
            string strGrade = string.Empty;
            if (!string.IsNullOrEmpty(Post("EDULENTH")))
                grade = comTran.ToInt(Post("EDULENTH"));
            else
                grade = comTran.ToInt(sch_info.CURRENT_YEAR);

            strGrade = (grade - i).ToString();

            return strGrade;
        }
    }
}