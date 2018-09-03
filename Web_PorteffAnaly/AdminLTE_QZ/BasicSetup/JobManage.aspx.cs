using System;
using System.Collections.Generic;
using System.Text;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;
using HQ.Architecture.Strategy;

namespace PorteffAnaly.Web.AdminLTE_QZ.BasicSetup
{
    public partial class JobManage : ListBaseLoad<Qz_job_manage_set>
    {
        #region 初始化

        private comdata cod = new comdata();
        private ComTranClass comTran = new ComTranClass();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        #endregion 初始化

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

        protected override SelectTransaction<Qz_job_manage_set> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Qz_job_manage_set>("Qz_job_manage_setSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("SCH_YEAR")))
                where += string.Format(" AND SCH_YEAR = '{0}' ", Post("SCH_YEAR"));
            if (!string.IsNullOrEmpty(Post("SCH_TERM")))
                where += string.Format(" AND SCH_TERM = '{0}' ", Post("SCH_TERM"));
            return where;
        }

        #endregion 辅助页面加载

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
                        case "check":
                            Response.Write(CheckOnly());
                            Response.End();
                            break;
                        case "getnotice"://获得公告信息
                            Response.Write(GetNotice());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Qz_job_manage_set entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            yield return new NameValue() { Name = "SCH_YEAR", Value = entity.SCH_YEAR };
            yield return new NameValue() { Name = "SCH_TERM", Value = entity.SCH_TERM };
            yield return new NameValue() { Name = "IS_ENABLE", Value = entity.IS_ENABLE };
            yield return new NameValue() { Name = "REWARD_STD_B", Value = entity.REWARD_STD_B.ToString() };
            yield return new NameValue() { Name = "REWARD_UNIT_B", Value = entity.REWARD_UNIT_B };
            yield return new NameValue() { Name = "REWARD_STD_Y", Value = entity.REWARD_STD_Y.ToString() };
            yield return new NameValue() { Name = "REWARD_UNIT_Y", Value = entity.REWARD_UNIT_Y };
            yield return new NameValue() { Name = "DECLARE_START_TIME", Value = entity.DECLARE_START_TIME };
            yield return new NameValue() { Name = "DECLARE_END_TIME", Value = entity.DECLARE_END_TIME };
            yield return new NameValue() { Name = "SCH_YEAR2", Value = cod.GetDDLTextByValue("ddl_year_type", entity.SCH_YEAR) };
            yield return new NameValue() { Name = "SCH_TERM2", Value = cod.GetDDLTextByValue("ddl_xq", entity.SCH_TERM) };
            yield return new NameValue() { Name = "IS_ENABLE2", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.IS_ENABLE) };
            yield return new NameValue() { Name = "DECLARE_TIME", Value = string.Format("{0} 至 {1}", entity.DECLARE_START_TIME, entity.DECLARE_END_TIME) };
            yield return new NameValue() { Name = "NOTICE_ID", Value = entity.NOTICE_ID };
        }

        #endregion 输出列表信息

        #region 判断是否重复设置

        private string CheckOnly()
        {
            string oid = Get("oid");
            string sch_year = Get("year");
            string sch_term = Get("term");
            if (string.IsNullOrEmpty(sch_year) || string.IsNullOrEmpty(sch_term))
                return "请输入必填项！";
            Dictionary<string, string> param = new Dictionary<string, string>(){
				{"SCH_YEAR", sch_year},
                {"SCH_TERM", sch_term}
			};
            if (oid.Length > 0)
                param.Add(string.Format("OID NOT IN ('{0}')", oid), string.Empty);
            var selectTran = ImplementFactory.GetSelectTransaction<Qz_job_manage_set>("Qz_job_manage_setSelectTransaction", param);
            var selectList = selectTran.SelectAll();
            if (selectList == null || selectList.Count <= 0)
                return string.Empty;
            return "该学年、学期设置已存在!";
        }

        #endregion 判断是否重复设置

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                Qz_job_manage_set head = new Qz_job_manage_set();
                head.OID = Post("OID");
                if (head.OID == "")
                    head.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(head);
                head.SCH_YEAR = Post("SCH_YEAR");
                head.SCH_TERM = Post("SCH_TERM");
                head.IS_ENABLE = Post("IS_ENABLE");
                head.DECLARE_START_TIME = Post("DECLARE_START_TIME");
                head.DECLARE_END_TIME = Post("DECLARE_END_TIME");
                head.REWARD_STD_B = comTran.ToDecimal(Post("REWARD_STD_B"));
                head.REWARD_UNIT_B = Post("REWARD_UNIT_B");
                head.REWARD_STD_Y = comTran.ToDecimal(Post("REWARD_STD_Y"));
                head.REWARD_UNIT_Y = Post("REWARD_UNIT_Y");
                head.OP_CODE = user.User_Id;
                head.OP_NAME = user.User_Name;
                head.OP_TIME = ComTranClass.getInstance().GetCurrLongDateTime();

                ds.UpdateObject(head);
                
                return head.OID;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保存岗位申报基本设置出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 删除数据

        /// <summary>
        /// 删除主表数据并且把子表数据也删除
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            var code = Get("id");
            if (string.IsNullOrEmpty(code)) return "主键为空,不允许删除操作";

            var model = new Qz_job_manage_set();
            model.OID = code;
            ds.RetrieveObject(model);
            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Qz_job_manage_set>("Qz_job_manage_setDeleteTransaction");
            transaction.EntityList.Add(model);
            bDel = transaction.Commit();
            if (bDel)
                return "";
            return "删除失败！";
        }

        #endregion 删除数据

        #region 获得公告信息

        /// <summary>
        /// 获得公告信息
        /// </summary>
        /// <returns></returns>
        private string GetNotice()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("id")))
                    return string.Empty;

                Notice_info head = new Notice_info();
                head.OID = Get("id");
                ds.RetrieveObject(head);

                StringBuilder json = new StringBuilder();//用来存放Json的
                json.Append("{");
                json.Append(Json.StringToJson(head.TITLE, "TITLE"));
                json.Append(",");
                json.Append(Json.StringToJson(head.SUB_TITLE, "SUB_TITLE"));
                json.Append(",");
                json.Append(Json.StringToJson(head.FUNCTION_ID, "FUNCTION_ID"));
                json.Append(",");
                json.Append(Json.StringToJson(head.START_TIME, "START_TIME"));
                json.Append(",");
                json.Append(Json.StringToJson(head.END_TIME, "END_TIME"));
                json.Append(",");
                json.Append(Json.StringToJson(head.ROLEID, "ROLEID"));
                json.Append("}");
                return json.ToString();
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "获得公告信息JSON，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 获得公告信息
    }
}