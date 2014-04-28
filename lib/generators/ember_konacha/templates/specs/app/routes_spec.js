// #= require spec_helper
// #= require router

describe("App.Router", function() {
  return it("is an Ember.Router", function() {
    assert.ok(App.Router);
    return assert.ok(Ember.Router.detect(App.Router));
  });
});