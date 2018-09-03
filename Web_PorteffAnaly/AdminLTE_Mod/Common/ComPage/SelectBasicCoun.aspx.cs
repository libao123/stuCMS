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

namespace PorteffAnaly.Web.AdminLTE_Mod.Common.ComPage
{
    public partial class SelectBasicCoun : ListBaseLoad<Basic_coun_info>
    {
        #region 初始化

        public comdata cod = new comdata();

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
            //公共选择页不进行过滤，执行通过需要进行过滤
            get { return false; }
        }

        protected override SelectTransaction<Basic_coun_info> GetSelectTransaction()
        {
            if (!string.IsNullOrEmpty(Request.QueryString["filter"]))
            {
                switch (Request.QueryString["filter"].ToString())
                {
                    default:
                        break;
                }
            }
            return ImplementFactory.GetSelectTransaction<Basic_coun_info>("Basic_coun_infoSelectTransaction", param);
        }

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
                    }
                }
            }
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("ENO")))
                where += string.Format(" AND ENO LIKE '%{0}%' ", Post("ENO"));
            if (!string.IsNullOrEmpty(Post("NAME")))
                where += string.Format(" AND NAME LIKE '%{0}%' ", Post("NAME"));
            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Basic_coun_info>.NameValue> GetValue(Basic_coun_info entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "ENO", Value = entity.ENO };
            yield return new NameValue() { Name = "NAME", Value = entity.NAME };
            yield return new NameValue() { Name = "DEPARTMENT", Value = entity.DEPARTMENT };
            yield return new NameValue() { Name = "SEX", Value = cod.GetDDLTextByValue("ddl_xb", entity.SEX) };
            yield return new NameValue() { Name = "GARDE", Value = entity.GARDE };
            yield return new NameValue() { Name = "IDCARDNO", Value = entity.IDCARDNO };
            yield return new NameValue() { Name = "COLLEGE", Value = entity.COLLEGE.ToString() };
            yield return new NameValue() { Name = "MAJOR", Value = entity.MAJOR.ToString() };
            yield return new NameValue() { Name = "NATION", Value = cod.GetDDLTextByValue("ddl_gj", entity.NATION.ToString()) };
            yield return new NameValue() { Name = "MOBILENUM", Value = entity.MOBILENUM.ToString() };
            yield return new NameValue() { Name = "POLISTATUS", Value = cod.GetDDLTextByValue("ddl_zzmm", entity.POLISTATUS.ToString()) };
        }

        #endregion 输出列表信息
    }
}