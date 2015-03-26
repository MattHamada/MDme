app.controller('PatientsController', ['$scope', '$http', 'AuthInterceptor', function($scope, $http, AuthInterceptor) {
  $scope.patient = {};
  $scope.patient.id =0;
  var req = {
    method: 'GET',
    url: '/patients/show',
    headers: $http.defaults.headers.common
  };
  req = AuthInterceptor.request(req);
}]);