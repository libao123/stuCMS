using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Loan.ProjectSet
{
    public partial class List : ListBaseLoad<Loan_project_head>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        public override string Doc_type { get { return CValue.DOC_TYPE_LOA01; } }

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

        protected override SelectTransaction<Loan_project_head> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Loan_project_head>("Loan_project_headSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("LOAN_TYPE")))
                where += string.Format(" AND LOAN_TYPE = '{0}' ", Post("LOAN_TYPE"));
            if (!string.IsNullOrEmpty(Post("LOAN_YEAR")))
                where += string.Format(" AND LOAN_YEAR = '{0}' ", Post("LOAN_YEAR"));
            if (!string.IsNullOrEmpty(Post("LOAN_NAME")))
                where += string.Format(" AND LOAN_NAME LIKE '%{0}%' ", Post("LOAN_NAME"));
            return where;
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

                        case "delete"://删除操作
                            Response.Write(DeleteData());
                            Response.End();
                            break;

                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Loan_project_head entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "LOAN_NAME", Value = entity.LOAN_NAME };
            yield return new NameValue() { Name = "LOAN_INFO", Value = entity.LOAN_INFO };
            yield return new NameValue() { Name = "LOAN_TYPE", Value = entity.LOAN_TYPE };
            yield return new NameValue() { Name = "LOAN_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_loan_type", entity.LOAN_TYPE) };
            yield return new NameValue() { Name = "LOAN_YEAR", Value = entity.LOAN_YEAR };
            yield return new NameValue() { Name = "LOAN_YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.LOAN_YEAR) };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            //贷款信息核对
            yield return new NameValue() { Name = "CHECK_START", Value = entity.CHECK_START };
            yield return new NameValue() { Name = "CHECK_END", Value = entity.CHECK_END };
            yield return new NameValue() { Name = "CHECK_IS_SEND", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.CHECK_IS_SEND) };
            yield return new NameValue() { Name = "CHECK_MSG_ID", Value = entity.CHECK_MSG_ID };
            yield return new NameValue() { Name = "CHECK_OP_CODE", Value = entity.CHECK_OP_CODE };
            yield return new NameValue() { Name = "CHECK_OP_NAME", Value = entity.CHECK_OP_NAME };
            yield return new NameValue() { Name = "CHECK_OP_TIME", Value = entity.CHECK_OP_TIME };
            yield return new NameValue() { Name = "CHECK_NOTICE_ID", Value = entity.CHECK_NOTICE_ID };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除主表数据并且把子表数据也删除
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            var code = Get("id");
            if (string.IsNullOrEmpty(code)) return "主键为空,不允许删除操作";

            var model = new Loan_project_head();
            model.OID = code;
            ds.RetrieveObject(model);

            var transaction = ImplementFactory.GetDeleteTransaction<Loan_project_head>("Loan_project_headDeleteTransaction");
            transaction.EntityList.Add(model);
            if (!transaction.Commit())
                return "删除失败";
            return "";
        }

        #endregion 删除数据

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                Loan_project_head head = new Loan_project_head();
                if (string.IsNullOrEmpty(Post("OID")))
                {
                    head.OID = Guid.NewGuid().ToString();
                    head.SEQ_NO = GetSeq_no();
                    ds.RetrieveObject(head);
                    head.LOAN_NAME = Post("LOAN_NAME").Trim();
                    head.LOAN_INFO = Post("LOAN_INFO");
                    head.LOAN_YEAR = Post("LOAN_YEAR");
                    head.LOAN_TYPE = Post("LOAN_TYPE");
                    head.OP_CODE = user.User_Id;
                    head.OP_NAME = user.User_Name;
                    head.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    ds.UpdateObject(head);
                }
                else
                {
                    head.OID = Post("OID");
                    ds.RetrieveObject(head);
                    head.LOAN_NAME = Post("LOAN_NAME").Trim();
                    head.LOAN_INFO = Post("LOAN_INFO");
                    head.LOAN_YEAR = Post("LOAN_YEAR");
                    head.LOAN_TYPE = Post("LOAN_TYPE");
                    head.OP_CODE = user.User_Id;
                    head.OP_NAME = user.User_Name;
                    head.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    ds.UpdateObject(head);
                    LoanHandleClass.getInstance().UpdateRelationFunction(head.SEQ_NO);
                }
                return head.OID;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "贷款项目保存，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据
    }
}