# Routism

A minimalist and fast JavaScript router

### Install

    npm install routism

### Usage

```PogoScript
routism = require 'routism'

routes = [
  { pattern = "/",              route = 'home' }
  { pattern = "/posts",         route = 'list posts' }
  { pattern = "/posts/:id",     route = 'show post' }
  { pattern = "/stuff/:path*",  route = 'show stuff' }
]
router = routism.compile (routes)

router.recognise('/')             // { route = 'home', params = {} }
router.recognise('/posts')        // { route = 'list posts', params = {} }
router.recognise('/posts/123')    // { route = 'show post',  params = [['id', '123']] }
router.recognise('/stuff/1/2/3')  // { route = 'show stuff', params = [['path', '1/2/3']] }
```

### Builder

```PogoScript
routism = require 'routism'

routes = routism.table ()
routes.add ('/', 'home')
routes.add ('/posts', 'list posts')
routes.add ('/posts/:id', 'show post')
router = routes.compile ()

router.recognise('/')           // { route = 'home', params = [] }
router.recognise('/posts')      // { route = 'list posts', params = [] }
router.recognise('/posts/123')  // { route = 'show post', params = [['id', '123']] }
```

### Connect

See the [specs](./spec/connect_spec.pogo)

### License

BSD
