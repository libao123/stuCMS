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
using HQ.WebControl;
using HQ.WebForm;
using System.Data;
using System.Text;

namespace PorteffAnaly.Web.AdminLTE_Mod.SysBasic.department
{
    public partial class List : ListBaseLoad<T_xt_department>
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

        protected override SelectTransaction<T_xt_department> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<T_xt_department>("T_xt_departmentSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("DW")))
                where += string.Format(" AND DW LIKE '%{0}%' ", Post("DW"));
            if (!string.IsNullOrEmpty(Post("MC")))
                where += string.Format(" AND MC LIKE '%{0}%' ", Post("MC"));
            if (!string.IsNullOrEmpty(Post("LX")))
                where += string.Format(" AND LX = '{0}' ", Post("LX"));
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

                        case "chk"://校验操作
                            Response.Write(CheckData());
                            Response.End();
                            break;

                        case "getmgr"://编辑时首次加载学院HTML
                            Response.Write(GetManager());
                            Response.End();
                            break;

                        case "addmgr"://选择时加载学院HTML
                            Response.Write(AddManager());
                            Response.End();
                            break;

                        case "delmgr"://删除选中学院HTML
                            Response.Write(DeleteManager());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(T_xt_department entity)
        {
            yield return new NameValue() { Name = "DW", Value = entity.DW };
            yield return new NameValue() { Name = "MC", Value = entity.MC };
            yield return new NameValue() { Name = "YWMC", Value = entity.YWMC };
            yield return new NameValue() { Name = "LX", Value = entity.LX };
            yield return new NameValue() { Name = "ZT", Value = entity.ZT };
            yield return new NameValue() { Name = "LX_NAME", Value = cod.GetDDLTextByValue("ddl_department_type", entity.LX) };
            yield return new NameValue() { Name = "ZT_NAME", Value = cod.GetDDLTextByValue("ddl_use_flag", entity.ZT) };
            yield return new NameValue() { Name = "SEQUENCE", Value = entity.SEQUENCE.ToString() };
            yield return new NameValue() { Name = "ADDRESS", Value = entity.ADDRESS };
            yield return new NameValue() { Name = "MANAGER", Value = entity.MANAGER };
            yield return new NameValue() { Name = "MANAGER_NAME", Value = GetManagerName(entity.MANAGER) };
        }

        private string GetManagerName(string strCode)
        {
            string strShow = "";
            string[] arr = strCode.Split(new char[] { ',' });
            for (int i = 0; i < arr.Length; i++)
            {
                if (arr[i].ToString().Length == 0)
                    continue;

                strShow += cod.GetDDLTextByValue("ddl_ua_user", arr[i].ToString()) + "，";
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
            T_xt_department head = new T_xt_department();
            head.DW = Get("id");
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<T_xt_department>("T_xt_departmentDeleteTransaction");
            transaction.EntityList.Add(head);
            if (!transaction.Commit())
                return "删除失败！";
            //记录操作日志
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
                T_xt_department head = new T_xt_department();
                head.DW = Post("DW").Trim();
                ds.RetrieveObject(head);
                head.MC = Post("MC").Trim();
                head.LX = Post("LX");
                head.ZT = Post("ZT");
                head.YWMC = Post("YWMC");
                head.BZ = Post("BZ");
                head.SEQUENCE = cod.ChangeInt(Post("SEQUENCE"));
                head.MANAGER = Post("hidAllMGR").TrimEnd(',');//管理员
                head.ADDRESS = Post("ADDRESS");//联系地址

                ds.UpdateObject(head);
                //记录操作日志

                return head.DW;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保存学院信息出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 校验学院代码的唯一性

        /// <summary>
        /// 校验学院代码的唯一性
        /// </summary>
        /// <returns></returns>
        private string CheckData()
        {
            if (string.IsNullOrEmpty(Get("dw")))
                return "学院代码不能为空！";

            string strSQL = string.Format("SELECT COUNT(*) AS NUM FROM t_xt_department WHERE dw = '{0}' ", Get("dw"));
            int nCount = cod.ChangeInt(ds.ExecuteTxtScalar(strSQL).ToString());
            if (nCount > 0)
                return "该学院代码已存在，请确认！";
            return string.Empty;
        }

        #endregion 校验学院代码的唯一性

        #region 加载单位管理员HTML

        /// <summary>
        /// 加载单位管理员HTML
        /// </summary>
        /// <returns></returns>
        private string GetManager()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("dw")))
                    return string.Empty;
                string strSQL = string.Format("SELECT MANAGER FROM T_XT_DEPARTMENT WHERE DW = '{0}' ", Get("dw"));
                string strCode = ds.ExecuteTxtScalar(strSQL).ToString();
                if (string.IsNullOrEmpty(strCode))
                    return string.Empty;
                string[] arrCode = strCode.Split(new char[] { ',' });
                StringBuilder sbHtml = new StringBuilder();
                foreach (string code in arrCode)
                {
                    if (string.IsNullOrEmpty(code))
                        continue;
                    sbHtml.Append("<input name=\"MANAGER\" id=\"" + code + "\"  type=\"checkbox\" value=\"" + code + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + code + "\">" + cod.GetDDLTextByValue("ddl_ua_user", code) + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, ex.ToString());
                return string.Empty;
            }
        }

