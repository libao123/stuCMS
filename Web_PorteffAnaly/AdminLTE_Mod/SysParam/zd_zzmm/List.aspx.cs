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

namespace PorteffAnaly.Web.AdminLTE_Mod.SysParam.zd_zzmm
{
    public partial class List : ListBaseLoad<T_zd_zzmm>
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

        protected override SelectTransaction<T_zd_zzmm> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<T_zd_zzmm>("T_zd_zzmmSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("DM")))
                where += string.Format(" AND DM LIKE '%{0}%' ", Post("DM"));
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
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<T_zd_zzmm>.NameValue> GetValue(T_zd_zzmm entity)
        {
            yield return new NameValue() { Name = "DM", Value = entity.DM };
            yield return new NameValue() { Name = "MC", Value = entity.MC };
            yield return new NameValue() { Name = "YWMC", Value = entity.YWMC };
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
            T_zd_zzmm head = new T_zd_zzmm();
            head.DM = Get("id");
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<T_zd_zzmm>("T_zd_zzmmDeleteTransaction");
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
                T_zd_zzmm head = new T_zd_zzmm();
                head.DM = Post("DM").Trim();
                ds.RetrieveObject(head);
                head.MC = Post("MC").Trim();
                head.YWMC = Post("YWMC");
                ds.UpdateObject(head);
                return head.DM;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        #endregion 保存数据
    }
}