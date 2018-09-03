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
using serverservice;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectManage
{
    public partial class List : ListBaseLoad<Shoolar_project_head>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        public override string Doc_type { get { return CValue.DOC_TYPE_BDM02; } }

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

        protected override SelectTransaction<Shoolar_project_head> GetSelectTransaction()
        {
            if (!string.IsNullOrEmpty(Get("from_page")))
            {
                #region 过滤条件来源于“奖助管理 >> 奖助申请”

                if (Get("from_page").Equals("pro_apply"))//过滤条件来源于“奖助管理 >> 奖助申请”
                {
                    //过滤项目开始时间、结束时间在当前时间之内
                    param.Add(string.Format(" APPLY_START <= '{0}' ", GetDateShortFormater()), "");
                    param.Add(string.Format(" APPLY_END >= '{0}' ", GetDateShortFormater()), "");
                    //并且属于当前学年
                    param.Add("APPLY_YEAR", sch_info.CURRENT_YEAR);
                    //排除线下项目
                    param.Add(string.Format("PROJECT_CLASS != 'OUTLINE' "), string.Empty);
                    //排除已经申请的项目
                    param.Add(string.Format("SEQ_NO NOT IN (SELECT PROJECT_SEQ_NO FROM SHOOLAR_APPLY_HEAD WHERE STU_NUMBER = '{0}') ", user.User_Id), string.Empty);
                    //20171015 ZZ 加入过滤：根据学生类型显示可以申请的奖助类型（表10）
                    if (!string.IsNullOrEmpty(user.Stu_Type))
                    {
                        if (user.Stu_Type.Equals("B"))//本科生
                        {
                            param.Add(string.Format("PROJECT_TYPE IN ('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}') ", "COUNTRY_B", "COUNTRY_ENCOUR", "AREA_GOV", "SCHOOL_MODEL", "SCHOOL_GOOD", "SCHOOL_SINGLE", "SOCIETY_OFFER", "COUNTRY_FIRST", "COUNTRY_SECOND"), string.Empty);
                        }
                        else if (user.Stu_Type.Equals("Y"))//研究生
                        {
                            param.Add(string.Format("PROJECT_TYPE IN ('{0}','{1}','{2}','{3}') ", "COUNTRY_YP", "COUNTRY_STUDY", "SOCIETY_NOCOUNTRY", "SCHOOL_NOTCOUNTRY"), string.Empty);
                        }
                        else//没有学生类型就不显示
                        {
                            param.Add(string.Format("PROJECT_TYPE = '' "), string.Empty);
                        }
                    }
                }

                #endregion 过滤条件来源于“奖助管理 >> 奖助申请”

                #region 过滤条件来源于“奖助管理 >> 信息核对 >> 基础设置”

                else if (Get("from_page").Equals("check_basic"))//过滤条件来源于“奖助管理 >> 信息核对 >> 基础设置”
                {
                    //查询只有过了申请日期的奖助数据
                    param.Add(string.Format("APPLY_END < '{0}' ", GetDateShortFormater()), "");
                    //zz 20180312 屏蔽：因为线下的项目，有些核对需要在线上做
                    ////排除线下项目
                    //param.Add(string.Format("PROJECT_CLASS != 'OUTLINE' "), string.Empty);
                }

                #endregion 过滤条件来源于“奖助管理 >> 信息核对 >> 基础设置”
            }
            return ImplementFactory.GetSelectTransaction<Shoolar_project_head>("Shoolar_project_headSelectTransaction", param);
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

                        case "getnotice"://获得公告信息
                            Response.Write(GetNotice());
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
            if (!string.IsNullOrEmpty(Post("APPLY_YEAR")))
                where += string.Format(" AND APPLY_YEAR = '{0}' ", Post("APPLY_YEAR"));
            if (!string.IsNullOrEmpty(Post("PROJECT_CLASS")))
                where += string.Format(" AND PROJECT_CLASS = '{0}' ", Post("PROJECT_CLASS"));
            if (!string.IsNullOrEmpty(Post("PROJECT_TYPE")))
                where += string.Format(" AND PROJECT_TYPE = '{0}' ", Post("PROJECT_TYPE"));
            if (!string.IsNullOrEmpty(Post("PROJECT_NAME")))
                where += string.Format(" AND PROJECT_NAME LIKE '%{0}%' ", Post("PROJECT_NAME"));
            if (!string.IsNullOrEmpty(Post("PROJECT_SEQ_NO")))
                where += string.Format(" AND SEQ_NO = '{0}' ", Post("PROJECT_SEQ_NO"));
            return where;
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Shoolar_project_head>.NameValue> GetValue(Shoolar_project_head entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "PROJECT_CLASS", Value = entity.PROJECT_CLASS };
            yield return new NameValue() { Name = "PROJECT_CLASS_NAME", Value = cod.GetDDLTextByValue("ddl_jz_project_class", entity.PROJECT_CLASS) };
            yield return new NameValue() { Name = "PROJECT_TYPE", Value = entity.PROJECT_TYPE };
            yield return new NameValue() { Name = "PROJECT_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_jz_project_type", entity.PROJECT_TYPE) };
            yield return new NameValue() { Name = "PROJECT_NAME", Value = entity.PROJECT_NAME };
            yield return new NameValue() { Name = "PROJECT_MONEY", Value = entity.PROJECT_MONEY.ToString() };
            yield return new NameValue() { Name = "PROJECT_DEPARTMENT", Value = entity.PROJECT_DEPARTMENT };
            yield return new NameValue() { Name = "PROJECT_REMARK", Value = entity.PROJECT_REMARK };
            yield return new NameValue() { Name = "APPLY_START", Value = entity.APPLY_START };
            yield return new NameValue() { Name = "APPLY_END", Value = entity.APPLY_END };
            yield return new NameValue() { Name = "APPLY_YEAR", Value = entity.APPLY_YEAR };
            yield return new NameValue() { Name = "APPLY_YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.APPLY_YEAR) };
            yield return new NameValue() { Name = "SCORE_YEAR", Value = entity.SCORE_YEAR };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            yield return new NameValue() { Name = "NOTICE_ID", Value = entity.NOTICE_ID };
            //项目信息核对
            yield return new NameValue() { Name = "CHECK_START", Value = entity.CHECK_START };
            yield return new NameValue() { Name = "CHECK_END", Value = entity.CHECK_END };
            yield return new NameValue() { Name = "CHECK_IS_SEND", Value = cod.GetDDLTextByValue("ddl_yes_no", entity.CHECK_IS_SEND) };
            yield return new NameValue() { Name = "CHECK_MSG_ID", Value = entity.CHECK_MSG_ID };
            yield return new NameValue() { Name = "CHECK_OP_CODE", Value = entity.CHECK_OP_CODE };
            yield return new NameValue() { Name = "CHECK_OP_NAME", Value = entity.CHECK_OP_NAME };
            yield return new NameValue() { Name = "CHECK_OP_TIME", Value = entity.CHECK_OP_TIME };
            yield return new NameValue() { Name = "CHECK_NOTICE_ID", Value = entity.CHECK_NOTICE_ID };
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
                Shoolar_project_head head = new Shoolar_project_head();
                head.OID = Get("id");
                ds.RetrieveObject(head);
                string strDelNotice = string.Format("DELETE FROM NOTICE_INFO WHERE OID = '{0}' ", head.NOTICE_ID);
                var transaction = ImplementFactory.GetDeleteTransaction<Shoolar_project_head>("Shoolar_project_headDeleteTransaction");
                transaction.EntityList.Add(head);

                //已经改写了Commit方法，提交删除操作时会同时把：表体对应数据删除
                if (transaction.Commit())
                {
                    if (head.PROJECT_CLASS.Equals("LIFE"))
                    {
                        string strDelApplyChk = string.Format("DELETE FROM SHOOLAR_APPLY_CHECK WHERE SEQ_NO IN(SELECT SEQ_NO FROM SHOOLAR_APPLY_HEAD WHERE PROJECT_SEQ_NO = '{0}')", head.SEQ_NO);
                        ds.ExecuteTxtNonQuery(strDelApplyChk);
                        string strDelApplyHead = string.Format("DELETE FROM SHOOLAR_APPLY_HEAD WHERE PROJECT_SEQ_NO = '{0}' ", head.SEQ_NO);
                        ds.ExecuteTxtNonQuery(strDelApplyHead);
                    }

                    //删除对应公告
                    ds.ExecuteTxtNonQuery(strDelNotice);
                    return string.Empty;
                }

                return "删除失败！";
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助项目设置，删除，出错：" + ex.ToString());
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
            Shoolar_project_head head = new Shoolar_project_head();
            head.OID = strOID;
            ds.RetrieveObject(head);
            DateTime dtAPPLY_START = Convert.ToDateTime(head.APPLY_START);
            DateTime dtSys = Convert.ToDateTime(GetDateShortFormater());
            if (dtAPPLY_START < dtSys)//申请开始日期 小于 系统当前日期
            {
                //判断是否有人已经开始申报
                int nCount = cod.ChangeInt(ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) AS APPLY_NUM FROM SHOOLAR_APPLY_HEAD WHERE PROJECT_SEQ_NO = '{0}' ", head.SEQ_NO)).ToString());
                if (nCount > 0)
                    return "该奖助项目已经在申请阶段，无法删除！";
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
            Shoolar_project_head head = new Shoolar_project_head();
            if (string.IsNullOrEmpty(Post("hidOid")))//新增
            {
                head.OID = Guid.NewGuid().ToString();
                head.SEQ_NO = GetSeq_no();
                GetPageValue(head);
                var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_project_head>("Shoolar_project_headInsertTransaction");
                inserttrcn.EntityList.Add(head);
                result = inserttrcn.Commit();
            }
            else//修改
            {
                head.OID = Post("hidOid");
                ds.RetrieveObject(head);
                GetPageValue(head);
                var updatetrcn = ImplementFactory.GetUpdateTransaction<Shoolar_project_head>("Shoolar_project_headUpdateTransaction", user.User_Name);
                result = updatetrcn.Commit(head);
                if (result)
                {
                    ProjectSettingHandleClass.getInstance().UpdateRelationFunction(head.SEQ_NO);
                }
            }

            if (result)
            {
                if (head.PROJECT_CLASS.Equals("LIFE"))
                {
                    if (string.IsNullOrEmpty(Post("hidOid")))//新增
                        InsertIntoLifeApplyData(head, Post("hidStudentType"));
                    else
                        UpdateLifeApplyData(head);
                }

                return head.SEQ_NO;//保存成功 返回单据编号
            }
            else
                return string.Empty;
        }

        #region 获得页面数据

        /// <summary>
        /// 获得页面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetPageValue(Shoolar_project_head model)
        {
            model.PROJECT_CLASS = Post("PROJECT_CLASS");
            model.PROJECT_TYPE = Post("PROJECT_TYPE");
            model.PROJECT_NAME = Post("PROJECT_NAME");
            model.PROJECT_MONEY = cod.ChangeDecimal(Post("PROJECT_MONEY"));
            model.PROJECT_DEPARTMENT = Post("PROJECT_DEPARTMENT");
            model.APPLY_YEAR = Post("APPLY_YEAR");
            model.SCORE_YEAR = Post("SCORE_YEAR");
            model.APPLY_START = Post("APPLY_START");
            model.APPLY_END = Post("APPLY_END");
            model.PROJECT_REMARK = Post("PROJECT_REMARK");
            model.OP_TIME = GetDateLongFormater();
            model.OP_CODE = user.User_Id;
            model.OP_NAME = user.User_Name;
        }

        #endregion 获得页面数据

        #endregion 保存方法

        #region 生活补贴类

        /// <summary>
        /// 插入生活补贴类
        /// </summary>
        /// <param name="project"></param>
        /// <param name="strStuType"></param>
        private void InsertIntoLifeApplyData(Shoolar_project_head project, string strStuType)
        {
            if (strStuType.Contains("Y"))
                strStuType += ",P";
            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add(string.Format(" STUTYPE IN ({0}) ", ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(strStuType)), string.Empty);
            List<Basic_stu_info> stuList = StuHandleClass.getInstance().GetStuInfoArray(param);
            if (stuList == null)
                return;

            foreach (Basic_stu_info stu in stuList)
            {
                if (stu == null)
                    continue;

                //删除重复数据，再插入
                string strDelHead = string.Format("DELETE FROM SHOOLAR_APPLY_HEAD WHERE PROJECT_SEQ_NO = '{0}' AND STU_NUMBER = '{1}' ", project.SEQ_NO, stu.NUMBER);
                ds.ExecuteTxtNonQuery(strDelHead);
                Shoolar_apply_head head = InsertIntoApplyHead(project, stu);
                //删除重复数据，再插入
                string strDelChk = string.Format("DELETE FROM SHOOLAR_APPLY_CHECK WHERE SEQ_NO = '{0}' ", head.SEQ_NO);
                ds.ExecuteTxtNonQuery(strDelChk);
                ProjectCheckHandleClass.getInstance().InsertIntoCheckInfo(head.SEQ_NO, head.STU_IDCARDNO, head.STU_BANKCODE);
            }
        }

        /// <summary>
        ///更新生活补贴类
        /// </summary>
        /// <param name="project"></param>
        private void UpdateLifeApplyData(Shoolar_project_head project)
        {
            StringBuilder strSQL = new StringBuilder();
            strSQL.Append("UPDATE SHOOLAR_APPLY_HEAD ");
            strSQL.Append("SET ");
            strSQL.AppendFormat("PROJECT_NAME = '{0}', ", project.PROJECT_NAME);
            strSQL.AppendFormat("PROJECT_YEAR = '{0}',  ", project.APPLY_YEAR);
            strSQL.AppendFormat("PROJECT_MONEY = '{0}' ", project.PROJECT_MONEY);
            strSQL.AppendFormat("WHERE PROJECT_SEQ_NO = '{0}' ", project.SEQ_NO);
            ds.ExecuteTxtNonQuery(strSQL.ToString());
        }

        #region 往奖助申报表中插入数据

        /// <summary>
        /// 往奖助申报表中插入数据
        /// </summary>
        /// <param name="project"></param>
        private Shoolar_apply_head InsertIntoApplyHead(Shoolar_project_head project, Basic_stu_info stu)
        {
            Shoolar_apply_head head = new Shoolar_apply_head();
            head.OID = Guid.NewGuid().ToString();
            head.SEQ_NO = BusDataDeclareTransaction.getInstance().GetSeq_no(CValue.DOC_TYPE_BDM03);
            head.RET_CHANNEL = CValue.RET_CHANNEL_D4000;
            head.CHK_STATUS = CValue.CHK_STATUS_N;
            head.DOC_TYPE = CValue.DOC_TYPE_BDM03;
            head.CHK_TIME = GetDateLongFormater();
            head.DECL_TIME = GetDateLongFormater();
            head.DECLARE_TYPE = CValue.DECLARE_TYPE_D;

            #region 项目信息

            head.PROJECT_SEQ_NO = project.SEQ_NO;
            head.PROJECT_CLASS = project.PROJECT_CLASS;
            head.PROJECT_TYPE = project.PROJECT_TYPE;
            head.PROJECT_YEAR = project.APPLY_YEAR;
            head.PROJECT_NAME = project.PROJECT_NAME;
            head.PROJECT_MONEY = project.PROJECT_MONEY;

            #endregion 项目信息

            #region 保存学生信息

            //学生信息
            head.STU_NUMBER = stu.NUMBER;
            head.STU_NAME = stu.NAME;
            //学生信息
            if (stu.STUTYPE.Equals(CValue.USER_STUTYPE_B))
                head.STU_TYPE = CValue.USER_STUTYPE_B;
            else
                head.STU_TYPE = CValue.USER_STUTYPE_Y;
            head.XY = stu.COLLEGE;
            head.ZY = stu.MAJOR;
            head.GRADE = stu.EDULENTH;
            head.CLASS_CODE = stu.CLASS;
            head.STU_IDCARDNO = stu.IDCARDNO;
            head.STU_BANKCODE = StuHandleClass.getInstance().ByStuNoGetBankCode(head.STU_NUMBER);

            #endregion 保存学生信息

            ds.UpdateObject(head);
            return head;
        }

        #endregion 往奖助申报表中插入数据

        #endregion 生活补贴类

        #region 获得公告信息

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
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助项目设置，获得公告信息，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 获得公告信息
    }
}