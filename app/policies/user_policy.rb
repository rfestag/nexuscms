class UserPolicy < ApplicationPolicy
  @readers = Set.new
  @creators = Set.new
  @updaters = Set.new
  @deleters = Set.new
  @acl = Hash.new { Set.new }

  governs User
  manage_roles :admin, :email, :first_name, :last_name, :address, :phone, :state, :roles => []
  read_roles [:user] {|scope, user| scope.where(id: user.id) }
end
