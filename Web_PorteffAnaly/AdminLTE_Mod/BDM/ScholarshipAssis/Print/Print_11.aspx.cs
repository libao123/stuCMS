using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.Print
{
    /// <summary>
    /// 国家奖学金（本科）
    /// </summary>
    public partial class Print_11 : Main
    {
        #region 初始化定义

        private comdata cod = new comdata();
        public Shoolar_apply_head head = new Shoolar_apply_head();
        public Shoolar_apply_txt txt = new Shoolar_apply_txt();
        public Basic_stu_info stu = new Basic_stu_info();
        public Shoolar_apply_study study = new Shoolar_apply_study();
        public int nRewardList = 0;
        public string strRewardJson = string.Empty;
        public string strPrintCode = string.Empty;

        #endregion 初始化定义

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
                string strOptype = Request.QueryString["optype"];

                if (!string.IsNullOrEmpty(strOptype))
                {
                    switch (strOptype)
                    {
                        case "print":
                            GetPrintData(Get("id"));
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 数据加载

        /// <summary>
        /// 数据加载
        /// </summary>
        /// <param name="oid"></param>
        private void GetPrintData(string oid)
        {
            #region 奖助申请信息

            //奖助申请信息
            head.OID = oid;
            ds.RetrieveObject(head);
            if (head == null)
                return;

            strPrintCode = ComHandleClass.getInstance().GetStuWorNo(head.STU_NUMBER, head.PROJECT_YEAR);
            head.PROJECT_YEAR = cod.GetDDLTextByValue("ddl_year_type", head.PROJECT_YEAR);
            head.XY = cod.GetDDLTextByValue("ddl_department", head.XY);
            head.ZY = cod.GetDDLTextByValue("ddl_zy", head.ZY);
            //大文本数据
            if (ProjectApplyHandleClass.getInstance().GetTxtInfo(head.SEQ_NO) != null)
                txt = ProjectApplyHandleClass.getInstance().GetTxtInfo(head.SEQ_NO);

            #endregion 奖助申请信息

            #region 学生基础信息

            //学生基础信息
            if (StuHandleClass.getInstance().GetStuInfo_Obj(head.STU_NUMBER) != null)
            {
                stu = StuHandleClass.getInstance().GetStuInfo_Obj(head.STU_NUMBER);
                stu.SEX = cod.GetDDLTextByValue("ddl_xb", stu.SEX);
                stu.POLISTATUS = cod.GetDDLTextByValue("ddl_zzmm", stu.POLISTATUS);
                stu.NATION = cod.GetDDLTextByValue("ddl_mz", stu.NATION);
                stu.SYSTEM = cod.GetDDLTextByValue("ddl_edu_system", stu.SYSTEM);
            }

            #endregion 学生基础信息

            #region 公共参数

            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("SEQ_NO", head.SEQ_NO);

            #endregion 公共参数

            #region 成绩信息

            //成绩信息
            if (ProjectApplyHandleClass.getInstance().GetStudyInfo(param) != null)
            {
                study = ProjectApplyHandleClass.getInstance().GetStudyInfo(param);
                study.IS_SCORE_FLAG = cod.GetDDLTextByValue("ddl_yes_no", study.IS_SCORE_FLAG);
            }

            #endregion 成绩信息

            #region 获奖列表

            //获奖列表
            List<Shoolar_apply_reward> rewardList = ProjectApplyHandleClass.getInstance().GetRewardListInfo(param);
            if (rewardList == null)
                return;

            #region 跨行数

            if (rewardList.Count == 0)
                nRewardList = 1;
            else
                nRewardList = rewardList.Count + 1;

            #endregion 跨行数

            strRewardJson = ProjectResultHandleClass.getInstance().GetRewardList(rewardList);
            StringBuilder strR = new StringBuilder();
            foreach (Shoolar_apply_reward item in rewardList)
            {
                if (item == null)
                    continue;
                strR.AppendFormat("<tr><td>{0}</td><td colspan=\"3\">{1}</td><td colspan=\"2\">{2}</td></tr>", cod.GetDDLTextByValue("ddl_year_type", item.REWARD_DATE), item.REWARD_NAME, item.AWARD_DEPARTMENT);
            }
            divReward.InnerHtml = strR.ToString();

            #endregion 获奖列表
        }

        #endregion 数据加载
    }
}