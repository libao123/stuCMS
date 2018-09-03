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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectManage
{
    public partial class LimitZyList : Main
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
                        case "getzy_edit"://编辑时首次加载专业HTML
                            Response.Write(GetZy_Edit());
                            Response.End();
                            break;

                        case "getzy_add"://选择时加载专业HTML
                            Response.Write(GetZy_Add());
                            Response.End();
                            break;

                        case "getzy_del"://删除选中专业HTML
                            Response.Write(GetAccpter_Del());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #region 编辑时首次加载专业HTML

        /// <summary>
        /// 编辑时首次加载专业HTML
        /// </summary>
        /// <returns></returns>
        private string GetZy_Edit()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("seq_no")))
                    return string.Empty;
                string strSQL = string.Format("SELECT ZY_ID, ZY_NAME FROM SHOOLAR_PROJECT_LIMIT_ZY WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                DataTable dt = ds.ExecuteTxtDataTable(strSQL);
                if (dt == null)
                    return string.Empty;
                StringBuilder sbHtml = new StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;
                    sbHtml.Append("<input name=\"limit_zy\" id=\"" + row["ZY_ID"].ToString() + "\"  type=\"checkbox\" value=\"" + row["ZY_ID"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["ZY_ID"].ToString() + "\">" + row["ZY_NAME"].ToString() + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "奖助项目设置，编辑时首次加载专业HTML，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 编辑时首次加载专业HTML

        #region 选择时加载专业HTML

        /// <summary>
        /// 选择时加载专业HTML
        /// </summary>
        /// <returns></returns>
        private string GetZy_Add()
        {
            try
            {
                #region 排除重复专业

                if (string.IsNullOrEmpty(Post("hidAllZy")))
                    return string.Empty;

                string strSel = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(Post("hidAllZy"));

                #endregion 排除重复专业

                #region 专业HTML

                string strSQL = string.Format("SELECT zy, mc FROM t_jx_zy WHERE zy IN ({0}) ", strSel);
                DataTable dt = ds.ExecuteTxtDataTable(strSQL);
                if (dt == null)
                    return string.Empty;
                StringBuilder sbHtml = new StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;
                    sbHtml.Append("<input name=\"limit_zy\" id=\"" + row["zy"].ToString() + "\"  type=\"checkbox\" value=\"" + row["zy"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["zy"].ToString() + "\">" + row["mc"].ToString() + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();

                #endregion 专业HTML
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "奖助项目设置，选择时加载专业HTML，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 选择时加载专业HTML

        #region 删除选中专业HTML

        /// <summary>
        /// 删除选中专业HTML
        /// </summary>
        /// <returns></returns>
        private string GetAccpter_Del()
        {
            try
            {
                #region 排除重复专业

                if (string.IsNullOrEmpty(Post("hidAllZy")))
                    return string.Empty;
                if (string.IsNullOrEmpty(Post("hidSelDelZy")))
                    return string.Empty;

                string[] arrAllUser = Post("hidAllZy").Split(new char[] { ',' });
                string SelDelUser = Post("hidSelDelZy").ToString();

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

                #endregion 排除重复专业

                #region 专业HTML

                string strSQL = string.Format("SELECT zy, mc FROM t_jx_zy WHERE zy IN ({0}) ", strSel);
                DataTable dt = ds.ExecuteTxtDataTable(strSQL);
                if (dt == null)
                    return string.Empty;
                StringBuilder sbHtml = new StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;

                    sbHtml.Append("<input name=\"limit_zy\" id=\"" + row["zy"].ToString() + "\"  type=\"checkbox\" value=\"" + row["zy"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["zy"].ToString() + "\">" + row["mc"].ToString() + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();

                #endregion 专业HTML
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "奖助项目设置，删除选中专业HTML，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 删除选中专业HTML
    }
}