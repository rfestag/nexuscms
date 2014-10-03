module Api
  extend ActiveSupport::Concern

  module ClassMethods
    def model model
      define_method(:get_model) {model}
    end
  end

  def get_model_class
    get_model.to_s.camelize.constantize
  end
  def index
    page = Integer(params[:page]) - 1 rescue 0
    limit = Integer(params[:limit]) rescue 10
    skip = page*limit
    query = get_model_class
    query = (params[:query])? query.where(JSON.parse(params[:query])) : query
    total = query.count
    query = get_model_class.skip(skip).limit(limit)
    puts "query: #{query}"
    @objects = ApplicationPolicy::Scope.new(current_user, query).resolve
    puts @objects.inspect
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
    @object = get_model_class.new(object_params)
    authorize @object
    respond_to do |format|
      if @object.save
        format.json { render json: @object, status: :created }
        format.xml { render xml: @object, status: :created }
      else
        format.json { render json: @object.errors, status: :unprocessable_entity }
        format.xml { render xml: @object.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @object = get_model_class.find(params[:id])
    authorize @object
    respond_to do |format|
      if @object.update_attributes(object_params)
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
  def object_params
    params.require(get_model).permit(*policy(@object || get_model_class).permitted_attributes)
  end
end
