/*
-------------------------------------------------------------------
版权所有:

版本: vs2010
描述: NPOI支持excel文件的导入类
作者: zz
创建时间: 2015-05-24
-------------------------------------------------------------------
*/

using System;
using System.Data;
using System.IO;
using System.Web.UI.HtmlControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;
using NPOI.HSSF.UserModel;

namespace AdminLTE_Mod.Common
{
    /// <summary>
    /// 使用NPOI的方式导入excel文档
    /// 优点：跟环境配置的关联性不大
    /// 缺点：只能支持97-2003格式的excel文件
    /// </summary>
    public class NpoiImportExcel : Main
    {
        protected comdata cod = new comdata();

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// 导入操作
        /// </summary>
        /// <param name="userfile"></param>
        protected void DoImport(HtmlInputFile userfile)
        {
            try
            {
                string fileName = string.Empty;
                string fileExtension = string.Empty;
                string physical_path = string.Empty;

                UploadFile(userfile, ref physical_path);//SaveAs有问题，改为通过文件流上传 20170302 by elh
                ///将文件转成文件流的形式
                using (Stream stream = new FileStream(physical_path, FileMode.Open, FileAccess.Read))
                {
                    ///excel第一个标签页
                    string strMsg = string.Empty;
                    DataTable dtExcel = ImportDataTableFromExcel(stream, 0, out strMsg);
                    if (strMsg.Length > 0)
                        LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "导入出错：" + strMsg);

                    if (dtExcel != null && dtExcel.Rows.Count > 0)
                    {
                        ReadExcelData(dtExcel);
                    }
                }
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "导入出错：" + ex.ToString());
                string alert_msg = string.Format("{{\"content\":\"{0}\", \"duration\":6,\"type\": \"danger\"}}", ex.Message);
                doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
            }
        }

        /// <summary>
        /// 将excel中的数据集转成datatable集合
        /// </summary>
        /// <param name="excelFileStream">excel文件流</param>
        /// <param name="sheetIndex">起始标签页码：从0开始</param>
        /// <returns></returns>
        public static DataTable ImportDataTableFromExcel(Stream excelFileStream, int sheetIndex, out string strMsg)
        {
            try
            {
                strMsg = string.Empty;
                HSSFWorkbook workbook = new HSSFWorkbook(excelFileStream);
                HSSFSheet sheet = workbook.GetSheetAt(sheetIndex);
                DataTable table = new DataTable();

                #region 构造datatable的列

                for (int i = sheet.GetRow(sheet.FirstRowNum).FirstCellNum; i < sheet.GetRow(sheet.FirstRowNum).LastCellNum; i++)
                {
                    string title = sheet.GetRow(sheet.FirstRowNum).GetCell(i).StringCellValue;
                    DataColumn col = new DataColumn(title.Trim());
                    table.Columns.Add(col);
                }

                #endregion 构造datatable的列

                System.Text.RegularExpressions.Regex re = new System.Text.RegularExpressions.Regex(@"\n");
                //sheet.LastRowNum：标签页中的行数
                for (int i = (sheet.FirstRowNum); i <= sheet.LastRowNum; i++)
                {
                    #region 构造datatable

                    DataRow dr = table.NewRow();
                    dr.BeginEdit();
                    HSSFRow row = sheet.GetRow(i);
                    //row.LastCellNum：一行中的单元格数据
                    for (int j = row.FirstCellNum; j < row.LastCellNum; j++)
                    {
                        HSSFCell cell = row.GetCell(j);
                        if (cell == null)
                            continue;

                        #region 判断单元格类型

                        switch (cell.CellType)
                        {
                            case HSSFCellType.BLANK:
                                dr[j] = "";
                                break;

                            case HSSFCellType.BOOLEAN:
                                dr[j] = cell.BooleanCellValue;
                                break;

                            case HSSFCellType.NUMERIC:
                                dr[j] = re.Replace(cell.ToString(), "").Trim();
                                break;

                            case HSSFCellType.STRING:
                                dr[j] = (re.Replace(cell.StringCellValue, "").Replace("．", ".")).Trim();
                                break;

                            case HSSFCellType.ERROR:
                                dr[j] = cell.ErrorCellValue;
                                break;

                            case HSSFCellType.FORMULA:
                                dr[j] = cell.NumericCellValue;
                                break;

                            default:
                                dr[j] = cell.CellFormula;
                                break;
                        }

                        #endregion 判断单元格类型
                    }
                    dr.EndEdit();
                    table.Rows.Add(dr);

                    #endregion 构造datatable
                }

                excelFileStream.Close();
                workbook = null;
                sheet = null;
                return table;
            }
            catch (Exception ex)
            {
                strMsg = ex.Message;
                return null;
            }
        }

        /// <summary>
        /// 把导入的excel文件保存到UpLoadFiles文件夹
        /// </summary>
        /// <param name="fileInput"></param>
        /// <param name="tmpFilePath"></param>
        private void UploadFile(HtmlInputFile fileInput, ref string tmpFilePath)
        {
            try
            {
                string fileName = DateTime.Now.ToString("yyyyMMddHHmmssfff") + ".xls";
                //保存文件夹位置:/UpLoadFiles/年份/月份
                string savePath = Server.MapPath("/UpLoadFiles/" + DateTime.Now.ToString("yyyy") + "/" + DateTime.Now.ToString("MM") + "/");
                if (!Directory.Exists(savePath))
                {
                    Directory.CreateDirectory(savePath);
                }
                tmpFilePath = savePath + fileName;

                System.Web.HttpPostedFile postFile = fileInput.PostedFile;
                using (System.IO.FileStream fs = new FileStream(tmpFilePath, FileMode.Create, FileAccess.Write, FileShare.Write))
                {
                    using (BinaryReader reader = new BinaryReader(postFile.InputStream))
                    {
                        long totalLength = reader.BaseStream.Length;
                        byte[] buffer = new byte[10240];
                        int readLength = 0;
                        while (totalLength > 0)
                        {
                            readLength = reader.Read(buffer, 0, 10240);
                            totalLength = totalLength - readLength;
                            fs.Write(buffer, 0, readLength);
                        }
                        reader.Close();
                        reader.Dispose();
                    }
                    fs.Close();
                    fs.Dispose();
                }
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "上传文件出错：" + ex.ToString());
                string alert_msg = string.Format("{{\"content\":\"{0}\", \"duration\":6,\"type\": \"danger\"}}", ex.Message);
                doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
            }
        }

        /// <summary>
        ///  导入excel转成table的值到对应表中
        /// </summary>
        /// <param name="table"></param>
        private void ReadExcelData(DataTable table)
        {
            try
            {
                string result = string.Empty;
                string reChkMsg = ProcessData(table);
                if (reChkMsg.Length > 0)
                {
                    result += string.Format("导入失败！excel中的数据不正确！具体如下：{0}", reChkMsg);
                }

                if (result.Length > 0)
                {
                    LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "上传文件出错：" + result);
                    string alert_msg = string.Format("{{\"content\":\"{0}\", \"duration\":6,\"type\": \"danger\"}}", result);
                    doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
                }
                else
                {
                    doJavaScript(cod.GetJScript("ListRefresh", string.Empty));//刷新列表
                    string alert_msg = string.Format("{{\"content\":\"{0}\", \"duration\":2,\"type\": \"danger\"}}", "上传成功！");
                    doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
                }
            }
            catch (Exception e)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "上传文件出错：" + e.ToString());
                string alert_msg = string.Format("{{\"content\":\"{0}\", \"duration\":6,\"type\": \"danger\"}}", e.Message);
                doJavaScript(cod.GetJScript("easyAlert.timeShow", alert_msg));
            }
        }

        /// <summary>
        /// 操作table的虚构方法
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        protected virtual string ProcessData(DataTable table)
        {
            return string.Empty;
        }
    }
}