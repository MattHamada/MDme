describe('ContactController', function() {
  var scope = null;
  var ctrl = null;
  var httpBackend = null;
  var flash = null;

  var fakeContact = {
    'client': {
      'name': 'boo radley',
      'email': 'boo@radley.com',
      'phone': '123-213-1231',
      'comment': 'hey'
    }
  };

  var setupController = function() {
    inject(function($rootScope, $controller, $httpBackend, _flash_) {
      scope = $rootScope.new();
      httpBackend = $httpBackend;
      flash = _flash_;

      var request = new RegExp("\/submit-comment");
      var results = [200, {'result': true}];

      httpBackend.expectPOST(request, fakeContact).respond(results[0], results[1]);

      ctrl = $controller('ContactController', {$scope: scope});
    });
  };
  beforeEach(module("mdme"));
  beforeEach(setupController());
  afterEach(function() {
    httpBackend.verifyNoOutstandingExpectation();
    httpBackend.verifyNoOutstandingRequest();
  });
  describe('submitting a comment', function() {
    beforeEach(setupController());
    it('resets the client object on submission', function() {
      httpBackend.flush();
      expect(scope.client).toBe(null);
      expect(flash.success).toBe("Comment submitted");
    });
  });
});
