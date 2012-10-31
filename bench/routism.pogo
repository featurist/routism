exports.create router (routes) =  
  router = require('../src/routism').compile (routes)
  
  recognise (path) =
    router.recognise (path)