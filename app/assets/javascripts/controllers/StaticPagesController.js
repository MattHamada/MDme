angular.module('mdme').controller('StaticPagesController', ['$scope', '$location', function($scope, $location) {
  $scope.isHome = $location.url() == '/';
  $scope.message = 'boo';
}]);