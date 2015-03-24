angular.module('mdme').controller('ContactController', ['$scope', '$http', 'flash', function($scope, $http, flash) {
  $scope.client = {};
  $scope.sendComment = function() {
    $http({
      method: 'POST',
      data: {client: $scope.client},
      url: '/submit-comment.json'
    }).success(function(data, status, headers) {
      if (data.status) {
        $scope.client = {};
        flash.success = "Comments submitted";
      }
      else {
        flash.error = data.message;
      }
    }).error(function(data, status, headers) {
      flash.error = "Connection error";
    });
  };
}]);
