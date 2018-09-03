using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.ChangRole
{
    public partial class Edit : Main
    {
        private comdata cod = new comdata();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                switch (optype)
                {
                    case "getuserrole":
                        Response.Write(GetUserRoleHtml());
                        Response.End();
                        break;

                    case "save":
                        Response.Write(ChangeUserRole());
                        Response.End();
                        break;
                }
            }
        }

        #region 获取用户角色radio选择界面

        /// <summary>
        /// 获取用户角色radio选择界面
        /// </summary>
        /// <returns></returns>
        private string GetUserRoleHtml()
        {
            string strRoleSQL = string.Format("SELECT USER_ROLE FROM UA_USER WHERE USER_ID = '{0}' ", user.User_Id);
            string strRole = ds.ExecuteTxtScalar(strRoleSQL).ToString();
            string[] arrRole = strRole.Split(new char[] { ',' });
            StringBuilder sbHtml = new StringBuilder();
            foreach (string role in arrRole)
            {
                if (string.IsNullOrEmpty(role))
                    continue;
                sbHtml.Append("<input name=\"user_role\" id=\"" + role + "\"  type=\"radio\" value=\"" + role + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + role + "\">" + cod.GetDDLTextByValue("ddl_ua_role", role) + "</label>&nbsp;&nbsp;");
            }

            return sbHtml.ToString();
        }

        #endregion 获取用户角色radio选择界面

        #region 切换角色

        /// <summary>
        /// 切换角色
        /// </summary>
        /// <returns></returns>
        private string ChangeUserRole()
        {
            try
            {
                //获取客户端的Cookie对象
                string cookie = "universtake_user";
                HttpCookie cUser = Cookie.Get(cookie);
                if (cUser != null)
                {
                    //修改用户角色的Cookie
                    cUser.Values["user_role"] = Post("hidRole");
                    Cookie.Save(cUser);
                }

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, ex.ToString());
                return string.Format("切换用户角色失败！");
            }
        }

        #endregion 切换角色
    }
}