using System;
using System.Collections.Generic;
using System.IO;
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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectApply
{
    public partial class RewardInfo : ListBaseLoad<Shoolar_apply_reward>
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

        protected override SelectTransaction<Shoolar_apply_reward> GetSelectTransaction()
        {
            if (Request.QueryString["seq_no"] != null && Request.QueryString["seq_no"].Length != 0)
            {
                param.Add("SEQ_NO", Request.QueryString["seq_no"]);
            }
            else
            {
                param.Add(" 1=2 ", "");
            }
            return ImplementFactory.GetSelectTransaction<Shoolar_apply_reward>("Shoolar_apply_rewardSelectTransaction", param);
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

                        case "synchro"://同步操作
                            Response.Write(SynchroData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Shoolar_apply_reward>.NameValue> GetValue(Shoolar_apply_reward entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "REWARD_NAME", Value = entity.REWARD_NAME };
            yield return new NameValue() { Name = "REWARD_DATE", Value = entity.REWARD_DATE };
            yield return new NameValue() { Name = "REWARD_DATE_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.REWARD_DATE) };
            //yield return new NameValue() { Name = "REWARD_LEVEL", Value = entity.REWARD_LEVEL };
            yield return new NameValue() { Name = "AWARD_DEPARTMENT", Value = entity.AWARD_DEPARTMENT };
            yield return new NameValue() { Name = "REWARD_TYPE", Value = entity.REWARD_TYPE };
            yield return new NameValue() { Name = "REWARD_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_apply_reward_type", entity.REWARD_TYPE) };
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
            Shoolar_apply_reward head = new Shoolar_apply_reward();
            head.OID = strOID;
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<Shoolar_apply_reward>("Shoolar_apply_rewardDeleteTransaction");
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
            try
            {
                bool res = false;
                Shoolar_apply_reward head = new Shoolar_apply_reward();
                if (string.IsNullOrEmpty(Post("hidOid_Reward")))
                {
                    head.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(head);
                    head.SEQ_NO = Post("hidSeqNo_Reward");
                    head.REWARD_NAME = Post("REWARD_NAME");
                    head.REWARD_DATE = Post("REWARD_DATE");
                    //head.REWARD_LEVEL = Post("REWARD_LEVEL");
                    head.AWARD_DEPARTMENT = Post("AWARD_DEPARTMENT");
                    head.REWARD_TYPE = Post("REWARD_TYPE");
                    var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_apply_reward>("Shoolar_apply_rewardInsertTransaction");
                    inserttrcn.EntityList.Add(head);
                    res = inserttrcn.Commit();
                }
                else
                {
                    head.OID = Post("hidOid_Reward");
                    ds.RetrieveObject(head);
                    head.REWARD_NAME = Post("REWARD_NAME");
                    head.REWARD_DATE = Post("REWARD_DATE");
                    //head.REWARD_LEVEL = Post("REWARD_LEVEL");
                    head.AWARD_DEPARTMENT = Post("AWARD_DEPARTMENT");
                    head.REWARD_TYPE = Post("REWARD_TYPE");
                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Shoolar_apply_reward>("Shoolar_apply_rewardUpdateTransaction", user.User_Name);
                    res = updatetrcn.Commit(head);
                }
                if (res)
                    return head.OID;//成功返回主键
                else
                    return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请，保存获奖情况数据失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 同步获奖情况数据

        /// <summary>
        /// 同步获奖情况数据
        /// </summary>
        /// <returns></returns>
        private string SynchroData()
        {
            string strMsg = string.Empty;
            try
            {
                if (string.IsNullOrEmpty(Get("seq_no")))
                {
                    return string.Format("奖助申请单据编号为空！");
                }

                //先删除数据再新增
                string strSQL1 = string.Format("DELETE FROM SHOOLAR_APPLY_REWARD WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                if (ds.ExecuteTxtNonQuery(strSQL1) < 0)
                    return "同步获奖情况数据失败！";

                ProjectApplyHandleClass.getInstance().InsertInto_apply_reward(Get("seq_no"), out strMsg);
                if (strMsg.Length > 0)
                    return strMsg;

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请，同步获奖情况数据失败：" + ex.ToString());
                return "同步获奖情况数据失败！";
            }
        }

        #endregion 同步获奖情况数据
    }
}