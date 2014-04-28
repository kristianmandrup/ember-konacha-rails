App.Router.reopen({
  location: 'none'
});

window.TestUtil || (window.TestUtil = {
  fakeServer: function() {
    return sinon.fakeServer.create();
  },
  lookupStore: function() {
    return App.__container__.lookup('store:main');
  },
  lookupRouter: function() {
    return App.__container__.lookup('router:main');
  },
  appendView: function() {
    return Ember.run(function() {
      return view.append('#konacha');
    });
  }
});

window.Test || (window.Test = {});

window.T = Test;

Konacha.reset = Ember.K;

beforeEach(function(done) {
  window.server = TestUtil.fakeServer();
  Ember.testing = true;
  window.Test = {};
  return Ember.run(function() {
    App.advanceReadiness();
    return App.then(function() {
      return done();
    });
  });
});

afterEach(function() {
  Ember.run(function() {
    return App.reset();
  });
  window.Test = {};
  return window.server.restore();
});