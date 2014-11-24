class EventsController < ApplicationController
  #include Api
  def index
    oauth = Koala::Facebook::OAuth.new ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
    graph = Koala::Facebook::API.new oauth.get_app_access_token
    image = 'http://graph.facebook.com/YomChiTaekwondoAssociation/picture'
    events = graph.get_connections('YomChiTaekwondoAssociation', 'events').map do |e|
      e['image'] = image
      e
    end
    render json: events
  end
end
