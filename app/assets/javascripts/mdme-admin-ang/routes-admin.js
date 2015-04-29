angular.module('mdme-admin')
  .config(['$stateProvider', '$urlRouterProvider', 'AccessLevels', function($stateProvider, $urlRouterProvider, AccessLevels) {

    $stateProvider
      .state('anon', {
        abstract: true,
        templateUrl: "admins/anon.html",
        data: {
          access: AccessLevels.anon
        }
      })
      .state('anon.signin', {
        url: '/',
        templateUrl: 'admins/signin.html',
        controller: 'AdminSessionsController'
      });

    $stateProvider
      .state('admin', {
        abstract: true,
        templateUrl: 'admins/_menu.html',
        data: {
          access: AccessLevels.admin
        }
      })
      .state('admin.home', {
        url: '/admins',
        templateUrl: 'admins/index.html',
        controller: 'AdminsController'
      });

    $urlRouterProvider.otherwise('/');
  }]);