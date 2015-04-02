var app = angular.module('mdme',[
  'templates',
  'ngRoute',
  'ngResource',
  'ui.router',
  'ngFileUpload',
  'angular-flare'
]);

app.constant('AccessLevels', {
  anon: 0,
  user: 1
});

app.run(['$rootScope', '$state', 'Auth', function($rootScope, $state, Auth) {
  $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
    if (!Auth.authorize(toState.data.access)) {
      event.preventDefault();
      $state.go('anon.login');
    }
  });
}]);