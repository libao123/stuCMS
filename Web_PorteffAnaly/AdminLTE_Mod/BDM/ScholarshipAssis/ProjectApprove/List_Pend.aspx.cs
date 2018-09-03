using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectApprove
{
    /// <summary>
    /// 待处理查看
    /// </summary>
    public partial class List_Pend : Main
    {
        #region 界面初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public bool bIsCanMultiAudit = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "multiaudit"://批量审批
                            Response.Write(MultiPAudit());
                            Response.End();
                            break;
                    }
                }
                if (!user.User_Role.Equals("F"))
                    bIsCanMultiAudit = true;
            }
        }

        #endregion 界面初始化

        #region 批量审批

        /// <summary>
        /// 批量审批
        /// </summary>
        /// <returns></returns>
        private string MultiPAudit()
        {
            try
            {
                #region 获得批量审核数据集合

                Dictionary<string, string> param = new Dictionary<string, string>();
                param.Add(string.Format(DataFilterHandleClass.getInstance().Pend_DataFilter(user.User_Role, CValue.DOC_TYPE_BDM03)), string.Empty);
                //ZZ 20171108 修改：加入数据过滤
                DataFilterHandleClass filter = new DataFilterHandleClass();
                filter.InputerInfo("STU_NUMBER", "CLASS_CODE", "XY", user.User_Id, user.User_Role, user.User_Xy);
                switch (user.User_Type)
                {
                    case "S":
                        filter.Student_DataFilter(param);
                        break;
                    case "T":
                        filter.Teacher_DataFilter(param);
                        break;
                    default:
                        filter.DefaultParams(param);
                        break;
                }
                if (!string.IsNullOrEmpty(Get("PROJECT_YEAR")))
                    param.Add("PROJECT_YEAR", Get("PROJECT_YEAR"));
                if (!string.IsNullOrEmpty(Get("PROJECT_CLASS")))
                    param.Add("PROJECT_CLASS", Get("PROJECT_CLASS"));
                if (!string.IsNullOrEmpty(Get("PROJECT_TYPE")))
                    param.Add("PROJECT_TYPE", Get("PROJECT_TYPE"));
                if (!string.IsNullOrEmpty(Get("PROJECT_SEQ_NO")))
                    param.Add("PROJECT_SEQ_NO", Get("PROJECT_SEQ_NO"));
                if (!string.IsNullOrEmpty(Get("XY")))
                    param.Add("XY", Get("XY"));
                if (!string.IsNullOrEmpty(Get("ZY")))
                    param.Add("ZY", Get("ZY"));
                if (!string.IsNullOrEmpty(Get("GRADE")))
                    param.Add("GRADE", Get("GRADE"));
                if (!string.IsNullOrEmpty(Get("CLASS_CODE")))
                    param.Add("CLASS_CODE", Get("CLASS_CODE"));
                if (!string.IsNullOrEmpty(Get("STU_NUMBER")))
                    param.Add(string.Format("STU_NUMBER LIKE '%{0}%' ", HttpUtility.UrlDecode(Get("STU_NUMBER"))), string.Empty);
                if (!string.IsNullOrEmpty(Get("STU_NAME")))
                    param.Add(string.Format("STU_NAME LIKE '%{0}%' ", HttpUtility.UrlDecode(Get("STU_NAME"))), string.Empty);
                if (!string.IsNullOrEmpty(Get("RET_CHANNEL")))
                    param.Add("RET_CHANNEL", Get("RET_CHANNEL"));
                if (!string.IsNullOrEmpty(Get("DECLARE_TYPE")))
                    param.Add("DECLARE_TYPE", Get("DECLARE_TYPE"));
                //ZZ 20171107 ：新增
                if (!user.User_Role.Equals(CValue.ROLE_TYPE_X))//不是校级管理员时，都需要经过勾选过滤
                {
                    string strSelectIds = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(Get("ids"));
                    if (strSelectIds.Length > 0)
                    {
                        param.Add(string.Format(" OID IN ({0}) ", strSelectIds), string.Empty);
                    }
                }
                List<Shoolar_apply_head> applyList = ProjectApplyHandleClass.getInstance().GetApplyHeadList(param);
                if (applyList == null)
                    return "查询批量审批奖助申请数据出错！";

                #endregion 获得批量审核数据集合

                #region 批量审批

                int nSuccess = 0;
                string strFlag = Get("flag");
                foreach (Shoolar_apply_head head in applyList)
                {
                    #region 审核操作

                    if (head == null)
                        continue;

                    string strMsg = WKF_ExternalInterface.getInstance().ChkAudit(head.DOC_TYPE, head.SEQ_NO, user.User_Role);
                    if (strMsg.Length > 0)
                        continue;
                    Shoolar_project_head project_head = ProjectSettingHandleClass.getInstance().GetProjectHead(head.PROJECT_SEQ_NO);
                    if (project_head == null)
                        continue;

                    #region 过了项目申请结束时间，学生、辅导员、学院都不能操作，校级可以审批操作

                    //ZZ 20171221 新增：过了项目申请结束时间，学生、辅导员、学院都不能操作，校级可以审批操作

                    if (!ProjectSettingHandleClass.getInstance().CheckIsFitApplyDate(project_head.APPLY_END, user.User_Role))
                        continue;

                    #endregion 过了项目申请结束时间，学生、辅导员、学院都不能操作，校级可以审批操作

                    #region 申请人数限制放在院级审核的时候，并且再次用条件进行校验

                    if (user.User_Role.Equals(CValue.ROLE_TYPE_Y) && strFlag.Equals("P"))
                    {
                        //ZZ 20171114 新增：申请人数限制放在院级审核的时候，并且再次用条件进行校验
                        Basic_stu_info stu_info = StuHandleClass.getInstance().GetStuInfo_Obj(head.STU_NUMBER);
                        if (stu_info == null || project_head == null)
                            continue;

                        #region 再次校验申请条件

                        //再次校验申请条件
                        if (!ProjectApplyHandleClass.getInstance().CheckProjectLimit(stu_info, project_head, out strMsg))
                        {
                            //发送消息
                            Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                            dicAccpter.Add(head.STU_NUMBER, head.STU_NAME);
                            string strMsgContent = string.Format("您好！您的{0}奖助申请不符合该项目申请条件（{1}），该奖助申请数据已被退回预录入状态，望您悉知，谢谢!", head.PROJECT_NAME, strMsg);
                            string strMessageMsg = string.Empty;
                            MessgeHandleClass.getInstance().SendMessge(CValue.MSG_TYPE_M, strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMessageMsg);
                            ////记录日志（屏蔽：不删除之后 不需要记录操作日志，因为已经写入了 审批流程日志中）
                            //LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "奖助院级审核", CValue.LOG_ACTION_TYPE_6, CValue.LOG_RECORD_TYPE_1, string.Format("删除：学号{0}姓名{1} 不满足奖助[{2}]申请条件：{3}", head.STU_NUMBER, head.STU_NAME, head.PROJECT_NAME, strMsg), user.User_Id, user.User_Name, user.UserLoginIP);
                            //20171121 ZZ 屏蔽：物理删除数据不合理，修改成 变成预录入
                            //删除数据
                            //ProjectApplyHandleClass.getInstance().DeleteProjectApplyData(head.SEQ_NO);
                            ProjectApplyHandleClass.getInstance().TurnBackApplyToRetchannelA0000(head.SEQ_NO, CValue.STEP_D2, CValue.RET_CHANNEL_D2020, CValue.ROLE_TYPE_Y, user.User_Name, strMsg);
                            continue;
                        }
                        if (!ProjectApplyHandleClass.getInstance().CheckProjectNotBoth(stu_info, project_head, out strMsg))
                        {
                            //发送消息
                            Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                            dicAccpter.Add(head.STU_NUMBER, head.STU_NAME);
                            string strMsgContent = string.Format("您好！您的{0}奖助申请不符合该项目申请条件（{1}），该奖助申请数据已被退回预录入状态，望您悉知，谢谢!", head.PROJECT_NAME, strMsg);
                            string strMessageMsg = string.Empty;
                            MessgeHandleClass.getInstance().SendMessge(CValue.MSG_TYPE_M, strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMessageMsg);
                            ////记录日志（屏蔽：不删除之后 不需要记录操作日志，因为已经写入了 审批流程日志中）
                            //LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "奖助院级审核", CValue.LOG_ACTION_TYPE_6, CValue.LOG_RECORD_TYPE_1, string.Format("删除：学号{0}姓名{1} 不满足奖助[{2}]申请条件：{3}", head.STU_NUMBER, head.STU_NAME, head.PROJECT_NAME, strMsg), user.User_Id, user.User_Name, user.UserLoginIP);
                            //20171121 ZZ 屏蔽：物理删除数据不合理，修改成 变成预录入
                            //删除数据
                            //ProjectApplyHandleClass.getInstance().DeleteProjectApplyData(head.SEQ_NO);
                            ProjectApplyHandleClass.getInstance().TurnBackApplyToRetchannelA0000(head.SEQ_NO, CValue.STEP_D2, CValue.RET_CHANNEL_D2020, CValue.ROLE_TYPE_Y, user.User_Name, strMsg);
                            continue;
                        }

                        #endregion 再次校验申请条件

                        #region 申请人数已满

                        //由于审核流转需要1秒，等待一秒之后再查询更准确。
                        Thread.Sleep(1000);
                        //申请人数已满
                        if (!ProjectApplyHandleClass.getInstance().CheckProjectNum(stu_info, project_head, out strMsg))
                        {
                            LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "奖助院级审核", CValue.LOG_ACTION_TYPE_6, CValue.LOG_RECORD_TYPE_1, string.Format("学号{0}姓名{1} 不满足奖助[{2}]申请条件：{3}", head.STU_NUMBER, head.STU_NAME, head.PROJECT_NAME, strMsg), user.User_Id, user.User_Name, user.UserLoginIP);
                            Dictionary<string, string> param_projectnum = new Dictionary<string, string>();
                            param_projectnum.Add("SEQ_NO", project_head.SEQ_NO);
                            param_projectnum.Add("XY", stu_info.COLLEGE);
                            List<Shoolar_project_num> projectNum = ProjectSettingHandleClass.getInstance().GetProjectNum(param_projectnum);
                            return string.Format("审核失败，原因：已超出{0}学院所获得的该项目名额人数{1}人！", cod.GetDDLTextByValue("ddl_department", projectNum[0].XY), projectNum[0].APPLY_NUM);
                        }

                        #endregion 申请人数已满
                    }

                    #endregion 申请人数限制放在院级审核的时候，并且再次用条件进行校验

                    strMsg = string.Empty;
                    string strOpNote = string.Format("{0}在{1}操作：奖助申请批量审批{2}", user.User_Id, GetDateLongFormater(), strFlag.Equals("P") ? "通过" : "不通过");
                    if (!WKF_ExternalInterface.getInstance().WKF_Audit(head.DOC_TYPE, head.SEQ_NO, user.User_Id, user.User_Role, strFlag, strOpNote, out strMsg))
                    {
                        LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, strMsg);
                    }

                    #endregion 审核操作

                    #region 审批通过之后给申请人发送信息

                    //审批通过之后给申请人发送信息

                    string strFinalPosCode = WKF_AuditHandleCLass.getInstance().GetFinalPosCode(head.DOC_TYPE);
                    if (!string.IsNullOrEmpty(strFinalPosCode))
                    {
                        if (strFinalPosCode == user.User_Role)
                        {
                            string strApproveInfo = string.Empty;
                            if (strFlag.ToString().Equals("P"))
                                strApproveInfo = "审批通过";
                            else
                                strApproveInfo = "审批不通过";

                            string strMsgContent = "奖助申请：" + head.PROJECT_NAME + strApproveInfo;
                            Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                            dicAccpter.Add(head.STU_NUMBER, head.STU_NAME);
                            MessgeHandleClass.getInstance().SendMessge("M", strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMsg);
                        }
                    }

                    #endregion 审批通过之后给申请人发送信息

                    #region 由于是批量审核，没有弹出相应的审核界面，所以需要更新奖助默认审核信息

                    //由于是批量审核，没有弹出相应的审核界面，所以需要更新奖助默认审核信息
                    if (strFlag.Equals("P"))
                    {
                        string strApproveMsg = ProjectApplyHandleClass.getInstance().GetApproveDefaultInfo(head.PROJECT_NAME, head.PROJECT_TYPE, user.User_Role);
                        string strComMsg = ProjectApplyHandleClass.getInstance().GetApproveDefaultInfo(head.PROJECT_NAME, head.PROJECT_TYPE, user.User_Role);
                        ProjectApplyHandleClass.getInstance().ApproveData_UpTxt(head.SEQ_NO, head.PROJECT_TYPE, user.User_Role, strApproveMsg, strComMsg);
                        nSuccess++;
                    }

                    #endregion 由于是批量审核，没有弹出相应的审核界面，所以需要更新奖助默认审核信息
                }

                #endregion 批量审批

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助批量审批出错：" + ex.ToString());
                return "批量审批失败！";
            }
        }

        #endregion 批量审批
    }
}