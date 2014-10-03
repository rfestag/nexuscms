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
  def self.governs klass
    @governs = klass
  end
  def self.permit_write roles, fields
    fields = (fields == :all)? @governs.fields.keys.reject {|n| n.in? FieldBlacklist} : fields
    [roles].flatten.each do |role|
      @acl[role] += fields
    end
  end
  def self.manage_roles roles, fields=:all, &block
    read_roles roles, &block
    create_roles roles
    update_roles roles
    delete_roles roles
    permit_write roles, fields
  end
  def self.read_roles roles, &block
    roles = [roles].flatten
    @readers += roles
    ApplicationPolicy::Scope.add_scope @governs, roles, &block
  end
  def self.create_roles roles, fields= :all
    roles = [roles].flatten
    @creators += roles
    permit_write roles, fields
  end
  def self.update_roles roles, fields= :all
    roles = [roles].flatten
    @updaters += roles
    permit_write roles, fields
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
    puts "Readers: #{readers.to_a}"
    readers.reduce(allowed) do |allowed, r|
      puts "Does #{user.email} have #{r}? #{user.has_role? r}"
      allowed || user.has_role?(r)
    end unless allowed
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
    updaters.reduce(allowed) do |allowed, r|
      allowed || user.has_role?(r)
    end unless allowed
  end
  def edit?
    update?
  end
  def destroy?
    allowed = (resource.respond_to? :created_by)? (user and resource.created_by == user) : false
    deleters.reduce(allowed) do |allowed, r|
      allowed || user.has_role?(r)
    end unless allowed
  end
  def permitted_attributes
    auths = acl.reduce(Set.new) do |auths, (role, attributes)|
      auths += attributes if user.has_role? role
    end
    auths.to_a
  end

  class Scope
    attr_reader :user, :scope
    @reader_scopes = Hash.new

    def initialize(user, scope)
      @user = user
      @scope = scope
    end
    def self.add_scope klass, roles, &block
      block ||= lambda {|scope| scope.all}
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
      if user and Set.new(scopes.keys) & Set.new(user.roles)
        scopes.reduce(@scope) do |scope, (role, block)|
          (user.has_role? role)? block.call(scope) : scope
        end
      elsif scopes[:guest]
        scopes[:guest].call scope
      else
        scope.none
      end
    end
  end
end
