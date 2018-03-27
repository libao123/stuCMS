<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="PorteffAnaly.Web.Home.Home" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>welcome</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport" />
    <meta content="telephone=no,email=no" name="format-detection" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <link rel="stylesheet" href="/AdminLTE/common/js/bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/AdminLTE/common/css/font-awesome.min.css" />
    <link rel="stylesheet" href="/AdminLTE/common/css/ionicons.min.css" />
    <link rel="stylesheet" href="/AdminLTE/common/css/AdminLTE.min.css" />
    <link rel="stylesheet" href="/AdminLTE/common/css/skins/_all-skins.min.css" />
    <link rel="stylesheet" href="/AdminLTE/common/plugins/datatables/dataTables.bootstrap.css" />
    <link rel="stylesheet" href="/AdminLTE/common/plugins/datatables/dataTables.responsive.css" />
    <link rel="stylesheet" href="/AdminLTE/common/plugins/iCheck/all.css" />
    <link rel="stylesheet" href="/AdminLTE/common/css/common.css" />
    <!-- bootstrap wysihtml5 - text editor -->
    <!--<link rel="stylesheet" href="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">-->
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
	  	<script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
	  	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	  	<![endif]-->
    <style type="text/css">
        .content-wrapper
        {
            position: relative;
            margin-left: auto;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">
        <div class="content-wrapper">
            <section class="content-header">
                <h1>后台首页</h1>
            </section>
            <section class="content">
      	    <div class="row">
	      	    <div class="col-xs-12">
	      		    <div class="box box-primary">
	      			    <div class="box-header with-border">
              			    <h3 class="box-title">快速指引</h3>
              			    <div class="box-tools pull-right">
                		        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
              			    </div>
            		    </div>
            		    <div class="box-body" id="quickEnter">
					    </div>
	      		    </div>
      		    </div>
      	    </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="box box-danger">
	      			    <div class="box-header with-border">
              			    <h3 class="box-title">待办事项</h3>
              			        <div class="box-tools pull-right">
                      		        <a href="/AdminLTE_Mod/BDM/PersonalCenter/ToDo.aspx" class="btn btn-box-tool">更多</a>
                			        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
              			        </div>
            		    </div>
            		    <div class="box-body no-padding" id="Personal_ToDo">
					    </div>
	      		    </div>
                </div>
      	    </div>
      	    <div class="row">
                <div class="col-md-7">
                    <div class="box box-danger">
	      			    <div class="box-header with-border">
              			    <h3 class="box-title">工作通知</h3>
              			        <div class="box-tools pull-right">
                      		        <a href="/AdminLTE_Mod/BDM/Notice/List.aspx" class="btn btn-box-tool">更多</a>
                			        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
              			        </div>
            		    </div>
            		    <div class="box-body no-padding" id="Notice_W">
					    </div>
	      		    </div>
                </div>
                <div class="col-md-5">
                    <div class="box box-info">
	      			    <div class="box-header with-border">
              			    <h3 class="box-title">近期公告</h3>
              			    <div class="box-tools pull-right">
                      		    <a href="/AdminLTE_Mod/BDM/Notice/List.aspx" class="btn btn-box-tool">更多</a>
                			    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
              			    </div>
            		    </div>
            		    <div class="box-body no-padding" id="Notice_N">
					    </div>
	      		    </div>
                </div>
      	    </div>
            <div class="row">
              <div class="col-md-5">
                <div class="box box-success">
	      			    <div class="box-header with-border">
		              	    <h3 class="box-title">政策解读</h3>
		              	    <div class="box-tools pull-right">
		                      <a href="/AdminLTE_Mod/BDM/Notice/List.aspx" class="btn btn-box-tool">更多</a>
		                	    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
		              	    </div>
	            	    </div>
            		    <div class="box-body no-padding" id="Notice_Z">
					    </div>
	      		    </div>
              </div>
              <div class="col-md-7">
                <div class="box box-warning">
	      			    <div class="box-header with-border">
		              	    <h3 class="box-title">资助动态</h3>
		              	    <div class="box-tools pull-right">
		                      <a href="/AdminLTE_Mod/BDM/Notice/List.aspx" class="btn btn-box-tool">更多</a>
		                	    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
		              	    </div>
            		    </div>
            		    <div class="box-body no-padding" id="Notice_J">
					    </div>
	      		    </div>
              </div>
            </div>
        </section>
        </div>
    </div>
    <script type="text/javascript" src="/AdminLTE/common/js/jquery/jquery-2.2.3.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/js/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/iCheck/icheck.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/datatables/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/datatables/dataTables.bootstrap.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/datatables/dataTables.responsive.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/Hui/h-ui/js/H-ui.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/Hui/h-ui.admin/js/H-ui.admin.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/js/app.min.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/js/demoTabs.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/js/common.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/js/datatables.init.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/js/modal.control.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/js/jtools.js"></script>
    <script type="text/javascript" src="/AdminLTE/common/plugins/layer/layer.js"></script>
    <script type="text/javascript">
        $(function () {
            //快速入口
            var quickData = AjaxUtils.getResponseText("Home.aspx?optype=quick");
            if (quickData.length > 0)
                quickData_json = eval('(' + quickData + ')');
            quickEnter.init('#quickEnter', quickData_json);

            //工作通知
            var iNoticeData_W;
            var notice_data_w = AjaxUtils.getResponseText("Home.aspx?optype=notice&notice_type=W");
            if (notice_data_w.length > 0)
                iNoticeData_W = eval('(' + notice_data_w + ')');
            indexNotice.init('#Notice_W', iNoticeData_W);
            //近期公告
            var iNoticeData_N;
            var notice_data_n = AjaxUtils.getResponseText("Home.aspx?optype=notice&notice_type=N");
            if (notice_data_n.length > 0)
                iNoticeData_N = eval('(' + notice_data_n + ')');
            indexNotice.init('#Notice_N', iNoticeData_N);
            //政策解读
            var iNoticeData_Z;
            var notice_data_z = AjaxUtils.getResponseText("Home.aspx?optype=notice&notice_type=Z");
            if (notice_data_z.length > 0)
                iNoticeData_Z = eval('(' + notice_data_z + ')');
            indexNotice.init('#Notice_Z', iNoticeData_Z);
            //资助动态
            var iNoticeData_J;
            var notice_data_j = AjaxUtils.getResponseText("Home.aspx?optype=notice&notice_type=J");
            if (notice_data_j.length > 0)
                iNoticeData_J = eval('(' + notice_data_j + ')');
            indexNotice.init('#Notice_J', iNoticeData_J);
            //ZZ 20171216 新增：首页显示 待办事项 已办事项
            //待办事项
            var iPersonal_ToDo;
            var personal_data_todo = AjaxUtils.getResponseText("Home.aspx?optype=personal_todo");
            if (personal_data_todo.length > 0)
                iPersonal_ToDo = eval('(' + personal_data_todo + ')');
            indexPersonalTodo.init('#Personal_ToDo', iPersonal_ToDo);
        });
    </script>
</body>
</html>
