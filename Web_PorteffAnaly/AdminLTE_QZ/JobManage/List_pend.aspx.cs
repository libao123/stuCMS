using System;
using System.Collections.Generic;
using System.Web;
using AdminLTE_Mod.Common;
using HQ.WebForm;
using HQ.Model;
using HQ.InterfaceService;
using HQ.Architecture.Strategy;
using HQ.Architecture.Factory;

namespace PorteffAnaly.Web.AdminLTE_QZ.JobManage
{
    public partial class List_pend : ListBaseLoad<Qz_job_manage>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Qz_job_manage head = new Qz_job_manage();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public ComHandleClass comHandle = new ComHandleClass();
        private ComTranClass comTran = new ComTranClass();

        public override string Doc_type { get { return CValue.DOC_TYPE_JOB01; } }

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
                        case "multiaudit":
                            Response.Write(GetList());
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
            yield return new NameValue() { Name = "WORK_START_TIME", Value = entity.WORK_START_TIME };
            yield return new NameValue() { Name = "WORK_END_TIME", Value = entity.WORK_END_TIME };
            yield return new NameValue() { Name = "DECL_START_TIME", Value = entity.DECL_START_TIME };
            yield return new NameValue() { Name = "DECL_END_TIME", Value = entity.DECL_END_TIME };
            yield return new NameValue() { Name = "POS_CODE2", Value = cod.GetDDLTextByValue("ddl_ua_role", entity.POS_CODE) };
            yield return new NameValue() { Name = "EMPLOYER2", Value = cod.GetDDLTextByValue("ddl_all_department", entity.EMPLOYER) };
            yield return new NameValue() { Name = "JOB_TYPE2", Value = cod.GetDDLTextByValue("ddl_job_type", entity.JOB_TYPE) };
            yield return new NameValue() { Name = "SCH_YEAR2", Value = cod.GetDDLTextByValue("ddl_year_type", entity.SCH_YEAR) };
            yield return new NameValue() { Name = "SCH_TERM2", Value = cod.GetDDLTextByValue("ddl_xq", entity.SCH_TERM) };
            yield return new NameValue() { Name = "IS_USE2", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.IS_USE) };
            yield return new NameValue() { Name = "IS_MULT2", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.IS_MULT) };
            yield return new NameValue() { Name = "STU_TYPE2", Value = cod.GetDDLTextByValue("ddl_ua_stu_type", entity.STU_TYPE) };
        }

        #endregion 输出列表信息

        #region 批量审批

        /// <summary>
        /// 批量审批
        /// </summary>
        /// <returns></returns>
        private string MultiPAudit()
        {
            try
            {
                #region 获得批量审核数据集合

                Dictionary<string, string> param = new Dictionary<string, string>();
                param.Add(string.Format(DataFilterHandleClass.getInstance().Pend_DataFilter(user.User_Role, Doc_type)), string.Empty);
                if (!string.IsNullOrEmpty(Get("SCH_YEAR")))
                    param.Add("SCH_YEAR", Get("SCH_YEAR"));
                if (!string.IsNullOrEmpty(Get("JOB_TYPE")))
                    param.Add("JOB_TYPE", Get("JOB_TYPE"));
                if (!string.IsNullOrEmpty(Get("IS_USE")))
                    param.Add("IS_USE", Get("IS_USE"));
                if (!string.IsNullOrEmpty(Get("JOB_NAME")))
                    param.Add(string.Format("JOB_NAME LIKE '%{0}%' ", HttpUtility.UrlDecode(Get("JOB_NAME"))), string.Empty);
                
                List<Qz_job_manage> applyList = JobManageHandleClass.getInstance().GetJobManageList(param);
                if (applyList == null)
                    return "查询批量审批勤助岗位申报数据出错！";

                #endregion 获得批量审核数据集合

                #region 批量审批

                string strFlag = Get("flag");
                foreach (Qz_job_manage head in applyList)
                {
                    #region 审核操作

                    if (head == null)
                        continue;

                    string strMsg = WKF_ExternalInterface.getInstance().ChkAudit(head.DOC_TYPE, head.SEQ_NO, user.User_Role);
                    if (strMsg.Length > 0)
                        continue;
                    
                    strMsg = string.Empty;
                    string strOpNote = string.Format("{0}在{1}操作：勤助岗位申报批量审批{2}", user.User_Id, GetDateLongFormater(), strFlag.Equals("P") ? "通过" : "不通过");
                    if (!WKF_ExternalInterface.getInstance().WKF_Audit(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, strFlag, strOpNote, out strMsg))
                    {
                        LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, strMsg);
                    }

                    #endregion 审核操作

                    #region 审批通过之后给申请人发送信息

                    string strFinalPosCode = WKF_AuditHandleCLass.getInstance().GetFinalPosCode(head.DOC_TYPE);
                    if (!string.IsNullOrEmpty(strFinalPosCode))
                    {
                        if (strFinalPosCode == user.User_Role)
                        {
                            string strApproveInfo = string.Empty;
                            if (strFlag.ToString().Equals("P"))
                                strApproveInfo = "审批通过";
                            else
                                strApproveInfo = "审批不通过";

                            string strMsgContent = "勤助岗位申报：" + head.JOB_NAME + strApproveInfo;
                            Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                            dicAccpter.Add(head.OP_CODE, head.OP_NAME);
                            MessgeHandleClass.getInstance().SendMessge("M", strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMsg);
                        }
                    }

                    #endregion 审批通过之后给申请人发送信息
                }

                #endregion 批量审批

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "勤助岗位申报批量审批出错：" + ex.ToString());
                return "批量审批失败！";
            }
        }

        #endregion 批量审批
    }
}