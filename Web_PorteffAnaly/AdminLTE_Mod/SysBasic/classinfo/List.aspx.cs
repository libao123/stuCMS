using System;
using System.Collections.Generic;
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
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.SysBasic.classinfo
{
    public partial class List : ListBaseLoad<Basic_class_info>
    {
        #region 初始化

        private comdata cod = new comdata();

        protected override string input_code_column
        {
            get { return "OP_CODE"; }
        }

        protected override string class_code_column
        {
            get { return "CLASSCODE"; }
        }

        protected override string xy_code_column
        {
            get { return "XY"; }
        }

        protected override bool is_do_filter
        {
            get { return false; }
        }

        protected override SelectTransaction<Basic_class_info> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Basic_class_info>("Basic_class_infoSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("XY")))
                where += string.Format(" AND XY = '{0}' ", Post("XY"));
            if (!string.IsNullOrEmpty(Post("ZY")))
                where += string.Format(" AND ZY = '{0}' ", Post("ZY"));
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("STU_TYPE")))
                where += string.Format(" AND STU_TYPE = '{0}' ", Post("STU_TYPE"));
            if (!string.IsNullOrEmpty(Post("CLASSCODE")))
                where += string.Format(" AND CLASSCODE LIKE '%{0}%' ", Post("CLASSCODE"));
            if (!string.IsNullOrEmpty(Post("CLASSNAME")))
                where += string.Format(" AND CLASSNAME LIKE '%{0}%' ", Post("CLASSNAME"));
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

                        case "save"://保存操作
                            Response.Write(SaveData());
                            Response.End();
                            break;

                        case "check"://校验是否可以编班
                            Response.Write(CheckData());
                            Response.End();
                            break;

                        case "chai"://拆班操作
                            Response.Write(ChaiClass());
                            Response.End();
                            break;

                        case "chkxiaoban"://校验该班是否存在小班
                            Response.Write(CheckXiaoBan());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Basic_class_info entity)
        {
            yield return new NameValue() { Name = "CLASSCODE", Value = entity.CLASSCODE };
            yield return new NameValue() { Name = "CLASSNAME", Value = entity.CLASSNAME };
            yield return new NameValue() { Name = "XY", Value = entity.XY };
            yield return new NameValue() { Name = "XSH", Value = entity.XSH };
            yield return new NameValue() { Name = "ZY", Value = entity.ZY };
            yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
            yield return new NameValue() { Name = "XY_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.XY) };
            yield return new NameValue() { Name = "XSH_NAME", Value = cod.GetDDLTextByValue("ddl_xsh", entity.XSH) };
            yield return new NameValue() { Name = "ZY_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.ZY) };
            yield return new NameValue() { Name = "GRADE_NAME", Value = cod.GetDDLTextByValue("ddl_grade", entity.GRADE) };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            //ZZ 20171024：班级类型
            yield return new NameValue() { Name = "STU_TYPE", Value = entity.STU_TYPE };
            yield return new NameValue() { Name = "STU_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_basic_stu_type", entity.STU_TYPE) };
            //ZZ 20171031：父班级ID
            yield return new NameValue() { Name = "PARENT_CLASSCODE", Value = entity.PARENT_CLASSCODE };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "编码为空,不允许删除操作";
            Basic_class_info head = new Basic_class_info();
            head.CLASSCODE = Get("id");
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<Basic_class_info>("Basic_class_infoDeleteTransaction");
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
            try
            {
                //保存前，通过班级名称删除现有数据
                string strSqlDel = string.Format("DELETE FROM BASIC_CLASS_INFO WHERE CLASSNAME = '{0}' AND XY = '{1}' ", Post("CLASSNAME"), Post("XY"));
                ds.ExecuteTxtNonQuery(strSqlDel);
                string strClassCode = ComHandleClass.getInstance().GetClassCode(Post("STU_TYPE"), Post("XY"), Post("ZY"), Post("GRADE"));
                if (strClassCode.Length == 0)
                    return string.Empty;

                Basic_class_info head = new Basic_class_info();
                head.CLASSCODE = strClassCode;
                ds.RetrieveObject(head);
                head.CLASSNAME = Post("CLASSNAME").Trim();
                head.XY = Post("XY");
                head.ZY = Post("ZY");
                head.GRADE = Post("GRADE");
                head.STU_TYPE = Post("STU_TYPE");
                head.OP_CODE = user.User_Id;
                head.OP_NAME = user.User_Name;
                head.OP_TIME = GetDateLongFormater();
                ds.UpdateObject(head);
                return head.CLASSCODE;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "班级保存失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 校验该班级是否存在小班

        /// <summary>
        /// 校验该班级是否存在小班
        /// </summary>
        /// <returns></returns>
        private string CheckXiaoBan()
        {
            if (string.IsNullOrEmpty(Get("classcode")))
                return "班级代码不能为空！";
            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("PARENT_CLASSCODE", Get("classcode"));
            var selecttrcn = ImplementFactory.GetSelectTransaction<Basic_class_info>("Basic_class_infoSelectTransaction", param);
            var selectList = selecttrcn.SelectAll();
            if (selectList == null)
                return "读取该班级下是否存在小班出错！";
            if (selectList.Count > 0)
                return "该班级下存在小班，请删除完小班之后再操作！";
            return string.Empty;
        }

        #endregion 校验该班级是否存在小班

        #region 校验是否可以进行拆班

        /// <summary>
        /// 校验是否可以进行拆班
        /// </summary>
        /// <returns></returns>
        private string CheckData()
        {
            if (string.IsNullOrEmpty(Get("classcode")))
                return "班级代码不能为空！";
            Basic_class_info classInfo = new Basic_class_info();
            classInfo.CLASSCODE = Get("classcode");
            ds.RetrieveObject(classInfo);
            if (classInfo == null)
                return "班级代码获取班级信息为空！";
            if (classInfo.PARENT_CLASSCODE.Length > 0)
                return "该班级已经是小班，无法再拆班！";
            return string.Empty;
        }

        #endregion 校验是否可以进行拆班

        #region 拆班操作

        /// <summary>
        /// 拆班操作
        /// </summary>
        /// <returns></returns>
        private string ChaiClass()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("classcode")) || string.IsNullOrEmpty(Get("chai_num")))
                    return "班级代码或者拆班个人不能为空！";
                int nChai = cod.ChangeInt(Get("chai_num"));
                Basic_class_info classInfo = new Basic_class_info();
                classInfo.CLASSCODE = Get("classcode");
                ds.RetrieveObject(classInfo);
                if (classInfo == null)
                    return "班级代码获取班级信息为空！";
                for (int i = 0; i < nChai; i++)
                {
                    Basic_class_info classInfo_chai = new Basic_class_info();
                    classInfo_chai.CLASSCODE = ComHandleClass.getInstance().GetClassCode(classInfo.STU_TYPE, classInfo.XY, classInfo.ZY, classInfo.GRADE);
                    ds.RetrieveObject(classInfo_chai);
                    classInfo_chai.PARENT_CLASSCODE = Get("classcode");
                    classInfo_chai.CLASSNAME = GetClassName_Chai(classInfo.CLASSCODE, classInfo.CLASSNAME);
                    classInfo_chai.XY = classInfo.XY;
                    classInfo_chai.ZY = classInfo.ZY;
                    classInfo_chai.GRADE = classInfo.GRADE;
                    classInfo_chai.STU_TYPE = classInfo.STU_TYPE;
                    classInfo_chai.OP_CODE = user.User_Id;
                    classInfo_chai.OP_NAME = user.User_Name;
                    classInfo_chai.OP_TIME = GetDateLongFormater();
                    ds.UpdateObject(classInfo_chai);
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "拆班失败：" + ex.ToString());
                return "拆班失败！";
            }
        }

        private string GetClassName_Chai(string strParentClassCode, string strParentClassName)
        {
            StringBuilder strSQL = new StringBuilder();
            strSQL.Append("SELECT COUNT(1) AS CLASS_ORDER FROM BASIC_CLASS_INFO ");
            strSQL.AppendFormat("WHERE 1=1 ");
            strSQL.AppendFormat("AND PARENT_CLASSCODE = '{0}' ", strParentClassCode);
            int nCLASS_ORDER = cod.ChangeInt(ds.ExecuteTxtScalar(strSQL.ToString()).ToString());
            return strParentClassName + "(" + (nCLASS_ORDER + 1).ToString() + "班)";
        }

        #endregion 拆班操作
    }
}