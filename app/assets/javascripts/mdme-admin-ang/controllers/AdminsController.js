angular.module('mdme-admin').controller('AdminsController', ['$scope', '$state', '$stateParams', 'AdminAuthInterceptor', 'AdminLocalService', '$http', 'flare', function($scope, $state, $stateParams, AdminAuthInterceptor, AdminLocalService, $http, flare) {
  $scope.admin = {id: AdminLocalService.get("adminId")};

  var todaysApptsReq = {
    method: 'GET',
    url: '/admins.json',
    headers: $http.defaults.headers.common
  };
  todaysApptsReq = AdminAuthInterceptor.request(todaysApptsReq);
  $http(todaysApptsReq)
    .success(function(data) {
      $scope.appointments = data.appointments;
    })
    .error(function(err) {
      console.log(err);
    });
}]);