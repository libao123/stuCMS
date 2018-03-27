<%@ Page Title="" Language="C#" MasterPageFile="~/Master/AltMaster.Master" AutoEventWireup="true"
    CodeBehind="List.aspx.cs" Inherits="PorteffAnaly.Web.BDM.STU.List" %>

<%@ Register Assembly="HQ.WebControl" Namespace="HQ.WebControl" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<script type="text/javascript">
		$(function () {
			window.onload = function(){
        if (window.parent) {
          setTimeout(function(){
            var _pageH = $("body").height();
            console.log(_pageH);
            var _parentIfm = $('#iframe_box', window.parent.document);
            if (_parentIfm.height() < _pageH) {
              _parentIfm.css({'height':_pageH+5,});
            } else{

            }
            console.log(_parentIfm.height());
          }, 200);
        }
      }
      loadTableList();
      loadModalBtnInit();

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Main" runat="server">
    <!--<div id="searchDiv" style="height: 90px;">
        <div style="height: 5px;">
        </div>
        <cc1:QueryField ID="QuerySearch" runat="server" QueryName="Stu_Basic_Info_Query"
            TableId="tabList" />
    </div>
    <div id="main" style="width: 100%;">
        <table id="tabList">
        </table>
    </div>
    <div id="editDiv" style="width: 700px; height: 600px; display: none;">
        <iframe id="editFrame" frameborder="0" src="" style="width: 100%; height: 100%;">
        </iframe>
    </div>
    <div id="divImportExcel" style="width: 500px; height: 300px; display: none;">
        <iframe id="ImportExcelFrame" frameborder="0" width="100%" height="100%" src="">
        </iframe>
    </div>
    <div id="excelDiv" style="width: 500px; height: 300px; display: none;">
        <iframe id="excelFrame" frameborder="0" src="" style="width: 100%; height: 100%;">
        </iframe>
    </div>-->
<div class="wrapper">
  <div id="menuFrame" class="content-wrapper" id="main-container">
	<!-- Main content -->
	<section class="content" id="content">
		<div class="row">
			<div class="col-xs-12">
				<div id="alertDiv"></div>
				<div class="box box-default">
					<table id="dataTable1" class="table table-bordered table-striped table-hover">
    			</table>
				</div>
			</div>
		</div>
	</section>

  </div>
</div>
		<!-- msg modal -->
		<div class="modal" id="tableModal">
          	<div class="modal-dialog">
	            <form action="#" method="post" name="form" class="modal-content form-horizontal" onsubmit="">
	              	<div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		                  	<span aria-hidden="true">×</span></button>
		                <h4 class="modal-title">公告通知管理</h4>
	              	</div>
	              	<div class="modal-body">
	              		<input name="ID" type="hidden" class="form-control" placeholder="Id" />
						        <div class="form-group">
		                  	<label class="col-sm-2 control-label">信息类型</label>
		                  	<div class="col-sm-10">
		                    	<select class="form-control" name="NOTICE_TYPE">
				                    <option value="1">通知公共</option>
				                    <option value="2">消息</option>
	                  			</select>
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">标题</label>
		                  	<div class="col-sm-10">
		                    	<input name="TITLE" type="text" class="form-control" placeholder="" />
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">副标题</label>
		                  	<div class="col-sm-10">
		                    	<input name="SUB_TITLE" type="text" class="form-control" placeholder="" />
		                  	</div>
		                </div>
		                <div class="form-group">
			                <label class="col-sm-2 control-label">开始时间</label>
			                <div class="col-sm-4">
				            	<input type="text" class="form-control timeSingle" name="START_TIME" />
			                </div>

			                <label class="col-sm-1 control-label">至</label>
			                <div class="col-sm-5">
				            	<input type="text" class="form-control timeSingle" name="END_TIME" />
			                </div>
		            	</div>
		            	<div class="form-group">
		                  	<label class="col-sm-2 control-label">查阅角色</label>
		                  	<div class="col-sm-10">
		                    	<input name="ROLEID" type="text" class="form-control" placeholder="" />
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">发布内容</label>
		                  	<div class="col-sm-10">
		                    	<textarea class="form-control ckEditor" name="ck_editor" id="editor1" rows="4" ></textarea>
		                  	</div>
		                </div>
		                <div class="form-group">
		                  	<label class="col-sm-2 control-label">发布人</label>
		                  	<div class="col-sm-4" style="margin-bottom: 10px;">
		                    	<input name="SEND_NAME" type="text" class="form-control" placeholder="" />
		                  	</div>
		                  	<label class="col-sm-2 control-label">发布时间</label>
		                  	<div class="col-sm-4">
		                    	<input name="SEND_TIME" type="text" class="form-control timeSingle" placeholder="" />
		                  	</div>
		                </div>
	              	</div>
		              	<div class="modal-footer">
		                	<button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
		                	<button type="submit" class="btn btn-primary btn-save">保存</button>
		              	</div>
	            </form>
	            <!-- /.modal-content -->
          	</div>
          	<!-- /.modal-dialog -->
        </div>
  	<!-- del -->
  	<div class="modal modal-warning" id="delModal">
        <div class="modal-dialog">
          	<form action="./List.aspx?optype=delete" method="POST" name="form" class="modal-content  form-horizontal">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">删除</h4>
              </div>
              <div class="modal-body">
                <p>确定要删除该信息？</p>
                <input type="hidden" name="ID" value="" />
                <input type="hidden" name="TITLE" value="" />
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">取消</button>
                <button type="submit" class="btn btn-outline">确定</button>
              </div>
            </form>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- file -->
    <div class="modal" id="fileModal">
      <div class="modal-dialog">
        <form action="#" method="post" name="form" class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
              <h4 class="modal-title">信息批量导入（附表）</h4>
            </div>
            <div class="modal-body">
              <!--<p>辅导员基本信息数据批量导入，如工号、姓名、身份证号、学院等。</p>-->
              <div class="form-group">
                <label for="modalInputFile">File input</label>
                <input id="modalInputFile" type="file" name="file" multiple="multiple" />

                <p class="help-block">信息数据批量导入。</p>
              </div>
            </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary btn-save">保存</button>
              </div>
        </form>
        <!-- /.modal-content -->
      </div>
      <!-- /.modal-dialog -->
    </div>
<script type="text/javascript">
  function loadModalBtnInit(){

    tablePackage.filed = [//配置表格各栏参数
        { "data": "NUMBER",
          "createdCell": function (nTd, sData, oData, iRow, iCol) {
            $(nTd).html("<input type='checkbox' name='checkList' value='" + sData + "'>");
          },
          "head":	"checkbox", "id":"checkAll",
        },
        { "data": "NUMBER", "head":"学号"},
        { "data": "NAME", "head":"姓名" },
        { "data": "COLLEGE", "head":"学院" },
        { "data": "MAJOR", "head":"专业" },
        { "data": "EDULENTH", "head":"年级" },
        { "data": "SEX", "head":"性别" },
        { "data": "GARDE", "head":"出生日期" },
        { "data": "IDCARDNO", "head":"身份证号" },
        { "data": "NATION", "head":"民族" },
        { "data": "POLISTATUS", "head":"政治面貌" },
        { "data": "CLASS", "head":"班级" },
        { "data": "STUTYPE", "head":"学生类型" },
        { "data": "EMAIL", "head":"EMAIL" },
        { "data": "QQNUM", "head":"QQ号码" },
        { "data": "POLISTATUS", "head":"政治面貌" }
    ];
    tablePackage.createOne({
      attrs:	{//表格参数
        tableId:"dataTable1",//表格id
        buttonId:"buttonId",//拓展按钮区域id
        tableTitle:"公共信息",
        checkAllId:"checkAll",//全选id
        tableConfig:{
          'pageLength':25,//每页显示个数，默认10条
          'selectSingle':true,//是否单选，默认为true
          'lengthChange':true,//用户改变分页
          //'ordering':true,//是否默认排序，默认为false
          'serverSide': false,//如果是服务器方式，必须要设置为true
          'ajax' : {//通过ajax访问后台获取数据
              "url": "../json/long.json",//后台地址
          },
        }
      },
      hasSearch:	{
        "cols":[
          {"data":"TITLE", "pre":"公共标题", "col":2, "type":"input"}
        ],
        "searchLink":	"Notice/List.aspx?optype=getlist",
        "searchCallBack":function(res, btn){
        	console.log(btn);

        },
      },
      hasBtns:	["reload","add","edit",
                {'type':'enter','title':'本科生导入模板','modal':'fileModal','action':'xxx/file1.aspx'},
                {'type':'enter','title':'研究生导入模板','modal':'fileModal','action':'xxx/file2.aspx'},
                {'type':'enter','title':'本科生批量导入','modal':'fileModal','action':'xxx/file3.aspx'},
                {'type':'enter','title':'研究生批量导入','modal':'fileModal','action':'xxx/file4.aspx'},
                "del"],//需要的按钮
    });

  }
  function loadModalBtnInit(){
    //ctrl
    var _content = $("#content"),
      _btns = {
        reload:	'.btn-reload',
      };
    var loadEditor = function(id) {
            var instance = CKEDITOR.instances[id];
            if (instance) {
                CKEDITOR.remove(instance);
            }
            CKEDITOR.replace(id);
        }
    var editorid = "editor1";
    loadEditor(editorid);
    _content.on('click', _btns.reload, function(){
      tablePackage.reload();
    });
    $dataModal.controls({
        "content":	"content",
        "modal":      "tableModal",//弹出层id
        "hasTime":    true,//时间控件控制
        "addAction":  "Edit.aspx?optype=add",//弹出层url
        "editAction": "Edit.aspx?optype=edit",//弹出层url
        "submitType":"form",//form或者ajax
        "submitBtn":  ".btn-save",
        "submitCallback":function(btn){
          console.log(btn);
        },//ajax下自定义ajax方法
        "valiConfig":{
          model:	'#tableModal form',
          validate:[
            {'name':'TITLE', 'tips':'标题必须填。'},
            {'name':'START_TIME', 'tips':'开始时间必须填。'},
            {'name':'END_TIME', 'tips':'结束时间必须填。'},
            {'name':'ckEditor', 'tips':'发布内容不能为空。'},
          ],
          callback:function(form){
              console.log(form)
            form.submit();
          },//验证成功后的操作
        }
      });
      $delModal.controls({
        "content":"content",
        "delModal":"delModal",//弹出层id
        // "delAction":"./List.aspx?optype=delete",
        "submitType":"form",
        "submitCallBack":function(btn){
          console.log(btn);
          // DeleteData();
        }
      });
      /*file 控制*/
      $fileModal.controls({
        "content":"content",
        "fileModal":"fileModal",//弹出层id，若有多个，在导入按钮里设置
        // "submitType":"form",
        "fileBtn":".btn-enter",
        //"fileAction":"List.aspx?optype=file",//可不写，会直接用导入按钮里的action属性
        "submitCallback":function(btn){
          console.log(btn);
          // $("#fileModal form").submit();
        }
      });
  }
</script>
</asp:Content>
