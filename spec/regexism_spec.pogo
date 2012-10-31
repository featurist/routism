regexism = require('../src/regexism')

describe 'regexism'
  
  routes = [
    { pattern = "/", route = 'home' }
    { pattern = "/foo/bar", route = 'foo bar' }
    { pattern = "/foo/:id", route = 'foo by id' }
    { pattern = "/foo/:id/bar/:id", route = 'bar by id' }
  ]
  router = regexism.compile (routes)
  
  it 'concatenates route patterns into a regexp, with named groups'
    expected = r/^((\/)|(\/foo\/bar)|(\/foo\/([^\/]+))|(\/foo\/([^\/]+)\/bar\/([^\/]+)))$/
    router.regex.to string().should.equal (expected.to string())
    router.groups.should.eql [
      { route = 'home',    params = [] }
      { route = 'foo bar', params = [] }
      { route = 'foo by id',  params = ['id'] }
      { route = 'bar by id',  params = ['id', 'id'] }
    ]
  
  it 'matches /'
    router.recognise("/").should.eql { route = 'home', params = [] }
  
  it 'matches /foo/bar'
    router.recognise("/foo/bar").should.eql {
      route = 'foo bar'
      params = []
    }
    
  it 'matches /foo/:id'
    router.recognise("/foo/123").should.eql {
      route = 'foo by id'
      params = [['id', '123']]
    }
  
  it 'matches /foo/:id/bar/:id'
    router.recognise("/foo/123/bar/456").should.eql {
      route = 'bar by id'
      params = [
        ['id', '123']
        ['id', '456']
      ]
    }