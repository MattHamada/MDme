angular.module('mdme-admin').controller('AdminsAppointmentRequestsController', ['$scope', '$location', '$state', '$stateParams', '$http', 'AdminAuthInterceptor', 'flare', function($scope, $location, $state, $stateParams, $http, AdminAuthInterceptor, flare) {

  var apptsReq = {
    method: 'GET',
    url: '/admins/' + $stateParams.adminId + '/appointments/approval.json',
    headers: $http.defaults.headers.common
  };
  apptsReq = AdminAuthInterceptor.request(apptsReq);
  $http(apptsReq)
    .success(function(data) {
      $scope.appointments = data.appointments;
    })
    .error(function(err) {
      console.log(err);
    })
}]);
