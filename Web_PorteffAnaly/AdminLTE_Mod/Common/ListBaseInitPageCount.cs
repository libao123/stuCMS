using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HQ.Architecture.Strategy;
using HQ.DALFactory;

namespace AdminLTE_Mod.Common
{
    public abstract class ListBaseInitPageCount<T> : ListBaseWithoutSelectTransaction<T> where T : DacHelper, new()
    {
        public string pageStr = "", rowsStr = "";

        protected override dynamic GetInstanceList()
        {
            return GetInstanceList(GetSelectTransaction());
        }

        protected virtual dynamic GetInstanceList(SelectTransaction<T> selecttrcn)
        {
            var size = GetPageSize();
            List<T> list = selecttrcn.SelectAll(size.PageSize * (size.PageIndex - 1), size.PageSize * size.PageIndex + 1);//查询出结果
            return new { List = list, Count = selecttrcn.SelectRowsCount() };
        }

        protected dynamic GetPageSize()
        {
            int pageindex, pagesize;
            int.TryParse(pageStr, out pageindex);
            int.TryParse(rowsStr, out pagesize);
            if (pageindex == 0) pageindex = 1;
            if (pagesize == 0) pagesize = 10;

            return new { PageSize = pagesize, PageIndex = pageindex };
        }

        /// <summary>
        /// 获取相关查询事务
        /// </summary>
        /// <returns></returns>
        protected abstract SelectTransaction<T> GetSelectTransaction();
    }
}