@LoginModalCtrl = ($scope, $http, $modal, SessionSvc) ->
  $scope.login = true
  $scope.user =
    name: null
    email: null
    password: null
    password_confirmation: null

  $scope.error =
    class: null
    message: null
    errors: {}

  $scope.toggleLogin =  ->
    $scope.login = !$scope.login

  success = (data) ->
    $modal.hide(data)
   
  error = (data) ->
    $scope.error.class = "has-#{data.status}"
    $scope.error.message = data.message
    $scope.error.errors = data.errors

  $scope.login = ->
    $scope.reset_messages
    SessionSvc.login($scope.user).then(success, error)
  $scope.password_reset = ->
    $scope.reset_messages
    SessionSvc.password_reset($scope.user).then(success, error)
  $scope.register = ->
    $scope.reset_messages
    SessionSvc.register($scope.user).then(success, error)
  
  $scope.reset_messages = ->
    $scope.error.class = null
    $scope.error.message = null
    $scope.error.errors = {}

  $scope.cancel = () ->
    $modal.hide('cancel');
