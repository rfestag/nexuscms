class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include User::AuthDefinitions
  #include User::Roles

  has_many :identities

  field :email, type: String
  field :image, type: String
  field :first_name, type: String
  field :last_name, type: String
  #field :roles_mask, type: Integer
  field :roles, type: Array
  field :address, type: String
  field :phone, type: String
  field :state, type: String

  validates_presence_of :email, :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_key
    id.to_s
  end
  def has_role?(role)
    roles.include?(role.to_s)
  end
#  def as_json(opions)
#    options ||= {}
#    options = {:include => {:roles => {:only => :name}}, :except => :role_ids}.merge(options)
#    super(options)
#  end
end
