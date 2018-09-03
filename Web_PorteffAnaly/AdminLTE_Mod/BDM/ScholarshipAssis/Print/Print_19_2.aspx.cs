using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.Print
{
    /// <summary>
    /// COUNTRY_YP：国家奖学金（研究生/博士）：研究生国家奖学金申请审批表
    /// </summary>
    public partial class Print_19_2 : Main
    {
        #region 页面加载

        private comdata cod = new comdata();
        public Shoolar_apply_head head = new Shoolar_apply_head();
        public Shoolar_apply_txt txt = new Shoolar_apply_txt();
        public Basic_stu_info stu = new Basic_stu_info();
        public string strTitle = string.Empty;
        public string strPrintCode = string.Empty;

        #endregion 页面加载

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
            head.XY = cod.GetDDLTextByValue("ddl_department", head.XY);
            head.ZY = cod.GetDDLTextByValue("ddl_zy", head.ZY);
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
                stu.NATION = cod.GetDDLTextByValue("ddl_mz", stu.NATION);
                stu.SYSTEM = cod.GetDDLTextByValue("ddl_edu_system", stu.SYSTEM);
            }

            #endregion 学生基础信息
        }

        #endregion 数据加载
    }
}