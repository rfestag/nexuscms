@UserCtrl = ($scope, $stateParams, UsersSvc, SessionSvc) ->
  id = $stateParams.id || $scope.current_user.id
  $scope.user = UsersSvc.get({id: id})
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
  $scope.saveUser = (user, data) ->
    UsersSvc.update({user: data, id: user._id['$oid']}, (value, headers) ->
      alert("Update successful")
    ,(response) ->
      alert("Update failed")
      return "Fail"
    )
