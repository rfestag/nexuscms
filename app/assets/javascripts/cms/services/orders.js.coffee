@app.factory "OrdersSvc", (ApiFactory) ->
  new_actions = 
    accept: 
      method: "PUT", 
      params: 
        action: 'accept'
    reject: 
      method: "PUT", 
      params: 
        action: 'reject'
    ship: 
      method: "PUT"
      params: 
        action: 'ship'
    payment_received: 
      method: "PUT"
      params: 
        action: 'payment_received'
    payment_forwarded: 
      method: "PUT", 
      params: 
        action: 'payment_forwarded'
  ApiFactory.api_resource('orders', new_actions)
