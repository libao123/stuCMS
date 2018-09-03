using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.NationalData.Dst
{
    public partial class List : Main
    {
        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        protected void Page_Load(object sender, EventArgs e)
        {
        }
    }
}