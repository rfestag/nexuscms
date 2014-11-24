@NewsCtrl = ($scope, $state, $stateParams, NewsSvc, SessionSvc, Alert, FileUploader) ->
  $scope.editorOptions = {}
  csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  is_new = $state.is "news.create"
  $scope.uploader = new FileUploader()
  $scope.news = new NewsSvc if is_new
  $scope.news ||= $stateParams.news || NewsSvc.get({id: $stateParams.id}, () ->
    true
  , (a) ->
    Alert.error({content: "You are not authorized to view this news"})
    $state.go "home"
  )
  $scope.uploader.onAfterAddingFile = (item) ->
    reader = new FileReader()
    reader.onloadend = () ->
      $scope.news.image = reader.result
    reader.readAsDataURL(item._file)

  $scope.save = () ->
    if is_new
      create()
    else
      update()
  create = () ->
    NewsSvc.save({news: $scope.news}, (n, headers) ->
      Alert.success  {content: "Created #{$scope.news.title}"}
      $scope.$emit('newsUpdated')
      $state.go "news.id", {id: n._id.$oid}
    , (response) ->
      Alert.error response.data.alert
    )
  update = () ->
    NewsSvc.update({id: $scope.news._id.$oid, news: $scope.news}, () ->
      Alert.success  {content: "Updated #{$scope.news.title}"}
      $scope.$emit('newsUpdated')
      $state.go "news.id", {id: $scope.news._id.$oid}
    , (response) ->
      Alert.error {content: response.data.alert}
    )
  $scope.edit = () ->
    $state.go "news.edit", {id: $scope.news._slugs[0], news: $scope.news}
  $scope.delete = () ->
    $scope.news.$delete({id: $scope.news._id.$oid}, () ->
      Alert.success {content: "Deleted #{$scope.news.name}"}
      $scope.$emit('newsUpdated')
      $state.go 'home'
    ,(msg) ->
      Alert.error {content: msg.data.alert}
    )
