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
};