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
using AdminLTE_Mod.Common;
using commonclass;
using HQ.Architecture.Factory;
using HQ.Architecture.Strategy;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;
using HQ.WebForm.Kernel;
using PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.Common;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.FamilySurvey
{
    public partial class List : ListBaseLoad<Dst_family_situa>
    {
        #region 初始化

        private comdata cod = new comdata();
        public TableMapping TableMapp = new TableMapping();
        public Dst_family_situa head = new Dst_family_situa();
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public string m_strIsShowEditBtn = "false";//是否显示增删改提交按钮：显示true 不显示false

        public override string Doc_type { get { return HQ.Model.CValue.DOC_TYPE_BDM04; } }

        private ComTranClass comTran = new ComTranClass();
        private datatables tables = new datatables();
        public string m_strUploadPhotoRoot = Util.GetAppSettings("PhotoPath");

        #endregion 初始化

        #region 辅助页面加载

        protected override string input_code_column
        {
            get { return "NUMBER"; }
        }

        protected override string class_code_column
        {
            get { return "CLASS"; }
        }

        protected override string xy_code_column
        {
            get { return "COLLEGE"; }
        }

        protected override bool is_do_filter
        {
            get { return true; }
        }

        protected override SelectTransaction<Dst_family_situa> GetSelectTransaction()
        {
            return ImplementFactory.GetSelectTransaction<Dst_family_situa>("Dst_family_situaSelectTransaction", param);
        }

        /// <summary>
        /// 查询
        /// </summary>
        /// <returns></returns>
        public override string GetSearchWhere()
        {
            string where = string.Empty;
            if (!string.IsNullOrEmpty(Post("COLLEGE")))
                where += string.Format(" AND COLLEGE = '{0}' ", Post("COLLEGE"));
            if (!string.IsNullOrEmpty(Post("MAJOR")))
                where += string.Format(" AND MAJOR = '{0}' ", Post("MAJOR"));
            if (!string.IsNullOrEmpty(Post("CLASS")))
                where += string.Format(" AND CLASS = '{0}' ", Post("CLASS"));
            if (!string.IsNullOrEmpty(Post("NUMBER")))
                where += string.Format(" AND NUMBER LIKE '%{0}%' ", Post("NUMBER"));
            if (!string.IsNullOrEmpty(Post("NAME")))
                where += string.Format(" AND NAME LIKE '%{0}%' ", Post("NAME"));
            if (!string.IsNullOrEmpty(Post("IDCARDNO")))
                where += string.Format(" AND IDCARDNO LIKE '%{0}%' ", Post("IDCARDNO"));
            return where;
        }

        #endregion 辅助页面加载

        #region 窗体加载

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (WKF_ExternalInterface.getInstance().IsShowEditButton(user.User_Role, this.Doc_type))
                    m_strIsShowEditBtn = "true";

                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "getlist":
                            Response.Write(GetList());
                            Response.End();
                            break;
                        case "checkadd":
                            Response.Write(CheckOperate("add"));
                            Response.End();
                            break;
                        case "checkmodi":
                            Response.Write(CheckOperate("modi"));
                            Response.End();
                            break;
                        case "checkdel":
                            Response.Write(CheckOperate("del"));
                            Response.End();
                            break;
                        case "checkdecl":
                            Response.Write(CheckOperate("decl"));
                            Response.End();
                            break;
                        case "delete"://删除操作
                            Response.Write(DeleteData());
                            Response.End();
                            break;
                        case "decl":
                            Response.Write(DeclData());
                            Response.End();
                            break;
                        case "save":
                            Response.Write(SaveData());
                            Response.End();
                            break;
                        case "createnewdata":
                            Response.Write(CreateNewData());
                            Response.End();
                            break;
                        case "getmember":
                            Response.Write(GetMember());
                            Response.End();
                            break;
                        case "getfile":
                            Response.Write(GetFile());
                            Response.End();
                            break;
                        case "checkaddmember":
                            Response.Write(CheckAdd());
                            Response.End();
                            break;
                        case "savemember":
                            Response.Write(SaveMember());
                            Response.End();
                            break;
                        case "delmember":
                            Response.Write(DeleteMember());
                            Response.End();
                            break;
                        case "delphoto":
                            Response.Write(DeletePhoto());
                            Response.End();
                            break;
                        case "getrecord":
                            Response.Write(GetSurveyRecord());
                            Response.End();
                            break;
                        case "getdata":
                            Response.Write(GetApplyData(Get("id")));
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 窗体加载

        #region 输出列表信息

        protected override IEnumerable<NameValue> GetValue(Dst_family_situa entity)
        {
            {
                yield return new NameValue() { Name = "SEX_NAME", Value = cod.GetDDLTextByValue("ddl_xb", entity.SEX) };
                yield return new NameValue() { Name = "COLLEGE_NAME", Value = cod.GetDDLTextByValue("ddl_department", entity.COLLEGE) };
                yield return new NameValue() { Name = "MAJOR_NAME", Value = cod.GetDDLTextByValue("ddl_zy", entity.MAJOR) };
                yield return new NameValue() { Name = "CLASS_NAME", Value = cod.GetDDLTextByValue("ddl_class", entity.CLASS) };
                yield return new NameValue() { Name = "RET_CHANNEL_NAME", Value = cod.GetDDLTextByValue("ddl_RET_CHANNEL", entity.RET_CHANNEL) };
                yield return new NameValue() { Name = "POLISTATUS_NAME", Value = cod.GetDDLTextByValue("ddl_zzmm", entity.POLISTATUS) };
                yield return new NameValue() { Name = "NATION_NAME", Value = cod.GetDDLTextByValue("ddl_mz", entity.NATION) };
                yield return new NameValue() { Name = "OID", Value = entity.OID };
                yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
                yield return new NameValue() { Name = "DOC_TYPE", Value = entity.DOC_TYPE };
                yield return new NameValue() { Name = "SERIAL_NO", Value = entity.SERIAL_NO };
                yield return new NameValue() { Name = "SCHYEAR", Value = entity.SCHYEAR };
                yield return new NameValue() { Name = "NUMBER", Value = entity.NUMBER };
                yield return new NameValue() { Name = "NAME", Value = entity.NAME };
                yield return new NameValue() { Name = "COLLEGE", Value = entity.COLLEGE };
                yield return new NameValue() { Name = "CLASS", Value = entity.CLASS };
                yield return new NameValue() { Name = "MAJOR", Value = entity.MAJOR };
                yield return new NameValue() { Name = "GRADE", Value = entity.GRADE };
                yield return new NameValue() { Name = "IS_ORPHAN", Value = entity.IS_ORPHAN == "Y" ? "1" : "0" };
                yield return new NameValue() { Name = "IS_SINGLE", Value = entity.IS_SINGLE == "Y" ? "1" : "0" };
                yield return new NameValue() { Name = "IS_DISABLED", Value = entity.IS_DISABLED == "Y" ? "1" : "0" };
                yield return new NameValue() { Name = "IS_MARTYRS", Value = entity.IS_MARTYRS == "Y" ? "1" : "0" };
                yield return new NameValue() { Name = "IS_MINIMUM", Value = entity.IS_MINIMUM };
                yield return new NameValue() { Name = "IS_POOR", Value = entity.IS_POOR };
                yield return new NameValue() { Name = "IS_OTHER", Value = entity.IS_OTHER == "Y" ? "1" : "0" };
                yield return new NameValue() { Name = "IS_DESTITUTE", Value = entity.IS_DESTITUTE == "Y" ? "1" : "0" };
                yield return new NameValue() { Name = "DECL_TIME", Value = entity.DECL_TIME };
                yield return new NameValue() { Name = "CHK_TIME", Value = entity.CHK_TIME };
                yield return new NameValue() { Name = "CHK_STATUS", Value = entity.CHK_STATUS };
                yield return new NameValue() { Name = "RET_CHANNEL", Value = entity.RET_CHANNEL };
                yield return new NameValue() { Name = "POS_CODE", Value = entity.POS_CODE };
                yield return new NameValue() { Name = "OP_CODE", Value = entity.OP_CODE };
                yield return new NameValue() { Name = "OP_NAME", Value = entity.OP_NAME };
                yield return new NameValue() { Name = "OP_TIME", Value = entity.OP_TIME };
            }
        }

        #endregion 输出列表信息

        #region 获得申请信息

        private string GetApplyData(string oid)
        {
            if (string.IsNullOrEmpty(oid))
                return "{}";

            Hashtable ddl = new Hashtable();
            ddl["SEX"] = "ddl_xb";
            ddl["COLLEGE"] = "ddl_department";
            ddl["MAJOR"] = "ddl_zy";
            ddl["CLASS"] = "ddl_class";
            ddl["NATION"] = "ddl_mz";
            ddl["POLISTATUS"] = "ddl_zzmm";
            DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM DST_FAMILY_SITUA WHERE OID = '{0}' ", oid));
            if (dt == null || dt.Rows.Count == 0)
                return "{}";
            else
            {
                cod.ConvertTabDdl(dt, ddl);
                dt.Columns.Add("PROVINCE", Type.GetType("System.String"));
                dt.Columns.Add("CITY", Type.GetType("System.String"));
                dt.Columns.Add("COUNTY", Type.GetType("System.String"));
                dt.Columns.Add("ADD_STREET", Type.GetType("System.String"));
                foreach (DataRow dr in dt.Rows)
                {
                    dr["PROVINCE"] = ComHandleClass.getInstance().GetAddrSplit(dr["ADDRESS"].ToString(), 0);
                    dr["CITY"] = ComHandleClass.getInstance().GetAddrSplit(dr["ADDRESS"].ToString(), 1);
                    dr["COUNTY"] = ComHandleClass.getInstance().GetAddrSplit(dr["ADDRESS"].ToString(), 2);
                    dr["ADD_STREET"] = ComHandleClass.getInstance().GetAddrSplit(dr["ADDRESS"].ToString(), 3);
                    dr["ADDRESS"] = ComHandleClass.getInstance().ConvertAddress(dr["ADDRESS"].ToString());
                    dr["IS_ORPHAN"] = dr["IS_ORPHAN"].ToString().Equals("Y") ? "1" : "0";
                    dr["IS_SINGLE"] = dr["IS_SINGLE"].ToString().Equals("Y") ? "1" : "0";
                    dr["IS_DISABLED"] = dr["IS_DISABLED"].ToString().Equals("Y") ? "1" : "0";
                    dr["IS_MARTYRS"] = dr["IS_MARTYRS"].ToString().Equals("Y") ? "1" : "0";
                    dr["IS_OTHER"] = dr["IS_OTHER"].ToString().Equals("Y") ? "1" : "0";
                    dr["IS_DESTITUTE"] = dr["IS_DESTITUTE"].ToString().Equals("Y") ? "1" : "0";
                }
            }
            return Json.DatatableToJson(dt);
        }

        #endregion 获得申请信息

        #region 判断是否可以进行操作

        private string CheckOperate(string strFlag)
        {
            string result = string.Empty;
            if (string.IsNullOrEmpty(Get("id")))
                return "主键不能为空！";

            Dst_family_situa situa = new Dst_family_situa();
            bool can = DstParamHandleClass.getInstance().IsCanSurvey(out result);
            situa.OID = Get("id");
            ds.RetrieveObject(situa);

            if (situa.CHK_STATUS.Equals(HQ.Model.CValue.CHK_STATUS_Y))
                return "该状态下不允许操作！";

            if (strFlag.Equals("add"))
            {
                if (!can && result.Length == 0)
                {
                    result = "未开放调查，请联系管理员！";
                }
                return result;
            }
            else if (strFlag.Equals("modi"))
            {
                //根据《20170830测试文档》要求，改为提交后可修改
                //在开放时间内，已提交的数据新学年允许修改
                //if (can && situa.SCHYEAR.Equals(sch_info.CURRENT_YEAR) && !situa.RET_CHANNEL.Equals(HQ.Model.CValue.RET_CHANNEL_A0000))
                //    return "该状态下不允许操作！";
            }
            else if (strFlag.Equals("del"))
            {
                if (situa.RET_CHANNEL.Equals(HQ.Model.CValue.RET_CHANNEL_A0000))
                    return string.Empty;
                else
                    return "该状态下不允许操作！";
            }

            //同一学年，已认定的不能再参与

            return result;
        }

        #endregion 判断是否可以进行操作

        #region 删除数据

        /// <summary>
        /// 删除主表数据并且把子表数据也删除
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            var code = Get("oid");
            if (string.IsNullOrEmpty(code)) return "主键为空,不允许删除操作";

            head.OID = code;
            ds.RetrieveObject(head);

            bool bDel = false;
            var transaction = ImplementFactory.GetDeleteTransaction<Dst_family_situa>("Dst_family_situaDeleteTransaction");
            transaction.EntityList.Add(head);
            bDel = transaction.Commit();
            if (!bDel)
                return "删除失败！";
            return "";
        }

        #endregion 删除数据

        #region 提交

        private string DeclData()
        {
            string msg = SaveData();
            if (msg.Length > 0)
            {
                var oid = Post("OID");
                if (string.IsNullOrEmpty(oid)) return "主键为空，不允许提交";

                head.OID = oid;
                ds.RetrieveObject(head);
                msg = CheckFamilyInfo(head.SEQ_NO) + CheckMembers(head.SEQ_NO);
                if (msg.Length > 0)
                    return msg;
                //学生个人信息是否审核通过
                if (!ComHandleClass.getInstance().IsPassStudentModify(head.NUMBER))
                    return "个人信息修改未审核通过，不允许提交";

                //家庭调查表提交后不需要流转
                Wkf_rule_queue rule = WKF_RuleQueueHandleCLass.getInstance().GetCurrRule(HQ.Model.CValue.DOC_TYPE_BDM04, WKF_VLAUES.DECLARE_TYPE_D, HQ.Model.CValue.STEP_A0, HQ.Model.CValue.RET_CHANNEL_A0010, user.User_Role);
                if (rule == null)
                {
                    msg = "没有权限提交";
                }
                else
                {
                    head.OP_CODE = user.User_Id;
                    head.OP_NAME = user.User_Name;
                    head.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    head.DECL_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    //提交时，插入一条文档编号
                    ComHandleClass.getInstance().InsertIntoBasicStuWordNo(head.NUMBER, head.SCHYEAR);
                    head.SERIAL_NO = ComHandleClass.getInstance().GetStuWorNo(head.NUMBER, head.SCHYEAR);
                    head.RET_CHANNEL = HQ.Model.CValue.RET_CHANNEL_A0010;
                    ds.UpdateObject(head);

                    //增加一条记录
                    if (!FamilySurveyHandleClass.getInstance().CreateRecord(head))
                        msg = "提交成功，但生成调查记录失败";
                }
            }
            else
                msg = "提交失败";

            return msg;
        }

        #endregion 提交

        #region 提交前校验

        #region 提交前校验家庭相关情况是否填写完整

        private string CheckFamilyInfo(string seq_no)
        {
            string msg = string.Empty;
            DataTable dt = ds.ExecuteTxtDataTable(string.Format("SELECT * FROM DST_FAMILY_SITUA WHERE SEQ_NO='{0}'", seq_no));
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["FUND_SITUA"].ToString().Length == 0 ||
                    dt.Rows[0]["ACCIDENT_SITUA"].ToString().Length == 0 ||
                    dt.Rows[0]["WORK_SITUA"].ToString().Length == 0 ||
                    dt.Rows[0]["DEBT_SITUA"].ToString().Length == 0 ||
                    dt.Rows[0]["OTHER_SITUA"].ToString().Length == 0)
                {
                    msg = "请填写完整家庭有关信息！";
                }
            }
            else
                msg = "请填写完整家庭有关信息！";

            return msg;
        }

        #endregion 提交前校验家庭相关情况是否填写完整

        #region 提交前家庭成员情况校验

        private string CheckMembers(string seq_no)
        {
            string msg = string.Empty;
            object o = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM DST_FAMILY_MEMBERS WHERE SEQ_NO = '{0}'", seq_no));
            if (o != null && o.ToString().Length > 0)
            {
                int cnt = Int32.Parse(o.ToString());
                //家庭成员与家庭人口数要一致：家庭成员=家庭人口数-1
                object size = ds.ExecuteTxtScalar(string.Format("SELECT FAMILY_SIZE FROM DST_FAMILY_SITUA WHERE SEQ_NO = '{0}'", seq_no));
                if (Int32.Parse(size.ToString()) - 1 != cnt)
                    msg = "家庭成员与家庭人口数不一致";

                //家庭成员身份证
                if (msg.Length == 0)
                {
                    object n = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM DST_FAMILY_MEMBERS WHERE SEQ_NO = '{0}' AND (IDCARDNO IS NULL OR IDCARDNO = '')", seq_no));
                    if (Int32.Parse(n.ToString()) > 0)
                        msg = "家庭成员的身份证号码未填写完全";
                }
            }
            else
                msg = "请填写家庭成员情况！";

            return msg;
        }

        #endregion 提交前家庭成员情况校验

        #region 提交前附件校验

        private string CheckPhoto(string seq_no)
        {
            string msg = string.Empty;
            object o = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM DST_FAMILY_PHOTO WHERE SEQ_NO='{0}'", seq_no));
            if (o != null && o.ToString().Length > 0)
            {
                if (Int32.Parse(o.ToString()) == 0)
                {
                    msg = "请上传附件！";
                }
            }
            else
                msg = "请上传附件";

            return msg;
        }

        #endregion 提交前附件校验

        #endregion 提交前校验

        #region 保存

        private string SaveData()
        {
            try
            {
                Dst_family_situa head = new Dst_family_situa();
                head.OID = Post("OID");
                if (head.OID == "")
                {
                    head.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(head);
                    head.SEQ_NO = GetSeq_no();
                }
                else
                {
                    ds.RetrieveObject(head);
                }
                GetPageValue(head);

                ds.UpdateObject(head);
                ds.ExecuteTxtNonQuery(string.Format("UPDATE DST_FAMILY_PHOTO SET SERIAL_NO='{0}' WHERE SEQ_NO='{1}'", head.SERIAL_NO, head.SEQ_NO));
                return head.OID + ";" + head.SEQ_NO;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        #region 获取页面数据

        private void GetPageValue(Dst_family_situa model)
        {
            model.HUKOU_BEFORE = Post("HUKOU_BEFORE");
            model.FAMILY_SIZE = comTran.ToDecimal(Post("FAMILY_SIZE"));
            model.GRADUATE_SCHOOL = Post("GRADUATE_SCHOOL");
            model.IS_ORPHAN = ConverCheckbox(Post("IS_ORPHAN"));
            model.IS_SINGLE = ConverCheckbox(Post("IS_SINGLE"));
            model.IS_DISABLED = ConverCheckbox(Post("IS_DISABLED"));
            model.IS_MARTYRS = ConverCheckbox(Post("IS_MARTYRS"));
            model.IS_OTHER = ConverCheckbox(Post("IS_OTHER"));
            model.IS_MINIMUM = Post("IS_MINIMUM");
            model.IS_POOR = Post("IS_POOR");
            model.ADDRESS = Post("PROVINCE") + "|" + Post("CITY") + "|" + Post("COUNTY") + "|" + Post("ADD_STREET");
            model.POSTCODE = Post("POSTCODE");
            model.TELEPHONE = Post("TELEPHONE");
            model.FUND_SITUA = Post("FUND_SITUA");
            model.ACCIDENT_SITUA = Post("ACCIDENT_SITUA");
            model.WORK_SITUA = Post("WORK_SITUA");
            model.DEBT_SITUA = Post("DEBT_SITUA");
            model.OTHER_SITUA = Post("OTHER_SITUA");
            model.SCHYEAR = sch_info.CURRENT_YEAR;
            model.OP_CODE = user.User_Id;
            model.OP_NAME = user.User_Name;
            model.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            model.IS_LOAN = Post("IS_LOAN");
            model.OUT_FUND = Post("OUT_FUND");
            model.OUT_FUND_MONEY = comTran.ToDecimal(Post("OUT_FUND_MONEY"));
            model.OUT_FUND_PROJECT = Post("OUT_FUND_PROJECT");
            model.HEALTH_TYPE = Post("HEALTH_TYPE");
            model.DISA_DEGREE = Post("DISA_DEGREE");
            model.HUKOU_ZONE = Post("HUKOU_ZONE");
            model.ORPHAN_DETAIL = Post("ORPHAN_DETAIL");
            model.SINGLE_DETAIL = Post("SINGLE_DETAIL");
            model.TOTAL_COST = comTran.ToDecimal(Post("TOTAL_COST"));
            model.LIVING_EXP = comTran.ToDecimal(Post("LIVING_EXP"));
            model.FAMILY_STATUS = Post("FAMILY_STATUS");
            model.SUPPORT_TYPE = Post("SUPPORT_TYPE");
            model.SUPPORT_NUM = comTran.ToDecimal(Post("SUPPORT_NUM"));
        }

        #endregion 获取页面数据

        private string ConverCheckbox(string val)
        {
            if (val == "on")
                return "Y";
            else
                return "N";
        }

        #endregion 保存

        #region 新增数据

        private string CreateNewData()
        {
            string strNumber = Get("number");
            Basic_stu_info stu = new Basic_stu_info();
            head = FamilySurveyHandleClass.getInstance().GetDst_family_situa(new Dictionary<string, string> { { "NUMBER", strNumber } });
            if (head == null)
            {
                head = new Dst_family_situa();
                object o = ds.ExecuteTxtScalar(string.Format("SELECT OID FROM Basic_stu_info WHERE NUMBER = '{0}'", strNumber));
                if (o != null && o.ToString().Trim().Length > 0)
                {
                    string OID = Guid.NewGuid().ToString();
                    stu.OID = o.ToString();
                    ds.RetrieveObject(stu);
                    head.NUMBER = stu.NUMBER;
                    head.NAME = stu.NAME;
                    head.SEX = stu.SEX;
                    head.BIRTH_DATE = stu.GARDE;
                    head.NATION = stu.NATION;
                    head.IDCARDNO = stu.IDCARDNO;
                    head.POLISTATUS = stu.POLISTATUS;
                    head.COLLEGE = stu.COLLEGE;
                    head.MAJOR = stu.MAJOR;
                    head.CLASS = stu.CLASS;
                    head.GRADE = stu.EDULENTH;
                    head.NATIVEPLACE = stu.NATIVEPLACE;
                    head.OID = OID;
                    head.SEQ_NO = GetSeq_no();
                    head.DOC_TYPE = this.Doc_type;
                    head.RET_CHANNEL = Ret_Channel_A0000;
                    head.SCHYEAR = sch_info.CURRENT_YEAR;
                    head.OP_TIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    head.OP_CODE = user.User_Id;
                    head.OP_NAME = user.User_Name;
                    head.ADDRESS = stu.ADDRESS;
                    head.POSTCODE = stu.POSTCODE;
                    head.TELEPHONE = stu.HOMENUM;
                    var inserttrcn = ImplementFactory.GetInsertTransaction<Dst_family_situa>("Dst_family_situaInsertTransaction");
                    inserttrcn.EntityList.Add(head);
                    inserttrcn.Commit();
                }
                else
                {
                    return "获取学生基本信息失败！";
                }
            }

            return GetApplyData(head.OID);
        }

        #endregion 新增数据

        #region 加载家庭成员列表

        private string GetMember()
        {
            string where = string.Format(" AND SEQ_NO='{0}'", Get("seq_no"));
            var ddl = new Hashtable();
            ddl.Add("RELATION_NAME", "ddl_relation");
            ddl.Add("PROFESSION_NAME", "ddl_profession");
            ddl.Add("HEALTH_NAME", "ddl_health");
            ddl.Add("EDU_LEVEL_NAME", "ddl_education");

            return tables.GetCmdQueryData("GET_FAMILY_MEMBERS", null, where, string.Empty, ddl);
        }

        #endregion 加载家庭成员列表

        #region 保存家庭成员

        private string SaveMember()
        {
            try
            {
                Dst_family_members member = new Dst_family_members();
                member.OID = Post("OID");
                if (member.OID == "")
                    member.OID = Guid.NewGuid().ToString();
                ds.RetrieveObject(member);
                member.SEQ_NO = Get("seq_no");
                member.NAME = Post("NAME");
                member.AGE = Post("AGE");
                member.RELATION = Post("MEMBER_RELATION_TEXT") == "" ? Post("RELATION") : Post("MEMBER_RELATION_TEXT");
                member.WORKPLACE = Post("WORKPLACE");
                member.PROFESSION = Post("MEMBER_PROFESSION_TEXT") == "" ? Post("PROFESSION") : Post("MEMBER_PROFESSION_TEXT");
                member.INCOME = comTran.ToDecimal(Post("INCOME"));
                member.HEALTH = Post("HEALTH");//Post("MEMBER_HEALTH_TEXT") == "" ? Post("HEALTH") : Post("MEMBER_HEALTH_TEXT");
                member.IDCARDNO = Post("IDCARDNO");
                member.DISA_DEGREE = Post("MEMBER_DISA_DEGREE");
                member.EDU_LEVEL = Post("MEMBER_EDU_LEVEL");
                ds.UpdateObject(member);
                string msg;
                if (!FamilySurveyHandleClass.getInstance().CalculateIncome(member.SEQ_NO, out msg))
                {
                    msg = "计算家庭年收入异常";
                }
                return member.OID;
            }
            catch (Exception)
            {
                return "";
            }
        }

        #endregion 保存家庭成员

        #region 添加成员前校验

        private string CheckAdd()
        {
            string seq_no = Get("seq_no");
            object o = ds.ExecuteTxtScalar(string.Format("SELECT COUNT(1) FROM DST_FAMILY_MEMBERS WHERE SEQ_NO='{0}'", seq_no));
            if (o != null && o.ToString().Length > 0)
            {
                int cnt = Int32.Parse(o.ToString());
                if (cnt == 8)
                {
                    return "最多只能添加8位家庭成员！";
                }
                else
                {
                    //家庭成员+本人=家庭人口数
                    object size = ds.ExecuteTxtScalar(string.Format("SELECT FAMILY_SIZE FROM DST_FAMILY_SITUA WHERE SEQ_NO='{0}'", seq_no));
                    if (ComTranClass.getInstance().ToInt(size) == 0)
                        return "请填写家庭人口数并保存后，再添加家庭成员！";
                    if (cnt + 1 >= ComTranClass.getInstance().ToInt(size))
                        return "家庭成员已达上限，不允许再添加！";
                }
            }

            return string.Empty;
        }

        #endregion 添加成员前校验

        #region 删除家庭成员

        private string DeleteMember()
        {
            bool bDel = false;
            string oid = Get("oid");
            if (string.IsNullOrEmpty(oid))
                return "主键为空，不允许删除！";

            Dst_family_members m = new Dst_family_members();
            m.OID = oid;
            ds.RetrieveObject(m);
            var transaction = ImplementFactory.GetDeleteTransaction<Dst_family_members>("Dst_family_membersDeleteTransaction");
            transaction.EntityList.Add(m);
            bDel = transaction.Commit();
            if (bDel)
            {
                string msg;
                if (!FamilySurveyHandleClass.getInstance().CalculateIncome(m.SEQ_NO, out msg))
                {
                    msg = "计算家庭年收入异常";
                }
                return msg;
            }

            return "删除失败！";
        }

        #endregion 删除家庭成员

        #region 加载附件列表

        private string GetFile()
        {
            string where = string.Format(" AND SEQ_NO='{0}'", Get("seq_no"));
            var ddl = new Hashtable();
            ddl["NOTE"] = "ddl_material_notes";

            return tables.GetCmdQueryData("GET_FAMILY_PHOTO", null, where, string.Empty, ddl);
        }

        #endregion 加载附件列表

        #region 删除附件

        private string DeletePhoto()
        {
            var oid = Get("id");
            if (string.IsNullOrEmpty(oid)) return "主键为空,不允许删除操作";
            string sqlDeleteConta = string.Format("DELETE FROM DST_FAMILY_PHOTO WHERE OID='{0}'", oid);
            string m_strUploadPhoto = System.Web.HttpContext.Current.Server.MapPath("~/" + Util.GetAppSettings("PhotoPath"));
            var model = new Dst_family_photo();
            model.OID = oid;
            ds.RetrieveObject(model);
            if (ds.ExecuteTxtNonQuery(sqlDeleteConta) > 0)
            {
                string delpath = m_strUploadPhoto + "\\" + model.ARCHIVE_DIRECTORY + "\\" + model.PHOTO_NAME;
                if (File.Exists(delpath))
                {
                    FileInfo fi = new FileInfo(delpath);
                    if (fi.Attributes.ToString().IndexOf("ReadOnly") != -1)
                        fi.Attributes = FileAttributes.Normal;

                    File.Delete(delpath);
                }
                return "";
            }

            return "删除失败！";
        }

        #endregion 删除附件

        #region 加载调查记录列表

        private string GetSurveyRecord()
        {
            string where = string.Format(" AND STU_NUMBER='{0}'", Get("number"));
            var ddl = new Hashtable();

            return tables.GetCmdQueryData("GET_SURVEY_RECORD", null, where, string.Empty, ddl);
        }

        #endregion 加载调查记录列表
    }
}