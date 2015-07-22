var app = angular.module('mdme',[
  'templates',
  'ngRoute',
  'ngResource',
  'ui.router',
  'ngFileUpload',
  'angular-flare',
  'ui.validate',
  'uiGmapgoogle-maps'
]);

app.constant('AccessLevels', {
  anon: 0,
  user: 1,
  admin: 2
});

app.run(['$rootScope', '$state', 'Auth', function($rootScope, $state, Auth) {
  $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
    if (!Auth.authorize(toState.data.access)) {
      event.preventDefault();
      $state.go('anon.login');
    }
  });
}]);

app.config(['uiGmapGoogleMapApiProvider', function(uiGmapGoogleMapApiProvider) {
  uiGmapGoogleMapApiProvider.configure({
    key: 'AIzaSyCDq1TX2uqhSDpRrtcebHzuNogcPPhKT0k',
    v: '3.17',
    libraries: 'weather,geometry,visualization'
  });
}]);