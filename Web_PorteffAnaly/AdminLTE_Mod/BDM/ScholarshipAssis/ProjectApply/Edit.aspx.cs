using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.Architecture.Factory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;
using serverservice;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectApply
{
    /// <summary>
    /// 奖助申请编辑页
    /// </summary>
    public partial class Edit : Main
    {
        #region 初始化

        public comdata cod = new comdata();
        public bool IsView = false;//是否为查阅状态
        public string m_strIsShowAuditBtn = "false";//是否显示审批按钮：显示true 不显示false
        public string m_RewardFlag = "ddl_apply_reward_flag";//拟评何种类型

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
                        case "add":
                        case "modi":
                            InitPage();
                            break;

                        case "view":
                            IsView = true;
                            ChkAudit();//判断是否可以审批
                            break;

                        case "getprojectdata":
                            Response.Write(GetProjectData());
                            Response.End();
                            break;

                        case "getstudata":
                            Response.Write(GetStudentData());
                            Response.End();
                            break;

                        case "getmodidata_head":
                            Response.Write(GetModiData_Head());
                            Response.End();
                            break;

                        case "getmodidata_family":
                            Response.Write(GetModiData_Family());
                            Response.End();
                            break;

                        case "getmodidata_study":
                            Response.Write(GetModiData_Study());
                            Response.End();
                            break;

                        case "getmodidata_txt":
                            Response.Write(GetModiData_Txt());
                            Response.End();
                            break;

                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;

                        case "iscan_submit":
                            Response.Write(ChkIsCanSubmit());
                            Response.End();
                            break;

                        case "submit":
                            Response.Write(SubmitData());
                            Response.End();
                            break;

                        case "getapproveinfo":
                            Response.Write(GetApproveDefaultInfo());
                            Response.End();
                            break;

                        case "submit_approve":
                            Response.Write(ApproveData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 新增/修改操作界面加载

        /// <summary>
        /// 新增/修改操作界面加载
        /// </summary>
        private void InitPage()
        {
            if (string.IsNullOrEmpty(Get("project_seq_no")))
                return;
            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("SEQ_NO", Get("project_seq_no"));
            Shoolar_project_head head = ProjectSettingHandleClass.getInstance().GetProjectHead(param);
            if (head == null)
                return;
            if (head.PROJECT_TYPE == "SCHOOL_GOOD" || head.PROJECT_TYPE == "SCHOOL_MODEL")
            {
                m_RewardFlag = "ddl_apply_reward_flag_1";//拟评何种类型（三好学生）
            }
            else if (head.PROJECT_TYPE == "SCHOOL_SINGLE")
            {
                m_RewardFlag = "ddl_apply_reward_flag_2";//拟评何种类型（单项奖学金）
            }
            else
            {
                m_RewardFlag = "ddl_apply_reward_flag";
            }
        }

        #endregion 新增/修改操作界面加载

        #region 判断是否具有审批权限

        /// <summary>
        /// 判断是否具有审批权限
        /// </summary>
        private void ChkAudit()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return;
            Shoolar_apply_head head = new Shoolar_apply_head();
            head.OID = Get("id").ToString();
            ds.RetrieveObject(head);
            if (head == null)
                return;
            //判断是否可以审批
            if (WKF_ExternalInterface.getInstance().ChkAudit(head.DOC_TYPE, head.SEQ_NO, user.User_Role).Length == 0)
            {
                m_strIsShowAuditBtn = "true";
            }
        }

        #endregion 判断是否具有审批权限

        #region 获得相应的奖助项目数据

        /// <summary>
        /// 获得相应的奖助项目数据
        /// </summary>
        /// <returns></returns>
        private string GetProjectData()
        {
            if (string.IsNullOrEmpty(Get("project_seq_no")))
                return "{}";
            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("SEQ_NO", Get("project_seq_no"));
            Shoolar_project_head head = ProjectSettingHandleClass.getInstance().GetProjectHead(param);
            if (head == null)
                return "{}";
            StringBuilder json = new StringBuilder();//用来存放Json的
            json.Append("{");
            json.Append(Json.StringToJson(head.PROJECT_CLASS, "PROJECT_CLASS"));
            json.Append(",");
            json.Append(Json.StringToJson(head.PROJECT_TYPE, "PROJECT_TYPE"));
            json.Append(",");
            json.Append(Json.StringToJson(head.APPLY_YEAR, "PROJECT_YEAR"));
            json.Append(",");
            json.Append(Json.StringToJson(head.PROJECT_MONEY.ToString(), "PROJECT_MONEY"));
            json.Append(",");
            json.Append(Json.StringToJson(head.PROJECT_NAME, "PROJECT_NAME"));
            json.Append("}");
            return json.ToString();
        }

        #endregion 获得相应的奖助项目数据

        #region 获得申报学生基本信息

        /// <summary>
        /// 获得申报学生基本信息
        /// </summary>
        /// <returns></returns>
        private string GetStudentData()
        {
            if (string.IsNullOrEmpty(Get("stu_num")))
                return "{}";
            return StuHandleClass.getInstance().GetStuInfoJson(Get("stu_num"));
        }

        #endregion 获得申报学生基本信息

        #region 获得奖助申请（表头）

        /// <summary>
        ///  获得奖助申请（表头）
        /// </summary>
        /// <returns></returns>
        private string GetModiData_Head()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "{}";
            //表头信息
            DataTable dtHead = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM SHOOLAR_APPLY_HEAD WHERE OID = '{0}' ", Get("id")));
            if (dtHead == null || dtHead.Rows.Count == 0)
                return "{}";
            return Json.DatatableToJson(dtHead);
        }

        #endregion 获得奖助申请（表头）

        #region 获得奖助申请（家庭情况）

        /// <summary>
        ///  获得奖助申请（家庭情况）
        /// </summary>
        /// <returns></returns>
        private string GetModiData_Family()
        {
            if (string.IsNullOrEmpty(Get("seq_no")))
                return "{}";
            //家庭情况信息
            DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM SHOOLAR_APPLY_FAMILY WHERE SEQ_NO = '{0}' ", Get("seq_no")));
            if (dt == null || dt.Rows.Count == 0)
                return "{}";
            return Json.DatatableToJson(dt);
        }

        #endregion 获得奖助申请（家庭情况）

        #region 获得奖助申请（学习情况）

        /// <summary>
        ///  获得奖助申请（学习情况）
        /// </summary>
        /// <returns></returns>
        private string GetModiData_Study()
        {
            if (string.IsNullOrEmpty(Get("seq_no")))
                return "{}";
            //学习情况信息
            DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM SHOOLAR_APPLY_STUDY WHERE SEQ_NO = '{0}' ", Get("seq_no")));
            if (dt == null || dt.Rows.Count == 0)
                return "{}";
            return Json.DatatableToJson(dt);
        }

        #endregion 获得奖助申请（学习情况）

        #region 获得奖助申请（大文本数据）

        /// <summary>
        ///  获得奖助申请（大文本数据）
        /// </summary>
        /// <returns></returns>
        private string GetModiData_Txt()
        {
            if (string.IsNullOrEmpty(Get("seq_no")))
                return "{}";
            //学习情况信息
            DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM SHOOLAR_APPLY_TXT WHERE SEQ_NO = '{0}' ", Get("seq_no")));
            if (dt == null || dt.Rows.Count == 0)
                return "{}";
            return Json.DatatableToJson(dt);
        }

        #endregion 获得奖助申请（大文本数据）

        #region 保存数据

        /// <summary>
        ///保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                bool result = false;
                Shoolar_apply_head head = new Shoolar_apply_head();
                if (string.IsNullOrEmpty(Post("hidOid")))//新增
                {
                    head.OID = Guid.NewGuid().ToString();
                    head.SEQ_NO = BusDataDeclareTransaction.getInstance().GetSeq_no(CValue.DOC_TYPE_BDM03);
                    head.RET_CHANNEL = Ret_Channel_A0000; //预录入 全程通道（回执状态）
                    head.DOC_TYPE = CValue.DOC_TYPE_BDM03;
                    GetPageValue(head);

                    #region 保存项目信息

                    //项目信息
                    Dictionary<string, string> param = new Dictionary<string, string>();
                    if (!string.IsNullOrEmpty(Post("hidProjectSeqNo")))
                        param.Add("SEQ_NO", Post("hidProjectSeqNo"));
                    Shoolar_project_head project = ProjectSettingHandleClass.getInstance().GetProjectList(param)[0];
                    if (project == null)
                    {
                        LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, string.Format("通过项目单据编号{0}，读取项目信息出错！", Post("hidProjectSeqNo")));
                        return string.Empty;
                    }

                    head.PROJECT_SEQ_NO = project.SEQ_NO;
                    head.PROJECT_CLASS = project.PROJECT_CLASS;
                    head.PROJECT_TYPE = project.PROJECT_TYPE;
                    head.PROJECT_YEAR = project.APPLY_YEAR;
                    head.PROJECT_NAME = project.PROJECT_NAME;
                    head.PROJECT_MONEY = project.PROJECT_MONEY;

                    #endregion 保存项目信息

                    #region 保存学生信息

                    //学生信息
                    head.STU_NUMBER = user.User_Id;
                    head.STU_NAME = user.User_Name;
                    Basic_stu_info stuInfo = StuHandleClass.getInstance().GetStuInfo_Obj(head.STU_NUMBER);
                    if (stuInfo == null)
                    {
                        LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, string.Format("通过学号{0}，读取学生信息出错！", head.STU_NUMBER));
                        return string.Empty;
                    }
                    //学生信息
                    if (stuInfo.STUTYPE.Equals(CValue.USER_STUTYPE_B))
                        head.STU_TYPE = CValue.USER_STUTYPE_B;
                    else
                        head.STU_TYPE = CValue.USER_STUTYPE_Y;
                    head.XY = stuInfo.COLLEGE;
                    head.ZY = stuInfo.MAJOR;
                    head.GRADE = stuInfo.EDULENTH;
                    head.CLASS_CODE = stuInfo.CLASS;
                    head.STU_IDCARDNO = stuInfo.IDCARDNO;
                    head.STU_BANKCODE = StuHandleClass.getInstance().ByStuNoGetBankCode(head.STU_NUMBER);

                    #endregion 保存学生信息

                    var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_apply_head>("Shoolar_apply_headInsertTransaction");
                    inserttrcn.EntityList.Add(head);
                    result = inserttrcn.Commit();
                    if (result)
                    {
                        #region 同步其他信息数据

                        //ZZ 20171125 新增：同步学生其他信息，因为在保存之前这些数据是还没有录入的 可以直接同步

                        #region 家庭情况

                        string strSynchroMsg = string.Empty;
                        ProjectApplyHandleClass.getInstance().InsertInto_apply_family(head.SEQ_NO, out strSynchroMsg);
                        if (strSynchroMsg.Length > 0)
                        {
                            LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请保存时，同步家庭情况出错：" + strSynchroMsg);
                        }

                        #endregion 家庭情况

                        #region 学习情况

                        ProjectApplyHandleClass.getInstance().InsertInto_apply_score(head.SEQ_NO, out strSynchroMsg);
                        if (strSynchroMsg.Length > 0)
                        {
                            LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请保存时，同步学习情况出错：" + strSynchroMsg);
                        }

                        #endregion 学习情况

                        #region 获奖情况

                        ProjectApplyHandleClass.getInstance().InsertInto_apply_reward(head.SEQ_NO, out strSynchroMsg);
                        if (strSynchroMsg.Length > 0)
                        {
                            LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请保存时，同步获奖情况出错：" + strSynchroMsg);
                        }

                        #endregion 获奖情况

                        #endregion 同步其他信息数据
                    }
                }
                else//修改
                {
                    head.OID = Post("hidOid");
                    ds.RetrieveObject(head);
                    GetPageValue(head);
                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Shoolar_apply_head>("Shoolar_apply_headUpdateTransaction", user.User_Name);
                    result = updatetrcn.Commit(head);
                }

                if (result)
                {
                    StringBuilder json = new StringBuilder();//用来存放Json的
                    json.Append("{");
                    json.Append(Json.StringToJson(head.OID, "OID"));
                    json.Append(",");
                    json.Append(Json.StringToJson(head.SEQ_NO, "SEQ_NO"));
                    json.Append(",");
                    json.Append(Json.StringToJson(head.PROJECT_SEQ_NO, "PROJECT_SEQ_NO"));
                    json.Append("}");
                    return json.ToString();
                }//保存成功 返回JSON
                else
                    return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保存奖助申请，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #region 获得页面数据

        /// <summary>
        /// 获得页面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetPageValue(Shoolar_apply_head model)
        {
            //录入信息
            model.POST_INFO = Post("POST_INFO");
            model.REWARD_FLAG = Post("REWARD_FLAG");
            model.STUDY_LEVEL = Post("STUDY_LEVEL");
            model.TRAIN_TYPE = Post("TRAIN_TYPE");
            model.HARD_FOR = Post("HARD_FOR");
            model.BASIC_UNIT = Post("BASIC_UNIT");
            //公共字段
            model.DECL_TIME = GetDateLongFormater();
            model.OP_CODE = user.User_Id;
            model.OP_NAME = user.User_Name;
            model.OP_TIME = GetDateLongFormater();
        }

        #endregion 获得页面数据

        #endregion 保存数据

        #region 判断是否满足提交条件

        /// <summary>
        /// 判断是否满足提交条件
        /// </summary>
        /// <returns></returns>
        private string ChkIsCanSubmit()
        {
            try
            {
                #region 基础校验

                if (string.IsNullOrEmpty(Get("id")))
                    return "请先保存数据之后再进行提交！";
                Shoolar_apply_head head = new Shoolar_apply_head();
                head.OID = Get("id");
                ds.RetrieveObject(head);
                if (head == null)
                    return "读取奖助申请信息出错,不允许提交！";

                #endregion 基础校验

                //20171121 ZZ 新增：在提交之前再次进行一次申请条件校验（人数不用放在这里校验，还是到院级审批）

                #region 申请条件校验

                Basic_stu_info stu_info = StuHandleClass.getInstance().GetStuInfo_Obj(head.STU_NUMBER);
                Shoolar_project_head project_head = ProjectSettingHandleClass.getInstance().GetProjectHead(head.PROJECT_SEQ_NO);
                if (stu_info == null || project_head == null)
                    return "删除失败，原因：学生信息为空或者奖助项目信息为空！";

                string strMsg = string.Empty;

                #region 项目限制条件

                if (!ProjectApplyHandleClass.getInstance().CheckProjectLimit(stu_info, project_head, out strMsg))
                {
                    return strMsg;
                }

                #endregion 项目限制条件

                #region 不可兼得条件

                if (!ProjectApplyHandleClass.getInstance().CheckProjectNotBoth(stu_info, project_head, out strMsg))
                {
                    return strMsg;
                }

                #endregion 不可兼得条件

                #endregion 申请条件校验

                #region 参数设置

                Dictionary<string, string> param = new Dictionary<string, string>();
                param.Add("SEQ_NO", head.SEQ_NO);
                Dictionary<string, string> param_file = new Dictionary<string, string>();
                param_file.Add("SEQ_NO", head.SEQ_NO);
                param_file.Add("FILE_TYPE != '6' ", string.Empty);//附件
                Dictionary<string, string> param_file_photo = new Dictionary<string, string>();
                param_file_photo.Add("SEQ_NO", head.SEQ_NO);
                param_file_photo.Add("FILE_TYPE = '6' ", string.Empty);//附件：个人生活照
                Shoolar_apply_txt txt = ProjectApplyHandleClass.getInstance().GetTxtInfo(head.SEQ_NO);
                List<Shoolar_apply_reward> rewardList = ProjectApplyHandleClass.getInstance().GetRewardListInfo(param);
                //系统限制条件改为，本科生限制不变（需填写4-21门），研究生不限制填写条数。
                List<Shoolar_apply_study_list> studyList = ProjectApplyHandleClass.getInstance().GetStudyListInfo(param);
                List<Shoolar_apply_family_list> familyList = ProjectApplyHandleClass.getInstance().GetFamilyListInfo(param);
                List<Shoolar_apply_file> fileList = ProjectApplyHandleClass.getInstance().GetFileListInfo(param_file);
                //国奖和三好学生标兵需要在系统上传生活照，学校宣传用。
                List<Shoolar_apply_file> fileList_photo = ProjectApplyHandleClass.getInstance().GetFileListInfo(param_file_photo);

                #endregion 参数设置

                return ByProjectTypeCheckInfo(head, txt, rewardList, studyList, familyList, fileList, fileList_photo);
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "判断是否满足奖助申请提交条件，出错：" + ex.ToString());
                return "是否满足提交条件校验出现异常！";
            }
        }

        /// <summary>
        /// 通过奖助类型判断检查内容
        /// </summary>
        /// <param name="strProjectType"></param>
        /// <param name="txt"></param>
        /// <param name="rewardList"></param>
        /// <returns></returns>
        private string ByProjectTypeCheckInfo(Shoolar_apply_head head, Shoolar_apply_txt txt, List<Shoolar_apply_reward> rewardList, List<Shoolar_apply_study_list> studyList, List<Shoolar_apply_family_list> familyList, List<Shoolar_apply_file> fileList, List<Shoolar_apply_file> fileList_photo)
        {
            string strResult = string.Empty;
            switch (head.PROJECT_TYPE)
            {
                case "COUNTRY_B"://国家奖学金（本科）：表11+1,11+2
                    strResult = Check_11(txt, fileList, fileList_photo);
                    break;

                case "COUNTRY_ENCOUR"://国家励志奖学金：表12
                case "AREA_GOV"://自治区人民政府奖学金：表15
                    strResult = Check_12_15(head, txt, studyList, familyList);
                    break;

                case "COUNTRY_FIRST"://国家一等助学金：表13
                case "COUNTRY_SECOND"://国家二等助学金：表14
                case "SOCIETY_OFFER"://社会捐资类奖学金：表16
                    strResult = Check_13_14_16(head, txt, studyList, familyList);
                    break;

                case "SCHOOL_GOOD"://三好学生：表17+1
                case "SCHOOL_MODEL"://三好学生标兵：表17+1,17+2,17+3
                    strResult = Check_17(head, txt, studyList, fileList, fileList_photo);
                    break;

                case "SCHOOL_SINGLE"://单项奖学金：表18
                    strResult = Check_18(txt);
                    break;

                case "COUNTRY_YP"://国家奖学金（研究生）：表19+1,19+2
                case "COUNTRY_STUDY"://国家学业奖学金：表20
                case "SCHOOL_NOTCOUNTRY"://非学校级奖学金：表21
                case "SOCIETY_NOCOUNTRY"://非社会级奖学金：表21
                    strResult = Check_19_20_21(head, txt, studyList, fileList, fileList_photo);
                    break;

                default:
                    break;
            }
            return strResult;
        }

        /// <summary>
        /// COUNTRY_B 国家奖学金（本科）：表11+1,11+2
        /// </summary>
        /// <param name="txt"></param>
        /// <returns></returns>
        private string Check_11(Shoolar_apply_txt txt, List<Shoolar_apply_file> fileList, List<Shoolar_apply_file> fileList_photo)
        {
            #region 校验“申请理由”字数

            if (txt == null)
                return "不满足提交条件：申请理由字数太少！";

            if (txt.APPLY_REASON.Length == 0)
                return "不满足提交条件：申请理由字数太少！";

            #endregion 校验“申请理由”字数

            #region 校验附件

            if (fileList == null)
                return "不满足提交条件：未上传附件！";
            if (fileList.Count == 0)
                return "不满足提交条件：未上传附件！";

            #endregion 校验附件

            #region 校验个人生活照

            if (fileList_photo == null)
                return "不满足提交条件：未上传个人生活照附件！";
            if (fileList_photo.Count == 0)
                return "不满足提交条件：未上传个人生活照附件！";

            #endregion 校验个人生活照

            return string.Empty;
        }

        /// <summary>
        /// COUNTRY_ENCOUR 国家励志奖学金：表12
        /// AREA_GOV 自治区人民政府奖学金：表15
        /// </summary>
        /// <param name="txt"></param>
        /// <param name="rewardList"></param>
        /// <returns></returns>
        private string Check_12_15(Shoolar_apply_head head, Shoolar_apply_txt txt, List<Shoolar_apply_study_list> studyList, List<Shoolar_apply_family_list> familyList)
        {
            #region 校验“申请理由”字数

            if (txt == null)
                return "不满足提交条件：申请理由字数太少！";

            if (txt.APPLY_REASON.Length < 200)
                return "不满足提交条件：申请理由字数太少！";

            #endregion 校验“申请理由”字数

            #region 校验科目成绩（需填写）

            if (head.STU_TYPE.Equals(CValue.USER_STUTYPE_B))
            {
                if (studyList == null)
                    return "不满足提交条件：科目成绩未填写！";
                if (studyList.Count == 0)
                    return "不满足提交条件：科目成绩未填写！";

                //ZZ 20171026 新增：成绩设至少填4项，最多21项，样板表格设置的是一列7行，共三列。
                if (studyList.Count < 4 || studyList.Count > 21)
                    return "不满足提交条件：科目成绩至少填4项，最多21项！";
            }

            #endregion 校验科目成绩（需填写）

            #region 校验家庭成员

            if (familyList == null)
                return "不满足提交条件：家庭成员未填写！";

            if (familyList.Count <= 0)
                return "不满足提交条件：家庭成员未填写！";

            #endregion 校验家庭成员

            return string.Empty;
        }

        /// <summary>
        /// COUNTRY_FIRST 国家一等助学金：表13
        /// COUNTRY_SECOND 国家二等助学金：表14
        /// SOCIETY_OFFER 社会捐资类奖学金：表16
        /// </summary>
        /// <param name="txt"></param>
        /// <param name="rewardList"></param>
        /// <returns></returns>
        private string Check_13_14_16(Shoolar_apply_head head, Shoolar_apply_txt txt, List<Shoolar_apply_study_list> studyList, List<Shoolar_apply_family_list> familyList)
        {
            #region 校验“申请理由”字数

            if (txt == null)
                return "不满足提交条件：申请理由字数太少！";

            if (txt.APPLY_REASON.Length < 200)
                return "不满足提交条件：申请理由字数太少！";

            #endregion 校验“申请理由”字数

            #region 校验家庭成员

            if (familyList == null)
                return "不满足提交条件：家庭成员未填写！";

            if (familyList.Count <= 0)
                return "不满足提交条件：家庭成员未填写！";

            #endregion 校验家庭成员

            #region 校验科目成绩（需填写）

            if (head.PROJECT_TYPE.Equals("SOCIETY_OFFER"))
            {
                if (head.STU_TYPE.Equals(CValue.USER_STUTYPE_B))
                {
                    if (studyList == null)
                        return "不满足提交条件：科目成绩未填写！";
                    if (studyList.Count == 0)
                        return "不满足提交条件：科目成绩未填写！";

                    //ZZ 20171026 新增：成绩设至少填4项，最多21项，样板表格设置的是一列7行，共三列。
                    if (studyList.Count < 4 || studyList.Count > 21)
                        return "不满足提交条件：科目成绩至少填4项，最多21项！";
                }
            }

            #endregion 校验科目成绩（需填写）

            return string.Empty;
        }

        /// <summary>
        /// SCHOOL_GOOD 三好学生：表17+1
        /// SCHOOL_MODEL 三好学生标兵：表17+1,17+2,17+3
        /// </summary>
        /// <param name="txt"></param>
        /// <param name="rewardList"></param>
        /// <returns></returns>
        private string Check_17(Shoolar_apply_head head, Shoolar_apply_txt txt, List<Shoolar_apply_study_list> studyList, List<Shoolar_apply_file> fileList, List<Shoolar_apply_file> fileList_photo)
        {
            #region 校验“政治思想、纪律、体育锻炼表现”字数

            if (txt == null)
                return "不满足提交条件：政治思想、纪律、体育锻炼表现字数太少！";

            if (txt.APPLY_REASON.Length < 200)
                return "不满足提交条件：政治思想、纪律、体育锻炼表现字数太少！";

            #endregion 校验“政治思想、纪律、体育锻炼表现”字数

            #region 校验科目成绩（需填写）

            if (head.STU_TYPE.Equals(CValue.USER_STUTYPE_B))
            {
                if (studyList == null)
                    return "不满足提交条件：科目成绩未填写！";
                if (studyList.Count == 0)
                    return "不满足提交条件：科目成绩未填写！";

                //ZZ 20171026 新增：成绩设至少填4项，最多21项，样板表格设置的是一列7行，共三列。
                if (studyList.Count < 4 || studyList.Count > 21)
                    return "不满足提交条件：科目成绩至少填4项，最多21项！";
            }

            #endregion 校验科目成绩（需填写）

            if (head.PROJECT_TYPE.Equals("SCHOOL_MODEL"))
            {
                #region 校验附件

                if (fileList == null)
                    return "不满足提交条件：未上传附件！";
                if (fileList.Count == 0)
                    return "不满足提交条件：未上传附件！";

                #endregion 校验附件

                #region 校验个人生活照

                if (fileList_photo == null)
                    return "不满足提交条件：未上传个人生活照附件！";
                if (fileList_photo.Count == 0)
                    return "不满足提交条件：未上传个人生活照附件！";

                #endregion 校验个人生活照

                //ZZ20171026 新增：先进事迹 字数校验

                #region 校验先进事迹

                if (txt.MOTTO.Length < 0)
                    return "不满足提交条件：人生格言字数太少！";
                if (txt.TEACHER_INFO.Length < 0)
                    return "不满足提交条件：师长点评字数太少！";
                if (txt.MODEL_INFO.Length < 1000)
                    return "不满足提交条件：事迹正文字数太少！";

                #endregion 校验先进事迹
            }

            return string.Empty;
        }

        /// <summary>
        /// SCHOOL_SINGLE 单项奖学金：表18
        /// </summary>
        /// <param name="txt"></param>
        /// <param name="rewardList"></param>
        /// <returns></returns>
        private string Check_18(Shoolar_apply_txt txt)
        {
            #region 校验“个人突出事迹”字数

            if (txt == null)
                return "不满足提交条件：个人突出事迹字数太少！";

            if (txt.APPLY_REASON.Length < 150)
                return "不满足提交条件：个人突出事迹字数太少！";

            #endregion 校验“个人突出事迹”字数

            return string.Empty;
        }

        /// <summary>
        /// COUNTRY_YP 国家奖学金（研究生）：表19+1,19+2
        /// COUNTRY_STUDY 国家学业奖学金：表20
        /// SCHOOL_NOTCOUNTRY 非学校级奖学金：表21
        /// SOCIETY_NOCOUNTRY 非社会级奖学金：表21
        /// </summary>
        /// <param name="txt"></param>
        /// <param name="rewardList"></param>
        /// <returns></returns>
        private string Check_19_20_21(Shoolar_apply_head head, Shoolar_apply_txt txt, List<Shoolar_apply_study_list> studyList, List<Shoolar_apply_file> fileList, List<Shoolar_apply_file> fileList_photo)
        {
            #region 校验“申请理由”字数

            if (txt == null)
                return "不满足提交条件：申请理由字数太少！";

            if (txt.APPLY_REASON.Length < 200)
                return "不满足提交条件：申请理由字数太少！";

            #endregion 校验“申请理由”字数

            #region 校验科目成绩（需填写）

            if (head.STU_TYPE.Equals(CValue.USER_STUTYPE_B))
            {
                if (studyList == null)
                    return "不满足提交条件：科目成绩未填写！";

                if (studyList.Count == 0)
                    return "不满足提交条件：科目成绩未填写！";

                //ZZ 20171026 新增：成绩设至少填4项，最多21项，样板表格设置的是一列7行，共三列。
                if (studyList.Count < 4 || studyList.Count > 21)
                    return "不满足提交条件：科目成绩至少填4项，最多21项！";
            }

            #endregion 校验科目成绩（需填写）

            if (head.PROJECT_TYPE.Equals("COUNTRY_YP"))
            {
                #region 校验附件

                if (fileList == null)
                    return "不满足提交条件：未上传附件！";

                if (fileList.Count == 0)
                    return "不满足提交条件：未上传附件！";

                #endregion 校验附件

                #region 校验个人生活照

                if (fileList_photo == null)
                    return "不满足提交条件：未上传个人生活照附件！";
                if (fileList_photo.Count == 0)
                    return "不满足提交条件：未上传个人生活照附件！";

                #endregion 校验个人生活照
            }
            return string.Empty;
        }

        #endregion 判断是否满足提交条件

        #region 提交数据

        /// <summary>
        /// 提交数据
        /// </summary>
        /// <returns></returns>
        private string SubmitData()
        {
            try
            {
                #region 基础校验

                if (string.IsNullOrEmpty(Get("id")))
                    return "请先保存数据之后再进行提交！";
                Shoolar_apply_head head = new Shoolar_apply_head();
                head.OID = Get("id");
                ds.RetrieveObject(head);
                if (head == null)
                    return "读取奖助申请信息出错,不允许提交！";

                #endregion 基础校验

                string strMsg = string.Empty;
                string strOpNotes = string.Format("提交奖助申请操作");
                if (!WKF_ExternalInterface.getInstance().WKF_BusDeclare(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, strOpNotes, out strMsg))
                    return strMsg;

                #region 往信息核对表中插入一条记录

                //首先判断是否已经存在数据，已经存在不需要再次插入
                string strSql = string.Format("SELECT COUNT(1) AS COUNT_NUM FROM SHOOLAR_APPLY_CHECK WHERE SEQ_NO = '{0}' ", head.SEQ_NO);
                int nCount = cod.ChangeInt(ds.ExecuteTxtScalar(strSql).ToString());
                if (nCount == 0)
                {
                    //提交成功之后，往信息核对表中插入一条记录
                    ProjectCheckHandleClass.getInstance().InsertIntoCheckInfo(head.SEQ_NO, head.STU_IDCARDNO, head.STU_BANKCODE);
                }

                #endregion 往信息核对表中插入一条记录

                #region 申请时，插入一条文档编号

                ComHandleClass.getInstance().InsertIntoBasicStuWordNo(head.STU_NUMBER, head.PROJECT_YEAR);

                #endregion 申请时，插入一条文档编号

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "提交奖助申请信息，出错：" + ex.ToString());
                return "提交失败！";
            }
        }

        #endregion 提交数据

        #region 获得默认审核信息

        /// <summary>
        /// 获得默认审核信息
        /// </summary>
        /// <returns></returns>
        private string GetApproveDefaultInfo()
        {
            #region 获得奖助申请信息

            if (string.IsNullOrEmpty(Get("id")))
                return "奖助申请主键不能为空！";
            Shoolar_apply_head head = new Shoolar_apply_head();
            head.OID = Get("id").ToString();
            ds.RetrieveObject(head);
            if (head == null)
                return "奖助申请信息为空！";

            #endregion 获得奖助申请信息

            return ProjectApplyHandleClass.getInstance().GetApproveDefaultInfo(head.PROJECT_NAME, head.PROJECT_TYPE, user.User_Role);
        }

        #endregion 获得默认审核信息

        #region 提交审核信息

        /// <summary>
        /// 提交审核信息
        /// </summary>
        /// <returns></returns>
        private string ApproveData()
        {
            try
            {
                #region 获得奖助申请信息

                if (string.IsNullOrEmpty(Post("hidOid_ForApprove")))
                    return "奖助申请主键不能为空！";
                Shoolar_apply_head head = new Shoolar_apply_head();
                head.OID = Post("hidOid_ForApprove").ToString();
                ds.RetrieveObject(head);
                if (head == null)
                    return "奖助申请信息为空！";
                if (head.DECLARE_TYPE != CValue.DECLARE_TYPE_D)
                    return "该状态不允许进行操作！";

                #endregion 获得奖助申请信息

                #region 是否满足提交审核条件

                string strMsg = string.Empty;
                strMsg = ChkApproveData(head.PROJECT_TYPE, Post("approveMsg"), Post("comMsg"));
                if (strMsg.Length > 0)
                    return strMsg;

                #endregion 是否满足提交审核条件

                #region 过了项目申请结束时间，学生、辅导员、学院都不能操作，校级可以审批操作

                Shoolar_project_head project_head = ProjectSettingHandleClass.getInstance().GetProjectHead(head.PROJECT_SEQ_NO);
                if (project_head == null)
                    return "项目信息为空，不允许进行操作！";
                //ZZ 20171221 新增：过了项目申请结束时间，学生、辅导员、学院都不能操作，校级可以审批操作
                if (!ProjectSettingHandleClass.getInstance().CheckIsFitApplyDate(project_head.APPLY_END, user.User_Role))
                    return "该项目申请结束日期已过，不允许进行操作！";

                #endregion 过了项目申请结束时间，学生、辅导员、学院都不能操作，校级可以审批操作

                #region 申请人数限制放在院级审核的时候，并且再次用条件进行校验

                if (user.User_Role.Equals(CValue.ROLE_TYPE_Y) && Post("approveType").Equals("P"))
                {
                    //ZZ 20171114 新增：申请人数限制放在院级审核的时候，并且再次用条件进行校验
                    Basic_stu_info stu_info = StuHandleClass.getInstance().GetStuInfo_Obj(head.STU_NUMBER);
                    if (stu_info == null || project_head == null)
                        return "审核失败：学生信息或者奖助项目信息不能为空！";

                    #region 再次校验申请条件

                    //再次校验申请条件
                    if (!ProjectApplyHandleClass.getInstance().CheckProjectLimit(stu_info, project_head, out strMsg))
                    {
                        //发送消息
                        Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                        dicAccpter.Add(head.STU_NUMBER, head.STU_NAME);
                        string strMsgContent = string.Format("您好！您的{0}奖助申请不符合该项目申请条件（{1}），该奖助申请数据已被退回预录入状态，望您悉知，谢谢!", head.PROJECT_NAME, strMsg);
                        string strMessageMsg = string.Empty;
                        MessgeHandleClass.getInstance().SendMessge("M", strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMessageMsg);
                        ////记录日志（屏蔽：不删除之后 不需要记录操作日志，因为已经写入了 审批流程日志中）
                        //LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "奖助院级审核", CValue.LOG_ACTION_TYPE_6, CValue.LOG_RECORD_TYPE_1, string.Format("删除：学号{0}姓名{1} 不满足奖助[{2}]申请条件：{3}", head.STU_NUMBER, head.STU_NAME, head.PROJECT_NAME, strMsg), user.User_Id, user.User_Name, user.UserLoginIP);
                        //20171121 ZZ 屏蔽：物理删除数据不合理，修改成 变成预录入
                        //删除数据
                        //ProjectApplyHandleClass.getInstance().DeleteProjectApplyData(head.SEQ_NO);
                        ProjectApplyHandleClass.getInstance().TurnBackApplyToRetchannelA0000(head.SEQ_NO, CValue.STEP_D2, CValue.RET_CHANNEL_D2020, CValue.ROLE_TYPE_Y, user.User_Name, strMsg);
                        return "由于该奖助申请不满足申请条件，已退回预录入状态，原因：" + strMsg;
                    }
                    if (!ProjectApplyHandleClass.getInstance().CheckProjectNotBoth(stu_info, project_head, out strMsg))
                    {
                        //发送消息
                        Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                        dicAccpter.Add(head.STU_NUMBER, head.STU_NAME);
                        string strMsgContent = string.Format("您好！您的{0}奖助申请不符合该项目申请条件（{1}），该奖助申请数据已被退回预录入状态，望您悉知，谢谢!", head.PROJECT_NAME, strMsg);
                        string strMessageMsg = string.Empty;
                        MessgeHandleClass.getInstance().SendMessge("M", strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMessageMsg);
                        ////记录日志（屏蔽：不删除之后 不需要记录操作日志，因为已经写入了 审批流程日志中）
                        //LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "奖助院级审核", CValue.LOG_ACTION_TYPE_6, CValue.LOG_RECORD_TYPE_1, string.Format("删除：学号{0}姓名{1} 不满足奖助[{2}]申请条件：{3}", head.STU_NUMBER, head.STU_NAME, head.PROJECT_NAME, strMsg), user.User_Id, user.User_Name, user.UserLoginIP);
                        //20171121 ZZ 屏蔽：物理删除数据不合理，修改成 变成预录入
                        //删除数据
                        //ProjectApplyHandleClass.getInstance().DeleteProjectApplyData(head.SEQ_NO);
                        ProjectApplyHandleClass.getInstance().TurnBackApplyToRetchannelA0000(head.SEQ_NO, CValue.STEP_D2, CValue.RET_CHANNEL_D2020, CValue.ROLE_TYPE_Y, user.User_Name, strMsg);
                        return "由于该奖助申请不满足申请条件，已退回预录入状态，原因：" + strMsg;
                    }

                    #endregion 再次校验申请条件

                    #region 申请人数已满

                    //由于审核流转需要1秒，等待一秒之后再查询更准确。
                    Thread.Sleep(1000);
                    //申请人数已满
                    if (!ProjectApplyHandleClass.getInstance().CheckProjectNum(stu_info, project_head, out strMsg))
                    {
                        LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "奖助院级审核", CValue.LOG_ACTION_TYPE_6, CValue.LOG_RECORD_TYPE_1, string.Format("学号{0}姓名{1} 不满足奖助[{2}]申请条件：{3}", head.STU_NUMBER, head.STU_NAME, head.PROJECT_NAME, strMsg), user.User_Id, user.User_Name, user.UserLoginIP);
                        Dictionary<string, string> param_projectnum = new Dictionary<string, string>();
                        param_projectnum.Add("SEQ_NO", project_head.SEQ_NO);
                        param_projectnum.Add("XY", stu_info.COLLEGE);
                        List<Shoolar_project_num> projectNum = ProjectSettingHandleClass.getInstance().GetProjectNum(param_projectnum);
                        return string.Format("审核失败，原因：已超出学院所获得的该项目名额人数{0}人！", projectNum[0].APPLY_NUM);
                    }

                    #endregion 申请人数已满
                }

                #endregion 申请人数限制放在院级审核的时候，并且再次用条件进行校验

                #region 提交审核信息

                bool bFlag = WKF_ExternalInterface.getInstance().WKF_Audit(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, Post("approveType"), Post("approveMsg"), out strMsg);
                if (bFlag)
                {
                    ProjectApplyHandleClass.getInstance().ApproveData_UpTxt(head.SEQ_NO, head.PROJECT_TYPE, user.User_Role, Post("approveMsg"), Post("comMsg"));

                    #region 审批通过之后给申请人发送信息

                    //审批通过之后给申请人发送信息

                    string strFinalPosCode = WKF_AuditHandleCLass.getInstance().GetFinalPosCode(head.DOC_TYPE);
                    if (!string.IsNullOrEmpty(strFinalPosCode))
                    {
                        if (strFinalPosCode == user.User_Role)
                        {
                            string strMsgContent = string.Empty;
                            if (Post("approveType").ToString().Equals("P"))
                                strMsgContent = string.Format("奖助申请：{0}审批通过", head.PROJECT_NAME);
                            else
                                strMsgContent = string.Format("奖助申请：{0}审批不通过，审批意见：{1}", head.PROJECT_NAME, Post("approveMsg"));
                            Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                            dicAccpter.Add(head.STU_NUMBER, head.STU_NAME);
                            MessgeHandleClass.getInstance().SendMessge("M", strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMsg);
                        }
                    }

                    #endregion 审批通过之后给申请人发送信息

                    return string.Empty;
                }
                else
                {
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, strMsg);
                    return "提交审核信息失败！";
                }

                #endregion 提交审核信息
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助审核提交审核信息失败：" + ex.ToString());
                return "提交审核信息失败！";
            }
        }

        #region 是否满足提交审核条件

        /// <summary>
        /// 是否满足提交审核条件
        /// </summary>
        /// <returns></returns>
        private string ChkApproveData(string strProjectType, string strReason, string strReason2)
        {
            if (strReason.Length == 0)
                return "审核意见必填！";

            if (strProjectType == "COUNTRY_B"
                || strProjectType == "COUNTRY_ENCOUR" || strProjectType == "AREA_GOV"
                || strProjectType == "SOCIETY_OFFER")
            {
                if (user.User_Role.Equals("F"))//辅导员
                {
                    if (strReason.Length < 90)
                        return "审核意见字数太少！";
                }
            }

            if (strProjectType == "COUNTRY_YP"
            || strProjectType == "COUNTRY_STUDY"
            || strProjectType == "SCHOOL_NOTCOUNTRY"
            || strProjectType == "SOCIETY_NOCOUNTRY")
            {
                if (user.User_Role.Equals("X"))//学院
                {
                    if (strReason2.Length == 0)
                        return "评审意见必填！";
                }
            }
            return string.Empty;
        }

        #endregion 是否满足提交审核条件

        #endregion 提交审核信息
    }
}