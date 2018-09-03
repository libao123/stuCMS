using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.APP.DataBaseControl.SqlSearch
{
    public partial class List : Main
    {
        #region 页面加载

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "check":
                            Response.Write(CheckSql());
                            Response.End();
                            break;
                        case "column":
                            Response.Write(GetColumnsByDataTable());
                            Response.End();
                            break;
                        case "search":
                            Response.Write(SearchSql());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 检查SQL语句是否有误

        /// <summary>
        /// 检查SQL语句是否有误
        /// </summary>
        /// <returns></returns>
        private string CheckSql()
        {
            string sql_txt = Get("sql_txt").Trim();
            if (sql_txt.Length < 6)
                return "SQL有误！";
            if (!sql_txt.ToUpper().StartsWith("SELECT"))
                return "SQL有误！";
            if (!ValidateSql(sql_txt))
                return "SQL有误！";
            return string.Empty;
        }

        #endregion 检查SQL语句是否有误

        #region 根据datatable获得列名

        /// <summary>
        /// 根据datatable获得列名
        /// </summary>
        /// <param name="dt">表对象</param>
        /// <returns>返回结果的数据列数组</returns>
        private string GetColumnsByDataTable()
        {
            string sql_txt = Get("sql_txt").Trim();
            DataTable dt = ds.ExecuteTxtDataTable(sql_txt);
            if (dt == null)
                return "[]";

            StringBuilder strColumns = new StringBuilder();
            strColumns.Append("[");
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                strColumns.AppendFormat("{{\"data\":\"{0}\",\"head\": \"{0}\"}},", dt.Columns[i].ColumnName);
            }
            if (strColumns[strColumns.Length - 1].Equals(','))
            {
                strColumns.Remove(strColumns.Length - 1, 1);//去掉最后一个逗号
            }
            strColumns.Append("]");
            return strColumns.ToString();
        }

        #endregion 根据datatable获得列名

        #region SQL语句查询结果

        /// <summary>
        /// SQL语句查询结果
        /// </summary>
        /// <returns></returns>
        private string SearchSql()
        {
            string sql_txt = Get("sql_txt").Trim();
            DataTable dt = ds.ExecuteTxtDataTable(sql_txt);
            return string.Format("{{\"draw\":{0},\"recordsTotal\":{1},\"recordsFiltered\":{2},\"data\":[{3}]}}", 1, dt == null ? 0 : Convert.ToInt32(dt.Rows.Count), dt.Rows.Count, Json.DatatableToJson(dt));
        }

        #endregion SQL语句查询结果
    }
}