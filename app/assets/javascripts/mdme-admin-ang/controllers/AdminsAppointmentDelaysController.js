angular.module('mdme-admin').controller('AdminsAppointmentDelaysController', ['$scope', '$location', '$state', '$stateParams', '$http', 'AdminAuthInterceptor', 'flare', function($scope, $location, $state, $stateParams, $http, AdminAuthInterceptor, flare) {
  $scope.admin = {id: $stateParams.adminId};

  var req = {
    method: 'GET',
    url: '/admins/' + $scope.admin.id + '/appointments/delays.json',
    headers: $http.defaults.headers.common
  };

  req = AdminAuthInterceptor.request(req);
  $http(req)
    .success(function(data) {
      console.log(data);
      $scope.doctors = data.doctors;
    }).error(function(err) {
      console.log(err);
    });
}]);