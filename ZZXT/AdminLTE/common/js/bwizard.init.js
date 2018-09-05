var _Bwizard = {
	config: {
		url:''
	},
	createOne: function(_obj, _opt){
		var _wizard = {}, _this = null;
		if(_obj){
			_this = $(_obj);
		} else {
			return false;
		}
		var baseConfig = {
			cache: false,
			clickableSteps: false,
			// panelTemplate: '<div class="myPanelClass"></div>',
			activeIndexChanged: function (e, ui) {
				console.log('/////index');
				console.log(e);
				console.log(ui);
			},
			// add: function (e, ui) {
			//   console.log('/////add');
			//   console.log(e);
			//   console.log(ui);
			// },
			validating: function (e, ui) {
				console.log('/////validate');
				console.log(e);
				console.log(ui);
			},
			load: function (e, ui) {
				console.log('/////load');
				console.log(e);
				console.log(ui);
			},

		};
		_wizard.initial = function(opt){
			for (var e in opt) {
				if (opt.hasOwnProperty(e)) {
					// _opt[e]
					baseConfig[e] = opt[e];
				}
			}
			_this.bwizard(baseConfig);
		};
		_wizard.addOne = function(addBtn, _modal, saveBtn){
			//TODO 打开modal，然后写文案，然后保存
			var addDialog = function(){
				$(addBtn).on('click', function(){
					$(_modal).modal();
					return false;
				});
			}
			// addSubmit = function(){
			//   modal.on("click", saveBtn, function() {
			//     // var submitData = gridlyApply.addGridModel.addMsg;
			//     // var submitData = _formData, submitUrl = bootstrapTable.submitUrl['addSubmitUrl'];
			//     // var addVal = setMsg();
			//     return false;
			//   });
			// };
			addDialog();
			// addSubmit();
		};
		_wizard.delOne = function(delBtn, _modal, saveBtn){
			//TODO
			var delDialog = function(){
				$(delBtn).on('click', function(){
					$(_modal).modal();
					return false;
				});
			}

			delDialog();
		};
		_wizard.initial(_opt);
		return _wizard;
	},
};
