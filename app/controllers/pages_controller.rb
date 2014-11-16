class PagesController < ApplicationController
  include Api

  def roots
    total = ApplicationPolicy::Scope.new(current_user, Page.roots).resolve.count
    @objects = ApplicationPolicy::Scope.new(current_user, Page.roots).resolve
    respond_to do |format|
      format.json { render json: {total: total, objects: @objects} }
      format.xml { render xml: {total: total, objects: @objects} }
    end
  end
  def children
    @object = get_model_class.find(params[:id])
    authorize @object
    depth = params[:depth] || 1
    respond_to do |format|
      format.json { render json: {total: total, objects: @object.children(to_depth: depth)} }
      format.xml { render xml: {total: total, objects: @object.children(to_depth: depth)} }
    end
  end
end
