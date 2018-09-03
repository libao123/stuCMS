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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.MakeUp.ProjectApply
{
    public partial class List : ListBaseLoad<Makeup_project_apply>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public bool bIsShowBtn = false;
        public bool bIsShowBtn_Export = false;

        protected override string input_code_column
        {
            get { return "STU_NUMBER"; }
        }

        protected override string class_code_column
        {
            get { return "CLASS_CODE"; }
        }

        protected override string xy_code_column
        {
            get { return "XY"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Makeup_project_apply> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Makeup_project_apply>("Makeup_project_applySelectTransaction", param);
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

                        case "getstudata":
                            Response.Write(GetStudentData());
                            Response.End();
                            break;
                    }
                }
                //只有菜单来源于“学费补偿贷款代偿信息” 才有按钮权限
                if (!string.IsNullOrEmpty(Get("fun_type")))
                {
                    if (Get("fun_type").ToString().Equals("manage"))
                    {
                        bIsShowBtn = true;
                    }
                    if (Get("fun_type").ToString().Equals("export"))
                    {
                        bIsShowBtn_Export = true;
                    }
                }
            }
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
            if (!string.IsNullOrEmpty(Post("MAKEUP_SEQ_NO")))
                where += string.Format(" AND MAKEUP_SEQ_NO = '{0}' ", Post("MAKEUP_SEQ_NO"));
            if (!string.IsNullOrEmpty(Post("MAKEUP_QUALIF_TYPE")))
                where += string.Format(" AND MAKEUP_QUALIF_TYPE = '{0}' ", Post("MAKEUP_QUALIF_TYPE"));
            if (!string.IsNullOrEmpty(Post("XY")))
                where += string.Format(" AND XY = '{0}' ", Post("XY"));
            if (!string.IsNullOrEmpty(Post("ZY")))
                where += string.Format(" AND ZY = '{0}' ", Post("ZY"));
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("CLASS_CODE")))
                where += string.Format(" AND CLASS_CODE = '{0}' ", Post("CLASS_CODE"));
            if (!string.IsNullOrEmpty(Post("STU_NUMBER")))
                where += string.Format(" AND STU_NUMBER LIKE '%{0}%' ", Post("STU_NUMBER"));
            if (!string.IsNullOrEmpty(Post("STU_NAME")))
                where += string.Format(" AND STU_NAME LIKE '%{0}%' ", Post("STU_NAME"));
            if (!string.IsNullOrEmpty(Post("STU_TYPE")))
                where += string.Format(" AND STU_TYPE = '{0}' ", Post("STU_TYPE"));
            return where;
        }

        #endregion 页面加载

        #region 获得申报学生基本信息

        /// <summary>
        /// 获得申报学生基本信息
        /// </summary>
        /// <returns></returns>
        private string GetStudentData()
        {
            if (string.IsNullOrEmpty(Get("stu_num")))
                return "{}";
            return StuHandleClass.getInstance().GetStuInfoJson(Get("stu_num"));
        }

        #endregion 获得申报学生基本信息

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Makeup_project_apply>.NameValue> GetValue(Makeup_project_apply entity)
        {
            //单据数据
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "DOC_TYPE", Value = entity.DOC_TYPE };
            yield return new NameValue() { Name = "DECL_TIME", Value = entity.DECL_TIME };
            yield return new NameValue() { Name = "CHK_TIME", Value = entity.CHK_TIME };
            yield return new NameValue() { Name = "CHK_STATUS", Value = entity.CHK_STATUS };
            yield return new NameValue() { Name = "CHK_STATUS_NAME", Value = cod.GetDDLTextByValue("ddl_CHK_STATUS", entity.CHK_STATUS) };
            yield return new NameValue() { Name = "DECLARE_TYPE", Value = entity.DECLARE_TYPE };
            yield return new NameValue() { Name = "DECLARE_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_DECLARE_TYPE", entity.DECLARE_TYPE) };
            yield return new NameValue() { Name = "RET_CHANNEL", Value = entity.RET_CHANNEL };
            yield return new NameValue() { Name = "RET_CHANNEL_NAME", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.RET_CHANNEL) };
            yield return new NameValue() { Name = "POS_CODE", Value = entity.POS_CODE };
            yield return new NameValue() { Name = "AUDIT_POS_CODE", Value = entity.AUDIT_POS_CODE };
            yield return new NameValue() { Name = "STEP_NO", Value = entity.STEP_NO };
            yield return new NameValue() { Name = "STEP_NO_NAME", Value = cod.GetDDLTextByValue("ddl_STEP_NO", entity.STEP_NO) };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            //项目数据
            yield return new NameValue() { Name = "MAKEUP_SEQ_NO", Value = entity.MAKEUP_SEQ_NO };
            yield return new NameValue() { Name = "MAKEUP_TYPE", Value = entity.MAKEUP_TYPE };
            yield return new NameValue() { Name = "MAKEUP_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_makyup_project_type", entity.MAKEUP_TYPE) };
            yield return new NameValue() { Name = "MAKEUP_NAME", Value = entity.MAKEUP_NAME };
            yield return new NameValue() { Name = "MAKEUP_YEAR", Value = entity.MAKEUP_YEAR };
            yield return new NameValue() { Name = "MAKEUP_YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.MAKEUP_YEAR) };
            //申请人数据
            yield return new NameValue() { Name = "STU_NUMBER", Value = entity.STU_NUMBER };
            yield return new NameValue() { Name = "STU_NAME", Value = entity.STU_NAME };
            yield return new NameValue() { Name = "STU_TYPE", Value = entity.STU_TYPE };
            yield return new NameValue() { Name = "STU_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_ua_stu_type", entity.STU_TYPE) };
            yield return new NameValue() { Name = "XY", Value = entity.XY };
            yield return new NameValue() { Name = "XY_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.XY) };
            yield return new NameValue() { Name = "ZY", Value = entity.ZY };
            yield return new NameValue() { Name = "ZY_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.ZY) };
            yield return new NameValue() { Name = "CLASS_CODE", Value = entity.CLASS_CODE };
            yield return new NameValue() { Name = "CLASS_CODE_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS_CODE) };
            yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
            //申请人填报数据
            yield return new NameValue() { Name = "MAKEUP_MONEY", Value = entity.MAKEUP_MONEY.ToString() };
            yield return new NameValue() { Name = "MAKEUP_QUALIF_TYPE", Value = entity.MAKEUP_QUALIF_TYPE };
            yield return new NameValue() { Name = "MAKEUP_QUALIF_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_makyup_qualif_type", entity.MAKEUP_QUALIF_TYPE) };
            yield return new NameValue() { Name = "MAKEUP_SEND_DATE", Value = entity.MAKEUP_SEND_DATE };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                string[] strs = Post("SELECT_OID").Split(',');
                for (int i = 0; i < strs.Length; i++)
                {
                    if (strs[i].Length == 0)
                        continue;
                    var model = new Makeup_project_apply();
                    model.OID = strs[i].ToString();
                    ds.RetrieveObject(model);

                    bool bDel = false;
                    var transaction = ImplementFactory.GetDeleteTransaction<Makeup_project_apply>("Makeup_project_applyDeleteTransaction");
                    transaction.EntityList.Add(model);
                    bDel = transaction.Commit();

                    if (!bDel)
                        return "删除失败！";
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "删除学费补偿学费补偿申请数据，出错：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据
    }
}