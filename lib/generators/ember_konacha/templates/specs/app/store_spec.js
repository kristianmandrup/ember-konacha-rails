#= require spec_helper
#= require store

var latestStoreRevision = 12;

describe("App.Store", function() {
  beforeEach(function() {
    return Test.store = TestUtil.lookupStore();
  });
  return it("works with latest Ember-Data revision", function() {
    return assert.equal(Test.store.get('revision'), latestStoreRevision);
  });
});