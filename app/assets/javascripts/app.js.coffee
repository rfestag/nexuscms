@app = angular.module('cms',["templates","ngResource","mgcrea.ngStrap","mgcrea.ngStrap.helpers.dimensions","mgcrea.ngStrap.tooltip","ui.router","xeditable", "checklist-model", "ng-context-menu", "ui.tree", "ngCkeditor", "ngSanitize", "angularFileUpload"])
.run((editableOptions) ->
  editableOptions.theme = 'bs3'
)
