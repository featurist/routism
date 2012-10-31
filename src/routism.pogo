exports.create router (routes, separator: '/') =
  
  router = {
    
    routes = []
    
    add (route) =
      self.routes.push(route)
      route.path elements = []
      parts = route.pattern.split (separator)
      for each @(part) in (parts)
        if (part.char at 0 == ':')
          route.path elements.push { param = part.substr 1 }
        else
          route.path elements.push { text = part }
    
    recognise (path) =
      parts = path.split (separator)
      for each @(route) in (router.routes)
        m = try routing (parts) to (route)
        if (m)
          return (m)
      
      false
  }
  
  for each @(route) in (routes)
    router.add (route)
  
  try routing (parts) to (route) =
    path = []
    params = {}
    i = 0
    for each @(element) in (route.path elements)
      if (element.param)
        path.push(params.(element.param) = parts.(i))
      else
        if ((element.text) && (element.text != parts.(i)))
          break
        else
          path.push(element.text)
  
      i = i + 1
    
    if ((i == parts.length) && (i == route.path elements.length))
      { params = params, route = route.route }
    else
      false
  
  router