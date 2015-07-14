angular.module('mdme-admin').controller('AdminsDoctorCreateController',
  ['$scope', '$state', '$stateParams', 'AdminAuthInterceptor', '$http', 'flare',
  function($scope, $state, $stateParams, AdminAuthInterceptor, $http, flare) {

    $scope.admin = {id: $stateParams.adminId};
    $scope.doctor = {};

    var departmentReq = {
      method: 'GET',
      url: '/admins/' + $scope.admin.id + '/departments.json',
      headers: $http.defaults.headers.common
    };
    departmentReq = AdminAuthInterceptor.request(departmentReq);
    $http(departmentReq)
      .success(function(data) {
        $scope.departments = data.departments;
      })
      .error(function(err) {
        console.log(err);
    });

    $scope.createDoctor = function() {
      var docReq = {
        method: 'POST',
        url: '/admins/' + $scope.admin.id + '/doctors',
        data: {doctor: $scope.doctor},
        headers: $http.defaults.headers.post
      };
      AdminAuthInterceptor.request(docReq);
      $http(docReq)
        .success(function(data) {
          $state.go('admin.doctors', {adminId: $scope.admin.id});
          flare.success(data.message, 10000);
        })
        .error(function(err) {
          for (var i = 0; i < err.message.length; i++){
            flare.error(err.message[i], 10000);
          }
        });
    };
}]);