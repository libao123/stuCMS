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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectApply
{
    /// <summary>
    /// 奖助申请：家庭情况
    /// </summary>
    public partial class FamilyInfo : Main
    {
        #region 初始化

        public comdata cod = new comdata();

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

        #region 保存数据

        /// <summary>
        ///保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                //先删除数据再新增
                string strSQL = string.Format("DELETE FROM SHOOLAR_APPLY_FAMILY WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                if (ds.ExecuteTxtNonQuery(strSQL) < 0)
                    return "保存家庭基本情况失败！";
                var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_apply_family>("Shoolar_apply_familyInsertTransaction");
                Shoolar_apply_family head = new Shoolar_apply_family();
                head.OID = Guid.NewGuid().ToString();
                head.SEQ_NO = Get("seq_no");
                head.HK = Post("HK");
                head.INCOME_SOURCE = Post("INCOME_SOURCE");
                head.TOTAL_INCOME = Math.Round(cod.ChangeDecimal(Post("TOTAL_INCOME")), 1);
                head.PREMONTH_INCOME = Math.Round(cod.ChangeDecimal(Post("PREMONTH_INCOME")), 1);
                head.FAMILY_NUM = cod.ChangeInt(Post("FAMILY_NUM"));
                head.POSTCODE = Post("POSTCODE");
                head.ADDRESS = Post("ADDRESS");
                head.COGRIZA_INFO = Post("COGRIZA_INFO");
                head.IS_JDLK = Post("IS_JDLK");
                inserttrcn.EntityList.Add(head);
                if (!inserttrcn.Commit())
                    return "保存家庭基本情况失败！";
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请，家庭情况保存失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 同步家庭情况数据

        /// <summary>
        /// 同步家庭情况数据
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
                string strSQL1 = string.Format("DELETE FROM SHOOLAR_APPLY_FAMILY WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                if (ds.ExecuteTxtNonQuery(strSQL1) < 0)
                    return "同步家庭情况数据失败！";
                string strSQL2 = string.Format("DELETE FROM SHOOLAR_APPLY_FAMILY_LIST WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                if (ds.ExecuteTxtNonQuery(strSQL2) < 0)
                    return "同步家庭情况数据失败！";

                ProjectApplyHandleClass.getInstance().InsertInto_apply_family(Get("seq_no"), out strMsg);
                if (strMsg.Length > 0)
                    return strMsg;

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请，同步家庭情况数据失败：" + ex.ToString());
                return "同步家庭情况数据失败！";
            }
        }

        #endregion 同步家庭情况数据
    }
}