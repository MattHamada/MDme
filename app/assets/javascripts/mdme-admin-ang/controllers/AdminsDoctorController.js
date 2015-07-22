angular.module('mdme-admin').controller('AdminsDoctorController',
  ['$scope', '$state', '$stateParams', 'AdminAuthInterceptor', '$http', 'flare',
    function($scope, $state, $stateParams, AdminAuthInterceptor, $http, flare) {

      $scope.admin = {id: $stateParams.adminId};

      var docReq = {
        method: 'GET',
        url: '/admins/' + $scope.admin.id + '/doctors/' + $stateParams.doctorId + '.json',
        headers: $http.defaults.headers.common
      };
      docReq = AdminAuthInterceptor.request(docReq);
      $http(docReq)
        .success(function(data) {
          $scope.doctor = data.doctor;
        })
        .error(function(err) {
          console.log(err);
        });
    }]);