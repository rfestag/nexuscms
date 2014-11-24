class NewsPolicy < ApplicationPolicy
  @readers = Set.new
  @creators = Set.new
  @updaters = Set.new
  @deleters = Set.new
  @acl = Hash.new { Set.new }

  governs News
  manage_roles [:admin, :content_admin]
  read_roles [:guest, :user]
end
