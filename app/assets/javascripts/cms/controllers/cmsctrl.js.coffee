@CmsCtrl = ($scope, $modal, $state, SessionSvc, PagesSvc, NewsSvc) ->
  $scope.user = null
  $scope.page_management_enabled = false
  $scope.root_pages = []
  $scope.get_roots = () ->
    $scope.root_pages = PagesSvc.roots()
  $scope.get_news = () ->
    $scope.news_entries = NewsSvc.query({limit: 5})
  $scope.get_roots()
  $scope.get_news()
  $scope.$on('pagesUpdated', (event, args) ->
    $scope.get_roots()
  )

  $scope.create_root = () ->
    $state.go "pages.create"
  $scope.create_news = () ->
    $state.go "news.create"

  $scope.reorder_roots = () ->
    alert "Need to re-order root pages"

  $scope.user_form =
    first_name: null
    last_name: null
    email: null
    password: null
    password_confirmation: null
  $scope.$state = $state
  login_modal = $modal({
      template: '/templates/login.html'
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

  $scope.enable_page_management = () ->
    $scope.page_management_enabled = true
  $scope.disable_page_management = () ->
    $scope.page_management_enabled = false

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
