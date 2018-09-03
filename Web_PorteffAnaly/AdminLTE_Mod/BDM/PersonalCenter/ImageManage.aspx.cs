using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.PersonalCenter
{
    public partial class ImageManage : Main
    {
        #region 初始化定义

        public comdata cod = new comdata();
        private ComTranClass comTran = new ComTranClass();
        public Ua_user_photo photo = new Ua_user_photo();
        public string strPhotoPath = string.Empty;

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
            photo.USER_ID = user.User_Id;
            ds.RetrieveObject(photo);

            //strPhotoPath = string.Format("{0}\\{1}\\{2}", m_strUploadPhoto, photo.ARCHIVE_DIRECTORY, photo.PHOTO_NAME);
            strPhotoPath = string.Format("{0}/{1}", photo.ARCHIVE_DIRECTORY.Replace("\\", "/"), photo.PHOTO_NAME.Replace("\\", "/"));
        }

        #endregion 页面加载

        #region 上传图片按钮

        protected void UploadBtn_Click(object sender, EventArgs e)
        {
            #region 判断图片大小

            string FileName = photoUpload.PostedFile.FileName;
            string lastName = FileName.Substring((FileName.LastIndexOf(".") + 1)).ToLower();
            decimal photoSize_KB = photoUpload.PostedFile.ContentLength / 1024;
            decimal photoSize_M = photoSize_KB / 1024;//从字节换算成兆
            decimal limitSize_M = cod.ChangeDecimal(Util.GetAppSettings("MaxFileLength")) / 1024;//从千字节换算成兆
            if (photoSize_M > limitSize_M)
            {
                doJavaScript(cod.GetJScript("MsgUtils.info", string.Format("'图片大小不允许超过{0}M！'", limitSize_M)));
                return;
            }

            #endregion 判断图片大小

            #region 判断是否存在该路径，不存在即创建

            //附件归档目录
            string strSavePath = Util.GetAppSettings("TXPhotoPath");
            if (strSavePath.Length == 0)
                strSavePath = "TX";

            string strArchiveDirectory = ComHandleClass.getInstance().ByCurrentDateGetFilePath() + "\\" + strSavePath;
            m_strUploadPhoto = m_strUploadPhoto + "\\" + strArchiveDirectory;
            if (!Directory.Exists(m_strUploadPhoto))
            {
                Directory.CreateDirectory(m_strUploadPhoto);//创建路径
            }

            #endregion 判断是否存在该路径，不存在即创建

            #region 上传文件到服务器

            string strPhotoName = GetFileName(user.User_Id + "_", lastName);
            string upload_file = m_strUploadPhoto + "\\" + strPhotoName;//取出服务器虚拟路径,存储上传文件
            photoUpload.SaveAs(upload_file);//开始上传文件
            //无损压缩图片
            string strCompressName = GetFileName(user.User_Id + "Compress_", lastName);
            string compress_file = m_strUploadPhoto + "\\" + strCompressName;
            bool b = GetPicThumbnail(upload_file, compress_file, 160, 160, 100);

            #endregion 上传文件到服务器

            try
            {
                if (SavePhoto(strPhotoName, strCompressName, strArchiveDirectory))
                {
                    photo.USER_ID = user.User_Id;
                    ds.RetrieveObject(photo);
                    strPhotoPath = string.Format("{0}/{1}", photo.ARCHIVE_DIRECTORY.Replace("\\", "/"), photo.PHOTO_NAME.Replace("\\", "/"));
                    doJavaScript(cod.GetJScript("uploadSuccess", "'图片上传成功'"));
                }
            }
            catch (Exception ex)
            {
                DeletePhoto(upload_file);
                DeletePhoto(compress_file);
                //不关闭窗口，刷新列表
                doJavaScript(cod.GetJScript("uploadFault", "'图片上传失败！'"));
            }
        }

        #endregion 上传图片按钮

        #region 附件名称定义

        //附件名称定义
        protected string GetFileName(string strSeq_No, string strLastName)
        {
            string strFileName = (strSeq_No + DateTime.Now.ToString("yyyyMMddHHmmss") + "." + strLastName).Trim();
            return strFileName;
        }

        #endregion 附件名称定义

        #region 保存到数据库

        protected bool SavePhoto(string strPhotoName, string strCompressName, string strArchiveDirectory)
        {
            DeletePhotoData(user.User_Id);

            photo = new Ua_user_photo();
            photo.USER_ID = user.User_Id;
            photo.PHOTO_NAME = strPhotoName;
            photo.COMPRESS_NAME = strCompressName;
            photo.ARCHIVE_DIRECTORY = strArchiveDirectory;
            var inserttrcn = ImplementFactory.GetInsertTransaction<Ua_user_photo>("Ua_user_photoInsertTransaction", user.User_Name);
            inserttrcn.EntityList.Add(photo);

            return inserttrcn.Commit();
        }

        #endregion 保存到数据库

        #region 删除图片

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

        private string DeletePhotoData(string id)
        {
            if (string.IsNullOrEmpty(id)) return "主键为空,不允许删除操作";
            string sqlDeleteConta = string.Format("DELETE FROM UA_USER_PHOTO WHERE USER_ID='{0}'", id);

            var model = new Ua_user_photo();
            model.USER_ID = id;
            ds.RetrieveObject(model);
            if (ds.ExecuteTxtNonQuery(sqlDeleteConta) > 0)
            {
                string delpath = m_strUploadPhoto + "\\" + model.ARCHIVE_DIRECTORY + "\\" + model.PHOTO_NAME;
                DeletePhoto(delpath);
                delpath = m_strUploadPhoto + "\\" + model.ARCHIVE_DIRECTORY + "\\" + model.COMPRESS_NAME;
                DeletePhoto(delpath);
                return "删除成功！";
            }

            return "删除失败！";
        }

        #endregion 删除图片

        #region 无损压缩图片

        /// <summary>
        /// 无损压缩图片
        /// </summary>
        /// <param name="sFile">原图片</param>
        /// <param name="dFile">压缩后保存位置</param>
        /// <param name="dHeight">压缩后的高度</param>
        /// <param name="dWidth">压缩后的宽度</param>
        /// <param name="flag">压缩质量(数字越小压缩率越高) 1-100</param>
        /// <returns></returns>
        public static bool GetPicThumbnail(string sFile, string dFile, int dHeight, int dWidth, int flag)
        {
            System.Drawing.Image iSource = System.Drawing.Image.FromFile(sFile);
            ImageFormat tFormat = iSource.RawFormat;
            int sW = 0, sH = 0;

            //按比例缩放  
            Size tem_size = new Size(iSource.Width, iSource.Height);

            if (tem_size.Width > dHeight || tem_size.Width > dWidth)
            {
                if ((tem_size.Width * dHeight) > (tem_size.Width * dWidth))
                {
                    sW = dWidth;
                    sH = (dWidth * tem_size.Height) / tem_size.Width;
                }
                else
                {
                    sH = dHeight;
                    sW = (tem_size.Width * dHeight) / tem_size.Height;
                }
            }
            else
            {
                sW = tem_size.Width;
                sH = tem_size.Height;
            }

            Bitmap ob = new Bitmap(dWidth, dHeight);
            Graphics g = Graphics.FromImage(ob);

            g.Clear(Color.WhiteSmoke);
            g.CompositingQuality = CompositingQuality.HighQuality;
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.InterpolationMode = InterpolationMode.HighQualityBicubic;

            g.DrawImage(iSource, new Rectangle((dWidth - sW) / 2, (dHeight - sH) / 2, sW, sH), 0, 0, iSource.Width, iSource.Height, GraphicsUnit.Pixel);

            g.Dispose();
            //以下代码为保存图片时，设置压缩质量    
            EncoderParameters ep = new EncoderParameters();
            long[] qy = new long[1];
            qy[0] = flag;//设置压缩的比例1-100    
            EncoderParameter eParam = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, qy);
            ep.Param[0] = eParam;
            try
            {
                ImageCodecInfo[] arrayICI = ImageCodecInfo.GetImageEncoders();
                ImageCodecInfo jpegICIinfo = null;
                for (int x = 0; x < arrayICI.Length; x++)
                {
                    if (arrayICI[x].FormatDescription.Equals("JPEG"))
                    {
                        jpegICIinfo = arrayICI[x];
                        break;
                    }
                }
                if (jpegICIinfo != null)
                {
                    ob.Save(dFile, jpegICIinfo, ep);//dFile是压缩后的新路径    
                }
                else
                {
                    ob.Save(dFile, tFormat);
                }
                return true;
            }
            catch
            {
                return false;
            }
            finally
            {
                iSource.Dispose();
                ob.Dispose();
            }
        }

        #endregion 无损压缩图片
    }
}