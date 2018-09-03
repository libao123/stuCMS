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
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectApply
{
    /// <summary>
    /// 奖助申请：大文本数据
    /// </summary>
    public partial class TxtInfo : Main
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
                string strSQL = string.Format("DELETE FROM SHOOLAR_APPLY_TXT WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                if (ds.ExecuteTxtNonQuery(strSQL) < 0)
                    return "保存大文本数据失败！";

                var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_apply_txt>("Shoolar_apply_txtInsertTransaction");
                Shoolar_apply_txt head = new Shoolar_apply_txt();
                head.OID = Guid.NewGuid().ToString();
                head.SEQ_NO = Get("seq_no");
                inserttrcn.EntityList.Add(head);
                if (!inserttrcn.Commit())
                    return "保存大文本数据失败！";

                //重新保存界面的文本数据
                StringBuilder strTxt = new StringBuilder();
                strTxt.AppendFormat("APPLY_REASON = '{0}', ", Post("APPLY_REASON"));//申请理由
                strTxt.AppendFormat("SKILL_INFO = '{0}', ", Post("SKILL_INFO"));//英语、计算机过级情况
                strTxt.AppendFormat("PUBLISH_INFO = '{0}', ", Post("PUBLISH_INFO"));//论文发表、获得专利等情况
                strTxt.AppendFormat("MOTTO = '{0}', ", Post("MOTTO"));//人生格言
                strTxt.AppendFormat("TEACHER_INFO = '{0}', ", Post("TEACHER_INFO"));//师长点评
                strTxt.AppendFormat("MODEL_INFO = '{0}' ", Post("MODEL_INFO"));//事迹正文
                if (!ComHandleClass.getInstance().UpdateTextContent(Get("seq_no"), "SEQ_NO", strTxt.ToString(), "SHOOLAR_APPLY_TXT"))
                    return "保存大文本数据失败！";

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请，保存大文本数据失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据
    }
}