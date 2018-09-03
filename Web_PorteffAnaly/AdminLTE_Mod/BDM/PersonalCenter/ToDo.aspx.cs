using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter
{
    public partial class ToDo : Main
    {
        #region 初始化定义

        public comdata cod = new comdata();
        private ComTranClass comTran = new ComTranClass();

        #endregion 初始化定义

        #region 窗体加载

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "getlist":
                            Response.Write(GetList());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 窗体加载

        #region 获取数据

        private string GetList()
        {
            DataTable dt = new DataTable();
            Hashtable ddl = new Hashtable();
            ddl["DOC_TYPE"] = "ddl_doc_type";

            dt = HandleSelect.getInstance().GetTodoDataTable(user.User_Id, user.User_Role);
            if (ddl != null && ddl.Count > 0)
            {
                cod.ConvertTabDdl(dt, ddl);
            }

            return DataTableToJson(dt);
        }

        private string DataTableToJson(DataTable dt)
        {
            int draw = 1;
            if (Post("draw") != null)
                int.TryParse(Post("draw"), out draw);
            return string.Format("{{\"draw\":{0},\"recordsTotal\":{1},\"recordsFiltered\":{2},\"data\":[{3}]}}", draw, dt.Rows.Count, dt.Rows.Count, Json.DatatableToJson(dt));
        }

        #endregion 获取数据
    }
}