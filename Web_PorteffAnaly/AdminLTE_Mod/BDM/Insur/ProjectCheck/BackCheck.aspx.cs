using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectCheck
{
    public partial class BackCheck : Main
    {
        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        protected void Page_Load(object sender, EventArgs e)
        {
            string optype = Request.QueryString["optype"];
            if (!string.IsNullOrEmpty(optype))
            {
                switch (optype.ToLower().Trim())
                {
                    case "multi_back":
                        Response.Write(MultiBack());
                        Response.End();
                        break;
                }
            }
        }

        #region 批量退回核对信息

        /// <summary>
        /// 批量退回核对信息
        /// </summary>
        /// <returns></returns>
        private string MultiBack()
        {
            try
            {
                if (string.IsNullOrEmpty(Post("SELECT_OID")))
                    return "未选择数据项！";
                if (string.IsNullOrEmpty(Get("backtype")) || string.IsNullOrEmpty(Get("step")))
                    return "操作类型或者核对阶段为空！";

                string strWhere = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(Post("SELECT_OID"));

                string strSQL = string.Empty;
                string strSQL_1 = string.Empty;
                switch (Get("backtype"))
                {
                    case "N"://退回学生未核对
                        strSQL = string.Format("UPDATE INSUR_APPLY_CHECK SET S_CHECK_CODE ='',S_CHECK_NAME ='',S_CHECK_TIME='',F_CHECK_CODE='',F_CHECK_NAME='',F_CHECK_TIME='',Y_CHECK_CODE='',Y_CHECK_NAME='',Y_CHECK_TIME='',CHECK_STEP='',IS_REFUND='N',REFUND_NOTES='',REFUND_INSUR_NAME='',BACK_CODE='{1}',BACK_NAME='{2}',BACK_TIME='{3}' WHERE OID IN ({0}) AND CHECK_STEP='{4}' ", strWhere, user.User_Id, user.User_Name, GetDateLongFormater(), Get("step"));
                        ds.ExecuteTxtNonQuery(strSQL);
                        break;
                    case "1"://退回学生已核对
                        strSQL = string.Format("UPDATE INSUR_APPLY_CHECK SET F_CHECK_CODE='',F_CHECK_NAME='',F_CHECK_TIME='',Y_CHECK_CODE='',Y_CHECK_NAME='',Y_CHECK_TIME='',CHECK_STEP='',IS_REFUND='N',REFUND_NOTES='',REFUND_INSUR_NAME='',BACK_CODE='{1}',BACK_NAME='{2}',BACK_TIME='{3}' WHERE OID IN ({0}) AND S_CHECK_CODE = '' AND CHECK_STEP='{4}' ", strWhere, user.User_Id, user.User_Name, GetDateLongFormater(), Get("step"));
                        ds.ExecuteTxtNonQuery(strSQL);
                        strSQL_1 = string.Format("UPDATE INSUR_APPLY_CHECK SET F_CHECK_CODE='',F_CHECK_NAME='',F_CHECK_TIME='',Y_CHECK_CODE='',Y_CHECK_NAME='',Y_CHECK_TIME='',CHECK_STEP='1',IS_REFUND='N',REFUND_NOTES='',REFUND_INSUR_NAME='',BACK_CODE='{1}',BACK_NAME='{2}',BACK_TIME='{3}' WHERE OID IN ({0}) AND S_CHECK_CODE != '' AND CHECK_STEP='{4}' ", strWhere, user.User_Id, user.User_Name, GetDateLongFormater(), Get("step"));
                        ds.ExecuteTxtNonQuery(strSQL_1);
                        break;
                    case "2"://退回辅导员已核对
                        strSQL = string.Format("UPDATE INSUR_APPLY_CHECK SET Y_CHECK_CODE='',Y_CHECK_NAME='',Y_CHECK_TIME='',CHECK_STEP='2',BACK_CODE='{1}',BACK_NAME='{2}',BACK_TIME='{3}' WHERE OID IN ({0}) AND CHECK_STEP='{4}' ", strWhere, user.User_Id, user.User_Name, GetDateLongFormater(), Get("step"));
                        ds.ExecuteTxtNonQuery(strSQL);
                        break;
                }
                return string.Format("批量退回成功！");
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保险核对信息批量核对出错：" + ex.ToString());
                return "批量退回失败！";
            }
        }

        #endregion 批量退回核对信息
    }
}