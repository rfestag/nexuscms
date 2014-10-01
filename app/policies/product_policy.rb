class ProductPolicy < ApplicationPolicy
  @readers = Set.new
  @creators = Set.new
  @updaters = Set.new
  @deleters = Set.new
  @acl = Hash.new { Set.new }

  governs Product
  manage_roles [:admin, :order_admin]
  read_roles [:order_submitter]
end
