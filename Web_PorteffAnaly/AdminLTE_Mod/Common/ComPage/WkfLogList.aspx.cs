using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.Common.ComPage
{
    public partial class WkfLogList : ListBaseLoad<Wkf_client_log>
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

        protected override HQ.Architecture.Strategy.SelectTransaction<Wkf_client_log> GetSelectTransaction()
        {
            if (!string.IsNullOrEmpty(Get("seq_no")))
            {
                param.Add("DOC_NO", Get("seq_no"));
            }
            else
            {
                param.Add(" 1=2 ", string.Empty);
            }
            //ZZ 20171024 修改：学生也可以看到除了 业务申请之外的历史操作
            //if (user.User_Role.Equals(CValue.ROLE_TYPE_S))
            //{
            //    param.Add("DECLARE_TYPE", CValue.DECLARE_TYPE_D);
            //}
            return ImplementFactory.GetSelectTransaction<Wkf_client_log>("Wkf_client_logSelectTransaction", param);
        }

        #endregion 初始化

        #region 页面加载

        /// <summary>
        /// 页面加载
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "getlist"://获取列表
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
        public string GetSearchWhere(string where)
        {
            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        /// <summary>
        /// 重载输出列表信息
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        protected override IEnumerable<ListBaseLoad<Wkf_client_log>.NameValue> GetValue(Wkf_client_log entity)
        {
            yield return new NameValue() { Name = "STEP_NO", Value = cod.GetDDLTextByValue("ddl_STEP_NO", entity.STEP_NO) };
            //yield return new NameValue() { Name = "RET_CHANNEL", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.RET_CHANNEL) };
            yield return new NameValue() { Name = "RET_CHANNEL", Value = GetRET_CHANNEL(entity.POST_CODE, entity.RET_CHANNEL) };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            yield return new NameValue() { Name = "OP_USER", Value = entity.OP_USER };//操作人代码
            yield return new NameValue() { Name = "OP_USER_NAME", Value = entity.OP_USER_NAME };//操作人名称
            yield return new NameValue() { Name = "OP_NOTES", Value = entity.OP_NOTES };
            yield return new NameValue() { Name = "POST_CODE", Value = cod.GetDDLTextByValue("ddl_ua_role", entity.POST_CODE) };
            yield return new NameValue() { Name = "DECLARE_TYPE", Value = cod.GetDDLTextByValue("ddl_DECLARE_TYPE", entity.DECLARE_TYPE) };
        }

        #endregion 输出列表信息

        #region 单据回执状态

        private string GetRET_CHANNEL(string post_code, string ret_channel)
        {
            string value = string.Empty;
            if (ret_channel.StartsWith("D") && ret_channel.EndsWith("10"))
                value = cod.GetDDLTextByValue("ddl_ua_role", post_code) + "通过";
            else if (ret_channel.StartsWith("D") && ret_channel.EndsWith("20"))
                value = cod.GetDDLTextByValue("ddl_ua_role", post_code) + "不通过";
            else
                value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", ret_channel);

            return value;
        }

        #endregion 单据回执状态
    }
}