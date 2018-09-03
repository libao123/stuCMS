using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectCheck
{
    /// <summary>
    /// 确认核对信息
    /// </summary>
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

                    case "get_remark":
                        Response.Write(GetRemark());
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
                    bIsShowBtnCheck = true;
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
            ddl["PROJECT_CLASS_NAME"] = "ddl_jz_project_class";
            ddl["PROJECT_TYPE_NAME"] = "ddl_jz_project_type";
            ddl["PROJECT_YEAR_NAME"] = "ddl_year_type";
            ddl["XY_NAME"] = "ddl_department";
            ddl["ZY_NAME"] = "ddl_zy";
            ddl["CLASS_CODE_NAME"] = "ddl_class";
            ddl["CHECK_STEP_NAME"] = "ddl_apply_check_step";

            string where = string.Empty;
            where += cod.GetDataFilterString(true, "STU_NUMBER", "CLASS_CODE", "XY");//用户数据过滤
            where = GetSearchWhere(where);
            //不同界面不同控制
            if (!string.IsNullOrEmpty(Get("from_page")))
            {
                //zz 20180312 屏蔽：因为线下的项目，有些核对需要在线上做
                //if (Get("from_page").ToString().Equals("check_check"))//"奖助管理 >> 信息核对 >> 确认核对信息"
                //    where += string.Format(" AND PROJECT_CLASS != 'OUTLINE' ");//排除线下的项目
                //else if (Get("from_page").ToString().Equals("check_import"))//"奖助管理 >> 信息核对 >> 线下项目核对信息导入"
                //    where += string.Format(" AND PROJECT_CLASS = 'OUTLINE' ");//只查询线下的项目
                //else if (Get("page_from").ToString().Equals("backcheck"))/// 退回处理
                //    where += string.Format(" AND '{0}' BETWEEN CHECK_START AND CHECK_END ", DateTime.Now.ToString("yyyy-MM-dd"));
                if (Get("page_from").ToString().Equals("backcheck"))/// 退回处理
                    where += string.Format(" AND '{0}' BETWEEN CHECK_START AND CHECK_END ", DateTime.Now.ToString("yyyy-MM-dd"));
                else if (Get("from_page").ToString().Equals("check_import"))//"奖助管理 >> 信息核对 >> 线下项目核对信息导入"
                    where += string.Format(" AND PROJECT_CLASS = 'OUTLINE' ");//只查询线下的项目
            }
            return tables.GetCmdQueryData("Get_ProjectApply_Checklist", null, where, string.Empty, ddl);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public string GetSearchWhere(string where)
        {
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
            Shoolar_apply_check head = new Shoolar_apply_check();
            head.OID = strOID;
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<Shoolar_apply_check>("Shoolar_apply_checkDeleteTransaction");
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
            Shoolar_apply_check head = new Shoolar_apply_check();
            if (string.IsNullOrEmpty(Post("CHECK_OID")))
            {
                head.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(head);
                head.SEQ_NO = Post("hidApplySeqNo");
                GetFormValue(head);
                var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_apply_check>("Shoolar_apply_checkInsertTransaction", user.User_Name);
                inserttrcn.EntityList.Add(head);
                if (inserttrcn.Commit())
                    bFlag = true;
            }
            else //修改
            {
                head.OID = Post("CHECK_OID");
                ds.RetrieveObject(head);
                GetFormValue(head);
                var updatetrcn = ImplementFactory.GetUpdateTransaction<Shoolar_apply_check>("Shoolar_apply_checkUpdateTransaction", user.User_Name);
                if (updatetrcn.Commit(head))
                    bFlag = true;
            }
            if (bFlag)
            {
                #region 保存成功之后，修改的 学生信息 同步更新至学生个人信息中

                //ZZ 20171213 修改：保存成功之后，修改的 手机号 同步更新至学生个人信息中
                Dictionary<string, string> param = new Dictionary<string, string>();
                param.Add("SEQ_NO", head.SEQ_NO);
                Shoolar_apply_head apply = ProjectApplyHandleClass.getInstance().GetApplyHeadInfo(param);
                if (apply != null)
                {
                    //手机号
                    if (!string.IsNullOrWhiteSpace(Post("STU_PHONE")))
                    {
                        StuHandleClass.getInstance().ByStuNumberUpStuInfo_Phone(apply.STU_NUMBER, Post("STU_PHONE"));
                    }
                    //ZZ 20180319 修改：保存成功之后，修改的 学籍状态以及异动时间 同步更新至学生个人信息中
                    if (!string.IsNullOrWhiteSpace(Post("STU_REGISTER")))
                    {
                        StuHandleClass.getInstance().ByStuNumberUpStuInfo_Register(apply.STU_NUMBER, Post("STU_REGISTER"));
                    }
                    if (!string.IsNullOrWhiteSpace(Post("STU_DIFFDATE")))
                    {
                        StuHandleClass.getInstance().ByStuNumberUpStuInfo_DiffDate(apply.STU_NUMBER, Post("STU_DIFFDATE"));
                    }
                    if (!string.IsNullOrWhiteSpace(Post("STU_RICE_CARD")))
                    {
                        StuHandleClass.getInstance().ByStuNumberUpStuInfo_RiceCard(apply.STU_NUMBER, Post("STU_RICE_CARD"));
                    }
                }

                #endregion 保存成功之后，修改的 学生信息 同步更新至学生个人信息中

                return string.Empty;
            }
            else
            {
                return "保存核对信息失败！";
            }
        }

        #region 获取页面文本

        /// <summary>
        /// 获取界面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetFormValue(Shoolar_apply_check model)
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
            model.OLD_BANKCODE = Post("OLD_BANKCODE");
            model.NEW_BANKCODE = Post("NEW_BANKCODE");
            model.OLD_IDCARDNO = Post("OLD_IDCARDNO");
            model.NEW_IDCARDNO = Post("NEW_IDCARDNO");
            model.REMARK = Post("REMARK");
            model.REMARK_Y = Post("REMARK_Y");
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
                    return "奖助申请主键不能为空！";

                string strMsg = string.Empty;
                if (!ProjectCheckHandleClass.getInstance().IsCanCheck(Get("id"), user.User_Role, "single", out strMsg))
                    return strMsg;
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "校验是否可以进行奖助信息核对失败：" + ex.ToString());
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
                    if (!ProjectCheckHandleClass.getInstance().IsCanCheck(row["OID"].ToString(), user.User_Role, "multi", out strMsg))
                    {
                        nFailNum++;
                        continue;
                    }

                    #endregion 筛选可以核对信息的数据

                    #region 更新核对信息

                    Shoolar_apply_head head = new Shoolar_apply_head();
                    head.OID = row["OID"].ToString();
                    ds.RetrieveObject(head);
                    if (head == null)
                        continue;

                    Shoolar_apply_check check = ProjectCheckHandleClass.getInstance().GetApplyCheckInfo(head.SEQ_NO);
                    check.OID = check.OID;
                    ds.RetrieveObject(check);

                    #region 批量核对时，也需要校验学生核对情况

                    if (head.PROJECT_CLASS.Equals("LIFE"))
                    {
                        //学生需要有饭卡号，银行卡号才可以核对通过
                        if (StuHandleClass.getInstance().ByStuNoGetRiceCard(head.STU_NUMBER).Length == 0)
                        {
                            nFailNum++;
                            continue;
                        }
                        if (check.OLD_BANKCODE.Length == 0 && check.NEW_BANKCODE.Length == 0)
                        {
                            nFailNum++;
                            continue;
                        }
                    }
                    else
                    {
                        //学生需要有银行卡号，身份证号 才可以核对通过
                        if (check.OLD_BANKCODE.Length == 0 && check.NEW_BANKCODE.Length == 0)
                        {
                            nFailNum++;
                            continue;
                        }
                        if (check.OLD_IDCARDNO.Length == 0 && check.NEW_IDCARDNO.Length == 0)
                        {
                            nFailNum++;
                            continue;
                        }
                    }

                    #endregion 批量核对时，也需要校验学生核对情况

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

                    #region 同步学生信息中的银行卡与身份证号，修改成核对后的数据

                    if (check.CHECK_STEP.Equals("3"))
                    {
                        #region 银行卡

                        if (check.NEW_BANKCODE.Length > 0)
                        {
                            head.STU_BANKCODE = check.NEW_BANKCODE;
                            //更新至学生银行卡信息中的银行卡号
                            string strSqlBank = string.Format("UPDATE BASIC_STU_BANK_INFO SET BANKCODE = '{0}' WHERE NUMBER = '{1}' ", head.STU_BANKCODE, head.STU_NUMBER);
                            ds.ExecuteTxtNonQuery(strSqlBank);
                        }

                        #endregion 银行卡

                        #region 身份证

                        if (check.NEW_IDCARDNO.Length > 0)
                        {
                            head.STU_IDCARDNO = check.NEW_IDCARDNO;
                            //更新至学生信息中的身份证号
                            string strSqlID = string.Format("UPDATE BASIC_STU_INFO SET IDCARDNO = '{0}' WHERE NUMBER = '{1}' ", head.STU_IDCARDNO, head.STU_NUMBER);
                            ds.ExecuteTxtNonQuery(strSqlID);
                        }

                        #endregion 身份证

                        ds.UpdateObject(head);
                    }

                    #endregion 同步学生信息中的银行卡与身份证号，修改成核对后的数据
                }
                return string.Format("批量核对成功：生效{0}条记录，不生效{1}条记录。", nSuccessNum, nFailNum);
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "批量审批奖助核对失败：" + ex.ToString());
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
            strSql.AppendFormat("A.PROJECT_CLASS AS PROJECT_CLASS_NAME, ");
            strSql.AppendFormat("A.PROJECT_TYPE AS PROJECT_TYPE_NAME, ");
            strSql.AppendFormat("A.PROJECT_YEAR AS PROJECT_YEAR_NAME, ");
            strSql.AppendFormat("A.XY AS XY_NAME, ");
            strSql.AppendFormat("A.ZY AS ZY_NAME, ");
            strSql.AppendFormat("A.CLASS_CODE AS CLASS_CODE_NAME, ");
            strSql.AppendFormat("B.OID AS CHECK_OID, ");
            strSql.AppendFormat("B.OLD_IDCARDNO,B.OLD_BANKCODE, ");
            strSql.AppendFormat("B.NEW_IDCARDNO,B.NEW_BANKCODE, ");
            strSql.AppendFormat("B.CHECK_STEP,B.CHECK_STEP AS CHECK_STEP_NAME, ");
            strSql.AppendFormat("B.S_CHECK_TIME,B.F_CHECK_TIME,B.Y_CHECK_TIME ");
            strSql.AppendFormat("FROM (SELECT A.*,B.CHECK_START, B.CHECK_END FROM SHOOLAR_APPLY_HEAD A LEFT JOIN  SHOOLAR_PROJECT_HEAD B ");
            strSql.AppendFormat("ON A.PROJECT_SEQ_NO = B.SEQ_NO) A ");
            strSql.AppendFormat("LEFT JOIN SHOOLAR_APPLY_CHECK B ");
            strSql.AppendFormat("ON A.SEQ_NO = B.SEQ_NO ");
            strSql.AppendFormat(") T WHERE 1=1 ");
            strSql.AppendFormat("AND T.RET_CHANNEL = 'D4000' ");
            //ZZ 20180324 修改：由于现在线下项目也需要线上核对 所以这个过滤条件先去掉
            //strSql.AppendFormat("AND T.PROJECT_CLASS != 'OUTLINE'  ");//排除线下的项目
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
            if (!string.IsNullOrEmpty(Get("PROJECT_YEAR")))
                where += string.Format(" AND PROJECT_YEAR = '{0}' ", Get("PROJECT_YEAR"));
            if (!string.IsNullOrEmpty(Get("PROJECT_CLASS")))
                where += string.Format(" AND PROJECT_CLASS = '{0}' ", Get("PROJECT_CLASS"));
            if (!string.IsNullOrEmpty(Get("PROJECT_TYPE")))
                where += string.Format(" AND PROJECT_TYPE = '{0}' ", Get("PROJECT_TYPE"));
            if (!string.IsNullOrEmpty(Get("PROJECT_SEQ_NO")))
                where += string.Format(" AND PROJECT_SEQ_NO = '{0}' ", Get("PROJECT_SEQ_NO"));
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

        #region 获得备注

        /// <summary>
        ///  获得备注
        /// </summary>
        /// <returns></returns>
        private string GetRemark()
        {
            if (string.IsNullOrEmpty(Get("seq_no")))
                return "{}";
            DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT REMARK,REMARK_Y FROM SHOOLAR_APPLY_CHECK WHERE SEQ_NO = '{0}' ", Get("seq_no")));
            if (dt == null || dt.Rows.Count == 0)
                return "{}";
            return Json.DatatableToJson(dt);
        }

        #endregion 获得备注
    }
}