using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectManage
{
    public partial class NumList : ListBaseLoad<Shoolar_project_num>
    {
        #region 初始化

        protected override string input_code_column
        {
            get { return ""; }
        }

        protected override string class_code_column
        {
            get { return ""; }
        }

        protected override string xy_code_column
        {
            get { return ""; }
        }

        protected override bool is_do_filter
        {
            get { return false; }
        }

        private comdata cod = new comdata();

        protected override SelectTransaction<Shoolar_project_num> GetSelectTransaction()
        {
            if (Request.QueryString["seq_no"] != null && Request.QueryString["seq_no"].Length != 0)
            {
                param.Add("SEQ_NO", Request.QueryString["seq_no"]);
            }
            else
            {
                param.Add(" 1=2 ", "");
            }
            return ImplementFactory.GetSelectTransaction<Shoolar_project_num>("Shoolar_project_numSelectTransaction", param);
        }

        #endregion 初始化

        #region 页面加载

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

                        case "delete"://删除操作
                            Response.Write(DeleteData());
                            Response.End();
                            break;

                        case "save"://保存操作
                            Response.Write(SaveData());
                            Response.End();
                            break;

                        case "add_numhtml"://新增操作：全部学院列表
                            Response.Write(AddNumHtml());
                            Response.End();
                            break;

                        case "edit_numhtml"://修改操作：全部学院列表
                            Response.Write(EditNumHtml());
                            Response.End();
                            break;

                        case "getxy"://全部学院列表JSON
                            Response.Write(GetXyStr());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Shoolar_project_num>.NameValue> GetValue(Shoolar_project_num entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "XY", Value = entity.XY };
            yield return new NameValue() { Name = "XY_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.XY) };
            yield return new NameValue() { Name = "APPLY_NUM", Value = entity.APPLY_NUM.ToString() };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            string strOID = Request.QueryString["id"];

            if (string.IsNullOrEmpty(strOID))
                return "OID为空,不允许删除操作";
            Shoolar_project_num head = new Shoolar_project_num();
            head.OID = strOID;
            ds.RetrieveObject(head);
            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Shoolar_project_num>("Shoolar_project_numDeleteTransaction");
            transaction.EntityList.Add(head);
            bDel = transaction.Commit();

            return string.Empty;
        }

        #endregion 删除数据

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                if (string.IsNullOrEmpty(Post("hidSeqNo_Num")))
                    return string.Empty;
                //先删除后保存
                string strDelSql = string.Format("DELETE FROM SHOOLAR_PROJECT_NUM WHERE SEQ_NO = '{0}' ", Post("hidSeqNo_Num"));
                ds.ExecuteTxtNonQuery(strDelSql);
                DataTable dt = cod.GetDDlDataTable("ddl_department");
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;
                    string strAPPLY_NUM_id = "APPLY_NUM" + "_" + row["VALUE"].ToString();
                    if (string.IsNullOrEmpty(Post(strAPPLY_NUM_id)))
                        continue;
                    int nAPPLY_NUM = cod.ChangeInt(Post(strAPPLY_NUM_id));
                    if (nAPPLY_NUM >= 0)
                    {
                        Shoolar_project_num num = new Shoolar_project_num();
                        num.OID = Guid.NewGuid().ToString();
                        ds.RetrieveObject(num);
                        num.SEQ_NO = Post("hidSeqNo_Num");
                        num.XY = row["VALUE"].ToString();
                        num.APPLY_NUM = nAPPLY_NUM;
                        ds.UpdateObject(num);
                    }
                }

                return "保存成功！";
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助项目设置，人数设置出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 新增操作：全部学院列表

        /// <summary>
        ///新增操作：全部学院列表
        /// </summary>
        /// <returns></returns>
        private string AddNumHtml()
        {
            StringBuilder strHtml = new StringBuilder();
            DataTable dt = cod.GetDDlDataTable("ddl_department");
            foreach (DataRow row in dt.Rows)
            {
                if (row == null)
                    continue;

                strHtml.Append("<div class=\"form-group col-sm-12\">");
                strHtml.AppendFormat("<label class=\"col-sm-4 control-label\">{0}</label>", row["TEXT"].ToString());
                strHtml.Append("<div class=\"col-sm-8\">");
                string strAPPLY_NUM_id = "APPLY_NUM" + "_" + row["VALUE"].ToString();
                strHtml.AppendFormat("<input name=\"{0}\" id=\"{0}\" type=\"text\" class=\"form-control\" placeholder=\"可通过学院审核的人数\" />", strAPPLY_NUM_id);
                strHtml.Append("</div>");
                strHtml.Append("</div>");
            }
            return strHtml.ToString();
        }

        #endregion 新增操作：全部学院列表

        #region 修改操作：全部学院列表

        /// <summary>
        ///修改操作：全部学院列表
        /// </summary>
        /// <returns></returns>
        private string EditNumHtml()
        {
            if (string.IsNullOrEmpty(Get("seq_no")))
                return "关联单据编号不能为空！";

            StringBuilder strHtml = new StringBuilder();
            DataTable dt = cod.GetDDlDataTable("ddl_department");
            foreach (DataRow row in dt.Rows)
            {
                if (row == null)
                    continue;

                //学院
                strHtml.Append("<div class=\"form-group col-sm-12\">");
                strHtml.AppendFormat("<label class=\"col-sm-4 control-label\">{0}</label>", row["TEXT"].ToString());
                strHtml.Append("<div class=\"col-sm-8\">");
                Dictionary<string, string> param = new Dictionary<string, string>();
                param.Add("SEQ_NO", Get("seq_no"));
                param.Add("XY", row["VALUE"].ToString());
                List<Shoolar_project_num> num = ProjectSettingHandleClass.getInstance().GetProjectNum(param);
                string strAPPLY_NUM_id = "APPLY_NUM" + "_" + row["VALUE"].ToString();
                if (num == null || num.Count == 0)
                {
                    strHtml.AppendFormat("<input name=\"{0}\" id=\"{0}\" type=\"text\" class=\"form-control\" placeholder=\"可通过学院审核的人数\" />", strAPPLY_NUM_id);
                }
                else
                {
                    strHtml.AppendFormat("<input name=\"{0}\" id=\"{0}\" value=\"{1}\" type=\"text\" class=\"form-control\" placeholder=\"可通过学院审核的人数\" />", strAPPLY_NUM_id, num[0].APPLY_NUM.ToString());
                }
                strHtml.Append("</div>");
                strHtml.Append("</div>");
            }

            return strHtml.ToString();
        }

        #endregion 修改操作：全部学院列表

        #region 全部学院字符串

        /// <summary>
        /// 全部学院字符串
        /// </summary>
        /// <returns></returns>
        private string GetXyStr()
        {
            string strResult = string.Empty;
            DataTable dt = cod.GetDDlDataTable("ddl_department");
            foreach (DataRow row in dt.Rows)
            {
                if (row == null)
                    continue;
                strResult += row["VALUE"].ToString() + ",";
            }
            return strResult;
        }

        #endregion 全部学院字符串
    }
}