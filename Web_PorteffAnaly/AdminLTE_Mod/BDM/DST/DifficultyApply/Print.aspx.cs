using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.DifficultyApply
{

	public partial class Print : Main
	{
		#region 初始化定义

		public comdata cod = new comdata();
		private ComTranClass comTran = new ComTranClass();
		public Dst_stu_apply head = new Dst_stu_apply();
		public Dst_stu_grant grant = new Dst_stu_grant();
        public Dst_family_situa situa = new Dst_family_situa();
        public string strGrant, strLevel1, strLevel2, strLevel3, strLevel4, strAgree2, strNAgree2, strOpinion2, strAgree3, strNAgree3, strOpinion3, strNCJDLK, strDBJT, strguer, strcanji, strqita;
        public ComHandleClass comHandle = new ComHandleClass();
        public bool IsHaveMember = false;//是否有家庭成员：true 有，false 无

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
						case "getgrant":
							Response.Write(GetStudentGrant(Get("seq_no")));
							Response.End();
							break;
					}
				}
			}
		}

		private void GetPrintData(string oid)
		{
			head.OID = oid;
			ds.RetrieveObject(head);
			head.OPINION1 = cod.GetDDLTextByValue("ddl_dst_opinion", head.OPINION1);
			strGrant = GetStudentGrant(head.SEQ_NO);
            GetFamilyMembers();//家庭成员

			#region 民主评议推荐档次
			if (head.LEVEL1 == "A")
			{
				strLevel1 = "▉";
				strLevel2 = "□";
				strLevel3 = "□";
				strLevel4 = "□";
			}
			else if (head.LEVEL1 == "B")
			{
				strLevel1 = "□";
				strLevel2 = "▉";
				strLevel3 = "□";
				strLevel4 = "□";
			}
			else if (head.LEVEL1 == "C")
			{
				strLevel1 = "□";
				strLevel2 = "□";
				strLevel3 = "▉";
				strLevel4 = "□";
			}
            else if (head.LEVEL1 == "D")
            {
                strLevel1 = "□";
                strLevel2 = "□";
                strLevel3 = "□";
                strLevel4 = "▉";
            }
            else
            {
                strLevel1 = "□";
                strLevel2 = "□";
                strLevel3 = "□";
                strLevel4 = "□";
            }
			#endregion 民主评议推荐档次

            #region 档次、意见
            //二级
            if (string.IsNullOrEmpty(head.LEVEL2))
            {
                strAgree2 = "□";
                strNAgree2 = "□";
                strOpinion2 = "          ";
            }
            else
            {
                if (head.LEVEL1 == head.LEVEL2)
                {
                    strAgree2 = "▉";
                    strNAgree2 = "□";
                    strOpinion2 = "          ";
                }
                else
                {
                    strAgree2 = "□";
                    strNAgree2 = "▉";
                    strOpinion2 = cod.GetDDLTextByValue("ddl_dst_level", head.LEVEL2);
                }
            }
            //三级
            if (string.IsNullOrEmpty(head.LEVEL3))
            {
                strAgree3 = "□";
                strNAgree3 = "□";
                strOpinion3 = "          ";
            }
            else
            {
                if (head.LEVEL2 == head.LEVEL3)
                {
                    strAgree3 = "▉";
                    strNAgree3 = "□";
                    strOpinion3 = "          ";
                }
                else
                {
                    strAgree3 = "□";
                    strNAgree3 = "▉";
                    strOpinion3 = cod.GetDDLTextByValue("ddl_dst_level", head.LEVEL3);
                }
            }
            #endregion 档次、意见

            #region 家庭经济特别困难勾选项
            situa = FamilySurveyHandleClass.getInstance().GetDst_family_situa(new Dictionary<string, string> { { "NUMBER", head.NUMBER } });
            if (head.LEVEL_CODE == "A" && situa != null)
            {
                if (situa.IS_POOR.Equals("G") || situa.IS_POOR.Equals("O"))//农村建档立卡
                    strNCJDLK = "▉";
                else
                    strNCJDLK = "□";
                if (situa.IS_MINIMUM == "Y")//低保家庭
                    strDBJT = "▉";
                else
                    strDBJT = "□";
                if (situa.IS_ORPHAN.Equals("Y"))//孤儿
                    strguer = "▉";
                else
                    strguer = "□";
                if (situa.IS_DISABLED.Equals("Y"))//残疾
                    strcanji = "▉";
                else
                    strcanji = "□";
                if (situa.IS_OTHER.Equals("Y") || situa.IS_DESTITUTE.Equals("Y"))//其他
                    strqita = "▉";
                else
                    strqita = "□";
            }
            else
            {
                strNCJDLK = "□";
                strDBJT = "□";
                strguer = "□";
                strcanji = "□";
                strqita = "□";
            }
            #endregion 家庭经济特别困难勾选项
		}

		#region 奖助情况

		private string GetStudentGrant(string seq_no)
		{
			string result = string.Empty;
			int i = 0;
			DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM Dst_stu_grant WHERE SEQ_NO = '{0}' ORDER BY ORDER_NO", seq_no));
			Hashtable ddl = new Hashtable();
			cod.ConvertTabDdl(dt, ddl);
			foreach (DataRow dr in dt.Rows)
			{
				i++;
				result += string.Format("{0}、学年：{1}，项目：{2}，等级：{3}<br />", i, dr["SCHOOL_YEAR"], i, dr["ITEM"], i, dr["RANK"]);
			}
            if (string.IsNullOrEmpty(result))
                result = "无";
			return result;
		}

		#endregion 奖助情况

        #region 家庭成员

        private void GetFamilyMembers()
        {
            string sql = string.Format("SELECT *,CAST(INCOME/12 AS NUMERIC(10,2)) AS INCOME_MON FROM DST_FAMILY_MEMBERS WHERE SEQ_NO=(SELECT SEQ_NO FROM DST_FAMILY_SITUA WHERE NUMBER='{0}') ORDER BY ORDER_NO", head.NUMBER);
            DataTable dt = ds.ExecuteTxtDataTable(sql);
            if (dt != null && dt.Rows.Count > 0)
                IsHaveMember = true;
            Hashtable ddl = new Hashtable();
            ddl = new Hashtable();
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