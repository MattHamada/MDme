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

  $scope.addDelay = function(appointment) {
    var delayReq = {
      method: 'POST',
      url: '/admins/' + $scope.admin.id + '/appointments/add_delay',
      headers: $http.defaults.headers.post,
      data: {
        appointment_id: appointment.id,
        delay_time: appointment.delay.minutes,
        apply_to_all: appointment.delay.apply_all
      }
    };
    delayReq = AdminAuthInterceptor.request(delayReq);
    $http(delayReq)
      .success(function(data) {
        flare.success(data.message, 10000);
      }).error(function(err) {
        flare.error(data.message, 10000);
    });
  };
}]);