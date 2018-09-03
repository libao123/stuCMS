using System;
using System.Collections.Generic;
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
    public partial class StudyList : ListBaseLoad<Shoolar_apply_study_list>
    {
        #region 初始化

        private comdata cod = new comdata();

        protected override string input_code_column
        {
            get { return ""; }
        }

        protected override string class_code_column
        {
            get { return ""; }
        }

        protected override string xy_code_column
        {
            get { return ""; }
        }

        protected override bool is_do_filter
        {
            get { return false; }
        }

        protected override SelectTransaction<Shoolar_apply_study_list> GetSelectTransaction()
        {
            if (Request.QueryString["seq_no"] != null && Request.QueryString["seq_no"].Length != 0)
            {
                param.Add("SEQ_NO", Request.QueryString["seq_no"]);
            }
            else
            {
                param.Add(" 1=2 ", "");
            }
            return ImplementFactory.GetSelectTransaction<Shoolar_apply_study_list>("Shoolar_apply_study_listSelectTransaction", param);
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

                        case "save"://保存操作
                            Response.Write(SaveData());
                            Response.End();
                            break;
                    }
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Shoolar_apply_study_list>.NameValue> GetValue(Shoolar_apply_study_list entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "COURSE_NAME", Value = entity.COURSE_NAME };
            yield return new NameValue() { Name = "SCORE", Value = entity.SCORE.ToString() };
        }

        #endregion 输出列表信息

        #region 删除数据

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <returns></returns>
        private string DeleteData()
        {
            try
            {
                if (string.IsNullOrEmpty(Request.QueryString["id"]))
                    return "OID为空,不允许删除操作";
                Shoolar_apply_study_list head = new Shoolar_apply_study_list();
                head.OID = Request.QueryString["id"].ToString();
                ds.RetrieveObject(head);
                var transaction = ImplementFactory.GetDeleteTransaction<Shoolar_apply_study_list>("Shoolar_apply_study_listDeleteTransaction");
                transaction.EntityList.Add(head);
                if (!transaction.Commit())
                    return "删除失败！";
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "奖助申请，删除学习科目数据失败：" + ex.ToString());
                return "删除失败！";
            }
        }

        #endregion 删除数据

        #region 保存数据

        /// <summary>
        /// 保存数据
        /// </summary>
        /// <returns></returns>
        private string SaveData()
        {
            try
            {
                bool res = false;
                Shoolar_apply_study_list list = new Shoolar_apply_study_list();
                if (string.IsNullOrEmpty(Post("hidOid_StudyList")))
                {
                    list.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(list);
                    list.SEQ_NO = Post("hidSeqNo_StudyList");
                    list.COURSE_NAME = Post("COURSE_NAME");
                    list.SCORE = Math.Round(cod.ChangeDecimal(Post("SCORE")), 1);
                    var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_apply_study_list>("Shoolar_apply_study_listInsertTransaction");
                    inserttrcn.EntityList.Add(list);
                    res = inserttrcn.Commit();
                }
                else
                {
                    list.OID = Post("hidOid_StudyList");
                    ds.RetrieveObject(list);
                    list.COURSE_NAME = Post("COURSE_NAME");
                    list.SCORE = Math.Round(cod.ChangeDecimal(Post("SCORE")), 1);
                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Shoolar_apply_study_list>("Shoolar_apply_study_listUpdateTransaction", user.User_Name);
                    res = updatetrcn.Commit(list);
                }
                if (res)
                    return list.OID;//成功返回主键
                else
                    return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请，保存学习科目数据失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据
    }
}