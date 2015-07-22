angular.module('mdme-admin').factory('AdminLocalService', function() {
  return {
    get: function(key) {
      return sessionStorage.getItem(key);
    },
    set: function(key, val) {
      return sessionStorage.setItem(key, val);
    },
    unset: function(key) {
      return sessionStorage.removeItem(key);
    },
    remove: function(key) {
      return sessionStorage.removeItem(key);
    }
  };
});