var ENV;

mocha.ui('bdd');

mocha.globals(['Ember', 'DS', 'App', 'MD5']);

mocha.timeout(5);

chai.Assertion.includeStack = true;

ENV = {
  TESTING: true
};