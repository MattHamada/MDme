app.controller('PatientsDoctorController', ['$scope', '$http', '$stateParams', 'AuthInterceptor', 'LocalService', function($scope, $http, $stateParams, AuthInterceptor, LocalService) {
  $scope.doctor = {};
  var docreq = {
    method: 'GET',
    url: '/patients/' + $stateParams.patientId + '/doctors/' + $stateParams.doctorId + '.json',
    headers: $http.defaults.headers.common
  };
  docreq = AuthInterceptor.request(docreq);

  $http(docreq)
    .success(function(data) {
      console.log(data);
      $scope.doctor = data.doctor;
    })
    .error(function(err) {
      console.log(err);
    })
}]);
