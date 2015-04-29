angular.module('mdme-admin').factory('AdminAuthInterceptor', ['$q', '$injector', function($q, $injector) {
  return {
    request: function(config) {
      var LocalService = $injector.get('AdminLocalService');
      var token;
      if (LocalService.get('admin_auth_token')) {
        token = angular.fromJson(LocalService.get('admin_auth_token')).token;
      }
      if(token) {
        config.headers.Authorization = "Bearer " + token;
      }
      return config;
    },
    responseError: function(response) {
      if (response.status == 401 || response.status == 403) {
        LocalService.unset('admin_auth_token');
        $injector.get('$state').go('anon.login');
      }
      return $q.reject(response);
    }
  };
}]);

