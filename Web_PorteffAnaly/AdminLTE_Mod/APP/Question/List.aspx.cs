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

namespace PorteffAnaly.Web.AdminLTE_Mod.APP.Question
{
    public partial class List : ListBaseLoad<Question_info>
    {
        #region 初始化

        private comdata cod = new comdata();
        public bool bIsManage = false;

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

        protected override SelectTransaction<Question_info> GetSelectTransaction()
        {
            if (!string.IsNullOrEmpty(Get("page_from")))
            {
                if (Get("page_from").ToString().Equals("submit"))/// 提交问题
                {
                    param.Add("CREATE_CODE", user.User_Id);
                }
                else if (Get("page_from").ToString().Equals("manage"))   /// 问题管理
                {
                    //看到所有
                }
                else
                {
                    param.Add(" 1= 2 ", string.Empty);//看不到数据
                }
            }
            return ImplementFactory.GetSelectTransaction<Question_info>("Question_infoSelectTransaction", param);
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

                        case "check":
                            Response.Write(CheckIsCanEdit());
                            Response.End();
                            break;

                        case "getnote":
                            Response.Write(GetNote());
                            Response.End();
                            break;
                    }
                }
                if (!string.IsNullOrEmpty(Get("page_from")))
                {
                    if (Get("page_from").ToString().Equals("manage"))   /// 问题管理
                        bIsManage = true;
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
            if (!string.IsNullOrEmpty(Post("CREATE_CODE")))
                where += string.Format(" AND CREATE_CODE LIKE '%{0}%' ", Post("CREATE_CODE"));
            if (!string.IsNullOrEmpty(Post("CREATE_NAME")))
                where += string.Format(" AND CREATE_NAME LIKE '%{0}%' ", Post("CREATE_NAME"));
            if (!string.IsNullOrEmpty(Post("QUESTION_NOTE")))
                where += string.Format(" AND QUESTION_NOTE LIKE '%{0}%' ", Post("QUESTION_NOTE"));
            if (!string.IsNullOrEmpty(Post("HANDLE_FLAG")))
                where += string.Format(" AND HANDLE_FLAG = '{0}' ", Post("HANDLE_FLAG"));
            if (!string.IsNullOrEmpty(Post("QUESTION_TYPE")))
                where += string.Format(" AND QUESTION_TYPE = '{0}' ", Post("QUESTION_TYPE"));
            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Question_info>.NameValue> GetValue(Question_info entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "QUESTION_NOTE", Value = entity.QUESTION_NOTE };
            yield return new NameValue() { Name = "CREATE_CODE", Value = entity.CREATE_CODE };
            yield return new NameValue() { Name = "CREATE_NAME", Value = entity.CREATE_NAME };
            yield return new NameValue() { Name = "CREATE_TIME", Value = entity.CREATE_TIME };
            yield return new NameValue() { Name = "HANDLE_CODE", Value = entity.HANDLE_CODE };
            yield return new NameValue() { Name = "HANDLE_NAME", Value = entity.HANDLE_NAME };
            yield return new NameValue() { Name = "HANDLE_TIME", Value = entity.HANDLE_TIME };
            yield return new NameValue() { Name = "HANDLE_NOTE", Value = entity.HANDLE_NOTE };
            yield return new NameValue() { Name = "HANDLE_FLAG", Value = entity.HANDLE_FLAG };
            yield return new NameValue() { Name = "HANDLE_FLAG_NAME", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.HANDLE_FLAG) };
            yield return new NameValue() { Name = "QUESTION_TYPE", Value = entity.QUESTION_TYPE };
            yield return new NameValue() { Name = "QUESTION_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_question_type", entity.QUESTION_TYPE) };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                if (string.IsNullOrEmpty(Request.QueryString["id"]))
                    return "OID为空,不允许删除操作";

                Question_info head = new Question_info();
                head.OID = Request.QueryString["id"].ToString();
                ds.RetrieveObject(head);
                var transaction = ImplementFactory.GetDeleteTransaction<Question_info>("Question_infoDeleteTransaction");
                transaction.EntityList.Add(head);
                if (!transaction.Commit())
                    return "删除失败！";

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "问题反馈删除失败：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据

        #region 保存数据

        /// <summary>
        ///保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                bool result = false;
                Question_info head = new Question_info();
                if (string.IsNullOrEmpty(Post("hidOid")))//新增
                {
                    head.OID = Guid.NewGuid().ToString();
                    GetPageValue(head);
                    var inserttrcn = ImplementFactory.GetInsertTransaction<Question_info>("Question_infoInsertTransaction");
                    inserttrcn.EntityList.Add(head);
                    result = inserttrcn.Commit();
                }
                else//修改
                {
                    head.OID = Post("hidOid");
                    ds.RetrieveObject(head);
                    GetPageValue(head);
                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Question_info>("Question_infoUpdateTransaction", user.User_Name);
                    result = updatetrcn.Commit(head);
                }

                if (result)
                    return "提交成功！";
                else
                    return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "提交问题反馈，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #region 获得页面数据

        /// <summary>
        /// 获得页面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetPageValue(Question_info model)
        {
            model.QUESTION_TYPE = Post("QUESTION_TYPE");
            model.QUESTION_NOTE = Post("QUESTION_NOTE");
            model.HANDLE_NOTE = Post("HANDLE_NOTE");
            if (Post("hidPageFrom").Equals("submit"))
            {
                model.CREATE_TIME = GetDateLongFormater();
                model.CREATE_CODE = user.User_Id;
                model.CREATE_NAME = user.User_Name;
                model.HANDLE_FLAG = CValue.FLAG_N;
            }
            else if (Post("hidPageFrom").Equals("manage"))
            {
                model.HANDLE_TIME = GetDateLongFormater();
                model.HANDLE_CODE = user.User_Id;
                model.HANDLE_NAME = user.User_Name;
                if (model.HANDLE_NOTE.Length > 0)
                    model.HANDLE_FLAG = CValue.FLAG_Y;
                else
                    model.HANDLE_FLAG = CValue.FLAG_N;
            }
            else
            {
                model.HANDLE_FLAG = CValue.FLAG_N;
            }
        }

        #endregion 获得页面数据

        #endregion 保存数据

        #region 判断提交人是否可以再次编辑

        /// <summary>
        /// 判断提交人是否可以再次编辑
        /// </summary>
        /// <returns></returns>
        private string CheckIsCanEdit()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "主键不能为空！";
            Question_info que = new Question_info();
            que.OID = Get("id");
            ds.RetrieveObject(que);
            if (que.HANDLE_FLAG.Equals(CValue.FLAG_Y))
                return "该问题已经解决，无法再次编辑！";
            return string.Empty;
        }

        #endregion 判断提交人是否可以再次编辑

        #region 获得文本数据

        /// <summary>
        /// 获得文本数据
        /// </summary>
        /// <returns></returns>
        private string GetNote()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "{}";
            Question_info que = new Question_info();
            que.OID = Get("id");
            ds.RetrieveObject(que);
            if (que == null)
                return "{}";
            StringBuilder json = new StringBuilder();//用来存放Json的
            json.Append("{");
            json.Append(Json.StringToJson(que.QUESTION_NOTE, "QUESTION_NOTE"));
            json.Append(",");
            json.Append(Json.StringToJson(que.HANDLE_NOTE, "HANDLE_NOTE"));
            json.Append("}");
            return json.ToString();
        }

        #endregion 获得文本数据
    }
}