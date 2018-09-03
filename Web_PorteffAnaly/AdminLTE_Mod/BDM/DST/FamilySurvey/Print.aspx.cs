using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.FamilySurvey
{
	public partial class Print : Main
	{
		#region 初始化定义

		public comdata cod = new comdata();
		private ComTranClass comTran = new ComTranClass();
		public Dst_family_situa head = new Dst_family_situa();
		public Dst_family_members menbers = new Dst_family_members();
		public string strNumber, strAddress, strProvince, strCity, strCounty, strStreet, strM_Address, strM_Province, strM_City, strM_County, strM_Street, strMembers;
        public string strHUKOU_U, strHUKOU_R, strOrphan, strDisabled, strSingle, strMartyrs, strMinimum, strPoor, strOther;
        public bool IsHaveMember = false;//是否有家庭成员：true 有，false 无
        public int row = 2;

		#endregion 初始化定义

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

		private void GetPrintData(string oid)
		{
			head.OID = oid;
			ds.RetrieveObject(head);

			strProvince = ComHandleClass.getInstance().GetAddrSplit(head.ADDRESS, 0);
			strCity = ComHandleClass.getInstance().GetAddrSplit(head.ADDRESS, 1);
			strCounty = ComHandleClass.getInstance().GetAddrSplit(head.ADDRESS, 2);
			strStreet = ComHandleClass.getInstance().GetAddrSplit(head.ADDRESS, 3);
			strAddress = ComHandleClass.getInstance().ConvertAddress(head.ADDRESS);

			GetFamilyMembers(head.SEQ_NO);

            #region 户口
            if (head.HUKOU_BEFORE.Equals("URBAN"))
            {
                strHUKOU_U = "▉";
                strHUKOU_R = "□";
            }
            else if (head.HUKOU_BEFORE.Equals("RURAL"))
            {
                strHUKOU_U = "□";
                strHUKOU_R = "▉";
            }
            else
            {
                strHUKOU_U = "□";
                strHUKOU_R = "□";
            }
            #endregion 户口

            #region 家庭类型
            //孤儿
            if (head.IS_ORPHAN.Equals("Y"))
                strOrphan = "▉";
            else
                strOrphan = "□";
            //单亲
            if (head.IS_SINGLE.Equals("Y"))
                strSingle = "▉";
            else
                strSingle = "□";
            //残疾
            if (head.IS_DISABLED.Equals("Y"))
                strDisabled = "▉";
            else
                strDisabled = "□";
            //烈士或优抚对象子女
            if (head.IS_MARTYRS.Equals("Y"))
                strMartyrs = "▉";
            else
                strMartyrs = "□";
            //低保家庭
            if (head.IS_MINIMUM.Length > 0)
                strMinimum = "▉";
            else
                strMinimum = "□";
            //建档立卡贫困户
            if (head.IS_POOR.Length > 0)
                strPoor = "▉";
            else
                strPoor = "□";
            //其他
            if (head.IS_OTHER.Equals("Y") || head.IS_DESTITUTE.Equals("Y"))
                strOther = "▉";
            else
                strOther = "□";
            #endregion 家庭类型

        }

		#region 家庭成员

		private void GetFamilyMembers(string seq_no)
		{
			string result = string.Empty;
			DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM Dst_family_members WHERE SEQ_NO = '{0}' ORDER BY ORDER_NO", seq_no));
            if (dt != null && dt.Rows.Count > 0)
            {
                IsHaveMember = true;
                row = dt.Rows.Count;
            }
			Hashtable ddl = new Hashtable();
			ddl["RELATION"] = "ddl_relation";
			ddl["PROFESSION"] = "ddl_profession";
			ddl["HEALTH"] = "ddl_health";
			cod.ConvertTabDdl(dt, ddl);
            repMember.DataSource = dt;
            repMember.DataBind();
		}

		#endregion 家庭成员
	}
}