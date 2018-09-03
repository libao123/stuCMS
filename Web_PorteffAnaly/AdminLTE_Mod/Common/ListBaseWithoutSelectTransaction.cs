using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using HQ.DALFactory;
using HQ.Utility;
using HQ.WebForm;

namespace AdminLTE_Mod.Common
{
    public abstract class ListBaseWithoutSelectTransaction<T> : Main where T : DacHelper, new()
    {
        protected struct NameValue
        {
            /// <summary>
            /// 字段名
            /// </summary>
            public string Name { get; set; }

            /// <summary>
            /// 字段值
            /// </summary>
            public string Value { get; set; }
        }

        protected abstract dynamic GetInstanceList();

        /// <summary>
        /// 读取数据，并转换为输出到页面的Json格式
        /// </summary>
        /// <returns></returns>
        protected string GetList()
        {
            //进行查询
            var res = GetInstanceList();
            StringBuilder sb = new StringBuilder();//用来存放Json的
            //将查询结果转换为Json
            sb.Append("{");
            //draw,recordsTotal,recordsFiltered,data.
            //说明下：
            //draw ：传给你的是什么，你返回的就是什么
            //recordsTotal ：总条数
            //recordsFiltered ：过滤后的总数
            //data ：数据。（这里需要注意下，data这个命名是默认的，咱们封装数据的时候，是可以修改的，这时候就需要配置属性 dataSrc : "list",//这个参数是自己封装的json里面的key）
            sb.Append("\"draw\":");
            sb.Append(res.Draw);
            sb.Append(",\"recordsTotal\":");
            sb.Append(res.recordsTotal);
            sb.Append(",\"recordsFiltered\":");
            sb.Append(res.recordsFiltered);
            sb.Append(",\"data\":");
            sb.Append("[");
            foreach (T entity in res.List)
            {
                sb.Append("{");
                foreach (var val in GetValue(entity))
                {
                    sb.Append(Json.StringToJson(val.Value, val.Name));
                    sb.Append(",");
                }
                sb.Remove(sb.Length - 1, 1);//去掉最后一个逗号
                sb.Append("},");
            }
            if (sb[sb.Length - 1].Equals(','))
            {//必须有数据才去掉最后一个逗号‘,’,不然会报错 20120816 mo
                sb.Remove(sb.Length - 1, 1);//去掉最后一个逗号
            }
            sb.Append("]");
            sb.Append("}");
            return Json.StringToJson(sb.ToString(), string.Empty, true);
        }

        /// <summary>
        /// 获取想要在页面上显示的所有字段值
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        protected abstract IEnumerable<NameValue> GetValue(T entity);
    }
}