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
using System.Collections;
using HQ.WebForm.Kernel;

namespace PorteffAnaly.Web.AdminLTE_QZ.JobProof
{
    public partial class List_proc : ListBaseLoad<Qz_job_proof_head>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Qz_job_proof_head head = new Qz_job_proof_head();
        public string m_strIsShowEditBtn = "false";//是否显示增删改提交按钮：显示true 不显示false
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public ComHandleClass comHandle = new ComHandleClass();
        private ComTranClass comTran = new ComTranClass();
        private datatables tables = new datatables();

        public override string Doc_type { get { return CValue.DOC_TYPE_JOB03; } }

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

        protected override SelectTransaction<Qz_job_proof_head> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Qz_job_proof_head>("Qz_job_proof_headSelectTransaction", param);
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
            if (!string.IsNullOrEmpty(Post("EMPLOYER")))
                where += string.Format(" AND EMPLOYER = '{0}' ", Post("EMPLOYER"));
            if (!string.IsNullOrEmpty(Post("JOB_SEQ_NO")))
                where += string.Format(" AND JOB_SEQ_NO = '{0}' ", Post("JOB_SEQ_NO"));
            if (!string.IsNullOrEmpty(Post("STU_NUMBER")))
                where += string.Format(" AND STU_NUMBER LIKE '%{0}%' ", Post("STU_NUMBER"));
            if (!string.IsNullOrEmpty(Post("STU_NAME")))
                where += string.Format(" AND STU_NAME LIKE '%{0}%' ", Post("STU_NAME"));
            where += " AND " + DataFilterHandleClass.getInstance().Proc_DataFilter(user.User_Role, Doc_type);
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
                        case "getdata":
                            Response.Write(GetData());
                            Response.End();
                            break;
                        case "getprooflist":
                            Response.Write(GetProofList());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Qz_job_proof_head entity)
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
            yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
            yield return new NameValue() { Name = "COLLEGE", Value = entity.COLLEGE };
            yield return new NameValue() { Name = "MAJOR", Value = entity.MAJOR };
            yield return new NameValue() { Name = "SCH_YEAR", Value = entity.SCH_YEAR };
            yield return new NameValue() { Name = "SCH_TERM", Value = entity.SCH_TERM };
            yield return new NameValue() { Name = "STU_TYPE", Value = entity.STU_TYPE };
            yield return new NameValue() { Name = "POS_CODE2", Value = cod.GetDDLTextByValue("ddl_ua_role", entity.POS_CODE) };
            yield return new NameValue() { Name = "GRADE2", Value = cod.GetDDLTextByValue("ddl_grade", entity.GRADE) };
            yield return new NameValue() { Name = "COLLEGE2", Value = cod.GetDDLTextByValue("ddl_department", entity.COLLEGE) };
            yield return new NameValue() { Name = "MAJOR2", Value = cod.GetDDLTextByValue("ddl_zy", entity.MAJOR) };
            yield return new NameValue() { Name = "CLASS2", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS_CODE) };
            yield return new NameValue() { Name = "EMPLOYER2", Value = cod.GetDDLTextByValue("ddl_all_department", entity.EMPLOYER) };
            yield return new NameValue() { Name = "JOB_NAME", Value = cod.GetDDLTextByValue("ddl_job_name", entity.JOB_SEQ_NO) };
            yield return new NameValue() { Name = "STU_TYPE2", Value = cod.GetDDLTextByValue("ddl_ua_stu_type", entity.STU_TYPE) };
            yield return new NameValue() { Name = "SCH_YEAR2", Value = cod.GetDDLTextByValue("ddl_year_type", entity.SCH_YEAR) };
            yield return new NameValue() { Name = "SCH_TERM2", Value = cod.GetDDLTextByValue("ddl_xq", entity.SCH_TERM) };
        }

        #endregion 输出列表信息

        #region 获取编辑页面Json

        private string GetData()
        {
            DataTable dt = null;
            if (string.IsNullOrEmpty(Get("id")))
            {
                dt = ds.ExecuteTxtDataTable(string.Format("SELECT NUMBER STU_NUMBER, NAME STU_NAME, SEX, NATION, POLISTATUS, EDULENTH GRADE, COLLEGE, MAJOR FROM BASIC_STU_INFO WHERE NUMBER = '{0}'", user.User_Id));
                if (dt == null || dt.Rows.Count == 0)
                    return "{}";
            }
            else
            {
                dt = ds.ExecuteTxtDataTable(string.Format("SELECT *, CMPL_STS CMPL_STS_TEXT FROM QZ_JOB_PROOF_HEAD WHERE OID = '{0}' ", Get("id")));
                if (dt == null || dt.Rows.Count == 0)
                    return "{}";
            }

            var ddl = new Hashtable();
            ddl.Add("EMPLOYER", "ddl_all_department");
            ddl.Add("JOB_SEQ_NO", "ddl_job_name");
            ddl.Add("SEX", "ddl_xb");
            ddl.Add("GRADE", "ddl_grade");
            ddl.Add("COLLEGE", "ddl_department");
            ddl.Add("MAJOR", "ddl_zy");
            ddl.Add("STU_TYPE", "ddl_ua_stu_type");
            ddl.Add("CMPL_STS_TEXT", "ddl_cmpl_status");
            cod.ConvertTabDdl(dt, ddl);

            return Json.DatatableToJson(dt);
        }

        #endregion 

        #region 劳动情况

        #region 加载劳动情况列表

        private string GetProofList()
        {
            string where = string.Format(" AND SEQ_NO = '{0}'", Get("seq_no"));
            var ddl = new Hashtable();

            return tables.GetCmdQueryData("GET_PROOF_LIST", null, where, string.Empty, ddl);
        }

        #endregion 加载劳动情况列表

        #endregion
    }
}