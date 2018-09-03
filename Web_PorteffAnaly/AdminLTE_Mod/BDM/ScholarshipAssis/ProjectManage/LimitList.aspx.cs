using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.Architecture.Factory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectManage
{
    public partial class LimitList : Main
    {
        #region 初始化

        public comdata cod = new comdata();

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
                        case "getlimitdata"://获得相应的条件限制数据
                            Response.Write(GetLimitData());
                            Response.End();
                            break;

                        case "save"://保存数据
                            Response.Write(SaveData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 获得相应的条件限制数据

        /// <summary>
        /// 获得相应的条件限制数据
        /// </summary>
        /// <returns></returns>
        private string GetLimitData()
        {
            StringBuilder json = new StringBuilder();//用来存放Json的
            Dictionary<string, string> param = new Dictionary<string, string> { { "SEQ_NO", Get("seq_no") } };
            List<Shoolar_project_limit> limitList = ProjectSettingHandleClass.getInstance().GetProjectLimitList(param);
            if (limitList == null || limitList.Count == 0)
                return "{}";
            json.Append("{");
            foreach (Shoolar_project_limit item in limitList)
            {
                if (item == null)
                    continue;

                switch (item.LIMIT_TYPE)
                {
                    case "Limit_ComRank"://综合考评总分排名
                        json.Append(Json.StringToJson(item.LIMIT_VALUE, "Limit_ComRank_Value"));
                        json.Append(",");
                        break;
                    case "Limit_ComScore"://综合考评总分
                        json.Append(Json.StringToJson(item.LIMIT_RANKPER.ToString(), "Limit_ComScore_RankPer"));
                        json.Append(",");
                        json.Append(Json.StringToJson(item.LIMIT_SCORE.ToString(), "Limit_ComScore_Score"));
                        json.Append(",");
                        break;
                    case "Limit_Conduct"://操行能单项综合分
                        json.Append(Json.StringToJson(item.LIMIT_RANKPER.ToString(), "Limit_Conduct_RankPer"));
                        json.Append(",");
                        json.Append(Json.StringToJson(item.LIMIT_SCORE.ToString(), "Limit_Conduct_Score"));
                        json.Append(",");
                        break;
                    case "Limit_Course"://课程能单项综合分
                        json.Append(Json.StringToJson(item.LIMIT_RANKPER.ToString(), "Limit_Course_RankPer"));
                        json.Append(",");
                        json.Append(Json.StringToJson(item.LIMIT_SCORE.ToString(), "Limit_Course_Score"));
                        json.Append(",");
                        break;
                    case "Limit_BodyArt"://体艺能单项综合分
                        json.Append(Json.StringToJson(item.LIMIT_RANKPER.ToString(), "Limit_BodyArt_RankPer"));
                        json.Append(",");
                        json.Append(Json.StringToJson(item.LIMIT_SCORE.ToString(), "Limit_BodyArt_Score"));
                        json.Append(",");
                        break;
                    case "Limit_JobSkill"://职业技能单项综合分
                        json.Append(Json.StringToJson(item.LIMIT_RANKPER.ToString(), "Limit_JobSkill_RankPer"));
                        json.Append(",");
                        json.Append(Json.StringToJson(item.LIMIT_SCORE.ToString(), "Limit_JobSkill_Score"));
                        json.Append(",");
                        break;
                    case "Limit_Total"://操行、课程、体艺、职业技能四个单项综合分
                        json.Append(Json.StringToJson(item.LIMIT_RANKPER.ToString(), "Limit_Total_RankPer"));
                        json.Append(",");
                        break;
                    case "Limit_Three"://操行、课程、体艺、职业技能分项任三个前x%
                        json.Append(Json.StringToJson(item.LIMIT_RANKPER.ToString(), "Limit_Three_RankPer"));
                        json.Append(",");
                        break;
                    case "Limit_One"://操行、课程、体艺、职业技能分项任三个前x%，另一个可放宽至x%
                        json.Append(Json.StringToJson(item.LIMIT_RANKPER.ToString(), "Limit_One_RankPer"));
                        json.Append(",");
                        break;
                    case "Limit_Grade"://年级
                        json.Append(Json.StringToJson(item.LIMIT_VALUE.ToString(), "Limit_Grade_Value"));
                        json.Append(",");
                        break;
                    case "Limit_Student"://学生类型
                        json.Append(Json.StringToJson(item.LIMIT_VALUE.ToString(), "Limit_Student_Value"));
                        json.Append(",");
                        break;
                    case "Limit_KN"://困难生档次
                        json.Append(Json.StringToJson(item.LIMIT_VALUE.ToString(), "Limit_KN_Value"));
                        json.Append(",");
                        break;
                    default:
                        break;
                }
            }
            if (json[json.Length - 1].Equals(','))
            {//必须有数据才去掉最后一个逗号‘,’,不然会报错 20120816 mo
                json.Remove(json.Length - 1, 1);//去掉最后一个逗号
            }
            json.Append("}");
            return json.ToString();
        }

        #endregion 获得相应的条件限制数据

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                //先删除数据再新增
                string strSQL = string.Format("DELETE FROM SHOOLAR_PROJECT_LIMIT WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                string strSQL_Zy = string.Format("DELETE FROM SHOOLAR_PROJECT_LIMIT_ZY WHERE SEQ_NO = '{0}' ", Get("seq_no"));
                if (ds.ExecuteTxtNonQuery(strSQL) < 0)
                    return "设置限制条件失败！";
                if (ds.ExecuteTxtNonQuery(strSQL_Zy) < 0)
                    return "设置限制条件中的专业表体失败！";
                var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_project_limit>("Shoolar_project_limitInsertTransaction");

                #region 综合考评总分排名

                int Limit_ComRank_Value = cod.ChangeInt(Post("Limit_ComRank_Value"));
                if (Limit_ComRank_Value != 0)
                {
                    Shoolar_project_limit head_Limit_ComRank = new Shoolar_project_limit();
                    head_Limit_ComRank.OID = Guid.NewGuid().ToString();
                    head_Limit_ComRank.SEQ_NO = Get("seq_no");
                    head_Limit_ComRank.LIMIT_TYPE = CValue.Limit_ComRank;//综合考评总分排名
                    head_Limit_ComRank.LIMIT_VALUE = Post("Limit_ComRank_Value");
                    head_Limit_ComRank.LIMIT_COMMENT = string.Format("综合考评总分排名：位于前{0}名", head_Limit_ComRank.LIMIT_VALUE);
                    inserttrcn.EntityList.Add(head_Limit_ComRank);
                }

                #endregion 综合考评总分排名

                #region 综合考评总分

                decimal Limit_ComScore_RankPer = cod.ChangeDecimal(Post("Limit_ComScore_RankPer"));
                decimal Limit_ComScore_Score = cod.ChangeDecimal(Post("Limit_ComScore_Score"));
                if (Limit_ComScore_RankPer != 0 || Limit_ComScore_Score != 0)
                {
                    Shoolar_project_limit head_Limit_ComScore = new Shoolar_project_limit();
                    head_Limit_ComScore.OID = Guid.NewGuid().ToString();
                    head_Limit_ComScore.SEQ_NO = Get("seq_no");
                    head_Limit_ComScore.LIMIT_TYPE = CValue.Limit_ComScore;//综合考评总分
                    head_Limit_ComScore.LIMIT_RANKPER = Math.Round(cod.ChangeDecimal(Post("Limit_ComScore_RankPer")), 1);
                    head_Limit_ComScore.LIMIT_SCORE = Math.Round(cod.ChangeDecimal(Post("Limit_ComScore_Score")), 1);
                    head_Limit_ComScore.LIMIT_COMMENT = string.Format(" 综合考评总分：位于前{0}%；分数大于{1}分", head_Limit_ComScore.LIMIT_RANKPER, head_Limit_ComScore.LIMIT_SCORE);
                    inserttrcn.EntityList.Add(head_Limit_ComScore);
                }

                #endregion 综合考评总分

                #region 操行能单项综合分

                decimal Limit_Conduct_RankPer = cod.ChangeDecimal(Post("Limit_Conduct_RankPer"));
                decimal Limit_Conduct_Score = cod.ChangeDecimal(Post("Limit_Conduct_Score"));
                if (Limit_Conduct_RankPer != 0 || Limit_Conduct_Score != 0)
                {
                    Shoolar_project_limit head_Limit_Conduct = new Shoolar_project_limit();
                    head_Limit_Conduct.OID = Guid.NewGuid().ToString();
                    head_Limit_Conduct.SEQ_NO = Get("seq_no");
                    head_Limit_Conduct.LIMIT_TYPE = CValue.Limit_Conduct;//操行能单项综合分
                    head_Limit_Conduct.LIMIT_RANKPER = Math.Round(cod.ChangeDecimal(Post("Limit_Conduct_RankPer")), 1);
                    head_Limit_Conduct.LIMIT_SCORE = Math.Round(cod.ChangeDecimal(Post("Limit_Conduct_Score")), 1);
                    head_Limit_Conduct.LIMIT_COMMENT = string.Format(" 操行能单项综合分：位于前{0}%；分数大于{1}分", head_Limit_Conduct.LIMIT_RANKPER, head_Limit_Conduct.LIMIT_SCORE);
                    inserttrcn.EntityList.Add(head_Limit_Conduct);
                }

                #endregion 操行能单项综合分

                #region 课程能单项综合分

                decimal Limit_Course_RankPer = cod.ChangeDecimal(Post("Limit_Course_RankPer"));
                decimal Limit_Course_Score = cod.ChangeDecimal(Post("Limit_Course_Score"));
                if (Limit_Course_RankPer != 0 || Limit_Course_Score != 0)
                {
                    Shoolar_project_limit head_Limit_Course = new Shoolar_project_limit();
                    head_Limit_Course.OID = Guid.NewGuid().ToString();
                    head_Limit_Course.SEQ_NO = Get("seq_no");
                    head_Limit_Course.LIMIT_TYPE = CValue.Limit_Course;//课程能单项综合分
                    head_Limit_Course.LIMIT_RANKPER = Math.Round(cod.ChangeDecimal(Post("Limit_Course_RankPer")), 1);
                    head_Limit_Course.LIMIT_SCORE = Math.Round(cod.ChangeDecimal(Post("Limit_Course_Score")), 1);
                    head_Limit_Course.LIMIT_COMMENT = string.Format(" 课程能单项综合分：位于前{0}%；分数大于{1}分", head_Limit_Course.LIMIT_RANKPER, head_Limit_Course.LIMIT_SCORE);
                    inserttrcn.EntityList.Add(head_Limit_Course);
                }

                #endregion 课程能单项综合分

                #region 体艺能单项综合分

                decimal Limit_BodyArt_RankPer = cod.ChangeDecimal(Post("Limit_BodyArt_RankPer"));
                decimal Limit_BodyArt_Score = cod.ChangeDecimal(Post("Limit_BodyArt_Score"));
                if (Limit_BodyArt_RankPer != 0 || Limit_BodyArt_Score != 0)
                {
                    Shoolar_project_limit head_Limit_BodyArt = new Shoolar_project_limit();
                    head_Limit_BodyArt.OID = Guid.NewGuid().ToString();
                    head_Limit_BodyArt.SEQ_NO = Get("seq_no");
                    head_Limit_BodyArt.LIMIT_TYPE = CValue.Limit_BodyArt;//体艺能单项综合分
                    head_Limit_BodyArt.LIMIT_RANKPER = Math.Round(cod.ChangeDecimal(Post("Limit_BodyArt_RankPer")), 1);
                    head_Limit_BodyArt.LIMIT_SCORE = Math.Round(cod.ChangeDecimal(Post("Limit_BodyArt_Score")), 1);
                    head_Limit_BodyArt.LIMIT_COMMENT = string.Format(" 体艺能单项综合分：位于前{0}%；分数大于{1}分", head_Limit_BodyArt.LIMIT_RANKPER, head_Limit_BodyArt.LIMIT_SCORE);
                    inserttrcn.EntityList.Add(head_Limit_BodyArt);
                }

                #endregion 体艺能单项综合分

                #region 职业技能单项综合分

                decimal Limit_JobSkill_RankPer = cod.ChangeDecimal(Post("Limit_JobSkill_RankPer"));
                decimal Limit_JobSkill_Score = cod.ChangeDecimal(Post("Limit_JobSkill_Score"));
                if (Limit_JobSkill_RankPer != 0 || Limit_JobSkill_Score != 0)
                {
                    Shoolar_project_limit head_Limit_JobSkill = new Shoolar_project_limit();
                    head_Limit_JobSkill.OID = Guid.NewGuid().ToString();
                    head_Limit_JobSkill.SEQ_NO = Get("seq_no");
                    head_Limit_JobSkill.LIMIT_TYPE = CValue.Limit_JobSkill;//职业技能单项综合分
                    head_Limit_JobSkill.LIMIT_RANKPER = Math.Round(cod.ChangeDecimal(Post("Limit_JobSkill_RankPer")), 1);
                    head_Limit_JobSkill.LIMIT_SCORE = Math.Round(cod.ChangeDecimal(Post("Limit_JobSkill_Score")), 1);
                    head_Limit_JobSkill.LIMIT_COMMENT = string.Format(" 职业技能单项综合分：位于前{0}%；分数大于{1}分", head_Limit_JobSkill.LIMIT_RANKPER, head_Limit_JobSkill.LIMIT_SCORE);
                    inserttrcn.EntityList.Add(head_Limit_JobSkill);
                }

                #endregion 职业技能单项综合分

                #region 操行、课程、体艺、职业技能四个单项综合分

                decimal Limit_Total_RankPer = cod.ChangeDecimal(Post("Limit_Total_RankPer"));
                if (Limit_Total_RankPer != 0)
                {
                    Shoolar_project_limit head_Limit_Total = new Shoolar_project_limit();
                    head_Limit_Total.OID = Guid.NewGuid().ToString();
                    head_Limit_Total.SEQ_NO = Get("seq_no");
                    head_Limit_Total.LIMIT_TYPE = CValue.Limit_Total;//操行、课程、体艺、职业技能四个单项综合分
                    head_Limit_Total.LIMIT_RANKPER = Math.Round(cod.ChangeDecimal(Post("Limit_Total_RankPer")), 1);
                    head_Limit_Total.LIMIT_COMMENT = string.Format("操行、课程、体艺、职业技能四个单项 综合分任一个在评选范围内位于前：{0}%", head_Limit_Total.LIMIT_RANKPER);
                    inserttrcn.EntityList.Add(head_Limit_Total);
                }

                #endregion 操行、课程、体艺、职业技能四个单项综合分

                #region 操行、课程、体艺、职业技能分项任三个前%,另一个可放宽至

                decimal Limit_Three_RankPer = cod.ChangeDecimal(Post("Limit_Three_RankPer"));
                decimal Limit_One_RankPer = cod.ChangeDecimal(Post("Limit_One_RankPer"));
                if (Limit_Three_RankPer != 0)
                {
                    Shoolar_project_limit head_Limit_Three_RankPer = new Shoolar_project_limit();
                    head_Limit_Three_RankPer.OID = Guid.NewGuid().ToString();
                    head_Limit_Three_RankPer.SEQ_NO = Get("seq_no");
                    head_Limit_Three_RankPer.LIMIT_TYPE = CValue.Limit_Three;//操行、课程、体艺、职业技能分项任三个前
                    head_Limit_Three_RankPer.LIMIT_RANKPER = Math.Round(cod.ChangeDecimal(Post("Limit_Three_RankPer")), 1);
                    head_Limit_Three_RankPer.LIMIT_COMMENT = string.Format("操行、课程、体艺、职业技能分项任三个前：{0}%，另一个可放宽至：{1}%", head_Limit_Three_RankPer.LIMIT_RANKPER, Limit_One_RankPer);
                    inserttrcn.EntityList.Add(head_Limit_Three_RankPer);
                }

                if (Limit_One_RankPer != 0)
                {
                    Shoolar_project_limit head_Limit_One_RankPer = new Shoolar_project_limit();
                    head_Limit_One_RankPer.OID = Guid.NewGuid().ToString();
                    head_Limit_One_RankPer.SEQ_NO = Get("seq_no");
                    head_Limit_One_RankPer.LIMIT_TYPE = CValue.Limit_One;//操行、课程、体艺、职业技能分项任三个前，另一个可放宽至
                    head_Limit_One_RankPer.LIMIT_RANKPER = Math.Round(cod.ChangeDecimal(Post("Limit_One_RankPer")), 1);
                    head_Limit_One_RankPer.LIMIT_COMMENT = string.Format("操行、课程、体艺、职业技能分项任三个前{0}%，另一个可放宽至：{1}%", Limit_Three_RankPer, head_Limit_One_RankPer.LIMIT_RANKPER);
                    inserttrcn.EntityList.Add(head_Limit_One_RankPer);
                }

                #endregion 操行、课程、体艺、职业技能分项任三个前%,另一个可放宽至

                #region 年级

                if (!string.IsNullOrEmpty(Post("Limit_Grade_Value")))
                {
                    Shoolar_project_limit head_Limit_Grade = new Shoolar_project_limit();
                    head_Limit_Grade.OID = Guid.NewGuid().ToString();
                    head_Limit_Grade.SEQ_NO = Get("seq_no");
                    head_Limit_Grade.LIMIT_TYPE = CValue.Limit_Grade;//年级
                    head_Limit_Grade.LIMIT_VALUE = Post("Limit_Grade_Value");
                    head_Limit_Grade.LIMIT_COMMENT = string.Format("年级：{0}（含）以上", cod.GetDDLTextByValue("ddl_grade", head_Limit_Grade.LIMIT_VALUE));
                    inserttrcn.EntityList.Add(head_Limit_Grade);
                }

                #endregion 年级

                #region 学生类型

                if (!string.IsNullOrEmpty(Post("hidStudentType")))
                {
                    Shoolar_project_limit head_Limit_Student = new Shoolar_project_limit();
                    head_Limit_Student.OID = Guid.NewGuid().ToString();
                    head_Limit_Student.SEQ_NO = Get("seq_no");
                    head_Limit_Student.LIMIT_TYPE = CValue.Limit_Student;//学生类型
                    head_Limit_Student.LIMIT_VALUE = Post("hidStudentType");

                    head_Limit_Student.LIMIT_COMMENT = string.Format("学生类型：{0}", GetStuTypeTxt(head_Limit_Student.LIMIT_VALUE));
                    inserttrcn.EntityList.Add(head_Limit_Student);
                }

                #endregion 学生类型

                #region 困难生等级

                if (!string.IsNullOrEmpty(Post("hidKN")))
                {
                    Shoolar_project_limit head_Limit_KN = new Shoolar_project_limit();
                    head_Limit_KN.OID = Guid.NewGuid().ToString();
                    head_Limit_KN.SEQ_NO = Get("seq_no");
                    head_Limit_KN.LIMIT_TYPE = CValue.Limit_KN;//困难生等级
                    head_Limit_KN.LIMIT_VALUE = Post("hidKN");
                    head_Limit_KN.LIMIT_COMMENT = string.Format("困难生等级：{0}", GetKNTypeTxt(head_Limit_KN.LIMIT_VALUE));
                    inserttrcn.EntityList.Add(head_Limit_KN);
                }

                #endregion 困难生等级

                if (!inserttrcn.Commit())
                    return "设置限制条件失败！";

                #region 专业

                Dictionary<string, string> dicZy = GetZy();
                if (dicZy != null)
                {
                    var inserttrcn_zy = ImplementFactory.GetInsertTransaction<Shoolar_project_limit_zy>("Shoolar_project_limit_zyInsertTransaction");
                    foreach (KeyValuePair<string, string> zy in dicZy)
                    {
                        Shoolar_project_limit_zy head_Limit_Zy = new Shoolar_project_limit_zy();
                        head_Limit_Zy.OID = Guid.NewGuid().ToString();
                        head_Limit_Zy.SEQ_NO = Get("seq_no");
                        head_Limit_Zy.ZY_ID = zy.Key;
                        head_Limit_Zy.ZY_NAME = zy.Value;
                        inserttrcn_zy.EntityList.Add(head_Limit_Zy);
                    }
                    inserttrcn_zy.Commit();
                }

                #endregion 专业

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保存申请限制条件出错：" + ex.ToString());
                return "信息发送失败！";
            }
        }

        /// <summary>
        /// 获得所选专业
        /// </summary>
        /// <returns></returns>
        private Dictionary<string, string> GetZy()
        {
            if (string.IsNullOrEmpty(Post("hidAllZy")))
                return null;

            #region 排除重复专业

            if (string.IsNullOrEmpty(Post("hidAllZy")))
                return null;
            string strSel = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(Post("hidAllZy"));

            #endregion 排除重复专业

            #region 专业

            Dictionary<string, string> resultIDic = new Dictionary<string, string>();
            string strSQL = string.Format("SELECT zy, mc FROM t_jx_zy WHERE zy IN ({0}) ", strSel);
            DataTable dt = ds.ExecuteTxtDataTable(strSQL);
            if (dt == null)
                return null;
            foreach (DataRow row in dt.Rows)
            {
                if (row == null)
                    continue;
                resultIDic.Add(row["zy"].ToString(), row["mc"].ToString());
            }
            return resultIDic;

            #endregion 专业
        }

        #endregion 保存数据

        #region 通过选择的学生类型转名称

        /// <summary>
        /// 通过选择的学生类型转名称
        /// </summary>
        /// <param name="strStuType"></param>
        /// <returns></returns>
        private string GetStuTypeTxt(string strStuType)
        {
            string strTxt = string.Empty;
            string[] arrType = strStuType.Split(new char[] { ',' });
            foreach (string str in arrType)
            {
                if (string.IsNullOrEmpty(str))
                    continue;
                strTxt += cod.GetDDLTextByValue("ddl_ua_stu_type", str) + "，";
            }
            if (strTxt.Length > 0)
                strTxt = strTxt.TrimEnd('，');
            return strTxt;
        }

        #endregion 通过选择的学生类型转名称

        #region 通过选择的困难生类型转名称

        /// <summary>
        /// 通过选择的困难生类型转名称
        /// </summary>
        /// <param name="strStuType"></param>
        /// <returns></returns>
        private string GetKNTypeTxt(string strStuType)
        {
            string strTxt = string.Empty;
            string[] arrType = strStuType.Split(new char[] { ',' });
            foreach (string str in arrType)
            {
                if (string.IsNullOrEmpty(str))
                    continue;
                strTxt += cod.GetDDLTextByValue("ddl_dst_level", str) + "，";
            }
            if (strTxt.Length > 0)
                strTxt = strTxt.TrimEnd('，');
            return strTxt;
        }

        #endregion 通过选择的困难生类型转名称
    }
}