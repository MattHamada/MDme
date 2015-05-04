angular.module('mdme-admin').controller('AdminsAppointmentController', ['$scope', '$location', '$state', '$stateParams', '$http', 'AdminAuthInterceptor', 'flare', function($scope, $location, $state, $stateParams, $http, AdminAuthInterceptor, flare) {
  $scope.admin = {id: $stateParams.adminId};
  $scope.appointment = {id: $stateParams.appointmentId};
  $scope.openTimes = [];

  var apptReq = {
    method: 'GET',
    url: '/admins/' + $stateParams.adminId + '/appointments/' + $stateParams.appointmentId + '.json',
    headers: $http.defaults.headers.common
  };
  apptReq = AdminAuthInterceptor.request(apptReq);
  $http(apptReq)
    .success(function(data) {
      console.log(data);
      $scope.appointment = data.appointment;
      $scope.openTimes = [$scope.appointment.time];
    })
    .error(function(err) {
      console.log(err);
    });

  if ($state.current.name == 'admin.appointmentEdit') {
    var openTimeReq = {
      method: 'GET',
      url: '/admins/' + $stateParams.adminId + '/appointments/' + $stateParams.appointmentId + '/edit.json',
      headers: $http.defaults.headers.common
    };
    openTimeReq = AdminAuthInterceptor.request(openTimeReq);
    $http(openTimeReq)
      .success(function(data) {
        console.log(data);
        $scope.openTimes = data.open_times;
        $scope.openTimes.push($scope.appointment.time);
      }).error(function(err) {
        console.log(err);
      })
  }

  $scope.editAppointment = function() {
    var updateApptReq = {
      method: 'PATCH',
      url: '/admins/' + $stateParams.adminId + '/appointments/' + $stateParams.appointmentId,
      headers: $http.defaults.headers.patch,
      data: {appointment: $scope.appointment}
    };
    updateApptReq = AdminAuthInterceptor.request(updateApptReq);
    $http(updateApptReq)
      .success(function(data) {
        flare.success(data.status, 10000);
        $state.go('admin.home')
      }).error(function(err) {
        flare.error(err.status, 10000);
      })
  }
}]);