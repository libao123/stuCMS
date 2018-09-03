using System;
using System.Collections.Generic;
using System.Data;
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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Score.Input
{
    public partial class List : ListBaseLoad<Score_rank_info>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public string strLastYear = string.Empty;

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

        protected override SelectTransaction<Score_rank_info> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Score_rank_info>("Score_rank_infoSelectTransaction", param);
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
                            Response.Write(Delete());
                            Response.End();
                            break;

                        case "save":
                            Response.Write(Save());
                            Response.End();
                            break;

                        case "chkstuinfo"://通过学号判断是否是辅导员所带班级的学生
                            Response.Write(ChkStuInfo());
                            Response.End();
                            break;

                        case "getstuinfo"://通过学号获得学生基础信息
                            Response.Write(GetStuInfo());
                            Response.End();
                            break;

                        case "getfdyclass":
                            Response.Write(GetFdyClassData());
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
            if (!string.IsNullOrEmpty(Post("XY")))
                where += string.Format(" AND XY = '{0}' ", Post("XY"));
            if (!string.IsNullOrEmpty(Post("ZY")))
                where += string.Format(" AND ZY = '{0}' ", Post("ZY"));
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("CLASS_CODE")))
                where += string.Format(" AND CLASS_CODE = '{0}' ", Post("CLASS_CODE"));
            if (!string.IsNullOrEmpty(Post("STU_NUMBER")))
                where += string.Format(" AND STU_NUMBER LIKE '%{0}%' ", Post("STU_NUMBER"));
            if (!string.IsNullOrEmpty(Post("STU_NAME")))
                where += string.Format(" AND STU_NAME LIKE '%{0}%' ", Post("STU_NAME"));

            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Score_rank_info>.NameValue> GetValue(Score_rank_info entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "STU_NUMBER", Value = entity.STU_NUMBER };
            yield return new NameValue() { Name = "STU_NAME", Value = entity.STU_NAME };
            yield return new NameValue() { Name = "YEAR", Value = entity.YEAR };
            yield return new NameValue() { Name = "YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.YEAR) };
            yield return new NameValue() { Name = "XY", Value = entity.XY };
            yield return new NameValue() { Name = "XY_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.XY) };
            yield return new NameValue() { Name = "ZY", Value = entity.ZY };
            yield return new NameValue() { Name = "ZY_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.ZY) };
            yield return new NameValue() { Name = "CLASS_CODE", Value = entity.CLASS_CODE };
            yield return new NameValue() { Name = "CLASS_CODE_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS_CODE) };
            yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
            yield return new NameValue() { Name = "SCORE_CONDUCT", Value = entity.SCORE_CONDUCT.ToString() };
            yield return new NameValue() { Name = "SCORE_COURSE", Value = entity.SCORE_COURSE.ToString() };
            yield return new NameValue() { Name = "SCORE_BODYART", Value = entity.SCORE_BODYART.ToString() };
            yield return new NameValue() { Name = "SCORE_JOBSKILL", Value = entity.SCORE_JOBSKILL.ToString() };
            yield return new NameValue() { Name = "SCORE_COM", Value = entity.SCORE_COM.ToString() };
            yield return new NameValue() { Name = "RANK_CLASS_COM", Value = entity.RANK_CLASS_COM.ToString() };
            yield return new NameValue() { Name = "RANK_CLASS_NUM", Value = entity.RANK_CLASS_NUM.ToString() };
            yield return new NameValue() { Name = "RANK_GRADE_COM", Value = entity.RANK_GRADE_COM.ToString() };
            yield return new NameValue() { Name = "RANK_GRADE_NUM", Value = entity.RANK_GRADE_NUM.ToString() };
            yield return new NameValue() { Name = "RANK_CLASS_PER", Value = entity.RANK_CLASS_PER.ToString() + "%" };
            yield return new NameValue() { Name = "RANK_GRADE_PER", Value = entity.RANK_GRADE_PER.ToString() + "%" };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            yield return new NameValue() { Name = "REMARK", Value = entity.REMARK };
            //ZZ 20171114 新增：加入各项百分比显示
            //zz 20171115 修改：从年级改成班级做限制条件
            yield return new NameValue() { Name = "SCORE_CONDUCT_PER", Value = Get_SCORE_CONDUCT_PER(entity.RANK_CLASS_NUM, entity.RANK_CLASS_CONDUCT) };//操行综合分%
            yield return new NameValue() { Name = "SCORE_COURSE_PER", Value = Get_SCORE_COURSE_PER(entity.RANK_CLASS_NUM, entity.RANK_CLASS_COURSE) };//课程学习综合分%
            yield return new NameValue() { Name = "SCORE_BODYART_PER", Value = Get_SCORE_BODYART_PER(entity.RANK_CLASS_NUM, entity.RANK_CLASS_BODYART) };//体艺综合分%
            yield return new NameValue() { Name = "SCORE_JOBSKILL_PER", Value = Get_SCORE_JOBSKILL_PER(entity.RANK_CLASS_NUM, entity.RANK_CLASS_JOBSKILL) };//职业技能综合分%
        }

        /// <summary>
        /// 操行综合分%
        /// </summary>
        /// <param name="nFenMu"></param>
        /// <param name="nFenZi"></param>
        /// <returns></returns>
        private string Get_SCORE_CONDUCT_PER(int nFenMu, int nFenZi)
        {
            decimal dPer = 0;
            decimal dFenMu = Math.Round(cod.ChangeDecimal(nFenMu.ToString()), 4);
            decimal dFenZi = Math.Round(cod.ChangeDecimal(nFenZi.ToString()), 4);
            if (nFenMu != 0)
                dPer = Math.Round(Math.Round(dFenZi / dFenMu, 4) * 100, 2);
            return dPer + "%";
        }

        /// <summary>
        /// 课程学习综合分%
        /// </summary>
        /// <param name="nFenMu"></param>
        /// <param name="nFenZi"></param>
        /// <returns></returns>
        private string Get_SCORE_COURSE_PER(int nFenMu, int nFenZi)
        {
            decimal dPer = 0;
            decimal dFenMu = Math.Round(cod.ChangeDecimal(nFenMu.ToString()), 4);
            decimal dFenZi = Math.Round(cod.ChangeDecimal(nFenZi.ToString()), 4);
            if (nFenMu != 0)
                dPer = Math.Round(Math.Round(dFenZi / dFenMu, 4) * 100, 2);
            return dPer + "%";
        }

        /// <summary>
        /// 体艺综合分%
        /// </summary>
        /// <param name="nFenMu"></param>
        /// <param name="nFenZi"></param>
        /// <returns></returns>
        private string Get_SCORE_BODYART_PER(int nFenMu, int nFenZi)
        {
            decimal dPer = 0;
            decimal dFenMu = Math.Round(cod.ChangeDecimal(nFenMu.ToString()), 4);
            decimal dFenZi = Math.Round(cod.ChangeDecimal(nFenZi.ToString()), 4);
            if (nFenMu != 0)
                dPer = Math.Round(Math.Round(dFenZi / dFenMu, 4) * 100, 2);
            return dPer + "%";
        }

        /// <summary>
        /// 职业技能综合分%
        /// </summary>
        /// <param name="nFenMu"></param>
        /// <param name="nFenZi"></param>
        /// <returns></returns>
        private string Get_SCORE_JOBSKILL_PER(int nFenMu, int nFenZi)
        {
            decimal dPer = 0;
            decimal dFenMu = Math.Round(cod.ChangeDecimal(nFenMu.ToString()), 4);
            decimal dFenZi = Math.Round(cod.ChangeDecimal(nFenZi.ToString()), 4);
            if (nFenMu != 0)
                dPer = Math.Round(Math.Round(dFenZi / dFenMu, 4) * 100, 2);
            return dPer + "%";
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除操作
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        private string Delete()
        {
            try
            {
                string[] strs = Get("ids").Split(',');
                for (int i = 0; i < strs.Length; i++)
                {
                    if (strs[i].Length == 0)
                        continue;
                    var model = new Score_rank_info();
                    model.OID = strs[i].ToString();
                    ds.RetrieveObject(model);

                    bool bDel = false;
                    var transaction = ImplementFactory.GetDeleteTransaction<Score_rank_info>("Score_rank_infoDeleteTransaction");
                    transaction.EntityList.Add(model);
                    bDel = transaction.Commit();

                    if (!bDel)
                        return "删除失败！";
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "删除成绩信息失败：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据

        #region 保存

        /// <summary>
        /// 保存方法
        /// </summary>
        /// <returns></returns>
        private string Save()
        {
            try
            {
                bool result = false;
                Score_rank_info head = new Score_rank_info();
                if (string.IsNullOrEmpty(Post("hidOid")))//新增
                {
                    //新增的时候，先通过学号+学年删除已有的数据再新增
                    string strDelSql = string.Format("DELETE FROM SCORE_RANK_INFO WHERE STU_NUMBER = '{0}'  AND YEAR = '{1}' ", Post("STU_NUMBER"), Post("YEAR"));
                    ds.ExecuteTxtNonQuery(strDelSql);
                    //再新增
                    head.OID = Guid.NewGuid().ToString();
                    GetPageValue(head);
                    head.YEAR = Post("YEAR");
                    head.STU_NUMBER = Post("STU_NUMBER");
                    head.STU_NAME = Post("STU_NAME");
                    head.GRADE = Post("GRADE");
                    head.XY = Post("XY");
                    head.ZY = Post("ZY");
                    head.CLASS_CODE = Post("CLASS_CODE");
                    var inserttrcn = ImplementFactory.GetInsertTransaction<Score_rank_info>("Score_rank_infoInsertTransaction");
                    inserttrcn.EntityList.Add(head);
                    result = inserttrcn.Commit();
                }
                else//修改
                {
                    head.OID = Post("hidOid");
                    ds.RetrieveObject(head);
                    GetPageValue(head);
                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Score_rank_info>("Score_rank_infoUpdateTransaction", user.User_Name);
                    result = updatetrcn.Commit(head);
                }
                if (!result)
                    return "成绩录入失败！";

                #region 成绩录入后即可由系统直接计算排名，无须手动进行

                //获得学生信息
                Basic_stu_info stuInfo = StuHandleClass.getInstance().GetStuInfo_Obj(head.STU_NUMBER);
                if (stuInfo != null)
                {
                    //ZZ 20171023 新增：成绩录入后即可由系统直接计算排名，无须手动进行
                    var inserttrcn_scorequeue = ImplementFactory.GetInsertTransaction<Score_rank_queue>("Score_rank_queueInsertTransaction");
                    Score_rank_queue queue = new Score_rank_queue();
                    queue.OID = Guid.NewGuid().ToString();
                    queue.YEAR = head.YEAR;
                    queue.GRADE = head.GRADE;
                    queue.CLASSCODE = head.CLASS_CODE;
                    queue.CREATE_USER_ID = user.User_Id;
                    queue.CREATE_USER = user.User_Name;
                    queue.CREATE_TIME = GetDateLongFormater();
                    queue.CREATE_TYPE = "A";
                    queue.HANDLE_STATUS = "N";
                    queue.STU_TYPE = stuInfo.STUTYPE;//学生类型
                    inserttrcn_scorequeue.EntityList.Add(queue);
                    inserttrcn_scorequeue.Commit();
                }

                #endregion 成绩录入后即可由系统直接计算排名，无须手动进行

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "成绩录入失败，原因：" + ex.ToString());
                return "成绩录入失败！";
            }
        }

        #region 获取页面文本

        /// <summary>
        /// 获取界面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetPageValue(Score_rank_info model)
        {
            ScoreHandleClass scoreHandle = new ScoreHandleClass();
            model.SCORE_CONDUCT = scoreHandle.GetHandleScore(Post("SCORE_CONDUCT"));
            model.SCORE_COURSE = scoreHandle.GetHandleScore(Post("SCORE_COURSE"));
            model.SCORE_BODYART = scoreHandle.GetHandleScore(Post("SCORE_BODYART"));
            model.SCORE_JOBSKILL = scoreHandle.GetHandleScore(Post("SCORE_JOBSKILL"));
            model.SCORE_COM = Math.Round(cod.ChangeDecimal(Post("SCORE_COM")), 2);
            model.REMARK = Post("REMARK");
            model.OP_CODE = user.User_Id;
            model.OP_NAME = user.User_Name;
            model.OP_TIME = GetDateLongFormater();
        }

        #endregion 获取页面文本

        #endregion 保存

        #region 获取辅导员所带班级HTML

        /// <summary>
        /// 获取辅导员所带班级HTML
        /// </summary>
        /// <returns></returns>
        private string GetFdyClassData()
        {
            string strSQL = string.Format("SELECT CLASSCODE AS VALUE, CLASSNAME AS TEXT FROM BASIC_CLASS_INFO WHERE 1=1 ");
            string strWhere = string.Empty;
            string strOrder = " ORDER BY CLASSCODE ASC ";
            ComHandleClass chc = new ComHandleClass();
            if (user.User_Role.Equals("S"))
            {
                strWhere += string.Format(" AND CLASSCODE = '{0}' ", chc.BySGetClassCode(user.User_Id));
            }
            //用户角色是辅导员的，只能看到所带班级的数据
            if (user.User_Role.Equals("F"))
            {
                string strFClass = chc.GetNoRepeatAndNoEmptyStringSql(chc.ByFGetClassCode(user.User_Id));
                if (!string.IsNullOrEmpty(strFClass))
                    strWhere += string.Format(" AND CLASSCODE IN ({0})", strFClass);
                else
                    strWhere += string.Format(" AND 1=2 ", strFClass);
            }
            strSQL = strSQL + strWhere + strOrder;
            DataTable dt = ds.ExecuteTxtDataTable(strSQL);

            StringBuilder sbHtml = new StringBuilder();
            foreach (DataRow row in dt.Rows)
            {
                if (row == null)
                    continue;
                sbHtml.Append("<div class=\"form-group col-sm-12\">");
                sbHtml.Append("<div class=\"col-sm-8\">");
                sbHtml.Append("<input name=\"fdy_class\" id=\"" + row["VALUE"].ToString() + "\"  type=\"checkbox\" value=\"" + row["VALUE"].ToString() + "\" class=\"flat-red\"/>&nbsp;&nbsp;<label for=\"" + row["VALUE"].ToString() + "\">" + row["TEXT"].ToString() + "</label>&nbsp;&nbsp;");
                sbHtml.Append("</div>");
                sbHtml.Append("</div>");
            }

            return sbHtml.ToString();
        }

        #endregion 获取辅导员所带班级HTML

        #region 通过学号判断是否是辅导员所带班级的学生

        /// <summary>
        /// 通过学号判断是否是辅导员所带班级的学生
        /// </summary>
        /// <returns></returns>
        private string ChkStuInfo()
        {
            Basic_stu_info info = StuHandleClass.getInstance().GetStuInfo_Obj(Get("stuno"));
            if (info == null)
                return string.Empty;

            ComHandleClass chc = new ComHandleClass();
            string strFClass = chc.ByFGetClassCode(user.User_Id);
            if (!strFClass.Contains(info.CLASS))
                return "录入的学号不是所带班级的学生，请确认！";
            return string.Empty;
        }

        #endregion 通过学号判断是否是辅导员所带班级的学生

        #region 通过学号获得学生基础信息

        /// <summary>
        /// 通过学号获得学生基础信息
        /// </summary>
        /// <returns></returns>
        private string GetStuInfo()
        {
            DataTable dt = StuHandleClass.getInstance().GetStuInfo_Dt(Get("stuno"));
            if (dt == null)
                return string.Empty;

            return Json.DatatableToJson(dt);
        }

        #endregion 通过学号获得学生基础信息
    }
}