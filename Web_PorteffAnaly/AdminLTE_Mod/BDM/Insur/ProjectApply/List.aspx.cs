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
using System.Data;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectApply
{
    public partial class List : ListBaseLoad<Insur_project_apply>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public bool bIsShowBtn = false;

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
            get { return "XY"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Insur_project_apply> GetSelectTransaction()
        {
            if (!string.IsNullOrEmpty(Get("page_from")))
            {
                //保险信息为N；参保之后为Y
                if (Get("page_from").ToString().Equals("personal"))/// 参保信息
                    param.Add("INSUR_FLAG", "Y");
                else///保险信息
                    param.Add("INSUR_FLAG", "N");
            }
            return ImplementFactory.GetSelectTransaction<Insur_project_apply>("Insur_project_applySelectTransaction", param);
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

                        case "auto_data"://自动生成数据
                            Response.Write(AutoData());
                            Response.End();
                            break;
                    }
                }
                //校级角色 才有按钮权限
                if (user.User_Role.Equals("X"))
                {
                    bIsShowBtn = true;
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
            if (!string.IsNullOrEmpty(Post("INSUR_TYPE")))
                where += string.Format(" AND INSUR_TYPE = '{0}' ", Post("INSUR_TYPE"));
            if (!string.IsNullOrEmpty(Post("INSUR_YEAR")))
                where += string.Format(" AND INSUR_YEAR = '{0}' ", Post("INSUR_YEAR"));
            if (!string.IsNullOrEmpty(Post("INSUR_SEQ_NO")))
                where += string.Format(" AND INSUR_SEQ_NO = '{0}' ", Post("INSUR_SEQ_NO"));
            if (!string.IsNullOrEmpty(Post("XY")))
                where += string.Format(" AND XY = '{0}' ", Post("XY"));
            if (!string.IsNullOrEmpty(Post("ZY")))
                where += string.Format(" AND ZY = '{0}' ", Post("ZY"));
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("CLASS_CODE")))
                where += string.Format(" AND CLASS_CODE = '{0}' ", Post("CLASS_CODE"));
            if (!string.IsNullOrEmpty(Post("STU_NUMBER")))
                where += string.Format(" AND STU_NUMBER LIKE '%{0}%' ", Post("STU_NUMBER"));
            if (!string.IsNullOrEmpty(Post("STU_NAME")))
                where += string.Format(" AND STU_NAME LIKE '%{0}%' ", Post("STU_NAME"));
            if (!string.IsNullOrEmpty(Post("RET_CHANNEL")))
                where += string.Format(" AND RET_CHANNEL = '{0}' ", Post("RET_CHANNEL"));
            if (!string.IsNullOrEmpty(Post("STU_TYPE")))
                where += string.Format(" AND STU_TYPE = '{0}' ", Post("STU_TYPE"));
            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Insur_project_apply>.NameValue> GetValue(Insur_project_apply entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            //项目数据
            yield return new NameValue() { Name = "INSUR_SEQ_NO", Value = entity.INSUR_SEQ_NO };
            yield return new NameValue() { Name = "INSUR_TYPE", Value = entity.INSUR_TYPE };
            yield return new NameValue() { Name = "INSUR_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_insur_type", entity.INSUR_TYPE) };
            yield return new NameValue() { Name = "INSUR_NAME", Value = entity.INSUR_NAME };
            yield return new NameValue() { Name = "INSUR_YEAR", Value = entity.INSUR_YEAR };
            yield return new NameValue() { Name = "INSUR_YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.INSUR_YEAR) };
            //申请人数据
            yield return new NameValue() { Name = "STU_NUMBER", Value = entity.STU_NUMBER };
            yield return new NameValue() { Name = "STU_NAME", Value = entity.STU_NAME };
            yield return new NameValue() { Name = "STU_TYPE", Value = entity.STU_TYPE };
            yield return new NameValue() { Name = "STU_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_ua_stu_type", entity.STU_TYPE) };
            yield return new NameValue() { Name = "XY", Value = entity.XY };
            yield return new NameValue() { Name = "XY_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.XY) };
            yield return new NameValue() { Name = "ZY", Value = entity.ZY };
            yield return new NameValue() { Name = "ZY_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.ZY) };
            yield return new NameValue() { Name = "CLASS_CODE", Value = entity.CLASS_CODE };
            yield return new NameValue() { Name = "CLASS_CODE_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS_CODE) };
            yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
            yield return new NameValue() { Name = "STU_PHONE", Value = entity.STU_PHONE };
            //申请人填报数据
            yield return new NameValue() { Name = "INSUR_LIMITDATE", Value = entity.INSUR_LIMITDATE };
            yield return new NameValue() { Name = "INSUR_MONEY", Value = entity.INSUR_MONEY.ToString() };
            //单据数据
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "DOC_TYPE", Value = entity.DOC_TYPE };
            yield return new NameValue() { Name = "DECL_TIME", Value = entity.DECL_TIME };
            yield return new NameValue() { Name = "CHK_TIME", Value = entity.CHK_TIME };
            yield return new NameValue() { Name = "CHK_STATUS", Value = entity.CHK_STATUS };
            yield return new NameValue() { Name = "CHK_STATUS_NAME", Value = cod.GetDDLTextByValue("ddl_CHK_STATUS", entity.CHK_STATUS) };
            yield return new NameValue() { Name = "DECLARE_TYPE", Value = entity.DECLARE_TYPE };
            yield return new NameValue() { Name = "DECLARE_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_DECLARE_TYPE", entity.DECLARE_TYPE) };
            yield return new NameValue() { Name = "RET_CHANNEL", Value = entity.RET_CHANNEL };
            yield return new NameValue() { Name = "RET_CHANNEL_NAME", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.RET_CHANNEL) };
            yield return new NameValue() { Name = "POS_CODE", Value = entity.POS_CODE };
            yield return new NameValue() { Name = "AUDIT_POS_CODE", Value = entity.AUDIT_POS_CODE };
            yield return new NameValue() { Name = "STEP_NO", Value = entity.STEP_NO };
            yield return new NameValue() { Name = "STEP_NO_NAME", Value = cod.GetDDLTextByValue("ddl_STEP_NO", entity.STEP_NO) };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            //参保信息
            yield return new NameValue() { Name = "INSUR_COMPANY", Value = entity.INSUR_COMPANY };
            yield return new NameValue() { Name = "INSUR_HANLDMAN", Value = entity.INSUR_HANLDMAN };
            yield return new NameValue() { Name = "INSUR_HANLDMAN_PHONE", Value = entity.INSUR_HANLDMAN_PHONE };
            yield return new NameValue() { Name = "INSUR_NUMBER", Value = entity.INSUR_NUMBER };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                string[] strs = Post("SELECT_OID").Split(',');
                for (int i = 0; i < strs.Length; i++)
                {
                    if (strs[i].Length == 0)
                        continue;
                    var model = new Insur_project_apply();
                    model.OID = strs[i].ToString();
                    ds.RetrieveObject(model);

                    bool bDel = false;
                    var transaction = ImplementFactory.GetDeleteTransaction<Insur_project_apply>("Insur_project_applyDeleteTransaction");
                    transaction.EntityList.Add(model);
                    bDel = transaction.Commit();

                    if (!bDel)
                        return "删除失败！";

                    //删除表体
                    string strDeleteSql_Check = string.Format("DELETE FROM INSUR_APPLY_CHECK WHERE SEQ_NO = '{0}' ", model.SEQ_NO);
                    ds.ExecuteTxtNonQuery(strDeleteSql_Check);
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "删除保险申请数据，出错：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据

        #region 自动生成数据
        /// <summary>
        /// 自动生成数据
        /// </summary>
        /// <returns></returns>
        private string AutoData()
        {
            try
            {
                string insur_seq_no = Post("insur_seq_no");
                if (string.IsNullOrWhiteSpace(insur_seq_no))
                    return "自动生成保险申请数据失败：参数不能为空！";
                Dictionary<string, string> param_pro_head = new Dictionary<string, string>();
                param_pro_head.Add("SEQ_NO", insur_seq_no);
                Insur_project_head project = InsurHandleClass.getInstance().GetInsurProjectHeadInfo(param_pro_head);
                if (project == null)
                    return "自动生成保险申请数据失败：项目信息为空！";
                //当为“医保”的时候，判断是否设置了 保险期限、金额
                if (project.INSUR_TYPE.Equals("A"))
                {
                    if (project.INSUR_LIMITDATE.Length == 0 || project.INSUR_MONEY.ToString().Length == 0)
                        return "自动生成保险申请数据失败：项目信息中承保期限、金额设置不能为空！";
                }
                Dictionary<string, string> param = new Dictionary<string, string>();
                List<Basic_stu_info> stuList = StuHandleClass.getInstance().GetStuInfoArray(param);
                if (stuList == null)
                    return "自动生成保险申请数据失败！";
                foreach (Basic_stu_info stu in stuList)
                {
                    if (stu == null)
                        continue;

                    //删除相同学号的数据
                    string strSelectSql = string.Format("SELECT SEQ_NO FROM INSUR_PROJECT_APPLY WHERE INSUR_SEQ_NO = '{0}' AND STU_NUMBER = '{1}' ", insur_seq_no, stu.NUMBER);
                    DataTable dt = ds.ExecuteTxtDataTable(strSelectSql);
                    if (dt != null && dt.Rows.Count != 0)
                    {
                        string strDeleteSql_Head = string.Format("DELETE FROM INSUR_PROJECT_APPLY WHERE SEQ_NO = '{0}' ", dt.Rows[0]["SEQ_NO"].ToString());
                        string strDeleteSql_Check = string.Format("DELETE FROM INSUR_APPLY_CHECK WHERE SEQ_NO = '{0}' ", dt.Rows[0]["SEQ_NO"].ToString());
                        ds.ExecuteTxtNonQuery(strDeleteSql_Head);
                        ds.ExecuteTxtNonQuery(strDeleteSql_Check);
                    }
                    //插入申请数据
                    Insur_project_apply head = InsertIntoApplyHead(project, stu);
                    //插入预先核对信息
                    InsertIntoCheckInfo(head.SEQ_NO, head.INSUR_LIMITDATE, head.INSUR_MONEY);
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "自动生成保险申请数据，出错：" + ex.ToString());
                return "自动生成保险申请数据失败！";
            }
        }

        #region 往申报表中插入数据

        /// <summary>
        /// 往申报表中插入数据
        /// </summary>
        /// <param name="project"></param>
        private Insur_project_apply InsertIntoApplyHead(Insur_project_head project, Basic_stu_info stu)
        {
            Insur_project_apply head = new Insur_project_apply();
            head.OID = Guid.NewGuid().ToString();
            head.SEQ_NO = BusDataDeclareTransaction.getInstance().GetSeq_no(CValue.DOC_TYPE_INS02);
            head.RET_CHANNEL = CValue.RET_CHANNEL_D4000;
            head.CHK_STATUS = CValue.CHK_STATUS_N;
            head.DOC_TYPE = CValue.DOC_TYPE_BDM03;
            head.CHK_TIME = GetDateLongFormater();
            head.DECL_TIME = GetDateLongFormater();
            head.DECLARE_TYPE = CValue.DECLARE_TYPE_D;
            head.INSUR_FLAG = "N";//保险信息为N；参保之后为Y
            #region 项目信息

            head.INSUR_SEQ_NO = project.SEQ_NO;
            head.INSUR_TYPE = project.INSUR_TYPE;
            head.INSUR_YEAR = project.INSUR_YEAR;
            head.INSUR_NAME = project.INSUR_NAME;
            head.INSUR_LIMITDATE = project.INSUR_LIMITDATE;
            head.INSUR_MONEY = project.INSUR_MONEY;

            #endregion 项目信息

            #region 保存学生信息

            //学生信息
            head.STU_NUMBER = stu.NUMBER;
            head.STU_NAME = stu.NAME;
            //学生信息
            if (stu.STUTYPE.Equals(CValue.USER_STUTYPE_B))
                head.STU_TYPE = CValue.USER_STUTYPE_B;
            else
                head.STU_TYPE = CValue.USER_STUTYPE_Y;
            head.STU_PHONE = stu.MOBILENUM;
            head.XY = stu.COLLEGE;
            head.ZY = stu.MAJOR;
            head.GRADE = stu.EDULENTH;
            head.CLASS_CODE = stu.CLASS;

            #endregion 保存学生信息

            ds.UpdateObject(head);
            return head;
        }

        #endregion 往奖助申报表中插入数据

        #region 预先插入保险核对信息
        /// <summary>
        /// 预先插入保险核对信息
        /// </summary>
        /// <param name="strSeqNo"></param>
        /// <param name="strOldLimitDate"></param>
        /// <param name="dOldMoney"></param>
        private void InsertIntoCheckInfo(string strSeqNo, string strOldLimitDate, decimal dOldMoney)
        {
            try
            {
                Insur_apply_check check = new Insur_apply_check();
                check.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(check);
                check.SEQ_NO = strSeqNo;
                check.OLD_INSUR_LIMITDATE = strOldLimitDate;
                check.OLD_INSUR_MONEY = dOldMoney;
                check.IS_REFUND = CValue.FLAG_N;
                ds.UpdateObject(check);
            }
            catch (Exception ex)
            {
                log.Error("预先插入保险核对信息，出错：" + ex.Message);
            }
        }
        #endregion

        #endregion
    }
}