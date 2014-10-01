@app.config(($stateProvider, $urlRouterProvider, $httpProvider) ->
  $urlRouterProvider.otherwise('/home')
  $stateProvider
    .state('home', {
      url: '/home'
      templateUrl: '/assets/home.html'
      controller: @HomeCtrl
    })  
    .state('admin', {
      abstract: true
      url: '/admin'
      templateUrl: '/assets/admin.html'
    })  
    .state('admin.metrics', {
      url: '/metrics'
      templateUrl: '/assets/metrics.html'
    })  
    .state('admin.users', {
      url: '/users'
      templateUrl: '/assets/users.html'
      controller: @UserCtrl
    })  
    .state('admin.resource_types', {
      url: '/resource_typess'
      templateUrl: '/assets/resource_types.html'
      controller: @ResourceTypeCtrl
    })  
)
