app.controller('PatientsAppointmentController', ['$scope', '$location', '$stateParams', '$http', 'AuthInterceptor', function($scope, $location, $stateParams, $http, AuthInterceptor) {
  $scope.patient = { id: $stateParams.patientId };
  $scope.appointment = {};
  $scope.doctor = {};

  var req = {
    method: 'GET',
    url: '/patients/' + $stateParams.patientId + '/appointments/' + $stateParams.appointmentId + '.json',
    headers: $http.defaults.headers.common
  };
  req = AuthInterceptor.request(req);
  $http(req)
    .success(function(data) {
      $scope.appointment = data.appointment;
      $scope.doctor = data.doctor;
    })
    .error(function(err) {
      console.log(err);
    });
}]);
