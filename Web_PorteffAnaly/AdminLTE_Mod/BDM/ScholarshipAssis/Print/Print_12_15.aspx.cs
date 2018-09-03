using System;
using System.Collections.Generic;
using System.Data;
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
    ///COUNTRY_ENCOUR：国家励志奖学金：表12
    //AREA_GOV：自治区人民政府奖学金：表15
    /// </summary>
    public partial class Print_12_15 : Main
    {
        #region 初始化定义

        private comdata cod = new comdata();
        public Shoolar_apply_head head = new Shoolar_apply_head();
        public Shoolar_apply_txt txt = new Shoolar_apply_txt();
        public Basic_stu_info stu = new Basic_stu_info();
        public Shoolar_apply_family family = new Shoolar_apply_family();
        public Shoolar_apply_study study = new Shoolar_apply_study();
        public string strTitle = string.Empty;
        public string strPrintCode = string.Empty;
        public int nMemberList = 0;
        public int nScoreList = 3;
        public string strScoreJson = string.Empty;

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
            if (head.PROJECT_TYPE.Equals("COUNTRY_ENCOUR"))//国家励志奖学金
                strTitle = string.Format(" 广西师范大学({0}学年)国家励志奖学金申请表", head.PROJECT_YEAR);
            else if (head.PROJECT_TYPE.Equals("AREA_GOV"))//自治区人民政府奖学金
                strTitle = string.Format(" 广西师范大学({0}学年)自治区人民政府奖学金申请表", head.PROJECT_YEAR);

            head.XY = cod.GetDDLTextByValue("ddl_department", head.XY);
            head.ZY = cod.GetDDLTextByValue("ddl_zy", head.ZY);
            head.GRADE = cod.GetDDLTextByValue("ddl_grade", head.GRADE);
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
            }

            #endregion 学生基础信息

            #region 公共参数

            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("SEQ_NO", head.SEQ_NO);

            #endregion 公共参数

            #region 家庭情况（分为 家庭信息 与 家庭成员）

            #region 家庭信息

            //家庭信息
            if (ProjectApplyHandleClass.getInstance().GetFamilyInfo(param) != null)
            {
                family = ProjectApplyHandleClass.getInstance().GetFamilyInfo(param);
                family.HK = cod.GetDDLTextByValue("ddl_stu_basic_hk", family.HK);
                family.COGRIZA_INFO = cod.GetDDLTextByValue("ddl_dst_level", family.COGRIZA_INFO);
            }

            #endregion 家庭信息

            #region 家庭成员信息

            //家庭成员信息
            List<Shoolar_apply_family_list> familyList = ProjectApplyHandleClass.getInstance().GetFamilyListInfo(param);
            if (familyList != null)
            {
                if (familyList.Count == 0)
                    nMemberList = 1;
                else
                    nMemberList = familyList.Count + 1;

                StringBuilder strM = new StringBuilder();
                foreach (Shoolar_apply_family_list item in familyList)
                {
                    if (item == null)
                        continue;
                    strM.AppendFormat("<tr><td>{0}</td><td>{1}</td><td colspan=\"2\">{2}</td><td colspan=\"3\">{3}</td></tr>", item.MEMBER_NAME, item.MEMBER_AGE, item.MEMBER_RELATION, item.MEMBER_UNIT);
                }
                divMember.InnerHtml = strM.ToString();
            }

            #endregion 家庭成员信息

            #endregion 家庭情况（分为 家庭信息 与 家庭成员）

            #region 获奖情况

            //获得奖助列表
            List<Shoolar_apply_reward> proList = ProjectApplyHandleClass.getInstance().GetRewardListInfo(param);
            if (proList != null)
            {
                if (proList.Count == 0)
                {
                    divReward.InnerHtml = "无";
                }
                else
                {
                    StringBuilder strR = new StringBuilder();
                    foreach (Shoolar_apply_reward item in proList)
                    {
                        if (item == null)
                            continue;
                        strR.AppendFormat("{0}        {1}           {2}<br/>", cod.GetDDLTextByValue("ddl_year_type", item.REWARD_DATE), item.REWARD_NAME, item.AWARD_DEPARTMENT);
                    }
                    divReward.InnerHtml = strR.ToString();
                }
            }

            #endregion 获奖情况

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
                strS.AppendFormat("<tr><td colspan=\"5\">{0}</td><td colspan=\"2\">{1}</td></tr>", item.COURSE_NAME, item.SCORE);
            }
            divScore.InnerHtml = strS.ToString();

            #endregion 科目成绩列表

            #endregion 学习情况（分为 成绩信息 与 科目成绩列表）
        }

        #endregion 数据加载
    }
}