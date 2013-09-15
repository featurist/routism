# Routism

A minimalist and fast JavaScript router

### Install

    npm install routism

### Usage

    routism = require 'routism'

    routes = [
        { pattern = "/",           route = 'home' }
        { pattern = "/posts",      route = 'list posts' }
        { pattern = "/posts/:id",  route = 'show post' }
    ]
    router = routism.compile (routes)

    router.recognise('/')           // { route = 'home', params = {} }
    router.recognise('/posts')      // { route = 'list posts', params = {} }
    router.recognise('/posts/123')  // { route = 'show post', params = [['id', '123']] }

### Builder

    routism = require 'routism'

    routes = routism.table()
    routes.add '/'           'home'
    routes.add '/posts'      'list posts'
    routes.add '/posts/:id'  'show post'
    router = routes.compile ()

    router.recognise('/')           // { route = 'home', params = [] }
    router.recognise('/posts')      // { route = 'list posts', params = [] }
    router.recognise('/posts/123')  // { route = 'show post', params = [['id', '123']] }

### Connect

    routism = require 'routism'
    connect = require 'connect'

    routes = [
        { pattern = "/hello/world", route = @(req, res) @{ res.end 'hello' } }
        { pattern = "/params/:foo", route = @(req, res, next, params) @{ res.end (params.foo) } }
    ]
    app = connect()
    app.use (routism.compile (routes).connectify())
    app.listen 1337

### License

BSD