using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.MakeUp.ProjectManage
{
    public partial class List : ListBaseLoad<Makeup_project_head>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        public override string Doc_type { get { return CValue.DOC_TYPE_MU01; } }

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

        protected override SelectTransaction<Makeup_project_head> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Makeup_project_head>("Makeup_project_headSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("MAKEUP_TYPE")))
                where += string.Format(" AND MAKEUP_TYPE = '{0}' ", Post("MAKEUP_TYPE"));
            if (!string.IsNullOrEmpty(Post("MAKEUP_YEAR")))
                where += string.Format(" AND MAKEUP_YEAR = '{0}' ", Post("MAKEUP_YEAR"));
            if (!string.IsNullOrEmpty(Post("MAKEUP_NAME")))
                where += string.Format(" AND MAKEUP_NAME LIKE '%{0}%' ", Post("MAKEUP_NAME"));
            return where;
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

                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Makeup_project_head entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "MAKEUP_NAME", Value = entity.MAKEUP_NAME };
            yield return new NameValue() { Name = "MAKEUP_INFO", Value = entity.MAKEUP_INFO };
            yield return new NameValue() { Name = "MAKEUP_TYPE", Value = entity.MAKEUP_TYPE };
            yield return new NameValue() { Name = "MAKEUP_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_makyup_project_type", entity.MAKEUP_TYPE) };
            yield return new NameValue() { Name = "MAKEUP_YEAR", Value = entity.MAKEUP_YEAR };
            yield return new NameValue() { Name = "MAKEUP_YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.MAKEUP_YEAR) };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除主表数据并且把子表数据也删除
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            var code = Get("id");
            if (string.IsNullOrEmpty(code)) return "主键为空,不允许删除操作";

            var model = new Makeup_project_head();
            model.OID = code;
            ds.RetrieveObject(model);

            var transaction = ImplementFactory.GetDeleteTransaction<Makeup_project_head>("Makeup_project_headDeleteTransaction");
            transaction.EntityList.Add(model);
            if (!transaction.Commit())
                return "删除失败";
            return "";
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
                Makeup_project_head head = new Makeup_project_head();
                if (string.IsNullOrEmpty(Post("OID")))
                {
                    head.OID = Guid.NewGuid().ToString();
                    head.SEQ_NO = GetSeq_no();
                    ds.RetrieveObject(head);
                    head.MAKEUP_NAME = Post("MAKEUP_NAME").Trim();
                    head.MAKEUP_INFO = Post("MAKEUP_INFO");
                    head.MAKEUP_YEAR = Post("MAKEUP_YEAR");
                    head.MAKEUP_TYPE = Post("MAKEUP_TYPE");
                    head.OP_CODE = user.User_Id;
                    head.OP_NAME = user.User_Name;
                    head.OP_TIME = GetDateLongFormater();
                    ds.UpdateObject(head);
                }
                else
                {
                    head.OID = Post("OID");
                    ds.RetrieveObject(head);
                    head.MAKEUP_NAME = Post("MAKEUP_NAME").Trim();
                    head.MAKEUP_INFO = Post("MAKEUP_INFO");
                    head.MAKEUP_YEAR = Post("MAKEUP_YEAR");
                    head.MAKEUP_TYPE = Post("MAKEUP_TYPE");
                    head.OP_CODE = user.User_Id;
                    head.OP_NAME = user.User_Name;
                    head.OP_TIME = GetDateLongFormater();
                    ds.UpdateObject(head);
                    LoanHandleClass.getInstance().UpdateRelationFunction(head.SEQ_NO);
                }
                return head.OID;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "学费补偿贷款代偿项目保存，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据
    }
}