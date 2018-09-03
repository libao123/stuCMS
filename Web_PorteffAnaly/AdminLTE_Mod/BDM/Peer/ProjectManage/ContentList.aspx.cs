using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Peer.ProjectManage
{
    public partial class ContentList : ListBaseLoad<Peer_project_list>
    {
        #region 初始化

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

        private comdata cod = new comdata();

        protected override SelectTransaction<Peer_project_list> GetSelectTransaction()
        {
            if (Request.QueryString["seq_no"] != null && Request.QueryString["seq_no"].Length != 0)
            {
                param.Add("SEQ_NO", Request.QueryString["seq_no"]);
            }
            else
            {
                param.Add(" 1=2 ", "");
            }
            return ImplementFactory.GetSelectTransaction<Peer_project_list>("Peer_project_listSelectTransaction", param);
        }

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
                        case "getlist":
                            Response.Write(GetList());
                            Response.End();
                            break;

                        case "delete"://删除操作
                            Response.Write(DeleteData());
                            Response.End();
                            break;

                        case "save"://保存操作
                            Response.Write(SaveData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Peer_project_list>.NameValue> GetValue(Peer_project_list entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "SEQUEUE", Value = entity.SEQUEUE.ToString() };
            yield return new NameValue() { Name = "PEER_CONTENT", Value = entity.PEER_CONTENT };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            string strOID = Request.QueryString["id"];
            if (string.IsNullOrEmpty(strOID))
                return "OID为空,不允许删除操作";
            Peer_project_list head = new Peer_project_list();
            head.OID = strOID;
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<Peer_project_list>("Peer_project_listDeleteTransaction");
            transaction.EntityList.Add(head);
            if (!transaction.Commit())
                return "删除失败！";

            return string.Empty;
        }

        #endregion 删除数据

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            string oid = Post("hidOid_Content");
            bool res = false;
            Peer_project_list notboth = new Peer_project_list();
            if (string.IsNullOrEmpty(oid))
            {
                oid = notboth.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(notboth);
                notboth.SEQ_NO = Post("hidSeqNo_Content");
                notboth.SEQUEUE = cod.ChangeInt(Post("SEQUEUE"));
                notboth.PEER_CONTENT = Post("PEER_CONTENT");
                var inserttrcn = ImplementFactory.GetInsertTransaction<Peer_project_list>("Peer_project_listInsertTransaction");
                inserttrcn.EntityList.Add(notboth);
                res = inserttrcn.Commit();
            }
            else
            {
                notboth.OID = oid;
                ds.RetrieveObject(notboth);
                notboth.SEQUEUE = cod.ChangeInt(Post("SEQUEUE"));
                notboth.PEER_CONTENT = Post("PEER_CONTENT");
                var updatetrcn = ImplementFactory.GetUpdateTransaction<Peer_project_list>("Peer_project_listUpdateTransaction", user.User_Name);
                res = updatetrcn.Commit(notboth);
            }
            if (res)
                return oid;
            else
                return string.Empty;
        }

        #endregion 保存数据
    }
}