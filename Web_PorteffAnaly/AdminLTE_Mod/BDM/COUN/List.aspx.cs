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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.COUN
{
    public partial class List : ListBaseLoad<Basic_coun_info>
    {
        #region 初始化

        private comdata cod = new comdata();
        public bool IsShowBtn = false;//ZZ 20171026 新增：是否显示按钮：校级角色显示

        protected override string input_code_column
        {
            get { return "ENO"; }
        }

        protected override string class_code_column
        {
            get { return ""; }
        }

        protected override string xy_code_column
        {
            get { return "DEPARTMENT"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Basic_coun_info> GetSelectTransaction()
        {
            if (!string.IsNullOrEmpty(Get("page_from")))
            {
                if (Get("page_from").ToString().Equals("index"))/// 首页的用户档案进来的，只展示自己的
                    param.Add("ENO", user.User_Id);
            }
            return ImplementFactory.GetSelectTransaction<Basic_coun_info>("Basic_coun_infoSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("ENO")))
                where += string.Format(" AND ENO LIKE '%{0}%' ", Post("ENO"));
            if (!string.IsNullOrEmpty(Post("NAME")))
                where += string.Format(" AND NAME LIKE '%{0}%' ", Post("NAME"));
            if (!string.IsNullOrEmpty(Post("IDCARDNO")))
                where += string.Format(" AND IDCARDNO LIKE '%{0}%' ", Post("IDCARDNO"));
            if (!string.IsNullOrEmpty(Post("DEPARTMENT")))
                where += string.Format(" AND DEPARTMENT = '{0}' ", Post("DEPARTMENT"));
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

                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;

                        case "chkid":
                            Response.Write(CheckPoeple());
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

        protected override IEnumerable<NameValue> GetValue(Basic_coun_info entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "ENO", Value = entity.ENO };
            yield return new NameValue() { Name = "NAME", Value = entity.NAME };
            yield return new NameValue() { Name = "IDCARDNO", Value = entity.IDCARDNO };
            yield return new NameValue() { Name = "GARDE", Value = entity.GARDE };
            yield return new NameValue() { Name = "MOBILENUM", Value = entity.MOBILENUM.ToString() };
            yield return new NameValue() { Name = "DEPARTMENT", Value = entity.DEPARTMENT };
            yield return new NameValue() { Name = "DEPARTMENT_NAME", Value = cod.GetDDLTextByValue("ddl_all_department", entity.DEPARTMENT) };
            yield return new NameValue() { Name = "SEX", Value = entity.SEX };
            yield return new NameValue() { Name = "SEX_NAME", Value = cod.GetDDLTextByValue("ddl_xb", entity.SEX) };
            yield return new NameValue() { Name = "COLLEGE", Value = entity.COLLEGE };
            yield return new NameValue() { Name = "COLLEGE_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.COLLEGE) };
            yield return new NameValue() { Name = "MAJOR", Value = entity.MAJOR };
            yield return new NameValue() { Name = "MAJOR_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.MAJOR) };
            yield return new NameValue() { Name = "NATION", Value = entity.NATION };
            yield return new NameValue() { Name = "NATION_NAME", Value = cod.GetDDLTextByValue("ddl_mz", entity.NATION) };
            yield return new NameValue() { Name = "POLISTATUS", Value = entity.POLISTATUS };
            yield return new NameValue() { Name = "POLISTATUS_NAME", Value = cod.GetDDLTextByValue("ddl_zzmm", entity.POLISTATUS) };
            yield return new NameValue() { Name = "ENTERTIME", Value = entity.ENTERTIME };
            yield return new NameValue() { Name = "ADDRESS", Value = entity.ADDRESS };
            yield return new NameValue() { Name = "EMAIL", Value = entity.EMAIL };
            yield return new NameValue() { Name = "UNIVE", Value = entity.UNIVE };
            yield return new NameValue() { Name = "OFFICEPHONE", Value = entity.OFFICEPHONE };
            yield return new NameValue() { Name = "FIXHPONE", Value = entity.FIXHPONE };
            yield return new NameValue() { Name = "FAX", Value = entity.FAX };
            yield return new NameValue() { Name = "NATIVEPLACE", Value = entity.NATIVEPLACE };
            yield return new NameValue() { Name = "HOMENUM", Value = entity.HOMENUM };
            yield return new NameValue() { Name = "PORJOB", Value = entity.PORJOB };
            yield return new NameValue() { Name = "POSTADDRESS", Value = entity.POSTADDRESS };
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

            var model = new Basic_coun_info();
            model.OID = Get("id");
            ds.RetrieveObject(model);

            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Basic_coun_info>("Basic_coun_infoDeleteTransaction");
            transaction.EntityList.Add(model);
            bDel = transaction.Commit();
            if (bDel)
                return "";
            return "删除失败！";
        }

        #endregion 删除数据

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

        #region 判断：身份证

        /// <summary>
        /// 判断：边民身份证是否唯一
        /// </summary>
        /// <returns></returns>
        private string CheckPoeple()
        {
            #region 校验录入的身份证号是否符合规范

            System.Text.RegularExpressions.Regex regexp = new System.Text.RegularExpressions.Regex(@"^\d{17}(\d|X|x)$");

            if (!regexp.IsMatch(Request.QueryString["idno"]))
                return "输入的身份证号码不符合规范，请重新录入！";

            return "";

            #endregion 校验录入的身份证号是否符合规范
        }

        #endregion 判断：身份证

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                Basic_coun_info head = new Basic_coun_info();
                head.OID = Post("OID");
                if (head.OID.Length == 0)
                {
                    head.OID = Guid.NewGuid().ToString();
                    head.SEQ_NO = HQ.InterfaceService.BusDataDeclareTransaction.getInstance().GetSeq_no("COU01");
                }
                ds.RetrieveObject(head);
                head.ENO = Post("ENO");
                head.NAME = Post("NAME");
                head.SEX = Post("SEX");
                head.HOMENUM = Post("HOMENUM");
                head.POLISTATUS = Post("POLISTATUS");
                head.GARDE = Post("GARDE");
                head.ENTERTIME = Post("ENTERTIME");
                head.ADDRESS = Post("ADDRESS");
                head.MOBILENUM = Post("MOBILENUM");
                head.EMAIL = Post("EMAIL");
                head.UNIVE = Post("UNIVE");
                head.FIXHPONE = Post("FIXHPONE");
                head.MAJOR = Post("MAJOR");
                head.PORJOB = Post("PORJOB");
                head.POSTADDRESS = Post("POSTADDRESS");
                head.OFFICEPHONE = Post("OFFICEPHONE");
                head.FAX = Post("FAX");
                head.NATIVEPLACE = Post("NATIVEPLACE");
                head.NATION = Post("NATION");
                head.DEPARTMENT = Post("DEPARTMENT");
                head.IDCARDNO = Post("IDCARDNO");
                head.OPER = user.User_Name;
                head.OPTIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                ds.UpdateObject(head);
                if (string.IsNullOrEmpty(Post("OID")))
                {
                    LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "辅导员基础信息管理", CValue.LOG_ACTION_TYPE_3, CValue.LOG_RECORD_TYPE_1, string.Format("新增辅导员信息：辅导员{0}，姓名{1}", head.ENO, head.NAME), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                else
                {
                    LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "辅导员基础信息管理", CValue.LOG_ACTION_TYPE_4, CValue.LOG_RECORD_TYPE_1, string.Format("修改辅导员信息：辅导员{0}，姓名{1}", head.ENO, head.NAME), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                InsertOrUpUser(head);
                return head.OID;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保存/更新辅导员数据，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据

        #region 插入/更新用户

        /// <summary>
        /// 插入/更新用户
        /// </summary>
        /// <param name="model"></param>
        private void InsertOrUpUser(Basic_coun_info model)
        {
            try
            {
                if (ComHandleClass.getInstance().IsExistUaUser(model.ENO))//存在，更新
                {
                    Ua_user Ua_user = new Ua_user();
                    Ua_user.USER_ID = model.ENO;
                    ds.RetrieveObject(Ua_user);
                    Ua_user.USER_NAME = model.NAME;
                    Ua_user.XY_CODE = model.DEPARTMENT;
                    ds.UpdateObject(Ua_user);
                    LogDBHandleClass.getInstance().LogOperation(Ua_user.USER_ID, "用户信息管理", CValue.LOG_ACTION_TYPE_4, CValue.LOG_RECORD_TYPE_1, string.Format("修改用户信息：用户{0}，姓名{1}", Ua_user.USER_ID, Ua_user.USER_NAME), user.User_Id, user.User_Name, user.UserLoginIP);
                }
                else//插入
                {
                    Ua_user Ua_user = new Ua_user();
                    Ua_user.USER_ID = model.ENO;
                    ds.RetrieveObject(Ua_user);
                    Ua_user.USER_NAME = model.NAME;
                    Ua_user.XY_CODE = model.DEPARTMENT;
                    Ua_user.USER_TYPE = "T";//S学生;T老师
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
                    Ua_user.USER_ROLE = "F";//用户角色分配
                    Ua_user.IS_ASSISTANT = "Y";//是否是辅导员
                    Ua_user.CREATE_TIME = GetDateLongFormater();
                    Ua_user.CREATE_CODE = user.User_Id;
                    Ua_user.CREATE_NAME = user.User_Name;
                    ds.UpdateObject(Ua_user);
                    LogDBHandleClass.getInstance().LogOperation(Ua_user.USER_ID, "用户信息管理", CValue.LOG_ACTION_TYPE_3, CValue.LOG_RECORD_TYPE_1, string.Format("新增用户信息：用户{0}，姓名{1}", Ua_user.USER_ID, Ua_user.USER_NAME), user.User_Id, user.User_Name, user.UserLoginIP);
                }
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "更新辅导员信息同步更新用户信息，失败：" + ex.ToString());
            }
        }

        #endregion 插入/更新用户
    }
}