@AdminPagesCtrl = ($scope, PagesSvc, SessionSvc, Alert) ->
  $scope.total = 0
  $scope.page = 1
  $scope.pageSize = 5
  $scope.maxSize = 5;
  $scope.getRoots = () ->
    $scope.pages = PagesSvc.roots()
    if $scope.pages.length == 0
      $scope.page = {title: 'Default Page', content: 'No pages have been created, this will be the first'}
      $scope.pages.push $scope.page
      $scope.create_page($scope.page)
      $scope.edit_page($scope.page)
    else
      $scope.select $scope.pages[0]
  $scope.getRoots()

  $scope.select = (page) ->
    $scope.page = page
  $scope.edit_page(page) ->
    $scope.select page
  $scope.add_page = (parent) ->
    new_page = {title: 'New Page', content:'No content added yet', is_new: false}
    if parent
      parent.children ||= []
      parent.children.push new_page
    else
      $scope.pages.push new_page
    $scope.create_page
    $scope.select(new_page)
  $scope.create_page = (page) ->
    PagesSvc.save({page: page}).then(() ->
      Alert.success {content: 'Successfully created page'}
    ,() ->
      Alert.error {content: 'Failed to create page' }
    )
  $scope.save_page = (page, data) ->
    if page.is_new
      PagesSvc.save({page: $scope.page}).then(() ->
        Alert.success {content: 'Successfully created page'}
        $scope.pages = $scope.getRoots()
      ,() ->
        Alert.error {content: 'Failed to create page' }
      )
    else
      PagesSvc.update({page: data, id: page._id['$oid']}, (value, headers) ->
        Alert.success {content: 'Successfully updated page'}
        $scope.pages = $scope.getRoots()
      ,(response) ->
        Alert.error {content: 'Failed to update page'}
      )
  $scope.delete_page = (node) ->
    p = node.$modelValue
    p.$delete({id:  p._id['$oid']}, () ->
      node.remove()
      Alert.success {content: 'Successfully deleted page'}
      $scope.pages = $scope.getRoots()
      $scope.page = $scope.pages[0] if $scope.page == p
    ,() ->
      Alert.error {content: 'Failed to delete page'}
    )

