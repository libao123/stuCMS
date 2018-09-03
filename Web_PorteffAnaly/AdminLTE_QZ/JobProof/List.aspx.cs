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
    public partial class List : ListBaseLoad<Qz_job_proof_head>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Qz_job_proof_head head = new Qz_job_proof_head();
        public string m_strIsShowEditBtn = "false";//是否显示增删改提交按钮：显示true 不显示false
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public ComHandleClass comHandle = new ComHandleClass();
        private ComTranClass comTran = new ComTranClass();
        private datatables tables = new datatables();
        public Qz_job_proof_set proof_set = JobProofHandleClass.getInstance().GetEnableProofSet();

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
                        case "chk":
                            Response.Write(Check());
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
                        case "chksave":
                            Response.Write(CheckSave());
                            Response.End();
                            break;
                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;
                        case "chksubmit":
                            Response.Write(CheckSubmit());
                            Response.End();
                            break;
                        case "submit":
                            Response.Write(SubmitData());
                            Response.End();
                            break;
                        case "chkdel":
                            Response.Write(CheckDelete());
                            Response.End();
                            break;
                        case "delete":
                            Response.Write(DeleteData());
                            Response.End();
                            break;
                        case "getprooflist":
                            Response.Write(GetProofList());
                            Response.End();
                            break;
                        case "savedetail":
                            Response.Write(SaveWorkDetail());
                            Response.End();
                            break;
                        case "deldetail":
                            Response.Write(DeleteWorkDetail());
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
            yield return new NameValue() { Name = "YEAR_MONTH", Value = entity.YEAR_MONTH };
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

        private string Check()
        {
            string result = string.Empty;
            bool iscan = JobProofHandleClass.getInstance().IsCan(out result);

            return result;
        }

        #region 获取编辑页面Json

        private string GetData()
        {
            DataTable dt = null;
            if (string.IsNullOrEmpty(Get("id")))
            {
                dt = ds.ExecuteTxtDataTable(string.Format("SELECT A.NUMBER STU_NUMBER, A.NAME STU_NAME, SEX, A.NATION, A.POLISTATUS, A.EDULENTH GRADE, A.COLLEGE, MAJOR, A.CLASS CLASS_CODE, A.IDCARDNO, A.STUTYPE STU_TYPE, A.MOBILENUM TELEPHONE, B.BANKCODE BANK_CARD_NO, C.RICE_CARD FROM BASIC_STU_INFO A LEFT JOIN BASIC_STU_BANK_INFO B ON A.NUMBER = B.NUMBER LEFT JOIN BASIC_STU_RICECARD C ON A.NUMBER = C.STU_NUMBER WHERE A.NUMBER = '{0}'", user.User_Id));
                if (dt == null || dt.Rows.Count == 0)
                    return "{}";
            }
            else
            {
                dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM QZ_JOB_PROOF_HEAD WHERE OID = '{0}' ", Get("id")));
                if (dt == null || dt.Rows.Count == 0)
                    return "{}";
            }

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

        #region 判断是否允许保存

        private string CheckSave()
        {
            string oid = Get("id");
            string strJob = Server.UrlDecode(Get("job"));

            //if (!string.IsNullOrEmpty(oid))
            //{
            //    object o = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM QZ_JOB_PROOF_HEAD WHERE JOB_SEQ_NO = '{0}' AND OID != '{1}'", oid, strJob, sch_info.CURRENT_YEAR, sch_info.CURRENT_XQ));
            //    if (o != null && comTran.ToDecimal(o.ToString()) > 0)
            //        return "";
            //}
            
            return string.Empty;
        }

        #endregion 判断是否允许保存

        #region 获取学生基本信息

        private void GetStutentInfo(Qz_job_proof_head model)
        {
            DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT A.*, B.BANKCODE, C.RICE_CARD FROM BASIC_STU_INFO A LEFT JOIN BASIC_STU_BANK_INFO B ON A.NUMBER = B.NUMBER LEFT JOIN BASIC_STU_RICECARD C ON A.NUMBER = C.STU_NUMBER WHERE A.NUMBER = '{0}'", user.User_Id));
            if (dt != null && dt.Rows.Count > 0)
            {
                model.STU_NUMBER = dt.Rows[0]["NUMBER"].ToString();
                model.STU_NAME = dt.Rows[0]["NAME"].ToString();
                model.SEX = dt.Rows[0]["SEX"].ToString();
                model.GRADE = dt.Rows[0]["EDULENTH"].ToString();
                model.COLLEGE = dt.Rows[0]["COLLEGE"].ToString();
                model.MAJOR = dt.Rows[0]["MAJOR"].ToString();
                model.CLASS_CODE = dt.Rows[0]["CLASS"].ToString();
                model.IDCARDNO = dt.Rows[0]["IDCARDNO"].ToString();
                model.STU_TYPE = dt.Rows[0]["STUTYPE"].ToString();
                model.TELEPHONE = dt.Rows[0]["MOBILENUM"].ToString();
                model.BANK_CARD_NO = dt.Rows[0]["BANKCODE"].ToString();
                model.RICE_CARD = dt.Rows[0]["RICE_CARD"].ToString();
            }
        }

        #endregion 获取学生基本信息

        #region 获取页面数据

        private void GetPageValue(Qz_job_proof_head model)
        {
            if (model.TELEPHONE.Length == 0)
                model.TELEPHONE = Post("TELEPHONE");
            if (model.BANK_CARD_NO.Length == 0)
                model.BANK_CARD_NO = Post("BANK_CARD_NO");
            if (model.RICE_CARD.Length == 0)
                model.RICE_CARD = Post("RICE_CARD");
            model.EMPLOYER = Post("EMPLOYER");
            model.JOB_SEQ_NO = Post("JOB_SEQ_NO");
            model.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            model.OP_CODE = user.User_Id;
            model.OP_NAME = user.User_Name;
            model.DECL_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        }

        #endregion 获取页面数据

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
                    head.HANDLE_STS = CValue.FLAG_N;
                    head.YEAR_MONTH = proof_set != null ? proof_set.YEAR_MONTH : string.Empty;
                    GetStutentInfo(head);
                }
                else
                {
                    ds.RetrieveObject(head);
                }
                GetPageValue(head);
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

        #region 判断是否允许提交

        private string CheckSubmit()
        {
            head.OID = Get("id");
            if (string.IsNullOrEmpty(head.OID))
                head.OID = Guid.NewGuid().ToString();

            ds.RetrieveObject(head);
            DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM QZ_JOB_PROOF_LIST WHERE SEQ_NO = '{0}'", head.SEQ_NO));
            if (dt == null || dt.Rows.Count == 0)
                return "请录入劳动内容";

            return string.Empty;
        }

        #endregion 判断是否允许提交

        private string SubmitData()
        {
            string saveResult = SaveData();
            if (saveResult.Length > 0)
            {
                string msg = "";
                bool result = WKF_ExternalInterface.getInstance().WKF_BusDeclare(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, "提交劳酬凭据", out msg);
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

        #region 删除操作

        #region 判断是否允许删除

        private string CheckDelete()
        {
            string result = string.Empty;
            var oid = Get("id");
            if (string.IsNullOrEmpty(oid)) return "主键为空,不允许删除操作";

            head.OID = oid;
            ds.RetrieveObject(head);

            if (!(head.RET_CHANNEL.Equals(CValue.RET_CHANNEL_A0000)))
                return "该状态下不允许操作！";

            //如果该岗位已有学生申请，则无法删除该岗位

            return result;
        }

        #endregion

        #region 删除数据

        private string DeleteData()
        {
            var oid = Get("id");
            if (string.IsNullOrEmpty(oid)) return "主键为空,不允许删除操作";

            head.OID = oid;
            ds.RetrieveObject(head);

            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Qz_job_proof_head>("Qz_job_proof_headDeleteTransaction");
            transaction.EntityList.Add(head);
            bDel = transaction.Commit();

            if (!bDel)
                return "删除失败！";
            else
                return string.Empty;
        }

        #endregion 删除数据

        #endregion 删除操作

        #region 劳动情况

        #region 加载劳动情况列表

        private string GetProofList()
        {
            string where = string.Format(" AND SEQ_NO = '{0}'", Get("seq_no"));
            var ddl = new Hashtable();

            return tables.GetCmdQueryData("GET_PROOF_LIST", null, where, string.Empty, ddl);
        }

        #endregion 加载劳动情况列表

        #region 保存劳动情况

        private string SaveWorkDetail()
        {
            try
            {
                Qz_job_proof_list list = new Qz_job_proof_list();
                list.OID = Post("LIST_OID");
                if (list.OID == "")
                {
                    list.OID = Guid.NewGuid().ToString();
                }
                ds.RetrieveObject(list);
                list.SEQ_NO = Get("seq_no");
                list.WORK_DATE = Post("WORK_DATE");
                list.WORK_START_TIME = Post("WORK_START_TIME");
                list.WORK_END_TIME = Post("WORK_END_TIME");
                list.WORK_HOURS = comTran.ToDecimal(Post("WORK_HOURS"));
                list.WORK_TASK = Post("WORK_TASK");
                list.JOB_SEQ_NO = Post("JOB_SEQ_NO");

                ds.UpdateObject(list);
                decimal reward = JobProofHandleClass.getInstance().CalculateReward(list.SEQ_NO);
                ds.ExecuteTxtNonQuery(string.Format("UPDATE QZ_JOB_PROOF_HEAD SET REWARD = {1} WHERE SEQ_NO = '{0}'", list.SEQ_NO, reward));
                //return list.OID + ";" + list.SEQ_NO;
                return Math.Round(reward, 2).ToString();
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        #endregion 保存劳动情况

        #region 删除劳动情况

        private string DeleteWorkDetail()
        {
            var oid = Get("id");
            if (string.IsNullOrEmpty(oid)) return "主键为空,不允许删除操作";

            Qz_job_proof_list list = new Qz_job_proof_list();
            list.OID = oid;
            ds.RetrieveObject(list);

            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Qz_job_proof_list>("Qz_job_proof_listDeleteTransaction");
            transaction.EntityList.Add(list);
            bDel = transaction.Commit();

            if (!bDel)
                return string.Empty;
            else
            {
                decimal reward = JobProofHandleClass.getInstance().CalculateReward(list.SEQ_NO);
                ds.ExecuteTxtNonQuery(string.Format("UPDATE QZ_JOB_PROOF_HEAD SET REWARD = {1} WHERE SEQ_NO = '{0}'", list.SEQ_NO, reward));
                return Math.Round(reward, 2).ToString();
            }
        }

        #endregion 删除劳动情况

        #endregion
    }
}