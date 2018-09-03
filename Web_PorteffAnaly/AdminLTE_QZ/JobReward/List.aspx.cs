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

namespace PorteffAnaly.Web.AdminLTE_QZ.JobReward
{
    public partial class List : ListBaseLoad<Qz_job_reward_head>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Qz_job_reward_head head = new Qz_job_reward_head();
        public string m_strIsShowEditBtn = "false";//是否显示增删改提交按钮：显示true 不显示false
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public ComHandleClass comHandle = new ComHandleClass();
        private ComTranClass comTran = new ComTranClass();
        private datatables tables = new datatables();

        public override string Doc_type { get { return CValue.DOC_TYPE_JOB04; } }

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
            get { return true; }
        }

        protected override SelectTransaction<Qz_job_reward_head> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Qz_job_reward_head>("Qz_job_reward_headSelectTransaction", param);
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
            if (!string.IsNullOrEmpty(Post("SCH_TERM")))
                where += string.Format(" AND SCH_TERM = '{0}' ", Post("SCH_TERM"));
            if (!string.IsNullOrEmpty(Post("EMPLOYER")))
                where += string.Format(" AND EMPLOYER = '{0}' ", Post("EMPLOYER"));
            if (!string.IsNullOrEmpty(Post("JOB_SEQ_NO")))
                where += string.Format(" AND JOB_SEQ_NO = '{0}' ", Post("JOB_SEQ_NO"));
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
                        case "chkmodi":
                            Response.Write(CheckModify());
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
                        case "getrewardlist":
                            Response.Write(GetRewardList());
                            Response.End();
                            break;
                        case "savereward":
                            Response.Write(SaveReward());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Qz_job_reward_head entity)
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
            yield return new NameValue() { Name = "SCH_YEAR", Value = entity.SCH_YEAR };
            yield return new NameValue() { Name = "SCH_TERM", Value = entity.SCH_TERM };
            yield return new NameValue() { Name = "EMPLOYER", Value = entity.EMPLOYER };
            yield return new NameValue() { Name = "JOB_SEQ_NO", Value = entity.JOB_SEQ_NO };
            yield return new NameValue() { Name = "YEAR_MONTH", Value = entity.YEAR_MONTH };
            yield return new NameValue() { Name = "POS_CODE2", Value = cod.GetDDLTextByValue("ddl_ua_role", entity.POS_CODE) };
            yield return new NameValue() { Name = "SCH_YEAR2", Value = cod.GetDDLTextByValue("ddl_year_type", entity.SCH_YEAR) };
            yield return new NameValue() { Name = "SCH_TERM2", Value = cod.GetDDLTextByValue("ddl_xq", entity.SCH_TERM) };
            yield return new NameValue() { Name = "EMPLOYER2", Value = cod.GetDDLTextByValue("ddl_all_department", entity.EMPLOYER) };
            yield return new NameValue() { Name = "JOB_NAME", Value = cod.GetDDLTextByValue("ddl_job_name", entity.JOB_SEQ_NO) };
        }

        #endregion 输出列表信息

        #region 获取编辑页面Json

        private string GetData()
        {
            DataTable dt = null;
            if (string.IsNullOrEmpty(Get("id")))
                return "{}";

            dt = ds.ExecuteTxtDataTable(string.Format("SELECT *, EMPLOYER EMPLOYER2, JOB_SEQ_NO JOB_NAME, '' TOTAL_REAL_AMOUNT FROM QZ_JOB_REWARD_HEAD WHERE OID = '{0}' ", Get("id")));
            if (dt == null || dt.Rows.Count == 0)
                return "{}";

            var ddl = new Hashtable();
            ddl.Add("EMPLOYER2", "ddl_all_department");
            ddl.Add("JOB_NAME", "ddl_job_name");
            cod.ConvertTabDdl(dt, ddl);

            dt.Rows[0]["TOTAL_REAL_AMOUNT"] = JobRewardHandleClass.getInstance().CalculateRealAmount(Get("seq_no")).ToString();
            return Json.DatatableToJson(dt);
        }

        #endregion 

        #region 判断是否允许修改

        private string CheckModify()
        {
            string result = string.Empty;
            var oid = Get("id");
            if (string.IsNullOrEmpty(oid)) return "主键为空,不允许修改";

            head.OID = oid;
            ds.RetrieveObject(head);

            //预录入、一级待审可以修改
            if (!(head.RET_CHANNEL.Equals(CValue.RET_CHANNEL_A0000) || head.RET_CHANNEL.Equals(CValue.RET_CHANNEL_D1000)))
                return "该状态下不允许操作！";

            return result;
        }

        #endregion

        #region 保存

        private string SaveData()
        {
            try
            {
                head.OID = Post("OID");
                if (string.IsNullOrEmpty(head.OID))
                {
                    head.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(head);
                    head.SEQ_NO = GetSeq_no();
                    head.DOC_TYPE = this.Doc_type;
                    head.DECLARE_TYPE = WKF_VLAUES.DECLARE_TYPE_D;
                    head.RET_CHANNEL = WKF_VLAUES.RET_CHANNEL_A0000;
                    head.SCH_YEAR = sch_info.CURRENT_YEAR;
                    head.SCH_TERM = sch_info.CURRENT_XQ;
                }
                else
                {
                    ds.RetrieveObject(head);
                }
                head.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                head.OP_CODE = user.User_Id;
                head.OP_NAME = user.User_Name;
                head.DECL_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                ds.UpdateObject(head);
                return head.OID + ";" + head.SEQ_NO;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        #endregion 保存

        #region 提交

        private string SubmitData()
        {
            string saveResult = SaveData();
            if (saveResult.Length > 0)
            {
                string msg = "";
                bool result = WKF_ExternalInterface.getInstance().WKF_BusDeclare(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, "提交薪酬核对", out msg);
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

        #region 保存学生薪酬

        private string SaveReward()
        {
            try
            {
                Qz_job_reward_list list = new Qz_job_reward_list();
                list.OID = Post("OID");
                if (list.OID == "")
                {
                    list.OID = Guid.NewGuid().ToString();
                }
                ds.RetrieveObject(list);
                list.SEQ_NO = Get("seq_no");
                //list.REWARD_STD = comTran.ToDecimal(Post("REWARD_STD"));
                //list.QUANTITY = comTran.ToDecimal(Post("QUANTITY"));
                list.REAL_AMOUNT = comTran.ToDecimal(Post("REAL_AMOUNT"));

                ds.UpdateObject(list);
                string total_real_amount = JobRewardHandleClass.getInstance().CalculateRealAmount(list.SEQ_NO).ToString();
                return total_real_amount;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        #endregion 保存学生薪酬

        #region 加载学生薪酬列表

        private string GetRewardList()
        {
            string where = string.Format(" AND SEQ_NO = '{0}'", Get("seq_no"));
            var ddl = new Hashtable();
            ddl.Add("COLLEGE2", "ddl_department");
            ddl.Add("MAJOR2", "ddl_zy");
            ddl.Add("CLASS2", "ddl_class");

            return tables.GetCmdQueryData("GET_REWARD_LIST", null, where, string.Empty, ddl);
        }

        #endregion 加载学生薪酬列表
    }
}