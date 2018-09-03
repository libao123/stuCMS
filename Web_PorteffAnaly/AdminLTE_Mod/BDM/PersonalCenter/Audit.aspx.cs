using HQ.Architecture.Factory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter
{
    public partial class Audit : Main
	{
		#region 初始化定义

		public comdata cod = new comdata();
		private ComTranClass comTran = new ComTranClass();
		public Basic_stu_info_modi modi = new Basic_stu_info_modi();
		public Basic_stu_info head = new Basic_stu_info();
		public Basic_stu_bank_info bank = new Basic_stu_bank_info();
		public Score_rank_info score = new Score_rank_info();
		public string strN_Province, strN_City, strN_County, strR_Province, strR_City, strR_County, strS_Province, strS_City, strS_County, strADD_Province, strADD_City, strADD_County, strADD_Street, strIDNO, strBankCode, strBankName, strN_Address, strR_Address, strS_Address, strAddress, strCollege, strMajor, strClass;
		public string m_strIsShowAuditBtn = "true";//是否显示审批按钮：显示true 不显示false
		public string strIsCanModi = "true";//是否可以加载修改页面：可以true 不可以false
		public bool bhead = true;//数据来源是否为Basic_stu_info
		public string strAuditOpinion = string.Empty;

		public override string Doc_type { get { return "BDM05"; } }

		#endregion 初始化定义

		#region 窗体加载

		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				string strOptype = Request.QueryString["optype"];

				if (!string.IsNullOrEmpty(strOptype))
				{
					switch (strOptype)
					{
						case "audit":
							this.GetData();
							break;
					}

					strAuditOpinion = GetAuditOpinion();
					if (!IsCanAudit())
					{
						m_strIsShowAuditBtn = "false";
					}
				}
			}
		}

		#endregion 窗体加载

		#region 绑定界面数据

		#region 审批/查阅
		protected void GetData()
		{
			string id = Get("id");
			string strNumber = Get("number");
			if (id.Length == 0)
			{
				object oid = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM BASIC_STU_INFO_MODI WHERE NUMBER = '{0}' ", strNumber));
				if (oid != null && oid.ToString().Length > 0)
					id = oid.ToString().ToString();
				else
					return;
			}

			bhead = false;
			hidoid.Value = id;
			modi.OID = id;
			ds.RetrieveObject(modi);
			ConvertAddress(modi.NATIVEPLACE, modi.REGISTPLACE, modi.STUPLACE, modi.ADDRESS);
			strIDNO = modi.IDCARDNO;
			strBankName = modi.BANKNAME;
			strBankCode = modi.BANKCODE;
			strCollege = bhead ? head.COLLEGE : modi.COLLEGE;
			strMajor = bhead ? head.MAJOR : modi.MAJOR;
			strClass = bhead ? head.CLASS : modi.CLASS;

            head = StuHandleClass.getInstance().GetStuInfo_Obj(strNumber);
            if (head == null)
                head = new Basic_stu_info();

            bank = StuHandleClass.getInstance().GetBankInfo_Obj(strNumber);
            if (bank == null)
                bank = new Basic_stu_bank_info();
		}

		#endregion 审批/查阅

		#endregion 绑定界面数据

		#region 地址转换

		private void ConvertAddress(string strN_Addr, string strR_Addr, string strS_Addr, string strAddr)
		{
            //籍贯
            strN_Province = ComHandleClass.getInstance().GetAddrSplit(strN_Addr, 0);
            strN_City = ComHandleClass.getInstance().GetAddrSplit(strN_Addr, 1);
            strN_County = ComHandleClass.getInstance().GetAddrSplit(strN_Addr, 2);
            strN_Address = ComHandleClass.getInstance().ConvertAddress(strN_Addr);
            //户口所在地
            strR_Province = ComHandleClass.getInstance().GetAddrSplit(strR_Addr, 0);
            strR_City = ComHandleClass.getInstance().GetAddrSplit(strR_Addr, 1);
            strR_County = ComHandleClass.getInstance().GetAddrSplit(strR_Addr, 2);
            strR_Address = ComHandleClass.getInstance().ConvertAddress(strR_Addr);
            //生源地（高考时户籍所在地）
            strS_Province = ComHandleClass.getInstance().GetAddrSplit(strS_Addr, 0);
            strS_City = ComHandleClass.getInstance().GetAddrSplit(strS_Addr, 1);
            strS_County = ComHandleClass.getInstance().GetAddrSplit(strS_Addr, 2);
            strS_Address = ComHandleClass.getInstance().ConvertAddress(strS_Addr);
            //家庭地址
            strADD_Province = ComHandleClass.getInstance().GetAddrSplit(strAddr, 0);
            strADD_City = ComHandleClass.getInstance().GetAddrSplit(strAddr, 1);
            strADD_County = ComHandleClass.getInstance().GetAddrSplit(strAddr, 2);
            strADD_Street = ComHandleClass.getInstance().GetAddrSplit(strAddr, 3);
            strAddress = ComHandleClass.getInstance().ConvertAddress(strAddr);
		}

		#endregion 地址转换

		#region 判断是否允许审批

		private bool IsCanAudit()
		{
			if (modi.RET_CHANNEL.Equals(WKF_VLAUES.RET_CHANNEL_D4000) || modi.RET_CHANNEL.Equals(WKF_VLAUES.RET_CHANNEL_A0000))
				return false;

			string strOut = WKF_ExternalInterface.getInstance().ChkAudit(modi.DOC_TYPE, modi.SEQ_NO, user.User_Role);
			if (string.IsNullOrEmpty(strOut))
				return true;
			else
				return false;
		}

		#endregion 判断是否允许审批

		#region 获取审核意见

		private string GetAuditOpinion()
		{
			string strResult = string.Empty;
			DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM BASIC_STU_INFO_MODI WHERE NUMBER = '{0}' AND RET_CHANNEL IN  ('{1}', '{2}')", user.User_Id, CValue.RET_CHANNEL_A0000, CValue.RET_CHANNEL_D4000));
			if (dt != null && dt.Rows.Count > 0)
			{
				strResult = dt.Rows[0]["OP_NOTE"].ToString();
				//DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT TOP 1 * FROM WKF_CLIENT_LOG WHERE DOC_NO = '{0}' ORDER BY HANDLE_TIME DESC", obj.ToString()));
				//if (dt != null && dt.Rows.Count > 0)
				//    strResult = dt.Rows[0]["HANDLE_MSG"].ToString();
			}

			return strResult;
		}

		#endregion
	}
}