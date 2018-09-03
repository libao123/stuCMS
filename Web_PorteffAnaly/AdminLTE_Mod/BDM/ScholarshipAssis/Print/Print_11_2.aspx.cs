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
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.Print
{
    /// <summary>
    /// 先进事迹
    /// </summary>
    public partial class Print_11_2 : Main
    {
        #region 初始化定义

        private comdata cod = new comdata();
        public Shoolar_apply_head head = new Shoolar_apply_head();
        public Shoolar_apply_txt txt = new Shoolar_apply_txt();
        public Basic_stu_info stu = new Basic_stu_info();
        public string strTitle = string.Empty;
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
            //标题
            if (head.PROJECT_TYPE.Equals("COUNTRY_B"))//国家奖学金（本科）
                strTitle = string.Format("国家奖学金申请者个人先进事迹");
            else if (head.PROJECT_TYPE.Equals("SCHOOL_MODEL"))//三好学生标兵
                strTitle = string.Format("校级三好学生标兵申请者个人先进事迹");

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
                stu.NATION = cod.GetDDLTextByValue("ddl_mz", stu.NATION);
            }

            #endregion 学生基础信息

            #region 获奖情况（区分获奖列表与奖助列表）

            #region 获奖列表

            //获奖列表
            Dictionary<string, string> param_o = new Dictionary<string, string>();
            param_o.Add("SEQ_NO", head.SEQ_NO);
            param_o.Add(string.Format("REWARD_TYPE != 'P' "), "");//其他
            List<Shoolar_apply_reward> rewardList = ProjectApplyHandleClass.getInstance().GetRewardListInfo(param_o);
            if (rewardList != null)
            {
                if (rewardList.Count == 0)
                {
                    divReward.InnerHtml = "无";
                }
                else
                {
                    StringBuilder strR_O = new StringBuilder();
                    foreach (Shoolar_apply_reward item in rewardList)
                    {
                        if (item == null)
                            continue;
                        strR_O.AppendFormat("{0}      {1}         {2}<br/>", cod.GetDDLTextByValue("ddl_year_type", item.REWARD_DATE), item.REWARD_NAME, item.AWARD_DEPARTMENT);
                    }
                    divReward.InnerHtml = strR_O.ToString();
                }
            }

            #endregion 获奖列表

            #region 奖助列表

            //奖助列表
            Dictionary<string, string> param_p = new Dictionary<string, string>();
            param_p.Add("SEQ_NO", head.SEQ_NO);
            param_p.Add("REWARD_TYPE", "P");//奖助
            List<Shoolar_apply_reward> proList = ProjectApplyHandleClass.getInstance().GetRewardListInfo(param_p);
            if (proList != null)
            {
                if (proList.Count == 0)
                {
                    divPassPro.InnerHtml = "无";
                }
                else
                {
                    StringBuilder strR_P = new StringBuilder();
                    foreach (Shoolar_apply_reward item in rewardList)
                    {
                        if (item == null)
                            continue;
                        strR_P.AppendFormat("{0}      {1}         {2}<br/>", cod.GetDDLTextByValue("ddl_year_type", item.REWARD_DATE), item.REWARD_NAME, item.AWARD_DEPARTMENT);
                    }
                    divPassPro.InnerHtml = strR_P.ToString();
                }
            }

            #endregion 奖助列表

            #endregion 获奖情况（区分获奖列表与奖助列表）
        }

        #endregion 数据加载
    }
}