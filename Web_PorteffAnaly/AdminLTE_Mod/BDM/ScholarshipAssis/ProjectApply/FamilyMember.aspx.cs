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
    public partial class FamilyMember : ListBaseLoad<Shoolar_apply_family_list>
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

        protected override SelectTransaction<Shoolar_apply_family_list> GetSelectTransaction()
        {
            if (Request.QueryString["seq_no"] != null && Request.QueryString["seq_no"].Length != 0)
            {
                param.Add("SEQ_NO", Request.QueryString["seq_no"]);
            }
            else
            {
                param.Add(" 1=2 ", "");
            }
            return ImplementFactory.GetSelectTransaction<Shoolar_apply_family_list>("Shoolar_apply_family_listSelectTransaction", param);
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

        protected override IEnumerable<ListBaseLoad<Shoolar_apply_family_list>.NameValue> GetValue(Shoolar_apply_family_list entity)
        {
            yield return new NameValue() { Name = "OID", Value = entity.OID };
            yield return new NameValue() { Name = "SEQ_NO", Value = entity.SEQ_NO };
            yield return new NameValue() { Name = "MEMBER_NAME", Value = entity.MEMBER_NAME };
            yield return new NameValue() { Name = "MEMBER_AGE", Value = entity.MEMBER_AGE.ToString() };
            yield return new NameValue() { Name = "MEMBER_RELATION", Value = entity.MEMBER_RELATION };
            yield return new NameValue() { Name = "MEMBER_UNIT", Value = entity.MEMBER_UNIT };
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
                Shoolar_apply_family_list head = new Shoolar_apply_family_list();
                head.OID = Request.QueryString["id"].ToString();
                ds.RetrieveObject(head);
                var transaction = ImplementFactory.GetDeleteTransaction<Shoolar_apply_family_list>("Shoolar_apply_family_listDeleteTransaction");
                transaction.EntityList.Add(head);
                if (!transaction.Commit())
                    return "删除失败！";
                return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_WARN, "奖助申请，删除家庭成员数据失败：" + ex.ToString());
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
                Shoolar_apply_family_list list = new Shoolar_apply_family_list();
                if (string.IsNullOrEmpty(Post("hidOid_FamilyMember")))
                {
                    list.OID = Guid.NewGuid().ToString();
                    ds.RetrieveObject(list);
                    list.SEQ_NO = Post("hidSeqNo_FamilyMember");
                    list.MEMBER_NAME = Post("MEMBER_NAME");
                    list.MEMBER_AGE = cod.ChangeInt(Post("MEMBER_AGE"));
                    list.MEMBER_RELATION = Post("MEMBER_RELATION");
                    list.MEMBER_UNIT = Post("MEMBER_UNIT");
                    var inserttrcn = ImplementFactory.GetInsertTransaction<Shoolar_apply_family_list>("Shoolar_apply_family_listInsertTransaction");
                    inserttrcn.EntityList.Add(list);
                    res = inserttrcn.Commit();
                }
                else
                {
                    list.OID = Post("hidOid_FamilyMember");
                    ds.RetrieveObject(list);
                    list.MEMBER_NAME = Post("MEMBER_NAME");
                    list.MEMBER_AGE = cod.ChangeInt(Post("MEMBER_AGE"));
                    list.MEMBER_RELATION = Post("MEMBER_RELATION");
                    list.MEMBER_UNIT = Post("MEMBER_UNIT");
                    var updatetrcn = ImplementFactory.GetUpdateTransaction<Shoolar_apply_family_list>("Shoolar_apply_family_listUpdateTransaction", user.User_Name);
                    res = updatetrcn.Commit(list);
                }
                if (res)
                    return list.OID;//成功返回主键
                else
                    return string.Empty;
            }
            catch (Exception ex)
            {
                LogDBHandleClass.getInstance().LogException(CValue.LOG_LEVEL_ERROR, "奖助申请，保存家庭成员数据失败：" + ex.ToString());
                return string.Empty;
            }
        }

        #endregion 保存数据
    }
}