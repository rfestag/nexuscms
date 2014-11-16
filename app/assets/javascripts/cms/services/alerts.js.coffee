@app.factory 'Alert',  ($alert) ->
  default_alert = {duration: 8, disimissable: true, container: '.alerts'}
  svc = 
    success: (alert) ->
      $alert angular.extend(default_alert, {title: 'Success', type: 'success'}, alert)
    info: (alert) ->
      $alert angular.extend(default_alert, {title: 'Info', type: 'info'}, alert)
    warning: (alert) ->
      $alert angular.extend(default_alert, {title: 'Warning', type: 'warning'}, alert)
    error: (alert) ->
      $alert angular.extend(default_alert, {title: 'Error', type: 'danger'}, alert)
  return svc
