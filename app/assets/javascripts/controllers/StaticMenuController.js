angular.module('mdme').controller('StaticMenuController', ['$scope', '$location', function($scope, $location) {
  $scope.currentNav = function(page) {
    var current = $location.path();
    return page === current ? 'top-links-active' : '';
  }
}]);