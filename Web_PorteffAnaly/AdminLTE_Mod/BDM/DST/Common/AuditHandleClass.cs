using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using HQ.Architecture.Factory;
using HQ.DALFactory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.Common
{
    public class AuditHandleClass
    {
        #region 初始化定义

        private static AuditHandleClass m_instance = new AuditHandleClass();
        private comdata cod = new comdata();
        private IDataSource ds = DataSourceFactory.GetDataSource();

        public AuditHandleClass()
        {
        }

        public static AuditHandleClass getInstance()
        {
            return m_instance;
        }

        #endregion 初始化定义

        #region 提交家庭调查表

        public bool SubmitSurvey(string doc_type, string doc_no, string op_user, string pos_code, string op_notes, out string msg)
        {
            try
            {
                //if (!WKF_ExternalInterface.getInstance().Chk_ClientParam(doc_type, doc_no, op_user, out msg))
                //    return false;
                var m_code = WKF_BusDataHandleCLass.getInstance().GetCodBiz(doc_type, out msg);
                if (m_code == null)
                    return false;
                DataRow drData = WKF_BusDataHandleCLass.getInstance().GetBusHeadData(m_code, doc_no, out msg);
                if (drData == null)
                    return false;
                if (!WKF_BusDataHandleCLass.getInstance().UpdateChk_status(m_code, doc_no, WKF_VLAUES.HANDLE_STATUS_Y, out msg))
                    return false;

                string op_time = ComTranClass.getInstance().GetCurrLongDateTime();
                ds.ExecuteTxtNonQuery(string.Format("UPDATE {0} SET {1}='{2}',{3}='{4}',{5}='{6}' WHERE {7}='{8}'", m_code.BUS_TABLE, WKF_VLAUES.COLUMN_CHK_STATUS, WKF_VLAUES.HANDLE_STATUS_N, WKF_VLAUES.COLUMN_RET_CHANNEL, CValue.RET_CHANNEL_A0010, WKF_VLAUES.COLUMN_POS_CODE, pos_code, m_code.BUS_COLUMN, doc_no));

                //创建工作日志
                CreateNewLog(doc_type, doc_no, CValue.DECLARE_TYPE_D, CValue.STEP_A0, CValue.RET_CHANNEL_A0010, pos_code, op_user, op_time, op_notes);

                return true;
            }
            catch (Exception ex)
            {
                var m_code = WKF_BusDataHandleCLass.getInstance().GetCodBiz(doc_type, out msg);
                WKF_BusDataHandleCLass.getInstance().UpdateChk_status(m_code, doc_no, WKF_VLAUES.HANDLE_STATUS_N, out msg);
                msg = ex.Message;
                return false;
            }
        }

        #endregion 提交家庭调查表

        #region 处理审批事务

        public bool AuditTranHandle(string doc_type, string doc_no, string op_user, string pos_code, string audit_result, string audit_note, string level_info, out string msg)
        {
            try
            {
                if (!WKF_ExternalInterface.getInstance().Chk_ClientParam(doc_type, doc_no, op_user, out msg))
                    return false;
                var m_code = WKF_BusDataHandleCLass.getInstance().GetCodBiz(doc_type, out msg);
                if (m_code == null)
                    return false;
                DataRow drData = WKF_BusDataHandleCLass.getInstance().GetBusHeadData(m_code, doc_no, out msg);
                if (drData == null)
                    return false;
                if (!WKF_BusDataHandleCLass.getInstance().UpdateChk_status(m_code, doc_no, WKF_VLAUES.HANDLE_STATUS_Y, out msg))
                    return false;

                string ret_channel = WKF_AuditHandleCLass.getInstance().GetAuditRet_Channel(drData[WKF_VLAUES.COLUMN_STEP_NO].ToString(), audit_result);

                Wkf_rule_queue rule = WKF_RuleQueueHandleCLass.getInstance().GetCurrRule(doc_type, WKF_VLAUES.DECLARE_TYPE_D, drData[WKF_VLAUES.COLUMN_STEP_NO].ToString(), ret_channel, drData[WKF_VLAUES.COLUMN_POS_CODE].ToString());
                if (rule == null)
                    return false;

                string next_step_no = rule.NEXT_STEP_NO;
                string next_ret_channel = rule.NEXT_RET_CHANNEL;
                string next_post_code = rule.NEXT_POST_CODE;
                string declare_type = rule.DECLARE_TYPE;
                string op_time = ComTranClass.getInstance().GetCurrLongDateTime();
                string audit_pos_code = audit_result.Equals("P") ? string.Format(",{0}='{1}'", WKF_VLAUES.COLUMN_AUDIT_POS_CODE, pos_code) : string.Empty;
                ds.ExecuteTxtNonQuery(string.Format("UPDATE {0} SET {3}='{4}',{5}='{6}',{7}='{8}',{9}='{10}',{11}='{12}',{13}='{14}'{15}{16} WHERE {1}='{2}'", m_code.BUS_TABLE, m_code.BUS_COLUMN, doc_no, WKF_VLAUES.COLUMN_STEP_NO, next_step_no, WKF_VLAUES.COLUMN_CHK_STATUS, WKF_VLAUES.HANDLE_STATUS_N, WKF_VLAUES.COLUMN_RET_CHANNEL, next_ret_channel, WKF_VLAUES.COLUMN_POS_CODE, next_post_code, WKF_VLAUES.COLUMN_DECLARE_TYPE, declare_type, WKF_VLAUES.COLUMN_CHK_TIME, op_time, level_info, audit_pos_code));

                //创建工作日志
                CreateNewLog(doc_type, doc_no, CValue.DECLARE_TYPE_D, drData[WKF_VLAUES.COLUMN_STEP_NO].ToString(), ret_channel, pos_code, op_user, op_time, audit_note);

                return true;
            }
            catch (Exception ex)
            {
                var m_code = WKF_BusDataHandleCLass.getInstance().GetCodBiz(doc_type, out msg);
                WKF_BusDataHandleCLass.getInstance().UpdateChk_status(m_code, doc_no, WKF_VLAUES.HANDLE_STATUS_N, out msg);
                msg = ex.Message;
                return false;
            }
        }

        #endregion 处理审批事务

        #region 创建工作日志

        public bool CreateNewLog(string doc_type, string doc_no, string declare_type, string step_no, string ret_channel, string post_code, string op_user, string op_time, string op_notes)
        {
            try
            {
                string strInsertSql = string.Format("INSERT INTO Wkf_client_log (OID,DOC_TYPE,DOC_NO,DECLARE_TYPE,STEP_NO,RET_CHANNEL,POST_CODE,OP_USER,OP_TIME,OP_NOTES,HANDLE_STATUS,HANDLE_TIME,HANDLE_MSG,OP_USER_NAME) VALUES ('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}')", Guid.NewGuid().ToString(), doc_type, doc_no, declare_type, step_no, ret_channel, post_code, op_user, op_time, op_notes, WKF_VLAUES.HANDLE_STATUS_Y, op_time, string.Empty, ComHandleClass.getInstance().ByUserIdGetUserName(op_user));
                ds.ExecuteTxtNonQuery(strInsertSql);
                return true;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(string.Empty, string.Format("创建工作日志异常，原因：{0}", ex.Message));
                return false;
            }
        }

        #endregion 创建工作日志
    }
}