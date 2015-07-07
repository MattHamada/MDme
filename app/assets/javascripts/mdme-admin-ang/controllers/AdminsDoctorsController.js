angular.module('mdme-admin').controller('AdminsDoctorsController',
  ['$scope', '$state', '$stateParams', 'AdminAuthInterceptor', '$http', 'flare', 'SplitArrayService',
  function($scope, $state, $stateParams, AdminAuthInterceptor, $http, flare, SplitArrayService) {

    $scope.admin = {id: $stateParams.adminId};
    var req = {
      method: 'GET',
      url: '/admins/' + $scope.admin.id + '/doctors.json',
      headers: $http.defaults.headers.common
    };
    req = AdminAuthInterceptor.request(req);

    $http(req)
      .success(function(data) {
        $scope.doctors = data.doctors;
        $scope.docRows = SplitArrayService.SplitArray($scope.doctors, 6);
      })
      .error(function(err) {
        console.log(err);
      })

}]);