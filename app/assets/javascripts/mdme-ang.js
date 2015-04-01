var app = angular.module('mdme',[
  'templates',
  'ngRoute',
  'ngResource',
  'angular-flash.service',
  'angular-flash.flash-alert-directive',
  'ui.router',
  'ngFileUpload'

]);

app.constant('AccessLevels', {
  anon: 0,
  user: 1
});

app.config(['flashProvider', function(flashProvider) {
    flashProvider.errorClassnames.push("alert-danger");
    flashProvider.warnClassnames.push("alert-warning");
    flashProvider.infoClassnames.push("alert-info");
    flashProvider.successClassnames.push("alert-success");
  }]);

app.run(['$rootScope', '$state', 'Auth', function($rootScope, $state, Auth) {
  $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
    if (!Auth.authorize(toState.data.access)) {
      event.preventDefault();
      $state.go('anon.login');
    }
  });
}]);