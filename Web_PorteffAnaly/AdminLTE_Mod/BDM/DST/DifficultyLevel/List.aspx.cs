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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.DifficultyLevel
{
    public partial class List : ListBaseLoad<Dst_level_info>
    {
        #region 初始化

        private comdata cod = new comdata();
        private ComTranClass comTran = new ComTranClass();

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
                        case "save"://删除操作
                            Response.Write(SaveData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 辅助页面加载

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

        protected override SelectTransaction<Dst_level_info> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Dst_level_info>("Dst_level_infoSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("LEVEL_CODE")))
                where += string.Format(" AND LEVEL_CODE LIKE '%{0}%' ", Post("LEVEL_CODE"));
            if (!string.IsNullOrEmpty(Post("LEVEL_NAME")))
                where += string.Format(" AND LEVEL_NAME LIKE '%{0}%' ", Post("LEVEL_NAME"));
            return where;
        }

        #endregion 辅助页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Dst_level_info entity)
        {
            {
                yield return new NameValue() { Name = "OID", Value = entity.OID };
                yield return new NameValue() { Name = "LEVEL_CODE", Value = entity.LEVEL_CODE };
                yield return new NameValue() { Name = "LEVEL_NAME", Value = entity.LEVEL_NAME };
                yield return new NameValue() { Name = "LEVEL_NOTE", Value = entity.LEVEL_NOTE };
                yield return new NameValue() { Name = "OP_USER", Value = entity.OP_USER };
                yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
                yield return new NameValue() { Name = "RATIO", Value = entity.RATIO.ToString() };
            }
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除主表数据并且把子表数据也删除
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            var code = Post("OID");
            if (string.IsNullOrEmpty(code)) return "主键为空,不允许删除操作";

            var model = new Dst_level_info();
            model.OID = code;
            ds.RetrieveObject(model);

            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Dst_level_info>("Dst_level_infoDeleteTransaction");
            transaction.EntityList.Add(model);
            bDel = transaction.Commit();
            if (bDel)
                return "";
            return "删除失败！";
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
                Dst_level_info head = new Dst_level_info();
                head.OID = Post("OID");
                if (head.OID == "")
                    head.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(head);
                head.LEVEL_CODE = Post("LEVEL_CODE");
                head.LEVEL_NAME = Post("LEVEL_NAME");
                head.LEVEL_NOTE = Post("LEVEL_NOTE");
                head.RATIO = comTran.ToDecimal(Post("RATIO"));
                head.OP_USER = user.User_Name;
                head.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

                ds.UpdateObject(head);
                return head.OID;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        #endregion 保存数据
    }
}