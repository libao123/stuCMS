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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter
{
    public partial class List : ListBaseLoad<Basic_stu_info_modi>
    {
        #region 初始化

        private comdata cod = new comdata();

        protected override string input_code_column
        {
            get { return "NUMBER"; }
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

        protected override SelectTransaction<Basic_stu_info_modi> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Basic_stu_info_modi>("Basic_stu_info_modiSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("NUMBER")))
                where += string.Format(" AND NUMBER LIKE '%{0}%' ", Post("NUMBER"));
            if (!string.IsNullOrEmpty(Post("NAME")))
                where += string.Format(" AND NAME LIKE '%{0}%' ", Post("NAME"));
            if (!string.IsNullOrEmpty(Post("IDCARDNO")))
                where += string.Format(" AND IDCARDNO LIKE '%{0}%' ", Post("IDCARDNO"));
            if (!string.IsNullOrEmpty(Post("COLLEGE")))
                where += string.Format(" AND COLLEGE = '{0}' ", Post("COLLEGE"));
            if (!string.IsNullOrEmpty(Post("MAJOR")))
                where += string.Format(" AND MAJOR = '{0}' ", Post("MAJOR"));
            if (!string.IsNullOrEmpty(Post("CLASS")))
                where += string.Format(" AND CLASS = '{0}' ", Post("CLASS"));
            if (!string.IsNullOrEmpty(Post("RET_CHANNEL")))
                where += string.Format(" AND RET_CHANNEL = '{0}' ", Post("RET_CHANNEL"));
            return where;
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
                        case "iscanaudit":
                            Response.Write(IsCanAudit());
                            Response.End();
                            break;
                        case "multiaudit"://批量审批
                            Response.Write(MultiPAudit());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Basic_stu_info_modi entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "NUMBER", Value = entity.NUMBER };
            yield return new NameValue() { Name = "NAME", Value = entity.NAME };
            yield return new NameValue() { Name = "IDCARDNO", Value = entity.IDCARDNO };
            yield return new NameValue() { Name = "GARDE", Value = entity.GARDE };
            yield return new NameValue() { Name = "CLASS", Value = entity.CLASS };
            yield return new NameValue() { Name = "SEX", Value = entity.SEX };
            yield return new NameValue() { Name = "COLLEGE", Value = entity.COLLEGE };
            yield return new NameValue() { Name = "MAJOR", Value = entity.MAJOR };
            yield return new NameValue() { Name = "NATION", Value = entity.NATION };
            yield return new NameValue() { Name = "POLISTATUS", Value = entity.POLISTATUS };
            yield return new NameValue() { Name = "DOC_TYPE", Value = entity.DOC_TYPE };
            yield return new NameValue() { Name = "CLASS_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS) };
            yield return new NameValue() { Name = "SEX_NAME", Value = cod.GetDDLTextByValue("ddl_xb", entity.SEX) };
            yield return new NameValue() { Name = "COLLEGE_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.COLLEGE) };
            yield return new NameValue() { Name = "MAJOR_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.MAJOR) };
            yield return new NameValue() { Name = "NATION_NAME", Value = cod.GetDDLTextByValue("ddl_mz", entity.NATION) };
            yield return new NameValue() { Name = "POLISTATUS_NAME", Value = cod.GetDDLTextByValue("ddl_zzmm", entity.POLISTATUS) };
            yield return new NameValue() { Name = "RET_CHANNEL", Value = entity.RET_CHANNEL };
            yield return new NameValue() { Name = "RET_CHANNEL_NAME", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.RET_CHANNEL) };
        }

        #endregion 输出列表信息

        #region 判断是否允许审批

        private string IsCanAudit()
        {
            string seq_no = Get("seq_no");
            string doc_type = Get("doc_type");
            string ret_channel = Get("ret_channel");
            if (ret_channel.Equals(WKF_VLAUES.RET_CHANNEL_D4000) || ret_channel.Equals(WKF_VLAUES.RET_CHANNEL_A0000))
                return "false";

            string strOut = WKF_ExternalInterface.getInstance().ChkAudit(doc_type, seq_no, user.User_Role);
            if (string.IsNullOrEmpty(strOut))
                return "true";
            else
                return "false";
        }

        #endregion 判断是否允许审批

        #region 批量审批

        /// <summary>
        /// 批量审批
        /// </summary>
        /// <returns></returns>
        private string MultiPAudit()
        {
            string strFlag = Get("flag");
            string[] strs = Get("ids").Split(',');
            for (int i = 0; i < strs.Length; i++)
            {
                #region 审核操作

                if (strs[i].Length == 0)
                    continue;
                Basic_stu_info_modi head = new Basic_stu_info_modi();
                head.OID = strs[i];
                ds.RetrieveObject(head);
                if (head.RET_CHANNEL.Equals(WKF_VLAUES.RET_CHANNEL_D4000) || head.RET_CHANNEL.Equals(WKF_VLAUES.RET_CHANNEL_A0000))
                    continue;

                string strMsg = WKF_ExternalInterface.getInstance().ChkAudit(head.DOC_TYPE, head.SEQ_NO, user.User_Role);
                if (strMsg.Length > 0)
                    continue;
                strMsg = string.Empty;
                string strOpNote = string.Format("{0}在{1}操作：学生信息修改批量审批{2}", user.User_Id, GetDateLongFormater(), strFlag.Equals("P") ? "通过" : "不通过");
                if (!WKF_ExternalInterface.getInstance().WKF_Audit(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, strFlag, strOpNote, out strMsg))
                {
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, strMsg);
                }

                #endregion 审核操作

                #region 审批通过之后给申请人发送信息

                //审批通过之后给申请人发送信息

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

                        string strMsgContent = "学生信息修改：" + strApproveInfo;
                        Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                        dicAccpter.Add(head.NUMBER, head.NAME);
                        MessgeHandleClass.getInstance().SendMessge("M", strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMsg);
                    }
                }

                #endregion 审批通过之后给申请人发送信息
            }

            return string.Empty;
        }

        #endregion 批量审批
    }
}