using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;
using HQ.WebForm.Kernel;
using PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.Common;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.DifficultyApply
{
    public partial class List_proc : ListBaseLoad<Dst_stu_apply>
    {
        #region 初始化

        private comdata cod = new comdata();
        public TableMapping TableMapp = new TableMapping();
        public Dst_stu_apply head = new Dst_stu_apply();
        public Basic_stu_info stu = new Basic_stu_info();
        public string m_strIsShowEditBtn = "false";//是否显示增删改提交按钮：显示true 不显示false
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public Dst_param_info param_info = new Dst_param_info();
        public ComHandleClass comHandle = new ComHandleClass();
        private ComTranClass comTran = new ComTranClass();

        public override string Doc_type { get { return CValue.DOC_TYPE_BDM01; } }

        #endregion 初始化

        #region 辅助页面加载

        protected override string input_code_column
        {
            get { return "OP_CODE"; }
        }

        protected override string class_code_column
        {
            get { return "CLASS"; }
        }

        protected override string xy_code_column
        {
            get { return "COLLEGE"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Dst_stu_apply> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Dst_stu_apply>("Dst_stu_applySelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("COLLEGE")))
                where += string.Format(" AND COLLEGE = '{0}' ", Post("COLLEGE"));
            if (!string.IsNullOrEmpty(Post("MAJOR")))
                where += string.Format(" AND MAJOR = '{0}' ", Post("MAJOR"));
            if (!string.IsNullOrEmpty(Post("CLASS")))
                where += string.Format(" AND CLASS = '{0}' ", Post("CLASS"));
            if (!string.IsNullOrEmpty(Post("NAME")))
                where += string.Format(" AND NAME LIKE '%{0}%' ", Post("NAME"));
            if (!string.IsNullOrEmpty(Post("NUMBER")))
                where += string.Format(" AND NUMBER LIKE '%{0}%' ", Post("NUMBER"));
            if (!string.IsNullOrEmpty(Post("SCHYEAR")))
                where += string.Format(" AND SCHYEAR = '{0}' ", Post("SCHYEAR"));
            if (!string.IsNullOrEmpty(Post("LEVEL_CODE")))
                where += string.Format(" AND LEVEL_CODE = '{0}' ", Post("LEVEL_CODE"));
            if (!string.IsNullOrEmpty(Post("DECLARE_TYPE")))
                where += string.Format(" AND DECLARE_TYPE = '{0}' ", Post("DECLARE_TYPE"));
            if (!string.IsNullOrEmpty(Post("RET_CHANNEL")))
                where += string.Format(" AND RET_CHANNEL = '{0}' ", Post("RET_CHANNEL"));
            if (!string.IsNullOrEmpty(Post("BATCH_NO")))
                where += string.Format(" AND BATCH_NO = '{0}' ", Post("BATCH_NO"));
            where += string.Format(" AND {0} ", DataFilterHandleClass.getInstance().Proc_DataFilter(user.User_Role, Doc_type));
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
                param_info = DstParamHandleClass.getInstance().GetDst_param_info(new Dictionary<string, string> { { "SCHYEAR", sch_info.CURRENT_YEAR }, { "DECLARE_FLAG", HQ.Model.CValue.FLAG_Y } });

                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "getlist":
                            Response.Write(GetList());
                            Response.End();
                            break;
                        case "checkadd":
                            Response.Write(CheckOperate("add"));
                            Response.End();
                            break;
                        case "checkmodi":
                            Response.Write(CheckOperate("modi"));
                            Response.End();
                            break;
                        case "checkdel":
                            Response.Write(CheckOperate("del"));
                            Response.End();
                            break;
                        case "checkdecl":
                            Response.Write(CheckOperate("decl"));
                            Response.End();
                            break;
                        case "checkrevoke":
                            Response.Write(CheckOperate("revoke"));
                            Response.End();
                            break;
                        case "checkchg":
                            Response.Write(CheckOperate("change"));
                            Response.End();
                            break;
                        case "delete":
                            Response.Write(DeleteData());
                            Response.End();
                            break;
                        case "selectstu":
                            Response.Write(SelectStudent());
                            Response.End();
                            break;
                        case "select":
                            Response.Write(GetStudentData());
                            Response.End();
                            break;
                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;
                        case "getgrantlist":
                            Response.Write(GetGrantList());
                            Response.End();
                            break;
                        case "delgrant":
                            Response.Write(DeleteGrant());
                            Response.End();
                            break;
                        case "savegrant":
                            Response.Write(SaveGrant());
                            Response.End();
                            break;
                        case "getmemberlist":
                            Response.Write(GetMemberList());
                            Response.End();
                            break;
                        case "change":
                            Response.Write(ChangeLevel());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Dst_stu_apply entity)
        {
            {
                yield return new NameValue() { Name = "SCHYEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.SCHYEAR) };
                yield return new NameValue() { Name = "SEX_NAME", Value = cod.GetDDLTextByValue("ddl_xb", entity.SEX) };
                yield return new NameValue() { Name = "COLLEGE_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.COLLEGE) };
                yield return new NameValue() { Name = "MAJOR_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.MAJOR) };
                yield return new NameValue() { Name = "CLASS_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS) };
                yield return new NameValue() { Name = "DECLARE_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_DECLARE_TYPE", entity.DECLARE_TYPE) };
                yield return new NameValue() { Name = "RET_CHANNEL_NAME", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.RET_CHANNEL) };
                yield return new NameValue() { Name = "LEVEL_CODE_NAME", Value = cod.GetDDLTextByValue("ddl_dst_level", entity.LEVEL_CODE) };
                yield return new NameValue() { Name = "NATION_NAME", Value = cod.GetDDLTextByValue("ddl_mz", entity.NATION) };
                yield return new NameValue() { Name = "POLISTATUS_NAME", Value = cod.GetDDLTextByValue("ddl_zzmm", entity.POLISTATUS) };

                yield return new NameValue() { Name = "OID", Value = entity.OID };
                yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
                yield return new NameValue() { Name = "DOC_TYPE", Value = entity.DOC_TYPE };
                yield return new NameValue() { Name = "SERIAL_NO", Value = entity.SERIAL_NO };
                yield return new NameValue() { Name = "SCHYEAR", Value = entity.SCHYEAR };
                yield return new NameValue() { Name = "NUMBER", Value = entity.NUMBER };
                yield return new NameValue() { Name = "NAME", Value = entity.NAME };
                yield return new NameValue() { Name = "COLLEGE", Value = entity.COLLEGE };
                yield return new NameValue() { Name = "CLASS", Value = entity.CLASS };
                yield return new NameValue() { Name = "MAJOR", Value = entity.MAJOR };
                yield return new NameValue() { Name = "DECL_TIME", Value = entity.DECL_TIME };
                yield return new NameValue() { Name = "CHK_TIME", Value = entity.CHK_TIME };
                yield return new NameValue() { Name = "CHK_STATUS", Value = entity.CHK_STATUS };
                yield return new NameValue() { Name = "RET_CHANNEL", Value = entity.RET_CHANNEL };
                yield return new NameValue() { Name = "POS_CODE", Value = entity.POS_CODE };
                yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
                yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
                yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
                yield return new NameValue() { Name = "LEVEL1", Value = entity.LEVEL1 };
                yield return new NameValue() { Name = "LEVEL2", Value = entity.LEVEL2 };
                yield return new NameValue() { Name = "LEVEL3", Value = entity.LEVEL3 };
                yield return new NameValue() { Name = "LEVEL_CODE", Value = entity.LEVEL_CODE };
                yield return new NameValue() { Name = "DECLARE_TYPE", Value = entity.DECLARE_TYPE };
                yield return new NameValue() { Name = "STEP_NO", Value = entity.STEP_NO };
                yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
                yield return new NameValue() { Name = "AUDIT_POS_CODE", Value = entity.AUDIT_POS_CODE };
                yield return new NameValue() { Name = "BATCH_NO", Value = entity.BATCH_NO };
                yield return new NameValue() { Name = "BATCH_NAME", Value = cod.GetDDLTextByValue("ddl_batch", entity.BATCH_NO) };
            }
        }

        #endregion 输出列表信息

        #region 判断是否允许操作

        private string CheckOperate(string strFlag)
        {
            string result = string.Empty;
            string need = string.Empty;
            bool can = DstParamHandleClass.getInstance().IsCanApply(out result, out need);
            string oid = Get("id");
            string number = Get("number");
            if (!strFlag.Equals("add") && string.IsNullOrEmpty(oid))
                return "主键不能为空！";

            Dst_stu_apply apply = new Dst_stu_apply();
            apply.OID = oid;
            ds.RetrieveObject(apply);

            if (strFlag.Equals("add"))
            {
                if (!can && result.Length == 0)
                {
                    result = "未开放申请，请联系管理员！";
                }
                else
                {
                    if (need.Equals("Y"))
                    {
                        object o = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM DST_FAMILY_SITUA WHERE NUMBER='{0}' AND RET_CHANNEL='{1}'", number, CValue.RET_CHANNEL_A0010));
                        if (o == null || o.ToString().Length == 0)
                            result = "未完成家庭情况调查！";
                    }
                }
                head = DstApplyHandleClass.getInstance().GetDst_stu_apply(new Dictionary<string, string> { { "NUMBER", number }, { "SCHYEAR", sch_info.CURRENT_YEAR } });
                if (head != null)
                    result = "不允许重复申请！";

                return result;
            }
            else if (strFlag.Equals("modi") || strFlag.Equals("del") || strFlag.Equals("decl"))
            {
                if (!(apply.RET_CHANNEL.Equals(CValue.RET_CHANNEL_A0000)))
                    return "该状态下不允许操作！";
            }
            else if (strFlag.Equals("revoke"))
            {
                //辅导员审核前学生自行撤销
                if (user.User_Role.Equals(CValue.ROLE_TYPE_S))
                {
                    if (apply.POS_CODE.Equals(CValue.ROLE_TYPE_F) && !apply.NUMBER.Equals(user.User_Id))
                        return "非本人不允许进行操作！";
                    if (!(apply.RET_CHANNEL.Equals(CValue.RET_CHANNEL_D1000) && apply.POS_CODE.Equals(CValue.ROLE_TYPE_F)))
                        return "该状态下不允许撤销！";
                }
            }
            else if (strFlag.Equals("change"))
            {
                #region 修改等级
                if (!can)
                    return "未开放申请，请联系管理员！";
                if (string.IsNullOrEmpty(apply.LEVEL_CODE) || !apply.DECLARE_TYPE.Equals(WKF_VLAUES.DECLARE_TYPE_D) || !apply.RET_CHANNEL.Equals(WKF_VLAUES.RET_CHANNEL_D4000) || apply.CHK_STATUS.Equals(CValue.CHK_STATUS_Y))
                    return "该状态下不允许操作！";
                if (apply.LEVEL_CODE.Equals("A"))
                    return "已经是最高等级，不允许操作！";
                #endregion
            }

            return result;
        }

        #endregion 判断是否允许操作

        #region 删除数据

        private string DeleteData()
        {
            var code = Get("id");
            if (string.IsNullOrEmpty(code)) return "主键为空,不允许删除操作";

            head.OID = code;
            ds.RetrieveObject(head);

            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Dst_stu_apply>("Dst_stu_applyDeleteTransaction");
            transaction.EntityList.Add(head);
            bDel = transaction.Commit();

            if (!bDel)
                return "删除失败！";
            else
                return "";
        }

        #endregion 删除数据

        #region 选择学生页面数据加载

        private string SelectStudent()
        {
            string where = "";
            if (!string.IsNullOrEmpty(Post("sel-NUMBER")))
                where += string.Format(" AND NUMBER LIKE '%{0}%' ", Post("sel-NUMBER"));
            if (!string.IsNullOrEmpty(Post("sel-NAME")))
                where += string.Format(" AND NAME LIKE '%{0}%' ", Post("sel-NAME"));
            datatables dts = new datatables();
            return dts.GetCmdQueryData("GET_STU_INFO", null, where, "", null);
        }

        #endregion 选择学生页面数据加载

        #region 根据学号获取学生基本信息

        private string GetStudentData()
        {
            string strNumber = Get("number");
            if (string.IsNullOrEmpty(strNumber))
                return "学号为空";

            head = DstApplyHandleClass.getInstance().GetDst_stu_apply(new Dictionary<string, string> { { "NUMBER", strNumber }, { "SCHYEAR", sch_info.CURRENT_YEAR } });
            if (head == null)
            {
                head = new Dst_stu_apply();
                object o = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM Basic_stu_info WHERE NUMBER = '{0}'", strNumber));
                if (o != null && o.ToString().Trim().Length > 0)
                {
                    stu.OID = o.ToString();
                    ds.RetrieveObject(stu);
                    CreateNewData();
                }
            }

            StringBuilder sb = new StringBuilder();
            sb.Append("{");
            foreach (var val in GetValue(head))
            {
                sb.Append(Json.StringToJson(val.Value, val.Name));
                sb.Append(",");
            }
            sb.Remove(sb.Length - 1, 1);//去掉最后一个逗号
            sb.Append("},");
            if (sb[sb.Length - 1].Equals(','))
            {
                sb.Remove(sb.Length - 1, 1);//去掉最后一个逗号
            }

            return sb.ToString();
        }

        #endregion 根据学号获取学生基本信息

        #region 新增数据

        private bool CreateNewData()
        {
            head.NUMBER = stu.NUMBER;
            head.NAME = stu.NAME;
            head.SEX = stu.SEX;
            head.BIRTH_DATE = stu.GARDE;
            head.NATION = stu.NATION;
            head.IDCARDNO = stu.IDCARDNO;
            head.POLISTATUS = stu.POLISTATUS;
            head.COLLEGE = stu.COLLEGE;
            head.MAJOR = stu.MAJOR;
            head.CLASS = stu.CLASS;
            head.GRADE = stu.EDULENTH;
            head.TELEPHONE = stu.MOBILENUM;
            head.HOME_ADDRESS = stu.ADDRESS;
            head.HOME_PHONE = stu.HOMENUM;
            head.SCHYEAR = sch_info.CURRENT_YEAR;
            head.OID = Guid.NewGuid().ToString();
            head.SEQ_NO = GetSeq_no();
            head.DOC_TYPE = this.Doc_type;
            head.RET_CHANNEL = Ret_Channel_A0000;
            head.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            head.OP_CODE = user.User_Id;
            head.OP_NAME = user.User_Name;
            GetIncome(stu.NUMBER);
            var inserttrcn = ImplementFactory.GetInsertTransaction<Dst_stu_apply>("Dst_stu_applyInsertTransaction");
            inserttrcn.EntityList.Add(head);
            return inserttrcn.Commit();
        }

        #endregion 新增数据

        #region 计算年收入、月收入

        private string GetIncome(string number)
        {
            if (!string.IsNullOrEmpty(number))
            {
                Dst_family_situa situa = FamilySurveyHandleClass.getInstance().GetDst_family_situa(new Dictionary<string, string> { { "NUMBER", number } });
                if (situa != null)
                {
                    head.SERIAL_NO = situa.SERIAL_NO;
                    DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT SUM(INCOME) INCOME,COUNT(1) QTY FROM DST_FAMILY_MEMBERS WHERE SEQ_NO='{0}'", situa.SEQ_NO));
                    if (dt != null && dt.Rows.Count == 1)
                    {
                        head.ANNUAL_INCOME = comTran.ToDecimal(dt.Rows[0]["INCOME"].ToString());
                        head.MONTHLY_INCOME = (situa.FAMILY_SIZE > 0) ? Math.Round(head.ANNUAL_INCOME / situa.FAMILY_SIZE / 12, 2) : 0;
                    }
                }
            }
            return head.ANNUAL_INCOME.ToString() + "*" + head.MONTHLY_INCOME.ToString();
        }

        #endregion 计算年收入、月收入

        #region 保存

        private string SaveData()
        {
            try
            {
                head.OID = Post("OID");
                if (head.OID == "")
                {
                    head.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(head);
                    head.SEQ_NO = GetSeq_no();
                }
                else
                {
                    ds.RetrieveObject(head);
                }
                head.APPLY_REASON = Post("APPLY_REASON");
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

        #region 获取奖励、资助情况

        private string GetGrantList()
        {
            Hashtable hs = new Hashtable();
            var ddl = new Hashtable();
            ddl["SCHOOL_YEAR_NAME"] = "ddl_year_type";
            string where = string.Format("SEQ_NO='{0}'", Get("seq_no"));
            datatables dts = new datatables();
            string result = dts.GetCmdQueryData("GET_STU_GRANT", hs, where, string.Empty, ddl);
            return result;
        }

        #endregion 获取奖励、资助情况

        #region 删除获取奖励、资助情况数据

        private string DeleteGrant()
        {
            Dst_stu_grant grant = new Dst_stu_grant();
            var code = Get("id");
            if (string.IsNullOrEmpty(code)) return "主键为空,不允许删除操作";

            grant.OID = code;
            ds.RetrieveObject(grant);

            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Dst_stu_grant>("Dst_stu_grantDeleteTransaction");
            transaction.EntityList.Add(grant);
            bDel = transaction.Commit();
            if (!bDel)
                return "删除失败！";
            else
                return "";
        }

        #endregion 删除获取奖励、资助情况数据

        #region 保存奖助

        private string SaveGrant()
        {
            try
            {
                Dst_stu_grant grant = new Dst_stu_grant();
                grant.OID = Post("OID");
                if (grant.OID == "")
                {
                    grant.OID = Guid.NewGuid().ToString();
                }
                ds.RetrieveObject(grant);
                grant.SEQ_NO = Get("seq_no");
                grant.ITEM = Post("ITEM");
                grant.RANK = Post("RANK");
                grant.SCHOOL_YEAR = Post("SCHOOL_YEAR");

                ds.UpdateObject(grant);
                return grant.OID + ";" + grant.SEQ_NO;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        #endregion 保存奖助

        private string GetMemberList()
        {
            Hashtable hs = new Hashtable();
            var ddl = new Hashtable();
            ddl.Add("RELATION", "ddl_relation");
            ddl.Add("PROFESSION", "ddl_profession");
            string where = string.Format(" NUMBER='{0}'", Get("number"));
            datatables dts = new datatables();
            string result = dts.GetCmdQueryData("GET_STU_MEMBER", hs, where, string.Empty, ddl);
            return result;
        }

        #region 修改等级

        private string ChangeLevel()
        {
            string msg = string.Empty;
            try
            {
                string oid = Get("id");
                string chg_lvl = Get("level");
                if (oid.Length == 0)
                    return "主键为空";
                Dst_stu_apply apply = new Dst_stu_apply();
                apply.OID = oid;
                ds.RetrieveObject(apply);
                if (Convert(chg_lvl) >= Convert(apply.LEVEL_CODE))
                    return "只能修改为更高等级";

                string opinion = cod.GetDDLTextByValue("ddl_dst_opinion", chg_lvl);
                string strSql = string.Format("UPDATE DST_STU_APPLY SET IS_CHG_LVL = 'Y', BATCH_NO = '{1}', LEVEL_CODE = '{2}', LEVEL1 = '{2}', LEVEL2 = '{2}', LEVEL3 = '{2}', OPINION1 = '{3}', OPINION2 = '{3}', OPINION3 = '{3}' WHERE OID = '{0}'", oid, param_info != null ? param_info.BATCH_NO : string.Empty, chg_lvl, opinion);
                if (ds.ExecuteTxtNonQuery(strSql) > 0)
                {
                    //插入一条修改记录
                    WKF_ClientLogHandleCLass.getInstance().InsertClientLog(apply.SEQ_NO, CValue.DOC_TYPE_BDM01, CValue.DECLARE_TYPE_C, string.Empty, "修改成功", user.User_Role, user.User_Name, Get("notes"), CValue.FLAG_Y);
                }
                else
                    msg = "修改等级失败";
            }
            catch (Exception ex)
            {
                msg = "修改等级失败";
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "修改等级出错：" + ex.ToString());
            }

            return msg;
        }

        private int Convert(string value)
        {
            byte[] array = new byte[1];
            array = System.Text.Encoding.ASCII.GetBytes(value);
            int asciicode = (short)(array[0]);
            return asciicode;
        }

        #endregion
    }
}