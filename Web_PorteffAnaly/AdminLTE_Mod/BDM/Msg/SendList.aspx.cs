using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Msg
{
    public partial class SendList : ListBaseLoad<Messge_info>
    {
        #region 初始化

        private comdata cod = new comdata();

        protected override string input_code_column
        {
            get { return ""; }
        }

        protected override string class_code_column
        {
            get { return ""; }
        }

        protected override string xy_code_column
        {
            get { return ""; }
        }

        protected override bool is_do_filter
        {
            get { return false; }
        }

        protected override SelectTransaction<Messge_info> GetSelectTransaction()
        {
            if (!user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))
            {
                //过滤：接收人与发送人都可以看到所属信息
                param.Add("SEND_CODE", user.User_Id);
            }
            return ImplementFactory.GetSelectTransaction<Messge_info>("Messge_infoSelectTransaction", param);
        }

        #endregion 初始化

        #region 界面加载

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
                            Response.Write(GetList());
                            Response.End();
                            break;

                        case "delete"://删除
                            Response.Write(DeleteData());
                            Response.End();
                            break;

                        case "save"://保存
                            Response.Write(Save());
                            Response.End();
                            break;

                        case "getaccpter_edit"://编辑时首次加载接收人HTML
                            Response.Write(GetAccpter_Edit());
                            Response.End();
                            break;

                        case "getaccpter_add"://选择时加载接收人HTML
                            Response.Write(GetAccpter_Add());
                            Response.End();
                            break;

                        case "getaccpter_del"://删除选中接收人HTML
                            Response.Write(GetAccpter_Del());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #region 查询

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("MSG_TYPE")))
                where += string.Format(" AND MSG_TYPE = '{0}' ", Post("MSG_TYPE"));
            if (!string.IsNullOrEmpty(Post("MSG_CONTENT")))
                where += string.Format(" AND MSG_CONTENT LIKE '%{0}%' ", Post("MSG_CONTENT"));
            return where;
        }

        #endregion 查询

        #endregion 界面加载

        #region 输出列表信息

        /// <summary>
        /// 重载输出列表信息
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        protected override IEnumerable<ListBaseLoad<Messge_info>.NameValue> GetValue(Messge_info entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "MSG_TYPE", Value = entity.MSG_TYPE };
            yield return new NameValue() { Name = "MSG_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_msg_type", entity.MSG_TYPE) };
            yield return new NameValue() { Name = "MSG_CONTENT", Value = entity.MSG_CONTENT };
            yield return new NameValue() { Name = "SEND_CODE", Value = entity.SEND_CODE };
            yield return new NameValue() { Name = "SEND_NAME", Value = entity.SEND_NAME };
            yield return new NameValue() { Name = "SEND_TIME", Value = entity.SEND_TIME };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 通过传入的主键编码删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("id")))
                    return "主键为空,不允许删除操作";

                var model = new Messge_info();
                model.OID = Get("id");
                ds.RetrieveObject(model);

                bool bDel = false;
                var transaction = ImplementFactory.GetDeleteTransaction<Messge_info>("Messge_infoDeleteTransaction");
                transaction.EntityList.Add(model);
                bDel = transaction.Commit();

                if (!bDel)
                    return "删除失败！";
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "删除消息，出错：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据

        #region 保存/提交

        /// <summary>
        /// 保存/提交事件
        /// </summary>
        /// <returns></returns>
        private string Save()
        {
            try
            {
                bool bFlag = false;
                Messge_info head = new Messge_info();
                if (string.IsNullOrEmpty(Post("OID")))            //新增
                {
                    head.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(head);
                    GetFormValue(head);

                    var inserttrcn = ImplementFactory.GetInsertTransaction<Messge_info>("Messge_infoInsertTransaction", user.User_Name);
                    inserttrcn.EntityList.Add(head);
                    bFlag = inserttrcn.Commit();
                }
                else //修改
                {
                    head.OID = Post("OID");
                    ds.RetrieveObject(head);
                    GetFormValue(head);

                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Messge_info>("Messge_infoUpdateTransaction", user.User_Name);
                    bFlag = updatetrcn.Commit(head);
                }
                if (bFlag)
                {
                    //插入接收人表
                    MessgeHandleClass.getInstance().InsertMessgeAccpter(head.OID, GetAccpter());
                    return string.Empty;
                }
                return "信息发送失败！";
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "信息发送失败：" + ex.ToString());
                return "信息发送失败！";
            }
        }

        /// <summary>
        /// 获得信息接收人
        /// </summary>
        /// <returns></returns>
        private Dictionary<string, string> GetAccpter()
        {
            if (string.IsNullOrEmpty(Post("hidAllUser")))
                return null;

            #region 排除重复用户

            if (string.IsNullOrEmpty(Post("hidAllUser")))
                return null;
            string strSel = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(Post("hidAllUser"));

            #endregion 排除重复用户

            #region 接收人

            Dictionary<string, string> resultIDic = new Dictionary<string, string>();
            string strSQL = string.Format("SELECT USER_ID, USER_NAME FROM UA_USER WHERE USER_ID IN ({0}) ", strSel);
            DataTable dt = ds.ExecuteTxtDataTable(strSQL);
            if (dt == null)
                return null;
            foreach (DataRow row in dt.Rows)
            {
                if (row == null)
                    continue;
                resultIDic.Add(row["USER_ID"].ToString(), row["USER_NAME"].ToString());
            }
            return resultIDic;

            #endregion 接收人
        }

        #endregion 保存/提交

        #region 获取页面文本

        /// <summary>
        /// 获取界面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetFormValue(Messge_info model)
        {
            model.MSG_TYPE = Post("MSG_TYPE");
            model.MSG_CONTENT = Post("MSG_CONTENT");
            model.SEND_TIME = GetDateLongFormater();
            model.SEND_CODE = user.User_Id;
            model.SEND_NAME = user.User_Name;
        }

        #endregion 获取页面文本

        #region 编辑时首次加载接收人HTML

        /// <summary>
        /// 编辑时首次加载接收人HTML
        /// </summary>
        /// <returns></returns>
        private string GetAccpter_Edit()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("id")))
                    return string.Empty;
                string strSQL = string.Format("SELECT ACCPTER_CODE, ACCPTER_NAME FROM MESSGE_ACCPTER WHERE MSG_OID = '{0}' ", Get("id"));
                DataTable dt = ds.ExecuteTxtDataTable(strSQL);
                if (dt == null)
                    return string.Empty;
                StringBuilder sbHtml = new StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;
                    sbHtml.Append("<input name=\"accpter_user\" id=\"" + row["ACCPTER_CODE"].ToString() + "\"  type=\"checkbox\" value=\"" + row["ACCPTER_CODE"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["ACCPTER_CODE"].ToString() + "\">" + row["ACCPTER_NAME"].ToString() + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "编辑时首次加载接收人HTML，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 编辑时首次加载接收人HTML

        #region 选择时加载接收人HTML

        /// <summary>
        /// 选择时加载接收人HTML
        /// </summary>
        /// <returns></returns>
        private string GetAccpter_Add()
        {
            try
            {
                #region 排除重复用户

                if (string.IsNullOrEmpty(Post("hidAllUser")))
                    return string.Empty;

                string strSel = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(Post("hidAllUser"));

                #endregion 排除重复用户

                #region 接收人HTML

                string strSQL = string.Format("SELECT USER_ID, USER_NAME FROM UA_USER WHERE USER_ID IN ({0}) ", strSel);
                DataTable dt = ds.ExecuteTxtDataTable(strSQL);
                if (dt == null)
                    return string.Empty;
                StringBuilder sbHtml = new StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;
                    sbHtml.Append("<input name=\"accpter_user\" id=\"" + row["USER_ID"].ToString() + "\"  type=\"checkbox\" value=\"" + row["USER_ID"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["USER_ID"].ToString() + "\">" + row["USER_NAME"].ToString() + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();

                #endregion 接收人HTML
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "选择时加载接收人HTML，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 选择时加载接收人HTML

        #region 删除选中接收人HTML

        /// <summary>
        /// 删除选中接收人HTML
        /// </summary>
        /// <returns></returns>
        private string GetAccpter_Del()
        {
            try
            {
                #region 排除重复用户

                if (string.IsNullOrEmpty(Post("hidAllUser")))
                    return string.Empty;
                if (string.IsNullOrEmpty(Post("hidSelDelUser")))
                    return string.Empty;

                string[] arrAllUser = Post("hidAllUser").Split(new char[] { ',' });
                string SelDelUser = Post("hidSelDelUser").ToString();

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

                #endregion 排除重复用户

                #region 接收人HTML

                string strSQL = string.Format("SELECT USER_ID, USER_NAME FROM UA_USER WHERE USER_ID IN ({0}) ", strSel);
                DataTable dt = ds.ExecuteTxtDataTable(strSQL);
                if (dt == null)
                    return string.Empty;
                StringBuilder sbHtml = new StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;

                    sbHtml.Append("<input name=\"accpter_user\" id=\"" + row["USER_ID"].ToString() + "\"  type=\"checkbox\" value=\"" + row["USER_ID"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["USER_ID"].ToString() + "\">" + row["USER_NAME"].ToString() + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();

                #endregion 接收人HTML
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "删除选中接收人HTML，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 删除选中接收人HTML
    }
}