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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Peer.PeerCoun
{
    public partial class List : ListBaseLoad<Peer_coun_head>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        public override string Doc_type { get { return CValue.DOC_TYPE_PE02; } }

        protected override string input_code_column
        {
            get { return "STU_NUMBER"; }
        }

        protected override string class_code_column
        {
            get { return "CLASS_CODE"; }
        }

        protected override string xy_code_column
        {
            get { return "XY"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Peer_coun_head> GetSelectTransaction()
        {
            if (!string.IsNullOrEmpty(Get("page_from")))
            {
                if (Get("page_from").ToString().Equals("result")) //查询都是结束的
                    param.Add(string.Format("PEER_SEQ_NO IN (SELECT SEQ_NO FROM PEER_PROJECT_HEAD WHERE PEER_END < '{0}' ) ", GetDateShortFormater()), "");
            }

            return ImplementFactory.GetSelectTransaction<Peer_coun_head>("Peer_coun_headSelectTransaction", param);
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

                        case "iscan_peer"://判断是否满足评议条件：是学生并且有辅导员
                            Response.Write(ChkIsCanPeer());
                            Response.End();
                            break;

                        case "iscanop"://判断是否满足操作条件
                            Response.Write(ChkIsCanOp());
                            Response.End();
                            break;

                        case "counname"://获得辅导员名称
                            Response.Write(GetCounName());
                            Response.End();
                            break;

                        case "content"://获得评议内容项
                            Response.Write(GetContent());
                            Response.End();
                            break;

                        case "content_id"://获得评议内容项ID集合
                            Response.Write(GetContentId());
                            Response.End();
                            break;

                        case "save"://保存操作
                            Response.Write(SaveData());
                            Response.End();
                            break;

                        case "content_score"://获得评议内容打分
                            Response.Write(GetCounScore());
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
            if (!string.IsNullOrEmpty(Post("PEER_SEQ_NO")))
                where += string.Format(" AND PEER_SEQ_NO = '{0}' ", Post("PEER_SEQ_NO"));
            if (!string.IsNullOrEmpty(Post("COUN_NAME")))
                where += string.Format(" AND COUN_NAME LIKE '%{0}%' ", Post("COUN_NAME"));

            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Peer_coun_head>.NameValue> GetValue(Peer_coun_head entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            //项目数据
            yield return new NameValue() { Name = "PEER_SEQ_NO", Value = entity.PEER_SEQ_NO };
            yield return new NameValue() { Name = "PEER_NAME", Value = entity.PEER_NAME };
            yield return new NameValue() { Name = "PEER_YEAR", Value = entity.PEER_YEAR };
            yield return new NameValue() { Name = "PEER_YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.PEER_YEAR) };
            //评议辅导员信息
            yield return new NameValue() { Name = "COUN_ID", Value = entity.COUN_ID };
            yield return new NameValue() { Name = "COUN_NAME", Value = entity.COUN_NAME };
            yield return new NameValue() { Name = "COUN_DEPARTMENT", Value = entity.COUN_DEPARTMENT };
            yield return new NameValue() { Name = "COUN_DEPARTMENT_NAME", Value = cod.GetDDLTextByValue("ddl_all_department", entity.COUN_DEPARTMENT) };
            yield return new NameValue() { Name = "PEER_RESULT", Value = entity.PEER_RESULT };
            yield return new NameValue() { Name = "PEER_SCORE", Value = entity.PEER_SCORE.ToString() };
            //评议学生信息
            yield return new NameValue() { Name = "STU_NUMBER", Value = entity.STU_NUMBER };
            yield return new NameValue() { Name = "STU_NAME", Value = entity.STU_NAME };
            yield return new NameValue() { Name = "XY", Value = entity.XY };
            yield return new NameValue() { Name = "XY_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.XY) };
            yield return new NameValue() { Name = "ZY", Value = entity.ZY };
            yield return new NameValue() { Name = "ZY_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.ZY) };
            yield return new NameValue() { Name = "CLASS_CODE", Value = entity.CLASS_CODE };
            yield return new NameValue() { Name = "CLASS_CODE_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS_CODE) };
            yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
        }

        #endregion 输出列表信息

        #region 保存方法

        /// <summary>
        ///保存方法
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            bool result = false;
            Peer_coun_head head = new Peer_coun_head();
            if (string.IsNullOrEmpty(Post("hidOid")))//新增
            {
                head.OID = Guid.NewGuid().ToString();
                head.SEQ_NO = GetSeq_no();
                GetPageValue(head);
                var inserttrcn = ImplementFactory.GetInsertTransaction<Peer_coun_head>("Peer_coun_headInsertTransaction");
                inserttrcn.EntityList.Add(head);
                result = inserttrcn.Commit();
            }
            else//修改
            {
                head.OID = Post("hidOid");
                ds.RetrieveObject(head);
                GetPageValue(head);
                var updatetrcn = ImplementFactory.GetUpdateTransaction<Peer_coun_head>("Peer_coun_headUpdateTransaction", user.User_Name);
                result = updatetrcn.Commit(head);
            }

            if (result)
            {
                //成功之后保存表体
                SaveDataList(head.SEQ_NO, head.PEER_SEQ_NO);
                return head.OID;
            }
            else
                return string.Empty;
        }

        #region 获得页面数据

        /// <summary>
        /// 获得页面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetPageValue(Peer_coun_head model)
        {
            string strCounId = ComHandleClass.getInstance().ByStuNumberGetCounCode(user.User_Id);
            Basic_coun_info coun = CounHandleClass.getInstance().GetCounInfo_Obj(strCounId);
            if (coun != null)
            {
                model.COUN_ID = coun.ENO;
                model.COUN_NAME = coun.NAME;
                model.COUN_DEPARTMENT = coun.DEPARTMENT;
            }

            Basic_stu_info stu = StuHandleClass.getInstance().GetStuInfo_Obj(user.User_Id);
            if (stu != null)
            {
                model.STU_NAME = stu.NAME;
                model.STU_NUMBER = stu.NUMBER;
                model.XY = stu.COLLEGE;
                model.ZY = stu.MAJOR;
                model.GRADE = stu.EDULENTH;
                model.CLASS_CODE = stu.CLASS;
            }

            Peer_project_head peer = PeerInfoHandleClass.getInstance().GetPeerInfoHead(Post("hidPeerSeqNo"));
            if (peer != null)
            {
                model.PEER_SEQ_NO = peer.SEQ_NO;
                model.PEER_NAME = peer.PEER_NAME;
                model.PEER_YEAR = peer.PEER_YEAR;
            }
            model.OP_TIME = GetDateLongFormater();
        }

        #endregion 获得页面数据

        #endregion 保存方法

        #region 保存表体数据

        /// <summary>
        /// 保存表体数据
        /// </summary>
        /// <returns></returns>
        private void SaveDataList(string SeqNo, string PeerSeqNo)
        {
            //先删除
            ds.ExecuteTxtNonQuery(string.Format("DELETE FROM PEER_COUN_LIST WHERE SEQ_NO = '{0}' ", SeqNo));
            //再保存
            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("SEQ_NO", PeerSeqNo);
            List<Peer_project_list> list = PeerInfoHandleClass.getInstance().GetPeerContentList(param);
            var inserttrcn = ImplementFactory.GetInsertTransaction<Peer_coun_list>("Peer_coun_listInsertTransaction");
            decimal decTotalScore = 0;
            foreach (Peer_project_list temp in list)
            {
                if (temp == null)
                    continue;

                Peer_coun_list notboth = new Peer_coun_list();
                notboth.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(notboth);
                notboth.SEQ_NO = SeqNo;
                notboth.CONTENT_ID = temp.OID;
                notboth.CONTENT_SCORE = Math.Round(cod.ChangeDecimal(Post(temp.OID)), 1);
                decTotalScore += notboth.CONTENT_SCORE;
                inserttrcn.EntityList.Add(notboth);
            }
            bool res = inserttrcn.Commit();
            if (res)
            {
                decimal decPerScore = decTotalScore / list.Count;
                string strResult = PeerCounHandleClass.getInstance().GetPeerResult(decPerScore);
                //更新表头字段
                ds.ExecuteTxtNonQuery(string.Format("UPDATE PEER_COUN_HEAD SET PEER_SCORE = '{0}' ,PEER_RESULT= '{1}' WHERE SEQ_NO = '{2}' ", decPerScore, strResult, SeqNo));
            }
        }

        #endregion 保存表体数据

        #region 删除数据

        /// <summary>
        /// 删除主表的时候连带子表的数据也一并删除
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                if (string.IsNullOrEmpty(Request.QueryString["id"]))
                    return "OID为空,不允许删除操作";

                Peer_coun_head head = new Peer_coun_head();
                head.OID = Request.QueryString["id"].ToString();
                ds.RetrieveObject(head);

                var transaction = ImplementFactory.GetDeleteTransaction<Peer_coun_head>("Peer_coun_headDeleteTransaction");
                transaction.EntityList.Add(head);

                if (!transaction.Commit())
                    return "删除失败！";

                #region 删除子表

                //删除子表
                ds.ExecuteTxtNonQuery(string.Format("DELETE FROM PEER_COUN_LIST WHERE SEQ_NO = '{0}' ", head.SEQ_NO));

                #endregion 删除子表

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "评议删除失败：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据

        #region 判断是否满足评议条件：是学生并且有辅导员

        /// <summary>
        /// 判断是否满足评议条件：是学生并且有辅导员
        /// </summary>
        /// <returns></returns>
        private string ChkIsCanPeer()
        {
            Basic_stu_info stu = StuHandleClass.getInstance().GetStuInfo_Obj(user.User_Id);
            if (stu == null)
                return "该用户不是学生，无法进行辅导员评议！";

            string strCounId = ComHandleClass.getInstance().ByStuNumberGetCounCode(user.User_Id);
            if (strCounId.Length == 0)
                return "该学生所属的班级没有设置辅导员，无法进行辅导员评议！";

            return string.Empty;
        }

        #endregion 判断是否满足评议条件：是学生并且有辅导员

        #region 判断是否满足操作条件

        /// <summary>
        /// 判断是否满足操作条件
        /// </summary>
        /// <returns></returns>
        private string ChkIsCanOp()
        {
            if (string.IsNullOrEmpty(Get("peer_seq_no")))
                return "选择评议主题的单据编号为空,不允许操作！";

            Peer_project_head project_head = PeerInfoHandleClass.getInstance().GetPeerInfoHead(Get("peer_seq_no"));
            if (project_head == null)
                return "选择评议主题信息为空,不允许操作！";

            if (!ProjectSettingHandleClass.getInstance().CheckIsFitApplyDate(project_head.PEER_END, user.User_Role))
                return "该评议主题的评议结束日期已过，无法操作！";

            return string.Empty;
        }

        #endregion 判断是否满足操作条件

        #region 获得辅导员名称

        /// <summary>
        /// 获得辅导员名称
        /// </summary>
        /// <returns></returns>
        private string GetCounName()
        {
            string CounCode = ComHandleClass.getInstance().ByStuNumberGetCounCode(user.User_Id);
            string CounName = string.Empty;
            Basic_coun_info coun = CounHandleClass.getInstance().GetCounInfo_Obj(CounCode);
            if (coun != null)
                CounName = coun.NAME;

            return CounName;
        }

        #endregion 获得辅导员名称

        #region 获得评议主题中 评议内容

        /// <summary>
        ///获得评议主题中 评议内容
        /// </summary>
        /// <returns></returns>
        private string GetContent()
        {
            if (string.IsNullOrEmpty(Get("peer_seq_no")))
                return string.Empty;

            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("SEQ_NO", Get("peer_seq_no"));
            List<Peer_project_list> list = PeerInfoHandleClass.getInstance().GetPeerContentList(param);
            if (list == null)
                return string.Empty;

            StringBuilder strHtml = new StringBuilder();
            for (int i = 0; i < list.Count; i++)
            {
                strHtml.Append("<div class=\"form-group\">");
                strHtml.AppendFormat("<label class=\"col-sm-1 control-label\">{0}、</label>", i + 1);
                strHtml.AppendFormat("<label class=\"col-sm-9 control-label\" style=\"text-align: left;\">{0}</label>", list[i].PEER_CONTENT);
                strHtml.AppendFormat("<div class=\"col-sm-2\">");
                string strID = list[i].OID;
                strHtml.AppendFormat("<input name=\"{0}\" id=\"{0}\" type=\"text\" class=\"form-control\" placeholder=\"评分\" maxlength=\"4\" />", strID);
                strHtml.Append("</div>");
                strHtml.Append("</div>");
            }

            return strHtml.ToString();
        }

        #endregion 获得评议主题中 评议内容

        #region 获得评议主题的评议内容ID集合

        /// <summary>
        ///获得评议主题的评议内容ID集合
        /// </summary>
        /// <returns></returns>
        private string GetContentId()
        {
            if (string.IsNullOrEmpty(Get("peer_seq_no")))
                return string.Empty;

            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("SEQ_NO", Get("peer_seq_no"));
            List<Peer_project_list> list = PeerInfoHandleClass.getInstance().GetPeerContentList(param);
            if (list == null)
                return string.Empty;

            StringBuilder strId = new StringBuilder();
            for (int i = 0; i < list.Count; i++)
            {
                strId.AppendFormat("{0},", list[i].OID);
            }

            return strId.ToString();
        }

        #endregion 获得评议主题的评议内容ID集合

        #region 获得评议辅导员的评议内容打分

        /// <summary>
        /// 获得评议辅导员的评议内容打分
        /// </summary>
        /// <returns></returns>
        private string GetCounScore()
        {
            if (string.IsNullOrEmpty(Get("seq_no")))
                return "{}";

            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("SEQ_NO", Get("seq_no"));
            List<Peer_coun_list> list = PeerCounHandleClass.getInstance().GetPeerCounContentList(param);
            if (list == null)
                return "{}";

            StringBuilder json = new StringBuilder();//用来存放Json的
            json.Append("{");
            foreach (Peer_coun_list counList in list)
            {
                json.Append(Json.StringToJson(counList.CONTENT_SCORE.ToString(), counList.CONTENT_ID));
                json.Append(",");
            }
            if (json[json.Length - 1].Equals(','))
            {//必须有数据才去掉最后一个逗号‘,’
                json.Remove(json.Length - 1, 1);//去掉最后一个逗号
            }
            json.Append("}");
            return json.ToString();
        }

        #endregion 获得评议辅导员的评议内容打分
    }
}