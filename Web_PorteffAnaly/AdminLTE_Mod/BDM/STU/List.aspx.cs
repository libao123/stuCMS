using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.STU
{
    public partial class List : ListBaseLoad<Basic_stu_info>
    {
        #region 初始化

        private comdata cod = new comdata();
        public bool IsShowBtn = false;//ZZ 20171026 新增：是否显示按钮：校级角色显示

        protected override string input_code_column
        {
            get { return "NUMBER"; }
        }

        protected override string class_code_column
        {
            get { return "CLASS"; }
        }

        protected override string xy_code_column
        {
            get { return "COLLEGE"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Basic_stu_info> GetSelectTransaction()
        {
            if (!string.IsNullOrEmpty(Get("page_from")))
            {
                if (Get("page_from").ToString().Equals("nosubmit"))/// 页面来源：未提交修改学生信息
                {
                    param.Add(string.Format("NUMBER NOT IN (SELECT NUMBER FROM BASIC_STU_INFO_MODI)"), string.Empty);
                }
            }
            return ImplementFactory.GetSelectTransaction<Basic_stu_info>("Basic_stu_infoSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("NUMBER")))
                where += string.Format(" AND NUMBER LIKE '%{0}%' ", Post("NUMBER"));
            if (!string.IsNullOrEmpty(Post("NAME")))
                where += string.Format(" AND NAME LIKE '%{0}%' ", Post("NAME"));
            if (!string.IsNullOrEmpty(Post("IDCARDNO")))
                where += string.Format(" AND IDCARDNO LIKE '%{0}%' ", Post("IDCARDNO"));
            if (!string.IsNullOrEmpty(Post("COLLEGE")))
                where += string.Format(" AND COLLEGE = '{0}' ", Post("COLLEGE"));
            if (!string.IsNullOrEmpty(Post("MAJOR")))
                where += string.Format(" AND MAJOR = '{0}' ", Post("MAJOR"));
            if (!string.IsNullOrEmpty(Post("EDULENTH")))
                where += string.Format(" AND EDULENTH = '{0}' ", Post("EDULENTH"));
            if (!string.IsNullOrEmpty(Post("CLASS")))
                where += string.Format(" AND CLASS = '{0}' ", Post("CLASS"));
            if (!string.IsNullOrEmpty(Post("STUTYPE")))
                where += string.Format(" AND STUTYPE = '{0}' ", Post("STUTYPE"));
            if (!string.IsNullOrEmpty(Post("REGISTER")))
                where += string.Format(" AND REGISTER = '{0}' ", Post("REGISTER"));

            return where;
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
                        case "save"://删除操作
                            Response.Write(SaveData());
                            Response.End();
                            break;

                        case "chkem":
                            Response.Write(CheckEmail());
                            Response.End();
                            break;
                    }
                }
                if (user.User_Role.Equals("X") || user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))
                    IsShowBtn = true;
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Basic_stu_info entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "NUMBER", Value = entity.NUMBER };
            yield return new NameValue() { Name = "NAME", Value = entity.NAME };
            yield return new NameValue() { Name = "CLASS", Value = entity.CLASS };
            yield return new NameValue() { Name = "CLASS_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS) };
            yield return new NameValue() { Name = "SEX", Value = entity.SEX };
            yield return new NameValue() { Name = "SEX_NAME", Value = cod.GetDDLTextByValue("ddl_xb", entity.SEX) };
            yield return new NameValue() { Name = "EDULENTH", Value = entity.EDULENTH };
            yield return new NameValue() { Name = "COLLEGE", Value = entity.COLLEGE };
            yield return new NameValue() { Name = "COLLEGE_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.COLLEGE) };
            yield return new NameValue() { Name = "MAJOR", Value = entity.MAJOR };
            yield return new NameValue() { Name = "MAJOR_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.MAJOR) };
            yield return new NameValue() { Name = "NATION", Value = entity.NATION };
            yield return new NameValue() { Name = "NATION_NAME", Value = cod.GetDDLTextByValue("ddl_mz", entity.NATION) };
            yield return new NameValue() { Name = "POLISTATUS", Value = entity.POLISTATUS };
            yield return new NameValue() { Name = "POLISTATUS_NAME", Value = cod.GetDDLTextByValue("ddl_zzmm", entity.POLISTATUS) };
            yield return new NameValue() { Name = "STUTYPE", Value = entity.STUTYPE };
            yield return new NameValue() { Name = "STUTYPE_NAME", Value = cod.GetDDLTextByValue("ddl_basic_stu_type", entity.STUTYPE) };
            yield return new NameValue() { Name = "ENROLLING", Value = entity.ENROLLING };
            yield return new NameValue() { Name = "US_NAME", Value = entity.US_NAME };
            yield return new NameValue() { Name = "HEIGTH", Value = entity.HEIGTH };
            yield return new NameValue() { Name = "WEIGTH", Value = entity.WEIGTH };
            yield return new NameValue() { Name = "GENIUS", Value = entity.GENIUS };
            yield return new NameValue() { Name = "HEALTH", Value = entity.HEALTH };
            yield return new NameValue() { Name = "TRAIN", Value = entity.TRAIN };
            yield return new NameValue() { Name = "STUWORK", Value = entity.STUWORK };
            yield return new NameValue() { Name = "CULTIVATION", Value = entity.CULTIVATION };
            yield return new NameValue() { Name = "COUN", Value = GetCOUN(entity.CLASS) };
            yield return new NameValue() { Name = "IDCARDNO", Value = entity.IDCARDNO };
            yield return new NameValue() { Name = "EMAIL", Value = entity.EMAIL.ToString() };
            yield return new NameValue() { Name = "QQNUM", Value = entity.QQNUM.ToString() };
            yield return new NameValue() { Name = "GARDE", Value = entity.GARDE };
            yield return new NameValue() { Name = "IDCARDNO", Value = entity.IDCARDNO };
            yield return new NameValue() { Name = "ADDRESS", Value = entity.ADDRESS };
            yield return new NameValue() { Name = "REGISTPLACE", Value = entity.REGISTPLACE };
            yield return new NameValue() { Name = "CANDIDATE", Value = entity.CANDIDATE };
            yield return new NameValue() { Name = "SYSTEM", Value = entity.SYSTEM };
            yield return new NameValue() { Name = "REGISTER", Value = entity.REGISTER };
            yield return new NameValue() { Name = "REGISTER_NAME", Value = cod.GetDDLTextByValue("ddl_xjzt", entity.REGISTER) };
            yield return new NameValue() { Name = "DIFFDATE", Value = entity.DIFFDATE };
            yield return new NameValue() { Name = "RICE_CARD", Value = GetRiceCard(entity.NUMBER) };
        }

        /// <summary>
        /// 获得带班辅导员姓名
        /// </summary>
        /// <param name="CLASS"></param>
        /// <returns></returns>
        private string GetCOUN(string CLASS)
        {
            string COUN = ComHandleClass.getInstance().ByClassCodeGetCounName(CLASS);
            if (string.IsNullOrWhiteSpace(COUN))
                return string.Empty;
            return COUN;
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除主表数据并且把子表数据也删除
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            if (string.IsNullOrEmpty(Get("id"))) return "主键为空,不允许删除操作";

            var model = new Basic_stu_info();
            model.OID = Get("id");
            ds.RetrieveObject(model);

            var transaction = ImplementFactory.GetDeleteTransaction<Basic_stu_info>("Basic_stu_infoDeleteTransaction");
            transaction.EntityList.Add(model);
            if (transaction.Commit())
                return "";
            return "删除失败！";
        }

        #endregion 删除数据

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                Basic_stu_info head = new Basic_stu_info();
                if (string.IsNullOrEmpty(Post("OID")))
                {
                    head.OID = Guid.NewGuid().ToString();
                    head.SEQ_NO = BusDataDeclareTransaction.getInstance().GetSeq_no("STU01");
                    LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "学生基础信息管理", CValue.LOG_ACTION_TYPE_3, CValue.LOG_RECORD_TYPE_1, string.Format("新增学生"), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                else
                {
                    head.OID = Post("OID");
                }
                ds.RetrieveObject(head);
                head.NUMBER = Post("NUMBER");
                head.NAME = Post("NAME");
                head.SEX = Post("SEX");
                head.OP_NAME = user.User_Name;
                head.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                head.GARDE = Post("GARDE");
                head.EDULENTH = Post("EDULENTH");
                head.COLLEGE = Post("COLLEGE");
                head.POLISTATUS = Post("POLISTATUS");
                head.MAJOR = Post("MAJOR");
                head.NATION = Post("NATION");
                head.CLASS = Post("CLASS");
                head.IDCARDNO = Post("IDCARDNO");
                head.US_NAME = Post("US_NAME");
                head.HEIGTH = Post("HEIGTH");
                head.WEIGTH = Post("WEIGTH");
                head.GENIUS = Post("GENIUS");
                head.HEALTH = Post("HEALTH");
                head.TRAIN = Post("TRAIN");
                head.STUWORK = Post("STUWORK");
                head.CANDIDATE = Post("CANDIDATE");
                head.ENROLLING = Post("ENROLLING");
                head.CULTIVATION = Post("CULTIVATION");
                head.COUN = Post("COUN");
                head.EMAIL = Post("EMAIL");
                head.QQNUM = Post("QQNUM");
                head.ADDRESS = string.Format("{0}|{1}|{2}|{3}", Post("ADD_PROVINCE"), Post("ADD_CITY"), Post("ADD_COUNTY"), Post("ADD_STREET"));
                head.CANDIDATE = Post("CANDIDATE");
                head.SYSTEM = Post("SYSTEM");
                head.STUTYPE = Post("STUTYPE");
                head.REGISTER = Post("REGISTER");
                head.DIFFDATE = Post("DIFFDATE");
                head.MOBILENUM = Post("MOBILENUM");
                ds.UpdateObject(head);
                if (string.IsNullOrEmpty(Post("OID")))
                {
                    LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "学生基础信息管理", CValue.LOG_ACTION_TYPE_3, CValue.LOG_RECORD_TYPE_1, string.Format("新增学生信息：学号{0}，姓名{1}", head.NUMBER, head.NAME), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                else
                {
                    LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "学生基础信息管理", CValue.LOG_ACTION_TYPE_4, CValue.LOG_RECORD_TYPE_1, string.Format("修改学生信息：学号{0}，姓名{1}", head.NUMBER, head.NAME), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                InsertOrUpUser(head);
                //同步业务数据
                ComHandleClass.getInstance().UpdateRelationFunction(head.NUMBER);
                return head.OID;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "新增/修改学生信息出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 插入/更新用户

        /// <summary>
        /// 插入/更新用户
        /// </summary>
        /// <param name="model"></param>
        private void InsertOrUpUser(Basic_stu_info model)
        {
            try
            {
                if (ComHandleClass.getInstance().IsExistUaUser(model.NUMBER))//存在，更新
                {
                    Ua_user Ua_user = new Ua_user();
                    Ua_user.USER_ID = model.NUMBER;
                    ds.RetrieveObject(Ua_user);
                    Ua_user.USER_NAME = model.NAME;
                    Ua_user.XY_CODE = model.COLLEGE;
                    Ua_user.STU_TYPE = model.STUTYPE;
                    ds.UpdateObject(Ua_user);
                    LogDBHandleClass.getInstance().LogOperation(Ua_user.USER_ID, "用户信息管理", CValue.LOG_ACTION_TYPE_4, CValue.LOG_RECORD_TYPE_1, string.Format("修改用户信息：用户{0}，姓名{1}", Ua_user.USER_ID, Ua_user.USER_NAME), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                else//插入
                {
                    Ua_user Ua_user = new Ua_user();
                    Ua_user.USER_ID = model.NUMBER;
                    ds.RetrieveObject(Ua_user);
                    Ua_user.USER_NAME = model.NAME;
                    Ua_user.XY_CODE = model.COLLEGE;
                    Ua_user.USER_TYPE = "S";//S学生;T老师
                    Ua_user.STU_TYPE = model.STUTYPE;//学生类型：B本科生  Y研究生 （研究生包括 硕士研究生/博士研究生）
                    //身份证
                    string strIDCARDNO = model.IDCARDNO;
                    if (strIDCARDNO.Length >= 6)
                    {
                        Ua_user.LOGIN_PW = strIDCARDNO.Substring(strIDCARDNO.Length - 6, 6);//取身份证后6位
                    }
                    else
                    {
                        Ua_user.LOGIN_PW = ConfigurationManager.AppSettings["InitPassword"]; ;//初始密码
                    }
                    Ua_user.USER_ROLE = "S";//用户角色分配
                    Ua_user.IS_ASSISTANT = "N";//是否是辅导员
                    Ua_user.CREATE_TIME = GetDateLongFormater();
                    Ua_user.CREATE_CODE = user.User_Id;
                    Ua_user.CREATE_NAME = user.User_Name;
                    ds.UpdateObject(Ua_user);
                    LogDBHandleClass.getInstance().LogOperation(Ua_user.USER_ID, "用户信息管理", CValue.LOG_ACTION_TYPE_3, CValue.LOG_RECORD_TYPE_1, string.Format("新增用户信息：用户{0}，姓名{1}", Ua_user.USER_ID, Ua_user.USER_NAME), user.User_Id, user.User_Name, user.UserLoginIP);
                }
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "更新学生信息同步更新用户信息，失败：" + ex.ToString());
            }
        }

        #endregion 插入/更新用户

        #region 判断：邮箱格式

        /// <summary>
        /// 判断：邮箱格式
        /// </summary>
        /// <returns></returns>
        private string CheckEmail()
        {
            #region 校验录入的邮箱格式是否符合规范

            System.Text.RegularExpressions.Regex regexp = new System.Text.RegularExpressions.Regex(@"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");

            if (!regexp.IsMatch(Request.QueryString["idno"]))
                return "输入的邮箱格式不符合规范，请重新录入！";

            return "";

            #endregion 校验录入的邮箱格式是否符合规范
        }

        #endregion 判断：邮箱格式

        #region 获取饭卡号

        private string GetRiceCard(string stu_number)
        {
            object o = ds.ExecuteTxtScalar(string.Format("SELECT RICE_CARD FROM BASIC_STU_RICECARD WHERE STU_NUMBER = '{0}'", stu_number));
            if (o != null && o.ToString().Length > 0)
            {
                return o.ToString();
            }
            return string.Empty;
        }

        #endregion 获取饭卡号
    }
}