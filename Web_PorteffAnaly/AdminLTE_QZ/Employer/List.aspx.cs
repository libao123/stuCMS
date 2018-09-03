using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using AdminLTE_Mod.Common;
using HQ.WebForm;
using HQ.Utility;
using HQ.Model;
using HQ.InterfaceService;
using HQ.Architecture.Strategy;
using HQ.Architecture.Factory;

namespace PorteffAnaly.Web.AdminLTE_QZ.Employer
{
    public partial class List : ListBaseLoad<Qz_employer_manage>
    {
        #region 初始化

        public Qz_employer_manage head = new Qz_employer_manage();
        public string m_strIsShowEditBtn = "false";//是否显示增删改提交按钮：显示true 不显示false
        public ComHandleClass comHandle = new ComHandleClass();
        private comdata cod = new comdata();
        private ComTranClass comTran = new ComTranClass();

        #endregion 初始化

        #region 辅助页面加载

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

        protected override SelectTransaction<Qz_employer_manage> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Qz_employer_manage>("Qz_employer_manageSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("EMPLOYER")))
                where += string.Format(" AND EMPLOYER LIKE '%{0}%' ", Post("EMPLOYER"));
            if (!string.IsNullOrEmpty(Post("EMPLOYER_TYPE")))
                where += string.Format(" AND EMPLOYER_TYPE = '{0}' ", Post("EMPLOYER_TYPE"));
            
            return where;
        }

        #endregion 辅助页面加载

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
                        case "getdata":
                            Response.Write(GetData());
                            Response.End();
                            break;
                        case "chksave":
                            Response.Write(CheckSave());
                            Response.End();
                            break;
                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;
                        case "chkdel":
                            Response.Write(CheckDelete());
                            Response.End();
                            break;
                        case "delete":
                            Response.Write(DeleteData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Qz_employer_manage entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            yield return new NameValue() { Name = "EMPLOYER", Value = entity.EMPLOYER };
            yield return new NameValue() { Name = "IS_USE", Value = entity.IS_USE };
            yield return new NameValue() { Name = "MANAGER_NAME", Value = entity.MANAGER_NAME };
            yield return new NameValue() { Name = "TELEPHONE", Value = entity.TELEPHONE };
            yield return new NameValue() { Name = "ADDRESS", Value = entity.ADDRESS };
            yield return new NameValue() { Name = "EMPLOYER_TYPE", Value = cod.GetDDLTextByValue("ddl_employer_type", entity.EMPLOYER_TYPE) };
            yield return new NameValue() { Name = "IS_USE_NAME", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.IS_USE) };
        }

        #endregion 输出列表信息

        #region 获取编辑页面Json

        private string GetData()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "{}";

            DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM QZ_EMPLOYER_MANAGE WHERE OID = '{0}' ", Get("id")));
            if (dt == null || dt.Rows.Count == 0)
                return "{}";

            return Json.DatatableToJson(dt);
        }

        #endregion 

        #region 判断是否允许保存

        private string CheckSave()
        {
            string oid = Get("id");
            string strEmployer = Server.UrlDecode(Get("employer"));
            string strType = Server.UrlDecode(Get("type"));
            string strIsModi = string.Empty;
            if (oid.Length > 0)
            {
                strIsModi = string.Format(" AND OID NOT IN ('{0}') ", oid);
            }
            string strSql = string.Format("SELECT COUNT(1) FROM QZ_EMPLOYER_MANAGE WHERE EMPLOYER = '{0}' AND EMPLOYER_TYPE = '{1}'{2}", strEmployer, strType, strIsModi);
            object o = ds.ExecuteTxtScalar(strSql);
            if (o != null && comTran.ToInt(o) > 0)
                return "岗位已存在";

            return string.Empty;
        }

        #endregion 判断是否允许保存

        #region 获取页面数据

        private void GetPageValue(Qz_employer_manage model)
        {
            model.EMPLOYER = Post("EMPLOYER");
            model.EMPLOYER_TYPE = Post("EMPLOYER_TYPE");
            model.MANAGER_NAME = Post("MANAGER_NAME");
            model.TELEPHONE = Post("TELEPHONE");
            model.ADDRESS = Post("ADDRESS");
            model.IS_USE = Post("IS_USE");
            model.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            model.OP_CODE = user.User_Id;
            model.OP_NAME = user.User_Name;
        }

        #endregion 获取页面数据

        #region 保存

        private string SaveData()
        {
            try
            {
                head.OID = Post("OID");
                if (string.IsNullOrEmpty(head.OID))
                {
                    head.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(head);
                    head.SEQ_NO = GetSeq_no();
                }
                else
                {
                    ds.RetrieveObject(head);
                }
                GetPageValue(head);
                ds.UpdateObject(head);
                return head.OID;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        #endregion 保存

        #region 删除操作

        #region 判断是否允许删除

        private string CheckDelete()
        {
            string result = string.Empty;
            var oid = Get("id");
            if (string.IsNullOrEmpty(oid)) return "主键为空,不允许删除操作";

            head.OID = oid;
            ds.RetrieveObject(head);


            return result;
        }

        #endregion

        #region 删除数据

        private string DeleteData()
        {
            var oid = Get("id");
            if (string.IsNullOrEmpty(oid)) return "主键为空,不允许删除操作";

            head.OID = oid;
            ds.RetrieveObject(head);

            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Qz_employer_manage>("Qz_employer_manageDeleteTransaction");
            transaction.EntityList.Add(head);
            bDel = transaction.Commit();

            if (!bDel)
                return "删除失败！";
            else
                return string.Empty;
        }

        #endregion 删除数据

        #endregion 删除操作
    }
}