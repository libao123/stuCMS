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

namespace PorteffAnaly.Web.AdminLTE_QZ.JobApply
{
    public partial class List : ListBaseLoad<Qz_job_apply_head>
    {
        #region 初始化

        public comdata cod = new comdata();
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
            return where;
        }

        #endregion 辅助页面加载

        #region 页面加载

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (WKF_ExternalInterface.getInstance().IsShowEditButton(user.User_Role, this.Doc_type))
                    m_strIsShowEditBtn = "true";

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
                        case "chksave":
                            Response.Write(CheckSave());
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
                        case "chkdel":
                            Response.Write(CheckDelete());
                            Response.End();
                            break;
                        case "delete":
                            Response.Write(DeleteData());
                            Response.End();
                            break;
                        case "chkjob":
                            Response.Write(CheckJob());
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

        #region 获取编辑页面Json

        private string GetData()
        {
            DataTable dt = null;
            if (string.IsNullOrEmpty(Get("id")))
            {
                dt = ds.ExecuteTxtDataTable(string.Format("SELECT NUMBER STU_NUMBER, NAME STU_NAME, SEX, NATION, POLISTATUS, EDULENTH GRADE, COLLEGE, MAJOR, CLASS CLASS_CODE FROM BASIC_STU_INFO WHERE NUMBER = '{0}'", user.User_Id));
                if (dt == null || dt.Rows.Count == 0)
                    return "{}";
            }
            else
            {
                dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM QZ_JOB_APPLY_HEAD WHERE OID = '{0}' ", Get("id")));
                if (dt == null || dt.Rows.Count == 0)
                    return "{}";
                else
                {
                    #region 课余时间

                    string strTemp = dt.Rows[0]["MONDAY"].ToString();
                    for (int i = 1; i <= strTemp.Length; i++)
                    {
                        if (strTemp.Substring(i - 1, 1) == "Y")
                        {
                            dt.Columns.Add("Mon" + i);
                            dt.Rows[0]["Mon" + i] = "1";
                        }
                    }

                    strTemp = dt.Rows[0]["TUESDAY"].ToString();
                    for (int i = 1; i <= strTemp.Length; i++)
                    {
                        if (strTemp.Substring(i - 1, 1) == "Y")
                        {
                            dt.Columns.Add("Tues" + i);
                            dt.Rows[0]["Tues" + i] = "1";
                        }
                    }

                    strTemp = dt.Rows[0]["WEDNESDAY"].ToString();
                    for (int i = 1; i <= strTemp.Length; i++)
                    {
                        if (strTemp.Substring(i - 1, 1) == "Y")
                        {
                            dt.Columns.Add("Wed" + i);
                            dt.Rows[0]["Wed" + i] = "1";
                        }
                    }

                    strTemp = dt.Rows[0]["THURSDAY"].ToString();
                    for (int i = 1; i <= strTemp.Length; i++)
                    {
                        if (strTemp.Substring(i - 1, 1) == "Y")
                        {
                            dt.Columns.Add("Thur" + i);
                            dt.Rows[0]["Thur" + i] = "1";
                        }
                    }

                    strTemp = dt.Rows[0]["FRIDAY"].ToString();
                    for (int i = 1; i <= strTemp.Length; i++)
                    {
                        if (strTemp.Substring(i - 1, 1) == "Y")
                        {
                            dt.Columns.Add("Fri" + i);
                            dt.Rows[0]["Fri" + i] = "1";
                        }
                    }

                    strTemp = dt.Rows[0]["SATURDAY"].ToString();
                    for (int i = 1; i <= strTemp.Length; i++)
                    {
                        if (strTemp.Substring(i - 1, 1) == "Y")
                        {
                            dt.Columns.Add("Sat" + i);
                            dt.Rows[0]["Sat" + i] = "1";
                        }
                    }

                    #endregion
                }
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

            if (!string.IsNullOrEmpty(oid))
            {
                object o = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM QZ_JOB_APPLY_HEAD WHERE STU_NUMBER = '{0}' AND SCH_YEAR = '{1}' AND SCH_TERM = '{2}' AND EXPECT_JOB1 = '{3}' AND OID != '{4}'", user.User_Id, sch_info.CURRENT_YEAR, sch_info.CURRENT_XQ, strJob, oid));
                if (o != null && comTran.ToDecimal(o.ToString()) > 0)
                    return "同一岗位不允许重复申请";
            }

            return string.Empty;
        }

        #endregion 判断是否允许保存

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
                    head.EMPLOY_FLAG = CValue.FLAG_N;
                    GetStutentInfo(head);
                }
                else
                {
                    ds.RetrieveObject(head);
                }
                GetPageValue(head);
                ds.UpdateObject(head);
                return head.OID;
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
                bool result = WKF_ExternalInterface.getInstance().WKF_BusDeclare(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, "提交上岗申请操作", out msg);
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
            var transaction = ImplementFactory.GetDeleteTransaction<Qz_job_apply_head>("Qz_job_apply_headDeleteTransaction");
            transaction.EntityList.Add(head);
            bDel = transaction.Commit();

            if (!bDel)
                return "删除失败！";
            else
                return string.Empty;
        }

        #endregion 删除数据

        #endregion 删除操作

        #region 判断是否允许选择该岗位

        private string CheckJob()
        {
            string result = string.Empty;
            var oid = Get("id");
            var job_seq = Get("job");
            if (!string.IsNullOrEmpty(job_seq))
            {
                //不允许一人多岗
                DataTable dt1 = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM QZ_JOB_MANAGE WHERE SEQ_NO = '{0}' AND IS_MULT = 'N'", job_seq));
                DataTable dt2 = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM QZ_JOB_APPLY_HEAD WHERE STU_NUMBER = '{0}' AND OID != '{1}'", user.User_Id, oid));
                if (dt1 != null && dt1.Rows.Count > 0 && dt2 != null && dt2.Rows.Count > 0)
                {
                    return string.Format("不符合申请：岗位【{0}】不允许一人多岗", dt1.Rows[0]["JOB_NAME"].ToString());
                }

                object o = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM QZ_JOB_APPLY_HEAD WHERE STU_NUMBER = '{0}' AND SCH_YEAR = '{1}' AND SCH_TERM = '{2}' AND EXPECT_JOB1 = '{3}' AND OID != '{4}'", user.User_Id, sch_info.CURRENT_YEAR, sch_info.CURRENT_XQ, job_seq, oid));
                if (o != null && comTran.ToDecimal(o.ToString()) > 0)
                    return "同一岗位不允许重复申请";
            }

            return result;
        }

        #endregion
    }
}