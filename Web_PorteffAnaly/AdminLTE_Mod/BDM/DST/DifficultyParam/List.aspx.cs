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
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.DifficultyParam
{
    public partial class List : ListBaseLoad<Dst_param_info>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

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
                        case "check":
                            Response.Write(CheckOnly(Get("oid"), Get("schyear"), Get("batch")));
                            //Response.Write(CheckExists(Get("oid"), Get("schyear")));
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

        protected override IEnumerable<NameValue> GetValue(Dst_param_info entity)
        {
            {
                yield return new NameValue() { Name = "OID", Value = entity.OID };
                yield return new NameValue() { Name = "SCHYEAR", Value = entity.SCHYEAR };
                yield return new NameValue() { Name = "SCHYEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.SCHYEAR) };
                yield return new NameValue() { Name = "FAMILY_INFO_FLAG", Value = entity.FAMILY_INFO_FLAG };
                yield return new NameValue() { Name = "FAMILY_INFO_FLAG_NAME", Value = cod.GetDDLTextByValue("ddl_on_off", entity.FAMILY_INFO_FLAG) };
                yield return new NameValue() { Name = "FAMILY_TIME", Value = string.Format("{0} 至 {1}", entity.FAMILY_START_TIME, entity.FAMILY_END_TIME) };
                yield return new NameValue() { Name = "FAMILY_START_TIME", Value = entity.FAMILY_START_TIME };
                yield return new NameValue() { Name = "FAMILY_END_TIME", Value = entity.FAMILY_END_TIME };
                yield return new NameValue() { Name = "DECLARE_FLAG", Value = entity.DECLARE_FLAG };
                yield return new NameValue() { Name = "DECLARE_FLAG_NAME", Value = cod.GetDDLTextByValue("ddl_on_off", entity.DECLARE_FLAG) };
                yield return new NameValue() { Name = "DECLARE_TIME", Value = string.Format("{0} 至 {1}", entity.DECLARE_START_TIME, entity.DECLARE_END_TIME) };
                yield return new NameValue() { Name = "DECLARE_START_TIME", Value = entity.DECLARE_START_TIME };
                yield return new NameValue() { Name = "DECLARE_END_TIME", Value = entity.DECLARE_END_TIME };
                yield return new NameValue() { Name = "NEED_FAMILY_FLAG", Value = entity.NEED_FAMILY_FLAG };
                yield return new NameValue() { Name = "NEED_FAMILY_FLAG_NAME", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.NEED_FAMILY_FLAG) };
                yield return new NameValue() { Name = "OP_USER", Value = entity.OP_USER };
                yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
                yield return new NameValue() { Name = "APPLY_NOTICE_ID", Value = entity.APPLY_NOTICE_ID };
                yield return new NameValue() { Name = "SURVEY_NOTICE_ID", Value = entity.SURVEY_NOTICE_ID };
                yield return new NameValue() { Name = "BATCH_NO", Value = entity.BATCH_NO };
                yield return new NameValue() { Name = "BATCH_NAME", Value = cod.GetDDLTextByValue("ddl_batch", entity.BATCH_NO) };
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
            var code = Get("id");
            if (string.IsNullOrEmpty(code)) return "主键为空,不允许删除操作";

            var model = new Dst_param_info();
            model.OID = code;
            ds.RetrieveObject(model);
            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Dst_param_info>("Dst_param_infoDeleteTransaction");
            transaction.EntityList.Add(model);
            bDel = transaction.Commit();
            if (bDel)
                return "";
            return "删除失败！";
        }

        #endregion 删除数据

        #region 判断是否不满足删除条件

        /// <summary>
        /// 判断是否不满足删除条件
        /// </summary>
        /// <returns></returns>
        private string CheckIsCanDelData()
        {
            string strOID = Request.QueryString["id"];
            if (string.IsNullOrEmpty(strOID))
                return "OID为空,不允许删除操作";
            Dst_param_info head = new Dst_param_info();
            head.OID = strOID;
            ds.RetrieveObject(head);
            DateTime dtAPPLY_START = Convert.ToDateTime(head.DECLARE_START_TIME);
            DateTime dtSys = Convert.ToDateTime(GetDateShortFormater());
            if (dtAPPLY_START < dtSys)//申请开始日期 小于 系统当前日期
            {
                //判断是否有人已经开始申报
                int nCount = cod.ChangeInt(ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) AS APPLY_NUM FROM DST_STU_APPLY WHERE SCHYEAR = '{0}' ", head.SCHYEAR)).ToString());
                if (nCount > 0)
                    return "该奖助项目已经在申请阶段，无法删除！";
            }

            return string.Empty;
        }

        #endregion 判断是否不满足删除条件

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

        protected override SelectTransaction<Dst_param_info> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Dst_param_info>("Dst_param_infoSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("SCHYEAR")))
                where += string.Format(" AND SCHYEAR = '{0}' ", Post("SCHYEAR"));
            return where;
        }

        #endregion 辅助页面加载

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                Dst_param_info head = new Dst_param_info();
                head.OID = Post("OID");
                if (head.OID == "")
                    head.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(head);
                head.SCHYEAR = Post("SCHYEAR");
                head.FAMILY_INFO_FLAG = Post("FAMILY_INFO_FLAG");
                head.FAMILY_START_TIME = Post("FAMILY_START_TIME");
                head.FAMILY_END_TIME = Post("FAMILY_END_TIME");
                head.DECLARE_FLAG = Post("DECLARE_FLAG");
                head.DECLARE_START_TIME = Post("DECLARE_START_TIME");
                head.DECLARE_END_TIME = Post("DECLARE_END_TIME");
                head.NEED_FAMILY_FLAG = Post("NEED_FAMILY_FLAG");
                head.BATCH_NO = Post("BATCH_NO");
                head.OP_USER = user.User_Name;
                head.OP_TIME = ComTranClass.getInstance().GetCurrLongDateTime();

                ds.UpdateObject(head);
                //修改该学年其他设置的开关状态
                try
                {
                    if (head.FAMILY_INFO_FLAG.Equals(CValue.FLAG_Y))
                        ds.ExecuteTxtNonQuery(string.Format("UPDATE DST_PARAM_INFO SET FAMILY_INFO_FLAG = 'N' WHERE SCHYEAR = '{0}' AND OID != '{1}'", head.SCHYEAR, head.OID));
                    if (head.DECLARE_FLAG.Equals(CValue.FLAG_Y))
                        ds.ExecuteTxtNonQuery(string.Format("UPDATE DST_PARAM_INFO SET DECLARE_FLAG = 'N' WHERE SCHYEAR = '{0}' AND OID != '{1}'", head.SCHYEAR, head.OID));

                }
                catch (Exception ex)
                {
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "修改该学年其他设置的开关状态出错：" + ex.ToString());
                }
                return head.OID;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保存困难生认定基本设置出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 判断是否重复设置

        private string CheckOnly(string oid, string schyear, string batch)
        {
            if (string.IsNullOrEmpty(schyear) || string.IsNullOrEmpty(batch))
                return "请输入必填项！";
            Dictionary<string, string> param = new Dictionary<string, string>(){
				{"SCHYEAR", schyear},
                {"BATCH_NO", batch}
			};
            if (oid.Length > 0)
                param.Add(string.Format("OID NOT IN ('{0}')", oid), string.Empty);
            var selectTran = ImplementFactory.GetSelectTransaction<Dst_param_info>("Dst_param_infoSelectTransaction", param);
            var selectList = selectTran.SelectAll();
            if (selectList == null || selectList.Count <= 0)
                return string.Empty;
            return "该学年该批次设置已存在!";
        }

        #endregion 判断是否重复设置

        #region 校验该学年是否存在设置

        private string CheckExists(string oid, string schyear)
        {
            Object obtype = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM Dst_param_info WHERE SCHYEAR='{0}' {1}", schyear, oid.Length > 0 ? string.Format("AND OID NOT IN ('{0}')", oid) : string.Empty));
            if (int.Parse(obtype.ToString()) > 0)
            {
                return "该学年基本设置已存在，是否重新设置?";
            }
            return string.Empty;
        }

        #endregion 校验该学年是否存在设置

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