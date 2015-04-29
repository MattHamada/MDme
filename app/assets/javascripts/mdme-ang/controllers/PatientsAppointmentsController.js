app.controller('PatientsAppointmentsController', ['$scope', '$location', '$stateParams', '$http', 'AuthInterceptor', function($scope, $location, $stateParams, $http, AuthInterceptor) {
  $scope.appointments = {};
  $scope.patient = { id: $stateParams.patientId };

  if ($location.path() == '/patients/' + $stateParams.patientId + '/appointments') {
    var req = {
      method: 'GET',
      url: '/patients/' + $stateParams.patientId + '/appointments.json',
      headers: $http.defaults.headers.common
    };
    req = AuthInterceptor.request(req);
    $http(req)
      .success(function(data) {
        $scope.appointments = data.appointments;
      })
      .error(function(error) {
        console.log(error);
      });
  }

  if ($location.path() == '/patients/' + $stateParams.patientId + '/appointments/requests') {
    var req = {
      method: 'GET',
      url: '/patients/' + $stateParams.patientId + '/appointments/requests.json',
      headers: $http.defaults.headers.common
    };
    req = AuthInterceptor.request(req);
    $http(req)
      .success(function(data) {
        $scope.appointments = data.appointments;
      })
      .error(function(error) {
        console.log(error);
      });
  }
}]);