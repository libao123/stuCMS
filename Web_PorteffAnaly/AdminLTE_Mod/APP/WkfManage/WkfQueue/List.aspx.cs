using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.APP.WkfManage.WkfQueue
{
    public partial class List : ListBaseLoad<Wkf_client_queue>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

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

        protected override SelectTransaction<Wkf_client_queue> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Wkf_client_queue>("Wkf_client_queueSelectTransaction", param);
        }

        #endregion 初始化

        #region 页面加载

        /// <summary>
        /// 页面加载
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
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

                        case "delete"://删除操作
                            Response.Write(DeleteData());
                            Response.End();
                            break;

                        case "update"://修改处理状态
                            Response.Write(UpdateHandleStatus());
                            Response.End();
                            break;

                        case "remove"://解除布控操作
                            Response.Write(RemoveLockData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("DOC_NO")))
                where += string.Format(" AND DOC_NO LIKE '%{0}%' ", Post("DOC_NO"));
            if (!string.IsNullOrEmpty(Post("DOC_TYPE")))
                where += string.Format(" AND DOC_TYPE = '{0}' ", Post("DOC_TYPE"));
            if (!string.IsNullOrEmpty(Post("DECLARE_TYPE")))
                where += string.Format(" AND DECLARE_TYPE = '{0}' ", Post("DECLARE_TYPE"));
            if (!string.IsNullOrEmpty(Post("HANDLE_STATUS")))
                where += string.Format(" AND HANDLE_STATUS = '{0}' ", Post("HANDLE_STATUS"));
            return where;
        }

        protected override IEnumerable<ListBaseLoad<Wkf_client_queue>.NameValue> GetValue(Wkf_client_queue entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "DOC_TYPE", Value = cod.GetDDLTextByValue("ddl_doc_type_needflow", entity.DOC_TYPE) };
            yield return new NameValue() { Name = "DOC_NO", Value = entity.DOC_NO };
            yield return new NameValue() { Name = "DECLARE_TYPE", Value = cod.GetDDLTextByValue("ddl_DECLARE_TYPE", entity.DECLARE_TYPE) };
            yield return new NameValue() { Name = "STEP_NO", Value = cod.GetDDLTextByValue("ddl_STEP_NO", entity.STEP_NO) };
            yield return new NameValue() { Name = "RET_CHANNEL", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.RET_CHANNEL) };
            yield return new NameValue() { Name = "POST_CODE", Value = entity.POST_CODE };
            yield return new NameValue() { Name = "OP_USER", Value = entity.OP_USER };
            yield return new NameValue() { Name = "OP_USER_NAME", Value = entity.OP_USER_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            yield return new NameValue() { Name = "HANDLE_MSG", Value = entity.HANDLE_MSG };
            yield return new NameValue() { Name = "HANDLE_STATUS", Value = cod.GetDDLTextByValue("ddl_queue_status", entity.HANDLE_STATUS) };
            yield return new NameValue() { Name = "HANDLE_TIME", Value = entity.HANDLE_TIME };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "OID为空,不允许删除操作";
            Wkf_client_queue head = new Wkf_client_queue();
            head.OID = Get("id");
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<Wkf_client_queue>("Wkf_client_queueDeleteTransaction");
            transaction.EntityList.Add(head);

            if (!transaction.Commit())
                return "删除失败！";

            return string.Empty;
        }

        #endregion 删除数据

        #region 修改处理状态

        /// <summary>
        /// 修改处理状态
        /// </summary>
        /// <returns></returns>
        private string UpdateHandleStatus()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "主键不能为空！";
            try
            {
                Wkf_client_queue quene = new Wkf_client_queue();
                quene.OID = Get("id");
                ds.RetrieveObject(quene);
                if (!quene.HANDLE_STATUS.Equals("E"))
                {
                    return "只能是异常的数据才可以重新进行操作！";
                }
                quene.HANDLE_STATUS = "N";
                quene.HANDLE_TIME = GetDateLongFormater();
                ds.UpdateObject(quene);
                return string.Empty;
            }
            catch (Exception ex)
            {
                return string.Format("重新处理失败，原因：{0}", ex.ToString());
            }
        }

        #endregion 修改处理状态

        #region 解除锁单状态

        /// <summary>
        /// 解除锁单状态
        /// </summary>
        /// <returns></returns>
        private string RemoveLockData()
        {
            try
            {
                string strOID = Request.QueryString["id"];
                if (string.IsNullOrEmpty(strOID))
                    return "OID为空,不允许删除操作";
                Wkf_client_queue head = new Wkf_client_queue();
                head.OID = strOID;
                ds.RetrieveObject(head);

                string strDocTable = ds.ExecuteTxtScalar(string.Format("SELECT BUS_TABLE FROM COD_BIZ_CODES WHERE DOC_TYPE = '{0}' ", head.DOC_TYPE)).ToString();
                if (strDocTable.Length == 0)
                    return "未找到相应业务表，无法进行解除锁单操作！";
                string strUpLockStatus = string.Format("UPDATE {0} SET CHK_STATUS = 'N' WHERE SEQ_NO = '{1}' ", strDocTable, head.DOC_NO);
                ds.ExecuteTxtNonQuery(strUpLockStatus);
                return string.Empty;
            }
            catch (Exception ex)
            {
                return string.Format("解除锁单失败，原因：{0}", ex.ToString());
            }
        }

        #endregion 解除锁单状态
    }
}