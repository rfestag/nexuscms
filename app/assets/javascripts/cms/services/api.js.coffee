@app.factory "ApiFactory", ($resource) ->
  service = {}
  service.api_resource = (type, hierarchical=false, actions={}, params={}) ->
    total = 0
    page = 1
    limit = 25
    array_type_action = 
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
    default_params = { id: '@id', params: {action: 'acl'}}
    default_actions =
      acl: {method: "GET"}
      update: { method: "PUT" }
      query: array_type_action 
    if hierarchical
      hierarchical_actions =
        roots: array_type_action
        children: array_type_action
      default_actions = angular.extend(default_actions, hierarchical_actions)
    svc = $resource("/#{type}/:id/:action", angular.extend(default_params, params), angular.extend(default_actions, actions))
    svc.currentPage = () ->
      return page
    svc.total = () ->
       return total
    return svc
  return service
