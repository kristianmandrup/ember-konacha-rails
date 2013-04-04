## Ember app structure

Proposed (recommended) app structure for large Ember app.

```

  - application.js

  + app
    - _loader.js
    + authentication
      + mixins  

    + config
      + locales
      - locale.js
      - logging.js
      - display.js

    + controllers
      + _mixins
      + users
        - user_controller
        - users_controller
      - session_controller

    + helpers
    + lib  
    + mixins

    + models
      + extensions
      + mixins  
      - user.js  

    + views
      + extensions
      + mixins
      - new_user_view.js
      - user_view.js
      - users_view.js

    + routes
      + helpers
      + mixins
      + shortcuts
      - user_router.js
      - index_router.js

    + state_managers
    + templates
    - config.js
    - controllers.js
    - router.js
    - helpers.js
    - lib.js
    - mixins.js
    - models.js
    - views.js
```

## application.js

```
# application.js

#= require modernizr
#= require jquery
#= require handlebars
#= require ruby
#= require ember
#= require ember-data
#= require ember-data-validations
#= require ember-formBuilder
#= require bootstrap

#= require app/_loader_

#= require rails.validations
#= require rails.validations.ember

window.App = Ember.Application.create LOG_TRANSITIONS: true

# Defer App readiness until it should be advanced for either
# testing or production.
App.deferReadiness()

```

## app/_loader_.js

Responsible for loading all the Ember app files

```javascript
# app/_loader_.js

#= require_self

#= require_tree lib
#= require_tree mixins
#= require_tree helpers
#= require_tree config

#= require store
#= require models
#= require controllers
#= require views
#= require templates

#= require state_managers
#= require authentication
#= require router

```

## models.js

Index files such as 'models.js' are useful in order to quickly change the load order of files or add/remove files to be included in the app ;)

You will likley have specific mixins for models, that should be loaded before the models they are mixed into - the reason for this pattern.

```javascript
# models.js
#= require_tree ./models/mixins
#= require_tree ./models
```

And so on ...

