@ResourceTypeCtrl = ($scope, ResourceTypeSvc) ->
  $scope.propertyTypes = ["Address", "Boolean", "Content", "Date", "DateTime", "Enumeration", "Number", "String", "Time"]
  $scope.total = 0
  $scope.page = 1
  $scope.pageSize = 5
  $scope.maxSize = 5;
  $scope.getPage = (page) ->
    $scope.types = ResourceTypeSvc.query({page: page, per: $scope.pageSize}, () ->
      $scope.total = ResourceTypeSvc.total()
      $scope.types[0].active = true
    )
  $scope.types = $scope.getPage(1)

  $scope.addType = () ->
    if !$scope.newType
      $scope.newType = {
        name: 'New Type',
        commentable: false,
        properties: []
      }
  $scope.addProperty = (type) ->
    alert "Adding property to #{angular.toJson(type)}"
    type.properties ||= []
    type.properties.push {name: '', type: 'String', required: false}

  $scope.removeProperty = (type, property) ->
    i = type.properties.indexOf(property)
    type.properties.splice(i, 1)
    
  $scope.select = (type) ->
    $scope.currentType = type
  $scope.createType = () ->
    ResourceTypeSvc.save({"resource_type": $scope.newType}, (value, headers) ->
      $scope.cancelNewType()
      $scope.types = $scope.getPage(ResourceTypeSvc.currentPage())
    ,() ->
      alert("Create failed") 
      return "Fail"
    )
  $scope.cancelNewType = () ->
    $scope.newType = null
  $scope.saveType = (type, data) ->
    ResourceTypeSvc.update({resource_type: data, id: type._id}, (value, headers) ->
      alert("Update successful")
    ,(response) ->
      alert("Update failed")
      return "Fail"
    )
  $scope.removeType = (type) ->
    type.$delete({id:  type._id}, () ->
      $scope.types = $scope.getPage(ResourceTypeSvc.currentPage())
    ,() ->
      alert("Delete failed")
    )
