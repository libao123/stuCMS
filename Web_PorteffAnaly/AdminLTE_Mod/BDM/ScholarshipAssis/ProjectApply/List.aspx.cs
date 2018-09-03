using System;
using System.Collections.Generic;
using System.IO;
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

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectApply
{
    public partial class List : ListBaseLoad<Shoolar_apply_head>
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
            get { return true; }
        }

        protected override SelectTransaction<Shoolar_apply_head> GetSelectTransaction()
        {
            if (!string.IsNullOrEmpty(Get("page_from")))
            {
                if (Get("page_from").ToString().Equals("approve_pend"))/// 待处理查看
                    param.Add(string.Format(DataFilterHandleClass.getInstance().Pend_DataFilter(user.User_Role, CValue.DOC_TYPE_BDM03)), string.Empty);
                else if (Get("page_from").ToString().Equals("approve_proce"))   /// 已处理查看
                    param.Add(string.Format(DataFilterHandleClass.getInstance().Proc_DataFilter(user.User_Role, CValue.DOC_TYPE_BDM03)), string.Empty);
                else if (Get("page_from").ToString().Equals("result")) //查询都是审批通过的数据
                    param.Add("RET_CHANNEL", CValue.RET_CHANNEL_D4000);
                else if (Get("page_from").ToString().Equals("nation_schoolar")) //全国信息：查询都是审批通过的数据
                    param.Add("RET_CHANNEL", CValue.RET_CHANNEL_D4000);
                else if (Get("page_from").ToString().Equals("result_outline")) //查询线下项目数据
                    param.Add("PROJECT_CLASS", "OUTLINE");
            }
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

                        case "delete"://删除操作
                            Response.Write(DeleteData());
                            Response.End();
                            break;

                        case "iscan_apply"://判断是否满足该项目申请条件
                            Response.Write(ChkIsCanApply());
                            Response.End();
                            break;

                        case "iscanop"://判断是否满足操作条件
                            Response.Write(ChkIsCanOp());
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
            if (!string.IsNullOrEmpty(Post("STU_TYPE")))
                where += string.Format(" AND STU_TYPE = '{0}' ", Post("STU_TYPE"));
            if (!string.IsNullOrEmpty(Post("EXPORT_TYPE")))//来自于 全国信息系统 模块
            {
                where += ProjectApplyHandleClass.getInstance().ByExportTypeGetQueryStr(Post("EXPORT_TYPE"), Post("STU_TYPE"));
            }
            return where;
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
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除主表的时候连带子表的数据也一并删除
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                if (string.IsNullOrEmpty(Request.QueryString["id"]))
                    return "OID为空,不允许删除操作";

                Shoolar_apply_head head = new Shoolar_apply_head();
                head.OID = Request.QueryString["id"].ToString();
                ds.RetrieveObject(head);

                #region 先读取附件信息

                //先读取附件信息
                Dictionary<string, string> param = new Dictionary<string, string>();
                param.Add("SEQ_NO", head.SEQ_NO);
                List<Shoolar_apply_file> fileList = ProjectApplyHandleClass.getInstance().GetFileListInfo(param);

                #endregion 先读取附件信息

                var transaction = ImplementFactory.GetDeleteTransaction<Shoolar_apply_head>("Shoolar_apply_headDeleteTransaction");
                transaction.EntityList.Add(head);

                if (!transaction.Commit())
                    return "删除失败！";

                #region 删除子表

                //删除子表
                ds.ExecuteTxtNonQuery(string.Format("DELETE FROM SHOOLAR_APPLY_FAMILY WHERE SEQ_NO = '{0}' ", head.SEQ_NO));
                ds.ExecuteTxtNonQuery(string.Format("DELETE FROM SHOOLAR_APPLY_FAMILY_LIST WHERE SEQ_NO = '{0}' ", head.SEQ_NO));
                ds.ExecuteTxtNonQuery(string.Format("DELETE FROM SHOOLAR_APPLY_TXT WHERE SEQ_NO = '{0}'", head.SEQ_NO));
                ds.ExecuteTxtNonQuery(string.Format("DELETE FROM SHOOLAR_APPLY_REWARD WHERE SEQ_NO = '{0}'", head.SEQ_NO));
                ds.ExecuteTxtNonQuery(string.Format("DELETE FROM SHOOLAR_APPLY_STUDY WHERE SEQ_NO = '{0}'", head.SEQ_NO));
                ds.ExecuteTxtNonQuery(string.Format("DELETE FROM SHOOLAR_APPLY_STUDY_LIST WHERE SEQ_NO = '{0}'", head.SEQ_NO));
                ds.ExecuteTxtNonQuery(string.Format("DELETE FROM SHOOLAR_APPLY_CHECK WHERE SEQ_NO = '{0}'", head.SEQ_NO));
                ds.ExecuteTxtNonQuery(string.Format("DELETE FROM SHOOLAR_APPLY_FILE WHERE SEQ_NO = '{0}'", head.SEQ_NO));

                #endregion 删除子表

                #region 删除附件

                if (fileList != null)
                {
                    //删除附件
                    foreach (Shoolar_apply_file file in fileList)
                    {
                        #region 删除对应文件

                        string strFilePath = file.FILE_DIRECTORY + "/" + file.FILE_SAVE_NAME;
                        strFilePath = System.Web.HttpContext.Current.Server.MapPath("~/") + strFilePath.Replace("/", "\\");
                        if (File.Exists(strFilePath))
                        {
                            FileInfo fi = new FileInfo(strFilePath);
                            //文件如果是只读的，设置成 正常 模式
                            if (fi.Attributes.ToString().IndexOf("ReadOnly") != -1)
                                fi.Attributes = FileAttributes.Normal;
                            //删除指定图片
                            File.Delete(strFilePath);
                        }

                        #endregion 删除对应文件
                    }
                }

                #endregion 删除附件

                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请删除失败：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据

        #region 判断是否满足该项目申请条件

        /// <summary>
        /// 判断是否满足该项目申请条件
        /// </summary>
        /// <returns></returns>
        private string ChkIsCanApply()
        {
            if (string.IsNullOrEmpty(Get("project_seq_no")))
                return "选择申请的项目单据编号为空,不允许操作！";
            //ZZ 20171026 新增：申请条件，多增加一个校验：校验学生基本信息是否完整
            Basic_stu_info stuInfo = StuHandleClass.getInstance().GetStuInfo_Obj(user.User_Id);
            if (stuInfo == null)
                return "学生信息为空,不允许操作！";
            if (stuInfo != null)
            {
                if (stuInfo.POLISTATUS.Length == 0 || stuInfo.ENTERTIME.Length == 0 || stuInfo.REGISTER.Length == 0)
                    return "学生信息不完整，学籍、入学时间、政治面貌不允许为空！需到个人中心进行个人信息维护！";
            }
            //判断该项目的限制条件是否一一通过
            string strMsg = string.Empty;
            if (!ProjectApplyHandleClass.getInstance().CheckIsCanApply(user.User_Id, Get("project_seq_no"), out strMsg))
                return strMsg;
            return string.Empty;
        }

        #endregion 判断是否满足该项目申请条件

        #region 判断是否满足操作条件

        /// <summary>
        /// 判断是否满足操作条件
        /// </summary>
        /// <returns></returns>
        private string ChkIsCanOp()
        {
            if (string.IsNullOrEmpty(Get("project_seq_no")))
                return "选择申请的项目单据编号为空,不允许操作！";

            Shoolar_project_head project_head = ProjectSettingHandleClass.getInstance().GetProjectHead(Get("project_seq_no"));
            if (project_head == null)
                return "选择申请的项目信息为空,不允许操作！";

            if (!ProjectSettingHandleClass.getInstance().CheckIsFitApplyDate(project_head.APPLY_END, user.User_Role))
                return "该项目申请结束日期已过，无法操作！";

            return string.Empty;
        }

        #endregion 判断是否满足操作条件
    }
}