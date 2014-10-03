@app = angular.module('cms',["templates","ngResource","mgcrea.ngStrap","ui.router","xeditable", "checklist-model"])
.run((editableOptions) ->
  editableOptions.theme = 'bs3'
)
