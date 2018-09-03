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
using HQ.Model;
using HQ.WebForm;
using System.Text;
using System.Configuration;

namespace PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.RoleManage
{
    public partial class List : ListBaseLoad<Ua_role>
    {
        #region 初始化

        public comdata cod = new comdata();
		private List<Ua_role_func> funcAll = null;

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

        protected override SelectTransaction<Ua_role> GetSelectTransaction()
        {
            Dictionary<string, string> param = new Dictionary<string, string>();
            return ImplementFactory.GetSelectTransaction<Ua_role>("Ua_roleSelectTransaction");
        }

        #endregion 初始化

        #region 页面加载

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
				string id = Request.QueryString["roleid"];
				if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "getlist":
                            Response.Write(GetList());
                            break;
                        case "getuserlist":
                            Response.Write(GetUserList());
                            break;
                        case "del":
                            Response.Write(Delete());
                            break;
						case "save":
							Response.Write(SaveData());
							break;
						case "savepermission":
							Response.Write(SavePermission());
							break;
						case "getmenu":
							Response.Write(GetJson(id));
							Response.End();
							break;
					}
                    Response.End();
                }
            }
        }

        #endregion 页面加载

        #region 输出列表信息

        protected override IEnumerable<ListBaseLoad<Ua_role>.NameValue> GetValue(Ua_role entity)
        {
            yield return new NameValue() { Name = "ROLEID", Value = entity.ROLEID };
            yield return new NameValue() { Name = "NAME", Value = entity.NAME };
            yield return new NameValue() { Name = "DESCRIPTION", Value = entity.DESCRIPTION };
            yield return new NameValue() { Name = "LASTMODIFYUSER", Value = entity.LASTMODIFYUSER };
            yield return new NameValue() { Name = "LASTMODIFYTIME", Value = entity.LASTMODIFYTIME };
        }

        #endregion 输出列表信息

        #region 删除操作

        /// <summary>
        /// 删除操作
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        private string Delete()
        {
            try
            {
                var deletetrcn = ImplementFactory.GetDeleteTransaction<Ua_role>("Ua_roleDeleteTransaction");
				deletetrcn.EntityList.Add(new Ua_role()
				{
					ROLEID = Post("ROLEID")

				});
                if (deletetrcn.Commit())
                {
                    return "";
                }
                return "操作失败!";
            }
            catch (Exception ex)
            {
                return "系统错误!原因：" + ex.Message;
            }
        }

        #endregion 删除操作

        #region 获取人员下用户列表

        public string GetUserList()
        {
            string reV = string.Empty;
            try
            {
                string sql = string.Format("SELECT DISTINCT(USERNAME) FROM SSO_USER WHERE USERID IN(SELECT ENTITYID FROM SSO_ENTITY2ROLE WHERE ROLEID='{0}')", Request.QueryString["id"]);
                IDataReader dr = ds.ExecuteTxtReader(sql);
                while (dr.Read())
                {
                    reV += dr[0].ToString() + "  ";
                }
                dr.Close();
            }
            catch (Exception ex)
            {
                return "获取人员下用户列表错误!原因：" + ex.Message;
            }

            return reV;
        }

		#endregion 获取人员下用户列表

		private string SaveData()
		{
			try
			{
				Ua_role head = new Ua_role();
				head.ROLEID = Post("ROLEID").Trim();
				if (head.ROLEID == "")
					head.ROLEID = Guid.NewGuid().ToString();
				ds.RetrieveObject(head);
				head.NAME = Post("NAME");
				head.DESCRIPTION = Post("DESCRIPTION");
				head.LASTMODIFYTIME = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
				ds.UpdateObject(head);
				return head.ROLEID;
			}
			catch (Exception ex)
			{
				return string.Empty;
			}
		}

		#region 获取父菜单

		private string GetJson(string id)
		{
			#region 设置功能

			StringBuilder sb = new StringBuilder();
			List<Ua_function> listAll = ImplementFactory.GetSelectTransaction<Ua_function>("Ua_functionSelectTransaction", new Dictionary<string, string>()).SelectAll();

			if (listAll.Count > 0)
			{
				Dictionary<string, string> param = new Dictionary<string, string>();

				string NAME = "1";
				string Type = " 1' AND ROLEID ='" + Request.QueryString["roleid"] + "' AND 1='1";
				param.Add(NAME, Type);

				funcAll = ImplementFactory.GetSelectTransaction<Ua_role_func>("Ua_role_funcSelectTransaction", param).SelectAll();
				Ua_function root = listAll.Find(p => p.FUNCTIONID.Equals(ConfigurationManager.AppSettings["GenericTreeId"].ToString()));
				if (root != null)
				{
					sb.AppendFormat("[{{\"id\":\"{0}\",\"text\":\"{1}\",\"state\":{{\"checked\":{2}}},\"attributes\":{{\"code\":\"{3}\"}}", root.FUNCTIONID, root.NAME, CheckFuncSelect(root.FUNCTIONID, root.FUNCTIONID, listAll), root.FUNCTIONID);
					List<Ua_function> listParent = listAll.FindAll(p => p.PARENTID == root.FUNCTIONID);
					if (listParent.Count > 0)
					{
						listParent.Sort(delegate (Ua_function small, Ua_function big) { return Comparer<string>.Default.Compare(small.SEQUENCE.ToString(), big.SEQUENCE.ToString()); });//按顺序排列
						sb.Append(",\"nodes\":[");
						foreach (Ua_function model in listParent)
						{
							sb.AppendFormat("{{\"id\":\"{0}\",\"text\":\"{1}\",\"state\":{{\"checked\":{2}}},\"attributes\":{{\"code\":\"{3}\"}}", model.FUNCTIONID, model.NAME, CheckFuncSelect(model.FUNCTIONID, model.FUNCTIONID, listAll), model.FUNCTIONID);
							AddChild(listAll, sb, model.FUNCTIONID);
							sb.Append("},");
						}
						if (sb[sb.Length - 1] == ',')
							sb.Remove(sb.Length - 1, 1);
						sb.Append("]");
					}
					sb.Append("}]");
				}
			}
			return sb.ToString();

			#endregion 设置功能
		}

		#endregion 获取父菜单

		#region 获取子菜单

		private void AddChild(List<Ua_function> listAll, StringBuilder sb, string parentid)
		{
			List<Ua_function> listChildren = listAll.FindAll(p => p.PARENTID.Equals(parentid));
			if (listChildren.Count > 0)
			{
				listChildren.Sort(delegate (Ua_function small, Ua_function big) { return Comparer<decimal>.Default.Compare(small.SEQUENCE, big.SEQUENCE); });//按顺序排列
				sb.Append(",\"nodes\":[");
				foreach (Ua_function model in listChildren)
				{
					sb.AppendFormat("{{\"id\":\"{0}\",\"text\":\"{1}\",\"state\":{{\"checked\":{2}}},\"attributes\":{{\"code\":\"{3}\"}}", model.FUNCTIONID, model.NAME, CheckFuncSelect(model.FUNCTIONID, model.FUNCTIONID, listAll), model.FUNCTIONID);
					AddChild(listAll, sb, model.FUNCTIONID);
					sb.Append("},");
				}
				if (sb[sb.Length - 1] == ',')
					sb.Remove(sb.Length - 1, 1);
				sb.Append("]");
			}
		}

		#endregion 获取子菜单
		#region 判断是否有权限

		private string CheckFuncSelect(string code, string id, List<Ua_function> list)
		{
			if (funcAll != null)
			{
				List<Ua_function> temp = list.FindAll(p => p.PARENTID.Equals(id));
				if (temp.Count > 0)
				{ //有子菜单
					foreach (Ua_function s in temp)
					{
						//if (!funcAll.Exists(p => p.FUNCTIONID.Equals(s.FUNCTIONID)))
						//{
						//	return "false";
						//}
						if (funcAll.Exists(p => p.FUNCTIONID.Equals(s.FUNCTIONID)))
						{
							return "true";
						}
					}
				}
				else
				{//没有子菜单
					if (funcAll.Find(p => p.FUNCTIONID.Equals(code)) != null)
					{
						return "true";
					}
				}
			}
			return "false";
		}

		#endregion 判断是否有权限

		private string SavePermission()
		{
			try
			{
				//删除
				string delStr = string.Format("DELETE FROM UA_ROLE_FUNC WHERE ROLEID='{0}'", Request.QueryString["roleid"]);
				ds.ExecuteTxtNonQuery(delStr);

				var insertTran = ImplementFactory.GetInsertTransaction<Ua_role_func>("Ua_role_funcInsertTransaction", Request.QueryString["roleid"]);
				string[] ids = Post("ids").Split(',');
				if (ids.Length > 0 && !(ids.Length == 1 && ids[0].Length == 0))
				{
					foreach (string id in ids)
					{
						if (insertTran.EntityList.FindAll(p => p.ROLEID.Equals(Request.QueryString["roleid"]) && p.FUNCTIONID.Equals(id)).Count <= 0)
						{//判断是否已存在
							insertTran.EntityList.Add(new Ua_role_func()
							{
								ROLEID = Request.QueryString["roleid"],
								FUNCTIONID = id
							});
						}
					}
				}
				if (insertTran.Commit()) { return ""; }
				else
				{
					return "保存失败！";
				}
			}
			catch (Exception ex)
			{
				return "系统错误！原因：" + ex.Message;
			}
		}
	}
}