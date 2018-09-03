using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using System;

namespace PorteffAnaly.Web.AdminLTE_Mod.SysBasic.sch
{
	public partial class List : Main
	{
		#region 初始化

		public comdata cod = new comdata();
		public ComHandleClass chc = new ComHandleClass();
		public Basic_sch_info head = new Basic_sch_info();

		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				string optype = Request.QueryString["optype"];

				if (!string.IsNullOrEmpty(optype))
				{
					switch (optype.ToLower().Trim())
					{
						case "save":
							Response.Write(SaveData());
							Response.End();
							break;
					}
				}

				LoadData();
			}
		}

		#endregion 初始化

		#region 界面数据加载

		/// <summary>
		/// 加载界面数据
		/// </summary>
		private void LoadData()
		{
			head = chc.GetCurrentSchYearXqInfo();
		}

		#endregion 界面数据加载

		#region 保存数据

		/// <summary>
		/// 保存数据
		/// </summary>
		/// <returns></returns>
		private string SaveData()
		{
			try
			{
				Basic_sch_info head = new Basic_sch_info();
				head.SCHOOL_CODE = Post("SCHOOL_CODE");
				ds.RetrieveObject(head);
				head.SCHOOL_NAME = Post("SCHOOL_NAME");
				head.CURRENT_YEAR = Post("CURRENT_YEAR");
				head.CURRENT_XQ = Post("CURRENT_XQ");

				ds.UpdateObject(head);
				UpdateContent(head.SCHOOL_CODE, Post("REMARK"));
				return "";
			}

			catch (Exception ex)
			{
				return ex.Message;
			}
		}

		private bool UpdateContent(string strKey, string strContent)
		{
			string strContent_new = string.Format(" REMARK = '{0}' ", strContent);
			return chc.UpdateTextContent(strKey, "SCHOOL_CODE", strContent_new, "BASIC_SCH_INFO");
		}

		#endregion 保存数据
	}
}