using System;
using System.Collections.Generic;
using AdminLTE_Mod.Common;
using HQ.WebForm;
using HQ.Model;
using HQ.InterfaceService;
using HQ.Architecture.Strategy;
using HQ.Architecture.Factory;
using System.Data;
using HQ.Utility;

namespace PorteffAnaly.Web.AdminLTE_QZ.JobApply
{
    public partial class List_can : ListBaseLoad<Qz_job_manage>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Qz_job_manage job_manage = new Qz_job_manage();
        public Qz_job_apply_head apply_head = new Qz_job_apply_head();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public ComHandleClass comHandle = new ComHandleClass();
        private ComTranClass comTran = new ComTranClass();

        public override string Doc_type { get { return CValue.DOC_TYPE_JOB02; } }

        #endregion 初始化

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

        protected override SelectTransaction<Qz_job_manage> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Qz_job_manage>("Qz_job_manageSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("SCH_YEAR")))
                where += string.Format(" AND SCH_YEAR = '{0}' ", Post("SCH_YEAR"));
            if (!string.IsNullOrEmpty(Post("IS_USE")))
                where += string.Format(" AND IS_USE = '{0}' ", Post("IS_USE"));
            if (!string.IsNullOrEmpty(Post("JOB_TYPE")))
                where += string.Format(" AND JOB_TYPE = '{0}' ", Post("JOB_TYPE"));
            if (!string.IsNullOrEmpty(Post("JOB_NAME")))
                where += string.Format(" AND JOB_NAME LIKE '%{0}%' ", Post("JOB_NAME"));
            //只显示审核通过的
            where += string.Format(" AND RET_CHANNEL = '{0}' ", WKF_VLAUES.RET_CHANNEL_D4000);
            //在申请有效时间范围内
            where += string.Format(" AND '{0}' BETWEEN DECL_START_TIME AND DECL_END_TIME", DateTime.Now.ToString("yyyy-MM-dd"));
            //已申请的岗位不显示
            where += string.Format(" AND SEQ_NO NOT IN (SELECT EXPECT_JOB1 FROM QZ_JOB_APPLY_HEAD WHERE STU_NUMBER = '{0}') ", user.User_Id);
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
                        case "chkjob":
                            Response.Write(CheckJob());
                            Response.End();
                            break;
                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;
                        case "submit":
                            Response.Write(SubmitData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Qz_job_manage entity)
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
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            yield return new NameValue() { Name = "EMPLOYER", Value = entity.EMPLOYER };
            yield return new NameValue() { Name = "CAMPUS", Value = entity.CAMPUS };
            yield return new NameValue() { Name = "JOB_NAME", Value = entity.JOB_NAME };
            yield return new NameValue() { Name = "JOB_TYPE", Value = entity.JOB_TYPE };
            yield return new NameValue() { Name = "REQ_NUM", Value = entity.REQ_NUM.ToString() };
            yield return new NameValue() { Name = "REWARD_STD", Value = entity.REWARD_STD.ToString() };
            yield return new NameValue() { Name = "REWARD_UNIT", Value = entity.REWARD_UNIT };
            yield return new NameValue() { Name = "SCH_YEAR", Value = entity.SCH_YEAR };
            yield return new NameValue() { Name = "SCH_TERM", Value = entity.SCH_TERM };
            yield return new NameValue() { Name = "IS_USE", Value = entity.IS_USE };
            yield return new NameValue() { Name = "IS_MULT", Value = entity.IS_MULT };
            yield return new NameValue() { Name = "WORK_PLACE", Value = entity.WORK_PLACE };
            yield return new NameValue() { Name = "WORK_START_TIME", Value = entity.WORK_START_TIME };
            yield return new NameValue() { Name = "WORK_END_TIME", Value = entity.WORK_END_TIME };
            yield return new NameValue() { Name = "WORK_TIME", Value = string.Format("{0} 至 {1}", entity.WORK_START_TIME, entity.WORK_END_TIME) };
            yield return new NameValue() { Name = "DECL_START_TIME", Value = entity.DECL_START_TIME };
            yield return new NameValue() { Name = "DECL_END_TIME", Value = entity.DECL_END_TIME };
            yield return new NameValue() { Name = "EMPLOYER_NAME", Value = cod.GetDDLTextByValue("ddl_all_department", entity.EMPLOYER) };
            yield return new NameValue() { Name = "JOB_TYPE2", Value = cod.GetDDLTextByValue("ddl_job_type", entity.JOB_TYPE) };
            yield return new NameValue() { Name = "SCH_YEAR2", Value = cod.GetDDLTextByValue("ddl_year_type", entity.SCH_YEAR) };
            yield return new NameValue() { Name = "SCH_TERM2", Value = cod.GetDDLTextByValue("ddl_xq", entity.SCH_TERM) };
            yield return new NameValue() { Name = "IS_USE2", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.IS_USE) };
            yield return new NameValue() { Name = "IS_MULT2", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.IS_MULT) };
            yield return new NameValue() { Name = "CAMPUS2", Value = cod.GetDDLTextByValue("ddl_campus", entity.CAMPUS) };
        }

        #endregion 输出列表信息

        #region 判断是否允许选择该岗位

        private string CheckJob()
        {
            string result = string.Empty;
            var oid = Get("id");
            if (!string.IsNullOrEmpty(oid))
            {
                //不允许一人多岗
                DataTable dt1 = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM QZ_JOB_MANAGE WHERE IS_MULT = 'N' AND OID = '{0}'", oid));
                DataTable dt2 = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM QZ_JOB_APPLY_HEAD WHERE STU_NUMBER = '{0}'", user.User_Id));
                if (dt1 != null && dt1.Rows.Count > 0 && dt2 != null && dt2.Rows.Count > 0)
                {
                    return string.Format("不符合申请：岗位【{0}】不允许一人多岗", dt1.Rows[0]["JOB_NAME"].ToString());
                }
            }

            return result;
        }

        #endregion

        #region 获取编辑页面Json

        private string GetData()
        {
            DataTable dt = null;
            if (!string.IsNullOrEmpty(Get("id")))
            {
                job_manage.OID = Get("id");
                ds.RetrieveObject(job_manage);
                if (job_manage != null)
                {
                    dt = ds.ExecuteTxtDataTable(string.Format("SELECT '{1}' EMPLOYER, '{2}' EXPECT_JOB1, A.NUMBER STU_NUMBER, A.NAME STU_NAME, SEX, A.NATION, A.POLISTATUS, A.EDULENTH GRADE, A.COLLEGE, MAJOR, A.CLASS CLASS_CODE, A.IDCARDNO, A.MOBILENUM TELEPHONE, B.BANKCODE BANK_CARD_NO, B.BANKNAME BANK_ACCOUNT FROM BASIC_STU_INFO A LEFT JOIN BASIC_STU_BANK_INFO B ON A.NUMBER = B.NUMBER WHERE A.NUMBER = '{0}'", user.User_Id, job_manage.EMPLOYER, job_manage.SEQ_NO));
                }
            }

            if (dt == null || dt.Rows.Count == 0)
                return "{}";
            else
                return Json.DatatableToJson(dt);
        }

        #endregion 

        #region 保存申请数据

        #region 获取学生基本信息

        private void GetStutentInfo(Qz_job_apply_head model)
        {
            DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT A.*, B.BANKCODE, B.BANKNAME FROM BASIC_STU_INFO A LEFT JOIN BASIC_STU_BANK_INFO B ON A.NUMBER = B.NUMBER WHERE A.NUMBER = '{0}'", user.User_Id));
            if (dt != null && dt.Rows.Count > 0)
            {
                model.STU_NUMBER = dt.Rows[0]["NUMBER"].ToString();
                model.STU_NAME = dt.Rows[0]["NAME"].ToString();
                model.SEX = dt.Rows[0]["SEX"].ToString();
                model.NATION = dt.Rows[0]["NATION"].ToString();
                model.POLISTATUS = dt.Rows[0]["POLISTATUS"].ToString();
                model.GRADE = dt.Rows[0]["EDULENTH"].ToString();
                model.COLLEGE = dt.Rows[0]["COLLEGE"].ToString();
                model.MAJOR = dt.Rows[0]["MAJOR"].ToString();
                model.CLASS_CODE = dt.Rows[0]["CLASS"].ToString();
                model.IDCARDNO = dt.Rows[0]["IDCARDNO"].ToString();
                model.TELEPHONE = dt.Rows[0]["MOBILENUM"].ToString();
                model.BANK_ACCOUNT = dt.Rows[0]["BANKNAME"].ToString();
                model.BANK_CARD_NO = dt.Rows[0]["BANKCODE"].ToString();
            }
        }

        #endregion 获取学生基本信息

        #region 获取页面数据

        private void GetPageValue(Qz_job_apply_head model)
        {
            model.DORMITORY = Post("DORMITORY");
            if (model.TELEPHONE.Length == 0)
                model.TELEPHONE = Post("TELEPHONE");
            if (model.BANK_ACCOUNT.Length == 0)
                model.BANK_ACCOUNT = Post("BANK_ACCOUNT");
            if (model.BANK_CARD_NO.Length == 0)
                model.BANK_CARD_NO = Post("BANK_CARD_NO");
            model.ENGLISH_LEVEL = Post("ENGLISH_LEVEL");
            model.COMPUTER_LEVEL = Post("COMPUTER_LEVEL");
            model.IS_FAIL = Post("IS_FAIL");
            model.FAIL_NUM = comTran.ToDecimal(Post("FAIL_NUM"));
            model.FAMILY_TYPE = Post("FAMILY_TYPE");
            model.SPECIALITY = Post("SPECIALITY");
            model.WORK_EXPERIENCE = Post("WORK_EXPERIENCE");
            model.APPLY_REASON = Post("APPLY_REASON");
            model.MONDAY = Post("DAY1");
            model.TUESDAY = Post("DAY2");
            model.WEDNESDAY = Post("DAY3");
            model.THURSDAY = Post("DAY4");
            model.FRIDAY = Post("DAY5");
            model.SATURDAY = Post("DAY6");
            model.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            model.OP_CODE = user.User_Id;
            model.OP_NAME = user.User_Name;
            model.DECL_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        }

        #endregion 获取页面数据

        private string SaveData()
        {
            try
            {
                job_manage.OID = Post("JOB_OID");
                apply_head.OID = Post("APPLY_OID");
                ds.RetrieveObject(job_manage);
                if (string.IsNullOrEmpty(apply_head.OID))
                {
                    apply_head.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(apply_head);
                    apply_head.SEQ_NO = GetSeq_no();
                    apply_head.DOC_TYPE = this.Doc_type;
                    apply_head.DECLARE_TYPE = WKF_VLAUES.DECLARE_TYPE_D;
                    apply_head.RET_CHANNEL = WKF_VLAUES.RET_CHANNEL_A0000;
                    apply_head.SCH_YEAR = sch_info.CURRENT_YEAR;
                    apply_head.SCH_TERM = sch_info.CURRENT_XQ;
                    apply_head.EMPLOY_FLAG = CValue.FLAG_N;
                    GetStutentInfo(apply_head);
                    if (job_manage != null)
                    {
                        apply_head.EMPLOYER = job_manage.EMPLOYER;
                        apply_head.EXPECT_JOB1 = job_manage.SEQ_NO;
                    }
                }
                else
                {
                    ds.RetrieveObject(apply_head);
                }
                GetPageValue(apply_head);
                ds.UpdateObject(apply_head);
                return apply_head.OID;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        #endregion 保存申请数据

        #region 提交

        private string SubmitData()
        {
            string saveResult = SaveData();
            if (saveResult.Length > 0)
            {
                string msg = "";
                bool result = WKF_ExternalInterface.getInstance().WKF_BusDeclare(apply_head.DOC_TYPE, apply_head.SEQ_NO, user.User_Id, user.User_Role, "提交上岗申请操作", out msg);
                if (!result)
                {
                    return "提交失败！" + msg;
                }
                else
                {
                    return string.Empty;
                }
            }
            else
                return "提交失败";
        }

        #endregion 提交
    }
}