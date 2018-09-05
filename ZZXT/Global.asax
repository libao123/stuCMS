<%@ Application Language="C#" %>
<%@ Import Namespace="HQ.Utility" %>
<script RunAt="server">

    void Application_Start(object sender, EventArgs e)
    {
        // 在应用程序启动时运行的代码

    }

    void Application_End(object sender, EventArgs e)
    {
        //  在应用程序关闭时运行的代码

    }

    void Application_Error(object sender, EventArgs e)
    {
        // 在出现未处理的错误时运行的代码
        // Code that runs when an unhandled error occurs
        #region 在出现未处理的错误时运行的代码
        Exception ex = Server.GetLastError().GetBaseException();
        //程序员跟踪
        //new Terminator().Throw(errorTime + "<br>" + errorAddress + "<br>" + errorInfo + "<br>" + errorSource + "<br>" + errorTrace + "<br>");
        //用户提示
        new HQ.Utility.Terminator().Throw("访问出错：<br />→　异常信息：" + ex.Message + " <br />→　请检查您的操作是否有误 ", "系统提示", null, null, false);
        #endregion
    }

    void Session_Start(object sender, EventArgs e)
    {
        // 在新会话启动时运行的代码

    }

    void Session_End(object sender, EventArgs e)
    {
        // 在会话结束时运行的代码。
        // 注意: 只有在 Web.config 文件中的 sessionstate 模式设置为
        // InProc 时，才会引发 Session_End 事件。如果会话模式设置为 StateServer
        // 或 SQLServer，则不会引发该事件。

    }
</script>