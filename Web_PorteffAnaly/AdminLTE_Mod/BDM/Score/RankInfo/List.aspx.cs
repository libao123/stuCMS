using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Score.RankInfo
{
    public partial class List : Main
    {
        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public string strLastYear = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            //ZZ 20171024 默认学年：成绩默认是上一学年
            strLastYear = (cod.ChangeInt(sch_info.CURRENT_YEAR) - 1).ToString();
        }
    }
}