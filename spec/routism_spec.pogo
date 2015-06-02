routism = require '../src/routism'

create router (route table) =
  routism.compile (route table)

describe 'routism'

  (router) should recognise (path) as (expected) =
    match = router.recognise(path)
    match.should.not.eql(false, "path '#(path)' was unrecognised")
    match.route.should.eql(expected.route)
    match.params.should.eql(expected.params)

  (router) should not recognise (path) =
    router.recognise(path).should.be.false

  it 'concatenates route patterns into a regexp with named groups'
    router = create router [
      { pattern = "/", route = 'home' }
      { pattern = "/foo/bar", route = 'foo bar' }
      { pattern = "/foo/:id", route = 'foo by id' }
      { pattern = "/foo/:id/bar/:id", route = 'bar by id' }
    ]
    expected = r/^((\/)|(\/foo\/bar)|(\/foo\/([^\/]+))|(\/foo\/([^\/]+)\/bar\/([^\/]+)))$/
    router.regex.to string().should.equal (expected.to string())
    router.groups.should.eql [
      { route = 'home',    params = [] }
      { route = 'foo bar',   params = [] }
      { route = 'foo by id',   params = ['id'] }
      { route = 'bar by id',   params = ['id', 'id'] }
    ]

  it 'recognises /'
    router = create router [ { route = "home", pattern = "/" } ]
    (router) should recognise '/' as {
      route = 'home'
      params = []
    }

  it 'recognises /widgets/:widgetId'
    router = create router [ { route = "widget", pattern = "/widgets/:widgetId" } ]
    (router) should recognise '/widgets/123' as {
      route = 'widget'
      params = [['widgetId', '123']]
    }

  it 'recognises /events/:year/:month/:day'
    router = create router [ { route = "day", pattern = "/events/:year/:month/:day" } ]
    (router) should recognise '/events/2012/12/25' as {
      route = 'day'
      params = [['year', '2012'], ['month', '12'], ['day', '25']]
    }

  it 'recognises the first matching route'
    router = create router [
      { route = "foo", pattern = "/route/:x" }
      { route = "bar", pattern = "/route/:y" }
    ]
    (router) should recognise '/route/66' as {
      route = 'foo'
      params = [['x', '66']]
    }

  it 'recognises different routes'
    router = create router [
      { route = "foo", pattern = "/foo" }
      { route = "bar", pattern = "/bar" }
    ]
    (router) should recognise '/foo' as { route = 'foo', params = [] }
    (router) should recognise '/bar' as { route = 'bar', params = [] }

  it 'can create more than one router'
    foo = create router [
      { route = "foo", pattern = "/foo" }
    ]
    bar = create router [
      { route = "bar", pattern = "/bar" }
    ]
    (foo) should recognise '/foo' as { route = 'foo', params = [] }
    (bar) should recognise '/bar' as { route = 'bar', params = [] }
    (foo) should not recognise '/bar'
    (bar) should not recognise '/foo'

  it 'allows an arbitrary object to be associated with the route'
    router = create router [
      { route = { id = "foo" }, pattern = "/foo" }
      { route = { id = "bar" }, pattern = "/bar" }
    ]
    (router) should recognise '/foo' as { route = { id = "foo" }, params = [] }
    (router) should recognise '/bar' as { route = { id = "bar" }, params = [] }

  it 'decodes params'
    router = create router [ { route = "number", pattern = "/numbers/:x/:y" } ]
    (router) should recognise '/numbers/one%202%2Fthree/four%205%2Fsix' as {
      route = 'number'
      params = [['x', 'one 2/three'], ['y', 'four 5/six']]
    }

  it 'does not recognise an empty string'
    router = create router [ { route = "foo", pattern = "/foo/bar" } ]
    (router) should not recognise ''

  it 'does not recognise a path with fewer elements than the pattern'
    router = create router [ { route = "foo", pattern = "/foo/bar" } ]
    (router) should not recognise '/foo'

  it 'does not recognise a path with more elements than the pattern'
    router = create router [ { route = "foo", pattern = "/foo" } ]
    (router) should not recognise '/foo/bar'

  it 'recognises a path with slashes when the pattern ends with a *'
    router = create router [ { route = "foo", pattern = "/:splat*" } ]
    (router) should recognise '/hi/there' as { route = 'foo', params = [['splat', 'hi/there']] }

  it 'recognises a path without slashes when the pattern ends with a *'
    router = create router [ { route = "foo", pattern = "/:splat*" } ]
    (router) should recognise '/hello' as { route = 'foo', params = [['splat', 'hello']] }

  it 'recognises a normal and splat groups'
    router = create router [ { route = "foo", pattern = "/page/:id/:splat*" } ]
    (router) should recognise '/page/5/hi/there' as { route = 'foo', params = [['id', '5'], ['splat', 'hi/there']] }

  it 'returns false when no route is recognised'
    router = create router [ ]
    router.recognise('/unrecognised').should.be.false

  it 'provides an interface for building a route table'
    table = routism.table()
    table.add '/foo' 'foo'
    table.add '/bar/:baz' 'bar'
    router = table.compile()
    (router) should recognise '/foo' as { route = 'foo', params = [] }
    (router) should recognise '/bar/zz' as { route = 'bar', params = [['baz', 'zz']] }
