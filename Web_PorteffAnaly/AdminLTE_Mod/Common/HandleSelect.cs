using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using HQ.DALFactory;
using HQ.InterfaceService;
using HQ.WebForm;

namespace AdminLTE_Mod.Common
{
    /// <summary>
    /// 处理查询下拉
    /// </summary>
    public class HandleSelect
    {
        #region 初始化定义

        private static HandleSelect m_instance = new HandleSelect();
        protected comdata cod = new comdata();
        private IDataSource ds = DataSourceFactory.GetDataSource();

        public HandleSelect() { }

        public static HandleSelect getInstance()
        {
            return m_instance;
        }

        #endregion 初始化定义

        #region 通过下拉参数获得下拉json串

        /// <summary>
        /// 通过下拉参数获得下拉json串
        /// </summary>
        /// <param name="strDdlName"></param>
        /// <returns></returns>
        public string GetDDLJson(string strDdlName)
        {
            return GetComboxJsonStr(cod.GetDDlDataTable(strDdlName));
        }

        #endregion 通过下拉参数获得下拉json串

        #region 获取下拉json字符串

        /// <summary>
        ///
        /// 格式：[{'text':'通知公共', 'value':'通知公共'}, {'text':'消息', 'value':'消息'}]
        /// </summary>
        /// <param name="tabData"></param>
        /// <returns></returns>
        public string GetComboxJsonStr(DataTable tabData)
        {
            if (!cod.TableIsValid(tabData))
                return "[]";
            StringBuilder result = new StringBuilder();
            result.Append("[");
            foreach (DataRow dr in tabData.Rows)
            {
                if (dr == null)
                    continue;

                result.Append("{");
                result.AppendFormat("'text':'{0}', 'value':'{1}'", dr["TEXT"].ToString(), dr["VALUE"].ToString());
                result.Append("},");
            }
            if (result[result.Length - 1].Equals(','))
                result.Remove(result.Length - 1, 1);//去掉最后一个逗号

            result.Append("]");
            return result.ToString();
        }

        #endregion 获取下拉json字符串

        #region 待办事项集合获得

        //格式："表名", "学号"
        private Dictionary<string, string> TableList_S = new Dictionary<string, string>(){
			{"BASIC_STU_INFO_MODI", "NUMBER"},//个人信息修改
            {"DST_FAMILY_SITUA", "NUMBER"},//家庭调查
            {"DST_STU_APPLY", "NUMBER"},//困难生申请
            {"SHOOLAR_APPLY_HEAD", "STU_NUMBER"},//奖助申请
            {"LOAN_PROJECT_APPLY", "STU_NUMBER"},//贷款信息核对
            {"INSUR_PROJECT_APPLY", "STU_NUMBER"}//保险管理信息核对
        };
        //格式："表名", "DOC_TYPE,INPUT_CODE_COLUMN,CLASS_CODE_COLUMN,XY_CODE_COLUMN"
        private Dictionary<string, string> TableList_T = new Dictionary<string, string>(){
			{"BASIC_STU_INFO_MODI", "BDM05,NUMBER,CLASS,COLLEGE"},//个人信息修改审核
            {"DST_STU_APPLY", "BDM01,NUMBER,CLASS,COLLEGE"},//困难生申请审核
            {"SHOOLAR_APPLY_HEAD", "BDM03,STU_NUMBER,CLASS_CODE,XY"},//奖助申请审核
            {"UA_CLASS_GROUP", "UA01,DECL_NUMBER,CLASSCODE,XY"},//编班管理审核
            {"INSUR_PROJECT_APPLY", "INS02,STU_NUMBER,CLASS_CODE,XY"},//保险
            {"LOAN_PROJECT_APPLY", "LOA02,STU_NUMBER,CLASS_CODE,XY"}//贷款
        };

