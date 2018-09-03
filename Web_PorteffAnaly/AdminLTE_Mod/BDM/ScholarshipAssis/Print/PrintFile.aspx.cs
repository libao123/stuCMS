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
    public partial class PrintFile : Main
    {
        #region 初始化

        public comdata cod = new comdata();
        public Shoolar_apply_file head = new Shoolar_apply_file();
        public string img_url = string.Empty;//图片路径
        public string strPrintCode = string.Empty;

        #endregion 初始化

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
                string optype = Request.QueryString["optype"];
                switch (optype)
                {
                    case "print":
                        this.Bind();
                        break;
                }
            }
        }

        #endregion 页面加载

        #region 绑定界面信息

        /// <summary>
        /// 绑定界面信息
        /// </summary>
        protected void Bind()
        {
            string OID = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(OID))
            {
                head.OID = OID;
                ds.RetrieveObject(head);
                Dictionary<string, string> param = new Dictionary<string, string>();
                param.Add("SEQ_NO", head.SEQ_NO);
                Shoolar_apply_head apply_head = ProjectApplyHandleClass.getInstance().GetApplyHeadInfo(param);
                strPrintCode = ComHandleClass.getInstance().GetStuWorNo(apply_head.STU_NUMBER, apply_head.PROJECT_YEAR);
                img_url = head.FILE_DIRECTORY + "/" + head.FILE_SAVE_NAME;
            }
        }

        #endregion 绑定界面信息
    }
}