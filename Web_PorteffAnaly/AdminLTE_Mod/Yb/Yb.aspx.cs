using System;
using System.Data;
using System.Data.SqlClient;
using HQ.Handlers;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using YbSDK.Model;

namespace PorteffAnaly.Web.AdminLTE_Mod.Yb
{
    /// <summary>
    /// 易班授权验证
    /// </summary>
    public partial class Yb : System.Web.UI.Page
    {
        private System.Web.Script.Serialization.JavaScriptSerializer jss = new System.Web.Script.Serialization.JavaScriptSerializer();
        private HQ.DALFactory.IDataSource ds = HQ.DALFactory.DataSourceFactory.GetDataSource();
        private comdata cod = new comdata();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["state"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "yb_oauth":
                            YbOauth();
                            break;
                    }
                }
            }
        }

        /// <summary>
        /// 易班授权验证
        /// </summary>
        private void YbOauth()
        {
            try
            {
                #region 判断Code是否为空

                if (string.IsNullOrEmpty(Request.QueryString["code"]))
                {
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "易班账号登录失败：code为NULL！");
                    UtilityHandler.WindowLocation("/Yb.html?yb=yb_loginerror");
                    return;
                }

                #endregion 判断Code是否为空

                #region 认证信息

                YbSDK.Api.OauthApi oauthApi = new YbSDK.Api.OauthApi();

                #endregion 认证信息

                #region 通过code获得AccessToken

                //通过code获得AccessToken
                string strUrl_AccessToken = "https://openapi.yiban.cn/oauth/access_token";
                string strParam_AccessToken = "client_id=" + oauthApi.context.Config.AppId + "&client_secret=" + oauthApi.context.Config.AppSecret + "&code=" + Request.QueryString["code"].ToString() + "&redirect_uri=" + oauthApi.context.Config.Callback;
                string strResult_AccessToken = HttpMethods.HttpPost(strUrl_AccessToken, strParam_AccessToken);
                //LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_INFO, "获取已授权用户的access_token：" + strResult_AccessToken);
                AccessToken accessToken = jss.Deserialize<AccessToken>(strResult_AccessToken);
                if (string.IsNullOrEmpty(accessToken.access_token))
                {
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "易班账号登录失败：通过code获得AccessToken为NULL！");
                    UtilityHandler.WindowLocation("/Yb.html?yb=yb_loginerror");
                    return;
                }

                #endregion 通过code获得AccessToken

                #region 通过AccessToken获得用户信息

                //通过AccessToken获得用户信息
                string strUrl_VerifyMe = "https://openapi.yiban.cn/user/verify_me?access_token=" + accessToken.access_token;
                string strResult_VerifyMe = HttpMethods.HttpGet(strUrl_VerifyMe);
                UserVerify userVerify = jss.Deserialize<UserVerify>(strResult_VerifyMe);
                if (userVerify == null)
                {
                    RevokeToken(oauthApi, accessToken.access_token, "", "");
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, userVerify.info.yb_realname + " 易班账号登录失败：通过AccessToken获得用户信息为NULL！");
                    UtilityHandler.WindowLocation("/Yb.html?yb=yb_loginerror");
                    return;
                }

                #endregion 通过AccessToken获得用户信息

                #region 验证易班用户是否在资助系统中已经有注册用户

                //验证易班用户是否在资助系统中已经有注册用户
                string strUserId = userVerify.info.yb_studentid;//学号
                if (string.IsNullOrEmpty(strUserId))
                    strUserId = userVerify.info.yb_employid;//工号
                string strUserName = userVerify.info.yb_realname;//姓名

                SqlParameter[] p = new SqlParameter[2];
                p[0] = new SqlParameter("@id", strUserId);
                p[1] = new SqlParameter("@name", strUserName);
                if (strUserId.Length == 0 || strUserName.Length == 0)
                {
                    RevokeToken(oauthApi, accessToken.access_token, strUserId, strUserName);
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, " 易班账号登录失败：" + strUserId + "易班账号为空或者" + strUserName + "易班真实用户名为空！");
                    UtilityHandler.WindowLocation("/Yb.html?yb=yb_noexist");
                    return;
                }

                //ZZ 20180901 新增：对接教务系统 Start
                //学生在易班登录的时候，通过教务系统对接接口获得学生在教务系统中的基础信息
                string jw_msg = string.Empty;
                if (!JWHandleClass.getInstance().ByJwInsertOrUpdateStuInfo("200812601079", out jw_msg))
                {
                    //RevokeToken(oauthApi, accessToken.access_token, strUserId, strUserName);
                    //LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, strUserName + " 易班账号登录失败：对接教务系统，出错："+ jw_msg);
                    UtilityHandler.WindowLocation("/Yb.html?yb=yb_noexist");
                    return;
                }
                //ZZ 20180901 新增：对接教务系统 End

                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_INFO, "易班登录，学号或者工号：" + strUserId + " 真实姓名：" + strUserName);
                DataTable dtUser = ds.ExecuteTxtDataTable("SELECT * FROM UA_USER WHERE USER_ID=@id AND USER_NAME=@name", p);
                if (dtUser == null || dtUser.Rows.Count == 0)
                {
                    RevokeToken(oauthApi, accessToken.access_token, strUserId, strUserName);
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, strUserName + " 易班账号登录失败：资助系统不存在此用户！");
                    UtilityHandler.WindowLocation("/Yb.html?yb=yb_noexist");
                    return;
                }

                //更新易班token值到用户表中
                if (!ComHandleClass.getInstance().UpdateUaUser_YbToken(dtUser.Rows[0]["USER_ID"].ToString(), accessToken.access_token))
                {
                    RevokeToken(oauthApi, accessToken.access_token, strUserId, strUserName);
                    UtilityHandler.WindowLocation("/Yb.html?yb=yb_loginerror");
                    return;
                }

                string username = dtUser.Rows[0]["USER_ID"].ToString();
                string password = dtUser.Rows[0]["LOGIN_PW"].ToString();
                if (UserHandler.CheckLogin(username, password, true))
                {
                    //LogDBHandleClass.getInstance().LogOperation(strUserId, "用户易班登录", CValue.LOG_ACTION_TYPE_0, CValue.LOG_RECORD_TYPE_1, string.Format("用户易班登录：用户{0}，用户名{1}", strUserId, strUserName), strUserId, strUserName, Fetch.UserIp);

                    UtilityHandler.WindowLocation("/Index.aspx?sid=" + accessToken.access_token);
                    return;
                }

                #endregion 验证易班用户是否在资助系统中已经有注册用户
            }
            catch (Exception ex)
            {
                //string strMsg = "易班账号登录失败：" + ex.ToString();
                //LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, strMsg);
                UtilityHandler.WindowLocation("/Yb.html?yb=yb_loginerror");
                return;
            }
        }

        /// <summary>
        /// 调用易班取消授权接口（oauth/revoke_token）帮助开发者主动取消用户的授权
        /// </summary>
        private void RevokeToken(YbSDK.Api.OauthApi oauthApi, string strAccess_token, string strUserId, string strUserName)
        {
            //退出时，调用易班取消授权接口（oauth/revoke_token）帮助开发者主动取消用户的授权
            string strUrl = "https://openapi.yiban.cn/oauth/revoke_token";
            string strParam = "client_id=" + oauthApi.context.Config.AppId + "&access_token=" + strAccess_token;
            string strResult = HttpMethods.HttpPost(strUrl, strParam);//返回状态说明：200-已注销、500-注销失败
            if (!strResult.Contains("200"))
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "取消用户" + strUserId + strUserName + "的授权失败！");
            }
        }
    }
}