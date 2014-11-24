@GroupCtrl = ($scope, $state, $stateParams, GroupsSvc, SessionSvc, Alert) ->
  $scope.editorOptions = {}
  is_new = $state.is "groups.create"
  $scope.group = GroupsSvc.new if is_new
  $scope.group ||= $stateParams.group || GroupsSvc.get({id: $stateParams.id}, () ->
    true
  , (a) ->
    Alert.error({content: "You are not authorized to view this group"})
    $state.go "home"
  )

  $scope.save = () ->
    if is_new
      create()
    else
      update()
  create = () ->
    GroupsSvc.save({group: $scope.group}, (g, headers) ->
      Alert.success  {content: "Created #{$scope.group.name}"}
      $scope.$emit('groupsUpdated')
      $state.go "groups.id", {id: g._id.$oid}
    , (response) ->
      Alert.error response.data.alert
    )
  update = () ->
    GroupsSvc.update({id: $scope.group._id.$oid, group: $scope.group}, () ->
      Alert.success  {content: "Updated #{$scope.group.name}"}
      $scope.$emit('groupsUpdated')
      $state.go "groups.id", {id: $scope.groups._id.$oid}
    , (response) ->
      Alert.error {content: response.data.alert}
    )
  $scope.edit = () ->
    $state.go "groups.edit", {id: $scope.groups._slugs[0], group: $scope.group}
  $scope.delete = () ->
    $scope.group.$delete({id: $scope.group._id.$oid}, () ->
      Alert.success {content: "Deleted #{$scope.group.name}"}
      $scope.$emit('groupsUpdated')
      $state.go 'home'
    ,(msg) ->
      Alert.error {content: msg.data.alert}
    )
