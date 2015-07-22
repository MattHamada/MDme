angular.module('mdme-admin').controller('AdminsPatientController',
  ['$scope', '$state', '$stateParams', 'AdminAuthInterceptor', '$http', 'flare',
    function($scope, $state, $stateParams, AdminAuthInterceptor, $http, flare) {

      $scope.admin = {id: $stateParams.adminId};

      var patientReq = {
        method: 'GET',
        url: '/admins/' + $scope.admin.id + '/patients/' + $stateParams.patientId + '.json',
        headers: $http.defaults.headers.common
      };
      patientReq = AdminAuthInterceptor.request(patientReq);
      $http(patientReq)
        .success(function(data) {
          $scope.patient = data.patient;
        })
        .error(function(err) {
          console.log(err);
        });
    }]);