create router = require('../src/routism').create router

describe 'routism'
  
  (router) should recognise (path) as (expected) =
    match = router.recognise(path)
    match.should.not.eql(false, "path '#(path)' was unrecognised")
    match.route.should.eql(expected.route)
    match.params.should.eql(expected.params)
  
  (router) should not recognise (path) =
    router.recognise(path).should.be.false
  
  it 'recognises /'
    router = create router [ { route = "home", pattern = "/" } ]
    (router) should recognise '/' as {
      route = 'home'
      params = { }
    }
  
  it 'recognises /widgets/:id'
    router = create router [ { route = "widget", pattern = "/widgets/:id" } ]
    (router) should recognise '/widgets/123' as {
      route = 'widget'
      params = { id = '123' }
    }
    
  it 'recognises /events/:year/:month/:day'
    router = create router [ { route = "day", pattern = "/events/:year/:month/:day" } ]
    (router) should recognise '/events/2012/12/25' as {
      route = 'day'
      params = { year = '2012', month = '12', day = '25' }
    }

  it 'recognises the first matching route'
    router = create router [
      { route = "foo", pattern = "/route/:x" }
      { route = "bar", pattern = "/route/:y" }
    ]
    (router) should recognise '/route/66' as {
      route = 'foo'
      params = { x = '66' }
    }
  
  it 'recognises different routes'
    router = create router [
      { route = "foo", pattern = "/foo" }
      { route = "bar", pattern = "/bar" }
    ]
    (router) should recognise '/foo' as { route = 'foo', params = { } }
    (router) should recognise '/bar' as { route = 'bar', params = { } }
    
  it 'can create more than one router'
    foo = create router [
      { route = "foo", pattern = "/foo" }
    ]
    bar = create router [
      { route = "bar", pattern = "/bar" }
    ]
    (foo) should recognise '/foo' as { route = 'foo', params = { } }
    (bar) should recognise '/bar' as { route = 'bar', params = { } }
    (foo) should not recognise '/bar'
    (bar) should not recognise '/foo'
  
  it 'allows an arbitrary object to be associated with the route'
    router = create router [
      { route = { id = "foo" }, pattern = "/foo" }
      { route = { id = "bar" }, pattern = "/bar" }
    ]
    (router) should recognise '/foo' as { route = { id = "foo" }, params = { } }
    (router) should recognise '/bar' as { route = { id = "bar" }, params = { } }

  it 'allows new routes to be added after the router is created'
    router = create router []
    router.add { route = "foo", pattern = "/foo" }
    (router) should recognise '/foo' as { route = "foo", params = { } }

  it 'does not recognise an empty string'
    router = create router [ { route = "foo", pattern = "/foo/bar" } ]
    (router) should not recognise ''

  it 'does not recognise a path with fewer elements than the pattern'
    router = create router [ { route = "foo", pattern = "/foo/bar" } ]
    (router) should not recognise '/foo'

  it 'does not recognise a path with more elements than the pattern'
    router = create router [ { route = "foo", pattern = "/foo" } ]
    (router) should not recognise '/foo/bar'

  it 'returns false when no route is recognised'
    router = create router [ ]
    router.recognise('/unrecognised').should.be.false