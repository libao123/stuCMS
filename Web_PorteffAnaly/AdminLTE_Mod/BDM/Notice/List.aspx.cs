using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;
using serverservice;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Notice
{
    public partial class List : ListBaseLoad<Notice_info>
    {
        #region 初始化

        /// <summary>
        /// 【服务器上虚拟路径的物理地址（有盘符的）】就是图片的实际存储路径
        /// </summary>
        private string m_strUploadFile = System.Web.HttpContext.Current.Server.MapPath("~/" + Util.GetAppSettings("FilePath"));
        /// <summary>
        /// 附件存储根目录
        /// </summary>
        public string m_strUploadFileRoot = Util.GetAppSettings("FilePath");
        private comdata cod = new comdata();
        public bool IsShowBtn = false;

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

        protected override SelectTransaction<Notice_info> GetSelectTransaction()
        {
            #region 只有可查阅角色可以看到相应公告

            //过滤：只有可查阅角色可以看到相应公告
            if (!user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))
            {
                StringBuilder strWhere = new StringBuilder();
                StringBuilder strWhereRole = new StringBuilder();
                string[] arrRole = user.User_Role.Split(new char[] { ',' });
                foreach (string str in arrRole)
                {
                    if (string.IsNullOrEmpty(str))
                        continue;

                    strWhereRole.AppendFormat("OR ROLEID LIKE '%{0}%' ", str);
                }
                string strResultWhere = string.Empty;
                if (strWhereRole.ToString().Length > 0)
                    strResultWhere = strWhereRole.ToString();
                if (strResultWhere.Length > 0)//去掉第一个O
                    strResultWhere = strResultWhere.TrimStart('O');
                if (strResultWhere.Length > 0)//去掉第二个R
                    strResultWhere = strResultWhere.TrimStart('R');
                if (strResultWhere.Length > 0)
                    strWhere.AppendFormat("({0})", strResultWhere);
                if (strWhere.ToString().Length > 0)
                    param.Add(strWhere.ToString(), string.Empty);
            }

            #endregion 只有可查阅角色可以看到相应公告

            return ImplementFactory.GetSelectTransaction<Notice_info>("Notice_infoSelectTransaction", param);
        }

        #endregion 初始化

        #region 界面加载

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "getlist"://获取列表
                            Response.Write(GetList());
                            Response.End();
                            break;

                        case "delete"://删除
                            Response.Write(DeleteData());
                            Response.End();
                            break;

                        case "save"://保存
                            Response.Write(Save());
                            Response.End();
                            break;

                        case "getcontent"://获得内容
                            Response.Write(GetContent());
                            Response.End();
                            break;

                        case "getnotice"://获得公告信息
                            Response.Write(GetNotice());
                            Response.End();
                            break;
                    }
                }

                if (user.User_Role.Contains("X") || user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))
                    IsShowBtn = true;
            }
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("NOTICE_TYPE")))
                where += string.Format(" AND NOTICE_TYPE = '{0}' ", Post("NOTICE_TYPE"));
            if (!string.IsNullOrEmpty(Post("TITLE")))
                where += string.Format(" AND TITLE LIKE '%{0}%' ", Post("TITLE"));
            return where;
        }

        #endregion 界面加载

        #region 输出列表信息

        /// <summary>
        /// 重载输出列表信息
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        protected override IEnumerable<ListBaseLoad<Notice_info>.NameValue> GetValue(Notice_info entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "NOTICE_TYPE", Value = entity.NOTICE_TYPE };
            yield return new NameValue() { Name = "NOTICE_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_notice_type", entity.NOTICE_TYPE) };
            yield return new NameValue() { Name = "TITLE", Value = entity.TITLE };
            yield return new NameValue() { Name = "SUB_TITLE", Value = entity.SUB_TITLE };
            yield return new NameValue() { Name = "START_TIME", Value = entity.START_TIME };
            yield return new NameValue() { Name = "END_TIME", Value = entity.END_TIME };
            yield return new NameValue() { Name = "ROLEID", Value = entity.ROLEID };
            yield return new NameValue() { Name = "SEND_CODE", Value = entity.SEND_CODE };
            yield return new NameValue() { Name = "SEND_NAME", Value = entity.SEND_NAME };
            yield return new NameValue() { Name = "SEND_TIME", Value = entity.SEND_TIME };
            yield return new NameValue() { Name = "FUNCTION_ID", Value = entity.FUNCTION_ID };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 通过传入的主键编码删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("id")))
                    return "主键为空,不允许删除操作";

                var model = new Notice_info();
                model.OID = Get("id");
                ds.RetrieveObject(model);

                bool bDel = false;
                var transaction = ImplementFactory.GetDeleteTransaction<Notice_info>("Notice_infoDeleteTransaction");
                transaction.EntityList.Add(model);
                bDel = transaction.Commit();

                if (!bDel)
                    return "删除失败！";
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "删除公告，出错：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据

        #region 保存/提交

        /// <summary>
        /// 保存/提交事件
        /// </summary>
        /// <returns></returns>
        private string Save()
        {
            try
            {
                #region 新增/修改公告

                bool bFlag = false;
                Notice_info head = new Notice_info();
                if (string.IsNullOrEmpty(Post("hidNOTICE_OID")))            //新增
                {
                    head.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(head);
                    GetFormValue(head);

                    var inserttrcn = ImplementFactory.GetInsertTransaction<Notice_info>("Notice_infoInsertTransaction", user.User_Name);
                    inserttrcn.EntityList.Add(head);
                    bFlag = inserttrcn.Commit();
                }
                else //修改
                {
                    head.OID = Post("hidNOTICE_OID");
                    ds.RetrieveObject(head);
                    GetFormValue(head);

                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Notice_info>("Notice_infoUpdateTransaction", user.User_Name);
                    bFlag = updatetrcn.Commit(head);
                }

                #endregion 新增/修改公告

                #region 发布成功之后操作

                if (bFlag)
                {
                    try
                    {
                        #region 重新更新公告内容

                        //重新更新公告内容
                        StringBuilder strTxt = new StringBuilder();
                        strTxt.AppendFormat("NOTICE_CONTENT = '{0}' ", Post("NOTICE_CONTENT"));//事迹正文
                        if (!ComHandleClass.getInstance().UpdateTextContent(head.OID, "OID", strTxt.ToString(), "NOTICE_INFO"))
                            return "保存公告内容失败！";

                        #endregion 重新更新公告内容

                        #region 奖助项目要更新公告ID

                        //奖助项目要更新公告ID
                        if (!string.IsNullOrEmpty(Request.QueryString["pro_oid"]))
                        {
                            string strUpProHead = string.Format("UPDATE SHOOLAR_PROJECT_HEAD SET NOTICE_ID = '{0}' WHERE OID = '{1}' ", head.OID, Request.QueryString["pro_oid"].ToString());
                            ds.ExecuteTxtNonQuery(strUpProHead);
                        }

                        #endregion 奖助项目要更新公告ID

                        #region 奖助核对信息要更新公告ID

                        //奖助核对信息要更新公告ID
                        if (!string.IsNullOrEmpty(Request.QueryString["pro_check_oid"]))
                        {
                            string strUpProHead = string.Format("UPDATE SHOOLAR_PROJECT_HEAD SET CHECK_NOTICE_ID = '{0}' WHERE OID = '{1}' ", head.OID, Request.QueryString["pro_check_oid"].ToString());
                            ds.ExecuteTxtNonQuery(strUpProHead);
                        }

                        #endregion 奖助核对信息要更新公告ID

                        #region 保险核对信息要更新公告ID

                        //保险核对信息要更新公告ID
                        if (!string.IsNullOrEmpty(Request.QueryString["insur_check_oid"]))
                        {
                            string strUpProHead = string.Format("UPDATE INSUR_PROJECT_HEAD SET CHECK_NOTICE_ID = '{0}' WHERE OID = '{1}' ", head.OID, Request.QueryString["insur_check_oid"].ToString());
                            ds.ExecuteTxtNonQuery(strUpProHead);
                        }

                        #endregion 保险核对信息要更新公告ID

                        #region 贷款核对信息要更新公告ID

                        //贷款核对信息要更新公告ID
                        if (!string.IsNullOrEmpty(Request.QueryString["loan_check_oid"]))
                        {
                            string strUpProHead = string.Format("UPDATE LOAN_PROJECT_HEAD SET CHECK_NOTICE_ID = '{0}' WHERE OID = '{1}' ", head.OID, Request.QueryString["loan_check_oid"].ToString());
                            ds.ExecuteTxtNonQuery(strUpProHead);
                        }

                        #endregion 贷款核对信息要更新公告ID

                        #region 困难生认定基本设置要更新公告ID（困难生申请）

                        //困难生认定基本设置要更新公告ID（困难生申请）
                        else if (!string.IsNullOrEmpty(Request.QueryString["apply_oid"]))
                        {
                            string strUpProHead = string.Format("UPDATE DST_PARAM_INFO SET APPLY_NOTICE_ID = '{0}' WHERE OID = '{1}' ", head.OID, Request.QueryString["apply_oid"].ToString());
                            ds.ExecuteTxtNonQuery(strUpProHead);
                        }

                        #endregion 困难生认定基本设置要更新公告ID（困难生申请）

                        #region 困难生认定基本设置要更新公告ID（家庭经济调查）

                        //困难生认定基本设置要更新公告ID（家庭经济调查）
                        else if (!string.IsNullOrEmpty(Request.QueryString["survey_oid"]))
                        {
                            string strUpProHead = string.Format("UPDATE DST_PARAM_INFO SET SURVEY_NOTICE_ID = '{0}' WHERE OID = '{1}' ", head.OID, Request.QueryString["survey_oid"].ToString());
                            ds.ExecuteTxtNonQuery(strUpProHead);
                        }

                        #endregion 困难生认定基本设置要更新公告ID（家庭经济调查）

                        #region 岗位申报基本设置要更新公告ID

                        else if (!string.IsNullOrEmpty(Request.QueryString["job_oid"]))
                        {
                            string strUpProHead = string.Format("UPDATE QZ_JOB_MANAGE_SET SET NOTICE_ID = '{0}' WHERE OID = '{1}' ", head.OID, Request.QueryString["job_oid"].ToString());
                            ds.ExecuteTxtNonQuery(strUpProHead);
                        }

                        #endregion 岗位申报基本设置要更新公告

                        #region 劳酬凭据基本设置要更新公告

                        else if (!string.IsNullOrEmpty(Request.QueryString["proof_oid"]))
                        {
                            string strUpProHead = string.Format("UPDATE QZ_JOB_PROOF_SET SET NOTICE_ID = '{0}' WHERE OID = '{1}' ", head.OID, Request.QueryString["proof_oid"].ToString());
                            ds.ExecuteTxtNonQuery(strUpProHead);
                        }

                        #endregion 劳酬凭据基本设置要更新公告
                    }
                    catch (Exception ex)
                    {
                        return "发布公告，出错：" + ex.ToString();
                    }
                }

                #endregion 发布成功之后操作

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "发布公告，出错：" + ex.ToString());
                return "发布公告，出错：" + ex.ToString();
            }
        }

        #endregion 保存/提交

        #region 获取页面文本

        /// <summary>
        /// 获取界面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetFormValue(Notice_info model)
        {
            #region 从奖助项目设置来

            if (!string.IsNullOrEmpty(Request.QueryString["pro_oid"]))
            {
                model.NOTICE_TYPE = CValue.NOTICE_TYPE_N;//20171015 ZZ 修改：奖助管理--项目设置，发布公告功能，所发的文章应该显示在“近期公告”模块。
                model.FUNCTION_ID = Util.GetAppSettings("ProjectApplyTreeId");//奖助申请树节点
            }

            #endregion 从奖助项目设置来

            #region 从奖助信息核对来

            else if (!string.IsNullOrEmpty(Request.QueryString["pro_check_oid"]))
            {
                model.NOTICE_TYPE = CValue.NOTICE_TYPE_N;
                model.FUNCTION_ID = Util.GetAppSettings("ProjectApplyCheckTreeId");//奖助核对树节点
            }

            #endregion 从奖助信息核对来

            #region 从保险信息核对来

            else if (!string.IsNullOrEmpty(Request.QueryString["insur_check_oid"]))
            {
                model.NOTICE_TYPE = CValue.NOTICE_TYPE_N;
                model.FUNCTION_ID = Util.GetAppSettings("InsurApplyCheckTreeId");//保险核对树节点
            }

            #endregion 从保险信息核对来

            #region 从贷款信息核对来

            else if (!string.IsNullOrEmpty(Request.QueryString["loan_check_oid"]))
            {
                model.NOTICE_TYPE = CValue.NOTICE_TYPE_N;
                model.FUNCTION_ID = Util.GetAppSettings("LoanApplyCheckTreeId");//贷款核对树节点
            }

            #endregion 从贷款信息核对来

            #region 从困难生基础设置（困难生申请开放时间）来

            else if (!string.IsNullOrEmpty(Request.QueryString["apply_oid"]))
            {
                model.NOTICE_TYPE = CValue.NOTICE_TYPE_N;
                model.FUNCTION_ID = Util.GetAppSettings("DstApplyTreeId");//困难生申请树节点
            }

            #endregion 从困难生基础设置（困难生申请开放时间）来

            #region 从困难生基础设置（家庭经济调查开放时间）来

            else if (!string.IsNullOrEmpty(Request.QueryString["survey_oid"]))
            {
                model.NOTICE_TYPE = CValue.NOTICE_TYPE_N;
                model.FUNCTION_ID = Util.GetAppSettings("DstSurveyTreeId");//家庭经济调查树节点
            }

            #endregion 从困难生基础设置（家庭经济调查开放时间）来

            #region 从岗位申报基本设置来

            else if (!string.IsNullOrEmpty(Request.QueryString["job_oid"]))
            {
                model.NOTICE_TYPE = CValue.NOTICE_TYPE_N;
                model.FUNCTION_ID = Util.GetAppSettings("QzJobTreeId");//岗位申报树节点
            }

            #endregion 从岗位申报基本设置来

            #region 从劳酬凭据基本设置来

            else if (!string.IsNullOrEmpty(Request.QueryString["proof_oid"]))
            {
                model.NOTICE_TYPE = CValue.NOTICE_TYPE_N;
                model.FUNCTION_ID = Util.GetAppSettings("QzProofTreeId");//填写劳酬凭据树节点
            }

            #endregion 从劳酬凭据基本设置来

            #region 默认

            else
            {
                model.NOTICE_TYPE = Post("NOTICE_TYPE");
                model.FUNCTION_ID = Post("FUNCTION_ID");
            }

            #endregion 默认

            model.TITLE = Post("TITLE");
            model.SUB_TITLE = Post("SUB_TITLE");
            model.START_TIME = Post("START_TIME");
            model.END_TIME = Post("END_TIME");
            model.ROLEID = Post("hidUserRoles");
            model.SEND_TIME = GetDateLongFormater();
            model.SEND_CODE = user.User_Id;
            model.SEND_NAME = user.User_Name;
        }

        #endregion 获取页面文本

        #region 获得发布内容

        /// <summary>
        /// 获得发布内容
        /// </summary>
        /// <returns></returns>
        private string GetContent()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("id")))
                    return "主键为空！";
                string strSql = string.Format("SELECT NOTICE_CONTENT FROM NOTICE_INFO WHERE OID = '{0}' ", Get("id"));
                return ds.ExecuteTxtScalar(strSql).ToString();
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        #endregion 获得发布内容

        #region 获得公告信息

        /// <summary>
        /// 获得公告信息
        /// </summary>
        /// <returns></returns>
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
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "获得公告信息，出错：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 获得公告信息

        #region 上传附件

        /// <summary>
        /// 上传按钮事件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void fileUpload_Click(object sender, EventArgs e)
        {
            string upload_file = string.Empty;
            try
            {
                #region 判断附件大小

                string FileName = fileUpload.PostedFile.FileName;
                string lastName = FileName.Substring((FileName.LastIndexOf(".") + 1)).ToLower();
                decimal limitSize_M = cod.ChangeDecimal(Util.GetAppSettings("MaxFileLength")) / 1024;//从千字节换算成兆
                decimal fileSize_KB = fileUpload.PostedFile.ContentLength / 1024;
                decimal fileSize_M = fileSize_KB / 1024;//从字节换算成兆

                #region 判断是否上传文件

                if (fileSize_M == 0)
                {
                    string alert_msg = string.Format("{{\"content\":\"请选择上传附件！\", \"duration\":2,\"type\": \"danger\"}}");
                    doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
                    return;
                }

                #endregion 判断是否上传文件

                if (limitSize_M != 0)
                {
                    if (fileSize_M > limitSize_M)
                    {
                        string alert_msg = string.Format("{{\"content\":\"附件大小不允许超过{0}兆！\", \"duration\":2,\"type\": \"danger\"}}", limitSize_M);
                        doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
                        return;
                    }
                }

                #endregion 判断附件大小

                #region 判断是否存在该路径，不存在即创建

                //附件归档目录
                string strNoticeSave = Util.GetAppSettings("NoticeFilePath");
                if (strNoticeSave.Length == 0)
                    strNoticeSave = "NOTICE";
                string strArchiveDirectory = m_strUploadFile + @"\" + ComHandleClass.getInstance().ByCurrentDateGetFilePath() + @"\" + strNoticeSave;
                string strFileDirectory = @"/" + m_strUploadFileRoot + @"/" + ComHandleClass.getInstance().ByCurrentDateGetFilePath() + @"/" + strNoticeSave;
                if (!Directory.Exists(strArchiveDirectory))
                {
                    Directory.CreateDirectory(strArchiveDirectory);//创建路径
                }

                #endregion 判断是否存在该路径，不存在即创建

                #region 上传文件到服务器

                string strFileName = GetFileName(hidNoticeOid_File.Value, lastName);
                upload_file = strArchiveDirectory + @"\" + strFileName;//取出服务器虚拟路径,存储上传文件
                //如果修改时，修改了附件，把原先的附件删除
                if (fileUpload.PostedFile.ContentLength > 0)
                {
                    DeleteFile(upload_file);
                }
                fileUpload.PostedFile.SaveAs(upload_file);//开始上传文件

                #endregion 上传文件到服务器

                if (SaveFile(strFileName, strFileDirectory))
                {
                    string alert_msg = string.Format("{{\"content\":\"附件上传成功！\", \"duration\":2,\"type\": \"success\"}}");
                    doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
                }
            }
            catch (Exception ex)
            {
                DeleteFile(upload_file);
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请：上传附件，出错：" + ex.ToString());
                string alert_msg = string.Format("{{\"content\":\"附件上传失败！\", \"duration\":2,\"type\": \"success\"}}");
                doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
            }
            finally//由于保存之后刷新界面，所以需要重新赋值
            {
                if (user.User_Role.Contains("X") || user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))
                    IsShowBtn = true;
                else
                    IsShowBtn = false;
            }
        }

        #region 上传文件公共方法

        /// <summary>
        /// 附件名称定义
        /// </summary>
        /// <param name="strSeq_No"></param>
        /// <param name="strLastName"></param>
        /// <returns></returns>
        protected string GetFileName(string strSeq_No, string strLastName)
        {
            string strFileName = (strSeq_No + DateTime.Now.ToString("yyyyMMddHHmmss") + "." + strLastName).Trim();
            return strFileName;
        }

        /// <summary>
        /// 保存附件
        /// </summary>
        /// <param name="strFileName"></param>
        /// <param name="strFileDirectory"></param>
        /// <returns></returns>
        protected bool SaveFile(string strFileName, string strFileDirectory)
        {
            try
            {
                bool res = false;
                Notice_info_file head = new Notice_info_file();
                if (string.IsNullOrEmpty(hidOid_File.Value))
                {
                    head.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(head);
                    head.NOTICE_OID = hidNoticeOid_File.Value;
                    head.FILE_NAME = hidFile_FILE_NAME.Value;
                    head.FILE_SAVE_NAME = strFileName;
                    strFileDirectory = strFileDirectory.Replace(@"\", @"/");//将字符串中所有反斜杠\替换成正斜杠/
                    head.FILE_DIRECTORY = strFileDirectory;
                    var inserttrcn = ImplementFactory.GetInsertTransaction<Notice_info_file>("Notice_info_fileInsertTransaction");
                    inserttrcn.EntityList.Add(head);
                    res = inserttrcn.Commit();
                }
                else
                {
                    head.OID = hidOid_File.Value;
                    ds.RetrieveObject(head);
                    head.FILE_NAME = hidFile_FILE_NAME.Value;
                    head.FILE_SAVE_NAME = strFileName;
                    strFileDirectory = strFileDirectory.Replace(@"\", @"/");//将字符串中所有反斜杠\替换成正斜杠/
                    head.FILE_DIRECTORY = strFileDirectory;
                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Notice_info_file>("Notice_info_fileUpdateTransaction", user.User_Name);
                    res = updatetrcn.Commit(head);
                }
                return res;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "公告附件上传失败：" + ex.ToString());
                return false;
            }
        }

        /// <summary>
        /// 保存信息不成功，同时删除上传的文件
        /// </summary>
        /// <param name="strPhotoPath"></param>
        protected void DeleteFile(string strFilePath)
        {
            if (File.Exists(strFilePath))
            {
                FileInfo fi = new FileInfo(strFilePath);
                if (fi.Attributes.ToString().IndexOf("ReadOnly") != -1)
                    fi.Attributes = FileAttributes.Normal;

                File.Delete(strFilePath);
            }
        }

        #endregion 上传文件公共方法

        #endregion 上传附件
    }
}