using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AdminLTE_Mod.Common;
using HQ.DALFactory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.APP.WkfManage.WkfRules
{
    public partial class List : Main
    {
        #region 初始化

        public comdata cod = new comdata();

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
                            Response.Write(GetData());
                            Response.End();
                            break;

                        case "delete":
                            Response.Write(Delete());
                            Response.End();
                            break;

                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;

                        case "check":
                            Response.Write(SaveChk());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 获取列表

        /// <summary>
        /// 获取列表
        /// </summary>
        /// <returns></returns>
        private string GetData()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("DOC_TYPE")))
                where += string.Format(" AND DOC_TYPE = '{0}' ", Post("DOC_TYPE"));

            Hashtable ddl = new Hashtable();
            ddl["DOC_TYPE_NAME"] = "ddl_doc_type"; //业务单据
            return GetCmdQueryData("WorkflowRuleSet_list", null, where, string.Empty, ddl);
        }

        /// <summary>
        /// 获取查询数据的JSON结果（多表查询，WEB用）
        /// </summary>
        /// <param name="sqlCmdName">执行的SQL</param>
        ///<param name="filter">查询参数</param>
        ///<param name="where">过滤语句</param>
        ///<param name="orderBy">结果排序</param>
        /// <param name="hsDDL">列表中的下拉框</param>
        /// <returns>JSON结果</returns>
        public string GetCmdQueryData(string sqlCmdName, Hashtable filter, string where, string orderBy, Hashtable hsDDL)
        {
            #region 查询结果集

            /*
             * command.config文件
               SELECT T_.*, ROW_NUMBER() OVER(ORDER BY 行号标志字段) RN  FROM ( SQL语句) T_  WHERE 1=1
             */
            int pageindex = 0, pagesize = 0;
            int draw = 0;
            if (HttpContext.Current.Request["draw"] != null)
                int.TryParse(HttpContext.Current.Request["draw"], out draw);
            if (HttpContext.Current.Request["start"] != null)
                int.TryParse(HttpContext.Current.Request["start"], out pageindex);
            pageindex = pageindex == 0 ? 1 : pageindex;
            if (HttpContext.Current.Request["length"] != null)
                int.TryParse(HttpContext.Current.Request["length"], out pagesize);
            if (pagesize == 0)
                pageindex = 1;
            else
                pageindex = pageindex / pagesize + 1;
            if (pagesize == 0)
                pagesize = 10;//默认10条

            if (!string.IsNullOrEmpty(orderBy))
            {
                orderBy = " order by " + orderBy;
            }

            var cmd = ds.GetCommand(sqlCmdName);
            DacHelper.PrepareCommand(cmd, filter);

            if (!string.IsNullOrEmpty(where))
            {
                if (!where.Trim().ToLower().StartsWith("and"))
                {
                    cmd.DbCommand.CommandText += " AND " + where;
                }
                else
                {
                    cmd.DbCommand.CommandText += where;
                }
            }

            var oldCmdText = cmd.DbCommand.CommandText;
            cmd.DbCommand.CommandText = string.Format("select count(1) from ({0}) c_", oldCmdText);
            object count = cmd.ExecuteScalar();
            cmd.DbCommand.CommandText = string.Format("select * from ({0}) list_ where list_.RN>{1} and list_.RN<={2} {3}", oldCmdText, pagesize * (pageindex - 1), pagesize * pageindex, orderBy);
            var dt = cmd.ExecuteDataTable();

            if (hsDDL != null && hsDDL.Count > 0)
            {
                cod.ConvertTabDdl(dt, hsDDL);
            }

            #endregion 查询结果集

            #region 新增"审批类型"，“审批岗位描述”两列

            //添加"审批类型"，“审批岗位描述”两列
            dt.Columns.Add("APPROVE_TYPE", typeof(string)); //数据类型为 文本
            dt.Columns.Add("POST_NOTE", typeof(string)); //数据类型为 文本
            //添加"撤销审批类型"，“撤销审批岗位描述”两列
            dt.Columns.Add("REVOKE_APPROVE_TYPE", typeof(string)); //数据类型为 文本
            dt.Columns.Add("REVOKE_POST_NOTE", typeof(string)); //数据类型为 文本

            #endregion 新增"审批类型"，“审批岗位描述”两列

            #region 给"审批类型"，“审批岗位描述”两列赋值

            foreach (DataRow row in dt.Rows)
            {
                //审批类型
                row["APPROVE_TYPE"] = GetApproveType(row["DOC_TYPE"].ToString(), WKF_VLAUES.DECLARE_TYPE_D);
                //审批岗位描述
                row["POST_NOTE"] = GetPostNote(row["DOC_TYPE"].ToString());
                //撤销审批类型
                row["REVOKE_APPROVE_TYPE"] = GetApproveType(row["DOC_TYPE"].ToString(), WKF_VLAUES.DECLARE_TYPE_R);
                //撤销审批岗位描述
                row["REVOKE_POST_NOTE"] = GetPostNote_Revoke(row["DOC_TYPE"].ToString());
            }

            #endregion 给"审批类型"，“审批岗位描述”两列赋值

            //return string.Format("{{\"total\":{0},\"rows\":[{1}]}}", count == null ? 0 : Convert.ToInt32(count), Json.DatatableToJson(dt));
            return string.Format("{{\"draw\":{0},\"recordsTotal\":{1},\"recordsFiltered\":{2},\"data\":[{3}]}}", draw, count == null ? 0 : Convert.ToInt32(count), dt.Rows.Count, Json.DatatableToJson(dt));
        }

        /// <summary>
        ///  通过操作类型、主管海关、监管场所，获得审批类型
        /// </summary>
        /// <param name="strWorkType">操作类型</param>
        /// <param name="strCustomsCode">主管海关</param>
        /// <param name="strAreaCode">监管场所</param>
        /// <returns>获得审批类型</returns>
        private string GetApproveType(string strWorkType, string strDeclareType)
        {
            string strResult = string.Empty;//审批类型
            string strSQL = string.Format("SELECT STEP_NO FROM WKF_RULE_QUEUE WHERE DOC_TYPE = '{0}' AND DECLARE_TYPE = '{1}' ORDER BY STEP_NO DESC", strWorkType, strDeclareType);
            DataTable dt = ds.ExecuteTxtDataTable(strSQL);
            if (dt == null || dt.Rows.Count == 0)
                return strResult;

            string strStepNo = dt.Rows[0]["STEP_NO"].ToString();
            //D0：自动审批；D1：一级审批；D2：二级审批；D3：三级审批
            if (dt.Rows[0]["STEP_NO"].ToString().Contains("0"))
            {
                strResult = "自动审批";
            }
            else if (dt.Rows[0]["STEP_NO"].ToString().Contains("1"))
            {
                strResult = "辅导员审批";
            }
            else if (dt.Rows[0]["STEP_NO"].ToString().Contains("2"))
            {
                strResult = "院级审批";
            }
            else if (dt.Rows[0]["STEP_NO"].ToString().Contains("3"))
            {
                strResult = "校级审批";
            }
            return strResult;
        }

        /// <summary>
        ///  通过操作类型获得审批岗位描述
        /// </summary>
        /// <param name="strWorkType"></param>
        /// <returns></returns>
        private string GetPostNote(string strWorkType)
        {
            string strResult = string.Empty;//审批岗位描述
            //D4表示审批回执，所以排除
            string strSQL = string.Format("SELECT DISTINCT STEP_NO,POST_CODE FROM WKF_RULE_QUEUE WHERE DOC_TYPE = '{0}' AND DECLARE_TYPE = '{1}' AND STEP_NO != 'D4' ORDER BY STEP_NO,POST_CODE", strWorkType, WKF_VLAUES.DECLARE_TYPE_D);
            DataTable dt = ds.ExecuteTxtDataTable(strSQL);
            if (dt == null || dt.Rows.Count == 0)
                return strResult;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["STEP_NO"].ToString().Equals(CValue.STEP_D1))
                    strResult += string.Format("{0}审批", cod.GetDDLTextByValue("ddl_ua_role", dt.Rows[i]["POST_CODE"].ToString()));
                else if (dt.Rows[i]["STEP_NO"].ToString().Equals(CValue.STEP_D2))
                    strResult += string.Format("{0}审批 ", cod.GetDDLTextByValue("ddl_ua_role", dt.Rows[i]["POST_CODE"].ToString()));
                else if (dt.Rows[i]["STEP_NO"].ToString().Equals(CValue.STEP_D3))
                    strResult += string.Format("{0}审批", cod.GetDDLTextByValue("ddl_ua_role", dt.Rows[i]["POST_CODE"].ToString()));
                else
                    strResult += string.Format("{0}申请", cod.GetDDLTextByValue("ddl_ua_role", dt.Rows[i]["POST_CODE"].ToString()));
                if (i != dt.Rows.Count - 1)
                    strResult += "=>";
            }
            return strResult;
        }

        /// <summary>
        ///  通过操作类型获得撤销审批岗位描述
        /// </summary>
        /// <param name="strWorkType"></param>
        /// <returns></returns>
        private string GetPostNote_Revoke(string strWorkType)
        {
            string strResult = string.Empty;//审批岗位描述
            //获得审批类型
            string strSQL1 = string.Format("SELECT STEP_NO FROM WKF_RULE_QUEUE WHERE DOC_TYPE = '{0}' AND DECLARE_TYPE = 'R' ORDER BY STEP_NO DESC", strWorkType);
            DataTable dt1 = ds.ExecuteTxtDataTable(strSQL1);
            //获取撤销申请角色
            string strSQL = string.Format("SELECT * FROM WKF_RULE_QUEUE WHERE DOC_TYPE = '{0}' AND DECLARE_TYPE = 'R' AND STEP_NO = 'A0' ORDER BY NEXT_STEP_NO,POST_CODE", strWorkType);
            DataTable dt = ds.ExecuteTxtDataTable(strSQL);
            if (dt == null || dt.Rows.Count == 0 || dt1 == null || dt1.Rows.Count == 0)
                return strResult;

            string strStepNo = dt1.Rows[0]["STEP_NO"].ToString();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["NEXT_STEP_NO"].ToString().Length == 0)
                    strResult += string.Format("{0}申请=>直接生效；", cod.GetDDLTextByValue("ddl_ua_role", dt.Rows[i]["POST_CODE"].ToString()));
                else if (dt.Rows[i]["NEXT_STEP_NO"].ToString().Equals(CValue.STEP_D1))
                {
                    if (strStepNo.Equals(CValue.STEP_D1))
                        strResult += "学生申请=>辅导员审批；";
                    else if (strStepNo.Equals(CValue.STEP_D2))
                        strResult += "学生申请=>辅导员审批=>院级管理者审批；";
                    if (strStepNo.Equals(CValue.STEP_D3))
                        strResult += "学生申请=>辅导员审批=>院级管理者审批=>校级管理者审批；";
                }
                else if (dt.Rows[i]["NEXT_STEP_NO"].ToString().Equals(CValue.STEP_D2))
                {
                    if (strStepNo.Equals(CValue.STEP_D2))
                        strResult += "辅导员申请=>院级管理者审批；";
                    if (strStepNo.Equals(CValue.STEP_D3))
                        strResult += "辅导员申请=>院级管理者审批=>校级管理者审批；";
                }
                else if (dt.Rows[i]["NEXT_STEP_NO"].ToString().Equals(CValue.STEP_D3))
                {
                    strResult += string.Format("院级管理者申请=>校级管理者审批；", string.Empty);
                }
            }
            return strResult;
        }

        #endregion 获取列表

        #region 删除

        private string Delete()
        {
            string strDOC_TYPE = Post("DOC_TYPE");
            if (string.IsNullOrEmpty(strDOC_TYPE))
                return "单据类型不能为空！";

            if (!DeletOldData(strDOC_TYPE))
                return "删除出错！";
            return string.Empty;
        }

        #region 删除原有数据

        /// <summary>
        /// 删除原有数据
        /// </summary>
        /// <param name="doc_type"></param>
        /// <param name="custom_code"></param>
        /// <param name="area_code"></param>
        /// <returns></returns>
        private bool DeletOldData(string doc_type)
        {
            try
            {
                ds.ExecuteTxtNonQuery(string.Format("DELETE FROM WKF_RULE_QUEUE WHERE DOC_TYPE ='{0}'", doc_type));
                return true;
            }
            catch (Exception ex)
            {
                log.Debug(string.Format("删除原有规则数据失败！原因：{0}", ex.Message));
                return false;
            }
        }

        #endregion 删除原有数据

        #endregion 删除

        #region 保存方法

        #region 确认事务处理

        private string SaveData()
        {
            if (!DeletOldData(Post("DOC_TYPE_2")))
                return "删除失败！";//删除原有数据
            if (InsertNewRule(Post("DOC_TYPE_2")))
                return string.Empty;
            return "删除失败！";
        }

        #endregion 确认事务处理

        #region 生成新的流转规则

        /// <summary>
        /// 生成新的流转规则
        /// </summary>
        /// <param name="doc_type"></param>
        /// <returns></returns>
        private bool InsertNewRule(string doc_type)
        {
            DataTable dtbiz = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM COD_BIZ_CODES A WHERE A.DOC_TYPE='{0}' ", doc_type));
            DataRow drbiz = null;
            if (cod.TableIsValid(dtbiz))
                drbiz = dtbiz.Rows[0];
            else
                return false;
            try
            {
                string op_time = ComTranClass.getInstance().GetCurrLongDateTime();
                if (Post("hidaudit_type").ToString().Equals("Ctype1"))
                {
                    WKF_RuleQueueHandleCLass.getInstance().SetOneLevelRule(doc_type, user.User_Id, op_time);
                }
                else if (Post("hidaudit_type").ToString().Equals("Ctype2"))
                {
                    if (Post("hiddeclare_man").ToString().Equals("Declare_S"))
                        WKF_RuleQueueHandleCLass.getInstance().SetTwoLevelRule(doc_type, user.User_Id, op_time);
                    else
                        WKF_RuleQueueHandleCLass.getInstance().SetTwoLevelRule_F(doc_type, user.User_Id, op_time);
                }
                else if (Post("hidaudit_type").ToString().Equals("Ctype3"))
                {
                    if (Post("hiddeclare_man").ToString().Equals("Declare_S"))
                        WKF_RuleQueueHandleCLass.getInstance().SetThreeLevelRule(doc_type, user.User_Id, op_time);
                    else if (Post("hiddeclare_man").ToString().Equals("Declare_F"))
                        WKF_RuleQueueHandleCLass.getInstance().SetThreeLevelRule_F(doc_type, user.User_Id, op_time);
                    else
                        WKF_RuleQueueHandleCLass.getInstance().SetThreeLevelRule_Y(doc_type, user.User_Id, op_time);
                }
                else if (Post("hidaudit_type").ToString().Equals("Ctype_Q"))
                {
                    if (Post("hiddeclare_man").ToString().Equals("Declare_D"))
                        WKF_RuleQueueHandleCLass.getInstance().SetQZRule(doc_type, user.User_Id, op_time);
                }

                #region 撤销申请审批流转规则

                string audit_type = Post("hidaudit_type").Equals("Ctype1") ? "F" : (Post("hidaudit_type").Equals("Ctype2") ? "Y" : "X");
                if (Post("hiddeclare_man").ToString().Equals("Declare_S"))
                {
                    if (Post("hidrevoke_type").ToString().Equals("Revoke1"))
                        WKF_RuleQueueHandleCLass.getInstance().SetRevokeRule_S_F(doc_type, user.User_Id, op_time, audit_type);
                    else if (Post("hidrevoke_type").ToString().Equals("Revoke2"))
                        WKF_RuleQueueHandleCLass.getInstance().SetRevokeRule_S_Y(doc_type, user.User_Id, op_time, audit_type);
                    else if (Post("hidrevoke_type").ToString().Equals("Revoke3"))
                        WKF_RuleQueueHandleCLass.getInstance().SetRevokeRule_S_X(doc_type, user.User_Id, op_time, audit_type);
                }
                else if (Post("hiddeclare_man").ToString().Equals("Declare_F"))
                {
                    if (Post("hidrevoke_type").ToString().Equals("Revoke2"))
                        WKF_RuleQueueHandleCLass.getInstance().SetRevokeRule_F_Y(doc_type, user.User_Id, op_time, audit_type);
                    else if (Post("hidrevoke_type").ToString().Equals("Revoke3"))
                        WKF_RuleQueueHandleCLass.getInstance().SetRevokeRule_F_X(doc_type, user.User_Id, op_time, audit_type);
                }
                else if (Post("hiddeclare_man").ToString().Equals("Declare_Y"))
                {
                    if (Post("hidrevoke_type").ToString().Equals("Revoke2"))
                        WKF_RuleQueueHandleCLass.getInstance().SetRevokeRule_Y_Y(doc_type, user.User_Id, op_time, audit_type);
                    else if (Post("hidrevoke_type").ToString().Equals("Revoke3"))
                        WKF_RuleQueueHandleCLass.getInstance().SetRevokeRule_Y_X(doc_type, user.User_Id, op_time, audit_type);
                }

                #endregion 撤销申请审批流转规则

                return true;
            }
            catch (Exception ex)
            {
                // info = string.Format("生成新的流转规则失败！原因：{0}", ex.Message);
                return false;
            }
        }

        #endregion 生成新的流转规则

        #region 校验单据是否存在设置

        /// <summary>
        /// 校验单据是否存在设置
        /// </summary>
        /// <param name="doc_type">单据类型</param>
        /// <returns></returns>
        private string SaveChk()
        {
            if (string.IsNullOrEmpty(Get("dctype")))
                return "单据类型不能为空！";
            string doc_type = Get("dctype");
            Object obtype = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM WKF_RULE_QUEUE A WHERE A.DOC_TYPE='{0}'", doc_type));
            if (int.Parse(obtype.ToString()) > 0)
            {
                return "已存在该单据的业务流转规则，是否重新添加?";
            }
            return string.Empty;
        }

        #endregion 校验单据是否存在设置

        #endregion 保存方法
    }
}