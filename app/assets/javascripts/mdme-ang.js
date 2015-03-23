var app = angular.module('mdme',[
  'templates',
  'ngRoute',
  'ngResource',
  'angular-flash.service',
  'angular-flash.flash-alert-directive',
  'ui.router'
]);

app.constant('AccessLevels', {
  anon: 0,
  user: 1
});

app.factory('LocalService', function() {
    return {
      get: function(key) {
        return localStorage.getItem(key);
      },
      set: function(key, val) {
        return localStorage.setItem(key, val);
      },
      unset: function(key) {
        return localStorage.removeItem(key);
      }
    };
  });

app.config(['$stateProvider', '$urlRouterProvider', 'flashProvider', 'AccessLevels', function($stateProvider, $urlRouterProvider, flashProvider, AccessLevels) {
  flashProvider.errorClassnames.push("alert-danger");
  flashProvider.warnClassnames.push("alert-warning");
  flashProvider.infoClassnames.push("alert-info");
  flashProvider.successClassnames.push("alert-success");

  $stateProvider
    .state('anon', {
      abstract: true,
      template: '<ui-view/>',
      data: {
        access: AccessLevels.anon
      }
    })
    .state('anon.home', {
      url: '/',
      templateUrl: 'static_pages/index.html',
      controller: 'StaticPagesController'
    })
    .state('anon.about', {
      url: '/about',
      templateUrl: 'static_pages/about.html',
      controller: 'StaticPagesController'
    })
    .state('anon.contact', {
      url: '/contact',
      templateUrl: 'static_pages/contact.html',
      controller: 'ContactController'
    })
    .state('anon.signin', {
      url: '/signin',
      templateUrl: 'static_pages/signin.html',
      controller: 'SessionsController'
    });

  $stateProvider
    .state('user', {
      abstract: true,
      template: '<ui-view/>',
      data: {
        access: AccessLevels.user
      }
    })
    .state('user.home', {
      url: '/patients',
      templateUrl: 'patients/show.html',
      controller:  'PatientsController'
    });

  $urlRouterProvider.otherwise('/');
}]);

app.run(['$rootScope', '$state', 'Auth', function($rootScope, $state, Auth) {
  $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
    if (!Auth.authorize(toState.data.access)) {
      event.preventDefault();
      $state.go('anon.login');
    }
  });
}]);

app.controller('StaticPagesController', ['$scope', '$location', function($scope, $location) {
  $scope.isHome = $location.url() == '/';
  $scope.message = 'boo';
}]);

app.controller('ContactController', ['$scope', '$http', 'flash', function($scope, $http, flash) {
  $scope.client = {};
  $scope.sendComment = function() {
    $http({
      method: 'POST',
      data: {client: $scope.client},
      url: '/submit-comment.json'
    }).success(function(data, status, headers) {
      if (data.status) {
        $scope.client = {};
        flash.success = "Comments submitted";
      }
      else {
        flash.error = data.message;
      }
    }).error(function(data, status, headers) {
      flash.error = "Connection error";
    });
  };
}]);

app.factory('AuthInterceptor', ['$q', '$injector', function($q, $injector) {
  return {
    request: function(config) {
      var LocalService = $injector.get('LocalService');
      var token;
      if (LocalService.get('auth_token')) {
        token = angular.fromJson(LocalService.get('auth_token')).token;
      }
      if(token) {
        config.headers.Authorization = "Bearer " + token;
      }
      return config;
    },
    responseError: function(response) {
      if (response.status == 401 || response.status == 403) {
        LocalService.unset('auth_token');
        $injector.get('$state').go('anon.login');
      }
      return $q.reject(response);
    }
  };
}]);

app.factory('Auth', ['$http', 'LocalService', 'AccessLevels', function($http, LocalService, AccessLevels) {
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



app.controller('SessionsController', ['$scope', '$state', 'Auth', 'flash', function($scope, $state, Auth, flash) {
  $scope.signin = function() {
    if ($scope.signinForm.$valid) {
      $scope.errors = [];
      Auth.login($scope.user).success(function(result) {
        $state.go('user.home');
      }).error(function(err) {
        $scope.user = {};
        flash.error = err.error;
      });
    }
  };
}]);

app.controller('PatientsController', ['$scope', function($scope) {

}]);