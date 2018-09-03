using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.Architecture.Factory;
using HQ.Model;
using HQ.WebForm;
using Newtonsoft.Json;

namespace PorteffAnaly.Web.AdminLTE_Mod.UserAuthority.FunctionManage
{
    public class JsonObj
    {
        public string NAME { get; set; }

        public string DESCRIPTION { get; set; }

        public string URL { get; set; }

        public string SEQUENCE { get; set; }

        public string ICON { get; set; }

        public string SHOWINMENU { get; set; }

        public string NOTICE_FLAG { get; set; }

        public string QUICK_FLAG { get; set; }

        public string YJS_FLAG { get; set; }

        public string FUNCTIONID { get; set; }

        public string HASROLE { get; set; }
    }

    public partial class List : Main
    {
        comdata cod = new comdata();

        #region 页面加载

        private Ua_function model = new Ua_function();

        protected void Page_Load(object sender, EventArgs e)
        {
            string optype = Request.QueryString["optype"];
            if (!string.IsNullOrEmpty(optype))
            {
                switch (optype)
                {
                    case "getlist":
                        Response.Write(GetJson());
                        break;
                    case "del":
                        Response.Write(Delete());
                        break;
                    case "getnode":
                        Response.ContentType = "application/json";
                        Response.Write(GetNode());
                        break;
                    case "add":
                    case "save":
                        Response.Write(Save());
                        break;
                }
                Response.End();
            }
        }

        #endregion 页面加载

        private string GetNode()
        {
            string functionid = Get("id");
            List<Ua_function> listAll = ImplementFactory.GetSelectTransaction<Ua_function>("Ua_functionSelectTransaction", new Dictionary<string, string> { { "FUNCTIONID", functionid } }).SelectAll();
            string json = "{}";
            if (listAll.Count > 0)
            {
                model = listAll[0];
                JsonObj jsonObj = new JsonObj();
                jsonObj.DESCRIPTION = model.DESCRIPTION;
                jsonObj.FUNCTIONID = model.FUNCTIONID;
                jsonObj.ICON = model.ICON;
                jsonObj.NAME = model.NAME;
                jsonObj.NOTICE_FLAG = model.NOTICE_FLAG;
                jsonObj.SEQUENCE = model.SEQUENCE.ToString();
                jsonObj.SHOWINMENU = model.SHOWINMENU;
                jsonObj.QUICK_FLAG = model.QUICK_FLAG;
                jsonObj.YJS_FLAG = model.YJS_FLAG;
                jsonObj.URL = model.URL;
                jsonObj.HASROLE = getRole4FunId(model.FUNCTIONID);
                json = JsonConvert.SerializeObject(jsonObj);
            }
            return json;
        }

        private string Save()
        {
            if (Request.QueryString["optype"].Equals("add"))
            {
                model.FUNCTIONID = Guid.NewGuid().ToString();
                ds.RetrieveObject(model);
                model.PARENTID = Request.QueryString["id"];
                GetValue(model);
                var inserttrcn = ImplementFactory.GetInsertTransaction<Ua_function>("Ua_functionInsertTransaction", user.User_Name);
                inserttrcn.EntityList.Add(model);
                if (inserttrcn.Commit())
                    return "保存成功";
                return "保存失败";
            }
            else
            {
                model.FUNCTIONID = Request.QueryString["id"];
                ds.RetrieveObject(model);
                GetValue(model);
                var updatetrcn = ImplementFactory.GetUpdateTransaction<Ua_function>("Ua_functionUpdateTransaction", user.User_Name);
                if (updatetrcn.Commit(model))
                    return "保存成功";
                return "保存失败";
            }
        }

        private void GetValue(Ua_function model)
        {
            model.NAME = Post("NAME");
            model.URL = Post("URL");
            model.SEQUENCE = cod.ChangeInt(Post("SEQUENCE"));
            model.DESCRIPTION = Post("DESCRIPTION");
            model.SHOWINMENU = Post("SHOWINMENU");
            model.ICON = Post("ICON");
            model.NOTICE_FLAG = Post("NOTICE_FLAG");
            model.QUICK_FLAG = Post("QUICK_FLAG");
            model.YJS_FLAG = Post("YJS_FLAG");
        }

