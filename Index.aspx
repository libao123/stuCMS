<%@ Page Language="C#" Inherits="HQ.WebForm.Index" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>大学生资助信息管理系统首页</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
        name="viewport" />
    <link rel="stylesheet" href="/AdminLTE/common/js/bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/AdminLTE/common/css/font-awesome.min.css" />
    <link rel="stylesheet" href="/AdminLTE/common/css/ionicons.min.css" />
    <link rel="stylesheet" href="/AdminLTE/common/css/AdminLTE.min.css" />
    <link rel="stylesheet" href="/AdminLTE/common/plugins/Hui/Hui-iconfont/1.0.7/iconfont.css" />
    <link rel="stylesheet" href="/AdminLTE/common/plugins/Hui/h-ui/css/H-ui.css" />
    <link rel="stylesheet" href="/AdminLTE/common/plugins/Hui/h-ui.admin/css/H-ui.admin.css" />
    <link rel="stylesheet" href="/AdminLTE/common/css/skins/_all-skins.min.css" />
    <!-- bootstrap wysihtml5 - text editor -->
    <!--<link rel="stylesheet" href="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">-->
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
	  	<script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
	  	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	  	<![endif]-->
    <style type="text/css">
        .content-wrapper{
            position: relative;
        }
        .menu .title-f{
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
            max-width: 100%;
        }
        .user-panel .info a{
            display: block;
            width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .dropdown-menu .user-header p span{
            display: block;
            width: 100%;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .form-group:last-child{
	  		margin-bottom: 0;
	  	}
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">
        <header class="main-header">
			<a href="#" class="logo">
			    <span class="logo-mini"><b>资助系统</b></span>
			    <span class="logo-lg"><b>大学生资助系统</b></span>
			</a>
			<nav class="navbar navbar-static-top">
			    <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
			        <span class="sr-only">Toggle</span>
			    </a>
			    <div class="navbar-custom-menu" id="headMenu">
			        <ul class="nav navbar-nav">
			          	<li class="dropdown user user-menu">
					        <a href="#" class="dropdown-toggle login-in-out">
					            <img src="/AdminLTE/common/images/user2-160x160.jpg" class="user-image" alt="User Image" />
					            <span class="hidden-xs"> <%= user.User_Name %></span>
					        </a>
			          	</li>
			        </ul>
			    </div>
			</nav>
		</header>
        <aside class="main-sidebar">
			<div class="sidebar">
				<div class="user-panel">
				    <div class="pull-left image">
				        <img src="/AdminLTE/common/images/user2-160x160.jpg" class="img-circle" alt="User Image">
				    </div>
				    <div class="pull-left info">
				        <p> <%= user.User_Name %></p>
				        <a href="#"><i class="fa fa-circle text-success"></i> <%= strUserRole%></a>
				    </div>
			    </div>
			    <ul class="sidebar-menu" id="sidebar-menu">
			        <li class="header">导航</li>
			    </ul>
			</div>
		</aside>
        <div class="content-wrapper">
            <div id="Hui-tabNav" class="Hui-tabNav">
                <div class="Hui-tabNav-wp">
                    <ul id="min_title_list" class="acrossTab cl" style="padding-left: 6px;">
                        <li class="active"><span title="首页" data-href='/Home/Home.aspx'>首页</span><em></em>
                        </li>
                    </ul>
                </div>
                <div class="Hui-tabNav-more btn-group">
                    <a id="js-tabNav-prev" class="btn radius btn-default size-S" href="javascript:void(0);">
                        <i class="Hui-iconfont">&#xe6d4;</i> </a><a id="js-tabNav-next" class="btn radius btn-default size-S"
                            href="javascript:void(0);"><i class="Hui-iconfont">&#xe6d7;</i> </a>
                </div>
            </div>
            <div id="iframe_box" class="Hui-article">
                <div class="show_iframe">
                    <div style="display: none" class="loading">
                    </div>
                    <iframe scrolling="yes" frameborder="0" src="/Home/Home.aspx"></iframe>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="/AdminLTE/common/js/jquery/jquery-2.2.3.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/js/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/js/app.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/Hui/h-ui/js/H-ui.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/Hui/h-ui.admin/js/H-ui.admin.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/js/common.js"></script>
    <script src="/Scripts/jsHelper.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            /*菜单加载*/
            var siderbarData = "";
            var tree_data = AjaxUtils.getResponseText(MiscUtils.FormatUrl("tree_data.aspx"));
            if (tree_data.length > 0)
                siderbarData = eval('(' + tree_data + ')');
            var s = mainSidebar.init("#sidebar-menu", siderbarData);
            /*公告加载*/
            var headNoticeData = [
				{ 'iconClass': 'fa fa-users text-aqua', 'msg': '今天是第一天' },
				{ 'iconClass': 'fa fa-warning text-yellow', 'msg': '时间很紧迫' },
				{ 'iconClass': 'fa fa-warning text-yellow', 'msg': '这是一段很长的警告。。警告。。警告。。。。。' },
			];
            /*消息加载*/
            var headMsgData = [
				{ 'icon': '/AdminLTE/common/images/user2-160x160.jpg', 'title': '大标题', 'time': '2017-06-22', 'msg': '这里是信息的标题。应该不会很长。。试试会不会很长。' },
			];
            var hs = mainHeader.init('#headMenu .nav', headMsgData, headNoticeData);
            /*iframe高度自适应*/
			var siH = $(".main-sidebar").height();
			$('#iframe_box').css('height', siH);
            /*退出登录*/
            $('.login-in-out').on('click', function () {
                if (confirm('是否要退出？')) {
                    console.log('退出');
                    window.location.href = "user_abandon.aspx"; //退出链接。
                } else {
                    console.log('继续');
                }
            });
        });
    </script>
</body>
</html>