        #endregion 加载单位管理员HTML

        #region 选择时加载学院HTML

        /// <summary>
        /// 选择时加载学院HTML
        /// </summary>
        /// <returns></returns>
        private string AddManager()
        {
            try
            {
                #region 排除重复学院

                if (string.IsNullOrEmpty(Post("hidAllMGR")))
                    return string.Empty;

                string strSel = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(Post("hidAllMGR"));

                #endregion 排除重复学院

                #region 学院HTML

                string strSQL = string.Format("SELECT USER_ID, USER_NAME FROM UA_USER WHERE USER_ID IN ({0})", strSel);
                DataTable dt = ds.ExecuteTxtDataTable(strSQL);
                if (dt == null)
                    return string.Empty;
                StringBuilder sbHtml = new StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;
                    sbHtml.Append("<input name=\"MANAGER\" id=\"" + row["USER_ID"].ToString() + "\"  type=\"checkbox\" value=\"" + row["USER_ID"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["USER_ID"].ToString() + "\">" + row["USER_NAME"].ToString() + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();

                #endregion 学院HTML
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "单位信息管理，管理员加载失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 选择时加载学院HTML

        #region 删除选中学院HTML

        /// <summary>
        /// 删除选中学院HTML
        /// </summary>
        /// <returns></returns>
        private string DeleteManager()
        {
            try
            {
                #region 排除重复学院

                if (string.IsNullOrEmpty(Post("hidAllMGR")))
                    return string.Empty;
                if (string.IsNullOrEmpty(Post("hidSelDelMGR")))
                    return string.Empty;

                string[] arrAll = Post("hidAllMGR").Split(new char[] { ',' });
                string steSelDel = Post("hidSelDelMGR").ToString();

                string strWhereUser = string.Empty;
                foreach (string user in arrAll)
                {
                    if (string.IsNullOrEmpty(user))
                        continue;
                    if (steSelDel.Contains(user + ","))
                        continue;
                    strWhereUser += user + ",";
                }
                string strSel = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(strWhereUser);

                #endregion 排除重复学院

                #region 学院HTML

                string strSQL = string.Format("SELECT USER_ID, USER_NAME FROM UA_USER WHERE USER_ID IN ({0})", strSel);
                DataTable dt = ds.ExecuteTxtDataTable(strSQL);
                if (dt == null)
                    return string.Empty;
                StringBuilder sbHtml = new StringBuilder();
                foreach (DataRow row in dt.Rows)
                {
                    if (row == null)
                        continue;

                    sbHtml.Append("<input name=\"MANAGER\" id=\"" + row["USER_ID"].ToString() + "\"  type=\"checkbox\" value=\"" + row["USER_ID"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["USER_ID"].ToString() + "\">" + row["USER_NAME"].ToString() + "</label>&nbsp;&nbsp;");
                }
                return sbHtml.ToString();

                #endregion 学院HTML
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "单位信息管理，删除管理员失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 删除选中学院HTML
    }
}