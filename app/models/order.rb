class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::Userstamp
  include Workflow

  track_history track_create: true, track_destroy: true

  field :order, type: Array
  field :notes, type: Array
  field :total_price, type: Float
  field :mail_address, type: String
  field :workflow_state, type: String
  #TODO: Support attachments for mail receipt and scanned check

  workflow do
    state :submitted do
      event :accept, transitions_to: :accepted
      event :reject, transitions_to: :rejected
    end
    state :accepted do
      event :send, transitions_to: :sent
    end
    state :sent do
      event :payment_recieved, transitions_to: :paid
    end
    state :paid do
      event :payment_forwarded, transitions_to: :complete
    end
    state :complete
    state :rejected
  end
  def submitted
    #TODO: Send e-mail verifying request was received, notify merchandise director
  end
  def accepted
    #TODO: Send e-mail containing final invoice to recipient
  end
  def sent
    #TODO: Send e-mail notifying recipient of sent package
  end
  def complete
    #TODO: Send e-mail notifying recipient that payment has been received
  end
  def rejected
    #TODO: Send e-mail notifying recipient that the request was rejected
  end
  def load_workflow_state
    self.workflow_state
  end

  def persist_workflow_state(new_value)
    self.workflow_state = new_value
    save!
  end
end
