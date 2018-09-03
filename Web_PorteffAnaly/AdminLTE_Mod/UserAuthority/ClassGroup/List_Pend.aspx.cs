using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;
using HQ.WebForm.Kernel;

namespace PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.ClassGroup
{
    /// <summary>
    /// 待处理
    /// </summary>
    public partial class List_Pend : Main
    {
        #region 初始化

        private comdata cod = new comdata();
        private datatables tables = new datatables();

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
                            Response.Write(GetListData());
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

        #region 自定义获取查询列表

        private string GetListData()
        {
            Hashtable ddl = new Hashtable();
            ddl["STEP_NO_NAME"] = "ddl_STEP_NO";//单据流转环节
            ddl["CHK_STATUS_NAME"] = "ddl_CHK_STATUS";//单据锁单状态
            ddl["DECLARE_TYPE_NAME"] = "ddl_DECLARE_TYPE";//单据申请类型
            ddl["RET_CHANNEL_NAME"] = "ddl_RET_CHANNEL";//单据回执状态
            ddl["GROUP_TYPE_NAME"] = "ddl_group_type";
            ddl["XY_NAME"] = "ddl_department";
            ddl["ZY_NAME"] = "ddl_zy";
            ddl["GRADE_NAME"] = "ddl_grade";
            ddl["STU_TYPE_NAME"] = "ddl_basic_stu_type";
            string where = string.Empty;
            where += cod.GetDataFilterString(true, "DECL_NUMBER", "CLASSCODE", "XY");
            where += GetSearchWhere(where);
            string from_type = Request.QueryString["from_type"];
            if (!string.IsNullOrEmpty(from_type))
            {
                if (from_type.Equals("pend"))
                    //未处理数据过滤
                    where += " AND " + DataFilterHandleClass.getInstance().Pend_DataFilter(user.User_Role, CValue.DOC_TYPE_UA01);
                else
                    //已处理数据过滤
                    where += " AND " + DataFilterHandleClass.getInstance().Proc_DataFilter(user.User_Role, CValue.DOC_TYPE_UA01);
            }
            return tables.GetCmdQueryData("Get_Approve_ClassGrouplist", null, where, string.Empty, ddl);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public string GetSearchWhere(string where)
        {
            if (!string.IsNullOrEmpty(Post("XY")))
                where += string.Format(" AND XY = '{0}' ", Post("XY"));
            if (!string.IsNullOrEmpty(Post("ZY")))
                where += string.Format(" AND ZY = '{0}' ", Post("ZY"));
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("CLASSCODE")))
                where += string.Format(" AND CLASSCODE = '{0}' ", Post("CLASSCODE"));
            if (!string.IsNullOrEmpty(Post("GROUP_NUMBER")))
                where += string.Format(" AND GROUP_NUMBER LIKE '%{0}%' ", Post("GROUP_NUMBER"));
            if (!string.IsNullOrEmpty(Post("GROUP_NAME")))
                where += string.Format(" AND GROUP_NAME LIKE '%{0}%' ", Post("GROUP_NAME"));
            if (!string.IsNullOrEmpty(Post("GROUP_TYPE")))
                where += string.Format(" AND GROUP_TYPE = '{0}' ", Post("GROUP_TYPE"));
            if (!string.IsNullOrEmpty(Post("RET_CHANNEL")))
                where += string.Format(" AND RET_CHANNEL = '{0}' ", Post("RET_CHANNEL"));
            if (!string.IsNullOrEmpty(Post("STU_TYPE")))
                where += string.Format(" AND STU_TYPE = '{0}' ", Post("STU_TYPE"));
            if (!string.IsNullOrEmpty(Post("DECLARE_TYPE")))
                where += string.Format(" AND DECLARE_TYPE = '{0}' ", Post("DECLARE_TYPE"));
            return where;
        }

        #endregion 自定义获取查询列表

        #region 批量审批

        /// <summary>
        /// 批量审批
        /// </summary>
        /// <returns></returns>
        private string MultiPAudit()
        {
            try
            {
                string strFlag = Get("flag");
                string[] strs = Get("ids").Split(',');
                for (int i = 0; i < strs.Length; i++)
                {
                    #region 审批操作

                    if (strs[i].Length == 0)
                        continue;
                    Ua_class_group head = new Ua_class_group();
                    head.OID = strs[i];
                    ds.RetrieveObject(head);
                    string strMsg = WKF_ExternalInterface.getInstance().ChkAudit(head.DOC_TYPE, head.SEQ_NO, user.User_Role);
                    if (strMsg.Length > 0)
                        continue;
                    strMsg = string.Empty;
                    string strOpNote = string.Format("{0}在{1}操作：编班批量审批{2}", user.User_Id, GetDateLongFormater(), strFlag.Equals("P") ? "通过" : "不通过");
                    if (!WKF_ExternalInterface.getInstance().WKF_Audit(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, strFlag, strOpNote, out strMsg))
                    {
                        LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, string.Format("单据编号{0}编班审核失败，原因", head.SEQ_NO) + strMsg);
                        continue;
                    }

                    #endregion 审批操作

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

                            string strMsgContent = "编班审批：" + cod.GetDDLTextByValue("ddl_class", head.GROUP_CLASS) + strApproveInfo;
                            Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                            dicAccpter.Add(head.DECL_NUMBER, ComHandleClass.getInstance().ByUserIdGetUserName(head.DECL_NUMBER));
                            MessgeHandleClass.getInstance().SendMessge("M", strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMsg);
                        }
                    }

                    #endregion 审批通过之后给申请人发送信息

                    #region 编班审批通过之后，如果辅导员是研究生，需要给研究生多分配一个“辅导员角色”

                    //ZZ 20171027 新增：编班审批通过之后，如果辅导员是研究生，需要给研究生多分配一个“辅导员角色”
                    if (!string.IsNullOrEmpty(strFinalPosCode))
                    {
                        if (strFinalPosCode == user.User_Role)
                        {
                            if (strFlag.ToString().Equals("P"))
                            {
                                if (head.GROUP_TYPE.Equals("Y"))
                                {
                                    Ua_user user_group = new Ua_user();
                                    user_group.USER_ID = head.GROUP_NUMBER;
                                    ds.RetrieveObject(user_group);
                                    if (user_group != null)
                                    {
                                        if (!user_group.USER_ROLE.Contains("F"))
                                        {
                                            user_group.USER_ROLE = "S,F";
                                            ds.UpdateObject(user_group);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    #endregion 编班审批通过之后，如果辅导员是研究生，需要给研究生多分配一个“辅导员角色”
                }

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "编班审批失败：" + ex.ToString());
                return "批量审批失败！";
            }
        }

        #endregion 批量审批
    }
}