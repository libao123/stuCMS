using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using AdminLTE_Mod.Common;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebControl;
using HQ.WebForm;
using HQ.WebForm.Kernel;

namespace PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.ClassGroup
{
    public partial class List : Main
    {
        #region 初始化

        private ComHandleClass chc = new ComHandleClass();
        private datatables tables = new datatables();
        public comdata cod = new comdata();
        public Ua_class_group head = new Ua_class_group();

        public override string Doc_type { get { return CValue.DOC_TYPE_UA01; } }

        public string m_strIsShowAuditBtn = "false";//是否显示审批按钮：显示true 不显示false

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
                            Response.Write(GetListData());
                            Response.End();
                            break;

                        case "delete"://删除操作
                            Response.Write(DeleteData());
                            Response.End();
                            break;

                        case "chk"://通过学工号判断是否是辅导员或者研究生
                            Response.Write(ChkUserInfo());
                            Response.End();
                            break;

                        case "getuserinfo"://通过学工号获得辅导员基础信息
                            Response.Write(GetUserInfo());
                            Response.End();
                            break;

                        case "save"://提交操作
                            Response.Write(SaveData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 加载数据

        /// <summary>
        /// 加载数据
        /// </summary>
        private void LoadData()
        {
            if (!string.IsNullOrEmpty(Get("id")))
            {
                head.OID = Get("id");
                ds.RetrieveObject(head);
                //判断是否可以审批
                if (WKF_ExternalInterface.getInstance().ChkAudit(head.DOC_TYPE, head.SEQ_NO, user.User_Role).Length == 0)
                {
                    m_strIsShowAuditBtn = "true";
                }
            }
        }

        #endregion 加载数据

        #region 自定义获取查询列表

        private string GetListData()
        {
            Hashtable ddl = new Hashtable();
            ddl["STEP_NO_NAME"] = "ddl_STEP_NO";//单据流转环节
            ddl["CHK_STATUS_NAME"] = "ddl_CHK_STATUS";//单据锁单状态
            ddl["DECLARE_TYPE_NAME"] = "ddl_DECLARE_TYPE";//单据申请类型
            ddl["RET_CHANNEL_NAME"] = "ddl_RET_CHANNEL";//单据回执状态
            ddl["GROUP_TYPE_NAME"] = "ddl_group_type";
            ddl["XY_NAME"] = "ddl_department";
            ddl["ZY_NAME"] = "ddl_zy";
            ddl["GRADE_NAME"] = "ddl_grade";
            ddl["STU_TYPE_NAME"] = "ddl_basic_stu_type";
            string where = string.Empty;
            where += cod.GetDataFilterString(true, "DECL_NUMBER", "CLASSCODE", "XY");
            where = GetSearchWhere(where);
            return tables.GetCmdQueryData("Get_Apply_ClassGrouplist", null, where, string.Empty, ddl);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public string GetSearchWhere(string where)
        {
            if (!string.IsNullOrEmpty(Post("XY")))
                where += string.Format(" AND XY = '{0}' ", Post("XY"));
            if (!string.IsNullOrEmpty(Post("ZY")))
                where += string.Format(" AND ZY = '{0}' ", Post("ZY"));
            if (!string.IsNullOrEmpty(Post("GRADE")))
                where += string.Format(" AND GRADE = '{0}' ", Post("GRADE"));
            if (!string.IsNullOrEmpty(Post("CLASSCODE")))
                where += string.Format(" AND CLASSCODE = '{0}' ", Post("CLASSCODE"));
            if (!string.IsNullOrEmpty(Post("GROUP_NUMBER")))
                where += string.Format(" AND GROUP_NUMBER LIKE '%{0}%' ", Post("GROUP_NUMBER"));
            if (!string.IsNullOrEmpty(Post("GROUP_NAME")))
                where += string.Format(" AND GROUP_NAME LIKE '%{0}%' ", Post("GROUP_NAME"));
            if (!string.IsNullOrEmpty(Post("GROUP_TYPE")))
                where += string.Format(" AND GROUP_TYPE = '{0}' ", Post("GROUP_TYPE"));
            if (!string.IsNullOrEmpty(Post("RET_CHANNEL")))
                where += string.Format(" AND RET_CHANNEL = '{0}' ", Post("RET_CHANNEL"));
            if (!string.IsNullOrEmpty(Post("DECLARE_TYPE")))
                where += string.Format(" AND DECLARE_TYPE = '{0}' ", Post("DECLARE_TYPE"));
            if (!string.IsNullOrEmpty(Post("STU_TYPE")))
                where += string.Format(" AND STU_TYPE = '{0}' ", Post("STU_TYPE"));
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
            Ua_class_group head = new Ua_class_group();
            head.OID = strOID;
            ds.RetrieveObject(head);
            var transaction = ImplementFactory.GetDeleteTransaction<Ua_class_group>("Ua_class_groupDeleteTransaction");
            transaction.EntityList.Add(head);

            if (!transaction.Commit())
                return "删除失败！";

            return string.Empty;
        }

        #endregion 删除数据

        #region 通过学号判断是否是辅导员或者研究生

        /// <summary>
        /// 通过学号判断是否是辅导员或者研究生
        /// </summary>
        /// <returns></returns>
        private string ChkUserInfo()
        {
            if (string.IsNullOrEmpty(Get("userno")))
                return "用户学工号不能为空！";
            //判断是否是辅导员
            Basic_coun_info coun_info = CounHandleClass.getInstance().GetCounInfo_Obj(Get("userno"));
            Basic_stu_info stu_info = StuHandleClass.getInstance().GetStuInfo_Obj(Get("userno"));
            if (coun_info == null)
            {
                if (stu_info == null)
                    return "录入的学工号不存在，请确认！";

                if (stu_info.STUTYPE.Equals("B"))
                    return "录入的学工号不符合班级辅导员设置要求！";
            }

            return string.Empty;
        }

        #endregion 通过学号判断是否是辅导员或者研究生

        #region 通过学工号获得辅导员基础信息

        /// <summary>
        /// 通过学工号获得辅导员基础信息
        /// </summary>
        /// <returns></returns>
        private string GetUserInfo()
        {
            if (string.IsNullOrEmpty(Get("userno")))
                return "用户学工号不能为空！";
            Basic_coun_info coun_info = CounHandleClass.getInstance().GetCounInfo_Obj(Get("userno"));
            Basic_stu_info stu_info = StuHandleClass.getInstance().GetStuInfo_Obj(Get("userno"));

            #region 构建表结构

            DataTable dtJson = new DataTable();
            dtJson.TableName = "FDY_INFO";
            //创建 “用户编号” 列
            DataColumn UserIdColumn = new DataColumn();
            UserIdColumn.DataType = System.Type.GetType("System.String");
            UserIdColumn.ColumnName = "USERID";
            dtJson.Columns.Add(UserIdColumn);
            //创建 “用户姓名” 列
            DataColumn UserNameColumn = new DataColumn();
            UserNameColumn.DataType = System.Type.GetType("System.String");
            UserNameColumn.ColumnName = "USERNAME";
            dtJson.Columns.Add(UserNameColumn);
            //创建 “用户类型” 列
            DataColumn UserTypeColumn = new DataColumn();
            UserTypeColumn.DataType = System.Type.GetType("System.String");
            UserTypeColumn.ColumnName = "USERTYPE";
            dtJson.Columns.Add(UserTypeColumn);

            #endregion 构建表结构

            #region 给表赋值

            DataRow row = dtJson.NewRow();
            if (coun_info != null)
            {
                row["USERID"] = coun_info.ENO;
                row["USERNAME"] = coun_info.NAME;
                row["USERTYPE"] = "F";
            }
            else if (stu_info != null)
            {
                row["USERID"] = stu_info.NUMBER;
                row["USERNAME"] = stu_info.NAME;
                row["USERTYPE"] = "Y";
            }
            else
            {
                row["USERID"] = "";
                row["USERNAME"] = "";
                row["USERTYPE"] = "";
            }
            dtJson.Rows.Add(row);

            #endregion 给表赋值

            return Json.DatatableToJson(dtJson);
        }

        #endregion 通过学工号获得辅导员基础信息

        #region 提交操作

        /// <summary>
        /// 提交操作
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                if (string.IsNullOrEmpty(Post("hidOid")))
                {
                    head.OID = Guid.NewGuid().ToString();
                    head.SEQ_NO = GetSeq_no();
                    GetValue(head);
                    head.DOC_TYPE = this.Doc_type;
                    head.DECL_NUMBER = user.User_Id;
                    head.DECL_TIME = GetDateLongFormater();
                    var inserttrcn = ImplementFactory.GetInsertTransaction<Ua_class_group>("Ua_class_groupInsertTransaction");
                    inserttrcn.EntityList.Add(head);
                    if (!inserttrcn.Commit())
                    {
                        return "提交失败！";
                    }
                }
                else
                {
                    head.OID = Post("hidOid");
                    ds.RetrieveObject(head);
                    GetValue(head);
                    head.DECL_NUMBER = user.User_Id;
                    head.DECL_TIME = GetDateLongFormater();
                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Ua_class_group>("Ua_class_groupUpdateTransaction", user.User_Name);
                    if (!updatetrcn.Commit(head))
                    {
                        return "提交失败！";
                    }
                }
                //提交编班申请
                string strOpNotes = string.Format("提交编班申请操作");
                string strMsg = string.Empty;
                if (!WKF_ExternalInterface.getInstance().WKF_BusDeclare(head.DOC_TYPE, head.SEQ_NO, user.User_Name, user.User_Role, strOpNotes, out strMsg))
                {
                    //20171017 ZZ 新增：由于编班没有暂存功能，所以编班提交失败或者没有权限提交，需要删除生成的数据。
                    string strDelSql = string.Format("DELETE FROM UA_CLASS_GROUP WHERE SEQ_NO = '{0}' ", head.SEQ_NO);
                    ds.ExecuteTxtNonQuery(strDelSql);
                    return string.Format("编班提交失败，原因：{0}", strMsg);
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                //20171017 ZZ 新增：由于编班没有暂存功能，所以编班提交失败或者没有权限提交，需要删除生成的数据。
                string strDelSql = string.Format("DELETE FROM UA_CLASS_GROUP WHERE SEQ_NO = '{0}' ", head.SEQ_NO);
                ds.ExecuteTxtNonQuery(strDelSql);
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "编班提交失败，原因：" + ex.ToString());
                return "提交失败！";
            }
        }

        #region 获得页面数据

        /// <summary>
        /// 获得页面数据
        /// </summary>
        /// <param name="model"></param>
        private void GetValue(Ua_class_group model)
        {
            //录入信息
            model.GROUP_CLASS = Post("hidGroupClass");
            model.GROUP_NUMBER = Post("GROUP_NUMBER");
            model.GROUP_NAME = Post("GROUP_NAME");
            model.GROUP_TYPE = Post("GROUP_TYPE");
            //公共字段
            model.OP_CODE = user.User_Id;
            model.OP_NAME = user.User_Name;
            model.OP_TIME = GetDateLongFormater();
        }

        #endregion 获得页面数据

        #endregion 提交操作
    }
}