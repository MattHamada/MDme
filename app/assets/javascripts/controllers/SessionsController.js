angular.module('mdme').controller('SessionsController', ['$scope', '$state', 'Auth', 'flash', function($scope, $state, Auth, flash) {
  if (Auth.isAuthenticated()) {
    $state.go('user.home');
  }
  $scope.signin = function() {
    if ($scope.signinForm.$valid) {
      $scope.errors = [];
      Auth.login($scope.user).success(function(result) {
        $state.go('user.home');
      }).error(function(err) {
        $scope.user = {};
        flash.error = err.error;
      });
    }
  };
}]);
