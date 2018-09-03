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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Score.RankInfo
{
    public partial class QueueList : ListBaseLoad<Score_rank_queue>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public string strLastYear = string.Empty;

        protected override string input_code_column
        {
            get { return "CREATE_USER_ID"; }
        }

        protected override string class_code_column
        {
            get { return "CLASSCODE"; }
        }

        protected override string xy_code_column
        {
            get { return "XY"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Score_rank_queue> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Score_rank_queue>("Score_rank_queueSelectTransaction", param);
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

                        case "update"://
                            Response.Write(UpdateHandleStatus());
                            Response.End();
                            break;

                        case "save"://
                            Response.Write(SaveData());
                            Response.End();
                            break;

                        case "del":
                            Response.Write(DeleteData());
                            Response.End();
                            break;
                    }
                }
                //ZZ 20171024 默认学年：成绩默认是上一学年
                strLastYear = (cod.ChangeInt(sch_info.CURRENT_YEAR) - 1).ToString();
            }
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("YEAR")))
                where += string.Format(" AND YEAR = '{0}' ", Post("YEAR"));
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("CLASSCODE")))
                where += string.Format(" AND CLASSCODE = '{0}' ", Post("CLASSCODE"));
            if (!string.IsNullOrEmpty(Post("HANDLE_STATUS")))
                where += string.Format(" AND HANDLE_STATUS = '{0}' ", Post("HANDLE_STATUS"));
            if (!string.IsNullOrEmpty(Post("STU_TYPE")))
                where += string.Format(" AND STU_TYPE = '{0}' ", Post("STU_TYPE"));
            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Score_rank_queue>.NameValue> GetValue(Score_rank_queue entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "YEAR", Value = entity.YEAR };
            yield return new NameValue() { Name = "YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.YEAR) };
            yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
            yield return new NameValue() { Name = "CLASSCODE", Value = entity.CLASSCODE };
            yield return new NameValue() { Name = "CLASSCODE_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASSCODE) };
            yield return new NameValue() { Name = "CREATE_TIME", Value = entity.CREATE_TIME };
            yield return new NameValue() { Name = "CREATE_USER", Value = entity.CREATE_USER };
            yield return new NameValue() { Name = "CREATE_TYPE", Value = entity.CREATE_TYPE };
            yield return new NameValue() { Name = "HANDLE_MSG", Value = entity.HANDLE_MSG };
            yield return new NameValue() { Name = "HANDLE_STATUS", Value = cod.GetDDLTextByValue("ddl_queue_status", entity.HANDLE_STATUS) };
            yield return new NameValue() { Name = "HANDLE_TIME", Value = entity.HANDLE_TIME };
            //ZZ 20171024 新增：学生类型
            yield return new NameValue() { Name = "STU_TYPE", Value = entity.STU_TYPE };
            yield return new NameValue() { Name = "STU_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_basic_stu_type", entity.STU_TYPE) };
        }

        #endregion 输出列表信息

        #region 新增计算排名队列

        /// <summary>
        /// 保存
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                Score_rank_queue head = new Score_rank_queue();
                head.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(head);
                head.STU_TYPE = Post("STU_TYPE");
                head.YEAR = Post("YEAR");
                head.GRADE = Post("GRADE");
                head.CLASSCODE = Post("CLASSCODE");
                head.HANDLE_STATUS = "N";
                head.CREATE_TIME = GetDateLongFormater();
                head.CREATE_USER = user.User_Name;
                head.CREATE_USER_ID = user.User_Id;
                head.CREATE_TYPE = "M";
                ds.UpdateObject(head);
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "新增计算排名队列失败：" + ex.ToString());
                return "新增计算排名队列失败！";
            }
        }

        #endregion 新增计算排名队列

        #region 修改处理状态

        /// <summary>
        /// 修改处理状态
        /// </summary>
        /// <returns></returns>
        private string UpdateHandleStatus()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "主键不能为空！";
            try
            {
                Score_rank_queue quene = new Score_rank_queue();
                quene.OID = Get("id");
                ds.RetrieveObject(quene);
                if (!quene.HANDLE_STATUS.Equals("E"))
                {
                    return "只能是异常的数据才可以重新进行操作！";
                }
                quene.HANDLE_STATUS = "N";
                quene.HANDLE_TIME = GetDateLongFormater();
                ds.UpdateObject(quene);
                return string.Empty;
            }
            catch (Exception ex)
            {
                return "重新处理排名失败！";
            }
        }

        #endregion 修改处理状态

        #region 删除记录

        /// <summary>
        /// 删除记录
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                string fromDATE = Post("Fromdate");//获取页面文本信息。
                string toDATE = Post("Todate");
                Dictionary<string, string> param = new Dictionary<string, string>{
				{string.Format(" CREATE_TIME BETWEEN '{0} 00:00:00,000' AND '{1} 23:59:59,999'", fromDATE, toDATE), ""} };//筛选出数据的SQL。
                var selecttrcn = ImplementFactory.GetSelectTransaction<Score_rank_queue>("Score_rank_queueSelectTransaction", param);
                var list = selecttrcn.SelectAll();

                var deletetrcn = ImplementFactory.GetDeleteTransaction<Score_rank_queue>("Score_rank_queueDeleteTransaction");
                for (int i = 0; i < list.Count; i++)
                {
                    deletetrcn.EntityList.Add(new Score_rank_queue()
                    {
                        OID = list[i].OID//获取筛选出的数据的OID，并添加到删除事务里。
                    });
                }

                if (list.Count > 0 && deletetrcn.Commit())
                {
                    return "";
                }
                else
                {
                    return "删除不成功！";
                }
            }
            catch (Exception ex)
            {
                return string.Format("删除记录异常，原因：{0}", ex.Message);
            }
        }

        #endregion 删除记录
    }
}