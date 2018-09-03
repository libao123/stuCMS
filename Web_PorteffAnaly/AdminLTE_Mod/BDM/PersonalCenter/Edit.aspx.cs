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
	public partial class Edit : Main
	{
		#region 初始化定义

		public comdata cod = new comdata();
		private ComTranClass comTran = new ComTranClass();
		public Basic_stu_info_modi modi = new Basic_stu_info_modi();
		public Basic_stu_info head = new Basic_stu_info();
		public Dst_family_situa situa = new Dst_family_situa();
		public Dst_family_members member = new Dst_family_members();
		public Dst_stu_apply dst_apply = new Dst_stu_apply();
		public Basic_stu_bank_info bank = new Basic_stu_bank_info();
		public Score_rank_info score = new Score_rank_info();
		public string strN_Province, strN_City, strN_County, strR_Province, strR_City, strR_County, strS_Province, strS_City, strS_County, strADD_Province, strADD_City, strADD_County, strADD_Street, strIDNO, strBankCode, strBankName, strN_Address, strR_Address, strS_Address, strAddress, strCollege, strMajor, strClass;
        public string m_strIsShowAuditBtn = "false";//是否显示审批按钮：显示true 不显示false
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
						case "modi":
							this.Bind(user.User_Id, "S");
							break;
						case "view":
							this.GetData();
							break;
						case "save":
							if(SaveData("save"))
								Response.Write("");
							else
								Response.Write("保存失败");
							Response.End();
							break;
						case "submit":
							Response.Write(btnSubmit());
							Response.End();
							break;
					}

					strAuditOpinion = GetAuditOpinion();
                    if (IsCanAudit())
                    {
                        m_strIsShowAuditBtn = "true";
                    }
				}
			}
		}

		#endregion 窗体加载

		#region 绑定界面数据

		#region 修改
		protected void Bind(string strNumber, string role)
		{
			//不是预录入、审批通过状态不能修改
            //object obj = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM BASIC_STU_INFO_MODI WHERE NUMBER = '{0}' AND RET_CHANNEL NOT IN ('{1}', '{2}')", strNumber, CValue.RET_CHANNEL_A0000, CValue.RET_CHANNEL_D4000));
            //if (obj != null && obj.ToString().Length > 0)
            //{
            //    strIsCanModi = "false";
            //}
			//判断modi表是否有未审批的数据，有则显示modi表，否则显示info表
			object o = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM BASIC_STU_INFO_MODI WHERE NUMBER = '{0}' AND RET_CHANNEL NOT IN ('{1}')", strNumber, CValue.RET_CHANNEL_D4000));
			if (o != null && o.ToString().Length > 0)
			{
				bhead = false;
				hidoid.Value = o.ToString();
				modi.OID = o.ToString();
				ds.RetrieveObject(modi);
				ConvertAddress(modi.NATIVEPLACE, modi.REGISTPLACE, modi.STUPLACE, modi.ADDRESS);
				strIDNO = modi.IDCARDNO;
				strBankName = modi.BANKNAME;
				strBankCode = modi.BANKCODE;
                //已进入审核流程，不能修改
                if (!WKF_AuditHandleCLass.getInstance().IsBeforeApprove(modi.DOC_TYPE, modi.RET_CHANNEL, modi.DECLARE_TYPE))
                    strIsCanModi = "false";
			}
			else
			{
				object h = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM BASIC_STU_INFO WHERE NUMBER = '{0}'", strNumber));
				if (h != null && h.ToString().Length > 0)
				{
					bhead = true;
					hidoid.Value = h.ToString();
					head.OID = h.ToString();
					ds.RetrieveObject(head);
					ConvertAddress(head.NATIVEPLACE, head.REGISTPLACE, head.STUPLACE, head.ADDRESS);
					strIDNO = head.IDCARDNO;
					//银行卡信息
					object b = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM BASIC_STU_BANK_INFO WHERE NUMBER = '{0}'", strNumber));
					if (b != null && b.ToString().Length > 0)
					{
						hidbid.Value = b.ToString();
						bank.OID = b.ToString();
						ds.RetrieveObject(bank);
						strBankName = bank.BANKNAME;
						strBankCode = bank.BANKCODE;
					}
				}
			}
			strCollege = bhead ? head.COLLEGE : modi.COLLEGE;
			strMajor = bhead ? head.MAJOR : modi.MAJOR;
			strClass = bhead ? head.CLASS : modi.CLASS;
		}
		#endregion 修改

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

		#region 获取页面参数

		private void GetValue(Basic_stu_info_modi model)
		{
            model.NOTES = Post("NOTES");//修改内容备注

			#region 基本信息
			model.NAME = Post("NAME");
			model.SEX = Post("SEX");
			model.GARDE = Post("GARDE");
			model.COLLEGE = Post("COLLEGE");
			model.MAJOR = Post("MAJOR");
			model.EDULENTH = Post("EDULENTH");
			model.CLASS = Post("CLASS");
			model.NATION = Post("NATION");
			model.POLISTATUS = Post("POLISTATUS");
			model.REGISTER = Post("REGISTER");
			model.ENTERTIME = Post("ENTERTIME");
			model.IDCARDNO = Post("IDCARDNO");
            model.NATIVEPLACE = string.Format("{0}|{1}|{2}", Post("N_PROVINCE"), Post("N_CITY"), Post("N_COUNTY"));//籍贯
            //model.REGISTPLACE = string.Format("{0}|{1}|{2}", Post("R_PROVINCE"), Post("R_CITY"), Post("R_COUNTY"));//户口所在地
            model.STUPLACE = string.Format("{0}|{1}|{2}", Post("S_PROVINCE"), Post("S_CITY"), Post("S_COUNTY"));//生源地
			#endregion 基本信息

			#region 联系方式
			model.MOBILENUM = Post("MOBILENUM");
			model.EMAIL = Post("EMAIL");
			model.QQNUM = Post("QQNUM");
			model.HOMENUM = Post("HOMENUM");
			model.POSTCODE = Post("POSTCODE");
			model.ADDRESS = string.Format("{0}|{1}|{2}|{3}", Post("ADD_PROVINCE"), Post("ADD_CITY"), Post("ADD_COUNTY"), Post("ADD_STREET"));
			#endregion 联系方式

			#region 其他信息
			model.BANKNAME = Post("BANKNAME");
			model.BANKCODE = Post("BANKCODE").Replace(" ", "");
			#endregion 其他信息
		}

		#endregion 获取页面参数

		#region 保存数据

		private bool SaveData(string type)
		{
			object o = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM BASIC_STU_INFO_MODI WHERE NUMBER = '{0}'", user.User_Id));
			if (o != null && o.ToString().Length > 0)
			{
				modi.OID = o.ToString();
				ds.RetrieveObject(modi);
				GetValue(modi);
				modi.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
				modi.OP_CODE = user.User_Id;
				modi.OP_NAME = user.User_Name;
				modi.RET_CHANNEL = CValue.RET_CHANNEL_A0000;

				var updatetrcn = ImplementFactory.GetUpdateTransaction<Basic_stu_info_modi>("Basic_stu_info_modiUpdateTransaction", user.User_Name);
				if (updatetrcn.Commit(modi))
				{
					return true;
				}
			}
			else
			{
				modi.OID = Guid.NewGuid().ToString();
				GetValue(modi);
				modi.SEQ_NO = GetSeq_no();
				modi.DOC_TYPE = this.Doc_type;
				modi.NUMBER = user.User_Id;
				modi.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
				modi.OP_CODE = user.User_Id;
				modi.OP_NAME = user.User_Name;
				modi.RET_CHANNEL = CValue.RET_CHANNEL_A0000;

				var inserttrcn = ImplementFactory.GetInsertTransaction<Basic_stu_info_modi>("Basic_stu_info_modiInsertTransaction");
				inserttrcn.EntityList.Add(modi);
				if (inserttrcn.Commit())
				{
					return true;
				}
			}

			return false;
		}

		#endregion 保存数据

		#region 保存按钮

		protected void btnSave_Click(object sender, EventArgs e)
		{
			try
			{
				if (SaveData("save"))
				{
					doJavaScript(cod.GetJScript("DialogUtils.newsaveAndRefresh_url", "'保存成功！', '" + string.Format("Edit.aspx?mode=open&optype=modi&id={0}", head.OID) + "'"));
				}
				else
				{
					//doJavaScript(cod.GetJScript("DialogUtils.newsaveAndRefresh_url", "'保存失败！', '" + string.Format("Edit.aspx?mode=open&optype=modi&id={0}", head.OID) + "'"));
					doJavaScript(cod.GetJScript("MsgUtils.info", "'保存失败！', '"));
				}
			}
			catch (Exception ex)
			{
				//doJavaScript(cod.GetJScript("DialogUtils.newsaveAndRefresh_url", "'保存失败！', '" + string.Format("Edit.aspx?mode=open&optype=modi&id={0}", head.OID) + "'"));
				doJavaScript(cod.GetJScript("MsgUtils.info", "'保存失败！', '"));
			}
		}

		#endregion 保存按钮

		#region 提交按钮

		private string btnSubmit()
		{
			try
			{
				if (SaveData("submit"))
				{
					string msg = string.Empty;
					bool result = WKF_ExternalInterface.getInstance().WKF_BusDeclare(modi.DOC_TYPE, modi.SEQ_NO, user.User_Id, user.User_Type, "修改个人信息", out msg);
					if (result)
					{
						return "";
					}
					else
					{
						return "提交失败";
					}
				}
				else
				{
					return "提交失败";
				}
			}
			catch (Exception ex)
			{
				return "提交失败:"+ex.Message;
			}
		}

		#endregion 提交按钮

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