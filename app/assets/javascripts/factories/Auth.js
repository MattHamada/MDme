angular.module('mdme').factory('Auth', ['$http', 'LocalService', 'AccessLevels', function($http, LocalService, AccessLevels) {
  return {
    authorize: function(access) {
      if (access === AccessLevels.user) {
        return this.isAuthenticated();
      }
      else {
        return true;
      }
    },
    isAuthenticated: function() {
      return LocalService.get('auth_token');
    },
    login: function(credentials) {
      var login = $http.post('/sessions', credentials);
      login.success(function(result) {
        LocalService.set('auth_token', JSON.stringify(result));
      });
      return login;
    },
    logout: function() {
      LocalService.remove('auth_token');
    },
    register: function(formData) {
      LocalService.remove('auth_token');
      var register = $http.post('/patients', formData);
      register.success(function(result) {
        LocalService.set('auth_token', JSON.stringify(result));
      });
      return register;
    }
  };
}]);

