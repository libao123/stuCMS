/**
* @license Copyright (c) 2003-2017, CKSource - Frederico Knabben. All rights reserved.
* For licensing, see LICENSE.md or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function (config) {
    config.customConfig = 'config.js';
    config.language = 'zh-cn';
    config.defaultLanguage = 'en';
    config.docType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">';
    config.contentsCss = ' /AdminLTE/common/plugins/ckeditor/contents.css';
    config.protectedSource.push(/<%[\s\S]*?%>/g); 											// ASP code
    config.protectedSource.push(/(<asp:[^\>]+>[\s|\S]*?<\/asp:[^\>]+>)|(<asp:[^\>]+\/>)/gi); // ASP.NET code
    config.autoUpdateElement = true;
    config.forceEnterMode = true;
    config.tabIndex = 1;
    config.height = 300;
    config.enterMode = CKEDITOR.ENTER_BR;
  	config.shiftEnterMode = CKEDITOR.ENTER_P;
  	config.toolbar = 'Basic';
  	config.toolbarCanCollapse = true;
    config.toolbar_Basic = [
      // ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink', '-', 'About']
      ['Bold','Italic','Underline','Strike'],
      ['Cut','Copy','Paste','PasteText'],
      ['Undo','Redo','-','Find','Replace'],
      ['SelectAll','RemoveFormat'],
      // ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea'],
      ['NumberedList','BulletedList'],
      ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
      ['Link','Unlink','Anchor'],
      '/',
      ['Styles','Format'],
      ['TextColor','BGColor'],
      ['Font','FontSize'],
      ['Source'],
      // ['Image','Table','HorizontalRule','SpecialChar','PageBreak'],
    ];
    var bodyWidth = document.getElementsByTagName('body')[0].offsetWidth;
    if (bodyWidth > 0 && bodyWidth < 720) {
      config.toolbarStartupExpanded = false; // 默认收起富编辑框
    }
};
