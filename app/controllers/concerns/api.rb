module Api
  extend ActiveSupport::Concern

  def get_model_class
    self.class.to_s.gsub("Controller", "").singularize.constantize
  end
  def get_model
    self.class.to_s.gsub("Controller", "").singularize.downcase.to_sym
  end
  def index
    page = Integer(params[:page]) - 1 rescue 0
    limit = Integer(params[:limit]) rescue 10
    skip = page*limit
    query = get_model_class
    query = (params[:query])? query.where(JSON.parse(params[:query])) : query
    total = ApplicationPolicy::Scope.new(current_user, query).resolve.count
    query = get_model_class.skip(skip).limit(limit)
    @objects = ApplicationPolicy::Scope.new(current_user, query).resolve
    respond_to do |format|
      format.json { render json: {total: total, objects: @objects} }
      format.xml { render xml: {total: total, objects: @objects} }
    end
  end
  def show
    @object = get_model_class.find(params[:id])
    authorize @object
    respond_to do |format|
      format.json { render json: @object }
      format.xml { render xml: @object }
    end
  end
  def create
    uses_ancestry = (get_model_class.ancestors.select{|o| o.class == Module}).include? Mongoid::Ancestry
    children = params[get_model].delete :children
    @object = get_model_class.new(object_params)
    puts @object.inspect
    authorize @object
    respond_to do |format|
      success = @object.save
      @object = create_children(@object, children) if uses_ancestry and children and success
      if @object.errors.size == 0
        format.json { render json: @object, status: :created }
        format.xml { render xml: @object, status: :created }
      else
        format.json { render json: @object.errors, status: :unprocessable_entity }
        format.xml { render xml: @object.errors, status: :unprocessable_entity }
      end
    end
  end
  def create_children parent, children
    children.each do |c|
      new_children = c.delete :children
      child = get_model_class.new c
      child.parent = parent
      #Because this is for create, there is no need to authorize the children
      if child.save
        create_children child, new_children if new_children
      end
      child.errors.each {|k,v| parent.errors.add "/#{child.title}/#{k}",v}
    end
    parent
  end
  def update
    uses_ancestry = (get_model_class.ancestors.select{|o| o.class == Module}).include? Mongoid::Ancestry
    children = params[get_model].delete :children
    @object = get_model_class.find(params[:id])
    authorize @object
    respond_to do |format|
      @object.update_attributes(object_params)
      @object = update_children(@object, children) if @object.errors.size == 0 and uses_ancestry and children
      if @object.errors.size == 0 
        format.json { head :no_content, status: :ok }
        format.xml { head :no_content, status: :ok }
      else
        format.json { render json: @object.errors, status: :unprocessable_entity }
        format.xml { render xml: @object.errors, status: :unprocessable_entity }
      end
    end
  end
  def update_children parent, children
    children.each do |c|
      new_children = c.delete :children
      child = get_model_class.find(c['_id'])
      #Because we are updating children, we need to ensure
      #the user only updates children they are authorized to update
      authorize child
      child.parent = parent
      if child.update_attributes(object_params c)
        update_children child, new_children if new_children
      end
      child.errors.each {|k,v| parent.errors.add "/#{child.title}/#{k}", v}
    end
    parent
  end

  def destroy
    @object = get_model_class.find(params[:id])
    authorize @object
    respond_to do |format|
      if @object.destroy
        format.json { head :no_content, status: :ok }
        format.xml { head :no_content, status: :ok }
      else
        format.json { render json: @object.errors, status: :unprocessable_entity }
        format.xml { render xml: @object.errors, status: :unprocessable_entity }
      end
    end
  end
  def search
    render json: get_model_class.search(params[:query])
  end
  def acl
    policy = self.policy_class
    @object = {readers: policy.readers,
           creators: policy.updaters,
           updaters: policy.updaters,
           deleters: policy.updaters}
    respond_to do |format|
      format.json { render json: @object }
      format.xml { render xml: @object }
    end
  end
  private
  def object_params obj=nil
    object = obj || @object
    permitted = policy(object || get_model_class).permitted_attributes
    p1 = params.require(get_model).permit(*[permitted[:scalars], permitted[:arrays]].flatten)
    filtered = (permitted[:hashes].length > 0)? p1.merge(params.require(get_model => permitted[:hashes])) : p1
    puts filtered.inspect
    filtered
  end
end
