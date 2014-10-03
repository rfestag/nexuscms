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
)
