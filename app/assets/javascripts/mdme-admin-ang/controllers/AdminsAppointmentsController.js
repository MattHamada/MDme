angular.module('mdme-admin').controller('AdminsAppointmentsController',
  ['$scope', '$state', '$stateParams', 'AdminAuthInterceptor', '$http', 'flare',
  function($scope, $state, $stateParams, AdminAuthInterceptor, $http, flare) {

    $scope.dateChosen = false;
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

    $scope.browseAppts = function() {
      var browseApptsReq = {
        method: 'GET',
        url: '/admins/' + $scope.admin.id + '/appointments/browse.json',
        params: {date: $scope.appointments.date},
        headers: $http.defaults.headers.common
      };
      browseApptsReq = AdminAuthInterceptor.request(browseApptsReq);
      $http(browseApptsReq)
        .success(function(data) {
          console.log(data);
          $scope.dateChosen = true;
          $scope.appointments = data.appointments;
        }).error(function(err) {
          console.log(err);
        });
    };

}]);