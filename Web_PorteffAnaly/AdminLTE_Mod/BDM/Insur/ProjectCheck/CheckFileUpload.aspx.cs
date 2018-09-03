using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.Architecture.Factory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using serverservice;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectCheck
{
    public partial class CheckFileUpload : Main
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

        #endregion 初始化

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
                string strNoticeSave = Util.GetAppSettings("InsurFilePath");
                if (strNoticeSave.Length == 0)
                    strNoticeSave = "INSUR";
                string strArchiveDirectory = m_strUploadFile + @"\" + ComHandleClass.getInstance().ByCurrentDateGetFilePath() + @"\" + strNoticeSave;
                string strFileDirectory = @"/" + m_strUploadFileRoot + @"/" + ComHandleClass.getInstance().ByCurrentDateGetFilePath() + @"/" + strNoticeSave;
                if (!Directory.Exists(strArchiveDirectory))
                {
                    Directory.CreateDirectory(strArchiveDirectory);//创建路径
                }

                #endregion 判断是否存在该路径，不存在即创建

                #region 上传文件到服务器

                string strFileName = GetFileName(hidRelationSeqNo_File.Value, lastName);
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
                    doJavaScript(cod.GetJScript("ListRefresh", string.Empty));//刷新列表
                    string alert_msg = string.Format("{{\"content\":\"附件上传成功！\", \"duration\":2,\"type\": \"success\"}}");
                    doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
                }
            }
            catch (Exception ex)
            {
                DeleteFile(upload_file);
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保险核对：上传附件，出错：" + ex.ToString());
                string alert_msg = string.Format("{{\"content\":\"附件上传失败！\", \"duration\":2,\"type\": \"success\"}}");
                doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
            }
            finally//由于保存之后刷新界面，所以需要重新赋值
            {
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
                Insur_apply_check_file head = new Insur_apply_check_file();
                if (string.IsNullOrEmpty(hidOid_File.Value))
                {
                    head.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(head);
                    head.SEQ_NO = hidRelationSeqNo_File.Value;
                    head.FILE_TYPE = hidFile_FILE_TYPE.Value;
                    head.FILE_NAME = hidFile_FILE_NAME.Value;
                    head.FILE_SAVE_NAME = strFileName;
                    strFileDirectory = strFileDirectory.Replace(@"\", @"/");//将字符串中所有反斜杠\替换成正斜杠/
                    head.FILE_DIRECTORY = strFileDirectory;
                    var inserttrcn = ImplementFactory.GetInsertTransaction<Insur_apply_check_file>("Insur_apply_check_fileInsertTransaction");
                    inserttrcn.EntityList.Add(head);
                    res = inserttrcn.Commit();
                }
                else
                {
                    head.OID = hidOid_File.Value;
                    ds.RetrieveObject(head);
                    head.FILE_TYPE = hidFile_FILE_TYPE.Value;
                    head.FILE_NAME = hidFile_FILE_NAME.Value;
                    head.FILE_SAVE_NAME = strFileName;
                    strFileDirectory = strFileDirectory.Replace(@"\", @"/");//将字符串中所有反斜杠\替换成正斜杠/
                    head.FILE_DIRECTORY = strFileDirectory;
                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Insur_apply_check_file>("Insur_apply_check_fileUpdateTransaction", user.User_Name);
                    res = updatetrcn.Commit(head);
                }
                if (res)
                {
                    //保存核对表头的参保人员类型
                    Insur_apply_check check = InsurHandleClass.getInstance().GetApplyCheckInfo(head.SEQ_NO);
                    if (check != null)
                    {
                        ds.RetrieveObject(check);
                        check.APPLY_TYPE = hidFile_FILE_TYPE.Value;
                        ds.UpdateObject(check);
                    }
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