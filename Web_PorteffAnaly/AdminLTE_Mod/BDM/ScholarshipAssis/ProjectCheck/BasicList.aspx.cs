using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.Architecture.Factory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectCheck
{
    public partial class BasicList : Main
    {
        #region 界面初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "getmsg"://获得信息内容
                            Response.Write(GetMsg());
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

                        case "chkcheck"://校验是否有核对信息
                            Response.Write(ChkCheckData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 界面初始化

        #region 获得发送的核对信息内容

        /// <summary>
        /// 获得发送的核对信息内容
        /// </summary>
        /// <returns></returns>
        private string GetMsg()
        {
            if (string.IsNullOrEmpty(Get("msg_id")))
                return "";
            Messge_info msg = new Messge_info();
            msg.OID = Get("msg_id");
            ds.RetrieveObject(msg);
            StringBuilder json = new StringBuilder();//用来存放Json的
            json.Append("{");
            json.Append(Json.StringToJson(msg.MSG_CONTENT, "MSG_CONTENT"));
            json.Append("}");
            return json.ToString();
        }

        #endregion 获得发送的核对信息内容

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                if (string.IsNullOrEmpty(Post("OID")))
                    return "主键不能为空！";

                Shoolar_project_head model = new Shoolar_project_head();
                model.OID = Post("OID");
                ds.RetrieveObject(model);

                #region 发送信息核对信息

                string strMsgOid = string.Empty;
                if (model.CHECK_MSG_ID.Length == 0)
                {
                    strMsgOid = SendMsg(model.SEQ_NO);
                }
                else
                {
                    //删除相关信息数据
                    string strDelMsgSql = string.Format("DELETE FROM MESSGE_INFO WHERE OID = '{0}' ", model.CHECK_MSG_ID);
                    string strDelMsg_ListSql = string.Format("DELETE FROM MESSGE_ACCPTER WHERE MSG_OID = '{0}' ", model.CHECK_MSG_ID);
                    ds.ExecuteTxtNonQuery(strDelMsgSql);
                    ds.ExecuteTxtNonQuery(strDelMsg_ListSql);
                    //重新发送信息
                    strMsgOid = SendMsg(model.SEQ_NO);
                }

                #endregion 发送信息核对信息

                #region 保存信息核对

                if (strMsgOid.Length > 0)
                {
                    //清除核对信息
                    model.CHECK_START = Post("CHECK_START");
                    model.CHECK_END = Post("CHECK_END");
                    model.CHECK_IS_SEND = CValue.FLAG_Y;
                    model.CHECK_MSG_ID = strMsgOid;
                    model.CHECK_OP_CODE = user.User_Id;
                    model.CHECK_OP_NAME = user.User_Name;
                    model.CHECK_OP_TIME = GetDateLongFormater();
                    ds.UpdateObject(model);
                }

                #endregion 保存信息核对

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "发送信息，奖助核对信息失败：" + ex.ToString());
                return "保存失败！";
            }
        }

        /// <summary>
        /// 发送信息核对信息
        /// </summary>
        /// <returns></returns>
        private string SendMsg(string strProjectSeqNo)
        {
            Dictionary<string, string> dic = ProjectCheckHandleClass.getInstance().GetCheckInfoMsgAccpterList(strProjectSeqNo);
            string strMsgOid = string.Empty;
            MessgeHandleClass.getInstance().SendMessge("J", Post("MSG_CONTENT"), user.User_Id, user.User_Name, dic, out strMsgOid);
            return strMsgOid;
        }

        #endregion 保存数据

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

                Shoolar_project_head model = new Shoolar_project_head();
                model.OID = Get("id");
                ds.RetrieveObject(model);
                //删除发布的核对信息
                Messge_info msg = new Messge_info();
                msg.OID = model.CHECK_MSG_ID;
                ds.RetrieveObject(msg);

                var transaction = ImplementFactory.GetDeleteTransaction<Messge_info>("Messge_infoDeleteTransaction");
                transaction.EntityList.Add(msg);
                if (transaction.Commit())
                {
                    //清除核对信息
                    model.CHECK_START = "";
                    model.CHECK_END = "";
                    model.CHECK_IS_SEND = "";
                    model.CHECK_MSG_ID = "";
                    model.CHECK_OP_CODE = "";
                    model.CHECK_OP_NAME = "";
                    model.CHECK_OP_TIME = "";
                    ds.UpdateObject(model);
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "删除发布的奖助核对信息失败：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据

        #region 校验是否有核对信息

        /// <summary>
        /// 校验是否有核对信息
        /// </summary>
        /// <returns></returns>
        private string ChkCheckData()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "奖助项目主键不能为空！";
            Shoolar_project_head head = new Shoolar_project_head();
            head.OID = Get("id");
            ds.RetrieveObject(head);
            if (head == null)
                return "奖助项目信息不能为空！";
            if (string.IsNullOrEmpty(head.CHECK_START))
                return "奖助项目核对信息未设置，不能发布公告！";
            return string.Empty;
        }

        #endregion 校验是否有核对信息
    }
}