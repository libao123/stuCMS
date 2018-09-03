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

namespace PorteffAnaly.Web.AdminLTE_Mod.SysBasic.zy
{
    public partial class List : ListBaseLoad<T_jx_zy>
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

        protected override SelectTransaction<T_jx_zy> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<T_jx_zy>("T_jx_zySelectTransaction", param);
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
                where += string.Format(" AND ZY LIKE '%{0}%' ", Post("ZY"));
            if (!string.IsNullOrEmpty(Post("MC")))
                where += string.Format(" AND MC LIKE '%{0}%' ", Post("MC"));
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
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(T_jx_zy entity)
        {
            yield return new NameValue() { Name = "ZY", Value = entity.ZY };
            yield return new NameValue() { Name = "MC", Value = entity.MC };
            yield return new NameValue() { Name = "YWMC", Value = entity.YWMC };
            yield return new NameValue() { Name = "XY", Value = entity.XY };
            yield return new NameValue() { Name = "XSH", Value = entity.XSH };
            yield return new NameValue() { Name = "ZT", Value = entity.ZT };
            yield return new NameValue() { Name = "XY_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.XY) };
            yield return new NameValue() { Name = "XSH_NAME", Value = cod.GetDDLTextByValue("ddl_xsh", entity.XSH) };
            yield return new NameValue() { Name = "ZT_NAME", Value = cod.GetDDLTextByValue("ddl_use_flag", entity.ZT) };
            yield return new NameValue() { Name = "LB", Value = entity.LB };
            yield return new NameValue() { Name = "ZYGB", Value = entity.ZYGB };
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
            T_jx_zy head = new T_jx_zy();
            head.ZY = Get("id");
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<T_jx_zy>("T_jx_zyDeleteTransaction");
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
                T_jx_zy head = new T_jx_zy();
                head.ZY = Post("ZY").Trim();
                ds.RetrieveObject(head);
                head.MC = Post("MC").Trim();
                head.YWMC = Post("YWMC");
                head.XY = Post("XY");
                head.ZT = Post("ZT");
                ds.UpdateObject(head);
                //记录操作日志

                return head.ZY;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保存专业信息出错：" + ex.ToString());
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
            if (string.IsNullOrEmpty(Get("zy")))
                return "专业代码不能为空！";

            string strSQL = string.Format("SELECT COUNT(*) AS NUM FROM t_jx_zy WHERE zy = '{0}' ", Get("zy"));
            int nCount = cod.ChangeInt(ds.ExecuteTxtScalar(strSQL).ToString());
            if (nCount > 0)
                return "该专业代码已存在，请确认！";
            return string.Empty;
        }

        #endregion 校验学院代码的唯一性
    }
}