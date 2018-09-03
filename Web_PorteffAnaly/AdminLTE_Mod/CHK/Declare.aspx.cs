using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.CHK
{
    /// <summary>
    /// 该页面为申报专用公共界面
    /// 申报前判断 当前操作人的角色是否满足该单据的申报条件
    /// </summary>
    public partial class Declare : Main
    {
        #region 初始化

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "chkdeclare":
                            Response.Write(ChkDeclare());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 初始化

        #region 判断是否符合申请条件

        /// <summary>
        /// 判断是否符合申请条件
        /// </summary>
        /// <returns></returns>
        private string ChkDeclare()
        {
            if (string.IsNullOrEmpty(Get("doc_type")) || string.IsNullOrEmpty(Get("seq_no")) || string.IsNullOrEmpty(Get("user_role")))
                return "单据类型、单据编号、用户角色，三者不能为空！";
            string strMsg = WKF_ExternalInterface.getInstance().ChkDeclare(Get("doc_type"), Get("seq_no"), Get("user_role"));
            if (strMsg.Length > 0)
                return strMsg;
            return string.Empty;
        }

        #endregion 判断是否符合申请条件
    }
}