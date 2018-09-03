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

namespace PorteffAnaly.Web.AdminLTE_QZ.JobManage
{
    public partial class List : ListBaseLoad<Qz_job_manage>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Qz_job_manage head = new Qz_job_manage();
        public string m_strIsShowEditBtn = "false";//是否显示增删改提交按钮：显示true 不显示false
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
            get { return true; }
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
                        case "getdept":
                            Response.Write(GetManageDepartment());
                            Response.End();
                            break;
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
                        case "getreward":
                            Response.Write(GetRewardStandard());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 获取单位信息

        private string GetManageDepartment()
        {
            string strSQL = string.Format("SELECT DW VALUE, MC TEXT FROM T_XT_DEPARTMENT WHERE ',' + MANAGER + ',' LIKE '%,{0},%' ", user.User_Id);
            return cod.GetComboxJsonStr(ds.ExecuteTxtDataTable(strSQL));
        }

        #endregion 获取单位信息

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
            yield return new NameValue() { Name = "STU_TYPE", Value = entity.STU_TYPE };
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

        private string Check()
        {
            string result = string.Empty;
            bool iscan = JobManageHandleClass.getInstance().IsCanDeclare(out result);

            return result;
        }

        #region 获得设置的薪酬标准

        private string GetRewardStandard()
        {
            string stu_type = Get("stu_type");
            Qz_job_manage_set manage_set = JobManageHandleClass.getInstance().GetJobManageSet(new Dictionary<string, string> { { "IS_ENABLE", CValue.FLAG_Y } });
            if (manage_set != null)
            {
                if (stu_type.Equals(CValue.STU_STUTYPE_B))
                    return string.Format("{0},{1}", manage_set.REWARD_STD_B, manage_set.REWARD_UNIT_B);
                else if (stu_type.Equals(CValue.STU_STUTYPE_Y))
                    return string.Format("{0},{1}", manage_set.REWARD_STD_Y, manage_set.REWARD_UNIT_Y);
            }
            return string.Empty;
        }

        #endregion 获得设置的薪酬标准

        #region 获取编辑页面Json

        private string GetData()
        {
            DataTable dt = null;
            if (string.IsNullOrEmpty(Get("id")))
            {
                dt = ds.ExecuteTxtDataTable("SELECT CURRENT_YEAR SCH_YEAR, CURRENT_XQ SCH_TERM FROM BASIC_SCH_INFO");
            }
            else
            {
                dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM QZ_JOB_MANAGE WHERE OID = '{0}' ", Get("id")));
            }
            if (dt == null || dt.Rows.Count == 0)
                return "{}";
            else
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
            string result = string.Empty;
            string job_type = Get("job_type");
            string oid = Get("id");
            string strEmployer = Server.UrlDecode(Get("employer"));
            string strJob_Name = Server.UrlDecode(Get("job_name"));
            string strIsModi = string.Empty;

            //非临时岗需要校验是否在申报时间范围内
            if (job_type != "2")
            {
                bool iscan = JobManageHandleClass.getInstance().IsCanDeclare(out result);
                if (result.Length > 0)
                    return result;
            }
            if (oid.Length > 0)
            {
                strIsModi = string.Format(" AND OID NOT IN ('{0}') ", oid);
            }
            string strSql = string.Format("SELECT COUNT(1) FROM QZ_JOB_MANAGE WHERE EMPLOYER = '{0}' AND JOB_NAME = '{1}'{2}", strEmployer, strJob_Name, strIsModi);
            object o = ds.ExecuteTxtScalar(strSql);
            if (o != null && comTran.ToInt(o) > 0)
                return "岗位已存在";

            return string.Empty;
        }

        #endregion 判断是否允许保存

        #region 获取页面数据

        private void GetPageValue(Qz_job_manage model)
        {
            model.CAMPUS = Post("CAMPUS");
            model.JOB_TYPE = Post("JOB_TYPE");
            model.EMPLOYER = Post("EMPLOYER");
            model.JOB_NAME = Post("JOB_NAME");
            model.REQ_NUM = comTran.ToDecimal(Post("REQ_NUM"));
            model.JOB_DESCR = Post("JOB_DESCR");
            model.JOB_RQMT = Post("JOB_RQMT");
            model.WORK_PLACE = Post("WORK_PLACE");
            model.REWARD_STD = comTran.ToDecimal(Post("REWARD_STD"));
            model.REWARD_UNIT = Post("REWARD_UNIT");
            model.IS_USE = Post("IS_USE");
            model.IS_MULT = Post("IS_MULT");
            model.SCH_YEAR = Post("SCH_YEAR");
            model.SCH_TERM = Post("SCH_TERM");
            model.DECL_START_TIME = Post("DECL_START_TIME");
            model.DECL_END_TIME = Post("DECL_END_TIME");
            model.WORK_START_TIME = Post("WORK_START_TIME");
            model.WORK_END_TIME = Post("WORK_END_TIME");
            model.ORDER_NUM = comTran.ToDecimal(Post("ORDER_NUM"));
            //model.STU_TYPE = Post("hidStuType").TrimEnd(',');
            model.STU_TYPE = Post("STU_TYPE");
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
                bool result = WKF_ExternalInterface.getInstance().WKF_BusDeclare(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, "提交岗位申报操作", out msg);
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
            object o = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM QZ_JOB_APPLY_HEAD WHERE EXPECT_JOB1 = '{0}' OR EXPECT_JOB2 = '{0}'", head.SEQ_NO));
            if (o != null)
            {
                if (Int32.Parse(o.ToString()) > 0)
                    return "已有学生申请该岗位，不允许删除！";
            }

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
            var transaction = ImplementFactory.GetDeleteTransaction<Qz_job_manage>("Qz_job_manageDeleteTransaction");
            transaction.EntityList.Add(head);
            bDel = transaction.Commit();

            if (!bDel)
                return "删除失败！";
            else
                return string.Empty;
        }

        #endregion 删除数据

        #endregion 删除操作
    }
}