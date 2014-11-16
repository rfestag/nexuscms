@AdminUsersCtrl = ($scope, UsersSvc, SessionSvc, Alert) ->
  $scope.total = 0
  $scope.page = 1
  $scope.pageSize = 5
  $scope.maxSize = 5;
  $scope.getPage = (page) ->
    $scope.users = UsersSvc.query({page: page, per: $scope.pageSize}, () ->
      $scope.total = UsersSvc.total()
    )
  $scope.users = $scope.getPage(1)

  $scope.roles = {admin: 'Admin', order_admin: 'Order Admin', content_admin: 'Content Admin', order_submitter: 'Order Submitter', user: 'User'}
  $scope.showUserRoles = (user) ->
    roles = user.roles.map (role) ->
      $scope.roles[role]
    roles.join ', '
  $scope.addUser = () ->
    $scope.newUser = {
      name: '',
      email: '',
      password: '',
      password_confirmation: ''
    }
  $scope.createUser = () ->
    SessionSvc.register($scope.newUser).then(() ->
      $scope.cancelNewUser()
      $scope.users = $scope.getPage(UsersSvc.currentPage())
    ,() ->
      Alert.error {content: 'Failed to create user'}
      return "Fail"
    )
  $scope.cancelNewUser = () ->
    $scope.newUser = null
  $scope.saveUser = (user, data) ->
    UsersSvc.update({user: data, id: user._id['$oid']}, (value, headers) ->
      Alert.success {content: 'Successfully updated user'}
    ,(response) ->
      Alert.error {content: 'Failed to update user'}
      alert("Update failed")
      return "Fail"
    )
  $scope.removeUser = (user) ->
    user.$delete({id:  user._id['$oid']}, () ->
      Alert.success {content: 'Successfully deleted user'}
      $scope.users = $scope.getPage(UsersSvc.currentPage())
    ,() ->
      Alert.error {content: 'Failed to delete user'}
    )
