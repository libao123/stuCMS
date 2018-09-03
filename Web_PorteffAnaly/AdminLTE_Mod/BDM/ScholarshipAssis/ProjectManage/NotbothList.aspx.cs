using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectManage
{
    public partial class NotbothList : ListBaseLoad<Shoolar_project_notboth>
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

        protected override SelectTransaction<Shoolar_project_notboth> GetSelectTransaction()
        {
            if (Request.QueryString["seq_no"] != null && Request.QueryString["seq_no"].Length != 0)
            {
                param.Add("SEQ_NO", Request.QueryString["seq_no"]);
            }
            else
            {
                param.Add(" 1=2 ", "");
            }
            return ImplementFactory.GetSelectTransaction<Shoolar_project_notboth>("Shoolar_project_notbothSelectTransaction", param);
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
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Shoolar_project_notboth>.NameValue> GetValue(Shoolar_project_notboth entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "PROJECT_SEQ_NO", Value = entity.PROJECT_SEQ_NO };
            yield return new NameValue() { Name = "PROJECT_NAME", Value = entity.PROJECT_NAME };
            yield return new NameValue() { Name = "PROJECT_CLASS", Value = entity.PROJECT_CLASS };
            yield return new NameValue() { Name = "PROJECT_CLASS_NAME", Value = cod.GetDDLTextByValue("ddl_jz_project_class", entity.PROJECT_CLASS) };
            yield return new NameValue() { Name = "PROJECT_TYPE", Value = entity.PROJECT_TYPE };
            yield return new NameValue() { Name = "PROJECT_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_jz_project_type", entity.PROJECT_TYPE) };
            yield return new NameValue() { Name = "PROJECT_YEAR", Value = entity.PROJECT_YEAR };
            yield return new NameValue() { Name = "PROJECT_YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.PROJECT_YEAR) };
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
            Shoolar_project_notboth head = new Shoolar_project_notboth();
            head.OID = strOID;
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<Shoolar_project_notboth>("Shoolar_project_notbothDeleteTransaction");
            transaction.EntityList.Add(head);
            if (!transaction.Commit())
                return "删除失败！";

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
            string oid = Post("hidOid_Notboth");
            bool res = false;
            Shoolar_project_notboth notboth = new Shoolar_project_notboth();
            if (string.IsNullOrEmpty(oid))
            {
                oid = notboth.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(notboth);
                notboth.SEQ_NO = Post("hidSeqNo_Notboth");
                notboth.PROJECT_YEAR = Post("PROJECT_YEAR_NOTBOTH");
                notboth.PROJECT_CLASS = Post("PROJECT_CLASS_NOTBOTH");
                notboth.PROJECT_TYPE = Post("PROJECT_TYPE_NOTBOTH");
                notboth.PROJECT_SEQ_NO = Post("PROJECT_SEQ_NO");
                notboth.PROJECT_NAME = Post("hidProName_Notboth");
                var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_project_notboth>("Shoolar_project_notbothInsertTransaction");
                inserttrcn.EntityList.Add(notboth);
                res = inserttrcn.Commit();
            }
            else
            {
                notboth.OID = oid;
                ds.RetrieveObject(notboth);
                notboth.PROJECT_YEAR = Post("PROJECT_YEAR_NOTBOTH");
                notboth.PROJECT_CLASS = Post("PROJECT_CLASS_NOTBOTH");
                notboth.PROJECT_TYPE = Post("PROJECT_TYPE_NOTBOTH");
                notboth.PROJECT_SEQ_NO = Post("PROJECT_SEQ_NO");
                notboth.PROJECT_NAME = Post("hidProName_Notboth");
                var updatetrcn = ImplementFactory.GetUpdateTransaction<Shoolar_project_notboth>("Shoolar_project_notbothUpdateTransaction", user.User_Name);
                res = updatetrcn.Commit(notboth);
            }
            if (res)
                return oid;
            else
                return string.Empty;
        }

        #endregion 保存数据
    }
}