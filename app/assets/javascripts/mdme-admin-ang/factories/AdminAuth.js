angular.module('mdme-admin').factory('AdminAuth', ['$http', 'AdminLocalService', 'AccessLevels', function($http, AdminLocalService, AccessLevels) {
  return {
    authorize: function(access) {
      if (access === AccessLevels.admin) {
        return this.isAuthenticated();
      }
      else {
        return true;
      }
    },
    isAuthenticated: function() {
      return AdminLocalService.get('admin_auth_token');
    },
    login: function(credentials) {
      var login = $http.post('/sessions', credentials);
      login.success(function(result) {
        AdminLocalService.set('admin_auth_token', JSON.stringify(result.api_token));
        AdminLocalService.set('adminId', JSON.stringify(result.admin_id));
        AdminLocalService.set('clinicId', JSON.stringify(result.clinic_id));
      });
      return login;
    },
    logout: function() {
      AdminLocalService.remove('admin_auth_token');
    },
    register: function(formData) {
      AdminLocalService.remove('admin_auth_token');
      var register = $http.post('/admins', formData);
      register.success(function(result) {
        AdminLocalService.set('admin_auth_token', JSON.stringify(result.api_token));
        AdminLocalService.set('adminId', JSON.stringify(result.admin_id));
        AdminLocalService.set('clinicId', JSON.stringify(result.clinic_id));
      });
      return register;
    }
  };
}]);

