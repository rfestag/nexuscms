@app.factory('SessionSvc',  ($q, $http) ->
  currentUser = null
  submit = (parameters) ->
    deferred = $q.defer()
    $http(
      method: parameters.method
      url: parameters.url
      data: parameters.data
    ).success((data, status) ->
      if status is 200 or status is 201 or status is 204 
        currentUser = data if parameters.setCurrentUser
        deferred.resolve({status: 'success', message: parameters.success_message, user: data})
      else if parameters.method == "DELETE"
        currentUser = null;
      else
        if data.error
          deferred.reject({status: 'error', message: data.error})
        else
          deferred.reject({status: 'warning', message: "Success, but with an unexpected success code, potentially a server error, please report via support channels as this indicates a code defect.  Server response was: " + angular.toJson(data)})
    ).error (data, status) ->
      if status is 422 
        deferred.reject({status: 'error', message: "Some fields were invalid" ,errors: data.errors})
      else
        if data.error
          deferred.reject({status: 'error', message: data.error})
        else
          deferred.reject({status: 'error', message: "Unexplained error, potentially a server error, please report via support channels as this indicates a code defect.  Server response was: " + angular.toJson(data)})
    return deferred.promise

  return {
    getCurrentUser: ()->
      return currentUser
    whoami: () ->
      submit
        method: "GET"
        url: "../whoami"
        success_message: "You are logged in"
        setCurrentUser: true
    login: (user) ->
      promise = submit
        method: "POST"
        url: "../users/sign_in.json"
        data:
          user:
            email: user.email
            password: user.password
        success_message: "You have been logged in."
        setCurrentUser: true
      return promise

    logout: ->
      submit
        method: "DELETE"
        url: "../users/sign_out.json"
        success_message: "You have been logged out."
        setCurrentUser: false

    password_reset: (user) ->
      submit
        method: "POST"
        url: "../users/password.json"
        data:
          user:
            email: user.email
        success_message: "Reset instructions have been sent to your e-mail address."
        setCurrentUser: false

    register: (user)->
      submit
        method: "POST"
        url: "../users.json"
        data:
          user:
            first_name: user.first_name
            last_name: user.last_name
            email: user.email
            password: user.password
            password_confirmation: user.password_confirmation
        success_message: "You have been registered and logged in.  A confirmation e-mail has been sent to your e-mail address, your access will terminate in 2 days if you do not use the link in that e-mail."
        setCurrentUser: false


    change_password: (user) ->
      submit
        method: "PUT"
        url: "../users/password.json"
        data:
          user:
            email: user.email
            password: user.password
            password_confirmation: user.password_confirmation
        success_message: "Your password has been updated."
        setCurrentUser: false
  }
)
