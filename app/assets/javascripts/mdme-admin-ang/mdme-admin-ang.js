var adminApp = angular.module('mdme-admin',[
  'templates',
  'ngRoute',
  'ngResource',
  'ui.router',
  'ngFileUpload',
  'angular-flare',
  'ui.validate',
  'uiGmapgoogle-maps'
]);

adminApp.constant('AccessLevels', {
  anon: 0,
  user: 1,
  admin: 2
});

adminApp.run(['$rootScope', '$state', 'AdminAuth', function($rootScope, $state, AdminAuth) {
  $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
    if (!AdminAuth.authorize(toState.data.access)) {
      event.preventDefault();
      $state.go('anon.login');
    }
  });
}]);

adminApp.config(['uiGmapGoogleMapApiProvider', function(uiGmapGoogleMapApiProvider) {
  uiGmapGoogleMapApiProvider.configure({
    key: 'AIzaSyCDq1TX2uqhSDpRrtcebHzuNogcPPhKT0k',
    v: '3.17',
    libraries: 'weather,geometry,visualization'
  });
}]);