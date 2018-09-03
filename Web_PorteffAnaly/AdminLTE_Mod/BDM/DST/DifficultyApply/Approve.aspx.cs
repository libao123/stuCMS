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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.DifficultyApply
{
	public partial class Approve : Main
	{
		#region 初始化定义

		protected List<string> DOC_CHANNEL = new List<string> { "D1000", "D2000", "D3000", "D1010", "D2010", "D3010" };
		public comdata cod = new comdata();
		private Dst_stu_apply head = new Dst_stu_apply();

		#endregion 初始化定义

		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				string optype = Request.QueryString["optype"];
				if (!string.IsNullOrEmpty(optype))
				{
					switch (optype.ToLower().Trim())
					{
						case "chk":
							Response.Write(IsCanAudit());
							Response.End();
							break;

                        case "chktime":
                            Response.Write(CheckTime(Get("batch")));
                            Response.End();
                            break;

						case "getopinion":
							Response.Write(GetOpinion());
							Response.End();
							break;
					}
				}
			}
		}

		#region 审核按钮

		protected void Confirm_Click(object sender, EventArgs e)
		{
			string id = Get("id");
            if (Get("optype").Equals("multi"))
                id = GetMultiAuditID();
            if (id.Contains("出错") || id.Contains("失败"))
                doJavaScript(cod.GetJScript("ApplyErrorAndClose", "'" + Get("divid") + "', '审核失败！'"));

			if (AuditData(id))
			{
				//关闭两个窗口，刷新列表
				doJavaScript(cod.GetJScript("ApplySuccessAndClose", "'" + Get("divid") + "', '" + Get("parentdiv") + "', '" + Get("tableid") + "', '审核成功！'"));
			}
			else
			{
				doJavaScript(cod.GetJScript("ApplyErrorAndClose", "'" + Get("divid") + "', '审核失败！'"));
			}
		}

		#endregion 审核按钮

		#region 审核

		private bool AuditData(string id)
		{
			string[] oids = id.Split(',');
			string result = hidresult.Value;
			string cur_level = Get("level");
			string opinion = Post("OPINION");
			string step = hidstep.Value;
			string level = hidlevel.Value.Equals(cur_level) ? cur_level : hidlevel.Value;
			string strUpdate = string.Empty;
			int nAllCount = 0;
			int nAuditErrorCount = 0;

			for (int i = 0; i < oids.Length; i++)
			{
				if (oids[i].Length == 0)
					continue;

				nAllCount++;

				head.OID = oids[i];
				ds.RetrieveObject(head);

                if (!head.POS_CODE.Equals(user.User_Role))//角色不一致，不允许操作
                    continue;

                if (step == "1")
                {
                    level = Post("LEVEL_CODE");
                    strUpdate = string.Format(",LEVEL1='{0}',OPINION1='{1}'", level, opinion);
                }
                else if (step == "2")
                {
                    level = result.Equals("Y") ? head.LEVEL1 : hidlevel.Value;
                    strUpdate = string.Format(",LEVEL2='{0}',OPINION2='{1}'", level, opinion);
                }
                else if (step == "3")
                {
                    level = result.Equals("Y") ? head.LEVEL2 : hidlevel.Value;
                    strUpdate = string.Format(",LEVEL3='{0}',OPINION3='{1}',LEVEL_CODE='{0}'", level, opinion);
                }
                else
                    continue;

				string strResult = string.Empty;
				Common.AuditHandleClass.getInstance().AuditTranHandle(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, "P", cod.GetDDLTextByValue("ddl_dst_opinion", opinion), strUpdate, out strResult);

				if (strResult.Contains("失败"))
				{
					nAuditErrorCount++;
				}
			}

			//全部审批失败时，返回false
			if (nAuditErrorCount == nAllCount)
				return false;

			return true;
		}

		#endregion 审核

		#region 是否可以进行审批
		/// <summary>
		/// 是否可以进行审批
		/// </summary>
		/// <returns></returns>
		private string IsCanAudit()
		{
			string strOut = string.Empty;
			string seq_no = Get("seq_no");
			DataTable tabData = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM DST_STU_APPLY WHERE SEQ_NO='{0}'", seq_no));
			if (!DOC_CHANNEL.Contains(tabData.Rows[0]["RET_CHANNEL"].ToString()))
			{ //只有待审状态才允许进行审批
				strOut = string.Format("只有待审的单据才能进行审批操作！");
			}

			string strTemp = string.Format(",{0},", user.User_Role);
			if (!strTemp.Contains(string.Format(",{0},", tabData.Rows[0]["POS_CODE"].ToString())))
			{//角色一致才允许审批
				strOut = string.Format("对不起，您没有此操作权限！");
			}
            if (strOut.Length == 0)
                strOut = CheckTime(tabData.Rows[0]["BATCH_NO"].ToString());

			//bool bFlag = AuditHandleClass.getInstance().IsCanAudit(Get("doc_type"), Get("seq_no"), user.User_Role, out strOut);

			return strOut;
		}

		#endregion 是否可以进行审批

		#region 根据推荐档次获取意见

		private string GetOpinion()
		{
			string level = Get("level");
			return cod.GetDDLTextByValue("ddl_dst_opinion", level);
		}

		#endregion 根据推荐档次获取意见

        #region 获得批量审核数据集合

        private string GetMultiAuditID()
        {
            string ids = string.Empty;

            #region 查询
            Dictionary<string, string> param = new Dictionary<string, string>();
            string filter = cod.GetDataFilterString(true, "OP_CODE", "CLASS", "COLLEGE");
            if (filter.Length > 0)
                param.Add(filter.Substring(4, filter.Length - 4), string.Empty);
            param.Add(string.Format(DataFilterHandleClass.getInstance().Pend_DataFilter(user.User_Role, CValue.DOC_TYPE_BDM01)), string.Empty);
            if (!string.IsNullOrEmpty(Get("COLLEGE")))
                param.Add("COLLEGE", Get("COLLEGE"));
            if (!string.IsNullOrEmpty(Get("MAJOR")))
                param.Add("MAJOR", Get("MAJOR"));
            if (!string.IsNullOrEmpty(Get("CLASS")))
                param.Add("CLASS", Get("CLASS"));
            if (!string.IsNullOrEmpty(Get("NAME")))
                param.Add(string.Format("NAME LIKE '%{0}%' ", HttpUtility.UrlDecode(Get("NAME"))), string.Empty);
            if (!string.IsNullOrEmpty(Get("SCHYEAR")))
                param.Add("SCHYEAR", Get("SCHYEAR"));
            if (!string.IsNullOrEmpty(Get("RET_CHANNEL")))
                param.Add("RET_CHANNEL", Get("RET_CHANNEL"));
            if (!string.IsNullOrEmpty(Get("DECLARE_TYPE")))
                param.Add("DECLARE_TYPE", Get("DECLARE_TYPE"));
            if (!string.IsNullOrEmpty(Get("LEVEL_CODE")))
            {
                if (user.User_Role.Equals(CValue.ROLE_TYPE_F))
                {
                }
                else if (user.User_Role.Equals(CValue.ROLE_TYPE_Y))
                {
                    param.Add("LEVEL1", Get("LEVEL_CODE"));
                }
                else if (user.User_Role.Equals(CValue.ROLE_TYPE_X))
                {
                    param.Add("LEVEL2", Get("LEVEL_CODE"));
                }
                else
                    param.Add("1", "2");
            }
            List<Dst_stu_apply> applyList = DstApplyHandleClass.getInstance().GetDst_stu_applyArray(param);
            if (applyList == null)
                return "查询批量审批申请数据出错！";
            #endregion 查询

            foreach (Dst_stu_apply apply in applyList)
            {
                ids += apply.OID + ",";
            }
            ids = ids.TrimEnd(',');

            return ids;
        }

        #endregion 获得批量审核数据集合

        #region 不在申请开放时间范围，不允许审核

        private string CheckTime(string batch)
        {
            string result = string.Empty;
            string need = string.Empty;
            bool can = DstParamHandleClass.getInstance().IsCanApply(out result, out need);
            if (!can)
                result = "不在申请开放时间范围，不允许审核";

            //非本批次的，不能直接审核，需要重新提交申请
            Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
            Dst_param_info param_info = DstParamHandleClass.getInstance().GetDst_param_info(new Dictionary<string, string> { { "SCHYEAR", sch_info.CURRENT_YEAR }, { "DECLARE_FLAG", HQ.Model.CValue.FLAG_Y } });
            if (param_info != null && !batch.Equals(param_info.BATCH_NO))
                return "非本批次不能审核";

            return result;
        }

        #endregion
    }
}