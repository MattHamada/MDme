app.controller('PatientsController', ['$scope', '$http', function($scope, $http) {
  $scope.patient = {};
  $scope.patient.id =0;
  var req = {
    method: 'GET',
    url: '/patients/show',
    headers: $http.defaults.headers.common
  };
  req = AuthInterceptor.request(req);
}]);