        /// <summary>
        /// 待办事项集合
        /// </summary>
        /// <param name="strUserId"></param>
        /// <param name="strUserRole"></param>
        /// <param name="strUserFilter"></param>
        /// <returns></returns>
        public DataTable GetTodoDataTable(string strUserId, string strUserRole)
        {
            StringBuilder strSQL = new StringBuilder();
            if (strUserRole.Equals(HQ.Model.CValue.ROLE_TYPE_S))
            {
                foreach (var table in TableList_S)
                {
                    if (table.Key.Equals("LOAN_PROJECT_APPLY"))
                    {
                        strSQL.AppendFormat("SELECT OID,SEQ_NO,DOC_TYPE,'未完成信息核对' RET_CHANNEL FROM (SELECT A.*,B.CHECK_STEP FROM LOAN_PROJECT_APPLY A LEFT JOIN LOAN_APPLY_CHECK B ON A.SEQ_NO = B.SEQ_NO) T WHERE STU_NUMBER = '{0}' AND (CHECK_STEP IS NULL OR CHECK_STEP = '') UNION ALL ", strUserId);
                    }
                    else if (table.Key.Equals("INSUR_PROJECT_APPLY"))
                    {
                        strSQL.AppendFormat("SELECT OID,SEQ_NO,DOC_TYPE,'未完成信息核对' RET_CHANNEL FROM (SELECT A.*,B.CHECK_STEP FROM INSUR_PROJECT_APPLY A LEFT JOIN INSUR_APPLY_CHECK B ON A.SEQ_NO = B.SEQ_NO) T WHERE STU_NUMBER = '{0}' AND (CHECK_STEP IS NULL OR CHECK_STEP = '') UNION ALL ", strUserId);
                    }
                    else
                    {
                        strSQL.AppendFormat("SELECT OID,SEQ_NO,DOC_TYPE,'未完成申请' RET_CHANNEL FROM {0} WHERE {1} = '{2}' AND RET_CHANNEL IN ('A0000') UNION ALL ", table.Key, table.Value, strUserId);
                    }
                }
            }
            else
            {
                foreach (var table in TableList_T)
                {
                    string[] arr = table.Value.Split(',');
                    string strFilter = DataFilterHandleClass.getInstance().Pend_DataFilter(strUserRole, arr[0]);
                    strFilter += cod.GetDataFilterString(true, arr[1], arr[2], arr[3]);
                    if (table.Key.Equals("UA_CLASS_GROUP"))
                    {
                        strSQL.AppendFormat("SELECT DOC_TYPE,COUNT(1) QTY FROM (SELECT A.CLASSCODE,A.XY,B.* FROM BASIC_CLASS_INFO A INNER JOIN UA_CLASS_GROUP B ON A.CLASSCODE = B.GROUP_CLASS) T WHERE {1} GROUP BY DOC_TYPE UNION ALL ", table.Key, strFilter);
                    }
                    else if (table.Key.Equals("INSUR_PROJECT_APPLY"))
                    {
                        string check_step = strUserRole.Equals(HQ.Model.CValue.ROLE_TYPE_F) ? "1" : (strUserRole.Equals(HQ.Model.CValue.ROLE_TYPE_Y) ? "2" : "");
                        strSQL.AppendFormat("SELECT DOC_TYPE,COUNT(1) FROM (SELECT A.*,B.CHECK_STEP FROM INSUR_PROJECT_APPLY A LEFT JOIN INSUR_APPLY_CHECK B ON A.SEQ_NO = B.SEQ_NO) T WHERE {0} AND CHECK_STEP = '{1}' GROUP BY DOC_TYPE UNION ALL ", strFilter, check_step);
                    }
                    else
                        strSQL.AppendFormat("SELECT DOC_TYPE,COUNT(1) QTY FROM {0} WHERE {1} GROUP BY DOC_TYPE UNION ALL ", table.Key, strFilter);
                }
            }
            return ds.ExecuteTxtDataTable(strSQL.ToString().Substring(0, strSQL.ToString().Length - 10));//把最后面的“UNION ALL”拿掉
        }

        #endregion 待办事项集合获得

        #region 通过单据类型获得待办事项调整URL

        /// <summary>
        /// 通过单据类型获得待办事项调整URL
        /// </summary>
        /// <param name="strDocType"></param>
        /// <returns></returns>
        public string ByDoctypeGetUrl(string strDocType)
        {
            string strResult = string.Empty;
            switch (strDocType)
            {
                case "BDM05"://个人信息修改审核
                    strResult = "学生信息修改审核@/AdminLTE_Mod/BDM/PersonalCenter/List.aspx";
                    break;
                case "BDM01"://困难生申请审核
                    strResult = "困难生审核待处理查看@/AdminLTE_Mod/BDM/DST/DifficultyApply/List_pend.aspx";
                    break;
                case "BDM03"://奖助申请审核
                    strResult = "奖助审核待处理查看@/AdminLTE_Mod/BDM/ScholarshipAssis/ProjectApprove/List_Pend.aspx";
                    break;
                case "UA01"://编班管理审核
                    strResult = "编班审核待处理查看@/AdminLTE_Mod/UserAuthority/ClassGroup/List_Pend.aspx";
                    break;
                case "INS02"://保险管理信息核对
                    strResult = "保险管理待核对信息@/AdminLTE_Mod/BDM/Insur/ProjectCheck/CheckList.aspx";
                    break;
                default:
                    strResult = "待办事项@/AdminLTE_Mod/BDM/PersonalCenter/ToDo.aspx";
                    break;
            }
            return strResult;
        }

        #endregion 通过单据类型获得待办事项调整URL
    }
}