using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.Architecture.Factory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectResult
{
    public partial class List : Main
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        #endregion 初始化

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
                        case "delete"://删除操作
                            Response.Write(DeleteData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                string[] strs = Get("ids").Split(',');
                for (int i = 0; i < strs.Length; i++)
                {
                    if (strs[i].Length == 0)
                        continue;
                    var model = new Insur_project_apply();
                    model.OID = strs[i].ToString();
                    ds.RetrieveObject(model);
                    model.INSUR_NUMBER = "";
                    model.INSUR_COMPANY = "";
                    model.INSUR_HANLDMAN = "";
                    model.INSUR_HANLDMAN_PHONE = "";
                    ds.UpdateObject(model);
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保险申请删除，出错：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据
    }
}