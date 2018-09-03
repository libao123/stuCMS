using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HQ.Architecture.Strategy;
using HQ.DALFactory;

namespace AdminLTE_Mod.Common
{
    public abstract class ListBase<T> : ListBaseWithoutSelectTransaction<T> where T : DacHelper, new()
    {
        protected override dynamic GetInstanceList()
        {
            return GetInstanceList(GetSelectTransaction());
        }

        protected virtual dynamic GetInstanceList(SelectTransaction<T> selecttrcn)
        {
            var size = GetPageSize();
            List<T> list = selecttrcn.SelectAll(size.PageSize * (size.PageIndex - 1), size.PageSize * size.PageIndex + 1);//查询出结果
            return new { Draw = size.Draw, recordsTotal = selecttrcn.SelectRowsCount(), recordsFiltered = selecttrcn.SelectRowsCount(), List = list };
        }

        protected dynamic GetPageSize()
        {
            int pageindex, pagesize;
            int draw;
            int.TryParse(Request["draw"], out draw);//绘制计数器。这个是用来确保Ajax从服务器返回的是对应的（Ajax是异步的，因此返回的顺序是不确定的）
            int.TryParse(Request["start"], out pageindex);//第一条数据的起始位置，比如0代表第一条数据
            int.TryParse(Request["length"], out pagesize);//告诉服务器每页显示的条数，这个数字会等于返回的 data集合的记录数，可能会大于因为服务器可能没有那么多数据。这个也可能是-1，代表需要返回全部数据(尽管这个和服务器处理的理念有点违背)
            if (pagesize == 0)
                pageindex = 1;
            else
                pageindex = pageindex / pagesize + 1;
            if (pagesize == 0)
                pagesize = 10;//默认10条

            return new { PageSize = pagesize, PageIndex = pageindex, Draw = draw };
        }

        /// <summary>
        /// 获取相关查询事务
        /// </summary>
        /// <returns></returns>
        protected abstract SelectTransaction<T> GetSelectTransaction();
    }
}