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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Revoke
{
    public partial class List : ListBaseLoad<Wkf_revoke_log>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Wkf_revoke_log head = new Wkf_revoke_log();

        #endregion 初始化

        #region 辅助页面加载

        protected override string input_code_column
        {
            get { return "CREATE_USER"; }
        }

        protected override string class_code_column
        {
            get { return "CLASS"; }
        }

        protected override string xy_code_column
        {
            get { return "COLLEGE"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Wkf_revoke_log> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Wkf_revoke_log>("Wkf_revoke_logSelectTransaction", param);
        }

        #endregion 辅助页面加载

        #region 窗体加载

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
            if (!string.IsNullOrEmpty(Post("DOC_TYPE")))
                where += string.Format(" AND DOC_TYPE = '{0}' ", Post("DOC_TYPE"));
            if (!string.IsNullOrEmpty(Post("COLLEGE")))
                where += string.Format(" AND COLLEGE = '{0}' ", Post("COLLEGE"));
            if (!string.IsNullOrEmpty(Post("MAJOR")))
                where += string.Format(" AND MAJOR = '{0}' ", Post("MAJOR"));
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("CLASS")))
                where += string.Format(" AND CLASS = '{0}' ", Post("CLASS"));
            if (!string.IsNullOrEmpty(Post("CREATE_TIME")))
                where += string.Format(" AND CREATE_TIME >= '{0}' ", Post("CREATE_TIME"));
            if (!string.IsNullOrEmpty(Post("CREATE_TIME2")))
                where += string.Format(" AND CREATE_TIME <= '{0}' ", Post("CREATE_TIME2"));
            return where;
        }

        #endregion 窗体加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Wkf_revoke_log>.NameValue> GetValue(Wkf_revoke_log entity)
        {
            {
                yield return new NameValue() { Name = "OID", Value = entity.OID };
                yield return new NameValue() { Name = "DOC_TYPE", Value = cod.GetDDLTextByValue("ddl_doc_type", entity.DOC_TYPE) };
                yield return new NameValue() { Name = "DOC_NO", Value = entity.DOC_NO };
                yield return new NameValue() { Name = "CURR_STEP_NO", Value = cod.GetDDLTextByValue("ddl_STEP_NO", entity.CURR_STEP_NO) };
                yield return new NameValue() { Name = "CURR_RET_CHANNEL", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.CURR_RET_CHANNEL) };
                yield return new NameValue() { Name = "CURR_POST_CODE", Value = cod.GetDDLTextByValue("ddl_ua_role", entity.CURR_POST_CODE) };
                yield return new NameValue() { Name = "RE_STEP_NO", Value = cod.GetDDLTextByValue("ddl_STEP_NO", entity.RE_STEP_NO) };
                yield return new NameValue() { Name = "RE_RET_CHANNEL", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.RE_RET_CHANNEL) };
                yield return new NameValue() { Name = "RE_POST_CODE", Value = cod.GetDDLTextByValue("ddl_ua_role", entity.RE_POST_CODE) };
                yield return new NameValue() { Name = "CREATE_USER", Value = entity.CREATE_USER };
                yield return new NameValue() { Name = "CREATE_TIME", Value = entity.CREATE_TIME };
                yield return new NameValue() { Name = "GRADE", Value = cod.GetDDLTextByValue("ddl_grade", entity.GRADE) };
                yield return new NameValue() { Name = "COLLEGE", Value = cod.GetDDLTextByValue("ddl_department", entity.COLLEGE) };
                yield return new NameValue() { Name = "MAJOR", Value = cod.GetDDLTextByValue("ddl_zy", entity.MAJOR) };
                yield return new NameValue() { Name = "CLASS", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS) };
                yield return new NameValue() { Name = "CREATE_USER_NAME", Value = entity.CREATE_USER_NAME };
                yield return new NameValue() { Name = "REVOKE_REASON", Value = entity.REVOKE_REASON };
            }
        }

        #endregion 输出列表信息
    }
}