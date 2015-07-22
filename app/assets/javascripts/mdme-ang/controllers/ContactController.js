angular.module('mdme').controller('ContactController', ['$scope', '$http', 'flare', function($scope, $http, flare) {
  $scope.client = {};
  $scope.sendComment = function() {
    $http({
      method: 'POST',
      data: {client: $scope.client},
      url: '/submit-comment.json'
    }).success(function(data, status, headers) {
      if (data.status) {
        $scope.client = {};
        flare.success("Comments submitted", 10000);
      }
      else {
        flare.error(data.message, 10000);
      }
    }).error(function(data, status, headers) {
      flare.error("Connection error", 10000);
    });
  };
}]);
