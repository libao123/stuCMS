using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.APP.DataBaseControl.SqlCommand
{
    public partial class List : Main
    {
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
                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;

                        case "check":
                            Response.Write(YZMChk());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 执行SQL

        /// <summary>
        /// 执行SQL
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                string strExeSql = Post("sql_txt");
                int nCount = ds.ExecuteTxtNonQuery(strExeSql);
                return string.Format("执行成功，影响行数：{0}", nCount);
            }
            catch (Exception ex)
            {
                return "执行出错！";
            }
        }

        #endregion 执行SQL

        #region 校验验证码是否正确

        /// <summary>
        /// 校验验证码是否正确
        /// </summary>
        /// <returns></returns>
        private string YZMChk()
        {
            if (string.IsNullOrEmpty(Get("yzm")))
                return "验证码不能为空！";
            string yzm_sys = "Powernet" + DateTime.Now.ToString("yyyyMMdd");
            string strYzm = Get("yzm");
            if (yzm_sys != strYzm)
                return "验证码不正确！";

            return string.Empty;
        }

        #endregion 校验验证码是否正确
    }
}