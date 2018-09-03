using System;
using System.Collections.Generic;
using System.Data;
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
using HQ.WebForm.Kernel;

namespace PorteffAnaly.Web.AdminLTE_Mod.APP.DevOps.ScholarshipAssis
{
    public partial class NotFitLimitData : ListBaseLoad<Shoolar_apply_head>
    {
        #region 初始化

        private comdata cod = new comdata();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();

        protected override string input_code_column
        {
            get { return "STU_NUMBER"; }
        }

        protected override string class_code_column
        {
            get { return "CLASS_CODE"; }
        }

        protected override string xy_code_column
        {
            get { return "XY"; }
        }

        protected override bool is_do_filter
        {
            get { return false; }
        }

        protected override SelectTransaction<Shoolar_apply_head> GetSelectTransaction()
        {
            //运维界面：不符合奖助申请条件学生名单
            //只查询 学院审核通过、学校审核通过 的数据，因为在辅导员审核、学院审核的时候 已经做了当前项目限制条件的过滤筛选
            param.Add(string.Format(" RET_CHANNEL IN ('{0}','{1}') ", CValue.RET_CHANNEL_D2010, CValue.RET_CHANNEL_D4000), string.Empty);
            return ImplementFactory.GetSelectTransaction<Shoolar_apply_head>("Shoolar_apply_headSelectTransaction", param);
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

                        case "delete"://删除并发消息告知
                            Response.Write(DeleteData());
                            Response.End();
                            break;

                        case "back_y"://退回学院待审
                            Response.Write(BackY());
                            Response.End();
                            break;

                        case "back_s"://退回预录入
                            Response.Write(BackS());
                            Response.End();
                            break;
                    }
                }
            }
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("PROJECT_YEAR")))
                where += string.Format(" AND PROJECT_YEAR = '{0}' ", Post("PROJECT_YEAR"));
            if (!string.IsNullOrEmpty(Post("PROJECT_CLASS")))
                where += string.Format(" AND PROJECT_CLASS = '{0}' ", Post("PROJECT_CLASS"));
            if (!string.IsNullOrEmpty(Post("PROJECT_TYPE")))
                where += string.Format(" AND PROJECT_TYPE = '{0}' ", Post("PROJECT_TYPE"));
            if (!string.IsNullOrEmpty(Post("PROJECT_SEQ_NO")))
                where += string.Format(" AND PROJECT_SEQ_NO = '{0}' ", Post("PROJECT_SEQ_NO"));
            if (!string.IsNullOrEmpty(Post("XY")))
                where += string.Format(" AND XY = '{0}' ", Post("XY"));
            if (!string.IsNullOrEmpty(Post("ZY")))
                where += string.Format(" AND ZY = '{0}' ", Post("ZY"));
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("CLASS_CODE")))
                where += string.Format(" AND CLASS_CODE = '{0}' ", Post("CLASS_CODE"));
            if (!string.IsNullOrEmpty(Post("STU_NUMBER")))
                where += string.Format(" AND STU_NUMBER LIKE '%{0}%' ", Post("STU_NUMBER"));
            if (!string.IsNullOrEmpty(Post("STU_NAME")))
                where += string.Format(" AND STU_NAME LIKE '%{0}%' ", Post("STU_NAME"));
            if (!string.IsNullOrEmpty(Post("RET_CHANNEL")))
                where += string.Format(" AND RET_CHANNEL = '{0}' ", Post("RET_CHANNEL"));
            if (!string.IsNullOrEmpty(Post("DECLARE_TYPE")))
                where += string.Format(" AND DECLARE_TYPE = '{0}' ", Post("DECLARE_TYPE"));
            if (!string.IsNullOrEmpty(Post("IS_FIT")))
            {
                if (Post("IS_FIT").Equals(CValue.FLAG_Y))//符合
                {
                    where += string.Format(" AND SEQ_NO NOT IN ({0}) ", GetNotFitSeqNo(where));
                }
                else if (Post("IS_FIT").Equals(CValue.FLAG_N))//不符合
                {
                    where += string.Format(" AND SEQ_NO IN ({0}) ", GetNotFitSeqNo(where));
                }
                else
                {
                    where += string.Format(" AND SEQ_NO = '' ", "");
                }
            }
            return where;
        }

        /// <summary>
        /// 查找不符合的SEQ_NO单据
        /// </summary>
        /// <returns></returns>
        private string GetNotFitSeqNo(string where)
        {
            string strResult = string.Empty;
            string strSQL = string.Format("SELECT * FROM SHOOLAR_APPLY_HEAD WHERE RET_CHANNEL IN ('{0}','{1}') {2}", CValue.RET_CHANNEL_D2010, CValue.RET_CHANNEL_D4000, where);
            DataTable dt = ds.ExecuteTxtDataTable(strSQL);
            if (dt == null || dt.Rows.Count == 0)
                return ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(strResult);
            foreach (DataRow row in dt.Rows)
            {
                if (row == null)
                    continue;
                if (GetIsFitLimit(row["STU_NUMBER"].ToString(), row["PROJECT_SEQ_NO"].ToString()).Equals(CValue.FLAG_N))
                    strResult += row["SEQ_NO"].ToString() + ",";
            }
            return ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(strResult);
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Shoolar_apply_head>.NameValue> GetValue(Shoolar_apply_head entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            //项目数据
            yield return new NameValue() { Name = "PROJECT_SEQ_NO", Value = entity.PROJECT_SEQ_NO };
            yield return new NameValue() { Name = "PROJECT_CLASS", Value = entity.PROJECT_CLASS };
            yield return new NameValue() { Name = "PROJECT_CLASS_NAME", Value = cod.GetDDLTextByValue("ddl_jz_project_class", entity.PROJECT_CLASS) };
            yield return new NameValue() { Name = "PROJECT_TYPE", Value = entity.PROJECT_TYPE };
            yield return new NameValue() { Name = "PROJECT_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_jz_project_type", entity.PROJECT_TYPE) };
            yield return new NameValue() { Name = "PROJECT_NAME", Value = entity.PROJECT_NAME };
            yield return new NameValue() { Name = "PROJECT_YEAR", Value = entity.PROJECT_YEAR };
            yield return new NameValue() { Name = "PROJECT_YEAR_NAME", Value = cod.GetDDLTextByValue("ddl_year_type", entity.PROJECT_YEAR) };
            yield return new NameValue() { Name = "PROJECT_MONEY", Value = entity.PROJECT_MONEY.ToString() };
            //申请人数据
            yield return new NameValue() { Name = "STU_NUMBER", Value = entity.STU_NUMBER };
            yield return new NameValue() { Name = "STU_NAME", Value = entity.STU_NAME };
            yield return new NameValue() { Name = "STU_TYPE", Value = entity.STU_TYPE };
            yield return new NameValue() { Name = "STU_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_ua_stu_type", entity.STU_TYPE) };
            yield return new NameValue() { Name = "STU_IDCARDNO", Value = entity.STU_IDCARDNO };
            yield return new NameValue() { Name = "STU_BANKCODE", Value = entity.STU_BANKCODE };
            yield return new NameValue() { Name = "XY", Value = entity.XY };
            yield return new NameValue() { Name = "XY_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.XY) };
            yield return new NameValue() { Name = "ZY", Value = entity.ZY };
            yield return new NameValue() { Name = "ZY_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.ZY) };
            yield return new NameValue() { Name = "CLASS_CODE", Value = entity.CLASS_CODE };
            yield return new NameValue() { Name = "CLASS_CODE_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS_CODE) };
            yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
            //申请人填报数据
            //存在特殊字符的可能，用ajax读取
            //yield return new NameValue() { Name = "POST_INFO", Value = entity.POST_INFO };//曾/现任职情况
            yield return new NameValue() { Name = "STUDY_LEVEL", Value = entity.STUDY_LEVEL };//学习阶段
            yield return new NameValue() { Name = "TRAIN_TYPE", Value = entity.TRAIN_TYPE };//培养方式
            yield return new NameValue() { Name = "HARD_FOR", Value = entity.HARD_FOR };//攻读学位
            yield return new NameValue() { Name = "BASIC_UNIT", Value = entity.BASIC_UNIT };//基层单位
            yield return new NameValue() { Name = "REWARD_FLAG", Value = entity.REWARD_FLAG };//拟评何种类型
            //单据数据
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "DOC_TYPE", Value = entity.DOC_TYPE };
            yield return new NameValue() { Name = "DECL_TIME", Value = entity.DECL_TIME };
            yield return new NameValue() { Name = "CHK_TIME", Value = entity.CHK_TIME };
            yield return new NameValue() { Name = "CHK_STATUS", Value = entity.CHK_STATUS };
            yield return new NameValue() { Name = "CHK_STATUS_NAME", Value = cod.GetDDLTextByValue("ddl_CHK_STATUS", entity.CHK_STATUS) };
            yield return new NameValue() { Name = "DECLARE_TYPE", Value = entity.DECLARE_TYPE };
            yield return new NameValue() { Name = "DECLARE_TYPE_NAME", Value = cod.GetDDLTextByValue("ddl_DECLARE_TYPE", entity.DECLARE_TYPE) };
            yield return new NameValue() { Name = "RET_CHANNEL", Value = entity.RET_CHANNEL };
            yield return new NameValue() { Name = "RET_CHANNEL_NAME", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.RET_CHANNEL) };
            yield return new NameValue() { Name = "POS_CODE", Value = entity.POS_CODE };
            yield return new NameValue() { Name = "AUDIT_POS_CODE", Value = entity.AUDIT_POS_CODE };
            yield return new NameValue() { Name = "STEP_NO", Value = entity.STEP_NO };
            yield return new NameValue() { Name = "STEP_NO_NAME", Value = cod.GetDDLTextByValue("ddl_STEP_NO", entity.STEP_NO) };
            yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
            yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
            yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            yield return new NameValue() { Name = "IS_FIT_LIMIT", Value = GetIsFitLimit(entity.STU_NUMBER, entity.PROJECT_SEQ_NO) };
            yield return new NameValue() { Name = "IS_FIT_LIMIT_NAME", Value = cod.GetDDLTextByValue("ddl_yes_no", GetIsFitLimit(entity.STU_NUMBER, entity.PROJECT_SEQ_NO)) };
            yield return new NameValue() { Name = "NOT_FIT_LIMIT_REMARK", Value = GetNotFitLimitRemark(entity.STU_NUMBER, entity.PROJECT_SEQ_NO) };
        }

        /// <summary>
        /// 是否符合奖助申请条件
        /// Y符合；N不符合
        /// </summary>
        /// <param name="strSTU_NUMBER"></param>
        /// <param name="strPROJECT_SEQ_NO"></param>
        /// <returns></returns>
        private string GetIsFitLimit(string strSTU_NUMBER, string strPROJECT_SEQ_NO)
        {
            Basic_stu_info stu_info = StuHandleClass.getInstance().GetStuInfo_Obj(strSTU_NUMBER);
            Shoolar_project_head project_head = ProjectSettingHandleClass.getInstance().GetProjectHead(strPROJECT_SEQ_NO);
            if (stu_info == null || project_head == null)
                return CValue.FLAG_N;

            string strMsg = string.Empty;

            #region 再次校验申请条件

            //再次校验申请条件
            if (!ProjectApplyHandleClass.getInstance().CheckProjectLimit(stu_info, project_head, out strMsg))
            {
                return CValue.FLAG_N;
            }
            if (!ProjectApplyHandleClass.getInstance().CheckProjectNotBoth(stu_info, project_head, out strMsg))
            {
                return CValue.FLAG_N;
            }

            #endregion 再次校验申请条件

            #region 申请人数已满

            //申请人数已满
            if (!ProjectApplyHandleClass.getInstance().CheckProjectNum(stu_info, project_head, out strMsg))
            {
                return CValue.FLAG_N;
            }

            #endregion 申请人数已满

            return CValue.FLAG_Y;
        }

        /// <summary>
        /// 不符合奖助申请的原因
        /// </summary>
        /// <param name="strSTU_NUMBER"></param>
        /// <param name="strPROJECT_SEQ_NO"></param>
        /// <returns></returns>
        private string GetNotFitLimitRemark(string strSTU_NUMBER, string strPROJECT_SEQ_NO)
        {
            Basic_stu_info stu_info = StuHandleClass.getInstance().GetStuInfo_Obj(strSTU_NUMBER);
            Shoolar_project_head project_head = ProjectSettingHandleClass.getInstance().GetProjectHead(strPROJECT_SEQ_NO);
            if (stu_info == null || project_head == null)
                return "学生信息为空或者奖助项目信息读取失败！";
            string strMsg = string.Empty;

            #region 再次校验申请条件

            //再次校验申请条件
            if (!ProjectApplyHandleClass.getInstance().CheckProjectLimit(stu_info, project_head, out strMsg))
            {
                return strMsg;
            }
            if (!ProjectApplyHandleClass.getInstance().CheckProjectNotBoth(stu_info, project_head, out strMsg))
            {
                return strMsg;
            }

            #endregion 再次校验申请条件

            #region 申请人数是否满足

            Dictionary<string, string> param_num = new Dictionary<string, string>();
            param_num.Add("SEQ_NO", project_head.SEQ_NO);
            param_num.Add("XY", stu_info.COLLEGE);
            List<Shoolar_project_num> projectNum = ProjectSettingHandleClass.getInstance().GetProjectNum(param_num);
            if (projectNum == null)
            {
                return string.Format("项目限制申报人数信息读取失败！");
            }
            if (projectNum.Count == 0)
                return string.Empty;

            int nApplyTotalNum = ProjectApplyHandleClass.getInstance().CheckProjectNum_PassedNum(stu_info, project_head);
            if (projectNum[0].APPLY_NUM <= nApplyTotalNum)
            {
                return strMsg = string.Format("[{0}] 奖助项目 {1} 学院设置的申请人数为 {2} 人，现在学院审核通过人数为 {3} 人，超出了{4} 人。", project_head.PROJECT_NAME, cod.GetDDLTextByValue("ddl_department", stu_info.COLLEGE), projectNum[0].APPLY_NUM, nApplyTotalNum, (nApplyTotalNum - projectNum[0].APPLY_NUM));
            }

            #endregion 申请人数是否满足

            return string.Empty;
        }

        #endregion 输出列表信息

        #region 删除并发消息告知

        /// <summary>
        /// 删除并发消息告知
        /// 删除只会删除申请条件不符合要求的，申请人数已经满了 不在删除的范围内，申请人数超员的情况应该由学院或者学校进行撤销处理。
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "删除失败，原因：主键为空！";

            Shoolar_apply_head head = new Shoolar_apply_head();
            head.OID = Get("id");
            ds.RetrieveObject(head);
            if (head != null)
            {
                #region 申请人数限制放在院级审核的时候，并且再次用条件进行校验

                Basic_stu_info stu_info = StuHandleClass.getInstance().GetStuInfo_Obj(head.STU_NUMBER);
                Shoolar_project_head project_head = ProjectSettingHandleClass.getInstance().GetProjectHead(head.PROJECT_SEQ_NO);
                if (stu_info == null || project_head == null)
                    return "删除失败，原因：学生信息为空或者奖助项目信息为空！";

                string strMsg = string.Empty;

                #region 再次校验申请条件

                //再次校验申请条件
                if (!ProjectApplyHandleClass.getInstance().CheckProjectLimit(stu_info, project_head, out strMsg))
                {
                    string strMessageMsg = string.Empty;
                    //发送消息
                    Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                    dicAccpter.Add(head.STU_NUMBER, head.STU_NAME);
                    string strMsgContent = string.Format("您好！由于系统排查升级，您的{0}奖助申请不符合该项目申请条件（{1}），系统随后会删除该奖助申请数据，给您带来不便请谅解，谢谢!", head.PROJECT_NAME, strMsg);
                    MessgeHandleClass.getInstance().SendMessge("M", strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMessageMsg);
                    //记录操作日志
                    LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "系统运维：不符合奖助申请条件学生名单", CValue.LOG_ACTION_TYPE_6, CValue.LOG_RECORD_TYPE_1, string.Format("删除：学号{0}姓名{1} 不满足奖助[{2}]申请条件：{3}", head.STU_NUMBER, head.STU_NAME, head.PROJECT_NAME, strMsg), user.User_Id, user.User_Name, user.UserLoginIP);
                    //删除数据
                    ProjectApplyHandleClass.getInstance().DeleteProjectApplyData(head.SEQ_NO);
                    return string.Empty;
                }
                if (!ProjectApplyHandleClass.getInstance().CheckProjectNotBoth(stu_info, project_head, out strMsg))
                {
                    string strMessageMsg = string.Empty;
                    //发送消息
                    Dictionary<string, string> dicAccpter = new Dictionary<string, string>();
                    dicAccpter.Add(head.STU_NUMBER, head.STU_NAME);
                    string strMsgContent = string.Format("您好！由于系统排查升级，您的{0}奖助申请不符合该项目申请条件（{1}），系统随后会删除该奖助申请数据，给您带来不便请谅解，谢谢!", head.PROJECT_NAME, strMsg);
                    MessgeHandleClass.getInstance().SendMessge("M", strMsgContent, user.User_Id, user.User_Name, dicAccpter, out strMessageMsg);
                    //记录日志
                    LogDBHandleClass.getInstance().LogOperation(head.SEQ_NO, "奖助院级审核", CValue.LOG_ACTION_TYPE_6, CValue.LOG_RECORD_TYPE_1, string.Format("删除：学号{0}姓名{1} 不满足奖助[{2}]申请条件：{3}", head.STU_NUMBER, head.STU_NAME, head.PROJECT_NAME, strMsg), user.User_Id, user.User_Name, user.UserLoginIP);
                    //删除数据
                    ProjectApplyHandleClass.getInstance().DeleteProjectApplyData(head.SEQ_NO);
                    return string.Empty;
                }

                #endregion 再次校验申请条件

                #endregion 申请人数限制放在院级审核的时候，并且再次用条件进行校验
            }
            return "不满足删除条件！";
        }

        #endregion 删除并发消息告知

        #region 退回学院待审

        /// <summary>
        /// 退回学院待审
        /// </summary>
        /// <returns></returns>
        private string BackY()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "退回学院待审失败，原因：主键为空！";

            Shoolar_apply_head head = new Shoolar_apply_head();
            head.OID = Get("id");
            ds.RetrieveObject(head);
            if (head == null)
                return "退回学院待审失败，原因：奖助申请信息读取失败！";
            if (head.DECLARE_TYPE.Equals(CValue.DECLARE_TYPE_R))
                return "退回学院待审失败，原因：该奖助申请目前正在撤销申请阶段！";

            //退回到院级待审
            string strUpSql = string.Format("UPDATE SHOOLAR_APPLY_HEAD SET RET_CHANNEL='D2000',POS_CODE='Y',STEP_NO='D2',AUDIT_POS_CODE='F' WHERE SEQ_NO = '{0}' ", head.SEQ_NO);
            if (ds.ExecuteTxtNonQuery(strUpSql) > 0)
            {
                //往审批流转表中插入一条记录
                WKF_ClientLogHandleCLass.getInstance().InsertClientLog(head.SEQ_NO, CValue.DOC_TYPE_BDM03, CValue.DECLARE_TYPE_D, CValue.STEP_D2, CValue.RET_CHANNEL_D2000, CValue.ROLE_TYPE_Y, user.User_Name, "在系统运维操作下进行了退回院级待审操作。", CValue.FLAG_Y);
            }

            return string.Empty;
        }

        #endregion 退回学院待审

        #region 退回预录入

        /// <summary>
        /// 退回预录入
        /// </summary>
        /// <returns></returns>
        private string BackS()
        {
            if (string.IsNullOrEmpty(Get("id")))
                return "退回预录入失败，原因：主键为空！";

            Shoolar_apply_head head = new Shoolar_apply_head();
            head.OID = Get("id");
            ds.RetrieveObject(head);
            if (head == null)
                return "退回预录入失败，原因：奖助申请信息读取失败！";
            if (head.DECLARE_TYPE.Equals(CValue.DECLARE_TYPE_R))
                return "退回预录入失败，原因：该奖助申请目前正在撤销申请阶段！";

            //退回到预录入
            string strUpSql = string.Format("UPDATE SHOOLAR_APPLY_HEAD SET RET_CHANNEL='A0000',POS_CODE='',STEP_NO='',AUDIT_POS_CODE='' WHERE SEQ_NO = '{0}' ", head.SEQ_NO);
            if (ds.ExecuteTxtNonQuery(strUpSql) > 0)
            {
                //往审批流转表中插入一条记录
                WKF_ClientLogHandleCLass.getInstance().InsertClientLog(head.SEQ_NO, CValue.DOC_TYPE_BDM03, CValue.DECLARE_TYPE_D, CValue.STEP_D3, CValue.RET_CHANNEL_D3020, CValue.ROLE_TYPE_X, user.User_Name, "在系统运维操作下进行了退回预录入操作。", CValue.FLAG_Y);
            }

            return string.Empty;
        }

        #endregion 退回预录入
    }
}