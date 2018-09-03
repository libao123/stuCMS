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

namespace PorteffAnaly.Web.AdminLTE_Mod.RestFul.Coun
{
    /// <summary>
    /// 获得辅导员信息
    /// </summary>
    public partial class GetCounData : System.Web.UI.Page
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
                        case "coun_info":
                            Response.Write(GetCounInfo());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 初始化

        #region 通过接口获得辅导员信息

        /// <summary>
        /// 通过接口获得辅导员信息
        /// </summary>
        /// <returns></returns>
        private string GetCounInfo()
        {
            ReturnJson json = new ReturnJson();
            try
            {
                #region 校验参数

                string counno = Request.QueryString["counno"];
                string token = Request.QueryString["token"];
                LogDBHandleClass.getInstance().LogOperation("", "辅导员信息接口", CValue.LOG_ACTION_TYPE_8, CValue.LOG_RECORD_TYPE_1, "辅导员信息接口被调用", "", "", "");
                if (string.IsNullOrWhiteSpace(counno))
                {
                    json.status = 0;
                    json.message = "参数错误";
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "辅导员信息接口参数错误：");
                    return Newtonsoft.Json.JsonConvert.SerializeObject(json);
                }

                #endregion 校验参数

                #region 校验密钥

                string msg = "";
                if (!OpenDataHandleClass.getInstance().VerifyParamForMD5(token, out msg))
                {
                    json.status = 0;
                    json.message = msg;
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "辅导员信息接口密钥错误：" + msg);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(json);
                }

                #endregion 校验密钥

                #region 通过工号读取辅导员信息

                Basic_coun_info counInfo = CounHandleClass.getInstance().GetCounInfo_Obj(counno);
                if (counInfo == null)
                {
                    json.status = 0;
                    json.message = "通过学号未找到相关辅导员信息";
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "辅导员信息接口密钥错误，通过工号未找到相关辅导员信息：" + counno);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(json);
                }
                OpenCounInfo openStuInfo = new OpenCounInfo(counInfo);
                List<object> objData = new List<object>();
                objData.Add(openStuInfo);

                #endregion 通过工号读取辅导员信息

                json.status = 1;
                json.message = "";
                json.data = objData;
                return Newtonsoft.Json.JsonConvert.SerializeObject(json);
            }
            catch (Exception ex)
            {
                json.status = 0;
                json.message = "接口内部错误";
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "调用辅导员信息接口错误：" + ex.Message + ex.StackTrace);
                return Newtonsoft.Json.JsonConvert.SerializeObject(json);
            }
        }

        #endregion 通过接口获得辅导员信息
    }

    #region 接口开放辅导员信息类

    /// <summary>
    /// 接口开放辅导员信息类
    /// </summary>
    public class OpenCounInfo
    {
        private comdata cod = new comdata();

        #region 接口类

        public OpenCounInfo(Basic_coun_info counInfo)
        {
            InitCounInfo(counInfo);
        }

        public void InitCounInfo(Basic_coun_info counInfo)
        {
            eno = counInfo.ENO;
            name = counInfo.NAME;
            idcardno = counInfo.IDCARDNO;
            sex = cod.GetDDLTextByValue("ddl_xb", counInfo.SEX);
            email = counInfo.EMAIL;
            mobilenum = counInfo.MOBILENUM;
            officephone = counInfo.OFFICEPHONE;
            birthday = counInfo.GARDE;
            department = cod.GetDDLTextByValue("ddl_all_department", counInfo.COLLEGE);
            zy = cod.GetDDLTextByValue("ddl_zy", counInfo.MAJOR);
            nation = cod.GetDDLTextByValue("ddl_mz", counInfo.NATION);
            polistatus = cod.GetDDLTextByValue("ddl_zzmm", counInfo.POLISTATUS);
            entertime = counInfo.ENTERTIME;
            porjob = counInfo.PORJOB;
            nativeplace = ComHandleClass.getInstance().ConvertAddress(counInfo.NATIVEPLACE);
            address = ComHandleClass.getInstance().ConvertAddress(counInfo.ADDRESS);
        }

        #endregion 接口类

        #region 字段

        /// <summary>
        /// 工号
        /// </summary>
        public string eno { get; set; }

        /// <summary>
        /// 姓名
        /// </summary>
        public string name { get; set; }

        /// <summary>
        /// 身份证号
        /// </summary>
        public string idcardno { get; set; }

        /// <summary>
        /// 性别
        /// </summary>
        public string sex { get; set; }

        /// <summary>
        /// 移动电话
        /// </summary>
        public string mobilenum { get; set; }

        /// <summary>
        /// 办公电话
        /// </summary>
        public string officephone { get; set; }

        /// <summary>
        /// 电子邮箱
        /// </summary>
        public string email { get; set; }

        /// <summary>
        /// 出生日期
        /// </summary>
        public string birthday { get; set; }

        /// <summary>
        /// 所在部门名称
        /// </summary>
        public string department { get; set; }

        /// <summary>
        /// 所学专业
        /// </summary>
        public string zy { get; set; }

        /// <summary>
        /// 民族
        /// </summary>
        public string nation { get; set; }

        /// <summary>
        /// 政治面貌
        /// </summary>
        public string polistatus { get; set; }

        /// <summary>
        /// 入校工作时间
        /// </summary>
        public string entertime { get; set; }

        /// <summary>
        /// 专兼职
        /// </summary>
        public string porjob { get; set; }

        /// <summary>
        /// 籍贯
        /// </summary>
        public string nativeplace { get; set; }

        /// <summary>
        /// 家庭所在地
        /// </summary>
        public string address { get; set; }

        #endregion 字段
    }

    #endregion 接口开放辅导员信息类
}