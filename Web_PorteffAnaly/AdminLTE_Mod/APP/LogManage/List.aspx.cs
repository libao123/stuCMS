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
using HQ.WebControl;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.APP.LogManage
{
    /// <summary>
    /// 操作日志
    /// </summary>
    public partial class List : ListBaseLoad<Log_sys_operation>
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
            if (!string.IsNullOrEmpty(Post("RECORD_TYPE")))
                where += string.Format(" AND RECORD_TYPE = '{0}' ", Post("RECORD_TYPE"));
            if (!string.IsNullOrEmpty(Post("ACTION_TYPE")))
                where += string.Format(" AND ACTION_TYPE = '{0}' ", Post("ACTION_TYPE"));
            if (!string.IsNullOrEmpty(Post("OP_CODE")))
                where += string.Format(" AND OP_CODE LIKE '%{0}%' ", Post("OP_CODE"));
            if (!string.IsNullOrEmpty(Post("OP_NAME")))
                where += string.Format(" AND OP_NAME LIKE '%{0}%' ", Post("OP_NAME"));
            if (!string.IsNullOrEmpty(Post("LOG_DATE")))
                where += string.Format(" AND LOG_DATE >= '{0}' ", Post("LOG_DATE"));
            if (!string.IsNullOrEmpty(Post("LOG_DATE2")))
                where += string.Format(" AND LOG_DATE <= '{0}' ", Post("LOG_DATE2"));
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

        protected override SelectTransaction<Log_sys_operation> GetSelectTransaction()
        {
            param.Add("RECORD_TYPE", "1");//显示应用操作日志
            return ImplementFactory.GetSelectTransaction<Log_sys_operation>("Log_sys_operationSelectTransaction", param);
        }

        #endregion 辅助页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Log_sys_operation>.NameValue> GetValue(Log_sys_operation entity)
        {
            {
                yield return new NameValue() { Name = "OID", Value = entity.OID };
                yield return new NameValue() { Name = "LOG_DATE", Value = entity.LOG_DATE.ToString() };
                yield return new NameValue() { Name = "LOG_MESSAGE", Value = entity.LOG_MESSAGE };
                yield return new NameValue() { Name = "IP", Value = entity.IP };
                yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
                yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
                yield return new NameValue() { Name = "RECORD_TYPE", Value = cod.GetDDLTextByValue("ddl_log_record_type", entity.RECORD_TYPE) };
                yield return new NameValue() { Name = "ACTION_TYPE", Value = cod.GetDDLTextByValue("ddl_log_action_type", entity.ACTION_TYPE) };
                yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
                yield return new NameValue() { Name = "MODEL", Value = entity.MODEL };
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
                Dictionary<string, string> param = new Dictionary<string, string>{
				{string.Format(" LOG_DATE BETWEEN '{0} 00:00:00,000' AND '{1} 23:59:59,999'", fromDATE, toDATE), ""} };//筛选出数据的SQL。
                var selecttrcn = ImplementFactory.GetSelectTransaction<Log_sys_operation>("Log_sys_operationSelectTransaction", param);
                var list = selecttrcn.SelectAll();

                var deletetrcn = ImplementFactory.GetDeleteTransaction<Log_sys_operation>("Log_sys_operationDeleteTransaction");
                for (int i = 0; i < list.Count; i++)
                {
                    deletetrcn.EntityList.Add(new Log_sys_operation()
                    {
                        OID = list[i].OID//获取筛选出的数据的OID，并添加到删除事务里。
                    });
                }

                if (list.Count > 0 && deletetrcn.Commit())
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