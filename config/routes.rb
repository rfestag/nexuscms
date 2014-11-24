Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root to: "application#index"

  devise_for :users, controllers: {
    registrations: "users/registrations", 
    passwords: "users/passwords", 
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  #Register core API endpoints
  get 'whoami' => 'users#whoami', defaults: {format: :json}
  get 'search' => 'search#search', defaults: {format: :json}

  #Any models that are hierarchical need to have an ability to look up children
  [:pages].each do |model|
    get "#{model}/roots" => "#{model}#roots", defaults: {format: :json}
    get "#{model}/children" => "#{model}#children", defaults: {format: :json}
  end
  #Then register standard API endpoints for all models
  [:users, :products, :orders, :events, :pages, :news].each do |model|
    get "#{model}/search" => "#{model}#search", defaults: {format: :json}
    get "#{model}/acl" => "#{model}#acl", defaults: {format: :json}
    resources model, defaults: {format: :json}
  end

  #Finally, we also need to register all of the order-related actions
  [:accept, :reject, :ship, :payment_recieved, :payment_forwarded].each do |action|
    put "orders/:id/#{action}" => "orders##{action}"
  end
end
