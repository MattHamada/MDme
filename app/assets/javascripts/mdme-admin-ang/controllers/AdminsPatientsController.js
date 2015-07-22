angular.module('mdme-admin').controller('AdminsPatientsController',
  ['$scope', '$state', '$stateParams', 'AdminAuthInterceptor', '$http', 'flare', 'SplitArrayService',
    function($scope, $state, $stateParams, AdminAuthInterceptor, $http, flare, SplitArrayService) {

      $scope.admin = {id: $stateParams.adminId};
      var req = {
        method: 'GET',
        url: '/admins/' + $scope.admin.id + '/patients.json',
        headers: $http.defaults.headers.common
      };
      req = AdminAuthInterceptor.request(req);

      $http(req)
        .success(function(data) {
          $scope.patients = data.patients;
          $scope.patientRows = SplitArrayService.SplitArray($scope.patients, 4);
        })
        .error(function(err) {
          console.log(err);
        });

      $scope.loadPatient = function(patient) {
        $state.go('admin.patient', {patientId: patient.id, adminId: $scope.admin.id});
      };

    }]);