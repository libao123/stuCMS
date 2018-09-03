using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectApply
{
    public partial class FileList : ListBaseLoad<Shoolar_apply_file>
    {
        #region 初始化

        private comdata cod = new comdata();

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

        protected override SelectTransaction<Shoolar_apply_file> GetSelectTransaction()
        {
            if (Request.QueryString["seq_no"] != null && Request.QueryString["seq_no"].Length != 0)
            {
                param.Add("SEQ_NO", Request.QueryString["seq_no"]);
            }
            else
            {
                param.Add(" 1=2 ", "");
            }
            return ImplementFactory.GetSelectTransaction<Shoolar_apply_file>("Shoolar_apply_fileSelectTransaction", param);
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

                        case "download"://下载
                            Response.Write(GetDownloadAddress());
                            Response.End();
                            break;

                        case "delete"://删除操作
                            Response.Write(DeleteData());
                            Response.End();
                            break;
                        case "getprintfile"://获得打印主键串
                            Response.Write(GetPrintFile());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Shoolar_apply_file>.NameValue> GetValue(Shoolar_apply_file entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "FILE_TYPE", Value = entity.FILE_TYPE };
            yield return new NameValue() { Name = "FILE_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_apply_file_type", entity.FILE_TYPE) };
            yield return new NameValue() { Name = "FILE_NAME", Value = entity.FILE_NAME };
            yield return new NameValue() { Name = "FILE_SAVE_NAME", Value = entity.FILE_SAVE_NAME };
            yield return new NameValue() { Name = "FILE_DIRECTORY", Value = entity.FILE_DIRECTORY };
        }

        #endregion 输出列表信息

        #region 获得附件下载地址

        /// <summary>
        /// 获得附件下载地址
        /// </summary>
        /// <returns></returns>
        private string GetDownloadAddress()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return string.Empty;

            Shoolar_apply_file head = new Shoolar_apply_file();
            head.OID = Get("id");
            ds.RetrieveObject(head);
            string strUrl = head.FILE_DIRECTORY + "/" + head.FILE_SAVE_NAME;
            strUrl = strUrl.Replace("\\", "/");
            return strUrl;
        }

        #endregion 获得附件下载地址

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("id")))
                    return "OID为空,不允许删除操作";
                Shoolar_apply_file head = new Shoolar_apply_file();
                head.OID = Get("id");
                ds.RetrieveObject(head);
                var transaction = ImplementFactory.GetDeleteTransaction<Shoolar_apply_file>("Shoolar_apply_fileDeleteTransaction");
                transaction.EntityList.Add(head);
                if (!transaction.Commit())
                    return "删除失败！";

                #region 删除对应文件

                string strFilePath = head.FILE_DIRECTORY + "/" + head.FILE_SAVE_NAME;
                strFilePath = System.Web.HttpContext.Current.Server.MapPath("~/") + strFilePath.Replace("/", "\\");
                if (File.Exists(strFilePath))
                {
                    FileInfo fi = new FileInfo(strFilePath);
                    //文件如果是只读的，设置成 正常 模式
                    if (fi.Attributes.ToString().IndexOf("ReadOnly") != -1)
                        fi.Attributes = FileAttributes.Normal;
                    //删除指定图片
                    File.Delete(strFilePath);
                }

                #endregion 删除对应文件

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请，删除附件数据失败：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据

        #region 获得打印主键串

        /// <summary>
        /// 获得打印主键串
        /// </summary>
        /// <returns></returns>
        private string GetPrintFile()
        {
            if (string.IsNullOrEmpty(Get("seq_no")))
                return string.Empty;

            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("SEQ_NO", Get("seq_no"));
            List<Shoolar_apply_file> fileList = ProjectApplyHandleClass.getInstance().GetFileListInfo(param);
            if (fileList == null)
                return string.Empty;
            string strResult = string.Empty;
            foreach (Shoolar_apply_file file in fileList)
            {
                strResult += file.OID + ",";
            }
            return strResult;
        }

        #endregion 获得打印主键串
    }
}