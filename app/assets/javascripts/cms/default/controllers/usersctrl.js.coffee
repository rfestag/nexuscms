@UserCtrl = ($scope, UserSvc, SessionSvc) ->
  $scope.total = 0
  $scope.page = 1
  $scope.pageSize = 5
  $scope.maxSize = 5;
  $scope.getPage = (page) ->
    $scope.users = UserSvc.query({page: page, per: $scope.pageSize}, () ->
      $scope.total = UserSvc.total()
    )
  $scope.users = $scope.getPage(1)

  $scope.showUserRoles = (user) ->
    selected = []
    angular.forEach user.roles, (r) ->
      selected.push(r.name)
    if selected.length then selected.join(', ') else 'None'
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
      $scope.users = $scope.getPage(UserSvc.currentPage())
    ,() ->
      alert("Create failed") 
      return "Fail"
    )
  $scope.cancelNewUser = () ->
    $scope.newUser = null
  $scope.saveUser = (user, data) ->
    UserSvc.update({user: data, id: user._id}, (value, headers) ->
      alert("Update successful")
    ,(response) ->
      alert("Update failed")
      return "Fail"
    )
  $scope.removeUser = (user) ->
    user.$delete({id:  user._id}, () ->
      $scope.users = $scope.getPage(UserSvc.currentPage())
    ,() ->
      alert("Delete failed")
    )
