@app.factory "UserSvc", ($resource) ->
  total = 0
  page = 1
  limit = 25
  svc = $resource('/users/:id.json',
    { id: '@id' },
    {
        update: { method: "PUT" }
        query:  { 
                  method: "GET"
                  isArray: true
                  transformResponse: (data, headers) ->
                    d = angular.fromJson(data)
                    total = d.total
                    return d.objects
                  transformRequest: (data, headers) ->
                    d = angular.extend({page: page, limit: limit}, data)
                    page = d.page
                    return d
                }
    }
  )
  svc.currentPage = () ->
    return page
  svc.total = () ->
    return total
  return svc
