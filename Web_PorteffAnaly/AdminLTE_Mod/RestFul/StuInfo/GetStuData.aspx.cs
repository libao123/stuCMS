using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Model.RestFul;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.RestFul.StuInfo
{
    /// <summary>
    /// 获得学生信息
    /// </summary>
    public partial class GetStuData : System.Web.UI.Page
    {
        #region 初始化

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "stu_info":
                            Response.Write(GetStuInfo());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 初始化

        #region 通过接口获得学生信息

        /// <summary>
        /// 通过接口获得学生信息
        /// </summary>
        /// <returns></returns>
        private string GetStuInfo()
        {
            ReturnJson json = new ReturnJson();
            try
            {
                #region 校验参数

                string stuno = Request.QueryString["stuno"];
                string token = Request.QueryString["token"];
                LogDBHandleClass.getInstance().LogOperation("", "学生信息接口", CValue.LOG_ACTION_TYPE_8, CValue.LOG_RECORD_TYPE_1, "学生信息接口被调用", "", "", "");
                if (string.IsNullOrWhiteSpace(stuno))
                {
                    json.status = 0;
                    json.message = "参数错误";
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "学生信息接口参数错误：");
                    return Newtonsoft.Json.JsonConvert.SerializeObject(json);
                }

                #endregion 校验参数

                #region 校验密钥

                string msg = "";
                if (!OpenDataHandleClass.getInstance().VerifyParamForMD5(token, out msg))
                {
                    json.status = 0;
                    json.message = msg;
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "学生信息接口密钥错误：" + msg);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(json);
                }

                #endregion 校验密钥

                #region 通过学号读取学生信息

                Basic_stu_info stuInfo = StuHandleClass.getInstance().GetStuInfo_Obj(stuno);
                if (stuInfo == null)
                {
                    json.status = 0;
                    json.message = "通过学号未找到相关学生信息";
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "学生信息接口密钥错误，通过学号未找到相关学生信息：" + stuno);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(json);
                }
                OpenStudentInfo openStuInfo = new OpenStudentInfo(stuInfo);
                List<object> objData = new List<object>();
                objData.Add(openStuInfo);

                #endregion 通过学号读取学生信息

                json.status = 1;
                json.message = "";
                json.data = objData;
                return Newtonsoft.Json.JsonConvert.SerializeObject(json);
            }
            catch (Exception ex)
            {
                json.status = 0;
                json.message = "接口内部错误";
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "调用学生信息接口错误：" + ex.Message + ex.StackTrace);
                return Newtonsoft.Json.JsonConvert.SerializeObject(json);
            }
        }

        #endregion 通过接口获得学生信息
    }

    #region 接口开放学生信息类

    /// <summary>
    /// 接口开放学生信息类
    /// </summary>
    public class OpenStudentInfo
    {
        private comdata cod = new comdata();

        #region 接口类

        public OpenStudentInfo(Basic_stu_info stuInfo)
        {
            InitStudentInfo(stuInfo);
        }

        public void InitStudentInfo(Basic_stu_info stuInfo)
        {
            number = stuInfo.NUMBER;
            name = stuInfo.NAME;
            us_name = stuInfo.US_NAME;
            idcardno = stuInfo.IDCARDNO;
            sex = cod.GetDDLTextByValue("ddl_xb", stuInfo.SEX);
            heigth = stuInfo.HEIGTH;
            weigth = stuInfo.WEIGTH;
            genius = stuInfo.GENIUS;
            health = stuInfo.HEALTH;
            stutype = cod.GetDDLTextByValue("ddl_basic_stu_type", stuInfo.STUTYPE);
            enrolling = cod.GetDDLTextByValue("ddl_rxfs", stuInfo.ENROLLING);
            email = stuInfo.EMAIL;
            qq = stuInfo.QQNUM;
            birthday = stuInfo.GARDE;
            grade = stuInfo.EDULENTH;
            xy = cod.GetDDLTextByValue("ddl_department", stuInfo.COLLEGE);
            zy = cod.GetDDLTextByValue("ddl_zy", stuInfo.MAJOR);
            classname = cod.GetDDLTextByValue("ddl_class", stuInfo.CLASS);
            system = cod.GetDDLTextByValue("ddl_edu_system", stuInfo.SYSTEM);
            nation = cod.GetDDLTextByValue("ddl_mz", stuInfo.NATION);
            polistatus = cod.GetDDLTextByValue("ddl_zzmm", stuInfo.POLISTATUS);
            entertime = stuInfo.ENTERTIME;
            register = cod.GetDDLTextByValue("ddl_xjzt", stuInfo.REGISTER);
            nativeplace = ComHandleClass.getInstance().ConvertAddress(stuInfo.NATIVEPLACE);
            stuplace = ComHandleClass.getInstance().ConvertAddress(stuInfo.STUPLACE);
            address = ComHandleClass.getInstance().ConvertAddress(stuInfo.ADDRESS);
            registplace = ComHandleClass.getInstance().ConvertAddress(stuInfo.REGISTPLACE);
        }

        #endregion 接口类

        #region 字段

        /// <summary>
        /// 学号
        /// </summary>
        public string number { get; set; }

        /// <summary>
        /// 姓名
        /// </summary>
        public string name { get; set; }

        /// <summary>
        /// 曾用名
        /// </summary>
        public string us_name { get; set; }

        /// <summary>
        /// 身份证号
        /// </summary>
        public string idcardno { get; set; }

        /// <summary>
        /// 性别
        /// </summary>
        public string sex { get; set; }

        /// <summary>
        /// 身高
        /// </summary>
        public string heigth { get; set; }

        /// <summary>
        /// 体重
        /// </summary>
        public string weigth { get; set; }

        /// <summary>
        /// 特长
        /// </summary>
        public string genius { get; set; }

        /// <summary>
        /// 健康状况
        /// </summary>
        public string health { get; set; }

        /// <summary>
        /// 学生类别
        /// </summary>
        public string stutype { get; set; }

        /// <summary>
        /// 入学方式
        /// </summary>
        public string enrolling { get; set; }

        /// <summary>
        /// 电子邮箱
        /// </summary>
        public string email { get; set; }

        /// <summary>
        /// QQ号码
        /// </summary>
        public string qq { get; set; }

        /// <summary>
        /// 出生日期
        /// </summary>
        public string birthday { get; set; }

        /// <summary>
        /// 年级
        /// </summary>
        public string grade { get; set; }

        /// <summary>
        /// 学院
        /// </summary>
        public string xy { get; set; }

        /// <summary>
        /// 专业
        /// </summary>
        public string zy { get; set; }

        /// <summary>
        /// 班级
        /// </summary>
        public string classname { get; set; }

        /// <summary>
        /// 学制
        /// </summary>
        public string system { get; set; }

        /// <summary>
        /// 民族
        /// </summary>
        public string nation { get; set; }

        /// <summary>
        /// 政治面貌
        /// </summary>
        public string polistatus { get; set; }

        /// <summary>
        /// 入学时间
        /// </summary>
        public string entertime { get; set; }

        /// <summary>
        /// 学籍
        /// </summary>
        public string register { get; set; }

        /// <summary>
        /// 籍贯
        /// </summary>
        public string nativeplace { get; set; }

        /// <summary>
        /// 生源地（高考时户籍所在地）
        /// </summary>
        public string stuplace { get; set; }

        /// <summary>
        /// 家庭所在地
        /// </summary>
        public string address { get; set; }

        /// <summary>
        /// 户口所在地
        /// </summary>
        public string registplace { get; set; }

        #endregion 字段
    }

    #endregion 接口开放学生信息类
}