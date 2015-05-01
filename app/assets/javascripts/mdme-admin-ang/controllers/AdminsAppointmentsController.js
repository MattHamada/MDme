angular.module('mdme-admin').controller('AdminsAppointmentsController',
  ['$scope', '$state', '$stateParams', 'AdminAuthInterceptor', '$http', 'flare',
  function($scope, $state, $stateParams, AdminAuthInterceptor, $http, flare) {

    $scope.admin = {id: $stateParams.adminId};

    if ($state.current.name == 'admin.appointments') {
    var todaysApptsReq = {
      method: 'GET',
      url: '/admins.json',
      headers: $http.defaults.headers.common
    };
    todaysApptsReq = AdminAuthInterceptor.request(todaysApptsReq);
    $http(todaysApptsReq)
      .success(function(data) {
        $scope.appointments = data.appointments;
      })
      .error(function(err) {
        console.log(err);
      });
  }

}]);