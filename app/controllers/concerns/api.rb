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
    @objects = ApplicationPolicy::Scope.new(current_user, query).resolve.map {|o| set_file_urls!(o)}
    respond_to do |format|
      format.json { render json: {total: total, objects: @objects} }
      format.xml { render xml: {total: total, objects: @objects} }
    end
  end
  def show
    @object = get_model_class.find(params[:id])
    authorize @object
    set_file_urls!(@object)
    respond_to do |format|
      format.json { render json: @object }
      format.xml { render xml: @object }
    end
  end
  def set_file_urls! object
    return object unless (object.class.ancestors.select{|o| o.class == Module}).include? Attachable
    object.class.file_fields.reduce(object) do |obj, file|
      file = file.to_sym
      puts "looking for #{file} in #{obj.inspect}"
      url = (obj.send file).url
      if url
        versions = (obj.send file).versions
        obj[file] = versions.keys.reduce({url: url}) do |urls, v|
          urls[v] = versions[v].url
          urls
        end
      end
      obj
    end
  end
  def add_files!
    return @object unless (@object.class.ancestors.select{|o| o.class == Module}).include? Attachable
    @object.class.file_fields.reduce(@object) do |obj, file|
      if params[get_model][file]
        type, encoder, data = params[get_model][file].match(%r{^data:(.*?);(.*?),(.*)$})[1..3]
        ext = type.split("/")[1]
        s = StringIO.new Base64.decode64(data)
        s.class_eval do
          attr_accessor :content_type, :original_filename
        end
        s.content_type = type
        s.original_filename = "foo.#{ext}"
        obj.send "#{file}=".to_sym, s
      end
      obj
    end
  end
  def create
    #uses_ancestry = (get_model_class.ancestors.select{|o| o.class == Module}).include? Mongoid::Ancestry
    file = params[:file]
    @object = get_model_class.new(object_params)
    add_files!
    authorize @object
    respond_to do |format|
      @object.save
      if @object.errors.size == 0
        format.json { render json: @object, status: :created }
        format.xml { render xml: @object, status: :created }
      else
        format.json { render json: @object.errors, status: :unprocessable_entity }
        format.xml { render xml: @object.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    #uses_ancestry = (get_model_class.ancestors.select{|o| o.class == Module}).include? Mongoid::Ancestry
    @object = get_model_class.find(params[:id])
    add_files!
    authorize @object
    respond_to do |format|
      @object.update_attributes(object_params)
      if @object.errors.size == 0 
        format.json { head :no_content, status: :ok }
        format.xml { head :no_content, status: :ok }
      else
        format.json { render json: @object.errors, status: :unprocessable_entity }
        format.xml { render xml: @object.errors, status: :unprocessable_entity }
      end
    end
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
