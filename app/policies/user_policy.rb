class UserPolicy < ApplicationPolicy
  @readers = Set.new
  @creators = Set.new
  @updaters = Set.new
  @deleters = Set.new
  @acl = Hash.new { Set.new }

  governs User
  manage_roles :admin
  read_roles [:user] {|scope| scope.find(current_user.id)}
end
