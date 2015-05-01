angular.module('mdme-admin').controller('AdminsAppointmentController', ['$scope', '$location', '$state', '$stateParams', '$http', 'AdminAuthInterceptor', 'flare', function($scope, $location, $state, $stateParams, $http, AdminAuthInterceptor, flare) {
  var apptReq = {
    method: 'GET',
    url: '/admins/' + $stateParams.adminId + '/appointments/' + $stateParams.appointmentId + '.json',
    headers: $http.defaults.headers.common
  };
  apptReq = AdminAuthInterceptor.request(apptReq);
  $http(apptReq)
    .success(function(data) {
      $scope.appointment = data.appointment;
    })
    .error(function(err) {
      console.log(err);
    })
}]);