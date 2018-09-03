using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using HQ.WebForm.Kernel;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Msg
{
    public partial class AccpterList : Main
    {
        private comdata cod = new comdata();
        private datatables tables = new datatables();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "getlist"://获取列表
                            Response.Write(GetListData());
                            Response.End();
                            break;

                        case "mark"://标记已读
                            Response.Write(MarkData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #region 自定义获取查询列表

        /// <summary>
        ///  自定义获取查询列表
        /// </summary>
        /// <returns></returns>
        private string GetListData()
        {
            Hashtable ddl = new Hashtable();
            ddl["MSG_TYPE"] = "ddl_msg_type";

            string where = string.Empty;
            where += string.Format(" AND T.ACCPTER_CODE = '{0}' ", user.User_Id);
            where = GetSearchWhere(where);
            return tables.GetCmdQueryData("GET_MSG_ACCPTER_LIST", null, where, " SEND_TIME DESC ", ddl);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public string GetSearchWhere(string where)
        {
            if (!string.IsNullOrEmpty(Post("MSG_TYPE")))
                where += string.Format(" AND MSG_TYPE = '{0}' ", Post("MSG_TYPE"));
            if (!string.IsNullOrEmpty(Post("IS_READ")))
                where += string.Format(" AND IS_READ = '{0}' ", Post("IS_READ"));
            if (!string.IsNullOrEmpty(Post("MSG_CONTENT")))
                where += string.Format(" AND MSG_CONTENT LIKE '%{0}%' ", Post("MSG_CONTENT"));
            return where;
        }

        #endregion 自定义获取查询列表

        #region 标记已读/未读

        /// <summary>
        /// 标记已读/未读
        /// </summary>
        /// <returns></returns>
        private string MarkData()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("id")))
                    return "信息主键不能为空！";

                Messge_accpter head = new Messge_accpter();
                head.OID = Get("id");
                ds.RetrieveObject(head);
                head.IS_READ = CValue.FLAG_Y;
                ds.UpdateObject(head);
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "信息标记已读，出错：" + ex.ToString());
                return "信息标记已读失败！";
            }
        }

        #endregion 标记已读/未读
    }
}