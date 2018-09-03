using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.Architecture.Factory;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;
using HQ.WebForm.Kernel;
using serverservice;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.Insur.ProjectCheck
{
    public partial class CheckList : Main
    {
        #region 界面初始化

        private comdata cod = new comdata();
        private datatables tables = new datatables();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public bool bIsSelectSingle = true;//是否单选
        public bool bIsShowBtnCheck = false;//是否显示核对按钮
        public bool bIsShowBtnMulitCheck = false;//是否显示批量核对按钮

        protected void Page_Load(object sender, EventArgs e)
        {
            string optype = Request.QueryString["optype"];
            if (!string.IsNullOrEmpty(optype))
            {
                switch (optype.ToLower().Trim())
                {
                    case "getlist":
                        Response.Write(GetListData());
                        Response.End();
                        break;

                    case "delete"://删除操作
                        Response.Write(DeleteData());
                        Response.End();
                        break;

                    case "save"://保存操作
                        Response.Write(SaveData());
                        Response.End();
                        break;

                    case "iscan_check":
                        Response.Write(IsCanCheck());
                        Response.End();
                        break;

                    case "multi_check":
                        Response.Write(MultiCheck());
                        Response.End();
                        break;

                    case "save_refund":
                        Response.Write(SaveRefund());
                        Response.End();
                        break;

                    case "stuinfo":
                        Response.Write(GetStuInfo());
                        Response.End();
                        break;
                }
            }
            //界面加载参数
            PageParamInit();
        }

        /// <summary>
        /// 界面加载参数
        /// </summary>
        private void PageParamInit()
        {
            switch (user.User_Role)
            {
                case "S"://学生
                    bIsShowBtnCheck = true;
                    bIsShowBtnMulitCheck = false;
                    break;
                case "F"://辅导员
                    bIsShowBtnCheck = true;
                    bIsShowBtnMulitCheck = true;
                    break;
                case "Y"://学院
                    bIsShowBtnCheck = false;
                    bIsShowBtnMulitCheck = true;
                    break;
            }
        }

        #endregion 界面初始化

        #region 自定义获取查询列表

        private string GetListData()
        {
            Hashtable ddl = new Hashtable();
            ddl["STEP_NO"] = "ddl_STEP_NO";//单据流转环节
            ddl["CHK_STATUS"] = "ddl_CHK_STATUS";//单据锁单状态
            ddl["DECLARE_TYPE"] = "ddl_DECLARE_TYPE";//单据申请类型
            ddl["RET_CHANNEL"] = "ddl_RET_CHANNEL";//单据回执状态
            ddl["INSUR_TYPE_NAME"] = "ddl_insur_type";
            ddl["INSUR_YEAR_NAME"] = "ddl_year_type";
            ddl["XY_NAME"] = "ddl_department";
            ddl["ZY_NAME"] = "ddl_zy";
            ddl["CLASS_CODE_NAME"] = "ddl_class";
            ddl["CHECK_STEP_NAME"] = "ddl_apply_check_step";
            ddl["APPLY_TYPE_NAME"] = "ddl_apply_insur_type";
            ddl["IS_REFUND_NAME"] = "ddl_yes_no";

            string where = string.Empty;
            where += cod.GetDataFilterString(true, "STU_NUMBER", "CLASS_CODE", "XY");//用户数据过滤
            where = GetSearchWhere(where);
            if (!string.IsNullOrEmpty(Get("page_from")))
            {
                if (Get("page_from").ToString().Equals("backcheck"))/// 退回处理
                {
                    where += string.Format(" AND '{0}' BETWEEN CHECK_START AND CHECK_END ", DateTime.Now.ToString("yyyy-MM-dd"));
                }
            }
            return tables.GetCmdQueryData("Get_InsurApply_Checklist", null, where, string.Empty, ddl);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public string GetSearchWhere(string where)
        {
            if (!string.IsNullOrEmpty(Post("INSUR_TYPE")))
                where += string.Format(" AND INSUR_TYPE = '{0}' ", Post("INSUR_TYPE"));
            if (!string.IsNullOrEmpty(Post("INSUR_YEAR")))
                where += string.Format(" AND INSUR_YEAR = '{0}' ", Post("INSUR_YEAR"));
            if (!string.IsNullOrEmpty(Post("INSUR_SEQ_NO")))
                where += string.Format(" AND INSUR_SEQ_NO = '{0}' ", Post("INSUR_SEQ_NO"));
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
            if (!string.IsNullOrEmpty(Post("BACK_NAME")))
                where += string.Format(" AND BACK_NAME LIKE '%{0}%' ", Post("BACK_NAME"));
            if (!string.IsNullOrEmpty(Post("CHECK_STEP")))
            {
                if (Post("CHECK_STEP").Equals("N"))//ZZ 20171106 新增：新增了一个状态“学生未核对”
                {
                    where += string.Format(" AND CHECK_STEP = '' ", string.Empty);
                }
                else
                {
                    where += string.Format(" AND CHECK_STEP = '{0}' ", Post("CHECK_STEP"));
                }
            }
            if (!string.IsNullOrEmpty(Post("IS_REFUND")))
                where += string.Format(" AND IS_REFUND = '{0}' ", Post("IS_REFUND"));
            return where;
        }

        #endregion 自定义获取查询列表

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            string strOID = Get("id");
            if (string.IsNullOrEmpty(strOID))
                return "OID为空,不允许删除操作";
            Insur_apply_check head = new Insur_apply_check();
            head.OID = strOID;
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<Insur_apply_check>("Insur_apply_checkDeleteTransaction");
            transaction.EntityList.Add(head);

            if (!transaction.Commit())
                return "删除失败！";

            return string.Empty;
        }

        #endregion 删除数据

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            bool bFlag = false;
            //新增
            Insur_apply_check head = new Insur_apply_check();
            if (string.IsNullOrEmpty(Post("CHECK_OID")))
            {
                head.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(head);
                head.SEQ_NO = Post("hidApplySeqNo");
                GetFormValue(head);
                //是否申请弃保 字段，如果没有值 就赋值 ，默认值 为否
                if (string.IsNullOrWhiteSpace(Post("IS_REFUND")))
                    head.IS_REFUND = CValue.FLAG_N;

                var inserttrcn = ImplementFactory.GetInsertTransaction<Insur_apply_check>("Insur_apply_checkInsertTransaction", user.User_Name);
                inserttrcn.EntityList.Add(head);
                if (inserttrcn.Commit())
                    bFlag = true;
            }
            else //修改
            {
                head.OID = Post("CHECK_OID");
                ds.RetrieveObject(head);
                GetFormValue(head);
                //是否申请弃保 字段，如果没有值 就赋值 ，默认值 为否
                if (string.IsNullOrWhiteSpace(Post("IS_REFUND")))
                    head.IS_REFUND = CValue.FLAG_N;

                var updatetrcn = ImplementFactory.GetUpdateTransaction<Insur_apply_check>("Insur_apply_checkUpdateTransaction", user.User_Name);
                if (updatetrcn.Commit(head))
                    bFlag = true;
            }
            if (bFlag)
            {
                #region 保存成功之后，修改的 手机号、身份证号、银行卡号 同步更新至学生个人信息中

                //ZZ 20171213 修改：保存成功之后，修改的 手机号、身份证号、银行卡号 同步更新至学生个人信息中
                Dictionary<string, string> param = new Dictionary<string, string>();
                param.Add("SEQ_NO", head.SEQ_NO);
                Insur_project_apply apply = InsurHandleClass.getInstance().GetInsurProjectApplyInfo(param);
                if (apply != null)
                {
                    //手机号
                    if (!string.IsNullOrWhiteSpace(Post("STU_PHONE")))
                    {
                        StuHandleClass.getInstance().ByStuNumberUpStuInfo_Phone(apply.STU_NUMBER, Post("STU_PHONE"));
                    }
                    //身份证号
                    if (!string.IsNullOrWhiteSpace(Post("STU_IDNO")))
                    {
                        StuHandleClass.getInstance().ByStuNumberUpStuInfo_IDNo(apply.STU_NUMBER, Post("STU_IDNO"));
                    }
                    //银行卡号
                    if (!string.IsNullOrWhiteSpace(Post("STU_BANDKCODE")))
                    {
                        StuHandleClass.getInstance().ByStuNumberUpStuInfo_BankCode(apply.STU_NUMBER, Post("STU_BANDKCODE"));
                    }
                }

                #endregion 保存成功之后，修改的 手机号、身份证号、银行卡号 同步更新至学生个人信息中

                StringBuilder json = new StringBuilder();//用来存放Json的
                json.Append("{");
                json.Append(Json.StringToJson(head.OID, "OID"));
                json.Append(",");
                json.Append(Json.StringToJson(head.SEQ_NO, "SEQ_NO"));
                json.Append("}");
                return json.ToString();
            }
            else
            {
                return string.Empty;
            }
        }

        #region 获取页面文本

        /// <summary>
        /// 获取界面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetFormValue(Insur_apply_check model)
        {
            switch (user.User_Role)
            {
                case "S"://学生
                    model.CHECK_STEP = "1";//学生已核对
                    model.S_CHECK_CODE = user.User_Id;
                    model.S_CHECK_NAME = user.User_Name;
                    model.S_CHECK_TIME = GetDateLongFormater();
                    break;
                case "F"://辅导员
                    model.CHECK_STEP = "2";//辅导员已核对
                    model.F_CHECK_CODE = user.User_Id;
                    model.F_CHECK_NAME = user.User_Name;
                    model.F_CHECK_TIME = GetDateLongFormater();
                    break;
                case "Y"://学院
                    model.CHECK_STEP = "3";//学院已核对
                    model.Y_CHECK_CODE = user.User_Id;
                    model.Y_CHECK_NAME = user.User_Name;
                    model.Y_CHECK_TIME = GetDateLongFormater();
                    break;
            }
            model.OLD_INSUR_LIMITDATE = Post("OLD_INSUR_LIMITDATE");
            model.OLD_INSUR_MONEY = cod.ChangeDecimal(Post("OLD_INSUR_MONEY"));
            //model.NEW_INSUR_LIMITDATE = Post("NEW_INSUR_LIMITDATE");
            model.NEW_INSUR_MONEY = cod.ChangeDecimal(Post("NEW_INSUR_MONEY"));
            model.REMARK = Post("REMARK");
            model.APPLY_TYPE = Post("APPLY_TYPE");
        }

        #endregion 获取页面文本

        #endregion 保存数据

        #region 判断是否可以核对

        /// <summary>
        /// 判断是否可以核对
        /// </summary>
        /// <returns></returns>
        private string IsCanCheck()
        {
            try
            {
                if (string.IsNullOrEmpty(Get("id")))
                    return "保险申请主键不能为空！";

                string strMsg = string.Empty;
                if (!InsurHandleClass.getInstance().IsCanCheck(Get("id"), user.User_Role, out strMsg))
                    return strMsg;
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "校验是否可以进行信息核对，出错：" + ex.ToString());
                return "校验是否可以进行信息核对失败！";
            }
        }

        #endregion 判断是否可以核对

        #region 批量确认核对信息

        /// <summary>
        /// 批量确认核对信息
        /// </summary>
        /// <returns></returns>
        private string MultiCheck()
        {
            try
            {
                DataTable dtMultiCheck = GetMultiCheckData();
                if (dtMultiCheck == null)
                    return "批量核对失败：批量核对数据读取失败！";
                int nSuccessNum = 0;
                int nFailNum = 0;
                foreach (DataRow row in dtMultiCheck.Rows)
                {
                    #region 筛选可以核对信息的数据

                    //筛选可以核对信息的数据
                    if (row == null)
                        continue;
                    string strMsg = string.Empty;
                    if (!InsurHandleClass.getInstance().IsCanCheck(row["OID"].ToString(), user.User_Role, out strMsg))
                    {
                        nFailNum++;
                        continue;
                    }

                    #endregion 筛选可以核对信息的数据

                    #region 更新核对信息

                    Insur_project_apply head = new Insur_project_apply();
                    head.OID = row["OID"].ToString();
                    ds.RetrieveObject(head);
                    if (head == null)
                        continue;
                    Insur_apply_check check = InsurHandleClass.getInstance().GetApplyCheckInfo(head.SEQ_NO);
                    check.OID = check.OID;
                    ds.RetrieveObject(check);

                    #region 由于医保新增了 参保人员字段，未填写以及 判断附件是否存在

                    //ZZ 20171214 新增校验：由于医保新增了 参保人员字段，未填写以及 判断附件是否存在
                    if (head.INSUR_TYPE.Equals("A"))//医保
                    {
                        //判断 参保人员类别 字段是否填写
                        if (check.APPLY_TYPE.Length == 0)//医保时，参保人员类别 字段必填
                            continue;
                        //判断 参保人员类别 != 普通在校生 时，校验是否上传了附件
                        if (!check.APPLY_TYPE.Equals("A"))
                        {
                            string strSQL = string.Format("SELECT COUNT(*) FROM INSUR_APPLY_CHECK_FILE WHERE SEQ_NO = '{0}' ", check.SEQ_NO);
                            int nCount = cod.ChangeInt(ds.ExecuteTxtScalar(strSQL).ToString());
                            if (nCount <= 0)
                            {
                                continue;
                            }
                        }
                    }

                    #endregion 由于医保新增了 参保人员字段，未填写以及 判断附件是否存在

                    switch (user.User_Role)
                    {
                        case "F"://辅导员
                            check.CHECK_STEP = "2";//辅导员已核对
                            check.F_CHECK_CODE = user.User_Id;
                            check.F_CHECK_NAME = user.User_Name;
                            check.F_CHECK_TIME = GetDateLongFormater();
                            break;
                        case "Y"://学院
                            check.CHECK_STEP = "3";//学院已核对
                            check.Y_CHECK_CODE = user.User_Id;
                            check.Y_CHECK_NAME = user.User_Name;
                            check.Y_CHECK_TIME = GetDateLongFormater();
                            break;
                    }
                    ds.UpdateObject(check);
                    nSuccessNum++;

                    #endregion 更新核对信息

                    #region 同步学生信息中的手机号，修改成核对后的数据

                    if (check.CHECK_STEP.Equals("3"))
                    {
                        #region 承保期限

                        if (check.NEW_INSUR_LIMITDATE.ToString().Length > 0)
                        {
                            head.INSUR_LIMITDATE = check.NEW_INSUR_LIMITDATE;
                        }

                        #endregion 承保期限

                        #region 金额

                        //金额大于0
                        if (check.NEW_INSUR_MONEY.ToString().Length > 0 && cod.ChangeInt(check.NEW_INSUR_MONEY.ToString()) > 0)
                        {
                            head.INSUR_MONEY = check.NEW_INSUR_MONEY;
                        }

                        #endregion 金额

                        ds.UpdateObject(head);
                    }

                    #endregion 同步学生信息中的手机号，修改成核对后的数据
                }

                return string.Format("批量核对成功：生效{0}条记录，不生效{1}条记录。", nSuccessNum, nFailNum);
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "保险核对信息批量核对出错：" + ex.ToString());
                return "批量核对失败！";
            }
        }

        /// <summary>
        /// 查询批量审核数据集合
        /// </summary>
        /// <returns></returns>
        private DataTable GetMultiCheckData()
        {
            StringBuilder strSql = new StringBuilder();
            strSql.AppendFormat("SELECT T.*,ROW_NUMBER() OVER(ORDER BY T.CHK_TIME DESC) RN ");
            strSql.AppendFormat("FROM( ");
            strSql.AppendFormat("SELECT A.*, ");
            strSql.AppendFormat("A.INSUR_TYPE AS INSUR_TYPE_NAME, ");
            strSql.AppendFormat("A.INSUR_YEAR AS INSUR_YEAR_NAME, ");
            strSql.AppendFormat("A.XY AS XY_NAME, ");
            strSql.AppendFormat("A.ZY AS ZY_NAME, ");
            strSql.AppendFormat("A.CLASS_CODE AS CLASS_CODE_NAME, ");
            strSql.AppendFormat("B.OID AS CHECK_OID, ");
            strSql.AppendFormat("B.OLD_INSUR_LIMITDATE,B.OLD_INSUR_MONEY, ");
            strSql.AppendFormat("B.NEW_INSUR_LIMITDATE,B.NEW_INSUR_MONEY, ");
            strSql.AppendFormat("B.CHECK_STEP,B.CHECK_STEP AS CHECK_STEP_NAME, ");
            strSql.AppendFormat("B.S_CHECK_TIME,B.F_CHECK_TIME,B.Y_CHECK_TIME, ");
            strSql.AppendFormat("B.REMARK ");
            strSql.AppendFormat("FROM (SELECT A.*,B.CHECK_START, B.CHECK_END FROM INSUR_PROJECT_APPLY A LEFT JOIN  INSUR_PROJECT_HEAD B ");
            strSql.AppendFormat("ON A.INSUR_SEQ_NO = B.SEQ_NO) A ");
            strSql.AppendFormat("LEFT JOIN INSUR_APPLY_CHECK B ");
            strSql.AppendFormat("ON A.SEQ_NO = B.SEQ_NO ");
            strSql.AppendFormat(") T WHERE 1=1 ");
            strSql.AppendFormat("AND T.RET_CHANNEL = 'D4000' ");
            strSql.AppendFormat(cod.GetDataFilterString(true, "STU_NUMBER", "CLASS_CODE", "XY"));
            strSql.AppendFormat(GetSearchWhere_MultiCheck());
            //ZZ 20171107 ：新增
            if (!user.User_Role.Equals(CValue.ROLE_TYPE_X))//不是校级管理员时，都需要经过勾选过滤
            {
                string strSelectIds = ComHandleClass.getInstance().GetNoRepeatAndNoEmptyStringSql(Post("SELECT_OID"));
                if (strSelectIds.Length > 0)
                    strSql.AppendFormat("AND T.OID IN ({0}) ", strSelectIds);
            }
            return ds.ExecuteTxtDataTable(strSql.ToString());
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public string GetSearchWhere_MultiCheck()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Get("INSUR_TYPE")))
                where += string.Format(" AND INSUR_TYPE = '{0}' ", Get("INSUR_TYPE"));
            if (!string.IsNullOrEmpty(Get("INSUR_YEAR")))
                where += string.Format(" AND INSUR_YEAR = '{0}' ", Get("INSUR_YEAR"));
            if (!string.IsNullOrEmpty(Get("INSUR_SEQ_NO")))
                where += string.Format(" AND INSUR_SEQ_NO = '{0}' ", Get("INSUR_SEQ_NO"));
            if (!string.IsNullOrEmpty(Get("XY")))
                where += string.Format(" AND XY = '{0}' ", Get("XY"));
            if (!string.IsNullOrEmpty(Get("ZY")))
                where += string.Format(" AND ZY = '{0}' ", Get("ZY"));
            if (!string.IsNullOrEmpty(Get("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Get("GRADE"));
            if (!string.IsNullOrEmpty(Get("CLASS_CODE")))
                where += string.Format(" AND CLASS_CODE = '{0}' ", Get("CLASS_CODE"));
            if (!string.IsNullOrEmpty(Get("STU_NUMBER")))
                where += string.Format(" AND STU_NUMBER LIKE '%{0}%' ", HttpUtility.UrlDecode(Get("STU_NUMBER")));
            if (!string.IsNullOrEmpty(Get("STU_NAME")))
                where += string.Format(" AND STU_NAME LIKE '%{0}%' ", HttpUtility.UrlDecode(Get("STU_NAME")));
            if (!string.IsNullOrEmpty(Get("CHECK_STEP")))
                where += string.Format(" AND CHECK_STEP = '{0}' ", Get("CHECK_STEP"));
            return where;
        }

        #endregion 批量确认核对信息

        #region 确认退费

        /// <summary>
        /// 确认退费
        /// </summary>
        /// <returns></returns>
        private string SaveRefund()
        {
            if (string.IsNullOrWhiteSpace(Post("hidRefond_Oid")))
                return "退费失败，原因：主键不能为空！";
            Insur_apply_check check = new Insur_apply_check();
            check.OID = Post("hidRefond_Oid");
            ds.RetrieveObject(check);
            if (check == null)
                return "退费失败，原因：核对信息不能为空！";
            check.IS_REFUND = CValue.FLAG_Y;
            check.REFUND_NOTES = Post("hidRefond");
            check.REFUND_INSUR_NAME = Post("REFUND_INSUR_NAME");
            ds.UpdateObject(check);

            return string.Empty;
        }

        #endregion 确认退费

        #region 通过学号获得学生信息

        /// <summary>
        /// 通过学号获得学生信息
        /// </summary>
        /// <returns></returns>
        private string GetStuInfo()
        {
            if (string.IsNullOrEmpty(Get("stu_num")))
                return "{}";
            return StuHandleClass.getInstance().GetStuInfoJson(Get("stu_num"));
        }

        #endregion 通过学号获得学生信息
    }
}