        private string getRole4FunId(string functionid)
        {
            string reV = string.Empty;

            try
            {
                string sql = string.Format("SELECT DISTINCT NAME FROM UA_ROLE WHERE ROLEID IN(SELECT ROLEID FROM UA_ROLE_FUNC WHERE FUNCTIONID='{0}')", functionid);
                IDataReader dr = ds.ExecuteTxtReader(sql);
                while (dr.Read())
                {
                    reV += dr[0].ToString() + ", ";
                }
                dr.Close();
                if (reV.Length > 0 && reV.EndsWith(", "))
                    reV = reV.Remove(reV.Length - 2, 2);
                return reV;
            }
            catch (Exception ex)
            {
                return "读取已分配的岗位名称错误!原因：" + ex.Message;
            }
        }

        #region 获取父菜单

        private string GetJson()
        {
            StringBuilder sb = new StringBuilder();

            Dictionary<string, string> param = new Dictionary<string, string>();
            var selectTran = ImplementFactory.GetSelectTransaction<Ua_function>("Ua_functionSelectTransaction", param);
            List<Ua_function> listAll = selectTran.SelectAll();

            if (listAll.Count > 0)
            {
                Ua_function root = listAll.Find(p => p.FUNCTIONID.Equals(ConfigurationManager.AppSettings["GenericTreeId"].ToString()));
                if (root != null)
                {
                    sb.AppendFormat("[{{\"id\":\"{0}\",\"nodeId\":\"{0}\",\"text\":\"{1}\"", root.FUNCTIONID, root.NAME);
                    List<Ua_function> listParent = listAll.FindAll(p => p.PARENTID == root.FUNCTIONID);
                    if (listParent.Count > 0)
                    {
                        listParent.Sort(delegate(Ua_function small, Ua_function big) { return Comparer<decimal>.Default.Compare(small.SEQUENCE, big.SEQUENCE); });//按顺序排列
                        sb.Append(",\"nodes\":[");
                        foreach (Ua_function model in listParent)
                        {
                            sb.AppendFormat("{{\"id\":\"{0}\",\"nodeId\":\"{0}\",\"text\":\"{1}\"", model.FUNCTIONID, model.NAME);
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
        }

        #endregion 获取父菜单

        #region 获取子菜单

        private void AddChild(List<Ua_function> listAll, StringBuilder sb, string parentid)
        {
            List<Ua_function> listChildren = listAll.FindAll(p => p.PARENTID.Equals(parentid));
            if (listChildren.Count > 0)
            {
                listChildren.Sort(delegate(Ua_function small, Ua_function big) { return Comparer<decimal>.Default.Compare(small.SEQUENCE, big.SEQUENCE); });//按顺序排列
                sb.Append(",\"nodes\":[");
                foreach (Ua_function model in listChildren)
                {
                    sb.AppendFormat("{{\"id\":\"{0}\",\"nodeId\":\"{0}\",\"text\":\"{1}\"", model.FUNCTIONID, model.NAME);
                    AddChild(listAll, sb, model.FUNCTIONID);
                    sb.Append("},");
                }
                if (sb[sb.Length - 1] == ',')
                    sb.Remove(sb.Length - 1, 1);
                sb.Append("]");
            }
        }

        #endregion 获取子菜单

        #region 删除菜单

        private string Delete()
        {
            try
            {
                if (Request.QueryString["id"].Length <= 0)
                {
                    return "菜单ID参数不正确，重新操作或者联系管理人员进行处理";
                }

                var deletetrcn = ImplementFactory.GetDeleteTransaction<Ua_function>("Ua_functionDeleteTransaction");
                deletetrcn.EntityList.Add(new Ua_function()
                {
                    FUNCTIONID = Request.QueryString["id"]
                });
                if (deletetrcn.Commit())
                {
                    //把子菜单也一并删除
                    string strSQL = string.Format("DELETE FROM UA_FUNCTION WHERE PARENTID = '{0}' ", Request.QueryString["id"].ToString());
                    ds.ExecuteTxtNonQuery(strSQL);
                    return "删除成功";
                }
                return "操作失败!";
            }
            catch (Exception ex)
            {
                return "删除失败!原因：" + ex.Message;
            }
        }

        #endregion 删除菜单
    }
}