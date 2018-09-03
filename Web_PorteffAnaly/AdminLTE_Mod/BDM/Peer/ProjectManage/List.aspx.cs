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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Peer.ProjectManage
{
    public partial class List : ListBaseLoad<Peer_project_head>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        public override string Doc_type { get { return CValue.DOC_TYPE_PE01; } }

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

        protected override SelectTransaction<Peer_project_head> GetSelectTransaction()
        {
            #region 过滤条件来源于“评议管理 >> 评议辅导员”

            if (Get("from_page").Equals("peer_coun"))//过滤条件来源于“评议管理 >> 评议辅导员”
            {
                //过滤评议开始时间、结束时间在当前时间之内
                param.Add(string.Format(" PEER_START <= '{0}' ", GetDateShortFormater()), "");
                param.Add(string.Format(" PEER_END >= '{0}' ", GetDateShortFormater()), "");
                //并且属于当前学年
                param.Add("PEER_YEAR", sch_info.CURRENT_YEAR);
                //排除已经申请的项目
                param.Add(string.Format("SEQ_NO NOT IN (SELECT PEER_SEQ_NO FROM PEER_COUN_HEAD WHERE STU_NUMBER = '{0}') ", user.User_Id), string.Empty);
            }

            #endregion 过滤条件来源于“评议管理 >> 评议辅导员”

            return ImplementFactory.GetSelectTransaction<Peer_project_head>("Peer_project_headSelectTransaction", param);
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

                        case "chkdel"://判断是否不满足删除条件：申请时间已经开始，已经有人开始申请
                            Response.Write(CheckIsCanDelData());
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
            if (!string.IsNullOrEmpty(Post("PEER_YEAR")))
                where += string.Format(" AND PEER_YEAR = '{0}' ", Post("PEER_YEAR"));
            if (!string.IsNullOrEmpty(Post("PEER_NAME")))
                where += string.Format(" AND PEER_NAME LIKE '%{0}%' ", Post("PEER_NAME"));
            if (!string.IsNullOrEmpty(Post("PEER_SEQ_NO")))
                where += string.Format(" AND SEQ_NO = '{0}' ", Post("PEER_SEQ_NO"));
            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Peer_project_head>.NameValue> GetValue(Peer_project_head entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "PEER_NAME", Value = entity.PEER_NAME };
            yield return new NameValue() { Name = "PEER_REMARK", Value = entity.PEER_REMARK };
            yield return new NameValue() { Name = "PEER_START", Value = entity.PEER_START };
            yield return new NameValue() { Name = "PEER_END", Value = entity.PEER_END };
            yield return new NameValue() { Name = "PEER_YEAR", Value = entity.PEER_YEAR };
            yield return new NameValue() { Name = "PEER_YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.PEER_YEAR) };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除主表的时候连带子表的数据也一并删除
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("id")))
                    return "OID为空,不允许删除操作";
                Peer_project_head head = new Peer_project_head();
                head.OID = Get("id");
                ds.RetrieveObject(head);
                var transaction = ImplementFactory.GetDeleteTransaction<Peer_project_head>("Peer_project_headDeleteTransaction");
                transaction.EntityList.Add(head);

                //已经改写了Commit方法，提交删除操作时会同时把：表体对应数据删除
                if (transaction.Commit())
                {
                    return string.Empty;
                }

                return "删除失败！";
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "评议项目设置，删除，出错：" + ex.ToString());
                return "删除失败！";
            }
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
            Peer_project_head head = new Peer_project_head();
            head.OID = strOID;
            ds.RetrieveObject(head);
            DateTime dtPEER_START = Convert.ToDateTime(head.PEER_START);
            DateTime dtSys = Convert.ToDateTime(GetDateShortFormater());
            if (dtPEER_START < dtSys)//申请开始日期 小于 系统当前日期
            {
                //判断是否有人已经开始申报
                int nCount = cod.ChangeInt(ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) AS APPLY_NUM FROM SHOOLAR_APPLY_HEAD WHERE PROJECT_SEQ_NO = '{0}' ", head.SEQ_NO)).ToString());
                if (nCount > 0)
                    return "该评议信息已经在评议阶段，无法删除！";
            }

            return string.Empty;
        }

        #endregion 判断是否不满足删除条件

        #region 保存方法

        /// <summary>
        ///保存方法
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            bool result = false;
            Peer_project_head head = new Peer_project_head();
            if (string.IsNullOrEmpty(Post("hidOid")))//新增
            {
                head.OID = Guid.NewGuid().ToString();
                head.SEQ_NO = GetSeq_no();
                GetPageValue(head);
                var inserttrcn = ImplementFactory.GetInsertTransaction<Peer_project_head>("Peer_project_headInsertTransaction");
                inserttrcn.EntityList.Add(head);
                result = inserttrcn.Commit();
            }
            else//修改
            {
                head.OID = Post("hidOid");
                ds.RetrieveObject(head);
                GetPageValue(head);
                var updatetrcn = ImplementFactory.GetUpdateTransaction<Peer_project_head>("Peer_project_headUpdateTransaction", user.User_Name);
                result = updatetrcn.Commit(head);
                if (result)
                {
                    ProjectSettingHandleClass.getInstance().UpdateRelationFunction(head.SEQ_NO);
                }
            }

            if (result)
            {
                StringBuilder json = new StringBuilder();//用来存放Json的
                json.Append("{");
                json.Append(Json.StringToJson(head.OID, "OID"));
                json.Append(",");
                json.Append(Json.StringToJson(head.SEQ_NO, "SEQ_NO"));
                json.Append("}");
                return json.ToString();
            }
            else
                return string.Empty;
        }

        #region 获得页面数据

        /// <summary>
        /// 获得页面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetPageValue(Peer_project_head model)
        {
            model.PEER_NAME = Post("PEER_NAME");
            model.PEER_YEAR = Post("PEER_YEAR");
            model.PEER_START = Post("PEER_START");
            model.PEER_END = Post("PEER_END");
            model.PEER_REMARK = Post("PEER_REMARK");
            model.OP_TIME = GetDateLongFormater();
            model.OP_CODE = user.User_Id;
            model.OP_NAME = user.User_Name;
        }

        #endregion 获得页面数据

        #endregion 保存方法
    }
}