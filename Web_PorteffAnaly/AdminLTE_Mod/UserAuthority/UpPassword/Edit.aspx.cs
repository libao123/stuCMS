using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;
using serverservice;

namespace PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.UpPassword
{
    public partial class Edit : Main
    {
        #region 初始化

        public comdata cod = new comdata();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "save"://修改密码
                            Response.Write(Save());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 初始化

        #region 修改密码事件

        /// <summary>
        /// 修改密码事件
        /// </summary>
        /// <returns></returns>
        private string Save()
        {
            try
            {
                Ua_user head = new Ua_user();
                head.USER_ID = user.User_Id;
                ds.RetrieveObject(head);
                head.LOGIN_PW = Post("new_pw");

                ds.UpdateObject(head);
                UpCookie();
                ComHandleClass.getInstance().SendMailUseGmail(Post("send_email").Trim(), "学生资助信息管理系统密码修改", string.Format("您在 {0} 时，修改了学生资助信息管理系统的登录密码，新登录密码为：{1}", GetDateLongFormater(), Post("new_pw")));
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "学生资助信息管理系统密码修改，失败：" + ex.ToString());
                return string.Format("密码修改失败！");
            }
        }

        //修改用户登录密码的Cookie
        protected void UpCookie()
        {
            //获取客户端的Cookie对象
            string cookie = "universtake_user";
            HttpCookie cUser = Cookie.Get(cookie);
            if (cUser != null)
            {
                //修改用户登录密码的Cookie
                cUser.Values["login_pw"] = Post("new_pw");
                Cookie.Save(cUser);
            }
        }

        #endregion 修改密码事件
    }
}