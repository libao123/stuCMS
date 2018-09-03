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
    /// 奖助申请：学习情况
    /// </summary>
    public partial class StudyInfo : Main
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
                string strSQL = string.Format("DELETE FROM SHOOLAR_APPLY_STUDY WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                if (ds.ExecuteTxtNonQuery(strSQL) < 0)
                    return "保存上学年度综合考评成绩失败！";
                var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_apply_study>("Shoolar_apply_studyInsertTransaction");
                Shoolar_apply_study head = new Shoolar_apply_study();
                head.OID = Guid.NewGuid().ToString();
                head.SEQ_NO = Get("seq_no");
                head.SCORE_RANK = cod.ChangeInt(Post("SCORE_RANK"));
                head.SCORE_TOTAL_NUM = cod.ChangeInt(Post("SCORE_TOTAL_NUM"));
                head.MUST_COURSE_NUM = cod.ChangeInt(Post("MUST_COURSE_NUM"));
                head.PASS_COURSE_NUM = cod.ChangeInt(Post("PASS_COURSE_NUM"));
                head.COM_SCORE_RANK = cod.ChangeInt(Post("COM_SCORE_RANK"));
                head.COM_SCORE_TOTAL_NUM = cod.ChangeInt(Post("COM_SCORE_TOTAL_NUM"));
                head.COM_SCORE = cod.ChangeDecimal(Post("COM_SCORE"));
                head.IS_SCORE_FLAG = Post("IS_SCORE_FLAG");
                head.PREYEAR_SCORE = Math.Round(cod.ChangeDecimal(Post("PREYEAR_SCORE")), 1);
                inserttrcn.EntityList.Add(head);
                if (!inserttrcn.Commit())
                    return "保存上学年度综合考评成绩失败！";
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请，保存学年度综合考评成绩失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 同步学习情况数据

        /// <summary>
        /// 同步学习情况数据
        /// </summary>
        /// <returns></returns>
        private string SynchroData()
        {
            string strMsg = string.Empty;
            try
            {
                if (string.IsNullOrEmpty(Get("seq_no")))
                {
                    return string.Format("奖助申请单据编号不能为空！");
                }

                //先删除数据再新增
                string strSQL1 = string.Format("DELETE FROM SHOOLAR_APPLY_STUDY WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                if (ds.ExecuteTxtNonQuery(strSQL1) < 0)
                    return "同步学习情况数据失败！";
                //string strSQL2 = string.Format("DELETE FROM SHOOLAR_APPLY_STUDY_LIST WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                //if (ds.ExecuteTxtNonQuery(strSQL2) < 0)
                //    return "同步学习情况数据失败！";

                ProjectApplyHandleClass.getInstance().InsertInto_apply_score(Get("seq_no"), out strMsg);
                if (strMsg.Length > 0)
                    return strMsg;
                //尚未有相关信息，暂时屏蔽
                //ProjectApplyHandleClass.getInstance().InsertInto_apply_score_list(Get("seq_no"), out strMsg);
                //if (strMsg.Length > 0)
                //    return strMsg;
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请，同步学习情况数据失败：" + ex.ToString());
                return "同步学习情况数据失败！";
            }
        }

        #endregion 同步学习情况数据
    }
}