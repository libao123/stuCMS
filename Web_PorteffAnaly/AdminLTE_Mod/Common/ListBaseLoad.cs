using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HQ.Architecture.Strategy;
using HQ.DALFactory;
using HQ.InterfaceService;
using HQ.Utility;

namespace AdminLTE_Mod.Common
{
    public abstract class ListBaseLoad<T> : ListBase<T> where T : DacHelper, new()
    {
        protected Dictionary<string, string> param = new Dictionary<string, string>();

        /// <summary>
        /// 单据录入人字段
        /// </summary>
        protected abstract string input_code_column { get; }

        /// <summary>
        /// 班级代码字段
        /// </summary>
        protected abstract string class_code_column { get; }

        /// <summary>
        /// 学院代码字段
        /// </summary>
        protected abstract string xy_code_column { get; }

        /// <summary>
        /// 是否进行过滤筛选
        /// </summary>
        protected abstract bool is_do_filter { get; }

        /// <summary>
        /// 是否是管理员
        /// </summary>
        public bool Is_AdminUser { get { return user.User_Id.Equals(ApplicationSettings.Get("AdminUser").ToString()); } }

        #region 获得查询结果

        /// <summary>
        /// 获得查询结果
        /// </summary>
        /// <param name="selecttrcn"></param>
        /// <returns></returns>
        protected override dynamic GetInstanceList(SelectTransaction<T> selecttrcn)
        {
            var size = GetPageSize();
            //组合查询语句
            string where = GetSearchWhere();
            InitParams();
            if (param.Count > 0)
            {
                foreach (var p in param)
                {
                    if (p.Value.Length > 0)
                        where += string.Format(" AND {0}='{1}' ", p.Key, p.Value);
                    else
                        where += string.Format(" AND {0}", p.Key);
                }
            }
            List<T> list = selecttrcn.SelectAll(where, size.PageSize * (size.PageIndex - 1), size.PageSize * size.PageIndex + 1);//查询出结果
            return new { Draw = size.Draw, recordsTotal = selecttrcn.SelectRowsCount(), recordsFiltered = selecttrcn.SelectRowsCount(where), List = list };
        }

        #endregion 获得查询结果

        #region 获取查询条件

        /// <summary>
        /// 获取查询条件
        /// </summary>
        /// <returns></returns>
        public virtual string GetSearchWhere()
        {
            string where = string.Empty;
            return where;
        }

        #endregion 获取查询条件

        #region 自定义查询条件

        /// <summary>
        /// 自定义查询条件
        /// </summary>
        protected virtual void InitParams()
        {
            if (Is_AdminUser)
                return;
            if (!is_do_filter)
                return;

            DataFilterHandleClass filter = new DataFilterHandleClass();
            filter.InputerInfo(input_code_column, class_code_column, xy_code_column, user.User_Id, user.User_Role, user.User_Xy);
            switch (user.User_Type)
            {
                case "S":
                    filter.Student_DataFilter(param);
                    break;
                case "T":
                    filter.Teacher_DataFilter(param);
                    break;
                default:
                    filter.DefaultParams(param);
                    break;
            }
        }

        #endregion 自定义查询条件
    }
}