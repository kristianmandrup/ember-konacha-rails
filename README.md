# Ember Konacha generators for Rails

Generators to help setup an [ember-rails](https://github.com/emberjs/ember-rails) app with [konacha](https://github.com/jfirebaugh/konacha) testing.

PS: Still young and under development... Please help improve it :)

## What?

This gem has the stated goal of making it _easy_ to setup a good testing infrastructure for testing your *Ember-Rails* apps.

An `install` generator is included for initial infrastructure setup!

Configures your Ember app with *Konacha* using a Javascript driver (poltergeist for PhantomJS by default). Adds the basic Konacha infrastructure so you can start writing tests/specs.

Can generate *Konacha* spec-skeletons for:

* models
* controllers
* views
* helpers

Please help provide more skeleton generators or improve the existing ones!!! :)

### More generators

You can find more generators/scaffolders as part of [ember-tools](https://github.com/rpflorence/ember-tools/)

[ember-i18n-rails](https://github.com/andrzejsliwa/ember-i18n-rails) or [here](https://github.com/kristianmandrup/ember-i18n-rails). Includes generators to configure and manage *i18n* with Ember and Rails.

### Other Ember-Rails tools

* [page_wrapper](https://github.com/mathieul/page_wrapper)
* [elasticsearch](https://github.com/karmi/ember-data-elasticsearch)

## Installation

Add this line to your application's Gemfile:

    gem 'ember-konacha-rails', github: 'kristianmandrup/ember-konacha-rails'

And then execute:

    $ bundle

Or install it yourself (from rubygems) as:

    $ gem install ember-konacha-rails


To see if the generators are installed:

    $ rails g

Note: or use `$ bundle exec rails g` (to execute in context of current bundled environment)

```
...

EmberKonacha:
  ember_konacha:controller_spec
  ember_konacha:helper_spec
  ember_konacha:install
  ember_konacha:model_spec
  ember_konacha:view_spec

...  
```

## Usage

Install basic Konacha infrastructure

    $ rails g ember_konacha:install

Files that should be generated

```
vendor/assets/javascripts/sinon.js

spec/javascripts/spec_helper.js.coffee
spec/javascripts/support/sinon_mvc_mocks.js.coffee
spec/javascripts/support/koncha_config.js.coffee

spec/javascripts/app/router_spec.js.coffee
spec/javascripts/app/store_spec.js.coffee
```

### Run examples 

*Clean run (default settings)*

$ rails g ember_konacha:install
     gemfile  konacha
     gemfile  poltergeist
      create  spec/javascripts/spec_helper.js.coffee
      create  spec/javascripts/support/konacha_config.js.coffee
      create  spec/javascripts/support/sinon_mvc_mocks.js
Trying to download sinon.js (http://sinonjs.org/releases/sinon-1.6.js) ...      
      vendor  assets/javascripts/sinon.js
      create  spec/javascripts/app/store_spec.js.coffee
      create  spec/javascripts/app/router_spec.js.coffee
        gsub  app/assets/javascripts/application.js.coffee
      append  app/assets/javascripts/application.js.coffee
================================================================================
Note: poltergeist requires you have installed PhantomJS headless JS driver.

via Homebrew:

brew install phantomjs

MacPorts:

sudo port install phantomjs

See https://github.com/jonleighton/poltergeist

*Install generator was run previously*

```
$ rails g ember_konacha:install
   identical  spec/javascripts/spec_helper.js.coffee
   identical  spec/javascripts/support/konacha_config.js.coffee
   identical  spec/javascripts/support/sinon_mvc_mocks.js
   identical  spec/javascripts/app/store_spec.js.coffee
   identical  spec/javascripts/app/router_spec.js.coffee
        gsub  app/assets/javascripts/application.js.coffee
      append  app/assets/javascripts/application.js.coffee
```

Now run Konacha!

    $ bundle exec rake konacha:run

To run specs in browser

    $ bundle exec rake konacha:serve
    $ open http://localhost:3500

See more run options at https://github.com/jfirebaugh/konacha

## Notice

Make sure that the following is at the end of your `application.js.coffee` file (or similar for pure javascript):

```javascript
window.App = Ember.Application.create LOG_TRANSITIONS: true

# Defer App readiness until it should be advanced for either
# testing or production.
App.deferReadiness()
```

The basic test setup/configuration can be found in `support/koncha_config.js.coffee` and `spec_helper.js.coffee` files.

The `spec_helper` initializes the app explicitly using `App.advanceReadiness()` within `Ember.run` in the `beforeEach` closure. To run your app in the browser, while also allowing for testing, you need to explicitly call `App.advanceReadiness()`, f.ex  when your DOM is ready.

```javascript
$ ->
  App.advanceReadiness()
```

If you run the `install` generator with the `--with-index` option on, it will attempt to generate a standard application layout and index view file, with this all setup for you (using slim templating language!)

### Install options

To see install options, run:

    $ rails g ember_konacha:install --help

Note: To avoid having to `bundle exec` install the gem in your current system gem repository, use `gem install ember_konacha` (when this is an official gem!).

## Guard Koncha config generator

To setup your project with Guard and execute koncha specs whenever your javascript assets change (default driver: poltergeist)

    $ rails g ember_konacha:guard

To specify a specific js driver (selenium or webkit):

    $ rails g ember_konacha:guard --driver wekbkit

### Generate Controller spec

Use the `--type` or `-t` option to specify type of controller (will try to auto-determine otherwise)

    $ rails g ember_konacha:controller_spec login -t base

`spec/javascripts/controllers/login_controller_spec.js.coffee`

    $ rails g ember_konacha:controller User --type object

`spec/javascripts/controllers/user_controller_spec.js.coffee`

    $ rails g ember_konacha:controller_spec Users -t array

`spec/javascripts/controllers/user_controller_spec.js.coffee`

    $ rails g ember_konacha:controller_spec Users

Will autodetect that users is a plural form of user and assume you have an array (resource) controller.

    $ rails g ember_konacha:helper_spec persons 

Will generate an object controller, since persons is not a valid plural form!

### Generate Model spec

    $ rails g ember_konacha:model_spec user

`spec/javascripts/models/user_spec.js.coffee`

### Generate View spec

    $ bundle exec rails g ember_konacha:view_spec NewUser

`spec/javascripts/views/new_user_view_spec.js.coffee`

### Generate Helper spec

    $ rails g ember_konacha:model_spec gravitation

`spec/javascripts/helpers/gravitation_helper_spec.js.coffee`

## Sinon notice

The install generator will attempt to download sinon.js, first via httparty and then try via curl. On any exception it will fall back to just copying _sinon-1.6.0.js_.

Read more on [http://sinonjs.org/] for mocking, stubbing and creating test spies ;)

## Contributing

Please help make it easier for developers tp get started using *Test Driven Development* (or BDD) for Ember with Rails.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
