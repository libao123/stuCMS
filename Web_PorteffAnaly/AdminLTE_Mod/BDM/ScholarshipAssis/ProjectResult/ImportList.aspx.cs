using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectResult
{
    /// <summary>
    /// 线下奖助数据导入
    /// </summary>
    public partial class ImportList : Main
    {
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        protected void Page_Load(object sender, EventArgs e)
        {
        }
    }
}