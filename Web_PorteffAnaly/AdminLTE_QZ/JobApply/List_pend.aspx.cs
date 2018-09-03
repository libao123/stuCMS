using System;
using System.Collections.Generic;
using System.Data;
using AdminLTE_Mod.Common;
using HQ.WebForm;
using HQ.Utility;
using HQ.Model;
using HQ.InterfaceService;
using HQ.Architecture.Strategy;
using HQ.Architecture.Factory;

namespace PorteffAnaly.Web.AdminLTE_QZ.JobApply
{
    public partial class List_pend : ListBaseLoad<Qz_job_apply_head>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Qz_job_apply_head head = new Qz_job_apply_head();
        public string m_strIsShowEditBtn = "false";//是否显示增删改提交按钮：显示true 不显示false
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public ComHandleClass comHandle = new ComHandleClass();
        private ComTranClass comTran = new ComTranClass();

        public override string Doc_type { get { return CValue.DOC_TYPE_JOB02; } }

        #endregion 初始化

        #region 辅助页面加载

        protected override string input_code_column
        {
            get { return "STU_NUMBER"; }
        }

        protected override string class_code_column
        {
            get { return "CLASS_CODE"; }
        }

        protected override string xy_code_column
        {
            get { return "COLLEGE"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Qz_job_apply_head> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Qz_job_apply_head>("Qz_job_apply_headSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("COLLEGE")))
                where += string.Format(" AND COLLEGE = '{0}' ", Post("COLLEGE"));
            if (!string.IsNullOrEmpty(Post("MAJOR")))
                where += string.Format(" AND MAJOR = '{0}' ", Post("MAJOR"));
            if (!string.IsNullOrEmpty(Post("STU_NUMBER")))
                where += string.Format(" AND STU_NUMBER LIKE '%{0}%' ", Post("STU_NUMBER"));
            if (!string.IsNullOrEmpty(Post("STU_NAME")))
                where += string.Format(" AND STU_NAME LIKE '%{0}%' ", Post("STU_NAME"));
            where += " AND " + DataFilterHandleClass.getInstance().Pend_DataFilter(user.User_Role, Doc_type);
            return where;
        }

        #endregion 辅助页面加载

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

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Qz_job_apply_head entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "DOC_TYPE", Value = entity.DOC_TYPE };
            yield return new NameValue() { Name = "DECLARE_TYPE", Value = entity.DECLARE_TYPE };
            yield return new NameValue() { Name = "DECL_TIME", Value = entity.DECL_TIME };
            yield return new NameValue() { Name = "CHK_TIME", Value = entity.CHK_TIME };
            yield return new NameValue() { Name = "CHK_STATUS", Value = entity.CHK_STATUS };
            yield return new NameValue() { Name = "STEP_NO", Value = entity.STEP_NO };
            yield return new NameValue() { Name = "RET_CHANNEL", Value = entity.RET_CHANNEL };
            yield return new NameValue() { Name = "POS_CODE", Value = entity.POS_CODE };
            yield return new NameValue() { Name = "AUDIT_POS_CODE", Value = entity.AUDIT_POS_CODE };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "STU_NUMBER", Value = entity.STU_NUMBER };
            yield return new NameValue() { Name = "STU_NAME", Value = entity.STU_NAME };
            yield return new NameValue() { Name = "SEX", Value = entity.SEX };
            yield return new NameValue() { Name = "NATION", Value = entity.NATION };
            yield return new NameValue() { Name = "POLISTATUS", Value = entity.POLISTATUS };
            yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
            yield return new NameValue() { Name = "COLLEGE", Value = entity.COLLEGE };
            yield return new NameValue() { Name = "MAJOR", Value = entity.MAJOR };
            yield return new NameValue() { Name = "IS_FAIL", Value = entity.IS_FAIL };
            yield return new NameValue() { Name = "EMPLOY_FLAG", Value = entity.EMPLOY_FLAG };
            yield return new NameValue() { Name = "SCH_YEAR", Value = entity.SCH_YEAR };
            yield return new NameValue() { Name = "SCH_TERM", Value = entity.SCH_TERM };
            yield return new NameValue() { Name = "EXPECT_JOB1", Value = entity.EXPECT_JOB1 };
            yield return new NameValue() { Name = "POS_CODE2", Value = cod.GetDDLTextByValue("ddl_ua_role", entity.POS_CODE) };
            yield return new NameValue() { Name = "GRADE2", Value = cod.GetDDLTextByValue("ddl_grade", entity.GRADE) };
            yield return new NameValue() { Name = "COLLEGE2", Value = cod.GetDDLTextByValue("ddl_department", entity.COLLEGE) };
            yield return new NameValue() { Name = "MAJOR2", Value = cod.GetDDLTextByValue("ddl_zy", entity.MAJOR) };
            yield return new NameValue() { Name = "CLASS2", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS_CODE) };
            yield return new NameValue() { Name = "IS_FAIL2", Value = cod.GetDDLTextByValue("ddl_study", entity.IS_FAIL) };
            yield return new NameValue() { Name = "EMPLOY_FLAG2", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.EMPLOY_FLAG) };
            yield return new NameValue() { Name = "SCH_YEAR2", Value = cod.GetDDLTextByValue("ddl_year_type", entity.SCH_YEAR) };
            yield return new NameValue() { Name = "SCH_TERM2", Value = cod.GetDDLTextByValue("ddl_xq", entity.SCH_TERM) };
            yield return new NameValue() { Name = "JOB_NAME", Value = cod.GetDDLTextByValue("ddl_job_name", entity.EXPECT_JOB1) };
            yield return new NameValue() { Name = "EMPLOYER", Value = entity.EMPLOYER };
            yield return new NameValue() { Name = "EMPLOYER2", Value = cod.GetDDLTextByValue("ddl_all_department", entity.EMPLOYER) };
        }

        #endregion 输出列表信息
    }
}