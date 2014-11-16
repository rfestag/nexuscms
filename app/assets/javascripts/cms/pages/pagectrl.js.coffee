@PageCtrl = ($scope, $state, $stateParams, PagesSvc, SessionSvc, Alert) ->
  $scope.editorOptions = {}
  is_new = $state.is "pages.create"
  $scope.page = PagesSvc.new if is_new
  $scope.page ||= $stateParams.page || PagesSvc.get({id: $stateParams.id}, () ->
    true
  , (a) ->
    Alert.error({content: "You are not authorized to view this page"})
    $state.go "home"
  )

  $scope.save = () ->
    if is_new
      create()
    else
      update()
  create = () ->
    PagesSvc.save({page: $scope.page}, (p, headers) ->
      Alert.success  {content: "Created #{$scope.page.title}"}
      $scope.$emit('pagesUpdated')
      $state.go "pages.id", {id: p._id.$oid}
    , (response) ->
      Alert.error response.data.alert
    )
  update = () ->
    PagesSvc.update({id: $scope.page._id.$oid, page: $scope.page}, () ->
      Alert.success  {content: "Updated #{$scope.page.title}"}
      $scope.$emit('pagesUpdated')
      $state.go "pages.id", {id: $scope.page._id.$oid}
    , (response) ->
      Alert.error {content: response.data.alert}
    )
  $scope.edit = () ->
    $state.go "pages.edit", {id: $scope.page._slugs[0], page: $scope.page}
  $scope.delete = () ->
    $scope.page.$delete({id: $scope.page._id.$oid}, () ->
      Alert.success {content: "Deleted #{$scope.page.title}"}
      $scope.$emit('pagesUpdated')
      $state.go 'home'
    ,(msg) ->
      Alert.error {content: msg.data.alert}
    )
