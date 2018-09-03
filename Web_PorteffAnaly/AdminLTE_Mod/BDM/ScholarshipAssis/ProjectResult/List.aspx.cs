using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HQ.InterfaceService;
using HQ.Model;
using HQ.Utility;
using HQ.WebForm;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.ScholarshipAssis.ProjectResult
{
    public partial class List : Main
    {
        public Basic_sch_info sch_info = ComHandleClass.getInstance().GetCurrentSchYearXqInfo();
        public string IsSchool = "false";//ZZ 20171026 新增：是否显示按钮：校级角色显示
        public string IsXueYuan = "false";//ZZ 20171026 新增：是否显示按钮：院级角色显示

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string optype = Request.QueryString["optype"];
                if (!string.IsNullOrEmpty(optype))
                {
                    switch (optype.ToLower().Trim())
                    {
                        case "chkquery":
                            Response.Write(ChkQuery());
                            Response.End();
                            break;
                    }
                }
            }

            if (user.User_Role.Equals(CValue.ROLE_TYPE_X) || user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()))
            {
                IsSchool = "true";
            }
            if (user.User_Role.Equals(CValue.ROLE_TYPE_Y))
            {
                IsXueYuan = "true";
            }
        }

        /// <summary>
        /// 校验查询的项目名称是否符合
        /// </summary>
        /// <returns></returns>
        private string ChkQuery()
        {
            if (string.IsNullOrWhiteSpace(Get("PROJECT_SEQ_NO")))
                return "项目名称不能为空！";
            Dictionary<string, string> param = new Dictionary<string, string>();
            param.Add("SEQ_NO", Get("PROJECT_SEQ_NO"));
            Shoolar_project_head head = ProjectSettingHandleClass.getInstance().GetProjectHead(param);
            if (head == null)
                return "项目信息不能为空！";
            if (!head.PROJECT_TYPE.Equals("SCHOOL_MODEL"))
                return "项目名称不属于三好学生标兵！";
            return string.Empty;
        }
    }
}