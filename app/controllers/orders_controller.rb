class OrdersController < ApplicationController
  include Api
  model :order

  def accept
  end
  def reject
  end
  def ship
  end
  def payment_recieved
  end
  def payment_forwarded
  end
end
