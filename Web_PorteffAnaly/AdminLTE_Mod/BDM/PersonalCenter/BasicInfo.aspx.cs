using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using commonclass;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter
{
    public partial class BasicInfo : Main
    {
        #region 初始化定义

        public comdata cod = new comdata();
        private ComTranClass comTran = new ComTranClass();
        public Basic_stu_info head = new Basic_stu_info();
        public Dst_family_situa situa = new Dst_family_situa();
        public Dst_family_members member = new Dst_family_members();
        public Dst_stu_apply dst_apply = new Dst_stu_apply();
        public Basic_stu_bank_info bank = new Basic_stu_bank_info();
        public Score_rank_info score = new Score_rank_info();
        public Basic_coun_info coun = new Basic_coun_info();
        public Basic_stu_ricecard ricecard = new Basic_stu_ricecard();
        public string strPhotoPath = string.Empty;
        public bool IsShowScoreOrDst = true;//是否显示成绩或者困难生列表信息：研究生不显示
        /// <summary>
        /// 【服务器上虚拟路径的物理地址（有盘符的）】就是图片的实际存储路径（注：PhotoPath配置在web.config中）
        /// </summary>
        private string m_strUploadPhoto = System.Web.HttpContext.Current.Server.MapPath("~/" + Util.GetAppSettings("PhotoPath"));

        /// <summary>
        /// 附件存储根目录
        /// </summary>
        public string m_strUploadPhotoRoot = Util.GetAppSettings("PhotoPath");

        #endregion 初始化定义

        #region 页面加载

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];

                #region 操作加载

                if (!string.IsNullOrEmpty(optype))
                {
                    object o = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM BASIC_STU_INFO WHERE NUMBER = '{0}'", user.User_Id));
                    if (o != null && o.ToString().Length > 0)
                    {
                        head.OID = o.ToString();
                        ds.RetrieveObject(head);
                    }
                    switch (optype.ToLower().Trim())
                    {
                        case "getfamilymembers":
                            Response.Write(GetFamilyMembers());
                            Response.End();
                            break;

                        case "getscore":
                            Response.Write(GetScore());
                            Response.End();
                            break;

                        case "getdstapply":
                            Response.Write(GetDstApply());
                            Response.End();
                            break;
                        case "getscholarship":
                            Response.Write(GetScholarship());
                            Response.End();
                            break;

                        case "getloaninfo":
                            Response.Write(GetLoanInfo());
                            Response.End();
                            break;
                        case "getinsuranceinfo":
                            Response.Write(GetInsuranceInfo());
                            Response.End();
                            break;
                    }
                }

                #endregion 操作加载

                #region 首次加载

                else
                {
                    object o = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM BASIC_STU_INFO WHERE NUMBER = '{0}'", user.User_Id));
                    if (o != null && o.ToString().Length > 0)
                    {
                        head.OID = o.ToString();
                        ds.RetrieveObject(head);
                        head.NATIVEPLACE = ComHandleClass.getInstance().ConvertAddress(head.NATIVEPLACE);
                        head.REGISTPLACE = ComHandleClass.getInstance().ConvertAddress(head.REGISTPLACE);
                        head.ADDRESS = ComHandleClass.getInstance().ConvertAddress(head.ADDRESS);
                        head.STUPLACE = ComHandleClass.getInstance().ConvertAddress(head.STUPLACE);

                        //头像存储目录
                        DataTable dt_p = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM UA_USER_PHOTO WHERE USER_ID = '{0}'", user.User_Id));
                        if (dt_p != null && dt_p.Rows.Count > 0)
                        {
                            strPhotoPath = string.Format("{0}/{1}", dt_p.Rows[0]["ARCHIVE_DIRECTORY"].ToString().Replace("\\", "/"), dt_p.Rows[0]["PHOTO_NAME"].ToString().Replace("\\", "/"));
                        }

                        //辅导员信息
                        DataTable dt_coun = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM UA_CLASS_GROUP WHERE RET_CHANNEL = 'D4000' AND GROUP_CLASS IN (SELECT CLASS FROM BASIC_STU_INFO WHERE NUMBER = '{0}')", user.User_Id));
                        if (dt_coun != null && dt_coun.Rows.Count > 0)
                        {
                            coun = CounHandleClass.getInstance().GetCounInfo(dt_coun.Rows[0]["GROUP_NUMBER"].ToString(), dt_coun.Rows[0]["GROUP_TYPE"].ToString());
                            if (coun == null)
                                coun = new Basic_coun_info();
                        }
                    }
                    object bankOID = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM BASIC_STU_BANK_INFO WHERE NUMBER = '{0}'", user.User_Id));
                    if (bankOID != null && bankOID.ToString().Length > 0)
                    {
                        bank.OID = bankOID.ToString();
                        ds.RetrieveObject(bank);
                    }

                    //学生饭卡信息
                    object riceOID = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM BASIC_STU_RICECARD WHERE STU_NUMBER = '{0}'", user.User_Id));
                    if (riceOID != null && riceOID.ToString().Length > 0)
                    {
                        ricecard.OID = riceOID.ToString();
                        ds.RetrieveObject(ricecard);
                    }
                }

                #endregion 首次加载

                if (user.Stu_Type.Equals("Y"))//学生类型为研究生
                {
                    if (user.User_Role.Contains("S"))//角色还包含学生的，不显示
                        IsShowScoreOrDst = false;
                }
            }
        }

        #endregion 页面加载

        #region 家庭成员

        /// <summary>
        /// 家庭成员
        /// </summary>
        /// <returns></returns>
        private string GetFamilyMembers()
        {
            string sql = string.Format("SELECT * FROM DST_FAMILY_MEMBERS WHERE SEQ_NO=(SELECT SEQ_NO FROM DST_FAMILY_SITUA WHERE NUMBER='{0}') ORDER BY ORDER_NO", head.NUMBER);
            DataTable dt = ds.ExecuteTxtDataTable(sql);
            Hashtable ddl = new Hashtable();
            ddl = new Hashtable();
            ddl["RELATION"] = "ddl_relation";
            ddl["PROFESSION"] = "ddl_profession";
            ddl["HEALTH"] = "ddl_health";
            cod.ConvertTabDdl(dt, ddl);
            //repMember.DataSource = dt;
            //repMember.DataBind();
            return DataTableToJson(dt);
        }

        #endregion 家庭成员

        #region 综测成绩

        /// <summary>
        /// 综测成绩
        /// </summary>
        private string GetScore()
        {
            string sql = string.Format("SELECT * FROM SCORE_RANK_INFO WHERE STU_NUMBER='{0}' ORDER BY YEAR", head.NUMBER);
            DataTable dt = ds.ExecuteTxtDataTable(sql);
            Hashtable ddl = new Hashtable();
            ddl = new Hashtable();
            ddl["YEAR"] = "ddl_year_type";
            cod.ConvertTabDdl(dt, ddl);
            //repScore.DataSource = dt;
            //repScore.DataBind();
            return DataTableToJson(dt);
        }

        #endregion 综测成绩

        #region 困难生认定

        /// <summary>
        /// 困难生认定
        /// </summary>
        /// <returns></returns>
        private string GetDstApply()
        {
            string sql = string.Format("SELECT * FROM DST_STU_APPLY WHERE NUMBER='{0}' AND RET_CHANNEL='{1}' ORDER BY SCHYEAR", head.NUMBER, HQ.Model.CValue.RET_CHANNEL_D4000);
            DataTable dt = ds.ExecuteTxtDataTable(sql);
            Hashtable ddl = new Hashtable();
            ddl = new Hashtable();
            ddl["SCHYEAR"] = "ddl_year_type";
            ddl["LEVEL_CODE"] = "ddl_dst_level";
            cod.ConvertTabDdl(dt, ddl);
            //repApply.DataSource = dt;
            //repApply.DataBind();
            return DataTableToJson(dt);
        }

        #endregion 困难生认定

        #region 奖助信息

        /// <summary>
        /// 奖助信息
        /// </summary>
        /// <returns></returns>
        private string GetScholarship()
        {
            string sql = string.Format("SELECT * FROM SHOOLAR_APPLY_HEAD WHERE STU_NUMBER='{0}' AND RET_CHANNEL='{1}' ORDER BY PROJECT_YEAR", head.NUMBER, HQ.Model.CValue.RET_CHANNEL_D4000);
            DataTable dt = ds.ExecuteTxtDataTable(sql);
            Hashtable ddl = new Hashtable();
            ddl = new Hashtable();
            ddl["PROJECT_YEAR"] = "ddl_year_type";
            cod.ConvertTabDdl(dt, ddl);
            //repScholar.DataSource = dt;
            //repScholar.DataBind();
            return DataTableToJson(dt);
        }

        #endregion 奖助信息

        #region 贷款信息

        /// <summary>
        /// 贷款信息
        /// </summary>
        private string GetLoanInfo()
        {
            string sql = string.Format("SELECT * FROM LOAN_PROJECT_APPLY WHERE STU_NUMBER='{0}'", head.NUMBER);
            DataTable dt = ds.ExecuteTxtDataTable(sql);
            Hashtable ddl = new Hashtable();
            ddl = new Hashtable();
            ddl["LOAN_YEAR"] = "ddl_year_type";
            ddl["LOAN_TYPE"] = "ddl_loan_type";
            cod.ConvertTabDdl(dt, ddl);
            return DataTableToJson(dt);
        }

        #endregion 贷款信息

        #region 参保信息

        /// <summary>
        /// 参保信息（有保单号才显示）
        /// </summary>
        private string GetInsuranceInfo()
        {
            string sql = string.Format("SELECT * FROM INSUR_PROJECT_APPLY WHERE STU_NUMBER='{0}' AND INSUR_NUMBER IS NOT NULL AND INSUR_NUMBER != '' ORDER BY INSUR_YEAR", head.NUMBER);
            DataTable dt = ds.ExecuteTxtDataTable(sql);
            Hashtable ddl = new Hashtable();
            ddl = new Hashtable();
            ddl["YEAR"] = "ddl_year_type";
            ddl["SURTYPE"] = "ddl_insur_type";
            cod.ConvertTabDdl(dt, ddl);
            //repInsur.DataSource = dt;
            //repInsur.DataBind();
            return DataTableToJson(dt);
        }

        #endregion 参保信息

        private string DataTableToJson(DataTable dt)
        {
            int draw = 1;
            if (Post("draw") != null)
                int.TryParse(Post("draw"), out draw);
            return string.Format("{{\"draw\":{0},\"recordsTotal\":{1},\"recordsFiltered\":{2},\"data\":[{3}]}}", draw, dt.Rows.Count, dt.Rows.Count, Json.DatatableToJson(dt));
        }
    }
}