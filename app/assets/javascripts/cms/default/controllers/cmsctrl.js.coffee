@CmsCtrl = ($scope, $modal, $state, SessionSvc) ->
  $scope.user = null
  $scope.user_form =
    first_name: null
    last_name: null
    email: null
    password: null
    password_confirmation: null
  $scope.$state = $state
  login_modal = $modal({
      template: '/assets/login.html'
      show: false
      persist: true
      scope: $scope
    })

  set_user = (data) ->
    $scope.user = data.user
  success = (data) ->
    set_user(data)
    login_modal.hide()
  error = (data) ->
    $scope.error.class = "has-#{data.status}"
    $scope.error.message = data.message
    $scope.error.errors = data.errors

  $scope.user_can = (action, resource) ->
    #TODO: Know what user can and can't do
    $scope.user != null

  $scope.show_login_modal = () ->
    login_modal.show()

  $scope.logout = () ->
    SessionSvc.logout().then((data) ->
      $scope.user = null
    )
  $scope.error =
    class: null
    message: null
    errors: {}

  $scope.toggleLogin =  ->
    $scope.login = !$scope.login

  $scope.login = ->
    $scope.reset_messages
    SessionSvc.login($scope.user_form).then(success, error)
  $scope.password_reset = ->
    $scope.reset_messages
    SessionSvc.password_reset($scope.user_form).then(success, error)
  $scope.register = ->
    $scope.reset_messages
    SessionSvc.register($scope.user_form).then(success, error)

  $scope.reset_messages = ->
    $scope.error.class = null
    $scope.error.message = null
    $scope.error.errors = {}

  SessionSvc.whoami().then(set_user)
