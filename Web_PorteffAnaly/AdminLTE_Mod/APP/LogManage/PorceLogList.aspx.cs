using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.APP.LogManage
{
    /// <summary>
    /// 系统异常日志
    /// </summary>
    public partial class PorceLogList : ListBaseLoad<Log_sys_procedure>
    {
        #region 初始化

        private comdata cod = new comdata();

        #endregion 初始化

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
                        case "getlist":
                            Response.Write(GetList());
                            Response.End();
                            break;
                        case "del":
                            Response.Write(DeleteLog());
                            Response.End();
                            break;
                    }
                }
            }
        }

        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("LOG_TYPE")))
                where += string.Format(" AND LOG_TYPE = '{0}' ", Post("LOG_TYPE"));
            if (!string.IsNullOrEmpty(Post("LOG_MSG")))
                where += string.Format(" AND LOG_MSG like '%{0}%' ", Post("LOG_MSG"));
            if (!string.IsNullOrEmpty(Post("LOG_TIME")))
                where += string.Format(" AND LOG_TIME >= '{0}' ", Post("LOG_TIME"));
            if (!string.IsNullOrEmpty(Post("LOG_TIME2")))
                where += string.Format(" AND LOG_TIME <= '{0}' ", Post("LOG_TIME2"));
            return where;
        }

        #endregion 页面加载

        #region 辅助页面加载

        protected override string input_code_column
        {
            get { return ""; }
        }

        protected override string class_code_column
        {
            get { return ""; }
        }

        protected override string xy_code_column
        {
            get { return ""; }
        }

        protected override bool is_do_filter
        {
            get { return false; }
        }

        protected override SelectTransaction<Log_sys_procedure> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Log_sys_procedure>("Log_sys_procedureSelectTransaction", param);
        }

        #endregion 辅助页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Log_sys_procedure>.NameValue> GetValue(Log_sys_procedure entity)
        {
            {
                yield return new NameValue() { Name = "OID", Value = entity.OID };
                yield return new NameValue() { Name = "LOG_TYPE", Value = cod.GetDDLTextByValue("ddl_log_level", entity.LOG_TYPE) };
                yield return new NameValue() { Name = "LOG_MSG", Value = entity.LOG_MSG };
                yield return new NameValue() { Name = "LOG_TIME", Value = entity.LOG_TIME };
            }
        }

        #endregion 输出列表信息

        #region 删除日志

        private string DeleteLog()
        {
            try
            {
                string fromDATE = Post("Fromdate");//获取页面文本信息。
                string toDATE = Post("Todate");
                string strSQL = string.Format("DELETE FROM LOG_SYS_PROCEDURE WHERE LOG_TIME BETWEEN '{0} 00:00:00' AND '{1} 23:59:59' ", fromDATE, toDATE);
                int nCount = ds.ExecuteTxtNonQuery(strSQL);

                if (nCount >= 0)
                {
                    return "";
                }
                else
                {
                    return "删除不成功！";
                }
            }
            catch (Exception ex)
            {
                return string.Format("删除日志异常，原因：{0}", ex.Message);
            }
        }

        #endregion 删除日志
    }
}