@app.config(($stateProvider, $urlRouterProvider, $httpProvider) ->
  $urlRouterProvider.otherwise('/home')
  $stateProvider
    .state('home', {
      url: '/home'
      templateUrl: '/templates/home.html'
      controller: @HomeCtrl
    })  
    .state('admin', {
      url: '/admin'
      templateUrl: '/templates/admin.html'
      abstract: true
    })  
    .state('admin.settings', {
      url: '/settings'
      templateUrl: '/templates/admin_settings.html'
      controller: @AdminSettingsCtrl
    }) 
    .state('admin.groups', {
      url: '/groups'
      templateUrl: '/templates/admin_groups.html'
      controller: @AdminGroupsCtrl
    }) 
    .state('admin.users', {
      url: '/users'
      templateUrl: '/templates/admin_users.html'
      controller: @AdminUsersCtrl
    }) 
    .state('users', {
      url: '/users'
      templateUrl: '/templates/users.html'
      abstract: true
    }) 
    .state('users.id', {
      url: '/:id'
      templateUrl: '/templates/users_id.html'
      controller: @UserCtrl
    })  
    .state('pages', {
      url: '/pages'
      templateUrl: '/templates/pages.html'
      abstract: true
    })
    .state('pages.create', {
      url: '/create'
      templateUrl: '/templates/pages_edit.html'
      controller: @PageCtrl
    })
    .state('pages.id', {
      url: '/:id'
      templateUrl: '/templates/pages_id.html'
      controller: @PageCtrl
    })
    .state('pages.edit', {
      url: '/:id/edit'
      templateUrl: '/templates/pages_edit.html'
      controller: @PageCtrl
    })
)
