@app = angular.module('cms',["templates","mgcrea.ngStrap","ui.router","xeditable"])
.run((editableOptions) ->
  editableOptions.theme = 'bs3'
)
