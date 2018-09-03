using AdminLTE_Mod.Common;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter
{
	public partial class Process : Main
	{
		#region 初始化定义

		public comdata cod = new comdata();
		private ComTranClass comTran = new ComTranClass();
        //格式："表名", "学号"
		private Dictionary<string, string> TableList_S = new Dictionary<string, string>(){
			{"BASIC_STU_INFO_MODI", "NUMBER"},//个人信息修改
            {"DST_STU_APPLY", "NUMBER"},//困难生申请
            {"SHOOLAR_APPLY_HEAD", "STU_NUMBER"}//奖助申请
        };
        //格式："表名", "DOC_TYPE,INPUT_CODE_COLUMN,CLASS_CODE_COLUMN,XY_CODE_COLUMN"
        private Dictionary<string, string> TableList_T = new Dictionary<string, string>(){
			{"BASIC_STU_INFO_MODI", "BDM05,NUMBER,CLASS,COLLEGE"},//个人信息修改审核
            {"DST_STU_APPLY", "BDM01,NUMBER,CLASS,COLLEGE"},//困难生申请审核
            {"SHOOLAR_APPLY_HEAD", "BDM03,STU_NUMBER,CLASS_CODE,XY"},//奖助申请审核
            {"UA_CLASS_GROUP", "UA01,DECL_NUMBER,CLASSCODE,XY"}//编班管理审核
        };

		#endregion 初始化定义

		#region 窗体加载

		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				string optype = Request.QueryString["optype"];
				if (!string.IsNullOrEmpty(optype))
				{
					switch (optype.ToLower().Trim())
					{
						case "getlist":
							Response.Write(GetList());
							Response.End();
							break;
					}
				}
			}
		}

		#endregion 窗体加载

        #region 获取数据
        /// <summary>
        /// 学生：提交申报及之后的审核环节都属于“已办”
        /// 教师：自己已审及上级已审都属于“已办”
        /// </summary>
        /// <returns></returns>
		private string GetList()
		{
			StringBuilder strSQL = new StringBuilder();
			Hashtable ddl = new Hashtable();
			ddl["DOC_TYPE"] = "ddl_doc_type";
            if (user.User_Role.Equals(CValue.ROLE_TYPE_S))
            {
                ddl["RET_CHANNEL"] = "ddl_RET_CHANNEL";
                foreach (var table in TableList_S)
                {
                    strSQL.AppendFormat("SELECT OID,SEQ_NO,DOC_TYPE,RET_CHANNEL FROM {0} WHERE {1} = '{2}' AND RET_CHANNEL NOT IN ('A0000') UNION ALL ", table.Key, table.Value, user.User_Id);
                }
            }
            else
            {
                foreach (var table in TableList_T)
                {
                    string[] arr = table.Value.Split(',');
                    string strFilter = DataFilterHandleClass.getInstance().Proc_DataFilter(user.User_Role, arr[0]);
                    strFilter += cod.GetDataFilterString(true, arr[1], arr[2], arr[3]);
                    if (!table.Key.Equals("UA_CLASS_GROUP"))
                        strSQL.AppendFormat("SELECT DOC_TYPE,COUNT(1) QTY FROM {0} WHERE {1} GROUP BY DOC_TYPE UNION ALL ", table.Key, strFilter);
                    else
                        strSQL.AppendFormat("SELECT DOC_TYPE,COUNT(1) QTY FROM (SELECT A.CLASSCODE,A.XY,B.* FROM BASIC_CLASS_INFO A INNER JOIN UA_CLASS_GROUP B ON A.CLASSCODE = B.GROUP_CLASS) T WHERE {1} GROUP BY DOC_TYPE UNION ALL ", table.Key, strFilter);
                }
            }

			DataTable dt = ds.ExecuteTxtDataTable(strSQL.ToString().Substring(0, strSQL.ToString().Length - 10));
			if (ddl != null && ddl.Count > 0)
			{
				cod.ConvertTabDdl(dt, ddl);
			}

			return DataTableToJson(dt);
		}
		private string DataTableToJson(DataTable dt)
		{
			int draw = 1;
			if (Post("draw") != null)
				int.TryParse(Post("draw"), out draw);
			return string.Format("{{\"draw\":{0},\"recordsTotal\":{1},\"recordsFiltered\":{2},\"data\":[{3}]}}", draw, dt.Rows.Count, dt.Rows.Count, Json.DatatableToJson(dt));
        }
        #endregion 获取数据
    }
}