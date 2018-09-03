using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.CHK
{
    /// <summary>
    /// 审核公共页
    /// </summary>
    public partial class Approve : Main
    {
        #region 初始化

        private comdata cod = new comdata();
        private string decl_type = string.Empty;
        public bool IsRevoke = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                decl_type = Request.QueryString["decltype"];
                if (decl_type.Equals(CValue.DECLARE_TYPE_R))
                    IsRevoke = true;
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "chk":
                            Response.Write(IsCanAudit());
                            Response.End();
                            break;

                        case "submit_approve":
                            Response.Write(ApproveData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 初始化

        #region 是否可以进行审批

        /// <summary>
        /// 是否可以进行审批
        /// </summary>
        /// <returns></returns>
        private string IsCanAudit()
        {
            if (string.IsNullOrEmpty(Get("doc_type")))
                return "单据类型不能为空！";
            if (string.IsNullOrEmpty(Get("seq_no")))
                return "单据编号不能为空！";
            string strOut = WKF_ExternalInterface.getInstance().ChkAudit(Get("doc_type"), Get("seq_no"), user.User_Role);
            if (string.IsNullOrEmpty(strOut))
                return string.Empty;
            else
                return strOut;
        }

        #endregion 是否可以进行审批

        #region 提交审核信息

        /// <summary>
        /// 提交审核信息
        /// </summary>
        /// <returns></returns>
        private string ApproveData()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("doc_type")))
                    return "单据类型不能为空！";
                if (string.IsNullOrEmpty(Get("seq_no")))
                    return "单据编号不能为空！";
                if (string.IsNullOrEmpty(Get("decltype")))
                    return "申请类型不能为空！";

                string strMsg = string.Empty;
                bool bResult = true;
                decl_type = Get("decltype");
                if (decl_type.Equals(CValue.DECLARE_TYPE_R))
                    bResult = WKF_ExternalInterface.getInstance().WKF_RevokeAudit(Get("doc_type"), Get("seq_no"), user.User_Id, user.User_Role, Post("approveType"), Post("approveMsg"), out strMsg);
                else
                    bResult = WKF_ExternalInterface.getInstance().WKF_Audit(Get("doc_type"), Get("seq_no"), user.User_Id, user.User_Role, Post("approveType"), Post("approveMsg"), out strMsg);

                if (!bResult)//审批成功
                    return "审批失败！";

                #region 审批通过之后给申请人发送信息

                //审批通过之后给申请人发送信息
                if (!string.IsNullOrEmpty(Get("msg_accpter")))
                {
                    string strFinalPosCode = WKF_AuditHandleCLass.getInstance().GetFinalPosCode(Get("doc_type"));
                    if (!string.IsNullOrEmpty(strFinalPosCode))
                    {
                        if (strFinalPosCode == user.User_Role)
                        {
                            string strMsgContent = string.Empty;
                            if (Post("approveType").ToString().Equals("P"))
                                strMsgContent = string.Format("{0}审批通过", cod.GetDDLTextByValue("ddl_doc_type", Get("doc_type")));
                            else
                                strMsgContent = string.Format("{0}审批不通过，审批意见：{1}", cod.GetDDLTextByValue("ddl_doc_type", Get("doc_type")), Post("approveMsg"));

                            Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                            dicAccpter.Add(Get("msg_accpter"), ComHandleClass.getInstance().ByUserIdGetUserName(Get("msg_accpter")));
                            MessgeHandleClass.getInstance().SendMessge("M", strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMsg);
                            if (strMsg.Length > 0)
                            {
                                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, strMsg);
                            }
                        }
                    }
                }

                #endregion 审批通过之后给申请人发送信息

                #region 编班审核或者撤销操作

                //ZZ 20171028 新增：编班审核或者撤销操作时使用
                if (Get("doc_type").Equals(CValue.DOC_TYPE_UA01))
                {
                    #region 撤销申请

                    if (decl_type.Equals(CValue.DECLARE_TYPE_R))//撤销申请
                    {
                        if (WKF_ClientRevokeHandleCLass.getInstance().IsRevokeSuccess(Get("doc_type"), user.User_Role))
                        {
                            #region 编班撤销之后，如果辅导员是研究生，需要去掉研究生的“辅导员角色”

                            //ZZ 20171027 新增：编班审批通过之后，如果辅导员是研究生，需要给研究生多分配一个“辅导员角色”
                            Ua_class_group class_group = UaGroupClassHandle.getInstance().GetUaClassGroup(Get("seq_no"));
                            if (class_group != null)
                            {
                                if (class_group.GROUP_TYPE.Equals("Y"))
                                {
                                    Ua_user user_group = new Ua_user();
                                    user_group.USER_ID = class_group.GROUP_NUMBER;
                                    ds.RetrieveObject(user_group);
                                    if (user_group != null)
                                    {
                                        if (user_group.USER_ROLE.Contains("F"))
                                        {
                                            user_group.USER_ROLE = "S";
                                            ds.UpdateObject(user_group);
                                        }
                                    }
                                }
                            }

                            #endregion 编班撤销之后，如果辅导员是研究生，需要去掉研究生的“辅导员角色”
                        }
                    }

                    #endregion 撤销申请

                    #region 业务申请

                    else//业务申请
                    {
                        string strFinalPosCode = WKF_AuditHandleCLass.getInstance().GetFinalPosCode(Get("doc_type"));
                        //编班审批通过之后，如果辅导员是研究生，需要给研究生多分配一个“辅导员角色”
                        if (!string.IsNullOrEmpty(strFinalPosCode))
                        {
                            if (strFinalPosCode == user.User_Role)
                            {
                                if (Post("approveType").ToString().Equals("P"))
                                {
                                    Ua_class_group class_group = UaGroupClassHandle.getInstance().GetUaClassGroup(Get("seq_no"));
                                    if (class_group.GROUP_TYPE.Equals("Y"))
                                    {
                                        Ua_user user_group = new Ua_user();
                                        user_group.USER_ID = class_group.GROUP_NUMBER;
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
                    }

                    #endregion 业务申请
                }

                #endregion 编班审核或者撤销操作

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "提交审核信息，出错：" + ex.ToString());
                return "审批失败！";
            }
        }

        #endregion 提交审核信息
    }
}