@app.factory "UserSvc", ($resource) ->
  total = 0
  page = 1
  per = 25
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
                    return d.users
                  transformRequest: (data, headers) ->
                    d = angular.extend({page: page, per: per}, data)
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
