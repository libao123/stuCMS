using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Notice
{
    public partial class Show : Main
    {
        #region 初始化定义

        public Notice_info head = new Notice_info();
        public Ua_function fun = new Ua_function();
        private comdata cod = new comdata();
        public string NoticeFile = string.Empty;

        #endregion 初始化定义

        #region 窗体加载

        /// <summary>
        /// 窗体加载
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string strOptype = Request.QueryString["optype"];
                string strOid = Request.QueryString["id"];

                if (!string.IsNullOrEmpty(strOptype))
                {
                    switch (strOptype)
                    {
                        case "view":
                            this.LookContent(strOid);
                            break;
                    }
                }
            }
        }

        #endregion 窗体加载

        #region 显示内容

        /// <summary>
        /// 显示内容
        /// </summary>
        /// <param name="strOID"></param>
        private void LookContent(string strOID)
        {
            if (!string.IsNullOrEmpty(strOID))
            {
                head.OID = strOID;
                ds.RetrieveObject(head);
                if (head.FUNCTION_ID.Length > 0)
                {
                    fun.FUNCTIONID = head.FUNCTION_ID;
                    ds.RetrieveObject(fun);
                    //获得附件
                    List<Notice_info_file> fileList = NoticeHandleClass.getInstance().GetNotice_info_fileList(head.OID);
                    if (fileList != null)
                    {
                        StringBuilder strHtml = new StringBuilder();
                        foreach (Notice_info_file file in fileList)
                        {
                            if (file == null)
                                continue;
                            strHtml.AppendFormat("附件：<a id=\"{0}\" title=\"{1}\" onclick=\"OpenFile('{0}')\">{1}</a>", file.OID, file.FILE_NAME);
                            strHtml.Append("<br/>");
                        }
                        NoticeFile = strHtml.ToString();
                    }
                }
            }
        }

        #endregion 显示内容
    }
}