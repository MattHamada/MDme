app = angular.module('mdme',[
  'templates',
  'ngRoute',
  'ngResource',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'
]);

app.config(['$routeProvider', 'flashProvider', function($routeProvider, flashProvider) {
  flashProvider.errorClassnames.push("alert-danger");
  flashProvider.warnClassnames.push("alert-warning");
  flashProvider.infoClassnames.push("alert-info");
  flashProvider.successClassnames.push("alert-success");
  $routeProvider
    .when('/', {
      controller: 'StaticPagesController',
      templateUrl: 'static_pages/index.html'
    })
    .when('/about', {
      controller: 'StaticPagesController',
      templateUrl: 'static_pages/about.html'
    })
    .when('/contact', {
      controller: 'ContactController',
      templateUrl: 'static_pages/contact.html'
    })
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