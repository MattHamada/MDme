app.controller('PatientsAppointmentController', ['$scope', '$location', '$state', '$stateParams', '$http', 'AuthInterceptor', 'flare', function($scope, $location, $state, $stateParams, $http, AuthInterceptor, flare) {
  $scope.patient = { id: $stateParams.patientId };
  $scope.appointment = {};
  $scope.doctor = {};
  $scope.clinics = {};
  $scope.doctors = {};

  if ($state.current.name == 'user.appointment') {
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
  }

  if ($state.current.name == 'user.newAppointment') {
    var reqClinics = {
      method: 'GET',
      url: '/patients/' + $stateParams.patientId + '/clinics.json',
      headers: $http.defaults.headers.common
    };
    reqClinics = AuthInterceptor.request(reqClinics);
    $http(reqClinics)
      .success(function(data) {
        $scope.clinics = data.clinics;
        console.log($scope.clinics);
      })
      .error(function(err) {
        console.log(err);
      });
  }

  $scope.cancel = function() {
    var check = confirm('Are you sure you want to delete this appointment?');
    if (check == true) {
      var req = {
        method: 'delete',
        url: '/patients/' + $stateParams.patientId + '/appointments/' + $stateParams.appointmentId + '.json',
        headers: $http.defaults.headers.common
      };
      req = AuthInterceptor.request(req);
      $http(req)
        .success(function(data) {
          flare.success(data.status, 10000);
          $state.go('user.appointments', {patientId: $scope.patient.id});
        })
        .error(function(error) {
          console.log(error);
          flare.error('Error processing request, please try again', 10000);
          $state.go('user.appointments', {patientId: $scope.patient.id});
        });
    }
  };
}]);