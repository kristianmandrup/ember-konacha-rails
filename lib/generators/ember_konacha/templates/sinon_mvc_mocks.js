sinon.Container = function(namespace) {
  this.namespace = namespace;
  this._cache = [];
  this._mocks = [];
  this.container = namespace.__container__;
};
 
var mock = function(context, method, args) {
  var object = context[method].apply(context, args);
  return mockObject(context, object);
};
 
var mockObject = function(context, object) {
  var mock = sinon.mock(object);
  context._mocks.push(object);
  return mock;
};
 
sinon.Container.prototype = {
  model: function(type, hash) {
    var store = this.store();
 
    type = this.namespace[type];
    return store.createRecord(type, hash || {});
  },
 
  view: function(name) {
    var view = this.container.lookup('view:'+name);
    this._cache.push(view);
    return view;
  },
 
  controller: function(name, context) {
    var controller = this.container.lookup('controller:'+name);
    if (controller && context) {
      controller.set('content', context);
    }
    return controller;
  },
 
  store: function() {
    return this.container.lookup('store:main');
  },
 
  /* Mocks */
  mockModel: function() {
    return mock(this, 'model', arguments);
  },
 
  mockView: function() {
    return mock(this, 'view', arguments);
  },
 
  mockController: function() {
    return mock(this, 'controller', arguments);
  },
 
  mockStore: function() {
    return mock(this, 'store', arguments);
  },
 
  mock: function(object) {
    return mockObject(this, object);
  },
 
  restoreObject: function(object) {
    if (object && object.restore) {
      object.restore();
    }
    return null;
  },
 
  reset: function() {
    this._cache.forEach(function(instance) {
      instance.destroy();
    });
    this._cache = [];
    this._mocks.forEach(function(mock) {
      this.restoreObject(mock);
    }, this);
    this._mocks = [];
 
    this.container.reset();
  }
};
 
var push = Array.prototype.push,
    each = Array.prototype.forEach,
    _expects = sinon.mock.expects;
 
sinon.mock.expects = function expects(method, isProperty) {
  if (!isProperty) {
    return _expects.call(this, method);
  }
  if (!method) {
    throw new TypeError("method is falsy");
  }
 
  if (!this.expectations) {
    this.expectations = {};
    this.proxies = [];
  }
 
  if (!this.expectations[method]) {
    this.expectations[method] = [];
    var mockObject = this;
    var object = this.object;
    var desc = Ember.meta(object).descs[method];
 
    Ember.defineProperty(this.object, method, Ember.computed(function(key, value) {
      return mockObject.invokeMethod(method, this, arguments);
    }));
 
    var restore = function() {
      Ember.defineProperty(object, method, desc);
    };
 
    this.restores = this.restores || {};
    this.restores[method] = {restore: restore};
    push.call(this.proxies, method);
  }
 
  var expectation = sinon.expectation.create(method);
  push.call(this.expectations[method], expectation);
 
  return expectation;
};
 
sinon.mock.restore = function restore() {
  var object = this.object,
      restores = this.restores || {};
 
  if (!this.proxies) { return; }
 
  each.call(this.proxies, function(proxy) {
    proxy = restores[proxy] || object[proxy];
    if (proxy && proxy.restore) {
      proxy.restore();
    }
  });
};