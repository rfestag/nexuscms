class ApplicationPolicy
  FieldBlacklist = %W(_id created_at created_by)
  attr_accessor :user, :resource
  @readers = Set.new
  @creators = Set.new
  @updaters = Set.new
  @deleters = Set.new
  @acl = Hash.new { Set.new }

  #Accessor Methods
  def self.readers
    @readers
  end
  def self.creators
    @creators
  end
  def self.updaters
    @updaters
  end
  def self.deleters
    @deleters
  end
  def self.acl
    @acl
  end
  def readers
    self.class.readers
  end
  def creators
    self.class.creators
  end
  def updaters
    self.class.updaters
  end
  def deleters
    self.class.deleters
  end
  def acl
    self.class.acl
  end

  #Methods used by extending class
  def self.governs klass=nil
    (klass)? (@governs = klass) : @governs
  end
  def governs
    self.class.governs
  end
  def self.permit_write roles, *fields
    fields = @governs.fields.keys if fields.length == 0
    fields = fields.reject {|n| (n.keys.first rescue n).in? FieldBlacklist}
    [roles].flatten.each do |role|
      @acl[role] += fields
    end
  end
  def self.manage_roles roles, *fields, &block
    block ||= lambda {|scope, user| scope.all}
    read_roles roles, &block
    create_roles roles, *fields
    update_roles roles, *fields
    delete_roles roles
  end
  def self.read_roles roles, &block
    roles = [roles].flatten
    @readers += roles
    ApplicationPolicy::Scope.add_scope @governs, roles, &block
  end
  def self.create_roles roles, *fields
    roles = [roles].flatten
    @creators += roles
    permit_write roles, *fields
  end
  def self.update_roles roles, *fields
    roles = [roles].flatten
    @updaters += roles
    permit_write roles, *fields
  end
  def self.delete_roles roles
    roles = [roles].flatten
    @deleters += roles
  end

  def initialize(user, record)
    @user = user
    @record = record
  end
  def show?
    allowed = readers.include? :guest
    allowed ||= (resource.respond_to? :created_by)? (user and resource.created_by == user) : false
    allowed ||= readers.reduce(allowed) do |allowed, r|
      allowed || user.has_role?(r)
    end
  end
  def create?
    creators.reduce(false) do |allowed, r|
      allowed || user.has_role?(r)
    end
  end
  def new?
    create?
  end
  def update?
    allowed = (resource.respond_to? :created_by)? (user and resource.created_by == user) : false
    allowed ||= updaters.reduce(allowed) do |allowed, r|
      allowed || user.has_role?(r)
    end
  end
  def edit?
    update?
  end
  def destroy?
    allowed = (resource.respond_to? :created_by)? (user and resource.created_by == user) : false
    allowed ||= deleters.reduce(allowed) do |allowed, r|
      allowed || user.has_role?(r)
    end
  end
  def permitted_attributes
    auths = acl.reduce(Set.new) do |auths, (role, attributes)|
      auths += attributes if user.has_role? role
      auths
    end
    auths.reduce({scalars: [], arrays: {}, hashes: []}) do |auths, attribute|
      type = (attribute.is_a? Hash)? attribute.values.first.class : attribute.class
      #puts "Looking for #{attribute} (#{attribute.class}) in #{governs.fields.keys} (#{governs.fields.keys.first.class})"
      #case governs.fields[attribute].options[:type]
      case type
      when Array
        auths[:arrays][attribute] = []
      when Hash
        auths[:hashes] << attribute
      else
        auths[:scalars] << attribute
      end
      auths
    end
  end

  class Scope
    attr_reader :user, :scope
    @reader_scopes = Hash.new

    def initialize(user, scope)
      @user = user
      @scope = scope
    end
    def self.add_scope klass, roles, &block
      #block ||= lambda {|scope, user| scope.all}
      @reader_scopes = roles.reduce(@reader_scopes) do |reader_scopes, role|
         reader_scopes[role] = block
         reader_scopes
      end
    end
    def self.scopes
      @reader_scopes
    end
    def scopes
      self.class.scopes
    end
    def resolve
      scope = nil
      if user and Set.new(scopes.keys) & Set.new(user.roles)
        valid = false
        scope = scopes.reduce(@scope) do |scope, (role, block)|
          if user.has_role?(role) and block
            valid = true
            scope = block.call(scope, user)
          end
          scope
        end
        scope = nil unless valid
      elsif scopes[:guest]
        scope = scopes[:guest].call @scope
      end
      (scope)? scope : @scope.none
    end
  end
end
