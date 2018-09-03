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
    ///  COUNTRY_YP：国家奖学金（研究生/博士）：表19+1,19+2
    ///  COUNTRY_STUDY：国家学业奖学金：表20
    ///  SCHOOL_NOTCOUNTRY：非国家级奖学金：表21
    ///  SOCIETY_NOCOUNTRY：非国家级奖学金：表21
    /// </summary>
    public partial class Print_19_20_21 : Main
    {
        #region 初始化定义

        private comdata cod = new comdata();
        public Shoolar_apply_head head = new Shoolar_apply_head();
        public Shoolar_apply_txt txt = new Shoolar_apply_txt();
        public Basic_stu_info stu = new Basic_stu_info();
        public Shoolar_apply_study study = new Shoolar_apply_study();
        public string strTitle = string.Empty;
        public int nScoreList = 2;
        public string strScoreJson = string.Empty;
        public string strPrintCode = string.Empty;

        #endregion 初始化定义

        #region 页面加载

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
            //标题
            if (head.PROJECT_TYPE.Equals("COUNTRY_YP"))//国家奖学金（研究生/博士）
                strTitle = string.Format("广西师范大学{0}学年研究生国家奖学金申请审批表", head.PROJECT_YEAR);
            else if (head.PROJECT_TYPE.Equals("COUNTRY_STUDY"))//国家学业奖学金
                strTitle = string.Format(" 广西师范大学({0}学年)学业奖学金申请审批表", head.PROJECT_YEAR);
            else if (head.PROJECT_TYPE.Equals("SCHOOL_NOTCOUNTRY"))//非国家级奖学金
                strTitle = string.Format(" 广西师范大学({0}学年)研究生{1}申请审批表", head.PROJECT_YEAR, head.PROJECT_NAME);

            head.XY = cod.GetDDLTextByValue("ddl_department", head.XY);
            head.ZY = cod.GetDDLTextByValue("ddl_zy", head.ZY);
            head.TRAIN_TYPE = cod.GetDDLTextByValue("ddl_apply_train_type", head.TRAIN_TYPE);
            head.STUDY_LEVEL = cod.GetDDLTextByValue("ddl_apply_study_level", head.STUDY_LEVEL);
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

            #region 学习情况（分为 成绩信息 与 科目成绩列表）

            #region 成绩信息

            //成绩信息
            if (ProjectApplyHandleClass.getInstance().GetStudyInfo(param) != null)
            {
                study = ProjectApplyHandleClass.getInstance().GetStudyInfo(param);
                study.IS_SCORE_FLAG = cod.GetDDLTextByValue("ddl_yes_no", study.IS_SCORE_FLAG);
            }

            #endregion 成绩信息

            #region 科目成绩列表

            //科目成绩列表
            List<Shoolar_apply_study_list> studyList = ProjectApplyHandleClass.getInstance().GetStudyListInfo(param);
            if (studyList == null)
                return;
            if (studyList.Count != 0)
                nScoreList = nScoreList + studyList.Count;
            StringBuilder strS = new StringBuilder();
            foreach (Shoolar_apply_study_list item in studyList)
            {
                if (item == null)
                    continue;
                strS.AppendFormat("<tr><td colspan=\"4\">{0}</td><td colspan=\"2\">{1}</td></tr>", item.COURSE_NAME, item.SCORE);
            }
            divScore.InnerHtml = strS.ToString();

            #endregion 科目成绩列表

            #endregion 学习情况（分为 成绩信息 与 科目成绩列表）

            #region 获奖列表

            //获奖列表
            List<Shoolar_apply_reward> rewardList = ProjectApplyHandleClass.getInstance().GetRewardListInfo(param);
            if (rewardList != null)
            {
                if (rewardList.Count == 0)
                {
                    divReward.InnerHtml = "无";
                }
                else
                {
                    StringBuilder strR = new StringBuilder();
                    foreach (Shoolar_apply_reward item in rewardList)
                    {
                        if (item == null)
                            continue;
                        strR.AppendFormat("{0}      {1}         {2}<br/>", cod.GetDDLTextByValue("ddl_year_type", item.REWARD_DATE), item.REWARD_NAME, item.AWARD_DEPARTMENT);
                    }
                    divReward.InnerHtml = strR.ToString();
                }
            }

            #endregion 获奖列表
        }

        #endregion 数据加载
    }
}