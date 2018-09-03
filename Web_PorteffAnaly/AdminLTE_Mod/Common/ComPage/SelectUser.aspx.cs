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
    public partial class SelectUser : ListBaseLoad<Ua_user>
    {
        #region 初始化

        private comdata cod = new comdata();

        protected override string input_code_column
        {
            get { return ""; }
        }

        protected override string class_code_column
        {
            get
            {
                return "";
            }
        }

        protected override string xy_code_column
        {
            get { return ""; }
        }

        protected override bool is_do_filter
        {
            get
            {
                return false;
            }
        }

        protected override SelectTransaction<Ua_user> GetSelectTransaction()
        {
            //目前暂时不过滤
            return ImplementFactory.GetSelectTransaction<Ua_user>("Ua_userSelectTransaction", param);
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
            if (!string.IsNullOrEmpty(Post("USER_ID")))
                where += string.Format(" AND USER_ID LIKE '%{0}%' ", Post("USER_ID"));
            if (!string.IsNullOrEmpty(Post("USER_NAME")))
                where += string.Format(" AND USER_NAME LIKE '%{0}%' ", Post("USER_NAME"));
            if (!string.IsNullOrEmpty(Post("USER_TYPE")))
                where += string.Format(" AND USER_TYPE = '{0}' ", Post("USER_TYPE"));
            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Ua_user>.NameValue> GetValue(Ua_user entity)
        {
            yield return new NameValue() { Name = "USER_ID", Value = entity.USER_ID };
            yield return new NameValue() { Name = "USER_NAME", Value = entity.USER_NAME };
            yield return new NameValue() { Name = "USER_TYPE", Value = entity.USER_TYPE };
            yield return new NameValue() { Name = "USER_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_user_type", entity.USER_TYPE) };
            yield return new NameValue() { Name = "XY_CODE", Value = entity.XY_CODE };
            yield return new NameValue() { Name = "XY_CODE_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.XY_CODE) };
        }

        #endregion 输出列表信息
    }
}