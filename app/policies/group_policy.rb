class GroupPolicy < ApplicationPolicy
  @readers = Set.new
  @creators = Set.new
  @updaters = Set.new
  @deleters = Set.new
  @acl = Hash.new { Set.new }

  governs Group
  manage_roles [:admin]
  read_roles [:guest, :user, :content_admin]
end
