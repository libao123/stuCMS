using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PorteffAnaly.Web.AdminLTE_Mod.BDM.DST.Common
{
    /// <summary>
    /// EXCEL导出字段对应类
    /// </summary>
    public class TableMapping
    {
        /// <summary>
        /// 家庭调查表导出字段
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, string> TbFamilySurvey()
        {
            Dictionary<string, string> dcMapping = new Dictionary<string, string>();
            dcMapping.Add("NUMBER", "学号");
            dcMapping.Add("NAME", "姓名");
            dcMapping.Add("SEX", "性别");
            dcMapping.Add("COLLEGE", "学院");
            dcMapping.Add("MAJOR", "专业");
            dcMapping.Add("CLASS", "班级");
            dcMapping.Add("DEC_TIME", "调查时间");

            return dcMapping;
        }
    }
}