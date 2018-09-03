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
using HQ.WebControl;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.UserManage
{
    public partial class List : ListBaseLoad<Ua_user>
    {
        #region 初始化

        private comdata cod = new comdata();

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

        protected override SelectTransaction<Ua_user> GetSelectTransaction()
        {
            Dictionary<string, string> param = new Dictionary<string, string>();
            return ImplementFactory.GetSelectTransaction<Ua_user>("Ua_userSelectTransaction", param);
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

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("USER_ID")))
                where += string.Format(" AND USER_ID LIKE '%{0}%' ", Post("USER_ID"));
            if (!string.IsNullOrEmpty(Post("USER_NAME")))
                where += string.Format(" AND USER_NAME LIKE '%{0}%' ", Post("USER_NAME"));
            if (!string.IsNullOrEmpty(Post("USER_TYPE")))
                where += string.Format(" AND USER_TYPE = '{0}' ", Post("USER_TYPE"));
            if (!string.IsNullOrEmpty(Post("STU_TYPE")))
                where += string.Format(" AND STU_TYPE = '{0}' ", Post("STU_TYPE"));
            if (!string.IsNullOrEmpty(Post("XY_CODE")))
                where += GetWhereXy(Post("XY_CODE"));
            return where;
        }

        /// <summary>
        /// 多学院查询
        /// </summary>
        /// <param name="strXy"></param>
        /// <returns></returns>
        private string GetWhereXy(string strXy)
        {
            StringBuilder strWhereXy = new StringBuilder();
            string[] arrXy = strXy.Split(new char[] { ',' });
            foreach (string str in arrXy)
            {
                if (string.IsNullOrEmpty(str))
                    continue;

                strWhereXy.AppendFormat("OR XY_CODE = '{0}' ", str);
            }
            string strResultWhere = string.Empty;
            string strWhere = string.Empty;
            if (strWhereXy.ToString().Length > 0)
                strResultWhere = strWhereXy.ToString();
            if (strResultWhere.Length > 0)//去掉第一个O
                strResultWhere = strResultWhere.TrimStart('O');
            if (strResultWhere.Length > 0)//去掉第二个R
                strResultWhere = strResultWhere.TrimStart('R');
            if (strResultWhere.Length > 0)
                strWhere = string.Format(" AND ({0})", strResultWhere);
            return strWhere;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Ua_user>.NameValue> GetValue(Ua_user entity)
        {
            yield return new NameValue() { Name = "USER_ID", Value = entity.USER_ID };
            yield return new NameValue() { Name = "USER_NAME", Value = entity.USER_NAME };
            yield return new NameValue() { Name = "USER_ROLE", Value = entity.USER_ROLE };
            yield return new NameValue() { Name = "USER_ROLE_NAME", Value = GetUserRole(entity.USER_ROLE) };
            yield return new NameValue() { Name = "XY_CODE", Value = entity.XY_CODE };
            yield return new NameValue() { Name = "XY_CODE_NAME", Value = GetUserXy(entity.XY_CODE) };
            yield return new NameValue() { Name = "STU_TYPE", Value = entity.STU_TYPE };
            yield return new NameValue() { Name = "STU_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_ua_stu_type", entity.STU_TYPE) };
            yield return new NameValue() { Name = "USER_TYPE", Value = entity.USER_TYPE };
            yield return new NameValue() { Name = "USER_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_user_type", entity.USER_TYPE) };
            yield return new NameValue() { Name = "IS_ASSISTANT", Value = entity.IS_ASSISTANT };
            yield return new NameValue() { Name = "IS_ASSISTANT_NAME", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.IS_ASSISTANT) };
            yield return new NameValue() { Name = "LOGIN_PW", Value = entity.LOGIN_PW };
            yield return new NameValue() { Name = "CREATE_CODE", Value = entity.CREATE_CODE };
            yield return new NameValue() { Name = "CREATE_NAME", Value = entity.CREATE_NAME };
            yield return new NameValue() { Name = "CREATE_TIME", Value = entity.CREATE_TIME };
        }

        private string GetUserRole(string strUserRole)
        {
            string strShow = "";
            string[] role = strUserRole.Split(new char[] { ',' });
            for (int i = 0; i < role.Length; i++)
            {
                if (role[i].ToString().Length == 0)
                    continue;

                strShow += cod.GetDDLTextByValue("ddl_ua_role", role[i].ToString()) + "，";
            }

            if (strShow.Length > 0)
                strShow = strShow.TrimEnd('，');
            return strShow;
        }

        private string GetUserXy(string strUserXy)
        {
            string strShow = "";
            string[] xy = strUserXy.Split(new char[] { ',' });
            for (int i = 0; i < xy.Length; i++)
            {
                if (xy[i].ToString().Length == 0)
                    continue;

                strShow += cod.GetDDLTextByValue("ddl_all_department", xy[i].ToString()) + "，";
            }

            if (strShow.Length > 0)
                strShow = strShow.TrimEnd('，');
            return strShow;
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
            Ua_user head = new Ua_user();
            head.USER_ID = Get("id");
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<Ua_user>("Ua_userDeleteTransaction");
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
                Ua_user head = new Ua_user();
                head.USER_ID = Post("USER_ID").Trim();
                ds.RetrieveObject(head);
                head.USER_NAME = Post("USER_NAME");
                head.USER_TYPE = Post("USER_TYPE");
                head.XY_CODE = Post("hidAllXy");
                head.STU_TYPE = Post("STU_TYPE");
                head.IS_ASSISTANT = Post("IS_ASSISTANT");
                head.LOGIN_PW = Post("LOGIN_PW");
                if (Post("hidUserRoles").ToString().Length > 0)
                    head.USER_ROLE = Post("hidUserRoles").TrimEnd(new char[] { ',' });
                else
                    head.USER_ROLE = Post("hidUserRoles");
                head.CREATE_TIME = GetDateLongFormater();
                head.CREATE_CODE = user.User_Id;
                head.CREATE_NAME = user.User_Name;
                ds.UpdateObject(head);
                return head.USER_ID;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "用户保存失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据
    }
}