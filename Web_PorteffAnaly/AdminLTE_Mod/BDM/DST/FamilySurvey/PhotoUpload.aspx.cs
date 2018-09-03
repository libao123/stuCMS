using System;
using System.IO;
using commonclass;
using HQ.Architecture.Factory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.FamilySurvey
{
    public partial class PhotoUpload : Main
    {
        #region 初始化定义

        public comdata cod = new comdata();
        private ComTranClass comTran = new ComTranClass();
        public Dst_family_situa head = new Dst_family_situa();
        public Dst_family_photo photo = new Dst_family_photo();

        /// <summary>
        /// 【服务器上虚拟路径的物理地址（有盘符的）】就是图片的实际存储路径（注：PhotoPath配置在web.config中）
        /// </summary>
        private string m_strUploadPhoto = System.Web.HttpContext.Current.Server.MapPath("~/" + Util.GetAppSettings("PhotoPath"));

        /// <summary>
        /// 附件存储根目录
        /// </summary>
        public string m_strUploadPhotoRoot = Util.GetAppSettings("PhotoPath");

        #endregion 初始化定义

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        #region 上传图片按钮

        protected void UploadBtn_Click(object sender, EventArgs e)
        {
            object o = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM DST_FAMILY_PHOTO WHERE SEQ_NO='{0}'", Get("seq_no")));
            if (o != null && o.ToString().Length > 0)
            {
                if (Int32.Parse(o.ToString()) == 30)
                {
                    doJavaScript(cod.GetJScript("modiFailExcel", "'上传图片数量不能超过30张！'"));
                    return;
                }
            }

            string seq_no = Get("seq_no");

            #region 判断图片大小

            string FileName = photoUpload.PostedFile.FileName;
            string lastName = FileName.Substring((FileName.LastIndexOf(".") + 1)).ToLower();
            decimal photoSize_KB = photoUpload.PostedFile.ContentLength / 1024;
            decimal photoSize_M = photoSize_KB / 1024;//从字节换算成兆
            decimal limitSize_M = cod.ChangeDecimal(Util.GetAppSettings("MaxFileLength")) / 1024;//从千字节换算成兆
            if (photoSize_M > limitSize_M)
            {
                doJavaScript(cod.GetJScript("modiFailExcel", string.Format("'图片大小不允许超过{0}M！'", limitSize_M)));
                return;
            }

            #endregion 判断图片大小

            #region 判断是否存在该路径，不存在即创建

            //附件归档目录
            string strSavePath = Util.GetAppSettings("DSTSurveyPhotoPath");
            if (strSavePath.Length == 0)
                strSavePath = "DST\\Survey";

            string strArchiveDirectory = ComHandleClass.getInstance().ByCurrentDateGetFilePath() + "\\" + strSavePath;
            m_strUploadPhoto = m_strUploadPhoto + "\\" + strArchiveDirectory;
            if (!Directory.Exists(m_strUploadPhoto))
            {
                Directory.CreateDirectory(m_strUploadPhoto);//创建路径
            }

            #endregion 判断是否存在该路径，不存在即创建

            #region 上传文件到服务器

            string strPhotoName = GetFileName(seq_no, lastName);
            string strPhotoNotes = Post("NOTE");
            string upload_file = m_strUploadPhoto + "\\" + strPhotoName;//取出服务器虚拟路径,存储上传文件
            photoUpload.SaveAs(upload_file);//开始上传文件

            #endregion 上传文件到服务器

            try
            {
                if (SavePhoto(seq_no, strPhotoName, strArchiveDirectory))
                {
                    //不关闭窗口，刷新列表
                    doJavaScript(cod.GetJScript("modiDataExcel", "'图片上传成功！'"));
                }
            }
            catch (Exception ex)
            {
                DeletePhoto(upload_file);
                LogDBHandleClass.getInstance().LogException(string.Empty, "家庭经济调查，上传附件失败：" + ex.ToString());
                //不关闭窗口，刷新列表
                doJavaScript(cod.GetJScript("modiFailExcel", "'图片上传失败！'"));
            }
        }

        //附件名称定义
        protected string GetFileName(string strSeq_No, string strLastName)
        {
            string strFileName = (strSeq_No + DateTime.Now.ToString("yyyyMMddHHmmss") + "." + strLastName).Trim();
            return strFileName;
        }

        protected bool SavePhoto(string seq_no, string strPhotoName, string strArchiveDirectory)
        {
            photo.OID = Guid.NewGuid().ToString();
            photo.SEQ_NO = seq_no;
            photo.PHOTO_NAME = strPhotoName;
            photo.ARCHIVE_DIRECTORY = strArchiveDirectory;
            photo.NOTE = Post("NOTE");
            photo.SHOW_NAME = Post("PName");
            var inserttrcn = ImplementFactory.GetInsertTransaction<Dst_family_photo>("Dst_family_photoInsertTransaction", user.User_Name);
            inserttrcn.EntityList.Add(photo);

            return inserttrcn.Commit();
        }

        #endregion 上传图片按钮

        #region 删除图片

        /// <summary>
        /// 保存信息不成功，同时删除上传的图片
        /// </summary>
        /// <param name="strPhotoPath"></param>
        protected void DeletePhoto(string strPhotoPath)
        {
            if (File.Exists(strPhotoPath))
            {
                FileInfo fi = new FileInfo(strPhotoPath);
                if (fi.Attributes.ToString().IndexOf("ReadOnly") != -1)
                    fi.Attributes = FileAttributes.Normal;

                File.Delete(strPhotoPath);
            }
        }

        #endregion 删除图片
    }
}