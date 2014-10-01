class EventPolicy < ApplicationPolicy
  @readers = Set.new
  @creators = Set.new
  @updaters = Set.new
  @deleters = Set.new
  @acl = Hash.new { Set.new }

  governs Event
  manage_roles [:admin]
  create_roles [:content_admin]
  read_roles [:guest, :user]
end
