angular.module('mdme-admin').controller('AdminsAppointmentRequestsController', ['$scope', '$location', '$state', '$stateParams', '$http', 'AdminAuthInterceptor', 'flare', function($scope, $location, $state, $stateParams, $http, AdminAuthInterceptor, flare) {
  $scope.admin = {id: $stateParams.adminId};
  var popup = angular.element('<div id=\"ajaxPopupInfo\" ui-view></div>');
  var body = angular.element(document).find('body').eq(0);;
  body.append(popup);
  angular.element('div#ajaxPopupInfo').hide();

  var apptsReq = {
    method: 'GET',
    url: '/admins/' + $scope.admin.id + '/appointments/approval.json',
    headers: $http.defaults.headers.common
  };
  apptsReq = AdminAuthInterceptor.request(apptsReq);
  $http(apptsReq)
    .success(function(data) {
      $scope.appointments = data.appointments;
      $scope.dd = $scope.appointments[0].date;
    })
    .error(function(err) {
      console.log(err);
    });

  $scope.processAppt = function(appointment, confirmed) {
    var confReq = {
      method: 'POST',
      url: '/admins/' + $stateParams.adminId + '/appointments/approvedeny.json',
      data: {appointment_id: appointment.id, confirmed: confirmed},
      headers: $http.defaults.headers.post
    };
    confReq = AdminAuthInterceptor.request(confReq);
    $http(confReq)
      .success(function(data) {
        if (data.status == 'confirmed') {
          flare.success(data.message);
        } else {
          flare.warn(data.message);
        }
        angular.element('tr#appt-request-' + appointment.id).hide();
      });
  };


}]);
