class OrderPolicy < ApplicationPolicy
  @readers = Set.new
  @creators = Set.new
  @updaters = Set.new
  @deleters = Set.new
  @acl = Hash.new { Set.new }

  governs Order
  manage_roles [:admin, :order_admin]
  create_roles [:order_submitter]
  read_roles [:order_submitter] {|scope, user| scope.where(created_by: user.id)}
end
