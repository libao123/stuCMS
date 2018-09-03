using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PorteffAnaly.Web.AdminLTE_Mod.CHK
{
    public partial class Return : Main
    {
        #region 初始化

        private comdata cod = new comdata();
        private ComTranClass comTran = new ComTranClass();

        #endregion 初始化

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "getrtnrole":
                            Response.Write(GetReturnRoleHtml());
                            Response.End();
                            break;

                        case "return":
                            Response.Write(ReturnData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        private string GetReturnRoleHtml()
        {
            string step_no = Get("step_no");
            string doc_type = Get("doc_type");
            string strSql = string.Format("SELECT DISTINCT STEP_NO, POST_CODE FROM WKF_RULE_QUEUE WHERE DOC_TYPE = '{0}' ORDER BY STEP_NO", doc_type);
            DataTable dt = ds.ExecuteTxtDataTable(strSql);
            string POST_DSC = string.Empty;
            StringBuilder sbHtml = new StringBuilder();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["STEP_NO"].ToString().Equals(step_no))
                    break;
                POST_DSC = cod.GetDDLTextByValue("ddl_ua_role", dt.Rows[i]["POST_CODE"].ToString());
                POST_DSC += dt.Rows[i]["STEP_NO"].ToString().Equals(CValue.STEP_A0) ? "申请" : "审批";
                sbHtml.Append("<input type=\"radio\" name=\"POST_CODE\" id=\"" + dt.Rows[i]["STEP_NO"].ToString() + "\" value=\"" + dt.Rows[i]["POST_CODE"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + dt.Rows[i]["STEP_NO"].ToString() + "\">" + POST_DSC + "</label>&nbsp;&nbsp;&nbsp;&nbsp;");
            }

            return sbHtml.ToString();
        }

        private string ReturnData()
        {
            string strMsg = string.Empty;
            bool bResult = WKF_ExternalInterface.getInstance().WKF_Return(Get("doc_type"), Get("seq_no"), Post("rtn_step"), Post("rtn_post"), user.User_Name, Post("OP_NOTES"), user.User_Role, out strMsg);

            return strMsg;
        }
    }
}