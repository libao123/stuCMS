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

namespace PorteffAnaly.Web.AdminLTE_Mod.Common.ComPage
{
    public partial class SelectBasicStu : ListBaseLoad<Basic_stu_info>
    {
        #region 初始化

        private comdata cod = new comdata();

        protected override string input_code_column
        {
            get { return "NUMBER"; }
        }

        protected override string class_code_column
        {
            get
            {
                return "CLASS";
            }
        }

        protected override string xy_code_column
        {
            get { return "COLLEGE"; }
        }

        protected override bool is_do_filter
        {
            get
            {
                if (!string.IsNullOrEmpty(Request.QueryString["filter"]))
                {
                    if (Request.QueryString["filter"].ToString().Equals("classgroup"))
                        return false;//编班申请
                    else if (Request.QueryString["filter"].ToString().Equals("scoreinput"))
                        return true;//成绩录入
                    else
                        return true;
                }
                return true;
            }
        }

        protected override SelectTransaction<Basic_stu_info> GetSelectTransaction()
        {
            if (!string.IsNullOrEmpty(Request.QueryString["filter"]))
            {
                switch (Request.QueryString["filter"].ToString())
                {
                    case "classgroup"://编班申请
                        param.Add(string.Format("STUTYPE IN ('Y','P') "), "");//过滤只显示研究生、博士
                        break;
                    default:
                        break;
                }
            }
            return ImplementFactory.GetSelectTransaction<Basic_stu_info>("Basic_stu_infoSelectTransaction", param);
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
            if (!string.IsNullOrEmpty(Post("NUMBER")))
                where += string.Format(" AND NUMBER LIKE '%{0}%' ", Post("NUMBER"));
            if (!string.IsNullOrEmpty(Post("NAME")))
                where += string.Format(" AND NAME LIKE '%{0}%' ", Post("NAME"));
            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Basic_stu_info>.NameValue> GetValue(Basic_stu_info entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "NUMBER", Value = entity.NUMBER };
            yield return new NameValue() { Name = "NAME", Value = entity.NAME };
            yield return new NameValue() { Name = "CLASS", Value = entity.CLASS };
            yield return new NameValue() { Name = "CLASS_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS) };
            yield return new NameValue() { Name = "SEX", Value = entity.SEX };
            yield return new NameValue() { Name = "GARDE", Value = entity.GARDE };
            yield return new NameValue() { Name = "EDULENTH", Value = entity.EDULENTH };
            yield return new NameValue() { Name = "IDCARDNO", Value = entity.IDCARDNO };
            yield return new NameValue() { Name = "COLLEGE", Value = entity.COLLEGE.ToString() };
            yield return new NameValue() { Name = "COLLEGE_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.COLLEGE) };
            yield return new NameValue() { Name = "MAJOR", Value = entity.MAJOR.ToString() };
            yield return new NameValue() { Name = "MAJOR_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.MAJOR) };
            yield return new NameValue() { Name = "NATION", Value = entity.NATION.ToString() };
            yield return new NameValue() { Name = "POLISTATUS", Value = entity.POLISTATUS.ToString() };
        }

        #endregion 输出列表信息
    }
}