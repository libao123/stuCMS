using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.RiceCard
{
    public partial class List : ListBaseLoad<Basic_stu_ricecard>
    {
        #region 初始化

        private comdata cod = new comdata();
        public bool IsShowBtn = false;//ZZ 20171026 新增：是否显示按钮：校级角色显示

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

        protected override SelectTransaction<Basic_stu_ricecard> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Basic_stu_ricecard>("Basic_stu_ricecardSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("STU_NUMBER")))
                where += string.Format(" AND STU_NUMBER LIKE '%{0}%' ", Post("STU_NUMBER"));
            if (!string.IsNullOrEmpty(Post("STU_NAME")))
                where += string.Format(" AND STU_NAME LIKE '%{0}%' ", Post("STU_NAME"));
            if (!string.IsNullOrEmpty(Post("XY")))
                where += string.Format(" AND XY = '{0}' ", Post("XY"));
            if (!string.IsNullOrEmpty(Post("ZY")))
                where += string.Format(" AND ZY = '{0}' ", Post("ZY"));
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("CLASS_CODE")))
                where += string.Format(" AND CLASS_CODE = '{0}' ", Post("CLASS_CODE"));
            if (!string.IsNullOrEmpty(Post("RICE_CARD")))
                where += string.Format(" AND RICE_CARD LIKE '%{0}%' ", Post("RICE_CARD"));
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

                        case "getstuinfo"://通过学号获得学生基础信息
                            Response.Write(GetStuInfo());
                            Response.End();
                            break;
                    }
                }
                if (user.User_Role.Equals("X") || user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))
                    IsShowBtn = true;
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Basic_stu_ricecard entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "STU_NUMBER", Value = entity.STU_NUMBER };
            yield return new NameValue() { Name = "STU_NAME", Value = entity.STU_NAME };
            yield return new NameValue() { Name = "XY", Value = entity.XY };
            yield return new NameValue() { Name = "XY_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.XY) };
            yield return new NameValue() { Name = "ZY", Value = entity.ZY };
            yield return new NameValue() { Name = "ZY_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.ZY) };
            yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
            yield return new NameValue() { Name = "GRADE_NAME", Value = cod.GetDDLTextByValue("ddl_grade", entity.GRADE) };
            yield return new NameValue() { Name = "CLASS_CODE", Value = entity.CLASS_CODE };
            yield return new NameValue() { Name = "CLASS_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS_CODE) };
            yield return new NameValue() { Name = "RICE_CARD", Value = entity.RICE_CARD };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
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
            if (string.IsNullOrEmpty(Get("id"))) return "主键为空,不允许删除操作";

            var model = new Basic_stu_ricecard();
            model.OID = Get("id");
            ds.RetrieveObject(model);

            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Basic_stu_ricecard>("Basic_stu_ricecardDeleteTransaction");
            transaction.EntityList.Add(model);
            bDel = transaction.Commit();
            if (!bDel) return "删除失败";

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
                Basic_stu_ricecard head = new Basic_stu_ricecard();
                if (string.IsNullOrEmpty(Post("OID")))
                    head.OID = Guid.NewGuid().ToString();
                else
                    head.OID = Post("OID");
                ds.RetrieveObject(head);
                head.STU_NUMBER = Post("STU_NUMBER");
                head.STU_NAME = Post("STU_NAME");
                head.XY = Post("XY");
                head.ZY = Post("ZY");
                head.GRADE = Post("GRADE");
                head.CLASS_CODE = Post("CLASS_CODE");
                head.RICE_CARD = Post("RICE_CARD");
                head.OP_CODE = user.User_Id;
                head.OP_NAME = user.User_Name;
                head.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                ds.UpdateObject(head);
                if (string.IsNullOrEmpty(Post("OID")))
                {
                    LogDBHandleClass.getInstance().LogOperation(head.OID, "学生饭卡基础信息管理", CValue.LOG_ACTION_TYPE_3, CValue.LOG_RECORD_TYPE_1, string.Format("新增学生饭卡信息：学号{0}，姓名{1}，饭卡卡号{2}", head.STU_NUMBER, head.STU_NAME, head.RICE_CARD), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                else
                {
                    LogDBHandleClass.getInstance().LogOperation(head.OID, "学生饭卡基础信息管理", CValue.LOG_ACTION_TYPE_4, CValue.LOG_RECORD_TYPE_1, string.Format("修改学生饭卡信息：学号{0}，姓名{1}，饭卡卡号{2}", head.STU_NUMBER, head.STU_NAME, head.RICE_CARD), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                return head.OID;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保存饭卡信息出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 通过学号获得学生基础信息

        /// <summary>
        /// 通过学号获得学生基础信息
        /// </summary>
        /// <returns></returns>
        private string GetStuInfo()
        {
            DataTable dt = StuHandleClass.getInstance().GetStuInfo_Dt(Get("stuno"));
            if (dt == null)
                return string.Empty;

            return Json.DatatableToJson(dt);
        }

        #endregion 通过学号获得学生基础信息
    }
}