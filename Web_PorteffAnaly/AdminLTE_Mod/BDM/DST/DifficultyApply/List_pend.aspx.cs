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
    public partial class List_pend : ListBaseLoad<Dst_stu_apply>
    {
        #region 初始化

        private comdata cod = new comdata();
        public TableMapping TableMapp = new TableMapping();
        public Dst_stu_apply head = new Dst_stu_apply();
        public Basic_stu_info stu = new Basic_stu_info();
        public string m_strIsShowEditBtn = "false";//是否显示增删改提交按钮：显示true 不显示false
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
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
            {
                if (user.User_Role.Equals(CValue.ROLE_TYPE_F))
                {
                }
                else if (user.User_Role.Equals(CValue.ROLE_TYPE_Y))
                {
                    where += string.Format(" AND LEVEL1 = '{0}' ", Post("LEVEL_CODE"));
                }
                else if (user.User_Role.Equals(CValue.ROLE_TYPE_X))
                {
                    where += string.Format(" AND LEVEL2 = '{0}' ", Post("LEVEL_CODE"));
                }
                else
                    where += string.Format(" AND 1 = 2 ");
            }
            if (!string.IsNullOrEmpty(Post("DECLARE_TYPE")))
                where += string.Format(" AND DECLARE_TYPE = '{0}' ", Post("DECLARE_TYPE"));
            if (!string.IsNullOrEmpty(Post("RET_CHANNEL")))
                where += string.Format(" AND RET_CHANNEL = '{0}' ", Post("RET_CHANNEL"));
            if (!string.IsNullOrEmpty(Post("BATCH_NO")))
                where += string.Format(" AND BATCH_NO = '{0}' ", Post("BATCH_NO"));
            where += cod.GetDataFilterString(true, "OP_CODE", "CLASS", "COLLEGE");
            where += " AND " + DataFilterHandleClass.getInstance().Pend_DataFilter(user.User_Role, Doc_type);
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
                        case "getgrantlist":
                            Response.Write(GetGrantList());
                            Response.End();
                            break;
                        case "getmemberlist":
                            Response.Write(GetMemberList());
                            Response.End();
                            break;
                        case "chkmulti":
                            Response.Write(CheckMulti());
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
                yield return new NameValue() { Name = "RET_CHANNEL", Value = entity.RET_CHANNEL };
                yield return new NameValue() { Name = "RET_CHANNEL_NAME", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.RET_CHANNEL) };
                yield return new NameValue() { Name = "LEVEL_CODE_NAME", Value = cod.GetDDLTextByValue("ddl_dst_level", entity.LEVEL_CODE) };
                yield return new NameValue() { Name = "NATION_NAME", Value = cod.GetDDLTextByValue("ddl_mz", entity.NATION) };
                yield return new NameValue() { Name = "POLISTATUS_NAME", Value = cod.GetDDLTextByValue("ddl_zzmm", entity.POLISTATUS) };
                yield return new NameValue() { Name = "DECLARE_NAME", Value = cod.GetDDLTextByValue("ddl_DECLARE_TYPE", entity.DECLARE_TYPE) };

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
                yield return new NameValue() { Name = "PRE_LEVEL", Value = ConverPreLevel(entity.POS_CODE, entity.LEVEL1, entity.LEVEL2) };
                yield return new NameValue() { Name = "PRE_LEVEL_NAME", Value = cod.GetDDLTextByValue("ddl_dst_level", ConverPreLevel(entity.POS_CODE, entity.LEVEL1, entity.LEVEL2)) };
                yield return new NameValue() { Name = "BATCH_NO", Value = entity.BATCH_NO };
                yield return new NameValue() { Name = "BATCH_NAME", Value = cod.GetDDLTextByValue("ddl_batch", entity.BATCH_NO) };
            }
        }

        private string ConverPreLevel(string posCode, string level1, string level2)
        {
            //(CASE POS_CODE WHEN 'F' THEN '' WHEN 'Y' THEN  LEVEL1 WHEN 'X' THEN LEVEL2 END)
            if (posCode == "F")
                return "";
            else if (posCode == "Y")
                return level1;
            else if (posCode == "X")
                return level2;
            else
                return "";
        }

        #endregion 输出列表信息

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

        #region 获取家庭成员

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

        #endregion 获取家庭成员

        #region 判断是否可以批量审核

        private string CheckMulti()
        {
            #region 获得批量审核数据集合

            Dictionary<string, string> param = new Dictionary<string, string>();
            string filter = cod.GetDataFilterString(true, "OP_CODE", "CLASS", "COLLEGE");
            if (filter.Length > 0)
                param.Add(filter.Substring(4, filter.Length - 4), string.Empty);
            param.Add(string.Format(DataFilterHandleClass.getInstance().Pend_DataFilter(user.User_Role, CValue.DOC_TYPE_BDM01)), string.Empty);
            if (!string.IsNullOrEmpty(Get("COLLEGE")))
                param.Add("COLLEGE", Get("COLLEGE"));
            if (!string.IsNullOrEmpty(Get("MAJOR")))
                param.Add("MAJOR", Get("MAJOR"));
            if (!string.IsNullOrEmpty(Get("CLASS")))
                param.Add("CLASS", Get("CLASS"));
            if (!string.IsNullOrEmpty(Get("NAME")))
                param.Add(string.Format("NAME LIKE '%{0}%' ", HttpUtility.UrlDecode(Get("NAME"))), string.Empty);
            if (!string.IsNullOrEmpty(Get("SCHYEAR")))
                param.Add("SCHYEAR", Get("SCHYEAR"));
            if (!string.IsNullOrEmpty(Get("RET_CHANNEL")))
                param.Add("RET_CHANNEL", Get("RET_CHANNEL"));
            if (!string.IsNullOrEmpty(Get("DECLARE_TYPE")))
                param.Add("DECLARE_TYPE", Get("DECLARE_TYPE"));
            if (!string.IsNullOrEmpty(Get("LEVEL_CODE")))
            {
                if (user.User_Role.Equals(CValue.ROLE_TYPE_F))
                {
                }
                else if (user.User_Role.Equals(CValue.ROLE_TYPE_Y))
                {
                    param.Add("LEVEL1", Get("LEVEL_CODE"));
                }
                else if (user.User_Role.Equals(CValue.ROLE_TYPE_X))
                {
                    param.Add("LEVEL2", Get("LEVEL_CODE"));
                }
                else
                    param.Add("1", "2");
            }
            if (!string.IsNullOrEmpty(Get("NUMBER")))
                param.Add(string.Format("NUMBER LIKE '%{0}%' ", HttpUtility.UrlDecode(Get("NUMBER"))), string.Empty);
            if (!string.IsNullOrEmpty(Get("BATCH_NO")))
                param.Add("BATCH_NO", Get("BATCH_NO"));
            List<Dst_stu_apply> applyList = DstApplyHandleClass.getInstance().GetDst_stu_applyArray(param);
            if (applyList == null)
                return "查询批量审批申请数据出错！";

            #endregion 获得批量审核数据集合

            int i = 0;
            string ret_channel = string.Empty;
            string pos_code = string.Empty;
            string level = string.Empty;
            foreach (Dst_stu_apply apply in applyList)
            {
                if (apply.OID.Length == 0)
                    continue;

                if (apply.POS_CODE.Equals(WKF_VLAUES.POST_CODE_F))//辅导员不允许批量审核
                    return "不符合批量审核的条件！";

                if (!apply.DECLARE_TYPE.Equals(WKF_VLAUES.DECLARE_TYPE_D))
                {
                    return "不符合批量审核的条件，原因：选择的单据申请类型不一致！";
                }
                if (i > 0 && !(apply.RET_CHANNEL.Equals(ret_channel) && apply.POS_CODE.Equals(pos_code)))
                {
                    return "不符合批量审核的条件，原因：选择的单据审核状态不一致！";
                }

                if (i > 0 && !level.Equals(user.User_Role.Equals(CValue.ROLE_TYPE_Y) ? apply.LEVEL1 : apply.LEVEL2))
                {
                    return "不符合批量审核的条件，原因：选择的单据前级推荐档次不一致！";
                }

                ret_channel = apply.RET_CHANNEL;
                pos_code = apply.POS_CODE;
                if (user.User_Role.Equals(CValue.ROLE_TYPE_Y))
                    level = apply.LEVEL1;
                else if (user.User_Role.Equals(CValue.ROLE_TYPE_X))
                    level = apply.LEVEL2;

                i++;
            }

            return string.Format("{0}^{1}", pos_code, level);
        }

        #endregion 判断是否可以批量审核
    }
}