using System;
using System.Collections.Generic;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Bank
{
    public partial class List : ListBaseLoad<Basic_stu_bank_info>
    {
        #region 初始化

        private comdata cod = new comdata();
        public bool IsShowBtn = false;//ZZ 20171026 新增：是否显示按钮：校级角色显示

        protected override string input_code_column
        {
            get { return "NUMBER"; }
        }

        protected override string class_code_column
        {
            get { return "CLASS"; }
        }

        protected override string xy_code_column
        {
            get { return "COLLEGE"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Basic_stu_bank_info> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Basic_stu_bank_info>("Basic_stu_bank_infoSelectTransaction", param);
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
            if (!string.IsNullOrEmpty(Post("COLLEGE")))
                where += string.Format(" AND COLLEGE = '{0}' ", Post("COLLEGE"));
            if (!string.IsNullOrEmpty(Post("CLASS")))
                where += string.Format(" AND CLASS = '{0}' ", Post("CLASS"));
            if (!string.IsNullOrEmpty(Post("BANKNAME")))
                where += string.Format(" AND BANKNAME LIKE '%{0}%' ", Post("BANKNAME"));
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
                if (user.User_Role.Equals("X") || user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))
                    IsShowBtn = true;
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Basic_stu_bank_info entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "NUMBER", Value = entity.NUMBER };
            yield return new NameValue() { Name = "NAME", Value = entity.NAME };
            yield return new NameValue() { Name = "COLLEGE", Value = entity.COLLEGE };
            yield return new NameValue() { Name = "COLLEGE_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.COLLEGE) };
            yield return new NameValue() { Name = "EDULENTH", Value = entity.EDULENTH };
            yield return new NameValue() { Name = "EDULENTH_NAME", Value = cod.GetDDLTextByValue("ddl_grade", entity.EDULENTH) };
            yield return new NameValue() { Name = "CLASS", Value = entity.CLASS };
            yield return new NameValue() { Name = "CLASS_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS) };
            yield return new NameValue() { Name = "STUTYPE", Value = entity.STUTYPE };
            yield return new NameValue() { Name = "STUTYPE_NAME", Value = cod.GetDDLTextByValue("ddl_ua_stu_type", entity.STUTYPE) };
            yield return new NameValue() { Name = "BANKTYPE", Value = entity.BANKTYPE };
            yield return new NameValue() { Name = "BANKNAME", Value = entity.BANKNAME };
            yield return new NameValue() { Name = "BANKCODE", Value = entity.BANKCODE };
            yield return new NameValue() { Name = "BANKUSERNAME", Value = entity.BANKUSERNAME };
            yield return new NameValue() { Name = "OPER", Value = entity.OPER };
            yield return new NameValue() { Name = "OPTIME", Value = entity.OPTIME };
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

            var model = new Basic_stu_bank_info();
            model.OID = Get("id");
            ds.RetrieveObject(model);

            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Basic_stu_bank_info>("Basic_stu_bank_infoDeleteTransaction");
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
                Basic_stu_bank_info head = new Basic_stu_bank_info();
                if (string.IsNullOrEmpty(Post("OID")))
                    head.OID = Guid.NewGuid().ToString();
                else
                    head.OID = Post("OID");
                ds.RetrieveObject(head);
                head.NUMBER = Post("NUMBER");
                head.NAME = Post("NAME");
                head.COLLEGE = Post("COLLEGE");
                head.EDULENTH = Post("EDULENTH");
                head.CLASS = Post("CLASS");
                head.STUTYPE = Post("STUTYPE");
                head.BANKTYPE = Post("BANKTYPE");
                head.BANKNAME = Post("BANKNAME");
                head.BANKCODE = Post("BANKCODE");
                head.BANKUSERNAME = Post("BANKUSERNAME");
                head.OPER = user.User_Name;
                head.OPTIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                ds.UpdateObject(head);
                if (string.IsNullOrEmpty(Post("OID")))
                {
                    LogDBHandleClass.getInstance().LogOperation(head.OID, "学生银行卡基础信息管理", CValue.LOG_ACTION_TYPE_3, CValue.LOG_RECORD_TYPE_1, string.Format("新增学生银行卡信息：学号{0}，姓名{1}，银行卡卡号{2}", head.NUMBER, head.NAME, head.BANKCODE), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                else
                {
                    LogDBHandleClass.getInstance().LogOperation(head.OID, "学生银行卡基础信息管理", CValue.LOG_ACTION_TYPE_4, CValue.LOG_RECORD_TYPE_1, string.Format("修改学生银行卡信息：学号{0}，姓名{1}，银行卡卡号{2}", head.NUMBER, head.NAME, head.BANKCODE), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                return head.OID;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保存银行卡信息出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据
    }
}