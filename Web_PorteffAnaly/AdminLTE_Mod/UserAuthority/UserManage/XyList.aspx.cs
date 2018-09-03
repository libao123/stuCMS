using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.UserManage
{
    public partial class XyList : Main
    {
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
                        case "getxy_edit"://编辑时首次加载学院HTML
                            Response.Write(GetXy_Edit());
                            Response.End();
                            break;

                        case "getxy_add"://选择时加载学院HTML
                            Response.Write(GetXy_Add());
                            Response.End();
                            break;

                        case "getxy_del"://删除选中学院HTML
                            Response.Write(GetXy_Del());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #region 编辑时首次加载学院HTML

        /// <summary>
        /// 编辑时首次加载学院HTML
        /// </summary>
        /// <returns></returns>
        private string GetXy_Edit()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("user_id")))
                    return string.Empty;
                string strSQL = string.Format("SELECT XY_CODE FROM UA_USER WHERE USER_ID = '{0}' ", Get("user_id"));
                string strXy = ds.ExecuteTxtScalar(strSQL).ToString();
                if (string.IsNullOrEmpty(strXy))
                    return string.Empty;
                string[] arrXy = strXy.Split(new char[] { ',' });
                StringBuilder sbHtml = new StringBuilder();
                foreach (string xy in arrXy)
                {
                    if (string.IsNullOrEmpty(xy))
                        continue;
                    sbHtml.Append("<input name=\"ua_xy\" id=\"" + xy + "\"  type=\"checkbox\" value=\"" + xy + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + xy + "\">" + cod.GetDDLTextByValue("ddl_all_department", xy) + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, ex.ToString());
                return string.Empty;
            }
        }

        #endregion 编辑时首次加载学院HTML

        #region 选择时加载学院HTML

        /// <summary>
        /// 选择时加载学院HTML
        /// </summary>
        /// <returns></returns>
        private string GetXy_Add()
        {
            try
            {
                #region 排除重复学院

                if (string.IsNullOrEmpty(Post("hidAllXy")))
                    return string.Empty;

                string strSel = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(Post("hidAllXy"));

                #endregion 排除重复学院

                #region 学院HTML

                string strSQL = string.Format("SELECT dw, mc FROM t_xt_department WHERE dw IN ({0}) ", strSel);
                DataTable dt = ds.ExecuteTxtDataTable(strSQL);
                if (dt == null)
                    return string.Empty;
                StringBuilder sbHtml = new StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;
                    sbHtml.Append("<input name=\"ua_xy\" id=\"" + row["dw"].ToString() + "\"  type=\"checkbox\" value=\"" + row["dw"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["dw"].ToString() + "\">" + row["mc"].ToString() + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();

                #endregion 学院HTML
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "用户信息管理，学院加载失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 选择时加载学院HTML

        #region 删除选中学院HTML

        /// <summary>
        /// 删除选中学院HTML
        /// </summary>
        /// <returns></returns>
        private string GetXy_Del()
        {
            try
            {
                #region 排除重复学院

                if (string.IsNullOrEmpty(Post("hidAllXy")))
                    return string.Empty;
                if (string.IsNullOrEmpty(Post("hidSelDelXy")))
                    return string.Empty;

                string[] arrAllUser = Post("hidAllXy").Split(new char[] { ',' });
                string SelDelUser = Post("hidSelDelXy").ToString();

                string strWhereUser = string.Empty;
                foreach (string user in arrAllUser)
                {
                    if (string.IsNullOrEmpty(user))
                        continue;
                    if (SelDelUser.Contains(user))
                        continue;
                    strWhereUser += user + ",";
                }
                string strSel = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(strWhereUser);

                #endregion 排除重复学院

                #region 学院HTML

                string strSQL = string.Format("SELECT dw, mc FROM t_xt_department WHERE dw IN ({0}) ", strSel);
                DataTable dt = ds.ExecuteTxtDataTable(strSQL);
                if (dt == null)
                    return string.Empty;
                StringBuilder sbHtml = new StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;

                    sbHtml.Append("<input name=\"ua_xy\" id=\"" + row["dw"].ToString() + "\"  type=\"checkbox\" value=\"" + row["dw"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["dw"].ToString() + "\">" + row["mc"].ToString() + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();

                #endregion 学院HTML
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "用户信息管理，删除学院失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 删除选中学院HTML
    }
}