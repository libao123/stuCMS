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
    public partial class Revoke : Main
    {
        #region 页面加载

        private comdata cod = new comdata();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "chk"://是否可以自行撤销
                            Response.Write(IsCanRevoke());
                            Response.End();
                            break;

                        case "chkdecl"://是否可以进行撤销申请
                            Response.Write(IsCanRevokeDeclare());
                            Response.End();
                            break;

                        case "revoke"://自行撤销
                            Response.Write(RevokeData());
                            Response.End();
                            break;

                        case "submit_revoke"://提交撤销申请
                            Response.Write(SubmitRevokeData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 是否可以自行撤销

        /// <summary>
        /// 是否可以自行撤销
        /// </summary>
        /// <returns></returns>
        private string IsCanRevoke()
        {
            try
            {
                string strOut = WKF_ExternalInterface.getInstance().ChkRevokeBySelf(Get("doc_type"), Get("seq_no"), user.User_Role, user.User_Id, Get("col_name"));
                if (string.IsNullOrEmpty(strOut))
                    return string.Empty;
                else
                    return strOut;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "是否可以自行撤销，出错：" + ex.ToString());
                return "不符合撤销要求！";
            }
        }

        #endregion 是否可以自行撤销

        #region 自行撤销

        /// <summary>
        /// 自行撤销
        /// </summary>
        /// <returns></returns>
        private string RevokeData()
        {
            try
            {
                string msg = string.Empty;
                string op_notes = string.Format("{0}自行撤销", cod.GetDDLTextByValue("ddl_ua_role", user.User_Role));
                bool bResult = WKF_ExternalInterface.getInstance().WKF_RevokeDeclare(Get("doc_type"), Get("seq_no"), user.User_Id, user.User_Role, op_notes, Get("nj"), Get("xy"), Get("bj"), Get("zy"), false, out msg);
                if (bResult)
                {
                    if (Get("doc_type").Equals(CValue.DOC_TYPE_UA01))
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
                    return string.Empty;
                }
                return string.Format("撤销失败，原因：{0}", msg);
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "撤销，出错：" + ex.ToString());
                return "撤销失败！";
            }
        }

        #endregion 自行撤销

        #region 是否可以进行撤销申请

        /// <summary>
        /// 是否可以进行撤销申请
        /// </summary>
        /// <returns></returns>
        private string IsCanRevokeDeclare()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("doc_type")))
                    return "单据类型不能为空！";
                if (string.IsNullOrEmpty(Get("seq_no")))
                    return "单据编号不能为空！";

                string strOut = WKF_ExternalInterface.getInstance().ChkRevoke(Get("doc_type"), Get("seq_no"), user.User_Role);
                if (string.IsNullOrEmpty(strOut))
                    return string.Empty;
                else
                    return strOut;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "是否可以进行撤销申请，出错：" + ex.ToString());
                return "不符合撤销申请要求！";
            }
        }

        #endregion 是否可以进行撤销申请

        #region 撤销申请操作

        /// <summary>
        /// 撤销申请操作
        /// </summary>
        /// <returns></returns>
        private string SubmitRevokeData()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("doc_type")))
                    return "单据类型不能为空！";
                if (string.IsNullOrEmpty(Get("seq_no")))
                    return "单据编号不能为空！";

                string msg = string.Empty;
                bool bResult = WKF_ExternalInterface.getInstance().WKF_RevokeDeclare(Get("doc_type"), Get("seq_no"), user.User_Id, user.User_Role, Post("revokeMsg"), Get("nj"), Get("xy"), Get("bj"), Get("zy"), true, out msg);

                if (!bResult)
                    return string.Format("撤销申请失败，原因：{0}", msg);
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "撤销申请操作，出错：" + ex.ToString());
                return "撤销申请失败！";
            }
        }

        #endregion 撤销申请操作
    }
}